import Foundation
import Combine

class TransactionViewModel: ObservableObject {
    enum TransactionFilter: String, CaseIterable {
        case today = "Today"
        case thisWeek = "This Week"
        case thisMonth = "This Month"
        case thisYear = "This Year"
    }
    
    @Published var transactions: [TransactionModel] = []
    @Published var totalIncome: Int = 0
    @Published var totalExpense: Int = 0
    @Published var totalBalance: Int = 0
    @Published var currentFilter: TransactionFilter = .today
    var dataManager: SwiftDataManager

    init(dataManager: SwiftDataManager) {
        self.dataManager = dataManager
        Task {
            await loadTransactions() // Use Task to call the function asynchronously
        }
    }
    
    @MainActor
    func loadTransactions() async {
        do {
            let allTransactions = try await dataManager.fetchAllTransactions() // Call async version
            transactions = applyFilter(transactions: allTransactions)
            calculateTotals()
        } catch {
            print("Failed to load transactions: \(error)")
        }
    }

    private func applyFilter(transactions: [TransactionModel]) -> [TransactionModel] {
        let currentDate = Date()
        let calendar = Calendar.current
        
        switch currentFilter {
        case .today:
            return transactions.filter { calendar.isDate($0.date, inSameDayAs: currentDate) }
        case .thisWeek:
            return transactions.filter { calendar.isDate($0.date, equalTo: currentDate, toGranularity: .weekOfYear) }
        case .thisMonth:
            return transactions.filter { calendar.isDate($0.date, equalTo: currentDate, toGranularity: .month) }
        case .thisYear:
            return transactions.filter { calendar.isDate($0.date, equalTo: currentDate, toGranularity: .year) }
        }
    }

    private func calculateTotals() {
        totalIncome = transactions.filter { $0.isIncome }.reduce(0) { $0 + $1.amount }
        totalExpense = transactions.filter { !$0.isIncome }.reduce(0) { $0 + $1.amount }
        totalBalance = totalIncome - totalExpense
    }
    
    func deleteTransaction(_ transaction: TransactionModel) {
        transactions.removeAll { $0.id == transaction.id }
        // Call data manager to delete the transaction from persistent storage if needed
        Task {
            do {
                try await dataManager.deleteTransaction(transaction)
            } catch {
                print("Failed to delete transaction: \(error)")
            }
        }
    }
    
    func updateFilter(_ filter: TransactionFilter) {
        currentFilter = filter
        Task {
            await loadTransactions()
        }
    }
}

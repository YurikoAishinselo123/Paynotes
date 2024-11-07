import Foundation

class AddTransactionViewModel: ObservableObject {
    private var dataManager: SwiftDataManager
    
    @Published var transactions: [TransactionModel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    @Published var title: String = ""
    @Published var amount: String = ""
    @Published var date: Date = Date()
    @Published var category: String = ""
    @Published var isIncome: Bool = true
    //    @Published var isValid: Bool = false
    
    
    init(dataManager: SwiftDataManager) {
        self.dataManager = dataManager
        loadTransactions()
    }
    
    func loadTransactions() {
        isLoading = true
        Task {
            do {
                transactions = try await dataManager.fetchAllTransactions()
                errorMessage = nil
            } catch {
                errorMessage = "Failed to load transactions: \(error.localizedDescription)"
            }
            isLoading = false
        }
    }
    
    func addTransaction() {
        guard let amountInt = Int(amount) else {
            errorMessage = "Amount must be a number"
            return
        }
        
        let newTransaction = TransactionModel(
            id: UUID(),
            title: title,
            amount: amountInt,
            date: date,
            category: category,
            isIncome: isIncome
        )
        // Reset Fields
        title = ""
        amount = ""
        date = Date()
        category = ""
        isIncome = true
        errorMessage = nil
        transactions.append(newTransaction)
        
        Task {
            do {
                try await dataManager.createTransaction(newTransaction)
            } catch {
                errorMessage = "Failed to add transaction: \(error.localizedDescription)"
            }
        }
    }
    
    
    func deleteTransaction(_ transaction: TransactionModel) {
        transactions.removeAll { $0.id == transaction.id }
        Task {
            do {
                try await dataManager.deleteTransaction(transaction)
                errorMessage = nil
            } catch {
                errorMessage = "Failed to delete transaction: \(error.localizedDescription)"
            }
        }
    }
}

import Foundation
import SwiftUI
import Combine

class StatisticViewModel: ObservableObject {
    @Published var income: Int = 0
    @Published var expense: Int = 0
    
    private var dataManager: SwiftDataManager
    
    init(dataManager: SwiftDataManager) {
        self.dataManager = dataManager
    }
    
    var total: Int {
        income + expense
    }
    
    var incomeRatio: Double {
        total > 0 ? Double(income) / Double(total) : 0
    }
    
    var expenseRatio: Double {
        total > 0 ? Double(expense) / Double(total) : 0
    }
    
    @MainActor func loadStatistics() {
        do {
            let transactions = try dataManager.fetchAllTransactions() // This is the correct method
            income = transactions.filter { $0.isIncome }.reduce(0) { $0 + $1.amount }
            expense = transactions.filter { !$0.isIncome }.reduce(0) { $0 + $1.amount }
        } catch {
            print("Failed to load statistics: \(error)")
        }
    }
}

import Foundation

class EditTransactionViewModel: ObservableObject {
    @Published var transaction: TransactionModel
    @Published var amount: String
    @Published var errorMessage: String?
    private var dataManager: SwiftDataManager

    init(transaction: TransactionModel, dataManager: SwiftDataManager) {
        self.transaction = transaction
        self.dataManager = dataManager
        self.amount = String(transaction.amount) // Initialize amount as String
    }

    func updateTransaction() {
        // Convert amount from String to Int
        guard let amountValue = Int(amount) else {
            errorMessage = "Amount must be a valid number"
            return
        }

        // Update transaction with the new amount
        transaction.amount = amountValue
        
        Task {
            do {
                try await dataManager.updateTransaction(transaction)
                print("Transaction updated successfully")
            } catch {
                print("Failed to update transaction: \(error)")
                errorMessage = "Failed to update transaction: \(error.localizedDescription)"
            }
        }
    }
}

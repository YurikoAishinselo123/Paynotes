//
//  SwiftDataManager.swift
//  Paynotes3
//
//  Created by Yuriko AIshinselo on 27/08/24.
//

import Foundation
import SwiftData

@MainActor
class SwiftDataManager {
    private var container: ModelContainer
    
    init() {
        do {
            container = try ModelContainer(for: TransactionModel.self)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }
    
    func updateContainer() {
        container = try! ModelContainer(for: TransactionModel.self)
    }
    
    // Create
    @MainActor
    func createTransaction(_ transaction: TransactionModel) throws {
        let context = container.mainContext
        context.insert(transaction)
        try context.save()
        print("Add successful")
    }
    
    // Read
    @MainActor
    func fetchAllTransactions() throws -> [TransactionModel] {
        let context = container.mainContext
        let fetchDescriptor = FetchDescriptor<TransactionModel>()
        return try context.fetch(fetchDescriptor)
    }

    
    @MainActor
    func fetchTransactionById(_ id: UUID) throws -> TransactionModel? {
        let context = container.mainContext
        let predicate = #Predicate<TransactionModel> { $0.id == id }
        let fetchDescriptor = FetchDescriptor<TransactionModel>(predicate: predicate)
        return try context.fetch(fetchDescriptor).first
    }
    
    // Update
    @MainActor
    func updateTransaction(_ transaction: TransactionModel) throws {
        let context = container.mainContext
        
        // Fetch the existing transaction by ID
        let existingTransaction = try fetchTransactionById(transaction.id)
        
        // Check if the transaction exists
        guard let existing = existingTransaction else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Transaction not found"])
        }
        
        // Update the properties of the existing transaction
        existing.title = transaction.title
        existing.amount = transaction.amount
        existing.date = transaction.date
        existing.category = transaction.category
        
        // Save changes
        try context.save()
        print("Update successful")
    }
    
    // Delete
    @MainActor
    func deleteTransaction(_ transaction: TransactionModel) throws {
        let context = container.mainContext
        context.delete(transaction)
        try context.save()
    }
    
}

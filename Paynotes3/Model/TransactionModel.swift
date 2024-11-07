import Foundation
import SwiftData

@Model
final class TransactionModel {
    var id: UUID
    var title: String
    var amount: Int
    var date: Date
    var category: String
    var isIncome: Bool
    
    init(id: UUID, title: String, amount: Int, date: Date, category: String, isIncome: Bool) {
        self.id = id
        self.title = title
        self.amount = amount
        self.date = date
        self.category = category
        self.isIncome = isIncome
    }
}

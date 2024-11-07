import SwiftUI

struct AddTransactionView: View {
    @State private var selectedSegment: Segment = .income
    @Binding var isAddingTransaction: Bool // Correctly defined Binding property

    enum Segment: String {
        case income = "Income"
        case expense = "Expense"
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("Select", selection: $selectedSegment) {
                    Text(Segment.income.rawValue).tag(Segment.income)
                    Text(Segment.expense.rawValue).tag(Segment.expense)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                

                if selectedSegment == .income {
                    IncomeView(isAddingTransaction: $isAddingTransaction)
                } else {
                    ExpenseView(isAddingTransaction: $isAddingTransaction)
                }
            }
            .navigationTitle("Add Transaction")
        }
    }
}

#Preview {
    // Sample Preview with a Binding
    AddTransactionView(isAddingTransaction: .constant(true))
}

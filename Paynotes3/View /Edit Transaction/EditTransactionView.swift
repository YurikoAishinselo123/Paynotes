import SwiftUI
import SwiftData

struct EditTransactionView: View {
    @StateObject private var viewModel: EditTransactionViewModel
    @Environment(\.dismiss) private var dismiss

    init(transaction: TransactionModel, dataManager: SwiftDataManager) {
        _viewModel = StateObject(wrappedValue: EditTransactionViewModel(transaction: transaction, dataManager: dataManager))
    }

    enum IncomeCategory: String, CaseIterable, Identifiable {
        case salary = "Salary"
        case investment = "Investment"
        case gift = "Gift"
        case other = "Other"

        var id: String { self.rawValue }
        
        var displayName: String {
            self.rawValue.capitalized
        }
    }
    
    enum ExpenseCategory: String, CaseIterable, Identifiable {
        case food = "Food"
        case hobby = "Hobby"
        case gift = "Gift"
        case education = "Education"
        case transport = "Transport"
        case health = "Health"
        case other = "Other"
        case pets = "Pets"
        
        var id: String { self.rawValue }
        
        var displayName: String {
            self.rawValue.capitalized
        }
    }

    private var isValid: Bool {
        !viewModel.transaction.title.isEmpty && !viewModel.amount.isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Transaction Details")) {
                    TextField("Title", text: $viewModel.transaction.title)

                    TextField("Amount", text: $viewModel.amount)
                        .keyboardType(.decimalPad)

                    DatePicker("Date", selection: $viewModel.transaction.date, displayedComponents: .date)
                    
                    // Category picker based on the transaction's existing type
                    if viewModel.transaction.isIncome {
                        Picker("Category", selection: $viewModel.transaction.category) {
                            ForEach(IncomeCategory.allCases) { category in
                                Text(category.displayName)
                                    .tag(category.rawValue)
                            }
                        }
                    } else {
                        Picker("Category", selection: $viewModel.transaction.category) {
                            ForEach(ExpenseCategory.allCases) { category in
                                Text(category.displayName)
                                    .tag(category.rawValue)
                            }
                        }
                    }
                }
                
                Section {
                    HStack {
                        Image(systemName: viewModel.transaction.isIncome ? "arrow.down.circle.fill" : "arrow.up.circle.fill")
                            .foregroundColor(viewModel.transaction.isIncome ? .blue : .red)
                        Text(viewModel.transaction.isIncome ? "Income" : "Expense")
                            .foregroundColor(viewModel.transaction.isIncome ? .blue : .red)
                        Spacer()
                    }
                }

                Button(action: {
                    updateTransaction()
                    dismiss()
                }) {
                    Text("Update Transaction")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isValid ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(!isValid)
            }
            .navigationTitle("Edit Transaction")
            .navigationBarItems(trailing: Button("Cancel") {
                dismiss()
            })
        }
    }

    private func updateTransaction() {
        viewModel.updateTransaction()
    }
}


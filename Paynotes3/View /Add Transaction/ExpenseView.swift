import SwiftUI

struct ExpenseView: View {
    @StateObject private var viewModel = AddTransactionViewModel(dataManager: SwiftDataManager())
    @Binding var isAddingTransaction: Bool

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
    }
    
    private var isValid: Bool {
        !viewModel.title.isEmpty && !viewModel.amount.isEmpty
    }
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Expense Details")) {
                    TextField("Title", text: $viewModel.title)
                    
                    TextField("Amount", text: $viewModel.amount)
                        .keyboardType(.numberPad)
                    
                    DatePicker("Date", selection: $viewModel.date, displayedComponents: .date)
                    
                    Picker("Category", selection: $viewModel.category) {
                        ForEach(ExpenseCategory.allCases) { category in
                            Text(category.rawValue.capitalized).tag(category.rawValue)
                        }
                    }
                }
                
                Button(action: saveTransaction) {
                    Text("Save Expense")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isValid ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(!isValid)
            }
            .navigationTitle("Add Expense") // Fixed stray slash
        }
        .onAppear {
            viewModel.isIncome = false
        }
    }
    
    private func saveTransaction() {
        viewModel.addTransaction()
        isAddingTransaction = false
    }
}

#Preview {
    ExpenseView(isAddingTransaction: .constant(true))
}

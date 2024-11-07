import SwiftUI

struct IncomeView: View {
    @StateObject private var viewModel = AddTransactionViewModel(dataManager: SwiftDataManager())
    @Binding var isAddingTransaction: Bool
    enum IncomeCategory: String, CaseIterable, Identifiable {
        case salary, investment, gift, other
        var id: String { self.rawValue }
    }
    
    private var isValid: Bool {
        !viewModel.title.isEmpty && !viewModel.amount.isEmpty
    }
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Income Details")) {
                    TextField("Title", text: $viewModel.title)
                    
                    TextField("Amount", text: $viewModel.amount)
                        .keyboardType(.numberPad)
                    
                    DatePicker("Date", selection: $viewModel.date, displayedComponents: .date)
                    
                    Picker("Category", selection: $viewModel.category) {
                        ForEach(IncomeCategory.allCases) { category in
                            Text(category.rawValue.capitalized).tag(category.rawValue)
                        }
                    }
                }
                
                Button(action: saveTransaction) {
                    Text("Save Income")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isValid ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(!isValid)
            }
        }

        .onAppear {
            viewModel.isIncome = true
        }
    }
    
    private func saveTransaction() {
        viewModel.addTransaction()
        isAddingTransaction = false
    }
}

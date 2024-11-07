import SwiftUI

struct TransactionView: View {
    @StateObject private var viewModel = TransactionViewModel(dataManager: SwiftDataManager())
    @State private var isAddingTransaction = false
    @State private var selectedTransaction: TransactionModel? = nil
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    // Filter Picker
                    Picker("Filter", selection: $viewModel.currentFilter) {
                        ForEach(TransactionViewModel.TransactionFilter.allCases, id: \.self) { filter in
                            Text(filter.rawValue).tag(filter)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    .onChange(of: viewModel.currentFilter) { _ in
                        Task {
                            await viewModel.loadTransactions() // Reload transactions when filter changes
                        }
                    }
                    
                    // Income, Expense, and Total Display
                    HStack {
                        Text("Income \n\(formattedValue(viewModel.totalIncome))")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .multilineTextAlignment(.center)
                        Spacer()
                        Text("Expense \n\(formattedValue(viewModel.totalExpense))")
                            .font(.headline)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                        Spacer()
                        Text("Total \n\(formattedValue(viewModel.totalBalance))")
                            .font(.headline)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, 30)
                    
                    // Transaction List
                    List {
                        ForEach(viewModel.transactions) { transaction in
                            TransactionRowView(transaction: transaction)
                                .onTapGesture {
                                    selectedTransaction = transaction
                                }
                                .swipeActions {
                                    Button(role: .destructive) {
                                        viewModel.deleteTransaction(transaction)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                        }
                    }
                    .frame(maxHeight: .infinity)
                    .onAppear {
                        Task {
                            await viewModel.loadTransactions()
                        }
                    }
                    
                    Spacer()
                    
                    // Add Transaction Button
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button(action: {
                                isAddingTransaction = true
                            }) {
                                Image(systemName: "plus")
                                    .foregroundColor(.white)
                                    .font(.system(size: 24, weight: .bold))
                                    .frame(width: 60, height: 60)
                                    .background(Circle().fill(Color.blue))
                                    .shadow(radius: 5)
                            }
                        }
                        .padding()
                        .padding(.bottom, 40)
                    }
                }
            }
            .navigationTitle("Transactions")
            .navigationDestination(isPresented: $isAddingTransaction) {
                AddTransactionView(isAddingTransaction: $isAddingTransaction)
            }
            .sheet(item: $selectedTransaction) { transaction in
                EditTransactionView(
                    transaction: transaction,
                    dataManager: viewModel.dataManager
                )
            }
        }
    }
    
    // Helper function to format values
    private func formattedValue(_ value: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        let formattedString = formatter.string(from: NSNumber(value: value)) ?? "\(value)"
        
        if formattedString.count > 9 {
            return String(formattedString.prefix(7)) + "..."
        }
        return formattedString
    }
}

// Helper view to display transaction row
struct TransactionRowView: View {
    let transaction: TransactionModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading){
                Text(transaction.title)
                    .foregroundColor(.white)
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding(.bottom, 2)
                Text(transaction.category)
                    .foregroundColor(.gray)
                    .font(.caption)
                Text("\(transaction.date, formatter: dateFormatter)") // Format
                    .foregroundColor(.gray)
                    .font(.caption)
            }
            Spacer()
            Text("Rp \(transaction.amount)")
                .foregroundColor(transaction.isIncome ? .blue : .red)
        }
    }
}

// Date Formatter for displaying transaction date
let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    return formatter
}()

#Preview {
    TransactionView()
        .preferredColorScheme(.dark)
}

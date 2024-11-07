import SwiftUI

struct StatisticView: View {
    @StateObject private var viewModel = StatisticViewModel(dataManager: SwiftDataManager())
    
    var body: some View {
        VStack {
            Text("Statistic")
                .font(.title)
                .padding()
            
            PieChartView(incomeRatio: viewModel.incomeRatio, expenseRatio: viewModel.expenseRatio)
                .frame(height: 200)
            
            HStack {
                VStack {
                    Text("Income")
                        .font(.headline)
                        .foregroundColor(.blue)
                    // Show message if income is zero
                    if viewModel.income > 0 {
                        Text("Rp \(viewModel.income)")
                            .font(.subheadline)
                    } else {
                        Text("Input your Income/Expense first")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                
                VStack {
                    Text("Expense")
                        .font(.headline)
                        .foregroundColor(.red)
                    // Show message if expense is zero
                    if viewModel.expense > 0 {
                        Text("Rp \(viewModel.expense)")
                            .font(.subheadline)
                    } else {
                        // Only one message for both conditions
                        Text("Input your Income/Expense first")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .padding()
            }
            .padding()
            
            Spacer()
        }
        .onAppear {
            Task {
                await viewModel.loadStatistics()
            }
        }
    }
}

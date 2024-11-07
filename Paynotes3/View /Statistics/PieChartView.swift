import SwiftUI

struct PieChartView: View {
    var incomeRatio: Double
    var expenseRatio: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if incomeRatio > 0 {
                    Circle()
                        .trim(from: 0, to: CGFloat(incomeRatio))
                        .stroke(Color.blue, lineWidth: 40)
                        .rotationEffect(.degrees(-90))
                }
                
                // Create the expense slice
                if expenseRatio > 0 {
                    Circle()
                        .trim(from: CGFloat(incomeRatio), to: CGFloat(incomeRatio + expenseRatio))
                        .stroke(Color.red, lineWidth: 40)
                        .rotationEffect(.degrees(-90)) // Start at the top
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.width)
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

#Preview {
    PieChartView(incomeRatio: 0.5, expenseRatio: 0.5)
}

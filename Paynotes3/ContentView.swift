//
//  ContentView.swift
//  Paynotes3
//
//  Created by Yuriko AIshinselo on 27/08/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            TransactionView()
                .tabItem {
                    Label("Transactions", systemImage: "list.bullet.rectangle.portrait")
                }
            
            StatisticView()
                .tabItem {
                    Label("Statistics", systemImage: "chart.bar.fill")
                }
        }
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}

//
//  TransactionFilter.swift
//  Paynotes3
//
//  Created by Yuriko AIshinselo on 02/11/24.
//

// TransactionFilter.swift
import Foundation

enum TransactionFilter: String, CaseIterable {
    case today = "Today"
    case thisWeek = "This Week"
    case thisMonth = "This Month"
    case thisYear = "This Year"
}

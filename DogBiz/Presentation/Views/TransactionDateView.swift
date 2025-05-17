//
//  TransactionDateView.swift
//  DogBiz
//
//  Created by Richard Borrero Pinargote on 16/5/25.
//

import Foundation
import SwiftUI

struct TransactionDateView: View {
    let transactionDate: Date

    var body: some View {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" // Formato con fecha y hora

        return Text(dateFormatter.string(from: transactionDate))
            .font(.headline)
    }
}

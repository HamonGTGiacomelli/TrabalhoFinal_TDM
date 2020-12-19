//
//  Util.swift
//  ProjetoFinalTDM
//
//  Created by Hamon Giacomelli on 18/12/20.
//

import Foundation

struct Util {
    func formatCurrencyDecimalToString(valor: Decimal) -> String? {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale.current
        
        return currencyFormatter.string(from: valor as NSNumber)
    }
}

//
//  HelperFunctions.swift
//  Online-Market
//
//  Created by 酒井ゆうき on 2020/01/07.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import Foundation

func convertCurrency(_ number : Double) -> String {
    
    let currncyFormatter = NumberFormatter()
    currncyFormatter.usesGroupingSeparator = true
    currncyFormatter.numberStyle = .currency
    currncyFormatter.locale = Locale.current
    
    return currncyFormatter.string(from: NSNumber(value: number))!
}

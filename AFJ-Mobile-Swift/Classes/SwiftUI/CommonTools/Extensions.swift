//
//  Extensions.swift
//  AFJ-Mobile-Swift
//
//  Created by viktyz on 2023/8/16.
//

import SwiftUI

extension Double {
    
    var celsiusFormat: String {
        Measurement(value: self, unit: UnitTemperature.celsius).formatted()
    }
}

extension View {
    
    @ViewBuilder func `if`<Content: View>(
        _ condition: Bool,
        apply transform: (Self) -> Content,
        else elseTransform: ((Self) -> Content)? = nil
    ) -> some View {
        if condition {
            transform(self)
        } else {
            if let elseTransform {
                elseTransform(self)
            } else {
                self
            }
        }
    }
}

extension Bool {
    static var iOS16_4: Bool {
        guard #available(iOS 16.4, *) else { return true }
        return false
    }
}

extension String {
    
    var localized: String {
        let res = UserDefaults.standard.string(forKey: "language")
        let path = Bundle.main.path(forResource: res, ofType: "lproj")
        let bundle: Bundle
        if let path = path {
            bundle = Bundle(path: path) ?? .main
        } else {
            bundle = .main
        }
        return NSLocalizedString(self, bundle: bundle, value: "", comment: "")
    }
}


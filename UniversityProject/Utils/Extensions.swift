//
//  Extensions.swift
//  UniversityProject
//
//  Created by Nitsan Asraf on 18/06/2022.
//


import SwiftUI

extension UIColor {
    var name: String? {
        switch self.accessibilityName {
        case "cyan blue": return "Blue"
        case "vibrant yellow": return "Yellow"
        case "black": return "Black"
        case "green": return "Green"
        case "white": return "White"
        case "red": return "Red"
        default: return nil
        }
    }
}

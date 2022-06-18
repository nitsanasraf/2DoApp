//
//  Fn.swift
//  UniversityProject
//
//  Created by Nitsan Asraf on 17/06/2022.
//

import SwiftUI

func getPriorityColor(priority:String) -> Color{
    switch priority.lowercased() {
    case "low":
        return Color.green
    case "medium":
        return Color.orange
    case "high":
        return Color.red
    default:
        return Color.orange
    }
}

func lowerAndTrim(_ str:String) -> String {
    return str.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
}


//
//  UniversityProjectApp.swift
//  UniversityProject
//
//  Created by Nitsan Asraf on 08/06/2022.
//

import SwiftUI


@main
struct UniversityProjectApp: App {

    
    @StateObject var viewModel = TodoViewModel()
    
    var body: some Scene {
        WindowGroup {
            CategoriesView()
                .environmentObject(viewModel)

        }
    }
}

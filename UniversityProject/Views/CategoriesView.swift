//
//  ContentView.swift
//  UniversityProject
//
//  Created by Nitsan Asraf on 08/06/2022.
//

import SwiftUI
import CoreData


struct CategoriesView: View {
    
    @EnvironmentObject var viewModel: TodoViewModel
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.categories) { item in
                    CategoryItem(item: item)
                }
                .onDelete(perform: viewModel.deleteCategory)
            }
            .navigationBarTitle("Categories")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                    
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddCategoryView()) {
                        Image(systemName: "plus.circle")
                            .resizable()
                            .foregroundColor(.blue)
                            .frame(width: 25, height: 25)
                    }
                    
                }
                
            }
        }.onAppear { viewModel.getCategories() }
    }
}

struct CategoryItem: View {
    let item:CategoryTodo
    var body: some View {
        NavigationLink(destination: TodosView(categoryName: item.title ?? "")) {
            Text(item.title ?? "")
                .fontWeight(.bold)
        }
        .foregroundColor(Color(UIColor(item.fgColor ?? "#fff")))
        .listRowBackground(Color(UIColor(item.bgColor ?? "#fff")))
        
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        CategoriesView()
            .environmentObject(TodoViewModel())
        
    }
}

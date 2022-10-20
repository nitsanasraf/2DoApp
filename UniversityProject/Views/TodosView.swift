//
//  TodosView.swift
//  UniversityProject
//
//  Created by Nitsan Asraf on 14/06/2022.
//

import SwiftUI

struct TodosView: View {
    @EnvironmentObject var viewModel: TodoViewModel
    
    let categoryName:String
    
    private let filters = ["Newly Created","Priority","Done","Undone"]
    
    @State private var searchQuery = ""
    @State var selectedFilter = "Newly Created"
    
    var body: some View {
        VStack {
            HStack {
                Text("Filter by")
                    .font(.system(size: 15))
                    .searchable(text: $searchQuery)
                Picker(selection: $selectedFilter,label:Text("Filters")) {
                    ForEach(filters, id: \.self) {
                        Text($0)
                    }
                }
                .onChange(of: selectedFilter) { val in
                    switch val {
                    case "Newly Created":
                        viewModel.getTodos(category: categoryName)
                    case "Priority":
                        viewModel.getTodos(category: categoryName)
                        viewModel.sortTodosByPriority()
                    case "Done":
                        viewModel.getTodos(category: categoryName)
                        viewModel.todos = viewModel.todos.filter {$0.isDone == true}
                    case "Undone":
                        viewModel.getTodos(category: categoryName)
                        viewModel.todos = viewModel.todos.filter {$0.isDone == false}
                    default:
                        viewModel.getTodos(category: categoryName)
                    }
                }
            }
            List {
                ForEach(viewModel.todos) { item in
                    if (!searchQuery.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) {
                        if (lowerAndTrim(item.todo!).contains(lowerAndTrim(searchQuery))) {
                            TodoItem(item: item)
                                .onTapGesture {
                                    viewModel.updateTodo(item: item)
                                }
                        }
                    } else {
                        TodoItem(item: item)
                            .onTapGesture {
                                withAnimation(.linear) {
                                    viewModel.updateTodo(item: item)
                                }
                            }
                    }
                    
                }
                .onDelete { indexSet in
                    viewModel.deleteTodo(indexSet: indexSet, selectedFilter: &selectedFilter)
                }
            }
            .onAppear {
                viewModel.onAppearReset(categoryName: categoryName, filter: "Newly Created", selectedFilter: &selectedFilter)
            }
            
            .navigationBarTitle(categoryName)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        EditButton()
                        NavigationLink(destination: AddTodoView(category: categoryName)) {
                            Image(systemName: "plus.circle")
                                .resizable()
                                .foregroundColor(.blue)
                                .frame(width: 25, height: 25)
                        }
                    }
                }
            }
        }
    }
}


struct TodoItem: View {
    var item:Todo
    var body: some View {
        HStack {
            Image(systemName: item.isDone ? "checkmark.circle.fill" : "circle")
                .resizable()
                .foregroundColor(.accentColor)
                .frame(width:18,height: 18)
            Text(item.todo ?? "")
                .strikethrough(item.isDone)
                .foregroundColor(item.isDone ? .gray : .primary)
            Spacer()
            Text(item.priority ?? "")
                .foregroundColor(.gray)
                .font(.system(size: 14))
            Circle()
                .fill(getPriorityColor(priority: item.priority ?? ""))
                .frame(width: 10, height: 10)
        }
    }
}



struct TodosView_Previews: PreviewProvider {
    
    static var previews: some View {
        TodosView(categoryName: "Sample")
            .environmentObject(TodoViewModel())
        
    }
}



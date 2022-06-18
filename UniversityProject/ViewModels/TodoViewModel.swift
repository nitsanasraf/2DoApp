//
//  ViewModel.swift
//  UniversityProject
//
//  Created by Nitsan Asraf on 14/06/2022.
//

import Foundation
import CoreData


class TodoViewModel:ObservableObject {
    
    let container: NSPersistentContainer
    
    @Published var categories = [CategoryTodo]()
    @Published var todos = [Todo]()
    
    init() {
        container = NSPersistentContainer(name: "UniversityProject")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }
    
    //MARK: - Todos
    func getTodos(category:String) {
        let request = NSFetchRequest<Todo>(entityName: "Todo")
        let sort = NSSortDescriptor(key: #keyPath(Todo.dateCreated), ascending: false)
        let predicate = NSPredicate(format: "category = %@", category)
        request.sortDescriptors = [sort]
        request.predicate = predicate
        do {
            try todos = container.viewContext.fetch(request)
        } catch {
            print("Error getting data. \(error)")
        }
    }
    
    
    func saveTodos() {
        do {
            try container.viewContext.save()
        } catch{
            print("Error: \(error)")
        }
    }
    
    
    func addTodo(todo text: String, category categoryName:String, priority priorityLevel:String, isDone isDoneState:Bool = false) {
        let newTodo = Todo(context: container.viewContext)
        newTodo.todo = text
        newTodo.category = categoryName
        newTodo.id = UUID().uuidString
        newTodo.isDone = isDoneState
        newTodo.dateCreated = Date()
        newTodo.priority = priorityLevel
        saveTodos()
    }
    
    func deleteTodo(indexSet: IndexSet, selectedFilter: inout String) {
        let todoIndex = indexSet[indexSet.startIndex]
        let category = todos[todoIndex].category
        container.viewContext.delete(todos[todoIndex])
        saveTodos()
        onAppearReset(categoryName: category ?? "", filter: "Newly Created", selectedFilter: &selectedFilter)
    }
    
    func updateTodo(item: Todo) {
        if let index = todos.firstIndex(where: {$0.id == item.id}) {
            let newTodo = Todo(context: container.viewContext)
            newTodo.todo = item.todo
            newTodo.category = item.category
            newTodo.id = item.id
            newTodo.isDone = !item.isDone
            newTodo.dateCreated = item.dateCreated
            newTodo.priority = item.priority
            todos[index] = newTodo
            container.viewContext.delete(item)
            saveTodos()
        }
        
    }
    
    func sortTodosByPriority() {
        var priorities = [(Todo,Int)]()
        for item in todos {
            switch (item.priority) {
            case "Low":
                priorities.append((item,0))
            case "Medium":
                priorities.append((item,1))
            case "High":
                priorities.append((item,2))
            default:
                priorities.append((item,0))
            }
        }
        let sortedTodos = priorities.sorted { $0.1 > $1.1 }
        todos = sortedTodos.map {$0.0}
    }
    
    func onAppearReset(categoryName:String,filter:String, selectedFilter:inout String) {
        getTodos(category: categoryName)
        selectedFilter = filter
    }
    
    
    
    
    //MARK: - Categories
    func getCategories() {
        let request = NSFetchRequest<CategoryTodo>(entityName: "CategoryTodo")
        let sort = NSSortDescriptor(key: #keyPath(CategoryTodo.title), ascending: true)
        request.sortDescriptors = [sort]
        do {
            try categories = container.viewContext.fetch(request)
        } catch {
            print("Error getting data. \(error)")
        }
    }
    
    func saveCategories() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error: \(error)")
        }
    }
    
    func addCategory(title text: String, bgColor bg:String, fgColor fg:String) -> Bool {
        for category in categories {
            if (lowerAndTrim(category.title ?? "") == lowerAndTrim(text)) {
                return false
            }
        }
        let newCategory = CategoryTodo(context: container.viewContext)
        newCategory.id = UUID().uuidString
        newCategory.title = text
        newCategory.bgColor = bg
        newCategory.fgColor = fg
        saveCategories()
        getCategories()
        return true
    }
    
    func deleteCategory(indexSet: IndexSet) {
        let categoryIndex = indexSet[indexSet.startIndex]
        getTodos(category: categories[categoryIndex].title ?? "")
        //Delete all todos in category
        for todo in todos {
            container.viewContext.delete(todo)
        }
        container.viewContext.delete(categories[categoryIndex])
        saveCategories()
        getCategories()
    }
    
    
}

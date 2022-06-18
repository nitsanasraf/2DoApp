//
//  AddTodoView.swift
//  UniversityProject
//
//  Created by Nitsan Asraf on 14/06/2022.
//

import SwiftUI

struct AddTodoView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: TodoViewModel
    
    @State private var selectedPriority:String = "Medium"
    let priorities = ["Low","Medium","High"]
    
    let category:String
    
    @State private var text: String = ""
    
    private var isDisabled: Bool {
        return text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? true : false
    }
    
    private var buttonColor: Color {
        return isDisabled ? .gray : .blue
    }

    var body: some View {
        VStack {
            Text("What do you need to do?")
                .fontWeight(.bold)
            TextField("Todo",text: self.$text)
                .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                .background(.ultraThinMaterial)
                .foregroundColor(.blue)
                .cornerRadius(7)
            Spacer()
                .frame(height: 20)
            
            Text("Choose a priority for the task")
                .fontWeight(.bold)
            Picker(selection: $selectedPriority,label:Text("Choose a priority level")) {
                ForEach(priorities, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(.segmented)
            .background(.ultraThinMaterial)
            
            Spacer()
                .frame(height: 20)
            Divider()
            Spacer()
                .frame(height: 20)
            
            Button(action: {
                viewModel.addTodo(todo: text, category: category,priority: selectedPriority)
                self.presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Image(systemName: "plus.circle")
                    Text("ADD")
                }
            }
            .frame(maxWidth: .infinity)
            .disabled(isDisabled)
            .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
            .foregroundColor(.white)
            .background(buttonColor)
            .cornerRadius(5)
            
            Spacer()
        }
        .padding()
        
        .navigationTitle("Add a new todo")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AddTodoView_Previews: PreviewProvider {
    static var previews: some View {
        AddTodoView(category: "Shop")
            .environmentObject(TodoViewModel())
    }
}

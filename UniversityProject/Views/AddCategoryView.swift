//
//  AddCategoryView.swift
//  UniversityProject
//
//  Created by Nitsan Asraf on 14/06/2022.
//

import SwiftUI
import UIColorHexSwift

struct AddCategoryView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var viewModel: TodoViewModel
    
    @State private var showingAlert = false
    @State var attempts: Int = 0
    @State private var text: String = ""
    @State private var selectedColor:String = "White"
    
    private var isDisabled: Bool {
        return text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || (selectedColor.isEmpty) ? true : false
    }
    
    private var buttonColor: Color {
        return isDisabled ? .gray : .blue
    }
    
    private let colors = ["White", "Green", "Blue", "Black", "Red","Yellow"]
    
    func getColors(colorName:String) -> (String,String) {
        switch colorName {
        case "White":
            return (bg:UIColor(.white).hexString(),fg:UIColor(.black).hexString())
        case "Green":
            return (bg:UIColor(.green).hexString(),fg:UIColor(.white).hexString())
        case "Blue":
            return (bg:UIColor(.blue).hexString(),fg:UIColor(.white).hexString())
        case "Black":
            return (bg:UIColor(.black).hexString(),fg:UIColor(.white).hexString())
        case "Red":
            return (bg:UIColor(.red).hexString(),fg:UIColor(.white).hexString())
        case "Yellow":
            return (bg:UIColor(.yellow).hexString(),fg:UIColor(.black).hexString())
        default:
            return (bg:UIColor(.white).hexString(),fg:UIColor(.black).hexString())
        }
    }
    
    var body: some View {
        VStack {
            Text("Pick a category title")
                .fontWeight(.bold)
            TextField("Category Name",text: self.$text)
                .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                .background(.ultraThinMaterial)
                .foregroundColor(.blue)
                .cornerRadius(7)
                .modifier(Shake(animatableData: CGFloat(attempts)))
            
                .alert("'\(text)' already exists.\nPlease choose a different title for the category.", isPresented: $showingAlert) {
                    Button("OK", role: .cancel) { }
                }
            Spacer()
                .frame(height: 20)
            Divider()
            Spacer()
                .frame(height: 20)
            Text("Pick a category color")
                .fontWeight(.bold)
            
            Picker(selection: $selectedColor,label:Text("Select a color")) {
                ForEach(colors, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(.segmented)
            .background(.ultraThinMaterial)
            
            Spacer()
                .frame(height:20)
            
            Button(action: {
                let colors = getColors(colorName: selectedColor)
                let isSuccessful = viewModel.addCategory(title: text, bgColor: colors.0, fgColor: colors.1)
                if (isSuccessful) {
                    self.presentationMode.wrappedValue.dismiss()
                } else {
                    withAnimation(.default) {
                        self.attempts += 1
                        showingAlert = true
                    }
                }
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
        
        .navigationTitle("Add a new category")
        .navigationBarTitleDisplayMode(.inline)
        
    }
}

struct Shake: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
                                                amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
                                              y: 0))
    }
}

struct AddCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        AddCategoryView()
            .environmentObject(TodoViewModel())
    }
}

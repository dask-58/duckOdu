//
//  ContentView.swift
//  duckodu
//
//  Created by Dhruv Koli on 03/10/24.
//

import SwiftUI

struct TodoItem: Identifiable, Equatable {
    let id = UUID()
    var task: String
    var isCompleted: Bool
}

struct ContentView: View {
    @State private var newTask: String = ""
    @State private var todoItems: [TodoItem] = []
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""

    var body: some View {
        VStack {
            Text("DuckOdu")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.blue)
                .padding(.top, 40)
            
            HStack {
                TextField("Enter new task", text: $newTask)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .background(Color(.systemGray))
                    .cornerRadius(10)
                    .padding(.leading)
                
                Button(action: addTask) {
                    Text("Add")
                        .font(.headline)
                         .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(0)
                }
                .padding(.trailing)
            }
            .padding()
            
            if todoItems.isEmpty {
                Spacer()
                Text("No tasks! Add some 🦆")
                    .font(.title2)
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List {
                    ForEach(todoItems) { item in
                        HStack {
                            Button(action: {
                                toggleTaskCompletion(item)
                            }) {
                                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                                    .font(.title2)
                                    .foregroundColor(item.isCompleted ? .green : .gray)
                                    .scaleEffect(item.isCompleted ? 1.2 : 1.0)
                                    .animation(.easeInOut, value: item.isCompleted)
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            Text(item.task)
                                .strikethrough(item.isCompleted)
                                .foregroundColor(item.isCompleted ? .gray : .black)
                                .font(.title3)
                                .padding(.leading, 10)
                        }
                    }
                    .onDelete(perform: deleteTask)
                }
                .animation(.default, value: todoItems)
                .listStyle(PlainListStyle())
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("DuckOdu"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private func addTask() {
        guard !newTask.isEmpty else { return }
        let newItem = TodoItem(task: newTask, isCompleted: false)
        todoItems.append(newItem)
        newTask = ""
        showPrompt(message: "Task added successfully!")
    }
    
    private func toggleTaskCompletion(_ item: TodoItem) {
        if let index = todoItems.firstIndex(where: { $0.id == item.id }) {
            todoItems[index].isCompleted.toggle()
        }
    }
    
    private func deleteTask(at offsets: IndexSet) {
        todoItems.remove(atOffsets: offsets)
        showPrompt(message: "Task deleted.")
    }
    
    private func showPrompt(message: String) {
        alertMessage = message
        showAlert = true
    }
}

#Preview {
    ContentView()
}

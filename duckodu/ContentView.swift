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
    
    private let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)), Color(#colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1))]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    var body: some View {
        ZStack {
            backgroundGradient.ignoresSafeArea()
            
            VStack {
                Text("DuckOdu")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.top, 40)
                    .shadow(radius: 2)
                
                HStack {
                    TextField("Enter new task", text: $newTask)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(15)
                        .foregroundColor(.white)
                    
                    Button(action: addTask) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 44))
                            .foregroundColor(.white)
                            .shadow(radius: 2)
                    }
                }
                .padding()
                
                if todoItems.isEmpty {
                    Spacer()
                    Text("No tasks! Add some 🦆")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                } else {
                    List {
                        ForEach(todoItems) { item in
                            HStack {
                                Button(action: { toggleTaskCompletion(item) }) {
                                    Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                                        .font(.title2)
                                        .foregroundColor(item.isCompleted ? Color(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)) : .white)
                                        .scaleEffect(item.isCompleted ? 1.2 : 1.0)
                                        .animation(.easeInOut, value: item.isCompleted)
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                Text(item.task)
                                    .strikethrough(item.isCompleted)
                                    .foregroundColor(item.isCompleted ? .gray : .white)
                                    .font(.title3)
                                    .padding(.leading, 10)
                            }
                        }
                        .onDelete(perform: deleteTask)
                        .listRowBackground(Color.white.opacity(0.1))
                    }
                    .animation(.default, value: todoItems)
                    .listStyle(PlainListStyle())
                    .background(Color.clear)
                    .scrollContentBackground(.hidden)
                }
            }
            .padding()
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

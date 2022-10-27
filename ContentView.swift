//
//  ContentView.swift
//  ToDo CoreData
//
//  Created by Fauzan Nugraha on 13/10/22.
//

import SwiftUI

enum Priority: String, Identifiable, CaseIterable { // identify the variable
    var id: UUID {
        return UUID()
    }
    
    case low = "Low"
    case medium = "Medium"
    case high = "High"
}

extension Priority {
    var title: String {
        switch self { // Switch case
        case .low:
            return "Low"
        case .medium:
            return "Medium"
        case .high:
            return "High"
        }
    }
}

struct ContentView: View {
    
    @State private var title: String = ""
    @State private var selectedPriorty: Priority = .medium
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Task.entity(), sortDescriptors: [NSSortDescriptor(key: "dateCreated", ascending: false)]) private var allTask: FetchedResults<Task>
    
    func saveTasks() {
        
        do {
            let task = Task(context: viewContext)
            task.title = title
            task.priority = selectedPriorty.rawValue
            task.dateCreated = Date()
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    private func styleForPriority(_ value: String) -> Color  { // for return the value to color
        
        let priority = Priority(rawValue: value)
        
        switch priority {
        case .low:
           return Color.green
        case .medium:
            return Color.orange
        case .high:
            return Color.red
        default :
            return Color.black
        }
    }
    
    private func updateTask(_ task: Task) {
        
        task.isFavorite = !task.isFavorite
        
        do{
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func deleteTask(at offsets: IndexSet) {
        offsets.forEach { index in
            let task = allTask[index]
            viewContext.delete(task)
            do{
                try viewContext.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            
            VStack {
                TextField("Enter Title", text: $title)
                    .textFieldStyle(.roundedBorder)
                
                Picker("Priority", selection: $selectedPriorty){
                    ForEach(Priority.allCases) { priority in
                        Text(priority.title).tag(priority)
                    }
                }.pickerStyle(.segmented)
                
                Button("Save") {
                    saveTasks()
                    
                } .padding(10)
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                
                List {
                    
                    ForEach(allTask) { task in
                        HStack{
                            
                            Circle()
                                .fill(styleForPriority(task.priority!))
                                .frame(width: 15, height: 15)
                            Spacer().frame(width: 20)
                            Text(task.title ?? "")
                            Spacer()
                            Image(systemName: task.isFavorite ? "heart.fill" : "heart")
                                .foregroundColor(.red)
                                .onTapGesture {
                                    updateTask(task)
                                }
                        }
                    } .onDelete(perform: deleteTask)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("All Task")
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            
            let persistedContainer = CoreDataManager.shared.persistentContainer
            ContentView().environment(\.managedObjectContext, persistedContainer.viewContext)
        }
    }
}

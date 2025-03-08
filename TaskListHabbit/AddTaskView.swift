//
//  AddTaskView.swift
//  TaskListHabbit
//
//  Created by Murat Mert Şenkaya on 1.03.2025.
//

import SwiftUI

struct AddTaskView: View {
    @ObservedObject var taskStore: TaskStore
    let themeColor: Color
    
    @State private var title = ""
    @State private var selectedPriority: Task.Priority = .normal
    @State private var dueDate = Date()
    @State private var hasDueDate = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Görev Detayları")) {
                    TextField("Görev Başlığı", text: $title)
                    
                    Picker("Öncelik", selection: $selectedPriority) {
                        ForEach(Task.Priority.allCases, id: \.self) { priority in
                            HStack {
                                Circle()
                                    .fill(priority.color)
                                    .frame(width: 12, height: 12)
                                Text(priority.rawValue)
                            }
                        }
                    }
                    
                    Toggle("Son Tarih Ekle", isOn: $hasDueDate)
                    
                    if hasDueDate {
                        DatePicker("Son Tarih", selection: $dueDate, displayedComponents: .date)
                    }
                }
            }
            .navigationTitle("Yeni Görev")
            .navigationBarItems(
                leading: Button("İptal") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Kaydet") {
                    saveTask()
                }
                .disabled(title.isEmpty)
            )
        }
        .accentColor(themeColor)
    }
    
    private func saveTask() {
        let newTask = Task(
            title: title,
            dueDate: hasDueDate ? dueDate : nil,
            priority: selectedPriority
        )
        
        taskStore.addTask(newTask)
        presentationMode.wrappedValue.dismiss()
    }
}

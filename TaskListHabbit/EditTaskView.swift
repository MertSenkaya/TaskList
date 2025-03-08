//
//  EditTaskView.swift
//  TaskListHabbit
//
//  Created by Murat Mert Şenkaya on 1.03.2025.
//

import SwiftUI

struct EditTaskView: View {
    let task: Task
    @ObservedObject var taskStore: TaskStore
    
    @State private var title: String
    @State private var selectedPriority: Task.Priority
    @State private var dueDate: Date
    @State private var hasDueDate: Bool
    
    @Environment(\.presentationMode) var presentationMode
    
    init(task: Task, taskStore: TaskStore) {
        self.task = task
        self.taskStore = taskStore
        
        // State'leri başlat
        _title = State(initialValue: task.title)
        _selectedPriority = State(initialValue: task.priority)
        _dueDate = State(initialValue: task.dueDate ?? Date())
        _hasDueDate = State(initialValue: task.dueDate != nil)
    }
    
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
            .navigationTitle("Görevi Düzenle")
            .navigationBarItems(
                leading: Button("İptal") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Kaydet") {
                    updateTask()
                }
                .disabled(title.isEmpty)
            )
        }
    }
    
    private func updateTask() {
        taskStore.updateTask(
            id: task.id,
            title: title,
            priority: selectedPriority,
            dueDate: dueDate,
            hasDueDate: hasDueDate
        )
        presentationMode.wrappedValue.dismiss()
    }
}

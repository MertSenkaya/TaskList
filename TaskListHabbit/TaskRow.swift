//
//  TaskRow.swift
//  TaskListHabbit
//
//  Created by Murat Mert Şenkaya on 1.03.2025.
//

import SwiftUI

struct TaskRow: View {
    let task: Task
    let taskStore: TaskStore
    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false
    
    var body: some View {
        HStack {
            Button(action: {
                taskStore.toggleTaskCompletion(task)
            }) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isCompleted ? task.priority.color : .gray)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .strikethrough(task.isCompleted)
                    .fontWeight(.medium)
                
                HStack {
                    Text(task.priority.rawValue)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(task.priority.color.opacity(0.2))
                        .cornerRadius(4)
                    
                    if let dueDate = task.dueDate {
                        Text(formatDate(dueDate))
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
            .onTapGesture {
                showingEditSheet = true
            }
            
            Spacer()
            
            Button(action: {
                showingDeleteAlert = true
            }) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
                    .font(.footnote)
            }
        }
        .padding(.vertical, 4)
        .alert(isPresented: $showingDeleteAlert) {
            Alert(
                title: Text("Görevi Sil"),
                message: Text("Bu görevi silmek istediğinize emin misiniz?"),
                primaryButton: .destructive(Text("Sil")) {
                    taskStore.deleteTask(withID: task.id)
                },
                secondaryButton: .cancel(Text("İptal"))
            )
        }
        .sheet(isPresented: $showingEditSheet) {
            EditTaskView(task: task, taskStore: taskStore)
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}

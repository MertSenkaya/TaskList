//
//  Models.swift
//  TaskListHabbit
//
//  Created by Murat Mert Şenkaya on 1.03.2025.
//

import SwiftUI

struct Task: Identifiable, Codable {
    var id = UUID()
    var title: String
    var isCompleted: Bool = false
    var dueDate: Date?
    var priority: Priority = .normal
    
    enum Priority: String, Codable, CaseIterable {
        case low = "Düşük"
        case normal = "Normal"
        case high = "Yüksek"
        
        var color: Color {
            switch self {
            case .low: return .blue
            case .normal: return .orange
            case .high: return .red
            }
        }
    }
}

class TaskStore: ObservableObject {
    @Published var tasks: [Task] = [] {
        didSet {
            saveTasks()
        }
    }
    
    init() {
        loadTasks()
    }
    
    func addTask(_ task: Task) {
        tasks.append(task)
    }
    
    func deleteTask(at indexSet: IndexSet) {
        tasks.remove(atOffsets: indexSet)
    }
    
    func deleteTask(withID id: UUID) {
        if let index = tasks.firstIndex(where: { $0.id == id }) {
            tasks.remove(at: index)
        }
    }
    
    func toggleTaskCompletion(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
        }
    }
    
    func updateTaskTitle(id: UUID, newTitle: String) {
        if let index = tasks.firstIndex(where: { $0.id == id }) {
            tasks[index].title = newTitle
        }
    }
    
    func updateTask(id: UUID, title: String, priority: Task.Priority, dueDate: Date?, hasDueDate: Bool) {
        if let index = tasks.firstIndex(where: { $0.id == id }) {
            tasks[index].title = title
            tasks[index].priority = priority
            tasks[index].dueDate = hasDueDate ? dueDate : nil
        }
    }
    
    private func saveTasks() {
        if let encoded = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encoded, forKey: "tasks")
        }
    }
    
    private func loadTasks() {
        if let data = UserDefaults.standard.data(forKey: "tasks"),
           let decoded = try? JSONDecoder().decode([Task].self, from: data) {
            tasks = decoded
        }
    }
}

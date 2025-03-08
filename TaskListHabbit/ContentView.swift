//
//  ContentView.swift
//  TaskListHabbit
//
//  Created by Mustafa Gümüş on 1.03.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var taskStore = TaskStore()
    @State private var showingAddTask = false
    @State private var useOrangeTheme = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Arkaplan rengi
                (useOrangeTheme ? Color.orange.opacity(0.1) : Color.blue.opacity(0.1))
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    List {
                        ForEach(taskStore.tasks) { task in
                            TaskRow(task: task, taskStore: taskStore)
                        }
                        .onDelete(perform: taskStore.deleteTask)
                    }
                    .listStyle(InsetGroupedListStyle())
                }
                .navigationTitle("Görevlerim")
                .navigationBarItems(
                    leading: Button(action: {
                        useOrangeTheme.toggle()
                    }) {
                        Image(systemName: "paintpalette.fill")
                            .foregroundColor(useOrangeTheme ? .orange : .blue)
                    },
                    trailing: Button(action: {
                        showingAddTask = true
                    }) {
                        Image(systemName: "plus")
                    }
                )
                .sheet(isPresented: $showingAddTask) {
                    AddTaskView(taskStore: taskStore, themeColor: useOrangeTheme ? .orange : .blue)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

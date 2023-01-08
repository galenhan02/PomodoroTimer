//
//  Pomodoro_TimerApp.swift
//  Pomodoro Timer
//
//  Created by Galen Han on 8/8/22.
//

import SwiftUI

@main
struct Pomodoro_TimerApp: App {
    let list = TODOList()
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: list)
        }
    }
}

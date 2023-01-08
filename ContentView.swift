//
//  ContentView.swift
//  Pomodoro Timer
//
//  Created by Galen Han on 8/8/22.
//
//

import SwiftUI
import UserNotifications

var pomodoro = "Pomodoro!"
var shortBreak = "Short break!"
var longBreak = "Long break!"
var timeValues = [pomodoro:10, shortBreak:10, longBreak:10]

struct ContentView: View {
    @ObservedObject var viewModel: TODOList
    @State var task: String = ""
    @State var showOptions = false
    
    var body: some View {
        if(!showOptions) {
            VStack {
                HStack {
                    Spacer()
                    optionBtn
                }
                //ProgressView()
                TimerView()
                //ProgressView()
                Text("TODO Tasks")
                    .bold()
                    .underline()
                ScrollView {
                    ForEach(viewModel.items) { item in
                        HStack {
                            TODOView(TODO: item)
                            Button {
                                viewModel.mark(item)
                            } label: {
                                Image(systemName: "minus.circle")
                            }
                        }
                        Spacer()
                    }
                    
                }
                Spacer()
                VStack(alignment: .leading) {
                    Text("Enter tasks")
                        .underline()
                    HStack {
                        TextField("Add tasks here", text: $task)
                            //.focused($isTaskFocused)
                            .onSubmit {
                                task = ""
                            }
                            .disableAutocorrection(true)
                        Button {
                            if task != "" {
                                viewModel.add(task)
                            }
                            task = ""
                        } label: {
                            Image(systemName: "plus.circle")
                        }
                    }
                    
                }
                
            }
            .padding()
        } else {
            VStack {
                HStack {
                    Spacer()
                    optionBtn
                }
                Text("Settings")
                    .bold()
                    .font(.largeTitle)
                    .padding()
                OptionView()
                Spacer()
                
            }
            .padding()
        }
    }
    var optionBtn: some View {
        Button {
            showOptions.toggle()
        } label: {
            Image(systemName: "clock")
        }
    }
}

struct OptionView: View {
    @State var pomDuration = ""
    @State var shortDuration = ""
    @State var longDuration = ""
    var body: some View {
        VStack(alignment: .leading) {
            Text("Change Pomodoro Duration:")
                .underline()
            HStack {
                TextField("seconds", text: $pomDuration)
                    //.focused($isTaskFocused)
                    .onSubmit {
                        pomDuration = ""
                    }
                    .disableAutocorrection(true)
                Button {
                    if let newTime = Int(pomDuration) {
                        if newTime > 0 {
                            timeValues[pomodoro] = newTime
                        }
                        
                    }
                    pomDuration = ""
                } label: {
                    Image(systemName: "pencil.circle")
                }
            }
            Text("Change (Short) Break Duration:")
                .underline()
            HStack {
                TextField("seconds", text: $shortDuration)
                    //.focused($isTaskFocused)
                    .onSubmit {
                        shortDuration = ""
                    }
                    .disableAutocorrection(true)
                Button {
                    if let newTime = Int(shortDuration) {
                        if newTime > 0 {
                            timeValues[shortBreak] = newTime
                        }
                    }
                    shortDuration = ""
                } label: {
                    Image(systemName: "pencil.circle")
                }
            }
            Text("Change (Long) Break Duration:")
                .underline()
            HStack {
                TextField("seconds", text: $longDuration)
                    //.focused($isTaskFocused)
                    .onSubmit {
                        longDuration = ""
                    }
                    .disableAutocorrection(true)
                Button {
                    if let newTime = Int(longDuration) {
                        if newTime > 0 {
                            timeValues[longBreak] = newTime
                        }
                        
                    }
                    longDuration = ""
                } label: {
                    Image(systemName: "pencil.circle")
                }
            }
            
        }
        
    }
}

struct TimerView: View {
    @State var time = timeValues[pomodoro]
    @State var isRunning = false
    @State var shouldBeRunning = false
    @State var statusMessage = pomodoro
    @State var sessionsCompleted = 0
    @State var statuses: [String] = [pomodoro, shortBreak, pomodoro, shortBreak, pomodoro, longBreak]
    
    @Environment(\.scenePhase) private var scenePhase
    @State var exitDate: Date = Date()
    @State var enterDate: Date = Date()
    
    @ObservedObject var notificationManger = LocalNotificationManger()
    
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    
    var body: some View {
        
        VStack {
            HStack {
                ForEach((0..<sessionsCompleted % 6), id: \.self) {_ in
                    Image(systemName: "checkmark")
                }
                ForEach((0..<(6 - sessionsCompleted % 6)), id: \.self) { _ in
                    Image(systemName: "hourglass")
                }
            }
            .padding(.bottom)
            Text("\(formatTime(sec: time!))")
                .onReceive(timer, perform: { _ in
                if isRunning {
                    if time == 1 {
                        sessionsCompleted += 1
                        statusMessage = statuses[sessionsCompleted % 6]
                        time = timeValues[statusMessage] ?? -1
                        self.notificationManger.sendNotification(title: "Just completed: \(statusMessage)", body: "Now: \(statuses[(sessionsCompleted + 1) % 6])", launchIn: 10, identifier: "\(statusMessage)")
                    }
                    else {
                        time! -= 1
                    }
                }
                })
                .font(.title)
            Text(statusMessage)
            HStack {
                restartBtn
                    .padding()
                startBtn
                    .padding()
                skipBtn
                    .padding()
            }
        }
        .onChange(of: scenePhase) { phase in
            if phase == .background {
                exitDate = Date()
                shouldBeRunning = isRunning
                isRunning = false
            }
            if phase == .active {
                if shouldBeRunning {
                    enterDate = Date()
                    if time! - Int(enterDate.timeIntervalSince(exitDate)) < 0 {
                        time = 1
                    } else {
                        time! -= Int(enterDate.timeIntervalSince(exitDate))
                    }
                    isRunning = true
                }
            }
        }
    }
    var startBtn: some View {
        Button {
            isRunning.toggle()
            if(!isRunning) {
                self.notificationManger.cancelAllNotifications()
            }
            else {
                self.notificationManger.sendNotification(title: "Just completed: \(statusMessage)", body: "Now: \(statuses[(sessionsCompleted + 1) % 6])", launchIn: Double(time!), identifier: "\(statusMessage)")
            }
            
        } label: {
            Image(systemName:isRunning ? "pause" : "play")
        }
    }
    
    var restartBtn: some View {
        Button {
            isRunning = false
            time = timeValues[statusMessage] ?? -1
            self.notificationManger.cancelAllNotifications()
        } label: {
            Image(systemName: "restart.circle")
        }
    }
    
    var skipBtn: some View {
        Button {
            isRunning = false
            self.notificationManger.cancelAllNotifications()
            sessionsCompleted += 1
            statusMessage = statuses[sessionsCompleted % 6]
            time = timeValues[statusMessage] ?? -1
        } label: {
            Image(systemName: "forward")
        }
    }
    
    func formatTime(sec time: Int) -> String {
        var minStr: String
        var secStr: String
        let min = time/60
        let sec = time%60
        
        if min < 10 {
            minStr = "0\(min)"
        }
        else {
            minStr = "\(min)"
        }
        
        if sec < 10 {
            secStr = "0\(sec)"
        }
        else {
            secStr = "\(sec)"
        }

        
        return minStr + ":" + secStr
    }
}




struct TODOView: View {
    let TODO: ItemList<String>.TODOItem
    
    var body: some View {
        HStack {
            Text(TODO.content)
        }
    }
}


















struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let list = TODOList()
        ContentView(viewModel: list)
    }
}

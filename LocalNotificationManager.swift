//
//  LocalNotificationManager.swift
//  Pomodoro Timer
//
//  Created by Galen Han on 8/11/22.
//

import Foundation
import SwiftUI

class LocalNotificationManger: ObservableObject {
    let center = UNUserNotificationCenter.current()
    
    init() {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            
            if error != nil {
                print("Notifs not permitted")
            }
        }
    }
    
    func sendNotification(title: String, body: String, launchIn: Double, identifier: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: launchIn, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error : Error?) in
            if let theError = error {
                print("\(theError)")
            }
        }
        
    }
    
    func cancelAllNotifications() {
        center.removeAllPendingNotificationRequests()
    }
    
    
}

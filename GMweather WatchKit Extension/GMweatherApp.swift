//
//  GMweatherApp.swift
//  GMweather WatchKit Extension
//
//  Created by Mikhail Tikhonov on 6/2/21.
//

import SwiftUI

@main
struct GMweatherApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}

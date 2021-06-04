//
//  tikhonov_weatherApp.swift
//  watchWeather Extension
//
//  Created by Mikhail Tikhonov on 5/28/21.
//

import SwiftUI
import SwiftyWeatherKit
import ClockKit

let service = SwiftyWeatherKit.shared().getService(WeatherServiceType: .Ambient, WeatherAPI: ["0bb802cc4ff04a4ab491cd9454854dd4cf707b2d18d443248d463a669d09202c","e30efdddbd354e079d6be39b7e6acd34c43c4e26d95c44ddb88420a75418d7c8"])

final class Data{
    @Published var temperature: String

    init(){
        var getTemp = " "
        service?.getLastMeasurement(uniqueID:"50:02:91:E3:9D:45", completionHandler: {stationData in
            guard stationData != nil else { return }
            guard let sensors = stationData?.availableSensors else {return }
            for sensor in sensors{
                if (sensor.name == "Outdoor Temperature") {
                    print("Sensor temperature detected")
                    getTemp = String(describing: sensor.measurement)
                    print(getTemp)
                }
            }
        })
        sleep(10)
        temperature = getTemp
        }
    func updateWeather(){
        service?.getLastMeasurement(uniqueID:"50:02:91:E3:9D:45", completionHandler: {stationData in
            guard stationData != nil else { return }
            guard let sensors = stationData?.availableSensors else {return }
            for sensor in sensors{
                if (sensor.name == "Outdoor Temperature") {
                    print("Sensor temperature updated")
                    self.temperature = String(describing: sensor.measurement)
                    print(self.temperature)
                }
            }
        })
    }

    
}
var state = Data();

var dlastMeasurementDate = Date()
func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
    for task in backgroundTasks {
        switch task {
        case let backgroundTask as WKApplicationRefreshBackgroundTask:
            scheduleNextReload()
            state.updateWeather();
            backgroundTask.setTaskCompletedWithSnapshot(false)
        default:
            task.setTaskCompletedWithSnapshot(false)
        }
    }
}

func scheduleNextReload() {
    let refreshTime = Date().advanced(by: 10)
    WKExtension.shared().scheduleBackgroundRefresh(
        withPreferredDate: refreshTime,
        userInfo: nil,
        scheduledCompletion: { _ in }
    )
}

@main
struct weatherApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

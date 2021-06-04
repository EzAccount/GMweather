//
//  ComplicationController.swift
//  GMweather WatchKit Extension
//
//  Created by Mikhail Tikhonov on 6/2/21.
//

import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // MARK: - Complication Configuration

    func getComplicationDescriptors(handler: @escaping ([CLKComplicationDescriptor]) -> Void) {
        let descriptors = [
            CLKComplicationDescriptor(identifier: "complication", displayName: "GMweather", supportedFamilies: CLKComplicationFamily.allCases)
            // Multiple complication support can be added here with more descriptors
        ]
        
        // Call the handler with the currently supported complication descriptors
        handler(descriptors)
    }
    
    func handleSharedComplicationDescriptors(_ complicationDescriptors: [CLKComplicationDescriptor]) {
        // Do any necessary work to support these newly shared complication descriptors
    }

    // MARK: - Timeline Configuration
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        // Call the handler with the last entry date you can currently provide or nil if you can't support future timelines
        handler(nil)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        // Call the handler with your desired behavior when the device is locked
        handler(.showOnLockScreen)
    }

    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(
        for complication: CLKComplication,
        withHandler callback: @escaping (CLKComplicationTimelineEntry?) -> Void)
    {
    let date = Date();
    let entry: CLKComplicationTimelineEntry
    let diff = date.timeIntervalSince1970 - dlastMeasurementDate.timeIntervalSince1970
    if (diff <= 1000)  {
        let handler = CLKComplicationTemplateModularSmallSimpleText(textProvider: CLKSimpleTextProvider(text: state.temperature) )
        entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: handler)
    } else {
        state.updateWeather()
        let level = String(state.temperature)
        let handler = CLKComplicationTemplateModularSmallSimpleText(textProvider: CLKSimpleTextProvider(text: level ))
        entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: handler)
        dlastMeasurementDate = Date()
        
    }
        callback(entry)
    }

    // MARK: - Sample Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        switch complication.family {
        case .modularSmall:
            let random = CLKComplicationTemplateModularSmallSimpleText(textProvider: CLKSimpleTextProvider(text: "70") )
            handler(random)
        default:
            handler(nil)
        // Pass the template to ClockKit.
        }
    }
}

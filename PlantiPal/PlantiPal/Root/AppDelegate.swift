//
//  AppDelegate.swift
//  PlantiPal
//
//  Created by Delia on 02/03/2023.
//  Copyright © 2023 Delia. All rights reserved.
//

import UIKit
import Parse
import UserNotifications
import MapKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    let locationManager = CLLocationManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let configuration = ParseClientConfiguration {
            $0.applicationId = "ak28rAAtX39AM49XEIsbMJBoquAmoBON1SU4r52m"
            $0.clientKey = "EFX2wexQMPa1CwNzbLLtjdQXNWzlzRB2kOmzjs6Y"
            $0.server = "https://parseapi.back4app.com"
        }
        Parse.initialize(with: configuration)
        // Override point for customization after application launch.
        
        UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
        // UserDefaults.standard.set(false, forKey: "isLoggedIn")
        
        return true
    }
    
//    func applicationDidFinishLaunching(_ application: UIApplication) {
//        UserDefaults.standard.set(false, forKey: "isLoggedIn")
//    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        print("entered background")
        
        if(notifAccess == true) {
            if(gardenPlants.count != 0) {
                var index = 0
                for plant in gardenPlants {
                    let weekday = Calendar.current.component(.weekday, from: Date())
                    // print(weekday)
                    scheduleNotifs(plantName: plant.name, weekInterval: plant.daysToWater, weekday: weekday, hour: 8, minute: index)
                    isScheduled = true
                    index = index+1
                }
            }
        }
        
        if(isSnowy == true) {
            scheduleWeatherNotif()
        }
        
        let defaults = UserDefaults.standard
        let token = defaults.string(forKey: "lastLoggedUserId")
        print("last user: ", token!)
        
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func scheduleNotifs(plantName: String, weekInterval: Int, weekday: Int, hour: Int, minute: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Your plant is thirsty!"
        content.body = "You need to water "+plantName+" today."
        
        var dateComponents = DateComponents()
        dateComponents.weekday = weekday // 1 is Sunday, 2 is Monday, etc.
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let initialTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let calendar = Calendar.current
        if let nextFireDate = calendar.date(byAdding: .weekOfMonth, value: weekInterval, to: initialTrigger.nextTriggerDate() ?? Date()) {
            let nextFireDateComponents = calendar.dateComponents([.weekday, .hour, .minute], from: nextFireDate)
            
            let nextTrigger = UNCalendarNotificationTrigger(dateMatching: nextFireDateComponents, repeats: true)
            
            let identifier = plantName+"Notification"
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: nextTrigger)
            
            UNUserNotificationCenter.current().add(request) { (error) in
                if let error = error {
                    print("Error scheduling notification: \(error.localizedDescription)")
                } else {
                    print("Repeating notification scheduled for ", plantName, " at hour: ", hour, " and minute: ", minute)
                }
            }
        } else {
            print("Error calculating next fire date.")
        }
    }
    
    func scheduleWeatherNotif() {
        let content = UNMutableNotificationContent()
        content.title = "Weather Alert"
        content.body = "Today will snow. Cover your outside plants to protect them!"
        content.sound = UNNotificationSound.default()
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 300, repeats: false)
        
        let request = UNNotificationRequest(identifier: "weatherNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Weather notification scheduled successfully!")
            }
        }
    }
    
    func fetchGardenData(completion: @escaping ([PFObject]?, Error?) -> Void) {
        let query = PFQuery(className: "Garden")
        query.whereKey("username", equalTo: loggedUser.user.username as Any)
        query.findObjectsInBackground { (objects, error) in
            completion(objects, error)
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let notification = response.notification
        let payload = notification.request.content.userInfo
        print("Payload: ", payload)
        openApp()
        
        completionHandler()
    }

    func openApp() {
        guard let window = UIApplication.shared.windows.first else {
            return
        }
        
        let rootViewController = ViewController()
        
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocation = manager.location else { return }
        fetchCityAndCountry(from: location) { city, country, error in
            guard let city = city, let country = country, error == nil else { return }
            print(city + ", " + country)
            locationCity = city
        }
    }
    
    func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first?.locality,
                       placemarks?.first?.country,
                       error)
        }
    }
}


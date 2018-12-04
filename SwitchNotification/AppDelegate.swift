//
//  AppDelegate.swift
//  SwitchNotification
//
//  Created by Macintosh on 30/11/18.
//  Copyright © 2018 Macintosh. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let defaultUser = UserDefaults.standard


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if defaultUser.integer(forKey: "firstTimeLogin") <= 0 {
            setupPushNotification(application: application)
        }
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }
    
    func setupPushNotification(application: UIApplication) -> () {
    
        UNUserNotificationCenter.current().requestAuthorization(options: [
            .alert, .badge, .sound]) {(granted, Error) in
                if granted {
                    DispatchQueue.main.async {
                        application.registerForRemoteNotifications()
                    }
                    self.defaultUser.set(1, forKey: "firstTimeLogin")
                    self.defaultUser.set(true, forKey: "notifON")
                } else {
                    print("User Notification permission denied: \(Error?.localizedDescription ?? "error")")
                }
                print("granted: \(granted)")
        }
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.notification.request.identifier == "test1" {
            print("recieve get it")
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print(" Entire message \(userInfo)")
        //print("Article avaialble for download: \(userInfo["articleId"]!)")
        
        //        let state : UIApplication.State = application.applicationState
        //        switch state {
        //        case UIApplication.State.active:
        //            print("If needed notify user about the message")
        //        default:
        //            print("Run code to download content")
        //        }
        //
        //        completionHandler(UIBackgroundFetchResult.newData)
    }
}

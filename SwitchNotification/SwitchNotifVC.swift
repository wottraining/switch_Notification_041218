//
//  ViewController.swift
//  SwitchNotification
//
//  Created by Macintosh on 30/11/18.
//  Copyright © 2018 Macintosh. All rights reserved.
//

import UIKit
import UserNotifications

class SwitchNotifVC: UIViewController {
    
    @IBOutlet weak var segmentBtn: UISegmentedControl!

    let defaultUser = UserDefaults.standard
    let dateFomatter = DateFormatter()
    let currentUserNotification = UNUserNotificationCenter.current()
    
    var pendingRequest: UNNotificationRequest!
    var countNotif = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let notifStatus = defaultUser.bool(forKey: "notifON")
        self.dateFomatter.dateStyle = .medium
        self.dateFomatter.timeStyle = .short
        self.countNotif = 1
        
        if notifStatus {
            segmentBtn.selectedSegmentIndex = 1
        } else {
            segmentBtn.selectedSegmentIndex = 0
        }
        
    }
    
 
    @IBAction func segmentBtnPress(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
            case 0 :
                defaultUser.set(false, forKey: "notifON")
                if pendingRequest != nil {
                    currentUserNotification.add(pendingRequest!, withCompletionHandler: nil)
                    print("prepare notification success...")
                }
                break
            case 1 :
                defaultUser.set(true, forKey: "notifON")
                currentUserNotification.add(pendingRequest!, withCompletionHandler: nil)
                print("prepare notification success...")
                break
            default:
                break
        }
    }
    
    
    @IBAction func notifBtnPress(_ sender: UIButton) {
        let currentSegmentIndex = segmentBtn.selectedSegmentIndex
        print(currentSegmentIndex)
        switch currentSegmentIndex {
            case 0 :
                segmentBtn.selectedSegmentIndex = 1
                defaultUser.set(true, forKey: "notifON")
                if pendingRequest != nil {
                    currentUserNotification.add(pendingRequest!, withCompletionHandler: nil)
                    print("prepare notification success...")
                }
            break
            case 1 :
                segmentBtn.selectedSegmentIndex = 0
                defaultUser.set(false, forKey: "notifON")
                currentUserNotification.removeAllPendingNotificationRequests()
                print("All notifi denied...")
            break
        default :
            break
        }
    }
    
    @IBAction func showNotif(_ sender: UIButton) {
        
        let notifStatus = defaultUser.bool(forKey: "notifON")
        pendingRequest = setReminder(identify: "admin", tittle: "Notification \(countNotif)", notes: "time: \(Date())", _repeat: false)

        if notifStatus {
            currentUserNotification.add(pendingRequest!, withCompletionHandler: nil)
            print("prepare notification success...")
        } else {
            print("notification denied...")
            pendingRequest = nil
        }
        countNotif += 1
    }
    
    func setReminder(identify: String, tittle: String, notes: String, _repeat: Bool) -> UNNotificationRequest {
        let content = UNMutableNotificationContent()
        
        content.title = tittle
        content.body = notes
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: _repeat)
        return UNNotificationRequest(identifier: identify, content: content, trigger: trigger)
    }
    

}


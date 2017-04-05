//
//  ViewController.swift
//  NotificationStrategy
//
//  Created by sarra srairi on 11/08/2016.
//  Copyright © 2016 R&D connecthings. All rights reserved.
//
import UIKit
import ATConnectionHttp
import ATAnalytics
import ATLocationBeacon
class ViewController: UIViewController {
    
    @IBOutlet weak var txtMessage: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
                // Enable or disable features based on authorization.
            }
            let setting = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(setting)
            UIApplication.shared.registerForRemoteNotifications()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.remoteNotificationReceived), name: NSNotification.Name(rawValue: "LocalNotificationMessageReceivedNotification"), object: nil)

   
        // Do any additional setup after loading the view, typically from a nib
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func remoteNotificationReceived(notification: NSNotification) {
        let beaconContent: ATBeaconContent = (notification.userInfo!["beaconContent"] as! ATBeaconContent)
        self.txtMessage.text = beaconContent.getNotificationTitle()
        self.txtMessage.setNeedsDisplay()
    }
}

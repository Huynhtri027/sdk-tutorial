//
//  AppDelegate.swift
//  SimpleNotification
//
//  Created by sarra srairi on 10/08/2016.
//  Copyright © 2016 R&D connecthings. All rights reserved.
//


import UIKit
import ATConnectionHttp
import ATAnalytics
import ATLocationBeacon
import UserNotifications


@UIApplicationMain

class AppDelegate: ATBeaconAppDelegate, UIApplicationDelegate,ATBeaconNotificationDelegate,ATBeaconWelcomeNotificationDelegate,ATBeaconReceiveNotificatonContentDelegate {
    
    var window: UIWindow?
    

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        /* ** Required -- used to initialize and setup the SDK
         *
         *
         *
         * If you have followed our SDK quickstart guide, you won't need to re-use this method, but you should add the parameters values.
         * -- 1- Platform : ATUrlTypePreprod  = > Pre-production Platform
         *                  ATUrlTypeProd     = > Production Platform
         *                  ATUrlTypeDemo     = > Demo Platform
         *
         * Key/Value are related to the selected Platform
         * -- 2- user Login : Login delivred by the Connecthings staff
         * -- 3- user Password : Password delivred by the Connecthings staff
         * -- 4- user Compagny : Define the compagny name
         * -- 5- beaconUuid : - UUID beacon number delivred by the Connecthings staff
         * --
         *
         * All other SDK methods must be called after this one, because they won't exist until you do.
         */
        let uuids = ["****UUID****"]
        initAdtagInstance(with: ATUrlTypeProd, userLogin: "*****LOGIN*****", userPassword: "****PASSWORD****", userCompany: "****COMPAGNY****", beaconArrayUuids: uuids, activatIos10Workaround: false)
        
        self.add(ATBeaconWelcomeNotification.init(title:"Nice Welcome Notification", description: "Good news: You have got network", minDisplayTime: 1000 * 60 * 2, welcomeNotificationType: ATBeaconWelcomeNotificationTypeNetworkOn))
        
        
        self.add(ATBeaconWelcomeNotification.init(title:"Nice Welcome Notification", description: "No network? Lucky you are, a free wifi is available!", minDisplayTime: 1000 * 60 * 2, welcomeNotificationType: ATBeaconWelcomeNotificationTypeNetworkOff))
        
        
        /* Required --- Ask for User Permission to Receive (UILocalNotifications/ UIUserNotification) in iOS 8 and later
         / -- Registering Notification Settings **/
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
                // Enable or disable features based on authorization.
            }
            let setting = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(setting)
            UIApplication.shared.registerForRemoteNotifications()
        } else {
            if(UIApplication.instancesRespond(to: #selector(UIApplication.registerUserNotificationSettings(_:)))){
                let notificationCategory:UIMutableUserNotificationCategory = UIMutableUserNotificationCategory()
                notificationCategory.identifier = "INVITE_CATEGORY"
                //registerting for the notification.
                UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings (types: [.alert, .badge, .sound], categories: nil))
            }
        }
            ATBeaconManager.sharedInstance().registerNotificationContentDelegate(self);
        return true
    }
    
    
    override func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        super.application(application, didReceive: notification)
        ATBeaconManager.sharedInstance().didReceive(notification);
    }
    
    override func applicationDidBecomeActive(_ application: UIApplication) {
        
        /* ** Required
         * Add super.applicationDidBecomeActive to your delegate method
         * the super class will init the range beacon
         * if a the super call isn't reachable the Beacon range won't be start
         */
        super.applicationDidBecomeActive(application);
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
    }
    
    func applicationWillTerminate(application: UIApplication) {
    }
    
    func createNotification(_ _beaconContent: ATBeaconContent!) -> UILocalNotification! {
        
        let kLocalNotificationMessage:String! = _beaconContent.getNotificationDescription()
        let kLocalNotificationAction:String! = _beaconContent.getAlertTitle()
        let localNotification:UILocalNotification = UILocalNotification()
        localNotification.alertBody = kLocalNotificationMessage
        localNotification.alertAction = kLocalNotificationAction
        
        let infoDict = [ KEY_NOTIFICATION_CONTENT : _beaconContent.toJSONString() ]
        localNotification.userInfo = infoDict
        print("create notification from app delegate");
        localNotification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.shared.presentLocalNotificationNow(localNotification)
        
        return localNotification;
    }
    
    
    func createWelcomeNotification(_ beaconWelcomeNotification: ATBeaconWelcomeNotification) -> UILocalNotification {
       
        let kLocalNotificationMessage:String! = beaconWelcomeNotification.description
        let kLocalNotificationAction:String! = beaconWelcomeNotification.title
        let localNotification:UILocalNotification = UILocalNotification()
        localNotification.alertBody = kLocalNotificationMessage
        localNotification.alertAction = kLocalNotificationAction
        
        let infoDict = [ KEY_WELCOME_NOTIFICATION_CONTENT : beaconWelcomeNotification.toJSONString() ]
        localNotification.userInfo = infoDict
        print("create notification from app delegate");
        localNotification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.shared.presentLocalNotificationNow(localNotification)
        
        return localNotification
    }
    
    
    func didReceiveNotificationContentReceived(_ _beaconContent: ATBeaconContent!) {
        let dict: [NSObject : AnyObject] = ["beaconContent" as NSObject : _beaconContent]
        let nc = NotificationCenter.default
        nc.post(name:Notification.Name(rawValue:"LocalNotificationMessageReceivedNotification"),
                object: nil,
                userInfo:dict)
        
    }
    
    func didReceiveWelcomeNotificationContentReceived(_ welcomeNotification: ATBeaconWelcomeNotification!) {
        let dict: [NSObject : AnyObject] = ["welcomeNotification" as NSObject : welcomeNotification]
        let nc = NotificationCenter.default
        nc.post(name:Notification.Name(rawValue:"LocalNotificationMessageReceivedWelcomeNotification"),
                object: nil,
                userInfo:dict)
    }

    
    
}


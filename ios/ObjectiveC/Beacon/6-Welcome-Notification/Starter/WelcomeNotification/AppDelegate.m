//
//  AppDelegate.m
//  WelcomeNotification
//
//  Created by sarra srairi on 20/12/2016.
//  Copyright © 2016 com.connecthings. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
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
    NSArray *uuids = @[@"*****UUID*******"];
    
    [self initAdtagInstanceWithUrlType:ATUrlTypeItg userLogin:@"***UUID***" userPassword:@"***PSWD***" userCompany:@"***COMPANY***" beaconArrayUuids:uuids];
    
    if([launchOptions objectForKey:@"UIApplicationLaunchOptionsLocationKey"]){}
    //To add the application to the notification center
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    return YES;
}

-(void)didReceiveNotificationContentReceived:(ATBeaconContent *)_beaconContent {
    NSDictionary* dict = [NSDictionary dictionaryWithObject: _beaconContent forKey:@"beaconContent"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BeaconNotification" object:nil userInfo:dict];
}


- (void)applicationDidBecomeActive:(UIApplication *)application{
    [super applicationDidBecomeActive:application];
    application.applicationIconBadgeNumber = 0;
}


-(UILocalNotification *)createNotification:(ATBeaconContent *)_beaconContent {
    if (_beaconContent) {
        ILog(@"create notification from app delegate");
        UILocalNotification *notification = [[UILocalNotification alloc]init];
        [notification setAlertBody:[_beaconContent getNotificationDescription]];
        if(SYSTEM_VERSION_GREATER_THAN(@"7.99")){
            [notification setAlertTitle:[_beaconContent getAlertTitle]];
        }
        
        NSDictionary *infoDict = [NSDictionary dictionaryWithObject:[_beaconContent toJSONString] forKey:KEY_NOTIFICATION_CONTENT];
        [notification setUserInfo:infoDict];
        
        [[UIApplication sharedApplication] presentLocalNotificationNow: notification];
 
        return notification;
        
    }
    return nil;
}
 

@end

//
//  AppDelegate.m
//  QuickStart
//
//  Created by sarra srairi on 22/03/2016.
//  Copyright © 2016 sarra srairi. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

/*** MUST KNOW !!
  IF YOU WILL IMPLEMENT THE applicationDidBecomeActive METHOD YOU SHOULD ADD [super applicationDidBecomeActive:application];
    -   the super method will activate the range in your project
*/

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // HELP:
    // init the adtag platforme with the
    // ** user Login : Login delivred by the Connecthings staff
    // ** user Password : Password delivred by the Connecthings staff
    // ** user Compagny : ....
    // ** beaconUuid : - UUID beacon number devivred by the Connecthings staff
    //
    NSArray *uuids = @[@"B0462602-CBF5-4ABB-87DE-B05340DCCBC5"];
    
    [self initAdtagInstanceWithUrlType:ATUrlTypeItg userLogin:@"User_cbeacon" userPassword:@"fSKbCEvCDCbYTDlk" userCompany:@"ccbeacondemo" beaconArrayUuids:uuids];
    [[ATBeaconManager sharedInstance] registerNotificationContentDelegate:self];
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application{
    [super applicationDidBecomeActive:application];
}


-(void) application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    [super application:application didReceiveLocalNotification:notification];
}

-(void)didReceiveNotificationContentReceived:(ATBeaconContent *)_beaconContent {
    // redirect to the correct ViewController - in our case there is just one ViewController, so it's not necessary
}

@end

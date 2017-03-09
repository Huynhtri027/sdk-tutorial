//
//  ViewController.m
//  QuickStart
//
//  Created by sarra srairi on 22/03/2016.
//  Copyright © 2016 sarra srairi. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    NSString *feedStatusString;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    beaconManager = [ATBeaconManager sharedInstance];
    // Register Range Delegate protocol to your view
    [beaconManager registerAdtagRangeDelegate:self];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)didRangeBeacons:(NSArray *)_beacons beaconContents:(NSArray *)_beaconContents informationStatus:(ATRangeInformationStatus)informationStatus feedStatus:(ATRangeFeedStatus)feedstatus region:(CLRegion *)region{
  
    feedStatusString=@"";
    switch(feedstatus){
        case ATRangeFeedStatusInProgress:
            feedStatusString = @"IN_PROGRESS";
            break;
        case ATRangeFeedStatusBackendError:
            feedStatusString= @"BACKEND_ERROR";
            break;
        case ATRangeFeedStatusNetworkError:
            feedStatusString = @"NETWORK_ERROR";
            break;
        case ATRangeFeedStatusBackendSuccess:
            feedStatusString = @"BACKEND_SUCCESS";
            break;
    }
    
    _txt_nbrBeacon.text =[NSString stringWithFormat:NSLocalizedString(@"beaconArrounds", @""),feedStatusString,_beacons.count,_beaconContents.count];
}

@end

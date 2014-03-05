//
//  JCDetectViewController.h
//  iBeaconLite
//
//  Created by João Carreira on 03/03/14.
//  Copyright (c) 2014 João Carreira. All rights reserved.
//

#import <UIKit/UIKit.h>

// import needed to work as receiver of iBeacons
#import <CoreLocation/CoreLocation.h>

@interface JCDetectViewController : UIViewController

@property (nonatomic, weak) IBOutlet UILabel *trackingStatusLabel;
@property (nonatomic, weak) IBOutlet UILabel *proximityUuidLabel;
@property (nonatomic, weak) IBOutlet UILabel *majorLabel;
@property (nonatomic, weak) IBOutlet UILabel *minorLabel;
@property (nonatomic, weak) IBOutlet UILabel *accuracyLabel;
@property (nonatomic, weak) IBOutlet UILabel *distanceLabel;
@property (nonatomic, weak) IBOutlet UILabel *rssiLabel;

@end

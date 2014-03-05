//
//  JCTransmitViewController.h
//  iBeaconLite
//
//  Created by João Carreira on 03/03/14.
//  Copyright (c) 2014 João Carreira. All rights reserved.
//

#import <UIKit/UIKit.h>

// imports needed to work as iBeacon transmitter
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface JCTransmitViewController : UIViewController

@property (nonatomic, weak) IBOutlet UILabel *uuidLabel;
@property (nonatomic, weak) IBOutlet UILabel *majorLabel;
@property (nonatomic, weak) IBOutlet UILabel *minorLabel;
@property (nonatomic, weak) IBOutlet UILabel *identityLabel;

@end

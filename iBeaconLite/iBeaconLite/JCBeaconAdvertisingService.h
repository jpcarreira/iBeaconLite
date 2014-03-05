//
//  JCBeaconAdvertisingService.h
//  iBeaconLite
//
//  Created by João Carreira on 03/03/14.
//  Copyright (c) 2014 João Carreira. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface JCBeaconAdvertisingService : NSObject

@property (nonatomic, readonly, getter = isAdvertising) BOOL advertising;
@property (nonatomic, readonly, getter = getBeaconRegion) CLBeaconRegion *beaconRegion;


+(JCBeaconAdvertisingService *)sharedInstance;

-(void)startAdvertisingWithUUID:(NSUUID *)uuid withMajor:(CLBeaconMajorValue)major withMinor:(CLBeaconMinorValue)minor;
-(void)stopAdverstising;

@end

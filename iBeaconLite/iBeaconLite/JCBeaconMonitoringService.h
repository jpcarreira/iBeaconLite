//
//  JCBeaconMonitoringService.h
//  iBeaconLite
//
//  Created by João Carreira on 05/03/14.
//  Copyright (c) 2014 João Carreira. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface JCBeaconMonitoringService : NSObject

@property (nonatomic, readonly, getter = getLocationManager) CLLocationManager *locationManager;
@property (nonatomic, readonly, getter = getBeaconRegion) CLBeaconRegion *beaconRegion;

+(JCBeaconMonitoringService *)sharedInstance;

-(void)startMonitoringBeaconWithUUID:(NSUUID *)uuid major:(CLBeaconMajorValue)major minor:(CLBeaconMinorValue)minor identifier:(NSString *)identifier onEntry:(BOOL)entry onExit:(BOOL)exit;
-(void)stopMonitoringAllRegions;

@end

//
//  JCBeaconMonitoringService.m
//  iBeaconLite
//
//  Created by João Carreira on 05/03/14.
//  Copyright (c) 2014 João Carreira. All rights reserved.
//

#import "JCBeaconMonitoringService.h"

@interface JCBeaconMonitoringService()

@property (nonatomic, readwrite, getter = getLocationManager) CLLocationManager *locationManager;
@property (nonatomic, readwrite, getter = getBeaconRegion) CLBeaconRegion *beaconRegion;

@end


@implementation JCBeaconMonitoringService


+(JCBeaconMonitoringService *)sharedInstance
{
    static dispatch_once_t onceToken;
    static JCBeaconMonitoringService *_sharedInstance;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}


-(instancetype)init
{
    self = [super init];
    if(!self)
    {
        return nil;
    }
    self.locationManager = [[CLLocationManager alloc] init];

    return self;
}


# pragma mark - Instance methods

-(void)startMonitoringBeaconWithUUID:(NSUUID *)uuid major:(CLBeaconMajorValue)major minor:(CLBeaconMinorValue)minor identifier:(NSString *)identifier onEntry:(BOOL)entry onExit:(BOOL)exit
{
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid major:major minor:minor identifier:identifier];
    
    self.beaconRegion.notifyOnEntry = entry;
    self.beaconRegion.notifyOnExit = exit;
    self.beaconRegion.notifyEntryStateOnDisplay = YES;
    
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
}


-(void)stopMonitoringAllRegions
{
    for(CLRegion *region in _locationManager.monitoredRegions)
    {
        [_locationManager stopMonitoringForRegion:region];
    }
}

@end

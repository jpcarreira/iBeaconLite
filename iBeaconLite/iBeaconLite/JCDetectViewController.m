//
//  JCDetectViewController.m
//  iBeaconLite
//
//  Created by João Carreira on 03/03/14.
//  Copyright (c) 2014 João Carreira. All rights reserved.
//

#import "JCDetectViewController.h"
#import "JCBeaconMonitoringService.h"

//static NSString *uuidString = @"43D58CBC-9EFF-4E63-A5E5-ED8EEE7F1B41";
static NSString *uuidString = @"45DDDA98-2F19-11E3-89D9-F23C91AEC05E";


@interface JCDetectViewController ()<CLLocationManagerDelegate>

@end


@implementation JCDetectViewController
{
    // ivar
    JCBeaconMonitoringService *_monitoringService;
    CLLocationManager *_locationManager;
    CLBeaconRegion *_beaconRegion;
}


#pragma mark - Standard methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _monitoringService = [JCBeaconMonitoringService sharedInstance];
    [_monitoringService stopMonitoringAllRegions];
    
    _locationManager = [_monitoringService getLocationManager];
    _locationManager.delegate = self;
    
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:uuidString];
    [_monitoringService startMonitoringBeaconWithUUID:uuid major:0 minor:1 identifier:@"com.jpcarreira.ibeacon" onEntry:YES onExit:YES];
    
    _beaconRegion = [_monitoringService getBeaconRegion];
    
    // this allows to call didStartMonitoringForRegion with no need to exit the region first
    [self locationManager:_locationManager  didStartMonitoringForRegion:_beaconRegion];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    [_locationManager startRangingBeaconsInRegion:_beaconRegion];
}


-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    [_locationManager stopRangingBeaconsInRegion:_beaconRegion];
    
    self.trackingStatusLabel.text = @"Left beacon region";
}


-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    // getting the last beacon passed as argument (for test purpose only)
    CLBeacon *beacon = [[CLBeacon alloc] init];
    beacon = [beacons lastObject];
    
    self.trackingStatusLabel.text = @"Got a beacon";
    self.proximityUuidLabel.text = beacon.proximityUUID.UUIDString;
    self.majorLabel.text = [NSString stringWithFormat:@"%@", beacon.major];
    self.minorLabel.text = [NSString stringWithFormat:@"%@", beacon.minor];
    self.accuracyLabel.text = [NSString stringWithFormat:@"%f", beacon.accuracy];
    
    
    CLProximity proximity = beacon.proximity;
    if(proximity == CLProximityUnknown)
    {
        self.distanceLabel.text = @"Unknown proximity";
    }
    else if(proximity == CLProximityImmediate)
    {
        self.distanceLabel.text = @"Immediate";
    }
    else if(proximity == CLProximityNear)
    {
        self.distanceLabel.text = @"Near";
    }
    else if(proximity == CLProximityFar)
    {
        self.distanceLabel.text = @"Far";
    }
    
    self.rssiLabel.text = [NSString stringWithFormat:@"%i", beacon.rssi];
}


-(void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
   [_locationManager startRangingBeaconsInRegion:_beaconRegion];
    
    self.trackingStatusLabel.text = @"searching ...";
}

@end

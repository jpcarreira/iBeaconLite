//
//  JCTransmitViewController.m
//  iBeaconLite
//
//  Created by João Carreira on 03/03/14.
//  Copyright (c) 2014 João Carreira. All rights reserved.
//

#import "JCTransmitViewController.h"
#import "JCBeaconAdvertisingService.h"

static NSString *uuidString = @"43D58CBC-9EFF-4E63-A5E5-ED8EEE7F1B41";

@interface JCTransmitViewController ()

@property (nonatomic, strong) CLBeaconRegion *beaconRegion;

@end

@implementation JCTransmitViewController
{
    // ivars
    CLBeaconRegion *_beaconRegion;
    NSDictionary *_beaconPeripheralData;
    CBPeripheralManager *_peripheralManager;
    JCBeaconAdvertisingService *_advertisingService;
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
	
    [self initBeacon];
    [self updateUI];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


-(void)dealloc
{
    NSLog(@"Dealloc %@", self);
}


#pragma mark - Instance methods


// updates user interface
-(void)updateUI
{
    self.uuidLabel.text = [NSString stringWithFormat: @"%@", _beaconRegion.proximityUUID.UUIDString];
    self.majorLabel.text = [NSString stringWithFormat:@"%@", _beaconRegion.major];
    self.minorLabel.text = [NSString stringWithFormat:@"%@", _beaconRegion.minor];
    self.identityLabel.text = [NSString stringWithFormat: @"%@", _beaconRegion.identifier];
}


-(void)initBeacon
{
    // the following UUID was generated in the terminal w/ uuidgen
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:uuidString];
    
    // using the advertising beacons singleton
    _advertisingService = [JCBeaconAdvertisingService sharedInstance];
    [_advertisingService startAdvertisingWithUUID:uuid withMajor:1 withMinor:1];
    
    NSLog(@"controller with object %@", _advertisingService);
}

@end

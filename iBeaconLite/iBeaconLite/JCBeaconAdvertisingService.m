//
//  JCBeaconAdvertisingService.m
//  iBeaconLite
//
//  Created by João Carreira on 03/03/14.
//  Copyright (c) 2014 João Carreira. All rights reserved.
//

#import "JCBeaconAdvertisingService.h"
#import <CoreBluetooth/CoreBluetooth.h>

// beacon identifier
NSString *const kBeaconIdentifier = @"com.jpcarreira.iBeaconLite";
NSString *const kBluetoothErrorIdentifier = @"com.jpcarreira.bluetoothstate";

@interface JCBeaconAdvertisingService()<CBPeripheralManagerDelegate>

@property (nonatomic, readwrite, getter = isAdvertising) BOOL advertising;
@property (nonatomic, readwrite, getter = getBeaconRegion) CLBeaconRegion *beaconRegion;

@end


@implementation JCBeaconAdvertisingService
{
    // ivars
    CBPeripheralManager *_peripheralManager;
}


#pragma mark - Standard methods

-(instancetype)init
{
    self = [super init];
    if(!self)
    {
        return nil;
    }
    
    // allocating and initializing a CBPeripheralManager instance by setting its delegate to self and using a default priority dispatch queue and assigning it to the ivar
    _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    
    return self;
}


-(void)dealloc
{
    NSLog(@"Killed ibeacon advertiser %@", self);
}

#pragma mark - Instance methods

+(JCBeaconAdvertisingService *)sharedInstance
{
    static JCBeaconAdvertisingService *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    NSLog(@"Advertiser Singleton created!");
    
    return sharedInstance;
}


-(void)startAdvertisingWithUUID:(NSUUID *)uuid withMajor:(CLBeaconMajorValue)major withMinor:(CLBeaconMinorValue)minor
{
    NSError *bluetoothStateError = nil;
    
    // checking the state of the CBPeripheralManager
    if(![self bluetoothStateIsValid:&bluetoothStateError])
    {
        [[[UIAlertView alloc] initWithTitle:@"Bluetooth Issue" message:bluetoothStateError.userInfo[@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        
        // if there's an error there's no point in continuing and we return
        return;
    }
     
    // calling the appropriate init according to values passed to this method
    
    if(uuid && major && minor)
    {
        self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid major:major minor:minor identifier:kBeaconIdentifier];
    }
    else if(uuid && major)
    {
        self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid major:major identifier:kBeaconIdentifier];
    }
    else if(uuid)
    {
        self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:kBeaconIdentifier];
    }
    else
    {
        [NSException raise:@"Please provide at least the UUID" format:nil];
    }
    
    // once we're sure we have a valid CLBeaconRegion object we can request peripheral data from it
    // (nil as parameter means we'll use the standard power level)
    NSDictionary *peripheralData = [self.beaconRegion peripheralDataWithMeasuredPower:nil];
    
    // the peripheral data is passed to the PeripheralManager that broadcasts it over bluetooth
    [_peripheralManager startAdvertising:peripheralData];
}


-(void)stopAdverstising
{
    [_peripheralManager stopAdvertising];
    self.advertising = NO;
}


-(BOOL)bluetoothStateIsValid:(NSError **)error
{
    BOOL bluetoothStateIsValid = YES;
    
    switch (_peripheralManager.state)
    {
        case CBPeripheralManagerStatePoweredOff:
            if(error != nil)
            {
                *error = [NSError errorWithDomain:kBluetoothErrorIdentifier
                            code:CBPeripheralManagerStatePoweredOff
                            userInfo:@{@"message": @"You must turn Bluetooth on in order to use the beacon feature."}];
            }
            bluetoothStateIsValid = NO;
            break;
            
        case CBPeripheralManagerStateResetting:
            if(error != nil)
            {
                *error = [NSError errorWithDomain:kBluetoothErrorIdentifier
                            code:CBPeripheralManagerStateResetting
                            userInfo:@{@"message": @"Bluetooth has reseted, please try again in a few moments"}];
            }
            bluetoothStateIsValid = NO;
            break;
            
        case CBPeripheralManagerStateUnauthorized:
            if(error != nil)
            {
                *error = [NSError errorWithDomain:kBluetoothErrorIdentifier
                            code:CBPeripheralManagerStateUnauthorized
                            userInfo:@{@"message": @"This application is not authorized to use Bluetooth, please check your system's settings"}];
            }
            bluetoothStateIsValid = NO;
            break;
        
        case CBPeripheralManagerStateUnknown:
            if(error != nil)
            {
                *error = [NSError errorWithDomain:kBluetoothErrorIdentifier
                                             code:CBPeripheralManagerStateUnknown
                                         userInfo:@{@"message": @"Bluetooth is not available at this time, please try again in a few moments"}];
            }
            bluetoothStateIsValid = NO;
            break;
            
        case CBPeripheralManagerStateUnsupported:
            if(error != nil)
            {
                *error = [NSError errorWithDomain:kBluetoothErrorIdentifier
                                             code:CBPeripheralManagerStateUnsupported
                                         userInfo:@{@"message": @"Your device doesn't support bluetooth, you won't be able to use iBeacons"}];
            }
            bluetoothStateIsValid = NO;
            break;
            
        case CBPeripheralManagerStatePoweredOn:
            bluetoothStateIsValid = YES;
            break;
    }
    
    return bluetoothStateIsValid;
}


#pragma mark - CBPeripheralManagerDelegate

// this delegate method is called by the CBPeripheralManager when it's state changes and we'll use it to let the user know
// if the bluetooth peripheral is in a valid state or not
-(void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    NSError *bluetoothStateError = nil;
    if(![self bluetoothStateIsValid:&bluetoothStateError])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *bluetoothIssueAlert = [[UIAlertView alloc] initWithTitle:@"Bluetooth Issue" message:bluetoothStateError.userInfo[@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [bluetoothIssueAlert show];
        });
    }
}


// this method is called when startAdvertising: is called
-(void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
       if(error)
       {
           [[[UIAlertView alloc] initWithTitle:@"Cannot Advertise Beacon" message:@"There was an issue starting the advertisement of your beacon." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
           NSLog(@"Error: %@", error);
       }
       else
       {
           NSLog(@"Advertising!");
           self.advertising = YES;
       }
    });
}

@end

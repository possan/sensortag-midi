//
//  SensorPoller.m
//  SensorTagMidi
//
//  Created by Per-Olov Jernberg on 2014-05-11.
//  Copyright (c) 2014 Per-Olov Jernberg. All rights reserved.
//

#import "SensorPoller.h"

@implementation SensorPoller {
    NSString *targetUrl;
    NSMutableArray *devices;
    int pollindex;
    CBCentralManager *manager;
    // CBPeripheral *peripheral;
    NSMutableArray *peripherals;
}

- (id) init {
    if (self = [super init]) {
        
    }
    self->devices = [NSMutableArray array];
    self->peripherals = [NSMutableArray array];
    self->pollindex = 0;
    self->targetUrl = @"";
    return self;
}

- (void) setTarget:(NSString *)url {
    NSLog(@"Set target url: %@", url);
    self->targetUrl = [NSString stringWithString:url];
}

- (void) addDevice:(NSString *)address {
    [self->devices addObject:address];
}


- (void) poll:(NSString *) address {
    NSLog(@"Connect to %@", address);
    
    
   //  [manager connectPeripheral:peripheral options:nil];
    
    
}

- (void) pollNext {
    NSString *address = nil;
    int max = (int)[self->devices count];
    if (max > 0) {
        address = (NSString *)[self->devices objectAtIndex:(pollindex % max)];
    }
    pollindex ++;
    if (address != nil) {
        [self poll:address];
        // [self performSelector:@selector(pollNext) withObject:self afterDelay:1.0];
       //  peripheral = [[CBPeripheral alloc] init];
    }
}

- (void) start {
 //   [self pollNext];
}

- (void) run {
    
    dispatch_queue_t queue;
    queue = dispatch_queue_create("com.example.MyQueue", NULL);
    
    
    self->manager = [[CBCentralManager alloc] initWithDelegate:self queue:queue];
    sleep(1);
    while(true) {
     //z   [self pollNext];
        sleep(1);
    }
}

- (void) startScan {
    NSLog(@"startScan");
    [manager scanForPeripheralsWithServices:nil options:nil];
}

- (void) stopScan {
    NSLog(@"stopScan");
}

#pragma mark - CBCentralManager delegate methods
/*
 Invoked whenever the central manager's state is updated.
 */
- (void) centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSLog(@"centralManagerDidUpdateState = %d", (int)central.state);
    //   [self isLECapableHardware];
    
    if(central.state==CBCentralManagerStatePoweredOn)
    {
        //Now do your scanning and retrievals
        [self startScan];
    }
}

/*
 Invoked when the central discovers heart rate peripheral while scanning.
 */
- (void) centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)aPeripheral
      advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"didDiscoverPeripheral %@ %@", aPeripheral.name, aPeripheral.identifier);
    if ([aPeripheral.name isEqualTo:@"SensorTag"]) {
   //     [self stopScan];
        [peripherals addObject:aPeripheral];
        [self->manager connectPeripheral:aPeripheral options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey]];
      //  [self->manager retrievePeripherals:[NSArray arrayWithObject:aPeripheral.UUID]];
    }
//    NSMutableArray *peripherals = [self mutableArrayValueForKey:@"heartRateMonitors"];
//    if( ![self.heartRateMonitors containsObject:aPeripheral] )
//        [peripherals addObject:aPeripheral];
//    
//    /* Retreive already known devices */
//    if(autoConnect)
//    {
    
//    }
}

/*
 Invoked when the central manager retrieves the list of known peripherals.
 Automatically connect to first known peripheral
 */
- (void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals
{
    NSLog(@"Retrieved peripherals.");
//    
//    [self stopScan];
//    
//    /* If there are any known devices, automatically connect to it.*/
//    if([peripherals count] >=1)
//    {
//        [indicatorButton setHidden:FALSE];
//        [progressIndicator setHidden:FALSE];
//        [progressIndicator startAnimation:self];
//        peripheral = [peripherals objectAtIndex:0];
//        [peripheral retain];
//        [connectButton setTitle:@"Cancel"];
//        [manager connectPeripheral:peripheral options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey]];
//    }
}

/*
 Invoked whenever a connection is succesfully created with the peripheral.
 Discover available services on the peripheral
 */
- (void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)aPeripheral
{
    NSLog(@"Connected to peripheral %@", aPeripheral.identifier);

    [aPeripheral setDelegate:self];
    [aPeripheral discoverServices:nil];
//
//	self.connected = @"Connected";
//    [connectButton setTitle:@"Disconnect"];
//    [indicatorButton setHidden:TRUE];
//    [progressIndicator setHidden:TRUE];
//    [progressIndicator stopAnimation:self];
}

/*
 Invoked whenever an existing connection with the peripheral is torn down.
 Reset local variables
 */
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)aPeripheral error:(NSError *)error
{
    NSLog(@"Disconnected from peripheral %@", aPeripheral.identifier);
//	self.connected = @"Not connected";
//    [connectButton setTitle:@"Connect"];
//    self.manufacturer = @"";
//    self.heartRate = 0;

    // reconnect immediately
    [self->manager connectPeripheral:aPeripheral options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey]];

    /*
    if( peripheral )
    {
        [peripheral setDelegate:nil];
        [peripheral release];
        peripheral = nil;
    }
    */
}

/*
 Invoked whenever the central manager fails to create a connection with the peripheral.
 */
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)aPeripheral error:(NSError *)error
{
    NSLog(@"Fail to connect to peripheral: %@ with error = %@", aPeripheral, [error localizedDescription]);
//    [connectButton setTitle:@"Connect"];
//    if( peripheral )
//    {
//        [peripheral setDelegate:nil];
//        [peripheral release];
//        peripheral = nil;
//    }
}

#pragma mark - CBPeripheral delegate methods
/*
 Invoked upon completion of a -[discoverServices:] request.
 Discover available characteristics on interested services
 */
- (void) peripheral:(CBPeripheral *)aPeripheral didDiscoverServices:(NSError *)error
{
    for (CBService *aService in aPeripheral.services)
    {
        NSLog(@"Service found with UUID: %@", aService.UUID);
        
        if ([aService.UUID isEqual:[CBUUID UUIDWithString:@"f000aa10-0451-4000-b000-000000000000"]])
        {
            [aPeripheral discoverCharacteristics:nil forService:aService];
        }

        if ([aService.UUID isEqual:[CBUUID UUIDWithString:@"180A"]])
        {
            [aPeripheral discoverCharacteristics:nil forService:aService];
        }
        
        if ( [aService.UUID isEqual:[CBUUID UUIDWithString:CBUUIDGenericAccessProfileString]] )
        {
            [aPeripheral discoverCharacteristics:nil forService:aService];
        }
    }
}

/*
 Invoked upon completion of a -[discoverCharacteristics:forService:] request.
 Perform appropriate operations on interested characteristics
 */
- (void) peripheral:(CBPeripheral *)aPeripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    NSLog(@"didDiscoverCharacteristicsForService %@", service);
//    if ([service.UUID isEqual:[CBUUID UUIDWithString:@"180D"]])
//    {
//        for (CBCharacteristic *aChar in service.characteristics)
//        {
//            /* Set notification on heart rate measurement */
//            if ([aChar.UUID isEqual:[CBUUID UUIDWithString:@"2A37"]])
//            {
//                [peripheral setNotifyValue:YES forCharacteristic:aChar];
//                NSLog(@"Found a Heart Rate Measurement Characteristic");
//            }
//            /* Read body sensor location */
//            if ([aChar.UUID isEqual:[CBUUID UUIDWithString:@"2A38"]])
//            {
//                [aPeripheral readValueForCharacteristic:aChar];
//                NSLog(@"Found a Body Sensor Location Characteristic");
//            }
//            
//            /* Write heart rate control point */
//            if ([aChar.UUID isEqual:[CBUUID UUIDWithString:@"2A39"]])
//            {
//                uint8_t val = 1;
//                NSData* valData = [NSData dataWithBytes:(void*)&val length:sizeof(val)];
//                [aPeripheral writeValue:valData forCharacteristic:aChar type:CBCharacteristicWriteWithResponse];
//            }
//        }
//    }
//    
    for (CBCharacteristic *aChar in service.characteristics)
    {
        NSLog(@"found characteristic with UUID %@", aChar.UUID);
    }
    
    if ([service.UUID isEqual:[CBUUID UUIDWithString:@"f000aa10-0451-4000-b000-000000000000"]])
    {
        for (CBCharacteristic *aChar in service.characteristics)
        {
            NSLog(@"found sensortag characteristic %@", aChar.UUID);

            if ([aChar.UUID isEqual:[CBUUID UUIDWithString:@"f000aa11-0451-4000-b000-000000000000"]])
            {
                // [peripheral setDelegate:self];
                [aPeripheral setNotifyValue:YES forCharacteristic:aChar];
                // [aPeripheral readValueForCharacteristic:aChar];
                NSLog(@"Found a data Measurement Characteristic");
            }
            
            /* Write heart rate control point */
            if ([aChar.UUID isEqual:[CBUUID UUIDWithString:@"f000aa12-0451-4000-b000-000000000000"]])
            {
                NSLog(@"Enable characteristic");
                uint8_t val = 1;
                NSData* valData = [NSData dataWithBytes:(void*)&val length:sizeof(val)];
                [aPeripheral writeValue:valData forCharacteristic:aChar type:CBCharacteristicWriteWithResponse];
            }
            
            /* Write heart rate control point */
            if ([aChar.UUID isEqual:[CBUUID UUIDWithString:@"f000aa13-0451-4000-b000-000000000000"]])
            {
                NSLog(@"Set interval");
                uint8_t val = 15;
                NSData* valData = [NSData dataWithBytes:(void*)&val length:sizeof(val)];
                [aPeripheral writeValue:valData forCharacteristic:aChar type:CBCharacteristicWriteWithResponse];
            }
        }
    }
//
    if ( [service.UUID isEqual:[CBUUID UUIDWithString:CBUUIDGenericAccessProfileString]] )
    {
        for (CBCharacteristic *aChar in service.characteristics)
        {
            /* Read device name */
            if ([aChar.UUID isEqual:[CBUUID UUIDWithString:CBUUIDDeviceNameString]])
            {
                [aPeripheral readValueForCharacteristic:aChar];
                NSLog(@"Found a Device Name Characteristic");
            }
        }
    }

    if ([service.UUID isEqual:[CBUUID UUIDWithString:@"180A"]])
    {
        for (CBCharacteristic *aChar in service.characteristics)
        {
            /* Read manufacturer name */
            if ([aChar.UUID isEqual:[CBUUID UUIDWithString:@"2A29"]])
            {
                [aPeripheral readValueForCharacteristic:aChar];
                NSLog(@"Found a Device Manufacturer Name Characteristic");
            }
        }
    }
}

- (void) sendJSON:(NSString *)json {
    NSURL *url = [NSURL URLWithString:targetUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[json dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    // NSLog(@"responseData: %@", responseData);
}

/*
 Invoked upon completion of a -[readValueForCharacteristic:] request or on the reception of a notification/indication.
 */
- (void) peripheral:(CBPeripheral *)aPeripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    /* Updated value for heart rate measurement received */
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"f000aa11-0451-4000-b000-000000000000"]]) {
        NSData * updatedValue = characteristic.value;
        // NSLog(@"Got sensor data %@ - %d bytes", updatedValue, (int)updatedValue.length);
        unsigned char *bytes = (unsigned char *)[updatedValue bytes];
        // for(int i=0; i<updatedValue.length; i++) {
        //    NSLog(@"byte[%d] = %d", i, bytes[i]);
        // }
        float x = (signed char)bytes[0] / 64.0f;
        float y = (signed char)bytes[1] / 64.0f;
        float z = -(signed char)bytes[2] / 64.0f;
        NSLog(@"%@ x=%f, y=%f, z=%f", aPeripheral.identifier, x, y, z);
        
        NSString *str = [NSString stringWithFormat:@"{\"id\":\"%@\",\"x\":%f,\"y\":%f,\"z\":%f}",
                         [aPeripheral.identifier UUIDString], x, y, z];
        [self sendJSON:str];
    }
//
//    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A37"]])
//    {
//        if( (characteristic.value)  || !error )
//        {
//            /* Update UI with heart rate data */
//            [self updateWithHRMData:characteristic.value];
//        }
//    }
//    /* Value for body sensor location received */
//    else  if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A38"]])
//    {
//        NSData * updatedValue = characteristic.value;
//        uint8_t* dataPointer = (uint8_t*)[updatedValue bytes];
//        if(dataPointer)
//        {
//            uint8_t location = dataPointer[0];
//            NSString*  locationString;
//            switch (location)
//            {
//                case 0:
//                    locationString = @"Other";
//                    break;
//                case 1:
//                    locationString = @"Chest";
//                    break;
//                case 2:
//                    locationString = @"Wrist";
//                    break;
//                case 3:
//                    locationString = @"Finger";
//                    break;
//                case 4:
//                    locationString = @"Hand";
//                    break;
//                case 5:
//                    locationString = @"Ear Lobe";
//                    break;
//                case 6:
//                    locationString = @"Foot";
//                    break;
//                default:
//                    locationString = @"Reserved";
//                    break;
//            }
//            NSLog(@"Body Sensor Location = %@ (%d)", locationString, location);
//        }
//    }
//    /* Value for device Name received */
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:CBUUIDDeviceNameString]])
    {
        NSString * deviceName = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
        NSLog(@"Device Name = %@", deviceName);
    }
    
    /* Value for manufacturer name received */
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A29"]])
    {
        NSString * manufacturer = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
        NSLog(@"Manufacturer Name = %@", manufacturer);
    }
}



@end

//
//  SensorPoller.h
//  SensorTagMidi
//
//  Created by Per-Olov Jernberg on 2014-05-11.
//  Copyright (c) 2014 Per-Olov Jernberg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IOBluetooth/IOBluetooth.h>

@interface SensorPoller : NSObject<CBCentralManagerDelegate, CBPeripheralDelegate>

- (void) setTarget:(NSString *)url;
- (void) addDevice:(NSString *)address;
- (void) start;
- (void) run;

@end

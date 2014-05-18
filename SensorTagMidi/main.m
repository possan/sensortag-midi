//
//  main.m
//  SensorTagMidi
//
//  Created by Per-Olov Jernberg on 2014-05-11.
//  Copyright (c) 2014 Per-Olov Jernberg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SensorPoller.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        // insert code here...
        NSLog(@"Hello, World!");
        if( argc > 1) {
            NSString *firstarg = [NSString stringWithCString:argv[1] encoding:kCFStringEncodingUTF8];
            NSLog(@"first arg %@", firstarg);
            if ([firstarg isEqualTo:@"scan"]) {
                
            }
            if ([firstarg isEqualTo:@"poll"]) {
                if (argc > 2) {
                    SensorPoller *poller = [[SensorPoller alloc] init];
                    
                    NSString *url = [NSString stringWithCString:argv[2] encoding:kCFStringEncodingUTF8];
                    [poller setTarget:url];
                    
                    [poller run];
                }
            }
        }
    }
    return 0;
}


//
//  Request.m
//  fbPhotoView
//
//  Created by Fenkins on 01/04/16.
//  Copyright © 2016 Fenkins. All rights reserved.
//

#import "Request.h"

@implementation Request
- (instancetype)init
{
    self = [super init];
    if (self) {
        if (self.requestType) {
            NSString* target = self.requestType;
            if ([target isEqualToString:@"albums"]) {
                NSLog(@"Albums requested, proceeding...");
                
            }
            if ([target isEqualToString:@"album"]) {
                NSLog(@"Album content requested, proceeding...");
                
            }
            if ([target isEqualToString:@"photo"]) {
                NSLog(@"Photo requested, proceeding");
                
            } else {
                NSLog(@"No occurence found \n Please select between albums/album or photo in requestType property \n   terminating now...");
            }
        }
    }
    return self;
}
@end

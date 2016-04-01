//
//  Request.h
//  fbPhotoView
//
//  Created by Fenkins on 01/04/16.
//  Copyright © 2016 Fenkins. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Request : NSObject
@property (nonatomic) NSString* requestType;
@property (nonatomic) NSString* requestGraphPath;
@property (nonatomic) NSDictionary* requestParams;
@end

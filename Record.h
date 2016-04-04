//
//  PhotoRecord.h
//  fbPhotoView
//
//  Created by Fenkins on 03/04/16.
//  Copyright © 2016 Fenkins. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Record : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, strong) NSDictionary *sizes;
@property (nonatomic, strong) NSString *preferableImageLink;
@end

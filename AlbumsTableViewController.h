//
//  PhotosTableViewController.h
//  fbPhotoView
//
//  Created by Fenkins on 28/03/16.
//  Copyright © 2016 Fenkins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "Record.h"
#import "IconDownloader.h"

@interface AlbumsTableViewController : UITableViewController

// the main data model for our UITableView
@property (nonatomic, strong) NSArray *entries;

@end
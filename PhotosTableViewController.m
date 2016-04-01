//
//  PhotosTableViewController.m
//  fbPhotoView
//
//  Created by Fenkins on 28/03/16.
//  Copyright © 2016 Fenkins. All rights reserved.
//

#import "PhotosTableViewController.h"

@interface PhotosTableViewController ()

@end

@implementation PhotosTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Request *req = [Request alloc];
    req.requestType = @"album";
    [req init];
    
    NSDictionary *params = @{@"fields": @"description"};
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:@"/me/albums"
                                  parameters:params
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {

        // We got albums ID, now its time for load some photos
        for (NSString* everyKey in [result objectForKey:@"data"]) {
            NSCharacterSet* doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"}{\n ;id="];
            NSString* graphPath =  [[[NSString stringWithFormat:@"/%@/photos",everyKey]componentsSeparatedByCharactersInSet:doNotWant]componentsJoinedByString:@""];
            
            
            NSLog(@"%@",graphPath);
            NSDictionary *params = @{@"fields": @"source"};
            FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                          initWithGraphPath:graphPath
                                          parameters:params
                                          HTTPMethod:@"GET"];
            [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                                  id result,
                                                  NSError *error) {
                //NSLog(@"%@",result);
                for (NSDictionary* everyKey in [result objectForKey:@"data"]) {
                    // Here we got an array containing ID and Source
                    
                    NSLog(@"ID %@",[everyKey objectForKey:@"id"]);
                    NSLog(@"Source %@",[everyKey objectForKey:@"source"]);
                    
//                    NSCharacterSet* doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"}{\n ;id="];
//                    NSString* graphPath =  [[[NSString stringWithFormat:@"/%@",everyKey]componentsSeparatedByCharactersInSet:doNotWant]componentsJoinedByString:@""];
//                    //NSLog(@"GraphPath %@",graphPath);
//                    NSDictionary *params = @{@"fields": @"images"};
//                    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
//                                                  initWithGraphPath:graphPath
//                                                  parameters:params
//                                                  HTTPMethod:@"GET"];
//                    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
//                                                          id result,
//                                                          NSError *error) {
//                        NSLog(@"Result images %@",result);
//                    }];
                }
            }];
        }
    }];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)logoutButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [[FBSDKLoginManager new]logOut];
}

@end

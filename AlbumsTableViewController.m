//
//  PhotosTableViewController.m
//  fbPhotoView
//
//  Created by Fenkins on 28/03/16.
//  Copyright © 2016 Fenkins. All rights reserved.
//

#import "AlbumsTableViewController.h"

#define kCustomRowCount 7

static NSString *CellIdentifier = @"LazyTableCell";
static NSString *PlaceholderCellIdentifier = @"PlaceholderCell";

#pragma mark -
@interface AlbumsTableViewController () <UIScrollViewDelegate>
// the set of IconDownloader objects for each album
@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;
@end


@implementation AlbumsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    Request *req = [Request alloc];
//    req.requestType = @"album";
//    [req init];
    
    _imageDownloadsInProgress = [NSMutableDictionary dictionary];
    
    NSDictionary *params = @{@"fields": @"description"};
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:@"/me/albums"
                                  parameters:params
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        //NSLog(@"Albums Albums Albums %@",result);
        // We got albums ID, now its time for load some photos
        for (NSString* everyKey in [result objectForKey:@"data"]) {
            NSCharacterSet* doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"}{\n ;id="];
            NSString* graphPath =  [[[NSString stringWithFormat:@"/%@/photos",everyKey]componentsSeparatedByCharactersInSet:doNotWant]componentsJoinedByString:@""];
            
            
            //NSLog(@"%@",graphPath);
            NSDictionary *params = @{@"fields": @"source"};
            FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                          initWithGraphPath:graphPath
                                          parameters:params
                                          HTTPMethod:@"GET"];
            [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                                  id result,
                                                  NSError *error) {
                NSLog(@"Albums Albums Albums %@",result);
                for (NSDictionary* everyKey in [result objectForKey:@"data"]) {
                    // Here we got the dict containing ID and Source
                    
                    NSLog(@"ID %@",[everyKey objectForKey:@"id"]);
                    NSLog(@"Source %@",[everyKey objectForKey:@"source"]);
                    
                    NSCharacterSet* doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"}{\n ;id="];
                    NSString* graphPath =  [[[NSString stringWithFormat:@"/%@",[everyKey objectForKey:@"id"]]componentsSeparatedByCharactersInSet:doNotWant]componentsJoinedByString:@""];
                    //NSLog(@"GraphPath %@",graphPath);
                    NSDictionary *params = @{@"fields": @"images"};
                    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                                  initWithGraphPath:graphPath
                                                  parameters:params
                                                  HTTPMethod:@"GET"];
                    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                                          id result,
                                                          NSError *error) {
                        NSLog(@"Result images %@",result);
                    }];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger count = self.entries.count;
    
    // if there's no data yet, return enough rows to fill the screen
    if (count == 0)
    {
        return kCustomRowCount;
    }
    return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    NSUInteger nodeCount = self.entries.count;
    
    if (nodeCount == 0 && indexPath.row == 0)
    {
        // add a placeholder cell while waiting on table data
        cell = [tableView dequeueReusableCellWithIdentifier:PlaceholderCellIdentifier forIndexPath:indexPath];
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        // Leave cells empty if there's no data yet
        if (nodeCount > 0)
        {
            // Set up the cell representing the app
            Record *singleRecord = (self.entries)[indexPath.row];
            
            cell.textLabel.text = singleRecord.name;
            
            // Only load cached images; defer new downloads until scrolling ends
            if (!singleRecord.icon)
            {
                if (self.tableView.dragging == NO && self.tableView.decelerating == NO)
                {
                    [self startIconDownload:singleRecord forIndexPath:indexPath];
                }
                // if a download is deferred or in progress, return a placeholder image
                cell.imageView.image = [UIImage imageNamed:@"Placeholder.png"];
            }
            else
            {
                cell.imageView.image = singleRecord.icon;
            }
        }
    }
    
    return cell;
}


#pragma mark - Table cell image support

- (void)startIconDownload:(Record *)singleRecord forIndexPath:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = (self.imageDownloadsInProgress)[indexPath];
    if (iconDownloader == nil)
    {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.singleRecord = singleRecord;
        [iconDownloader setCompletionHandler:^{
            
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            
            // Display the newly loaded image
            cell.imageView.image = singleRecord.icon;
            
            // Remove the IconDownloader from the in progress list.
            // This will result in it being deallocated.
            [self.imageDownloadsInProgress removeObjectForKey:indexPath];
            
        }];
        (self.imageDownloadsInProgress)[indexPath] = iconDownloader;
        [iconDownloader startDownload];
    }
}


- (void)loadImagesForOnscreenRows
{
    if (self.entries.count > 0)
    {
        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            Record *singleRecord = (self.entries)[indexPath.row];
            
            if (!singleRecord.icon)
                // Avoid the app icon download if the app already has an icon
            {
                [self startIconDownload:singleRecord forIndexPath:indexPath];
            }
        }
    }
}



#pragma mark - UIScrollViewDelegate

// -------------------------------------------------------------------------------
//	scrollViewDidEndDragging:willDecelerate:
//  Load images for all onscreen rows when scrolling is finished.
// -------------------------------------------------------------------------------
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        [self loadImagesForOnscreenRows];
    }
}

// -------------------------------------------------------------------------------
//	scrollViewDidEndDecelerating:scrollView
//  When scrolling stops, proceed to load the app icons that are on screen.
// -------------------------------------------------------------------------------
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}




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

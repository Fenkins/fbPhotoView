//
//  ViewController.m
//  fbPhotoView
//
//  Created by Fenkins on 17/03/16.
//  Copyright © 2016 Fenkins. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <FBSDKLoginButtonDelegate>
@property (retain, nonatomic) IBOutlet FBSDKLoginButton *loginButton;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    _loginButton = [FBSDKLoginButton new];
    _loginButton.center = self.view.center;
    _loginButton.readPermissions = @[@"public_profile", @"email", @"user_friends", @"user_photos"];
    _loginButton.delegate = self;
    [self.view addSubview:_loginButton];
    
}

- (void)viewDidAppear:(BOOL)animated {
    // If we already logged in
    if ([FBSDKAccessToken currentAccessToken]){
        UINavigationController *navController = [self.storyboard instantiateViewControllerWithIdentifier:@"navControllerMain"];
        [self presentViewController:navController animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)checkLoginStatus:(id)sender {
    if ([FBSDKAccessToken currentAccessToken]){
        NSLog(@"We are good");
    }
}

#pragma mark -Login Button Delegate Methods

-(void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
    NSLog(@"didCompleteWithResult Called");
    if ([FBSDKAccessToken currentAccessToken]){
        UINavigationController *navController = [self.storyboard instantiateViewControllerWithIdentifier:@"navControllerMain"];
        [self presentViewController:navController animated:YES completion:nil];
    }
}

-(void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    NSLog(@"loginButtonDidLogOut Called");
}

@end

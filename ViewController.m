//
//  ViewController.m
//  fbPhotoView
//
//  Created by Fenkins on 17/03/16.
//  Copyright © 2016 Fenkins. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (retain, nonatomic) IBOutlet FBSDKLoginButton *loginButton;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _loginButton = [FBSDKLoginButton new];
    _loginButton.center = self.view.center;
    _loginButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    [self.view addSubview:_loginButton];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  LoginViewController.m
//  ChatClient
//
//  Created by Jagtej Sodhi on 9/16/15.
//  Copyright © 2015 Jagtej Sodhi. All rights reserved.
//

#import "LoginViewController.h"
#import "Parse.h"
#import "ChatViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailTextView;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextView;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

@end

@implementation LoginViewController
- (IBAction)signInButtonClicked:(id)sender{
    NSString *email = [self.emailTextView text];
    NSString* password = [self.passwordTextView text];
    
    [PFUser logInWithUsernameInBackground:email password:password
                                    block:^(PFUser *user, NSError *error) {
        if (user) {
            NSLog(@"User successfully logged in");
            
            [self openNextPage];
            
        } else {
            NSString *errorString = [error userInfo][@"error"];
            NSLog(@"Error when signing up: %@", errorString);
            
            UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"" message:@"Invalid Credentials"
                delegate:self cancelButtonTitle:@"Chalo next time" otherButtonTitles: nil];
            
            [alert show];
        }
    }];
}

- (void) openNextPage {
    ChatViewController* chatViewController = [[ChatViewController alloc] init];
    
    [self performSegueWithIdentifier:@"com.jagtej.sodhi.composesegue" sender:nil];
}

- (IBAction)signUpButtonClicked:(id)sender{
    NSString *email = [self.emailTextView text];
    NSString* password = [self.passwordTextView text];
    
    PFUser* user = [PFUser user];
    user.username = email;
    user.email = email;
    user.password = password;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        //code
        if (!error) {
            NSLog(@"Hooray! Let them use the app now.");
            [self openNextPage];
        }
        else {
            NSString *errorString = [error userInfo][@"error"];
            NSLog(@"Error when signing up: %@", errorString);
            
            UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Invalid Credentials" message:errorString
                                                            delegate:self cancelButtonTitle:@"Chalo next time" otherButtonTitles: nil];
            
            [alert show];
        }
    }];
    
    
   // NSLog(@"Sign up clicked");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //ChatViewController* chatViewController = [segue destinationViewController];
    
}


@end

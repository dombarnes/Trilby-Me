//
//  TMSubmitViewController.m
//  Trilby Me
//
//  Created by Dom Barnes on 27/09/2013.
//  Copyright (c) 2013 Trilby Multimedia Limited. All rights reserved.
//

#import "TMSubmitViewController.h"
#import "Reachability.h"


@interface TMSubmitViewController ()
@property (nonatomic) Reachability *hostReachability;
@property (nonatomic) NSString * MYServerURL;
@property (nonatomic) NSURL * strURL;

@end

@implementation TMSubmitViewController

#ifdef DEBUG
NSString *const MYServerURL = @"http://trilbyme.dev";
#else
NSString *const MYServerURL = @"http://trilby-me.herokuapp.com";
#endif


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) submitPhoto {
    /*
     Observe the kNetworkReachabilityChangedNotification. When that notification is posted, the method reachabilityChanged will be called.
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    //Change the host name here to change the server you want to monitor.
    NSString *remoteHostName = @"%@MYServerURL";
//    NSURL *url=[NSURL URLWithString:_strURL];
//    NSString *remoteHostLabelFormatString = NSLocalizedString(@"Remote Host: %@", @"Remote host label format string");

    
	self.hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
	[self.hostReachability startNotifier];
    
    // Post request
//    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:@"%@MYServerURL"];
//    [request setPostValue:@"Ben" forKey:@"name"];
//    [request setPostValue:@"Copsey" forKey:@"twitter"];
//    [request setPostValue:@"Your feedback" forKey:@"feedback"];
//    [request setFile:@"photo@2x.png" forKey:@"image_file"];
    
}
- (BOOL)nextTextField:(UITextField *)textField;
{
    if (textField == _nameTextField)
    {
        [_nameTextField resignFirstResponder];
        [_feedbackTextField becomeFirstResponder];
    }
    else if (textField == _feedbackTextField)
    {
        [_feedbackTextField resignFirstResponder];
        [_twitterName becomeFirstResponder];
    }
    else if (textField == _twitterName)
    {
        [_twitterName resignFirstResponder];
    }
    return YES;
}

-(IBAction)dismissKeyboard;
{
    [_nameTextField resignFirstResponder];
    [_feedbackTextField resignFirstResponder];
    [_twitterName resignFirstResponder];
}

@end

//
//  TMSubmitViewController.h
//  Trilby Me
//
//  Created by Dom Barnes on 27/09/2013.
//  Copyright (c) 2013 Trilby Multimedia Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TMSubmitViewController : UIViewController
{
    UITapGestureRecognizer *_tapRecognizer;
    UITextField *_activeField;
}

extern NSString *const MYServerURL;


@property (weak) IBOutlet UITextField *nameTextField;
@property (weak) IBOutlet UITextField *feedbackTextField;
@property (weak) IBOutlet UITextField *twitterName;


-(IBAction)dismissKeyboard;

@end

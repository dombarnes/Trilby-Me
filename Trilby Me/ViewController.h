//
//  ViewController.h
//  Trilby Me
//
//  Created by Dom Barnes on 30/07/2013.
//  Copyright (c) 2013 Trilby Multimedia Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
<UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIGestureRecognizerDelegate,UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *hatView;
@property (strong, nonatomic) IBOutlet UIImageView *photoView;

- (IBAction)cameraBtnAction:(id)sender;
- (IBAction)shareBtnAction:(id)sender;


@end

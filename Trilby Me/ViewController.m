//
//  ViewController.m
//  Trilby Me
//
//  Created by Dom Barnes on 30/07/2013.
//  Copyright (c) 2013 Trilby Multimedia Limited. All rights reserved.
//

#import "ViewController.h"
#import "TestFlight.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.hatView.userInteractionEnabled = YES;
    self.photoView.autoresizingMask = UIViewAutoresizingFlexibleHeight;

    UIPinchGestureRecognizer *pinchGestureRecogniser =
    [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchZoomHatView:)];
    pinchGestureRecogniser.delegate = self;
    [self.hatView addGestureRecognizer:pinchGestureRecogniser];
    
    UIPanGestureRecognizer *panGestureRecogniser =
    [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHatView:)];
    panGestureRecogniser.maximumNumberOfTouches = 1;
    panGestureRecogniser.delegate = self;
    [self.hatView addGestureRecognizer:panGestureRecogniser];
    
    self.hatView.userInteractionEnabled = YES;
    self.photoView.autoresizingMask = UIViewAutoresizingFlexibleHeight;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) pinchZoomHatView:(UIPinchGestureRecognizer *)sender {
    
    UIView *hat = [sender view];
    
    // The scale factor between the two fingers
    CGFloat factor = [sender scale];
    
    // Apply transformation only for the beginning or changing states
    if (sender.state == UIGestureRecognizerStateBegan || sender.state == UIGestureRecognizerStateChanged )  {
        NSLog(@"Scale: %1.2f",factor);
        // Apply an affine transformation based on the factor
        hat.transform = CGAffineTransformMakeScale(factor, factor);
    }
}
- (void) panHatView:(UIPanGestureRecognizer *)sender {

    UIView *hat = [sender view];
    
    if ([sender state] == UIGestureRecognizerStateBegan || [sender state] == UIGestureRecognizerStateChanged) {
        
        // Get the panning move point relative to the parent view
        CGPoint translation = [sender translationInView:[hat superview]];
        NSLog(@"x: %1.2f, y: %1.2f",translation.x,translation.y);
        
        // Add it to the center point of the beard view so that it stays
        // under the finger of the user
        [hat setCenter:CGPointMake([hat center].x + translation.x, [hat center].y + translation.y)];
        
        // Reset the translation to reduce panning velocity
        // Removing this line will result in the beard view disappearing very quickly
        [sender setTranslation:CGPointZero inView:[hat superview]];
        
    }               
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    // Create a new image picker instance:
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    // Set the image picker source:
    switch (buttonIndex) {
        case 0:
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
//            picker.sourceType = UIImagePickerControllerCameraDeviceFront;
            break;
        case 1:
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            break;
        default:
            break;
    }
    
    picker.delegate = self;
    
    // Show picker if Take a picture or Choose from Library is selected
    if ( buttonIndex == 0 || buttonIndex == 1)
        [self presentViewController:picker animated:YES completion:nil];
    
}
- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    self.photoView.image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (UIImage *) blendImages {
    UIImage *photoImage = self.photoView.image;
    UIImage *beardImage = self.hatView.image;
    
    // Get the size of the photo
    CGSize photoSize = CGSizeMake(photoImage.size.width, photoImage.size.height);
    
    // Create a bitmap graphics context of the photoSize
    UIGraphicsBeginImageContext( photoSize );
    
    // Draw the photo in the specified rectangle area
    [photoImage drawInRect:CGRectMake(0,0,photoSize.width,photoSize.height)];
    
    CGPoint origin = self.hatView.frame.origin;
    CGSize size = self.hatView.frame.size;
    
    CGFloat xScale = photoImage.size.width / self.view.bounds.size.width;
    CGFloat yScale = photoImage.size.height / (self.view.bounds.size.height-44);
    
    // Draw the beard in the specified rectangle area
    [beardImage drawInRect:CGRectMake((origin.x * xScale), (origin.y * yScale),
                                      size.width * xScale, size.height * yScale)
                 blendMode:kCGBlendModeNormal alpha:1.0];
    
    
    // Save the generated image to an image object
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}
- (void) cameraBtnAction:(UIButton *)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Take a Picture",@"Choose from Library", nil];
    [actionSheet showInView:self.view];
	[TestFlight passCheckpoint:@"User hit camera button button"];

}
- (void) shareBtnAction:(UIButton *)sender {
    
    
    // An array of content that needs to posted
    NSArray *activityItems = @[@"You have been Bearded!", UIImageJPEGRepresentation([self blendImages],0.75)];
    
    
    // Create a new UIActivityViewController with the activityItems array
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    // Exclude activities that are irrelevant
    activityController.excludedActivityTypes = @[UIActivityTypePostToWeibo,UIActivityTypePrint,UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact];
    
    // Present the activityController
    [self presentViewController:activityController
                       animated:YES completion:nil];
	
    [TestFlight passCheckpoint:@"User hit share button"];

//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Photo Saved" message:@"Saved to camera roll" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
//    [alertView show];
}
@end
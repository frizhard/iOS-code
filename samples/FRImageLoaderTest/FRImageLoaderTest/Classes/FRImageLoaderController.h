//
//  FRImageLoaderControllerViewController.h
//  FRImageLoaderTest
//
//  Created by José Servet Font on 15/09/13.
//  Copyright (c) 2013 Frizhard. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum ImageTag { ImageTag1 = 0, ImageTag2, ImageTag3 } ImageTag;

@interface FRImageLoaderController : UIViewController
{
	UIImageView *mImageView1;
	UIActivityIndicatorView *mActivityIndicator1;
	
	UIImageView *mImageView2;
	UIActivityIndicatorView *mActivityIndicator2;
	
	UIImageView *mImageView3;
	UIActivityIndicatorView *mActivityIndicator3;
}

@property (nonatomic, retain) IBOutlet UIImageView *imageView1;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator1;

@property (nonatomic, retain) IBOutlet UIImageView *imageView2;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator2;

@property (nonatomic, retain) IBOutlet UIImageView *imageView3;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator3;

@end

@interface FRImageLoaderController (Actions)

- (IBAction) button1Clicked;
- (IBAction) button2Clicked;
- (IBAction) button3Clicked;

@end

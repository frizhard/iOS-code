//
//  FRImageLoaderController.m
//  FRImageLoaderTest
//
//  Created by José Servet Font on 15/09/13.
//  Copyright (c) 2013 Frizhard. All rights reserved.
//

#import "FRImageLoaderController.h"

#import <FRExtras/FRImageLoader/FRImageLoader.h>

@interface FRImageLoaderController (privateMethods)

- (void) loadImageWithTag:(NSInteger)_tag;

@end

@implementation FRImageLoaderController

@synthesize imageView1 = mImageView1;
@synthesize activityIndicator1 = mActivityIndicator1;

@synthesize imageView2 = mImageView2;
@synthesize activityIndicator2 = mActivityIndicator2;

@synthesize imageView3 = mImageView3;
@synthesize activityIndicator3 = mActivityIndicator3;

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

@implementation FRImageLoaderController (Actions)

- (IBAction) button1Clicked
{
	[self loadImageWithTag:ImageTag1];
}

- (IBAction) button2Clicked
{
	[self loadImageWithTag:ImageTag2];
}

- (IBAction) button3Clicked
{
	[self loadImageWithTag:ImageTag3];
}

@end

@implementation FRImageLoaderController (privateMethods)

- (void) loadImageWithTag:(NSInteger)_tag
{
	// TODO: first images searching google for iOS7, will change later
	
	NSArray *urlStringArray = @[ @"http://media.idownloadblog.com/wp-content/uploads/2013/05/iOS-7-concept-Simply-Zesty.jpg",
								 @"http://cdn.thenextweb.com/wp-content/blogs.dir/1/files/2013/05/home-screen-ios7-concept.png",
								 @"http://media.idownloadblog.com/wp-content/uploads/2013/06/iOS-7-Messages-005.jpg"];
	NSArray *imageArray = [NSArray arrayWithObjects:mImageView1, mImageView2, mImageView3, nil];
	NSArray *activityArray = [NSArray arrayWithObjects:mActivityIndicator1, mActivityIndicator2, mActivityIndicator3, nil];
	
	UIImageView *imageView = [imageArray objectAtIndex:_tag];
	if(imageView.image==nil)
	{
		UIActivityIndicatorView *activity = [activityArray objectAtIndex:_tag];
		[activity startAnimating];
		
		[FRImageLoader loadImageFromUrl:[NSURL URLWithString:[urlStringArray objectAtIndex:_tag]] completion:^ (NSURL *_url, UIImage *_image, NSError *_error) {
			[activity stopAnimating];
			imageView.image = _image;
		}];
	}
}

@end
//
//  FRImageLoader.h
//  FRExtras
//
//  Created by José Servet Font on 15/09/13.
//  Copyright (c) 2013 Frizhard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^FRImageLoaderCompletionBlock)(NSURL *, UIImage *, NSError *);

@interface FRImageLoader : NSObject
{
	dispatch_queue_t mLoadingQueue;
	
	NSCache *mImageCache;
	NSMutableDictionary *mUrlDictionary;
}

+ (FRImageLoader *) sharedInstance;
+ (void) loadImageFromUrl:(NSURL *)_url isRetina:(BOOL)_isRetina completion:(FRImageLoaderCompletionBlock)_completionBlock;

@end

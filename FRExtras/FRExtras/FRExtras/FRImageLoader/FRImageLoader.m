//
//  FRImageLoader.m
//  FRExtras
//
//  Created by José Servet Font on 15/09/13.
//  Copyright (c) 2013 Frizhard. All rights reserved.
//

#import "FRImageLoader.h"

#include "../FRArc/FRArc.h"
#include "../FRError/FRError.h"

static FRImageLoader *gSharedInstance = nil;

@interface FRImageLoader (singleton)

- (id) initWithDefaults;
- (void) releaseSingleton;

@end

@interface FRImageLoader(privateMethods)

- (void) loadImageFromUrl:(NSURL *)_url completion:(FRImageLoaderCompletionBlock)_completionBlock;

@end

@implementation FRImageLoader

+ (FRImageLoader *) sharedInstance
{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		gSharedInstance = arc_safe_retain([[FRImageLoader alloc] initWithDefaults]);
	});
	
	return gSharedInstance;
}

+ (void) loadImageFromUrl:(NSURL *)_url completion:(FRImageLoaderCompletionBlock)_completionBlock
{
	FRImageLoader *loader = [FRImageLoader sharedInstance];
	
	[loader loadImageFromUrl:_url completion:_completionBlock];
}

- (id) init
{
	return nil;
}

#if !__has_feature(objc_arc)

- (id) retain
{
	return self;
}

- (void) release
{
}

- (void) dealloc
{
	dispatch_release(mLoading_queue);
	
	[mImageCache release];
	[mUrlDictionary release];
}

#endif

@end

@implementation FRImageLoader (singleton)

- (id) initWithDefaults
{
	self = [super init];
	if(self!=nil)
	{
		mLoadingQueue = dispatch_queue_create("com.frizhard.frimageloader.loadingqueue", 0x0);
		
		mImageCache = arc_safe_retain([[NSCache alloc] init]);
		mUrlDictionary = arc_safe_retain([[NSMutableDictionary alloc] initWithCapacity:0]);
	}
	
	return self;
}

- (void) releaseSingleton
{
	arc_safe_release(super);
}

@end

@implementation FRImageLoader(privateMethods)

- (void) loadImageFromUrl:(NSURL *)_url completion:(FRImageLoaderCompletionBlock)_completionBlock
{
	NSAssert(_url!=nil, @"URL must not be nil");
	
	NSString *urlString = [_url absoluteString];
	
	dispatch_sync(mLoadingQueue, ^{
		UIImage *cachedImage = [mImageCache objectForKey:urlString];
		if(cachedImage!=nil)
		{
			dispatch_async(dispatch_get_main_queue(), ^{
				_completionBlock(_url, cachedImage, nil);
			});
		}
		else
		{
			NSMutableArray *blockArray = [mUrlDictionary objectForKey:urlString];
			if(blockArray==nil)
			{
				blockArray = [NSMutableArray arrayWithCapacity:0];
				[mUrlDictionary setObject:blockArray forKey:urlString];
			}
			[blockArray addObject:_completionBlock];
			
			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
				UIImage *img = nil;
				NSError *error = nil;
				
				NSData *data = [NSData dataWithContentsOfURL:_url];
				if(data==nil)
					error = [NSError errorWithDomain:kFrizhardErrorDomain code:kFrizhardErrorFileOrUrlNotFound userInfo:@{ kFrizhardErrorKeyUrl : _url }];
				else
				{
					//NSArray *pathArray = [_url pathComponents];
					NSString *extension = [_url pathExtension];
					NSString *path = [_url path];
					NSString *filePath = [path substringToIndex:[path length]-[extension length]-1];
					
					if([filePath hasSuffix:@"@2x"]==NO)
						img = [UIImage imageWithData:data];
					else
					{
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 60000
						// iOS 6.0+, defined this way to support older xcode compilers with no __IPHONE_6_0 defined
						img = [UIImage imageWithData:data scale:2.0];
#else
						UIImage *tmpImg = [UIImage imageWithData:data];
						img = [UIImage imageWithCGImage:tmpImage scale:2.0 orientation:tmpImg.imageOrientation];
#endif
					}
				}
				
				dispatch_sync(mLoadingQueue, ^{
					if(img!=nil)
						[mImageCache setObject:img forKey:urlString];
					
					NSArray *blockArray = [NSArray arrayWithArray:[mUrlDictionary objectForKey:urlString]];
					dispatch_async(dispatch_get_main_queue(), ^{
						for(FRImageLoaderCompletionBlock block in blockArray)
							block(_url, img, error);
					});
					
					[mUrlDictionary removeObjectForKey:urlString];
				});
			});
		}
	});
}

@end
//
//  BasePhotosTableViewController.h
//  Flickr
//
//  Created by Sergey Perov on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlickrImageViewController.h"

@interface BasePhotosTableViewController : UITableViewController
#define FAVORITES_KEY @"PhotosTableViewController.favorites"
@property (nonatomic, strong) NSDictionary* currentPhotoSelected;
+ (NSString*) pictureTitle:(NSDictionary*) pt;
+ (NSString*) pictureDescription:(NSDictionary*) pd;
+ (NSArray*) getFavorites;
- (FlickrImageViewController *) splitFlickrImageViewController;
- (void) updateFlickrImage:(NSDictionary*)currentPhoto;
@end

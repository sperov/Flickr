//
//  FlickrImageViewController.h
//  Flickr
//
//  Created by Sergey Perov on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FlickrImageViewController : UIViewController <UISplitViewControllerDelegate>
@property (nonatomic, strong) NSDictionary* flickrPhoto;
- (void) loadFlickrPhoto; 
- (void) resizeFlickrImage;
- (void) updateGraphTitle;
@end



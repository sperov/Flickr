//
//  BasePhotosTableViewController.m
//  Flickr
//
//  Created by Sergey Perov on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BasePhotosTableViewController.h"

@interface BasePhotosTableViewController ()

@end

@implementation BasePhotosTableViewController
@synthesize currentPhotoSelected = _currentPhotoSelected;

+ (NSString*) pictureTitle:(NSDictionary*) pt { 
    
    NSString* pictureTitle = [pt objectForKey:@"title"];
    NSString* pictureDescription = [pt valueForKeyPath:@"description._content"];
    NSString* result =pictureTitle;
    
    if ([pictureTitle isEqualToString:@""]) {
        if ([pictureDescription isEqualToString:@""]) {
            result = @"Unknown";
        } else {
            result = pictureDescription;
        }
    } 
    return result;
    
}

+ (NSString*) pictureDescription:(NSDictionary*) pd {
    
    NSString* pictureDescription = [pd valueForKeyPath:@"description._content"];
    NSString* result = pictureDescription;
    
    if ([pictureDescription isEqualToString:@""]) {
        result = @"Unknown";
    } 
    return result;
}

+ (NSArray*) getFavorites {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:FAVORITES_KEY]; 
}

- (FlickrImageViewController *) splitFlickrImageViewController {
    id splitFlickrIVC = [self.splitViewController.viewControllers lastObject];
    if (![splitFlickrIVC isKindOfClass:[FlickrImageViewController class]]) {
        splitFlickrIVC = nil;
    }
    return splitFlickrIVC;
}

- (void) updateFlickrImage:(NSDictionary*)currentPhoto {
    [[self splitFlickrImageViewController] setFlickrPhoto:currentPhoto];
    [[self splitFlickrImageViewController] loadFlickrPhoto];
    [[self splitFlickrImageViewController] resizeFlickrImage];
    [[self splitFlickrImageViewController] updateGraphTitle];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    return cell;
}

@end

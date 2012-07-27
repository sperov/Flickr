//
//  PhotosTableViewController.m
//  Flickr
//
//  Created by Sergey Perov on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhotosTableViewController.h"
#import "FlickrImageViewController.h"
#import "FlickrFetcher.h"

@interface PhotosTableViewController ()
@property (nonatomic, strong) NSArray* firstFiftyPhotos; 
@end

@implementation PhotosTableViewController
@synthesize firstFiftyPhotos = _firstFiftyPhotos;   
@synthesize topPlace = _topPlace;


#define MAX_RESULTS_PER_PLACE 50

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!_firstFiftyPhotos) {
        _firstFiftyPhotos = [FlickrFetcher photosInPlace:self.topPlace maxResults:MAX_RESULTS_PER_PLACE];
    }
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.firstFiftyPhotos count]; // it may be less than 50 pics in that location
}

- (void) addToFavorites:(NSDictionary *) flickrPhoto
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray* favorites = [[defaults objectForKey:FAVORITES_KEY] mutableCopy];
    if (!favorites) favorites = [NSMutableArray array];
    
    NSString* id = [flickrPhoto valueForKey:@"id"];
    NSMutableArray* updatedFavorites = [NSMutableArray array];
    [updatedFavorites addObject:flickrPhoto]; // add the most recent photo first
    
    // walk through the rest of the entries and add them all
    for (int currentIndex = 0; currentIndex < favorites.count; currentIndex++ ) {
        if (![[[favorites objectAtIndex:currentIndex] valueForKey:@"id"] isEqualToString:id]) {            
            [updatedFavorites addObject:[favorites objectAtIndex:currentIndex]];
        }
    }
    [defaults setObject:updatedFavorites forKey:FAVORITES_KEY];
    [defaults synchronize];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Photo Description";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
     NSDictionary* picture = [self.firstFiftyPhotos objectAtIndex:indexPath.row];
    cell.textLabel.text = [BasePhotosTableViewController pictureTitle:picture];
    cell.detailTextLabel.text = [BasePhotosTableViewController pictureDescription:picture];

    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.currentPhotoSelected = [self.firstFiftyPhotos objectAtIndex:indexPath.row];
    [self addToFavorites:self.currentPhotoSelected]; // save in defaults
    if ([self splitFlickrImageViewController]) {
        [self updateFlickrImage:self.currentPhotoSelected];
    } else {
        [self performSegueWithIdentifier:@"Show Photo" sender:self];
    }
    
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Show Photo"]) {
        [segue.destinationViewController setFlickrPhoto:self.currentPhotoSelected];
    }
}

@end

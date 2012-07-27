//
//  RecentPhotosTableViewController.m
//  Flickr
//
//  Created by Sergey Perov on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RecentPhotosTableViewController.h"

@interface RecentPhotosTableViewController ()
@property (nonatomic, strong) NSArray* defaults;
@end

@implementation RecentPhotosTableViewController
@synthesize defaults = _defaults; 


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

- (void) viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}

// need to look how it is checked in the lectures
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[BasePhotosTableViewController getFavorites] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Recent Photo Description";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSDictionary* picture = [[BasePhotosTableViewController getFavorites] objectAtIndex:indexPath.row];
    cell.textLabel.text = [BasePhotosTableViewController pictureTitle:picture];
    cell.detailTextLabel.text = [BasePhotosTableViewController pictureDescription:picture];
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.currentPhotoSelected = [[BasePhotosTableViewController getFavorites] objectAtIndex:indexPath.row];

    if ([self splitFlickrImageViewController]) {
        [self updateFlickrImage:self.currentPhotoSelected];
    } else {
        [self performSegueWithIdentifier:@"Show Recent Photo" sender:self];
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Show Recent Photo"]) {
        [segue.destinationViewController setFlickrPhoto:self.currentPhotoSelected];
    }
}

@end

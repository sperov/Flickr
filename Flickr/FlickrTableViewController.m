//
//  FlickrTableViewController.m
//  Flickr
//
//  Created by Sergey Perov on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FlickrTableViewController.h"
#import "PhotosTableViewController.h"
#import "FlickrFetcher.h"


@interface FlickrTableViewController ()
@property (nonatomic,strong) NSArray* topPlaces;
@property (nonatomic, strong) NSDictionary* topPlaceSelected; 
@end

@implementation FlickrTableViewController

@synthesize topPlaces = _topPlaces;
@synthesize topPlaceSelected = _topPlaceSelected;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // only do all this stuff below if it has not been done yet
    // how about lazy instantiation
    if (!_topPlaces) {   
        _topPlaces = [FlickrFetcher topPlaces];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


#pragma mark - UITableViewDataSource
// define UITableViewDataSource methods here

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.topPlaces count];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"Top Place Description";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSString* contentStringForCurrentTopPlace = [[self.topPlaces objectAtIndex:indexPath.row] objectForKey:@"_content"];
    NSRange locationDividerRange = [contentStringForCurrentTopPlace rangeOfString:@", "];
    
    cell.textLabel.text = [contentStringForCurrentTopPlace substringToIndex:locationDividerRange.location];
    cell.detailTextLabel.text = [contentStringForCurrentTopPlace substringFromIndex:(locationDividerRange.location + locationDividerRange.length)];
    return cell;
}
#pragma mark - UITableViewDelegate
// define UITableViewDelegate methods here

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.topPlaceSelected = [self.topPlaces objectAtIndex:indexPath.row]; 
    [self performSegueWithIdentifier:@"Show Top 50 Photos" sender:self];

}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"Show Top 50 Photos"]) {
        [segue.destinationViewController setTopPlace:self.topPlaceSelected];
    }
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

@end

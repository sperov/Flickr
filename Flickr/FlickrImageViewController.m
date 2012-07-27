//
//  FlickrImageViewController.m
//  Flickr
//
//  Created by Sergey Perov on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FlickrTableViewController.h"
#import "PhotosTableViewController.h"
#import "RecentPhotosTableViewController.h"
#import "FlickrImageViewController.h"
#import "FlickrFetcher.h"

@interface FlickrImageViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView* scrollView;
@property (weak, nonatomic) IBOutlet UIImageView* imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) UIBarButtonItem* splitViewBarButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *graphTitle;
@property (weak, nonatomic) IBOutlet UINavigationItem *iPhoneGraphTitle;
@end

@implementation FlickrImageViewController
@synthesize flickrPhoto = _flickrPhoto;
@synthesize scrollView = _scrollView;
@synthesize imageView = _imageView;
@synthesize toolbar = _toolbar;
@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;
@synthesize graphTitle = _graphTitle;
@synthesize iPhoneGraphTitle = _iPhoneGraphTitle;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) loadFlickrPhoto {
    if (self.flickrPhoto) {
        NSURL* flickrImageURL = [FlickrFetcher urlForPhoto:self.flickrPhoto format:FlickrPhotoFormatLarge];
        
        NSData* flickrImageData = [NSData dataWithContentsOfURL:flickrImageURL];
        UIImage* flickrImage = [UIImage imageWithData:flickrImageData];
        
        self.scrollView.zoomScale = 1;
        
        self.imageView.image = flickrImage;
        self.imageView.frame = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);
        
        self.scrollView.contentSize = self.imageView.image.size;
    }
}

- (void) resizeFlickrImage {
    if (self.flickrPhoto) {
        float scalex = self.scrollView.bounds.size.height/self.imageView.image.size.height;
        float scaley = self.scrollView.bounds.size.width/self.imageView.image.size.width;
        self.scrollView.zoomScale = (scalex > scaley) ? scalex : scaley;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.splitViewController) {
        if ([self.splitViewController respondsToSelector:@selector(presentsWithGesture)]) {
            self.splitViewController.presentsWithGesture = NO;
        }
    }
    [self loadFlickrPhoto];
    [self updateGraphTitle];
    self.scrollView.delegate = self;
    self.splitViewController.delegate = self;
}

- (void) viewWillAppear:(BOOL)animated {
    [self resizeFlickrImage];
}
- (UIView* ) viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)viewDidUnload
{
    [self setToolbar:nil];
    [self setGraphTitle:nil];
    [self setIPhoneGraphTitle:nil];
    [super viewDidUnload];
    [self setImageView:nil];
    [self setScrollView:nil];
}

- (FlickrTableViewController *) splitViewFlickerViewController {
    id flickerTVC = [(UINavigationController*) [self.splitViewController.viewControllers objectAtIndex:0] topViewController];
    
    if (![flickerTVC isKindOfClass:[FlickrTableViewController class]] &&
        ![flickerTVC isKindOfClass:[PhotosTableViewController class]] &&
        ![flickerTVC isKindOfClass:[RecentPhotosTableViewController class]]) {
        flickerTVC = nil;
    }
    return flickerTVC;
}

- (void) setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem {
    if (_splitViewBarButtonItem != splitViewBarButtonItem ) {
        NSMutableArray* toolbarItems = [self.toolbar.items mutableCopy];
        if (_splitViewBarButtonItem) [toolbarItems removeObject:_splitViewBarButtonItem];
        if (splitViewBarButtonItem) [toolbarItems insertObject:splitViewBarButtonItem atIndex:0];
        self.toolbar.items = toolbarItems; 
        _splitViewBarButtonItem = splitViewBarButtonItem;
    }
}

- (BOOL) splitViewController:(UISplitViewController *) svc 
    shouldHideViewController:(UIViewController* )vc 
               inOrientation:(UIInterfaceOrientation)orientation {
    return UIInterfaceOrientationIsPortrait(orientation);
}

- (void) splitViewController:(UISplitViewController*) svc 
      willHideViewController:(UIViewController *)aViewController 
           withBarButtonItem:(UIBarButtonItem *)barButtonItem 
        forPopoverController:(UIPopoverController *)pc
{
    barButtonItem.title = [self splitViewFlickerViewController].title;
    self.splitViewBarButtonItem = barButtonItem;
    
}

- (void) splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    self.splitViewBarButtonItem = nil;    
}

- (void) updateGraphTitle {
    if (self.flickrPhoto) {
        if (self.splitViewController) {
            NSMutableArray* toolbarItems = [self.toolbar.items mutableCopy];
            NSUInteger graphTitlePosition = [toolbarItems indexOfObject:self.graphTitle];
            UIBarButtonItem* graphTitle = [toolbarItems objectAtIndex:graphTitlePosition];
            graphTitle.title = [PhotosTableViewController pictureTitle:self.flickrPhoto];
            [toolbarItems replaceObjectAtIndex:graphTitlePosition withObject:graphTitle];
            self.toolbar.items = toolbarItems; 
            _graphTitle = graphTitle;
        } else {
            self.iPhoneGraphTitle.title = [PhotosTableViewController pictureTitle:self.flickrPhoto];
        }
    }
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end

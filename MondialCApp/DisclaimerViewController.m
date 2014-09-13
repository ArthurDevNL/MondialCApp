#import "DisclaimerViewController.h"

@interface DisclaimerViewController ()

- (void) loadScrollViewWithPage:(int)page;


@end

@implementation DisclaimerViewController
@synthesize delegate = _delegate;
@synthesize scroller = _scroller;
@synthesize pageControl = _pageControl;
@synthesize viewControllers = _viewControllers;

#define kNumberOfPages 3

#pragma mark - Barbuttons
//This is just the action of the contact button you see in the disclaimer view
- (IBAction)contact {

    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    
    [picker setSubject:@"MondialCApp - Contact"];
    
    picker.mailComposeDelegate = self;
    
    [picker setToRecipients:[NSArray arrayWithObject:@"mondialapp@gmail.com"]];
    
    NSString *emailBody = @"Typ hier uw bericht...";
    [picker setMessageBody:emailBody isHTML:NO];
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {

    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)done:(id)sender
{
    [self.delegate disclaimerViewControllerDidFinish:self];
}

#pragma mark - Scroll View
- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView 
{
    pageControlBeingUsed = NO;
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pageControlBeingUsed = NO;
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (pageControlBeingUsed) return;
    
    //Get the current page and change the page control indicator
    CGFloat pageWidth = self.scroller.frame.size.width;
    int page = floor((self.scroller.contentOffset.x - pageWidth / 2) / pageWidth) + 1; 
    self.pageControl.currentPage = page;
    
    //Load the visible page on either side of the visible view to avoid white flashes
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
}

/*
- (IBAction)changePage:(id)sender {
    int page = self.pageControl.currentPage;
    
    //Load the visible page on either side of the visible view to avoid white flashes
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
	//Update the scrollview
    CGRect frame = self.scroller.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [self.scroller scrollRectToVisible:frame animated:YES];
    
    pageControlBeingUsed = YES;
}
*/

- (void)loadScrollViewWithPage:(int)page {
    if (page < 0) return;
    if (page >= kNumberOfPages) return;

    //Replace the nsnull object if necessary
    UIViewController *controller = [self.viewControllers objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null]) {
        if (page == 0) {
            controller = [self.storyboard instantiateViewControllerWithIdentifier:@"disclaimer"];
        } else if (page == 1) {
            controller = [self.storyboard instantiateViewControllerWithIdentifier:@"lestijden"];
        } else if (page == 2) {
            controller = [self.storyboard instantiateViewControllerWithIdentifier:@"tijdenrooster"];
        }
        
        [self.viewControllers replaceObjectAtIndex:page withObject:controller];
    }
    
    //Add the controllers view to the scrollview
    if (nil == controller.view.superview) {
        CGRect frame = self.scroller.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        [self.scroller addSubview:controller.view];
    }
    
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    //Set up the scroll view
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (int i = 0; i < kNumberOfPages; i++) {
        [controllers addObject:[NSNull null]];
    }
    self.viewControllers = controllers;

    pageControlBeingUsed = NO;
    
    self.scroller.contentSize = CGSizeMake(self.scroller.frame.size.width * kNumberOfPages, self.scroller.frame.size.height);
	self.scroller.pagingEnabled = YES;
    self.scroller.showsVerticalScrollIndicator = NO;
    self.scroller.showsHorizontalScrollIndicator = NO;
    self.scroller.scrollsToTop = NO;
    self.scroller.delegate = self;
	self.pageControl.currentPage = 0;    
    self.pageControl.numberOfPages = kNumberOfPages;
    
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



@end

#import "RoosterViewController.h"
#import "RoosterTableViewController.h"

#define kNumberOfPages 5

@interface RoosterViewController ()

@property (nonatomic) IBOutlet NSLayoutConstraint *constraint;

@property (nonatomic) BOOL isAnimatingScroll;

@end

@implementation RoosterViewController
@synthesize scroller = _scroller;
@synthesize viewControllers = _viewControllers;
@synthesize daySegment = _daySegment;

- (IBAction)didSelectDay:(UISegmentedControl *)sender
{
//    int page = sender.selectedSegmentIndex;
//    [self scrollToPage:page];
    [self setIsAnimatingScroll:YES];
}

#pragma mark - Scroll View
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self setIsAnimatingScroll:NO];
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    //Get the current page and change the page control indicator
    CGFloat pageWidth = self.scroller.frame.size.width;
    int page = floor((self.scroller.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if (page != self.lastPage) {
        
        if (!self.isAnimatingScroll)
            [self.daySegment setSelectedSegmentIndex:page];
        
        //Load the visible page on either side of the visible view to avoid white flashes
        [self loadScrollViewWithPage:page - 1];
        [self loadScrollViewWithPage:page];
        [self loadScrollViewWithPage:page + 1];
        
        self.lastPage = page;
    }
}

- (void)loadScrollViewWithPage:(int)page
{
    if (page < 0) return;
    if (page >= kNumberOfPages) return;

    //Replace the nsnull object if necessary
    RoosterTableViewController *controller = [self.viewControllers objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null]) {
        controller = [self.storyboard instantiateViewControllerWithIdentifier:@"RoosterTableViewController"];
        [controller setDag:page];
        [self.viewControllers replaceObjectAtIndex:page withObject:controller];
    }
    
    //Add the controllers view to the scrollview
    if (nil == controller.view.superview) {
        CGRect frame = self.scroller.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0.f;
        frame.size.height = self.scroller.frame.size.height;
        controller.view.frame = frame;
        [self.scroller addSubview:controller.view];
    }
    
}

 - (void)scrollToPage:(int)page {
     if (page < 0) return;
     if (page >= kNumberOfPages) return;
     
     //Load the visible page on either side of the visible view to avoid white flashes
     [self loadScrollViewWithPage:page - 1];
     [self loadScrollViewWithPage:page];
     [self loadScrollViewWithPage:page + 1];
 
     [self.daySegment setSelectedSegmentIndex:page];
     
     //Update the scrollview
     CGRect frame = self.scroller.frame;
     frame.origin.x = frame.size.width * page;
     frame.origin.y = 0;
     [self.scroller scrollRectToVisible:frame animated:YES];
}

- (void)scrollToCurrentDay
{
    //Scroll to current day of the week
    NSDate *currentDate = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *weekdayComponents =[calendar components:NSWeekdayCalendarUnit fromDate:currentDate];
    
    NSInteger weekday = [weekdayComponents weekday];
    
    switch (weekday) {
        case 1:         //Zondag
            [self scrollToPage:0];
            break;
        case 2:         //Maandag
            [self scrollToPage:0];
            break;
        case 3:         //Dinsdag
            [self scrollToPage:1];
            break;
        case 4:         //Woensdag
            [self scrollToPage:2];
            break;
        case 5:         //Donderdag
            [self scrollToPage:3];
            break;
        case 6:         //Vrijdag
            [self scrollToPage:4];
            break;
        case 7:         //Zaterdag
            [self scrollToPage:0];
            break;
        default:
            break;
    }
}

#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];

	//Set up the scroll view
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (int i = 0; i < kNumberOfPages; i++) {
        [controllers addObject:[NSNull null]];
    }
    self.viewControllers = controllers;
        
	self.scroller.pagingEnabled = YES;
    self.scroller.showsVerticalScrollIndicator = NO;
    self.scroller.showsHorizontalScrollIndicator = NO;
    self.scroller.scrollsToTop = NO;
    self.scroller.delegate = self;
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.scroller.contentSize = CGSizeMake(self.scroller.frame.size.width * kNumberOfPages, self.scroller.frame.size.height);

    //If the viewcontrollers haven't been initialized yet, load them
    if ([self.viewControllers[0] isEqual:[NSNull null]]) {
        for (int i = 0; i < kNumberOfPages; i++) {
            [self loadScrollViewWithPage:i];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self scrollToCurrentDay];
}

@end

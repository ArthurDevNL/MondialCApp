#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@class DisclaimerViewController;

@protocol DisclaimerViewControllerDelegate
- (void)disclaimerViewControllerDidFinish:(DisclaimerViewController *)controller;
@end

@interface DisclaimerViewController : UIViewController <MFMailComposeViewControllerDelegate, UIScrollViewDelegate>
{

    BOOL pageControlBeingUsed;
}

@property (assign, nonatomic) IBOutlet id <DisclaimerViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIScrollView *scroller;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *viewControllers;

- (IBAction)done:(id)sender;
- (IBAction)contact;
//- (IBAction)changePage:(id)sender;

@end

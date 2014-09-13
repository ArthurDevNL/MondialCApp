#import <UIKit/UIKit.h>

@interface RoosterViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *scroller;
@property (nonatomic, weak) IBOutlet UISegmentedControl *daySegment;
@property (nonatomic) int lastPage;
@property (nonatomic, strong) NSMutableArray *viewControllers;

- (IBAction)didSelectDay:(UISegmentedControl *)sender;

@end

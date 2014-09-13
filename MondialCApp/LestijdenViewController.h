//
//  LestijdenViewController.h
//  MondialCApp
//
//  Created by Arthur Hemmer on 7/26/13.
//
//

#import <UIKit/UIKit.h>

@interface LestijdenViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIScrollView *scroller;
@property (nonatomic, weak) IBOutlet UIPageControl *pageControl;

@property (nonatomic) NSMutableArray *viewControllers;
@property (nonatomic) BOOL pageControlBeingUsed;

@end

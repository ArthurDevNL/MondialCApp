//
//  LestijdenViewController.m
//  MondialCApp
//
//  Created by Arthur Hemmer on 7/26/13.
//
//

#import "LestijdenViewController.h"

@interface LestijdenViewController () <UIScrollViewDelegate>
@property (nonatomic) UIImageView *imgView;
@end

@implementation LestijdenViewController

#pragma mark - View lifecycle
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.imgView) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [imgView setContentMode:UIViewContentModeScaleAspectFit];
        [imgView setImage:[UIImage imageNamed:@"lestijden"]];
        
        CGRect iFrame = CGRectZero;
        iFrame.size.height = 391;
        iFrame.size.width = 612.f;
        iFrame.origin.x = 10.f;
        iFrame.origin.y = (self.scroller.frame.size.height/2.f) - (iFrame.size.height/2.f);
        [imgView setFrame:iFrame];
        
        [self.scroller addSubview:imgView];
        [self.scroller setContentSize:CGSizeMake(iFrame.size.width + 20.f, iFrame.size.height)];
    }
}

@end

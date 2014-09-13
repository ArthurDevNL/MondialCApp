#import "RoosterCell.h"
#import "Timetable.h"
#import "UIColor+MLPFlatColors.h"
#import <QuartzCore/QuartzCore.h>

static NSTimeInterval kAnimationTime = .15f;

@interface RoosterCell ()
@property (nonatomic, weak) IBOutlet UILabel *lblLokaal;
@property (nonatomic, weak) IBOutlet UILabel *lblVak;
@property (nonatomic, weak) IBOutlet UILabel *lblLesuur;
@property (nonatomic, weak) IBOutlet UILabel *lblDocent;
@property (nonatomic, weak) IBOutlet UIImageView *imgColor;
@property (nonatomic, weak) IBOutlet UILabel *lblLestijd;

@property (nonatomic) Timetable *timetable;

@property (nonatomic) BOOL isShowingTime;

@property (nonatomic) BOOL isAnimating;

@end

@implementation RoosterCell
@synthesize lblLokaal = _lblLokaal;
@synthesize lblDocent = _lblDocent;
@synthesize lblVak = _lblVak;
@synthesize lblLesuur = _lblLesuur;
@synthesize imgColor = _imgColor;

#pragma mark - Animation
-(void)switchInformation
{
    if (self.isAnimating) return;
    
    [self setIsAnimating:YES];
    
    if (self.isShowingTime) {
        [self hideLessonTime:^(BOOL finished) {
            [self showLesson:^(BOOL finished) {
                [self setIsAnimating:NO];
            }];
        }];
        [self setIsShowingTime:NO];
    } else if (!self.isShowingTime) {
        [self hideLesson:^(BOOL finished) {
            [self showLessonTime:^(BOOL finished) {
                [self setIsAnimating:NO];
            }];
        }];
        [self setIsShowingTime:YES];
    }
}

-(void)hideLessonTime:(void(^)(BOOL finished))completion
{
    [UIView animateWithDuration:kAnimationTime animations:^{
        [self.lblLestijd setAlpha:.0f];
    } completion:completion];
}

-(void)showLessonTime:(void(^)(BOOL finished))completion
{
    [UIView animateWithDuration:kAnimationTime animations:^{
        [self.lblLestijd setAlpha:1.f];
    } completion:completion];
}

-(void)hideLesson:(void(^)(BOOL finished))completion
{
    [UIView animateWithDuration:kAnimationTime animations:^{
        [self.lblLokaal setAlpha:0.f];
        [self.lblDocent setAlpha:0.f];
        [self.lblVak setAlpha:0.f];
    } completion:completion];
}

-(void)showLesson:(void(^)(BOOL finished))completion
{
    [UIView animateWithDuration:kAnimationTime animations:^{
        [self.lblLokaal setAlpha:1.f];
        [self.lblDocent setAlpha:1.f];
        [self.lblVak setAlpha:1.f];
    } completion:completion];
}

#pragma mark - Layout
-(void)layoutSubviews
{
    [super layoutSubviews];
        
    //Set the text for the 'lblLestijd' but hide it for now
    [self.lblLestijd setAlpha:0.f];
    
    NSIndexPath *index = [NSIndexPath indexPathForRow:self.indexPath.row-1 inSection:self.indexPath.section-1];
    [self.lblLestijd setText:[self getLestijdVoorLesuur:index]];
    
    
    //Set the new data
    Lesson *l = [Timetable getLessonFromTimetable:self.timetable forIndexPath:self.indexPath];
    [self.lblLesuur setText:[NSString stringWithFormat:@"%li", (long)l.hour]];
    [self.lblVak setText:l.subject];
    [self.lblLokaal setText:l.classroom];
    
    Timetable *t = [Timetable defaultInstance];
    if (t.timetableType == Pupil)
        [self.lblDocent setText:l.teacher];
    else
        [self.lblDocent setText:l.group];
    
    [self.imgColor.layer setCornerRadius:self.imgColor.frame.size.width/2.f];
    
    if (!l.ID || [l.ID isEqualToString:@""]) {
        [self.imgColor setBackgroundColor:[UIColor flatGreenColor]];
    } else {
        [self.imgColor setBackgroundColor:[UIColor flatBlueColor]];
    }
    
    [self setClipsToBounds:YES];
    [self.contentView setClipsToBounds:YES];
}

#pragma mark - Utility
- (NSString *)getLestijdVoorLesuur:(NSIndexPath *)indexPath
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Lestijden" ofType:@"plist"];
    NSDictionary *lestijdenDict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    NSArray *lestijdenArray;
    
    NSString *lesgroep = [Timetable getLessonFromTimetable:self.timetable forIndexPath:indexPath].group;
    NSString *klas = lesgroep.length > 0 ? [lesgroep substringToIndex:1] : nil;
    
    NSString *average = [self.timetable averageLevel];
    if ([klas isEqualToString:@"2"] || [klas isEqualToString:@"3"]) {
        lestijdenArray = lestijdenDict[@"onderbouw"];
    } else if ([klas isEqualToString:@"1"] || [klas isEqualToString:@"4"] || [klas isEqualToString:@"5"] || [klas isEqualToString:@"6"]) {
        
        lestijdenArray = lestijdenDict[@"bovenbouw"];
    } else if (average && ![average isEqualToString:@""]) {
        NSString *a = average;
        lestijdenArray = ([a isEqualToString:@"2"] || [a isEqualToString:@"3"]) ? lestijdenDict[@"onderbouw"] : lestijdenDict[@"bovenbouw"];
    } else {
        lestijdenArray = lestijdenDict[@"bovenbouw"];
    }
    
    return lestijdenArray[indexPath.row];
}

#pragma mark - Getters & Setters
-(Timetable *)timetable
{
    if (!_timetable) {
        _timetable = [Timetable defaultInstance];
    }
    return _timetable;
}

-(void)setIndexPath:(NSIndexPath *)indexPath
{
    if (_indexPath != indexPath) {
        _indexPath = indexPath;
        
//        [self layoutSubviews];
    }
}


@end

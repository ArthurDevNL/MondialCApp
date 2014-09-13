#import <UIKit/UIKit.h>

@class Lesson;

@interface RoosterCell : UITableViewCell

//Set this property to either an NSString or a Lesson, the cell will figure out what to display
@property (nonatomic) NSIndexPath *indexPath;

//This method changes the information displayed in the cell to the time of the lesson
// if the lesson is displayed and vice versa
-(void)switchInformation;

@end

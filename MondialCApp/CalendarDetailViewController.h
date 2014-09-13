#import <UIKit/UIKit.h>

@interface CalendarDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *partyTitleLabel;
@property (weak, nonatomic) IBOutlet UITextView *partyDescriptionLabel;
@property (weak, nonatomic) NSString *partyTitle;
@property (weak, nonatomic) NSString *partyDescription;

@end

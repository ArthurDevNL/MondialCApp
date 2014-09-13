#import <UIKit/UIKit.h>
#import "PersoonlijkRooster.h"

@interface AccountRoostervanViewController : UITableViewController <UITextFieldDelegate>

@property (nonatomic, retain) IBOutlet UIBarButtonItem *btnNext;
@property (nonatomic, retain) IBOutlet UITextField *accountRoostervan;

@property (nonatomic) PersoonlijkRooster *roosterAccount;

- (IBAction)txtValueChanged:(UITextField *)sender;

@end

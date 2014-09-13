#import <UIKit/UIKit.h>
#import "AgendaInfo.h"

@interface CalendarViewController : UITableViewController <UIActionSheetDelegate> 

@property (strong, nonatomic) AgendaInfo *agendaInfo;
@property (strong, nonatomic) NSString *twitterText;
@property (strong, nonatomic) IBOutlet UITableView *table;


- (IBAction)openActionSheet;

@end

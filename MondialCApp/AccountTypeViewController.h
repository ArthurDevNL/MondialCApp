#import <UIKit/UIKit.h>
#import "PersoonlijkRooster.h"

@protocol AccountDelegate <NSObject>
- (void)accountDidFinishConfiguring:(PersoonlijkRooster*)account;
@end

@interface AccountTypeViewController : UITableViewController

@property (nonatomic, weak) IBOutlet UIBarButtonItem *volgende;
@property (nonatomic, weak) id<AccountDelegate> delegate;
@property (nonatomic) PersoonlijkRooster *roosterAccount;
@property (nonatomic, retain) NSIndexPath *oldIndexPath;

@end

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "PersoonlijkRooster.h"

#define BasisRoosterVan @"roostervan"
#define BasisRoosterType @"roostertype"

@interface InstellingenViewController : UITableViewController <UITextFieldDelegate, UITableViewDelegate>
{
    BOOL roosterVanList;
    BOOL indelingenParsen;
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *typeRoosterSegment;
@property (nonatomic, weak) IBOutlet UITextField *roosterVanTextField;
@property (nonatomic, weak) IBOutlet UILabel *lblAccountRoosterVan;
@property (nonatomic, strong) PersoonlijkRooster *account;
- (IBAction)sgmValueChanged:(UISegmentedControl *)sender;
- (IBAction)txtEditingChanged:(UITextField *)sender;
- (IBAction)btnRefreshPressed:(UIBarButtonItem *)sender;

@end

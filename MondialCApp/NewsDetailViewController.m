#import "NewsDetailViewController.h"
#import "AppDelegate.h"
#import "TUSafariActivity.h"
#import "JBWhatsAppActivity/JBWhatsAppActivity.h"
#import "Article.h"

@interface NewsDetailViewController ()  <UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIImageView *seperatorImage;
@property (weak, nonatomic) IBOutlet UILabel *lblSummary;

- (IBAction)btnSharePressed:(UIBarButtonItem*)sender;

@end

@implementation NewsDetailViewController
@synthesize lblTitle = _titleText;
@synthesize seperatorImage = _seperatorImage;
@synthesize lblSummary = _desText;

- (IBAction)btnSharePressed:(UIBarButtonItem*)sender
{
    //The things you want to share
    NSString *shareText = [NSString stringWithFormat:@"\"%@\" Download nu ook de MondialCApp! http://appstore.com/mondialcapp", self.article.Title];
    WhatsAppMessage *message = [[WhatsAppMessage alloc] initWithMessage:shareText forABID:nil];
    NSURL *URL = [NSURL URLWithString:self.article.Link];
    
    NSMutableArray *items = @[shareText, message].mutableCopy;
    NSMutableArray *applications = @[[JBWhatsAppActivity new]].mutableCopy;
    
    //There is a chance that the link can't be parsed and the NSURL object will be nil. If it isn't we'll add it to the items and applicationactivities
    if (URL) {
        [items addObject:URL];
        [applications addObject:[TUSafariActivity new]];
    }
    
    //Create the AVActivityViewController and present it
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:applications];
    activityVC.excludedActivityTypes = @[UIActivityTypePrint,
                                         UIActivityTypeCopyToPasteboard,
                                         UIActivityTypeAssignToContact,
                                         UIActivityTypeSaveToCameraRoll];
    [self presentViewController:activityVC animated:YES completion:nil];
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Set the text
    [self.lblTitle setText:self.article.Title];
    [self.lblSummary setText:self.article.Summary];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
}

@end

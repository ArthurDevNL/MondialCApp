//
//  OverAppViewController.m
//  MondialCApp
//
//  Created by Arthur Hemmer on 7/26/13.
//
//

#import "OverAppViewController.h"
#import <MessageUI/MessageUI.h>

@interface OverAppViewController () <MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnContact;

- (IBAction)btnContactPressed:(UIButton *)sender;


- (IBAction)btnDonePressed:(UIBarButtonItem *)sender;

@end

@implementation OverAppViewController

#pragma mark - IBAction
- (IBAction)btnContactPressed:(UIBarButtonItem *)sender
{
    [self presentModalMailComposerViewController];
}

- (IBAction)btnDonePressed:(UIBarButtonItem *)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)presentModalMailComposerViewController
{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] init];
        composeViewController.mailComposeDelegate = self;
        
        [composeViewController setSubject:@"Contact [MondialCApp]"];
        [composeViewController setToRecipients:@[@"arthur@appsss.nl"]];
        
        [self presentViewController:composeViewController animated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        }];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Fout!"
                                    message:@"Mogelijk zijn er geen mailboxen ingesteld."
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

#pragma mark - MFMailComposeViewControllerDelegate
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if (error) {
        
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }];
}

#pragma mark - View lifecycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

@end

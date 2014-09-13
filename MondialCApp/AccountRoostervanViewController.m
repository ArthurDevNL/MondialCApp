#import "AccountRoostervanViewController.h"

@interface AccountRoostervanViewController ()

//The action for when the user has pressed done
-(IBAction)btnDonePressed:(UIBarButtonItem*)sender;

@end

@implementation AccountRoostervanViewController
@synthesize roosterAccount = _roosterAccount;
@synthesize btnNext = _klaar;
@synthesize accountRoostervan = _accountRoostervan;

//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if ([segue.identifier isEqualToString:@"ShowAccountNotificaties"]) {
//        NSString *trimmedString = [self.accountRoostervan.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//        
//        [self.roosterAccount setRoostervan:trimmedString];
//    }
//}

- (IBAction)txtValueChanged:(UITextField *)sender 
{
    NSString *trimmedString = [sender.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [self.roosterAccount setRoostervan:trimmedString];
    
    if ([trimmedString isEqualToString:@""]) {
        [self.btnNext setEnabled:NO];
    } else {
        [self.btnNext setEnabled:YES];
    }
}

-(IBAction)btnDonePressed:(UIBarButtonItem*)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"finishedCreatingAccount" object:nil];
}

-(PersoonlijkRooster *)roosterAccount
{
    if (!_roosterAccount) {
        _roosterAccount = [PersoonlijkRooster defaultInstance];
    }
    return _roosterAccount;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - View lifecycle
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //Set the textfield as the firstresponder
    [self.accountRoostervan becomeFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.roosterAccount.roostertype == Pupil) {
        [self.accountRoostervan setPlaceholder:@"Leerlingnummer"];
        [self.accountRoostervan setKeyboardType:UIKeyboardTypeDecimalPad];
    } else if (self.roosterAccount.roostertype == Teacher) {
        [self.accountRoostervan setPlaceholder:@"Afkorting"];
        [self.accountRoostervan setKeyboardType:UIKeyboardTypeAlphabet];
    }
    
    if (![self.roosterAccount.roostervan isEqualToString:@""])
        [self.accountRoostervan setText:self.roosterAccount.roostervan];
}

@end

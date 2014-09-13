 #import "InstellingenViewController.h"
#import "Reachability.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "AccountTypeViewController.h"

@interface InstellingenViewController () <TimetableDelegate, AccountDelegate>

@property (nonatomic, retain) NSString *roosterVan;
@property (nonatomic, strong) Timetable *timeTable;

@property (weak, nonatomic) IBOutlet UILabel *lblModify;


- (void)downloadTimetable:(NSString*)type;
@end

@implementation InstellingenViewController
#pragma mark - Synthesizes
@synthesize roosterVanTextField = _roosterVanTextField;
@synthesize typeRoosterSegment = _typeRoosterSegment;
@synthesize account = _account;
@synthesize lblAccountRoosterVan = _accountRoostervan;
@synthesize roosterVan = _roosterVan;
@synthesize timeTable = _timeTable;

#pragma mark - Account Configuration
//Get the current account
- (PersoonlijkRooster*)account
{
    if (!_account) {
        _account = [PersoonlijkRooster defaultInstance];
    }
    return _account;
}

-(Timetable *)timeTable
{
    if (!_timeTable) {
        _timeTable = [Timetable defaultInstance];
        _timeTable.delegate = self;
    }
    return _timeTable;
}

//Delegation method for the configure account segue
-(void)accountDidFinishConfiguring:(PersoonlijkRooster *)account
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Segues
//Prepare for the Configure account segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ConfigureAccount"]) {
        UINavigationController *controller = (UINavigationController *)segue.destinationViewController;
        AccountTypeViewController *viewController = [controller.viewControllers objectAtIndex:0];
        [viewController setDelegate:self];
    }
}

#pragma mark - Timetable
//The delegate metthod that gets called whenever the Timetable class has finished processing. All the parameters speak for themselves
-(void)timetableDidUpdate:(Timetable *)timeTable succes:(BOOL)succes
{
    [self.roosterVanTextField setEnabled:YES];
    [self.roosterVanTextField setText:self.roosterVan];
    
    if (!succes) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray *huds = [MBProgressHUD allHUDsForView:self.view];
            for (MBProgressHUD *hud in huds) {
                hud.mode = MBProgressHUDModeCustomView;
                hud.labelText = @"Geen rooster gevonden";
                [hud hide:YES afterDelay:2];
            }
        });
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.roosterVanTextField setEnabled:YES];
        [self.roosterVanTextField setText:self.roosterVan];
        
        NSArray *huds = [MBProgressHUD allHUDsForView:self.view];
        for (MBProgressHUD *hud in huds) {
            hud.mode = MBProgressHUDModeCustomView;
            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
            hud.labelText = @"Rooster gevonden.";
            [hud hide:YES afterDelay:2];
        }
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:self.roosterVan forKey:BasisRoosterVan];
        [defaults setObject:[NSString stringWithFormat:@"%li", (long)self.typeRoosterSegment.selectedSegmentIndex] forKey:BasisRoosterType];
        [defaults synchronize];
    });
}
//Pc: The user has been informed that the timetable has or hasn't been found and the tableviews have been reloaded accordingly

#pragma mark - IBActions
//This method will start the timetable class to load the new timetable
- (void)downloadTimetable:(NSString*)type
{
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:hud];
        [hud setMode:MBProgressHUDModeIndeterminate];
        [hud setAnimationType:MBProgressHUDAnimationFade];
        [hud setLabelText:type];
        [hud setRemoveFromSuperViewOnHide:YES];
        [hud show:YES];
        
        [self.roosterVanTextField resignFirstResponder];
        [self.roosterVanTextField setEnabled:NO];
        self.roosterVan = self.roosterVanTextField.text;

//        [self.timeTable reloadTimetableWithName:self.roosterVanTextField.text forType:self.typeRoosterSegment.selectedSegmentIndex];
    });
}
//Post-condition: The appropriate method has been called to load the rooster into the app

//This method is called when the typeRoostersegment has changed its value. The action taken upon is setting the keyboard layout
- (IBAction)sgmValueChanged:(UISegmentedControl *)sender
{
    [self.roosterVanTextField resignFirstResponder];
    
    if ([self.roosterVanTextField.text isEqualToString:@"urt"]) {
        [self.typeRoosterSegment setSelectedSegmentIndex:0];
        self.roosterVanTextField.text = @"100282";
        [self downloadTimetable:@"Arthur..."];
        [self.typeRoosterSegment setSelectedSegmentIndex:Pupil];
    }
    
//    [self setKeyboardLayoutForType:self.typeRoosterSegment.selectedSegmentIndex];
}
//Pc: The right keyboard layout has been set

//This method sets the keyboard layout for a given persontype
-(void)setKeyboardLayoutForType:(PersonType)type
{
    switch (type) {
        case Pupil:
            self.roosterVanTextField.keyboardType = UIKeyboardTypeDecimalPad;
            break;
        case Teacher:
            self.roosterVanTextField.keyboardType = UIKeyboardTypeAlphabet;
            break;
        case Classroom:
            self.roosterVanTextField.keyboardType = UIKeyboardTypeNumberPad;
            break;
        default:
            break;
    }
}
//Pc: The keyboard layout has been set according to the given PersonType

//Smart feature: if the first character in the roostervantextfield is a digit then auto-hide the keyboard when it reaches 6 numbers. If the first character is a letter auto-hide the keyboard whenever the length reaches 4
- (IBAction)txtEditingChanged:(UITextField *)sender
{
    NSString *firstChar = sender.text.length > 0 ? [[sender text] substringToIndex:1] : nil;
    NSCharacterSet *set = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    if (firstChar && [firstChar rangeOfCharacterFromSet:set].location == NSNotFound) {
        if (self.typeRoosterSegment.selectedSegmentIndex == Pupil && sender.text.length == 6) {
            [sender resignFirstResponder];
            [self downloadTimetable:@"Leerling..."];
        } else if (self.typeRoosterSegment.selectedSegmentIndex == Classroom && sender.text.length == 3) {
            [sender resignFirstResponder];
            [self downloadTimetable:@"Lokaal"];
        }
    } else if (!firstChar){
        //Nothing
    } else if ([firstChar rangeOfCharacterFromSet:set].location != NSNotFound){
        if (sender.text.length == 4) {
            [sender resignFirstResponder];
            [self downloadTimetable:@"Leraar..."];
        }
    }
}
//Pc: Whenever the conditions above are met the keyboard will be hidden

- (IBAction)btnRefreshPressed:(UIBarButtonItem *)sender
{
//    [self downloadTimetable:[self stringForPersonType:self.typeRoosterSegment.selectedSegmentIndex]];
}

-(NSString*)stringForPersonType:(PersonType)type
{
    if (type == Pupil)
        return @"Leerling...";
    if (type == Teacher)
        return @"Leraar...";
    if (type == Classroom)
        return @"Lokaal...";
    
    return nil;
}

#pragma mark - UITextFieldDelegate
//This method makes the keyboard leave the screen whenever the return key is pressed
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
//Pc: the keyboard has been hidden

#pragma mark - UITableViewControllerDelegate
//Whenever the 'Persoonlijk rooster' cell has been clicked, execute the following statements
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSIndexPath *indexPathOfPersoonlijkRooster = [NSIndexPath indexPathForRow:2 inSection:0];

    if ([indexPath isEqual:indexPathOfPersoonlijkRooster] && self.account) {
        [self.typeRoosterSegment setSelectedSegmentIndex:self.account.roostertype];
        [self.roosterVanTextField setText:self.account.roostervan];
        [self txtEditingChanged:self.roosterVanTextField];
    }
}
//Pc: The timetable class has been given order to reload its contents accordingly

#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //Check if the user has a 'roosteraccount configured. If so, we'll set the lblModify text
    // to 'Modify'. If not, set it to 'Configure'
    if ([self.account isConfigured]) {
        [self.lblModify setText:@"Wijzig"];
        [self.lblAccountRoosterVan setText:self.account.roostervan];
    } else {
        [self.lblModify setText:@"Instellen"];
    }
    
    //Set the correct value for the segmented control en keypad of the 'roostervan' textfield
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:BasisRoosterVan]) {
        self.roosterVanTextField.text = [defaults objectForKey:BasisRoosterVan];
        [self.typeRoosterSegment setSelectedSegmentIndex:[[defaults objectForKey:BasisRoosterType] intValue]];
        [self setKeyboardLayoutForType:[[defaults objectForKey:BasisRoosterType] intValue]];
    } else {
        [self.typeRoosterSegment setSelectedSegmentIndex:0];
        [self setKeyboardLayoutForType:Pupil];
    }
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self setRoosterVan:nil];
    [self setAccount:nil];
    [self setTimeTable:nil];
}

@end

#import "AccountTypeViewController.h"
#import "AccountRoostervanViewController.h"

@interface AccountTypeViewController ()
-(IBAction)btnCancelPressed:(UIBarButtonItem*)sender;
@end

@implementation AccountTypeViewController
@synthesize volgende = _volgende;
@synthesize roosterAccount = _roosterAccount;
@synthesize oldIndexPath = _oldIndexPath;

-(void)btnCancelPressed:(UIBarButtonItem *)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Getters & Setters
-(PersoonlijkRooster *)roosterAccount
{
    if (!_roosterAccount) {
        _roosterAccount = [PersoonlijkRooster defaultInstance];
    }
    return _roosterAccount;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.oldIndexPath];
    
    if (!cell) {
        cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    
//    [self.roosterAccount setRoostertype:indexPath.row];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.oldIndexPath = indexPath;
}

- (void)respondToNotification:(NSNotification *)notification
{
    [self.delegate accountDidFinishConfiguring:self.roosterAccount];
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(respondToNotification:)
                                                 name:@"finishedCreatingAccount"
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.roosterAccount.roostertype == Teacher) {
        int row = self.roosterAccount.roostertype;
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        self.oldIndexPath = indexPath;
    } else if (self.roosterAccount.roostertype == Pupil || self.roosterAccount.roostertype == None) {
        int row = 0;
        [self.roosterAccount setRoostertype:Pupil];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        self.oldIndexPath = indexPath;
    }
}

//Respond to memory warnings
-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self setRoosterAccount:nil];
}

@end

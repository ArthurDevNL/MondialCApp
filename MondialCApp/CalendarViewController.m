#import "CalendarViewController.h"
#import "CalendarDetailViewController.h"
#import <Twitter/Twitter.h>

@implementation CalendarViewController
@synthesize table;
@synthesize agendaInfo;
@synthesize twitterText;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Agenda", @"Agenda");
        self.tabBarItem.image = [UIImage imageNamed:@"calendar"];
        agendaInfo = [[AgendaInfo alloc] init];
        [agendaInfo makeInfo];
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setTable:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    
    if ([agendaInfo.arrayOfItems count] == 0) {
        [agendaInfo makeInfo];
        [self.tableView reloadData]; 
    }
    
    [self.tableView reloadData];    
    
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return [agendaInfo numberOfObjectsInDictOfItems];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //Return the number of rows in section
    return [agendaInfo numberOfRowsInSection:section];
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return @"Feesten";
    } else if (section == 1) {
        return @"Ouderavonden";
    } else if (section == 2){
        return @"Vrije dagen";
    } else if (section == 3) {
        return @"Verkorte Lesroosters";
    } else {
        return @"Overig";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.textLabel.text = [agendaInfo getTitle:indexPath.row inSection:indexPath.section]; 

    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    CalendarDetailViewController *detailViewController = [[CalendarDetailViewController alloc] initWithNibName:@"CalendarDetailViewController" bundle:nil];
    
    detailViewController.partyTitle = [agendaInfo getTitle:indexPath.row inSection:indexPath.section];
    detailViewController.partyDescription = [agendaInfo getDescription:indexPath.row atSection:indexPath.section];
    
    twitterText = [[NSString alloc] initWithFormat:[agendaInfo getTweetText:indexPath.row inSection:indexPath.section]];
    
    UIBarButtonItem *actionSheetButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(openActionSheet)];
    detailViewController.navigationItem.rightBarButtonItem = actionSheetButton;
    
    [self.navigationController pushViewController:detailViewController animated:YES];    
}

- (IBAction)openActionSheet {
    
    UIActionSheet *shareActionSheet = [[UIActionSheet alloc] initWithTitle:@"Delen" delegate:self cancelButtonTitle:@"Annuleren" destructiveButtonTitle:nil otherButtonTitles:@"Twitter", nil];
    
    [shareActionSheet showFromTabBar:self.tabBarController.tabBar];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:
            //Check if tweet can be send
            if ([TWTweetComposeViewController canSendTweet]) {
                TWTweetComposeViewController *twitterSheet = [[TWTweetComposeViewController alloc] init];
                
                //Set tweet text
                [twitterSheet setInitialText:twitterText];
                
                twitterSheet.completionHandler = ^(TWTweetComposeViewControllerResult result) {
                    [self dismissModalViewControllerAnimated:YES];
                };
                
                //Show twitter sheet
                [self presentModalViewController:twitterSheet animated:YES];
                
            } else {
                
                //If tweet can't be send:
                UIAlertView *canNotSendTweet = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Kan geen tweet maken. Mogelijk heb je momenteel geen internet verbinding of ben je niet ingelogd op twitter." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [canNotSendTweet show];
            }
            break;
        default:
            break;
    }
}

@end

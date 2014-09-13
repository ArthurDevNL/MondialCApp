#import "DagroosterViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation DagroosterViewController
@synthesize rooster;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Dagrooster", @"Dagrooster");
       self.tabBarItem.image = [UIImage imageNamed:@"notepad"];
    }
    return self;
}
							
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)refresh
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSURL *url = [NSURL URLWithString:[defaults objectForKey:@"dagrooster"]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url
                                                  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                              timeoutInterval:20];
    
    [rooster loadRequest:request];
}

- (void)viewDidUnload
{
    [self setRooster:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSURL *url = [NSURL URLWithString:[defaults objectForKey:@"dagrooster"]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url
                                                  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                              timeoutInterval:10];
    
    [rooster loadRequest:request];
    
    [super viewDidAppear:animated];
}

@end

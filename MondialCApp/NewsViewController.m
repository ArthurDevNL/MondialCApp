#import "NewsViewController.h"
#import "NewsDetailViewController.h"
#import "News.h"
#import "NewsCell.h"

static CGFloat kMaxHeight = 10000;

@interface NewsViewController () <NewsDelegate>

@property (nonatomic) NSArray *articles;

@property (nonatomic) News *news;

@end

@implementation NewsViewController

-(IBAction)btnInfoWasPressed:(id)sender
{
    [self performSegueWithIdentifier:@"ShowDisclaimer" sender:sender];
}

#pragma mark - Table view
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Getting the size of the titlelabel for the cell
    Article *a = self.articles[indexPath.row];
    
    UIFontDescriptor *userFont = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleHeadline];
    UIFont *font = [UIFont fontWithDescriptor:userFont size:17.f];
    CGRect titleSize = [a.Title boundingRectWithSize:CGSizeMake(260.f, kMaxHeight)
                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                     attributes:@{NSFontAttributeName: font}
                                                        context:nil];

    //We want to return the 'default' height of the cell plus the height of a UILabel line times
    // the number of lines
    return 35.f + titleSize.size.height;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.articles count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"NewsCell";
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    [cell setArticle:self.articles[indexPath.row]];
    return cell;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"News Segue"]) {
        NewsDetailViewController *detail = (NewsDetailViewController *)segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        [detail setArticle:self.articles[indexPath.row]];
        
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark - NewsDelegate
-(void)news:(News *)news didFinishFetchingNewArticles:(NSSet *)articles
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self endRefreshing:self.refreshControl];
        
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"PubDate" ascending:NO];
        self.articles = [articles sortedArrayUsingDescriptors:@[sortDescriptor]];
        [self.tableView reloadData];
    });
}

-(void)newsDidStartFetchingNewArticles:(News *)news
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.refreshControl beginRefreshing];
    });
}

-(void)newsDidFinishWithoutNewArticles:(News *)news
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self endRefreshing:self.refreshControl];
    });
}

#pragma mark - Actions
-(IBAction)endRefreshing:(UIRefreshControl*)refresh
{
    if (!self.refreshControl.isRefreshing)
        return;
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"d MMM HH:mm"];
    NSString *lastUpdated = [NSString stringWithFormat:@"Laatst gecheckt: %@", [formatter stringFromDate:[NSDate date]]];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
    [refresh endRefreshing];
}

-(IBAction)refreshControlValueChanged:(UIRefreshControl*)refresh
{
    if (refresh.isRefreshing) {
        refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Verversen..."];
        [self.news refreshArticles];
    }
}

#pragma mark - Getters & Setters
-(News *)news
{
    if (!_news) {
        _news = [News defaultInstance];
        [_news setDelegate:self];
    }
    return _news;
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{    
    [super viewDidLoad];
    
    //Get the articles that are already in chache, sort them by date and put them in memory
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"PubDate" ascending:NO];
    self.articles = [self.news.articles sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    //Set up the refreshcontrol
    UIRefreshControl *refreshControl = [UIRefreshControl new];
    [refreshControl addTarget:self action:@selector(refreshControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
}

@end

#import "RoosterTableViewController.h"
#import "RoosterCell.h"
#import "AppDelegate.h"
#import "InstellingenViewController.h"
#import "UIColor+MLPFlatColors.h"

#import <QuartzCore/QuartzCore.h>

@interface RoosterTableViewController ()
@end

@implementation RoosterTableViewController

#pragma mark - Table View Data Source
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10.f;
}

//Because it can get a bit messy with the calculated heights, we want all the rows to have the same height
// and the last row to fill the space
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    if (indexPath.row != 9) { //If it isn't the last row
        height = round(self.tableView.frame.size.height/10.f);
    } else { //If it is the last row, we subtract all the previous 9 heights from the totalheight
        float totalHeight = roundf(self.tableView.frame.size.height/10.f) * 9.f;
        height = self.tableView.frame.size.height - totalHeight;
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RoosterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Rooster Cell"];
    NSIndexPath *lessonIndex = [NSIndexPath indexPathForRow:(indexPath.row+1) inSection:(self.dag+1)];
    [cell setIndexPath:lessonIndex];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    RoosterCell *cell = (RoosterCell*)[tableView cellForRowAtIndexPath:indexPath];
    [cell switchInformation];
}

#pragma mark - View lifecycle
-(void)viewDidLoad
{
    [super viewDidLoad];
}

@end

//
//  NewsCell.m
//  MondialCApp
//
//  Created by Arthur Hemmer on 7/20/13.
//
//

#import "NewsCell.h"
#import "Article.h"

@interface NewsCell ()
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (nonatomic) NSDateFormatter *formatter;
@end

@implementation NewsCell

//The dateformatter
static NSDateFormatter *formatter;
-(NSDateFormatter *)formatter
{
    if (!formatter) {
        formatter = [NSDateFormatter new];
        [formatter setDateFormat:@"d MMMM, yyyy"];
    }
    return formatter;
}

//Setting the number of lines for the title
-(void)layoutSubviews
{
    [super layoutSubviews];
        
    //Setting the text for the labels
    [self.lblTitle setText:self.article.Title];
    [self.lblDate setText:[self.formatter stringFromDate:self.article.PubDate]];
}

@end

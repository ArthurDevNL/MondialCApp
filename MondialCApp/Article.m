//
//  Article.m
//  MondialCApp
//
//  Created by Arthur Hemmer on 7/16/13.
//
//

#import "Article.h"

NSString *kTitle = @"title";
NSString *kPubDate = @"pubdate";
NSString *kSummary = @"description";
NSString *kLink = @"link";

@interface Article ()
@property (nonatomic) NSDateFormatter *formatter;
@end

@implementation Article

+(instancetype)articleWithInfo:(NSDictionary *)info
{
    return [[Article alloc] initWithInfo:info];
}

//Read the values from the 'info' dictionary and fill in the objects' properties
-(instancetype)initWithInfo:(NSDictionary *)info
{
    self = [super init];
    if (self) {
        self.Title = info[kTitle];
        self.PubDate = [self.formatter dateFromString:info[kPubDate]];
        self.Summary = info[kSummary];
        self.Link = info[kLink] ?: @"";
    }
    return self;
}

#pragma mark - Getters & Setters
static NSDateFormatter *formatter;
-(NSDateFormatter *)formatter
{
    if (!formatter) {
        formatter = [NSDateFormatter new];
        [formatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss z"];
        NSLocale *englishLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
        [formatter setLocale:englishLocale];
    }
    return formatter;
}

#pragma mark - NSCoding
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.Title forKey:kTitle];
    [aCoder encodeObject:self.PubDate forKey:kPubDate];
    [aCoder encodeObject:self.Summary forKey:kSummary];
    [aCoder encodeObject:self.Link forKey:kLink];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.Title = [aDecoder decodeObjectForKey:kTitle];
        self.PubDate = [aDecoder decodeObjectForKey:kPubDate];
        self.Summary = [aDecoder decodeObjectForKey:kSummary];
        self.Link = [aDecoder decodeObjectForKey:kLink];
    }
    return self;
}

@end

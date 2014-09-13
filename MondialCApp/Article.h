//
//  Article.h
//  MondialCApp
//
//  Created by Arthur Hemmer on 7/16/13.
//
//

#import <Foundation/Foundation.h>

extern NSString *kTitle;
extern NSString *kPubDate;
extern NSString *kSummary;
extern NSString *kLink;

@interface Article : NSObject <NSCoding>

@property (nonatomic) NSString *Title;
@property (nonatomic) NSDate *PubDate;
@property (nonatomic) NSString *Summary;
@property (nonatomic) NSString *Link;

+(instancetype)articleWithInfo:(NSDictionary*)info;
-(instancetype)initWithInfo:(NSDictionary*)info;

@end

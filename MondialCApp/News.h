//
//  News.h
//  MondialCApp
//
//  Created by Arthur Hemmer on 7/16/13.
//
//

#import <Foundation/Foundation.h>
#import "Article.h"

@class News;

@protocol NewsDelegate <NSObject>
@required
-(void)newsDidStartFetchingNewArticles:(News*)news;
-(void)news:(News*)news didFinishFetchingNewArticles:(NSSet*)articles;
-(void)newsDidFinishWithoutNewArticles:(News*)news;
@end

typedef void (^Completion)(NSSet *articles);

@interface News : NSObject

//The delegate
@property (nonatomic, weak) id<NewsDelegate> delegate;

//Whenever you want to use the News class, call this instance
+(instancetype)defaultInstance;

//A set containing Article objects
@property (nonatomic) NSSet *articles;

//This method checks if the ticks have changed on the webservice and downloads the new articles if needed
// if the ticks have changed, then the delegate will be called
-(void)refreshArticles;

@end

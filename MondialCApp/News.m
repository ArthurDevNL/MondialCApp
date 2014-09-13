//
//  News.m
//  MondialCApp
//
//  Created by Arthur Hemmer on 7/16/13.
//
//

#import "News.h"
#import "AHPlistManager.h"
#import "AFNetworking.h"

static NSString *URLNews = @"http://mondialapp.mondialweb.nl/Nieuws/Nieuws.php";

typedef void (^Ticks)(NSString *, NSError *);

@interface News ()

//The articles returned from cache
@property (nonatomic) NSSet *cachedArticles;

//The method that downloads and parses the RSS feed in JSON format from the webserver
-(void)fetchArticles:(void(^)(NSSet *articles, NSError *))completion;

@end

@implementation News
@synthesize cachedArticles = _cachedArticles;

#pragma mark - Public Methods
//This method checks the article ticks and refetches all the articles. This method
// also handles the network activity indicator
-(void)refreshArticles
{
    //Set the activity indicator to visible and tell our delegate that we've begun fetching new articles
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self.delegate newsDidStartFetchingNewArticles:self];
    [self fetchArticles:^(NSSet *articles, NSError *error) {
        
        //If something went wrong, finish the sequence
        if (error) {
            [self.delegate newsDidFinishWithoutNewArticles:self];
            
        } else { //Everything went OK, so we'll cache the new articles and tell our delegate that we've finished
            [self setCachedArticles:articles];
            [self.delegate news:self didFinishFetchingNewArticles:articles];
        }
        
        //Hide the network inidicator
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
}

+(instancetype)defaultInstance
{
    static News *_sharednews;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharednews = [News new];
    });
    
    return _sharednews;
}

-(NSSet *)articles
{
    return self.cachedArticles;
}

#pragma mark - Requests
//This method is called from -refreshArticles to download the all the articles form the webservice
// it will be an asynchronous request so the Article objects will be returned through the completion block
-(void)fetchArticles:(void (^)(NSSet *, NSError *))completion
{
    //Construct the URL, request and create an asynchronous connection
    NSURL *URL = [NSURL URLWithString:URLNews];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL
                                             cachePolicy:NSURLRequestReloadIgnoringCacheData
                                         timeoutInterval:20.f];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *r, NSData *d, NSError *e) {
        //Check for errors and datalength
        if (!e && d.length > 0) {
            NSError *JSONError;
            NSArray *array = [NSJSONSerialization JSONObjectWithData:d options:NSJSONReadingAllowFragments error:&JSONError];
            
            //Fill the set with Article objects
            NSMutableSet *articles = [NSMutableSet setWithCapacity:array.count];
            for (NSDictionary *info in array) {
                Article *a = [Article articleWithInfo:info];
                [articles addObject:a];
            }
            
            //Complete
            if (completion)
                completion(articles, nil);
        } else {
            //Complete with error and no articles
            if (completion)
                completion(nil, e);
        }
    }];
}

#pragma mark - Getters & Setters
static NSString *kPlistArticles = @"MondialCAppArticles";
static NSString *kPlistNewArticles = @"MondialCAppNewArticles";
-(NSSet *)cachedArticles
{    
    if (!_cachedArticles) {
        _cachedArticles = [[AHPlistManager alloc] initWithName:kPlistNewArticles delegate:nil].contents;
        
        //Because we've changed the model, delete the old articles file
        AHPlistManager *oldPlist = [[AHPlistManager alloc] initWithName:kPlistArticles delegate:nil];
        if ([[NSFileManager defaultManager] fileExistsAtPath:[[oldPlist fileUrl] path]]) {
            NSError *error;
            [[NSFileManager defaultManager] removeItemAtURL:[oldPlist fileUrl] error:&error];
        }
    }
    return _cachedArticles;
}

-(void)setCachedArticles:(NSSet *)cachedArticles
{
    if (_cachedArticles != cachedArticles) {
        _cachedArticles = cachedArticles;
        
        AHPlistManager *plist = [[AHPlistManager alloc] initWithName:kPlistNewArticles delegate:nil];
        [plist setContents:cachedArticles];
    }
}

@end

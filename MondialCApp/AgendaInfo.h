#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AgendaInfo : NSObject {

}

@property (strong, retain) NSMutableArray *arrayOfItems;
@property (strong, retain) NSMutableArray *arrayOfTitles;
@property (strong, retain) NSMutableArray *arrayOfHeaders;

- (NSInteger)numberOfRowsInSection:(NSInteger)atSection;
- (NSInteger)numberOfObjectsInDictOfItems;
- (NSString *)getTitle:(NSInteger)atIndex inSection:(NSInteger)indexPathSection; 
- (NSString *)getHeaders:(NSInteger)atIndex;
- (NSString *)getTweetText:(NSInteger)atIndex inSection:(NSInteger)indexPathSection;
- (NSString *)getDescription:(NSInteger)atIndex atSection:(NSInteger)indexPathSection;
- (void) makeInfo;

@end

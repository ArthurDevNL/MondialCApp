#import "AgendaInfo.h"

@implementation AgendaInfo
@synthesize arrayOfItems, arrayOfTitles, arrayOfHeaders;

- (NSInteger)numberOfRowsInSection:(NSInteger)atSection {
    
    return [[arrayOfItems objectAtIndex:atSection] count];
}

- (NSString *)getTitle:(NSInteger)atIndex inSection:(NSInteger)indexPathSection {

    return [[arrayOfTitles objectAtIndex:indexPathSection] objectAtIndex:atIndex];
}

- (NSString *)getHeaders:(NSInteger)section {

    return [arrayOfHeaders objectAtIndex:section];
}

- (NSInteger) numberOfObjectsInDictOfItems {
    
    return [arrayOfItems count];
}

- (NSString*) getTweetText:(NSInteger)atIndex inSection:(NSInteger)indexPathSection {
    
    return [[[arrayOfItems objectAtIndex:indexPathSection] objectAtIndex:atIndex] objectForKey:@"tweettext"];

}

- (NSString*)getDescription:(NSInteger)atIndex atSection:(NSInteger)indexPathSection {

    
    return [[[arrayOfItems objectAtIndex:indexPathSection] objectAtIndex:atIndex] objectForKey:@"description"];
}

- (void) makeInfo {  
    
    arrayOfTitles = [[NSMutableArray alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://mondialapp.mondialweb.nl/agenda/agenda.plist"]];
    
    arrayOfItems = [[NSMutableArray alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://mondialapp.mondialweb.nl/agenda/agendainfo.plist"]];


}



@end

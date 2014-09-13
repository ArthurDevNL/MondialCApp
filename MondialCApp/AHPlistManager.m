//
//  AHPlistManager.m
//  PropertyListManager
//
//  Created by Arthur Hemmer on 12/31/12.
//  Copyright (c) 2012 Arthur Hemmer. All rights reserved.
//

#import "AHPlistManager.h"

@interface AHPlistManager ()
-(BOOL)isArray:(id)plist;
-(BOOL)isDictionary:(id)plist;
- (NSURL *)fileUrl;
-(void)save:(id)plist;
@end

@implementation AHPlistManager
@synthesize contents = _contents;

-(id)initWithName:(NSString *)name delegate:(id<AHPlistManagerDelegate>)delegate
{
    self = [super init];
    if (self) {
        _name = name;
        _delegate = delegate;
        [self contents];
    }
    
    return self;
}

-(BOOL)isArray:(id)plist
{
    if ([plist isKindOfClass:[NSArray class]]) {
        return true;
    }
    
    return false;
}

-(BOOL)isDictionary:(id)plist
{
    if ([plist isKindOfClass:[NSDictionary class]]) {
        return true;
    }
    
    return false;
}

-(id)contents
{
    if (!_contents) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:[self.fileUrl path]]) {
            NSData *contentsData = [NSData dataWithContentsOfURL:self.fileUrl];
            _contents = [NSKeyedUnarchiver unarchiveObjectWithData:contentsData];
        }
    }
    
    return _contents;
}

-(void)setContents:(id)contents
{
    _contents = contents;
    [self save:_contents];
}

//This is a private method which saves the given plist
-(void)save:(id)plist
{
    NSData *contentsData = [NSKeyedArchiver archivedDataWithRootObject:plist];
    if (![contentsData writeToFile:[self.fileUrl path] atomically:YES]) {
        NSException *exception = [NSException exceptionWithName:@"Write error" reason:@"Could not write data to path." userInfo:nil];
        @throw exception;
    } else {
        [self.delegate plistManager:self didUpdate:self.contents];
    }
}

// Returns the URL to the file.
- (NSURL *)fileUrl
{
    NSURL *documents = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    return [documents URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", _name]];
}

@end

//
//  AHPlistManager.h
//  PropertyListManager
//
//  Created by Arthur Hemmer on 12/31/12.
//  Copyright (c) 2012 Arthur Hemmer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AHPlistManager;

@protocol AHPlistManagerDelegate <NSObject>
-(void)plistManager:(AHPlistManager*)plistManager didUpdate:(id)content;
@end

@interface AHPlistManager : NSObject
@property (nonatomic) id contents;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, weak) id<AHPlistManagerDelegate> delegate;

-(id)initWithName:(NSString*)name delegate:(id<AHPlistManagerDelegate>)delegate;

//Returns the url for the current propertylist
-(NSURL*)fileUrl;

@end

//
//  Stack.h
//  TimeTable
//
//  Created by Arthur Hemmer on 12/26/12.
//  Copyright (c) 2012 Arthur Hemmer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Stack : NSObject
-(id)pop;
-(void)push:(id)element;
-(int)size;
@end

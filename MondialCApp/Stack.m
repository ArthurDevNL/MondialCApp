//
//  Stack.m
//  TimeTable
//
//  Created by Arthur Hemmer on 12/26/12.
//  Copyright (c) 2012 Arthur Hemmer. All rights reserved.
//

#import "Stack.h"

@interface Stack ()
@property (nonatomic, strong) NSMutableArray *stack;
@end

@implementation Stack

-(id)pop
{
    if ([self size] == 0) {
        NSException *exception = [NSException exceptionWithName:@"Nothing on stack." reason:@"No items have been found on the stack" userInfo:nil];
        [exception raise];
        return nil;
    } else {
        id obj = [self.stack lastObject];
        [self.stack removeObject:obj];
        return obj;
    }
}

-(int)size
{
    return (int)self.stack.count;
}

-(void)push:(id)element
{
    [self.stack addObject:element];
}

-(NSMutableArray *)stack
{
    if (!_stack) {
        _stack = [NSMutableArray new];
    }

    return _stack;
}

@end

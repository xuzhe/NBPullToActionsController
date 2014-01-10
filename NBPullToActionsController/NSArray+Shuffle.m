//
//  NSArray+Shuffle.m
//  iDaily
//
//  Created by James Chen on 8/10/10.
//  Copyright 2010 ラクラクテクノロジーズ. All rights reserved.
//

#import "NSArray+Shuffle.h"


@implementation NSArray (Shuffle)

- (NSArray *)shuffle {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self count]];
    
    NSMutableArray *copy = [self mutableCopy];
    while ([copy count] > 0)
    {
        int index = arc4random() % [copy count];
        id obj = [copy objectAtIndex:index];
        [array addObject:obj];
        [copy removeObjectAtIndex:index];
    }
    
    return array;
}

@end

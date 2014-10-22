//
//  PKAppearance.m
//  PKAppearance
//
//  Created by Walig Castain on 22/10/14.
//  Copyright (c) 2014 Walig Castain. All rights reserved.
//

#import "PKAppearance.h"

@interface PKAppearance ()

@property (strong, nonatomic) Class mainClass;
@property (strong, nonatomic) NSMutableArray *invocations;

@end

static NSMutableDictionary *dictionaryOfClasses = nil;

@implementation PKAppearance

// this method return the same object instance for each different class
+ (id)appearanceForClass:(Class)thisClass
{
    // create the dictionary if not exists
    // use a dispatch to avoid problems in case of concurrent calls
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!dictionaryOfClasses)
            dictionaryOfClasses = [[NSMutableDictionary alloc] init];
    });
    
    if (![dictionaryOfClasses objectForKey:NSStringFromClass(thisClass)])
    {
        id thisAppearance = [[self alloc] initWithClass:thisClass];
        [dictionaryOfClasses setObject:thisAppearance forKey:NSStringFromClass(thisClass)];
        return thisAppearance;
    } else {
        return [dictionaryOfClasses objectForKey:NSStringFromClass(thisClass)];
    }
}

- (id)initWithClass:(Class)thisClass
{
    self.mainClass = thisClass;
    self.invocations = [NSMutableArray array];

    return self;
}

- (id)init
{
    [NSException exceptionWithName:@"InvalidOperation" reason:@"Cannot invoke init. Use appearanceForClass: method" userInfo:nil];
    return nil;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation;
{
    // tell the invocation to retain arguments
    [anInvocation retainArguments];
    
    // add the invocation to the array
    [self.invocations addObject:anInvocation];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return [self.mainClass instanceMethodSignatureForSelector:aSelector];
}

- (void)startForwarding:(id)sender
{
    for (NSInvocation *invocation in self.invocations) {
        [invocation setTarget:sender];
        [invocation invoke];
    }
}

@end

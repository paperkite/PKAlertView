//
//  PKAppearance.h
//  PKAppearance
//
//  Created by Walig Castain on 22/10/14.
//  Copyright (c) 2014 Walig Castain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PKAppearance : NSProxy

+ (id)appearanceForClass:(Class)thisClass;

- (void)startForwarding:(id)sender;

@end

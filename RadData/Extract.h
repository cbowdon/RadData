//
//  Extract.h
//  RadData
//
//  Created by Chris on 11-10-30.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Extract : NSObject

+(NSUInteger)shortAtIndex:(NSUInteger)index ofData:(NSData*)data;

+(NSNumber*)real48AtIndex:(NSUInteger)index ofData:(NSData*)data;


@end

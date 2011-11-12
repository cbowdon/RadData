//
//  RadData.h
//  RadData
//
//  Created by Chris on 11-10-29.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Extract.h"
#import "Radioisotope.h"

@interface RadData : NSObject {
	NSArray *_isotopes;
}

@property (nonatomic, strong) NSArray *isotopes;

-(NSArray*)loadIsotopes;
-(Radioisotope*)extractIsotopeAtIndex:(NSUInteger)index ofRecords:(NSData*)data;
-(NSArray*)findIsotopeWithName:(NSString*)name;

@end

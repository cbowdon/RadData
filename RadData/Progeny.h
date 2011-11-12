//
//  Progeny.h
//  RadData
//
//  Created by Chris on 11-10-30.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Radioisotope;

@interface Progeny : NSObject {
	NSString *name;
	Radioisotope *isotope;
	NSNumber *probability;
	NSString *_stringValue;
}

@property (nonatomic, strong) NSString *name;
@property (nonatomic, weak) Radioisotope *isotope;
@property (nonatomic, strong) NSNumber *probability;
@property (readonly, strong) NSString *stringValue;

-(NSString*)stringValue;

@end

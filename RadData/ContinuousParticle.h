//
//  ContinuousParticle.h
//  RadData
//
//  Created by Chris on 11-11-7.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContinuousParticle : NSObject {
	NSNumber *probability;
	NSNumber *energy;
	NSNumber *maxEnergy;
}

@property (readonly, strong) NSNumber* probability;
@property (readonly, strong) NSNumber* energy;
@property (readonly, strong) NSNumber* maxEnergy;

-(id)initWithProbability:(NSNumber*)prob energy:(NSNumber*)en andMaxEnergy:(NSNumber*)maxEn;

@end

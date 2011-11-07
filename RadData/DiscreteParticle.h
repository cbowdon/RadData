//
//  DiscreteParticle.h
//  RadData
//
//  Created by Chris on 11-11-7.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiscreteParticle : NSObject {
	NSNumber *probability;
	NSNumber *energy;
}

@property (readonly, strong) NSNumber* probability;
@property (readonly, strong) NSNumber* energy;

-(id)initWithProbability:(NSNumber*)prob andEnergy:(NSNumber*)en;

@end

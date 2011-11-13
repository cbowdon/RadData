//
//  ContinuousParticle.m
//  RadData
//
//  Created by Chris on 11-11-7.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "ContinuousParticle.h"

@implementation ContinuousParticle

@synthesize probability = _probability, energy = _energy, maxEnergy = _maxEnergy, stringValue = _stringValue;

-(id)initWithProbability:(NSNumber *)prob energy:(NSNumber *)en andMaxEnergy:(NSNumber *)maxEn
{
    self = [super init];
    if (self) {
        _probability = prob;
		_energy = en;
		_maxEnergy = maxEn;
	}
    return self;	
}

-(NSString*)stringValue
{
	return [NSString stringWithFormat:@"%.3f MeV max\t %.3f MeV avg", [self.maxEnergy doubleValue], [self.energy doubleValue]];
}

@end

//
//  DiscreteParticle.m
//  RadData
//
//  Created by Chris on 11-11-7.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "DiscreteParticle.h"

@implementation DiscreteParticle

@synthesize probability = _probability, energy = _energy, stringValue = _stringValue;

-(id)initWithProbability:(NSNumber *)prob andEnergy:(NSNumber *)en
{
    self = [super init];
    if (self) {
        _probability = prob;
		_energy = en;		
	}
    return self;	
}

-(NSString*)stringValue
{
	return [NSString stringWithFormat:@"%.3f%c\t %.3f MeV", [self.probability doubleValue], '%', [self.energy doubleValue]];
}

@end

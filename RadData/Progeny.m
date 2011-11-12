//
//  Progeny.m
//  RadData
//
//  Created by Chris on 11-10-30.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "Progeny.h"

@implementation Progeny

@synthesize name = _name, isotope = _isotope, probability = _probability, stringValue = _stringValue;

-(NSString*)stringValue
{
	return [NSString stringWithFormat:@"%.3f%c\t %@", 100*[self.probability doubleValue], '%', self.name];
}

@end

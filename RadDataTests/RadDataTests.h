//
//  RadDataTests.h
//  RadDataTests
//
//  Created by Chris on 11-10-29.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "RadData.h"

@interface RadDataTests : SenTestCase {
	RadData *rad;
	Radioisotope *first;
	Radioisotope *am241;
	Radioisotope *sr90;
	Radioisotope *xe123;
	Radioisotope *last;
}

@end

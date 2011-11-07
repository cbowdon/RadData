//
//  Extract.m
//  RadData
//
//  Created by Chris on 11-10-30.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "Extract.h"

@implementation Extract

+(NSUInteger)shortAtIndex:(NSUInteger)index ofData:(NSData *)data
{
	unsigned char shortBuffer[2];
	NSRange shortRange = {index, 2};
	[data getBytes:shortBuffer range:shortRange];
	return shortBuffer[0]+(shortBuffer[1] << 8);
}

+(NSNumber*)real48AtIndex:(NSUInteger)index ofData:(NSData *)data
{
	unsigned char realBuffer[6];
	NSRange realRange = {index, 6};
	[data getBytes:realBuffer range:realRange];
	
	if (realBuffer[0] == 0) {
		return [[NSNumber alloc]  initWithDouble:0];
	}
	
	double exponent = realBuffer[0] - 129.0;
	double mantissa = 0;
	NSUInteger i;
	for (i = 1; i <= 4; i++) {
		mantissa += realBuffer[i];
		mantissa /= 256.0;
	}
	
	mantissa += (realBuffer[5] & 0x7F);
	mantissa /= 128.0;
	mantissa += 1.0;
	
	// Sign bit check
	if ((realBuffer[5] & 0x80) == 0x80) {
		mantissa = -mantissa;
	}
	
	return [[NSNumber alloc] initWithDouble:mantissa * pow(2,exponent)];
}

@end

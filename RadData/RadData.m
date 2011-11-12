//
//  RadData.m
//  RadData
//
//  Created by Chris on 11-10-29.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "RadData.h"

@implementation RadData

@synthesize isotopes = _isotopes;

- (id)init
{
    self = [super init];
    if (self) {
        // Load array of isotopes
		_isotopes = [self loadIsotopes];
		// give each item in array a reference to the array
		NSUInteger i;
		for (i = 0; i < [self.isotopes count]; i++) {
			Radioisotope *r = [self.isotopes objectAtIndex:i];
			r.collection = self.isotopes;
		}
		
    }
    
    return self;
}

-(NSUInteger)numberOfIsotopes 
{
	return [self.isotopes count];
}

-(NSArray*)loadIsotopes 
{	
	NSString *folder = @"";
	NSString *fileName = @"NUCLIDES";
	NSString *extension = @"REC";
	NSString *fullPath = [folder stringByAppendingPathComponent:fileName];
	fullPath = [fullPath stringByAppendingPathExtension:extension];
	
	NSData *contents = [NSData dataWithContentsOfFile:fullPath];
	NSMutableArray *topes = [NSMutableArray arrayWithCapacity:(uint)497];
	
	NSUInteger i;
	for (i = 0; i < 497; i++) {
		Radioisotope *tope = [self extractIsotopeAtIndex:i ofRecords:contents];
		[topes addObject: tope];
	}
	
	return [[NSArray alloc] initWithArray:topes];
}

-(Radioisotope*)extractIsotopeAtIndex:(NSUInteger)index ofRecords:(NSData*)data 
{
	Radioisotope *tope = [[Radioisotope alloc] init];
	
	// Get name
	NSRange nameRange = {44*index+1, 7};
	NSData *subset = [data subdataWithRange:nameRange];
	NSString *name = [[NSString alloc] initWithData:subset encoding:NSASCIIStringEncoding];	
	tope.name = [name stringByReplacingOccurrencesOfString:@" " withString:@""];	
	
	// Get mass
	NSUInteger massIndex = 44*index+9;
	tope.mass = [Extract shortAtIndex:massIndex ofData:data];
	
	// Get atomic number
	NSUInteger atomicNumberIndex = 44*index+11;
	tope.atomicNumber = [Extract shortAtIndex:atomicNumberIndex ofData:data];
	
	// Get half life
	NSUInteger halfLifeNumberIndex = 44*index+13;
	NSUInteger halfLifeUnitIndex = 44*index+19;
	tope.halfLifeNumber = [Extract real48AtIndex:halfLifeNumberIndex ofData:data];
	unsigned char unit[1];
	NSRange unitRange = {halfLifeUnitIndex, 1};
	[data getBytes:unit range:unitRange];
	tope.halfLifeUnit = [[NSString alloc] initWithBytes:unit length:1 encoding:NSASCIIStringEncoding];
	
	// Get progeny number and start
	NSUInteger nProgenyIndex = 44*index+20;
	NSUInteger progenyStartIndex = 44*index+22;
	tope.nProgeny = [Extract shortAtIndex:nProgenyIndex ofData:data];
	tope.progenyStart = [Extract shortAtIndex:progenyStartIndex ofData:data];
	
	// Get alpha number and start
	NSUInteger nAlphasIndex = 44*index+24;
	NSUInteger alphaStartIndex = 44*index+26;
	tope.nAlphas = [Extract shortAtIndex:nAlphasIndex ofData:data];
	tope.alphaStart = [Extract shortAtIndex:alphaStartIndex ofData:data];
	
	// Get beta number and start
	NSUInteger nBetasIndex = 44*index+28;
	NSUInteger betaStartIndex = 44*index+30;
	tope.nBetas = [Extract shortAtIndex:nBetasIndex ofData:data];
	tope.betaStart = [Extract shortAtIndex:betaStartIndex ofData:data];
	
	// Get positron number and start
	NSUInteger nPositronsIndex = 44*index+32;
	NSUInteger positronStartIndex = 44*index+34;
	tope.nPositrons = [Extract shortAtIndex:nPositronsIndex ofData:data];
	tope.positronStart = [Extract shortAtIndex:positronStartIndex ofData:data];
	
	// Get negatron number and start
	NSUInteger nNegatronsIndex = 44*index+36;
	NSUInteger negatronStartIndex = 44*index+38;
	tope.nNegatrons = [Extract shortAtIndex:nNegatronsIndex ofData:data];
	tope.negatronStart = [Extract shortAtIndex:negatronStartIndex ofData:data];
	
	// Get photon number and start
	NSUInteger nPhotonsIndex = 44*index+40;
	NSUInteger photonStartIndex = 44*index+42;
	tope.nPhotons = [Extract shortAtIndex:nPhotonsIndex ofData:data];
	tope.photonStart = [Extract shortAtIndex:photonStartIndex ofData:data];
	
	return tope;
}

-(NSArray*)findIsotopeWithName:(NSString *)name {
	
	NSPredicate *symbolProper = [NSPredicate predicateWithFormat:@"SELF MATCHES '[A-Za-z]{1,2}-[0-9]{1,3}'"];
	NSPredicate *symbolShort = [NSPredicate predicateWithFormat:@"SELF MATCHES '[A-Za-z]{1,2}[0-9]{1,3}'"];
	NSPredicate *symbolBackwards = [NSPredicate predicateWithFormat:@"SELF MATCHES '[0-9]{1,3}[A-Za-z]{1,2}'"];
	NSPredicate *symbolLetters = [NSPredicate predicateWithFormat:@"SELF MATCHES '[A-Za-z]{1,2}'"];
	NSPredicate *symbolNumbers = [NSPredicate predicateWithFormat:@"SELF MATCHES '.*[0-9]{1,3}.*'"];
	NSPredicate *oneLetter = [NSPredicate predicateWithFormat:@"SELF MATCHES '[A-Za-z]+'"];
	
	
	NSArray *filteredArray; 
	NSArray *symbolShortArray;
	NSArray *symbolLettersArray;
	NSArray *symbolNumbersArray;
	NSArray *oneLetterArray;
	NSPredicate *match;
	
	
	// check for an exact match
	if ([symbolProper evaluateWithObject:name] == YES) {
				
		match = [NSPredicate predicateWithFormat:@"name == %@", name];
		filteredArray =	[self.isotopes filteredArrayUsingPredicate:match];
		if ([filteredArray count] == 1) {
			return filteredArray;
		}
	}
	NSMutableArray *joinedResults = [[NSMutableArray alloc] initWithArray:filteredArray];

	
	// extract numbers
	NSString *numberString;
	NSScanner *numberScanner = [NSScanner scannerWithString:name];
	NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
	[numberScanner scanUpToCharactersFromSet:numbers intoString:NULL];
	[numberScanner scanCharactersFromSet:numbers intoString:&numberString];
	
	// extract letters
	NSString *letterString;
	NSScanner *letterScanner =[NSScanner scannerWithString:name];
	NSCharacterSet *letters = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"];
	[letterScanner scanUpToCharactersFromSet:letters intoString:NULL];
	[letterScanner scanCharactersFromSet:letters intoString:&letterString];
	
	// check for an exact match where they left out the hyphen
	// or an exact match where they wrote it backwards	
	if ([symbolShort evaluateWithObject:name] == YES ||
		[symbolBackwards evaluateWithObject:name] == YES) {
				
		NSString *shortMatchExpr = [NSString stringWithFormat:@"%@*%@", letterString, numberString];
		
		match = [NSPredicate predicateWithFormat:@"name like %@", shortMatchExpr];		
		symbolShortArray = [self.isotopes filteredArrayUsingPredicate:match];
				
		if ([symbolShortArray count] == 1) {
			return symbolShortArray;
		}
	} 

	[joinedResults addObjectsFromArray:symbolShortArray];

	
	if ([symbolLetters evaluateWithObject:name] == YES) {		
				
		NSString *letterMatchExpr = [NSString stringWithFormat:@"%@*", letterString];
		match = [NSPredicate predicateWithFormat:@"name like %@", letterMatchExpr];		
		symbolLettersArray = [self.isotopes filteredArrayUsingPredicate:match];
	}
	[joinedResults addObjectsFromArray:symbolLettersArray];

	
	if ([symbolNumbers evaluateWithObject:name] == YES) {
				
		match = [NSPredicate predicateWithFormat:@"mass == %i", [numberString integerValue]];							
		symbolNumbersArray = [self.isotopes filteredArrayUsingPredicate:match];
	}
	[joinedResults addObjectsFromArray:symbolNumbersArray];

	if ([oneLetter evaluateWithObject:name] == YES && [joinedResults count] == 0) {
		
		NSString *charMatchExpr = [NSString stringWithFormat:@"%c*", [[name capitalizedString] characterAtIndex:0]];
		match = [NSPredicate predicateWithFormat:@"name like %@", charMatchExpr];
		oneLetterArray = [self.isotopes filteredArrayUsingPredicate:match];		
	}
	[joinedResults addObjectsFromArray:oneLetterArray];
	
	return joinedResults;
	
}

@end

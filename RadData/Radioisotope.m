//
//  Radioisotope.m
//  RadData
//
//  Created by Chris on 11-10-29.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "Radioisotope.h"
#import "Extract.h"

@implementation Radioisotope

@synthesize collection = _collection;
@synthesize name = _name, atomicNumber = _atomicNumber, mass = _mass;
@synthesize halfLifeNumber = _halfLifeNumber, halfLifeUnit = _halfLifeUnit, halfLifeString = _halfLifeString;
@synthesize nProgeny = _nProgeny, progenyStart = _progenyStart;
@synthesize nAlphas = _nAlphas, alphaStart = _alphaStart;
@synthesize	nBetas = _nBetas, betaStart = _betaStart;
@synthesize nPositrons = _nPositrons, positronStart = _positronStart;
@synthesize nNegatrons = _nNegatrons, negatronStart = _negatronStart;
@synthesize nPhotons = _nPhotons, photonStart = _photonStart;
@synthesize contents = _contents;

-(NSString*)halfLifeString
{
	if (!_halfLifeString) {
		NSString *longUnit;
		if ([self.halfLifeUnit isEqualToString:@"S"]) {
			longUnit = @"seconds";
		} else if ([self.halfLifeUnit isEqualToString:@"M"]) {
			longUnit = @"minutes";
		} else if ([self.halfLifeUnit isEqualToString:@"H"]) {
			longUnit = @"hours";
		} else if ([self.halfLifeUnit isEqualToString:@"D"]) {
			longUnit = @"days";
		} else if ([self.halfLifeUnit isEqualToString:@"Y"]) {
			longUnit = @"years";
		}
		_halfLifeString = [NSString stringWithFormat:@"%.3f %@", [self.halfLifeNumber doubleValue], longUnit];
	}
	return _halfLifeString;
}

-(NSArray*)progeny
{	
	if (_progeny) {
		return _progeny;
	} 
	
	//	NSString *folder = @"";
	//	NSString *fileName = @"PROGENY";
	//	NSString *extension = @"REC";
	//	NSString *fullPath = [folder stringByAppendingPathComponent:fileName];
	//	fullPath = [fullPath stringByAppendingPathExtension:extension];
	
	NSString *fullPath = [[NSBundle mainBundle] pathForResource: @"PROGENY" ofType: @"REC"];
	
	NSFileHandle *file = [NSFileHandle fileHandleForReadingAtPath:fullPath];
	
	if (file == nil) {
		NSLog(@"\n\nFailed to read %@\n\n", fullPath);
	}
	
	NSUInteger recordLength = 8;
	
	// make temporary mutable array for progeny
	NSMutableArray *progs = [[NSMutableArray alloc] initWithCapacity:self.nProgeny];
	
	NSUInteger i;		
	for (i = 0; i < self.nProgeny; i++) {
		
		// get data from file into buffer
		NSUInteger fileOffset = recordLength*(self.progenyStart+i-1); 
		[file seekToFileOffset:fileOffset];
		NSData *buffer = [file readDataOfLength:recordLength];
		
		// get position and probability from buffer
		// remembering 1st->0th conversion
		NSUInteger pos = [Extract shortAtIndex:0 ofData:buffer]-1;		
		NSNumber *prob = [Extract real48AtIndex:2 ofData:buffer];
		
		// make and fill in a Progeny
		Progeny *prog = [[Progeny alloc] init];				
		prog.isotope = [self.collection objectAtIndex:pos];
		prog.name = [[NSString alloc] initWithString:prog.isotope.name];
		prog.probability = prob;
		
		// add to temp array
		[progs addObject:prog];
	}
	
	// initialize a fixed array
	_progeny = [[NSArray alloc] initWithArray:progs];	
	return _progeny;
}

-(NSArray*)alphas
{
	if (!_alphas) {
		_alphas = [self getDiscrete:@"ALPHA" nParticles:self.nAlphas startPoint:self.alphaStart];
	} 
	return _alphas;
}

-(NSArray*)betas
{
	if (!_betas) {
		_betas = [self getContinuous:@"BETAS" nParticles:self.nBetas startPoint:self.betaStart];
	} 
	return _betas;
}

-(NSArray*)positrons {
	if (!_positrons) {
		_positrons = [self getContinuous:@"POSITRON" nParticles:self.nPositrons startPoint:self.positronStart];
	} 	
	return _positrons;
}

-(NSArray*)negatrons {
	
	if (!_negatrons) {
		_negatrons = [self getDiscrete:@"ELECTRON" nParticles:self.nNegatrons startPoint:self.negatronStart];
	} 
	return _negatrons;
}

-(NSArray*)photons {
	
	if (!_photons) {
		_photons = [self getDiscrete:@"PHOTONS" nParticles:self.nPhotons startPoint:self.photonStart];
	} 
	return _photons;
}

-(NSDictionary*)contents
{
	if (!_contents) {
		NSMutableDictionary *mut = [[NSMutableDictionary alloc] init];
		if (self.nProgeny > 0) {
			[mut setValue:self.progeny forKey:@"Progeny"];
		}
		if (self.nAlphas > 0) {
			[mut setValue:self.alphas forKey:@"Alphas"];
		}
		if (self.nBetas > 0) {
			[mut setValue:self.betas forKey:@"Betas"];
		}
		if (self.nPositrons > 0){
			[mut setValue:self.positrons forKey:@"Positrons"];	
		}
		if (self.nNegatrons > 0) {
			[mut setValue:self.negatrons forKey:@"Negatrons"];
		} 
		if (self.nPhotons > 0) {
			[mut setValue:self.photons forKey:@"Photons"];	
		}		
		_contents = [[NSDictionary alloc] initWithDictionary:mut];
	}
	return _contents;
}

-(NSArray*)getDiscrete:(NSString *)fileName nParticles:(NSUInteger)n startPoint:(NSUInteger)s {
	
	//	NSString *folder = @"";
	//	NSString *extension = @"REC";
	//	NSString *fullPath = [folder stringByAppendingPathComponent:fileName];
	//	fullPath = [fullPath stringByAppendingPathExtension:extension];
	
	NSString *fullPath = [[NSBundle mainBundle] pathForResource:fileName ofType: @"REC"];
	
	
	NSFileHandle *file = [NSFileHandle fileHandleForReadingAtPath:fullPath];
	
	if (file == nil) {
		NSLog(@"\n\nFailed to read %@\n\n", fullPath);
	}
	
	NSUInteger recordLength = 12;
	
	// make temporary mutable array
	NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:n];
	
	// load alphas from file into mut array
	NSUInteger i;
	for (i = 0; i < n; i++) {
		// get data from file into buffer
		NSUInteger fileOffset = recordLength*(s+i-1); 
		[file seekToFileOffset:fileOffset];
		NSData *buffer = [file readDataOfLength:recordLength];
		
		// get position and probability from buffer
		// remembering 1st->0th conversion
		NSNumber *en = [Extract real48AtIndex:0 ofData:buffer];
		NSNumber *prob = [Extract real48AtIndex:6 ofData:buffer];
		
		// make and fill in a discrete particle
		DiscreteParticle *a = [[DiscreteParticle alloc] initWithProbability:prob andEnergy:en];				
		
		// add to temp array
		[array addObject:a];
	}
	
    return [[NSArray alloc] initWithArray:array];	
}

-(NSArray*)getContinuous:(NSString *)fileName nParticles:(NSUInteger)n startPoint:(NSUInteger)s {
	
	//	NSString *folder = @"";
	//	NSString *extension = @"REC";
	//	NSString *fullPath = [folder stringByAppendingPathComponent:fileName];
	//	fullPath = [fullPath stringByAppendingPathExtension:extension];
	
	NSString *fullPath = [[NSBundle mainBundle] pathForResource:fileName ofType: @"REC"];
	
	NSFileHandle *file = [NSFileHandle fileHandleForReadingAtPath:fullPath];
	
	if (file == nil) {
		NSLog(@"\n\nFailed to read %@\n\n", fullPath);
	}
	
	NSUInteger recordLength = 18;
	
	// make temporary mutable array
	NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:n];
	
	// load from file into mut array
	NSUInteger i;
	for (i = 0; i < n; i++) {
		// get data from file into buffer
		NSUInteger fileOffset = recordLength*(s+i-1); 
		[file seekToFileOffset:fileOffset];
		NSData *buffer = [file readDataOfLength:recordLength];
		
		// get position and probability from buffer
		// remembering 1st->0th conversion
		NSNumber *maxEn = [Extract real48AtIndex:0 ofData:buffer];
		NSNumber *en = [Extract real48AtIndex:6 ofData:buffer];
		NSNumber *prob = [Extract real48AtIndex:12 ofData:buffer];
		
		// make and fill in
		ContinuousParticle *a = [[ContinuousParticle alloc] initWithProbability:prob energy:en andMaxEnergy:maxEn];						
		// add to temp array
		[array addObject:a];
	}
	
    return [[NSArray alloc] initWithArray:array];	
}

@end

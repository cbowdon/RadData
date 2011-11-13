//
//  Radioisotope.h
//  RadData
//
//  Created by Chris on 11-10-29.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Progeny.h"
#import "ContinuousParticle.h"
#import "DiscreteParticle.h"

@interface Radioisotope : NSObject {
	
	NSArray *collection;
	
	NSString *name;
	NSUInteger mass;
	NSUInteger atomicNumber;
	
	NSNumber *halfLifeNumber;
	NSString *halfLifeUnit;
	NSString *_halfLifeString;

	NSUInteger nProgeny;
	NSUInteger progenyStart;
	NSArray *_progeny;
	
	NSUInteger *nAlphas;
	NSUInteger alphaStart;
	NSArray *_alphas;
	
	NSUInteger *nBetas;
	NSUInteger betaStart;
	NSArray *_betas;
	
	NSUInteger *nPositrons;
	NSUInteger positronStart;
	NSArray *_positrons;
	
	NSUInteger *nNegatrons;
	NSUInteger negatronStart;
	NSArray *_negatrons;
	
	NSUInteger *nPhotons;
	NSUInteger photonStart;
	NSArray *_photons;
	
	NSDictionary *_contents;
}

@property (nonatomic, weak) NSArray *collection;

@property (nonatomic, strong) NSString *name;
@property NSUInteger mass;
@property NSUInteger atomicNumber;
@property (nonatomic, strong) NSNumber *halfLifeNumber;
@property (nonatomic, strong) NSString *halfLifeUnit;
@property (readonly, strong) NSString *halfLifeString;

@property NSUInteger nProgeny;
@property NSUInteger progenyStart;

@property NSUInteger nAlphas;
@property NSUInteger alphaStart;

@property NSUInteger nBetas;
@property NSUInteger betaStart;

@property NSUInteger nPositrons;
@property NSUInteger positronStart;

@property NSUInteger nNegatrons;
@property NSUInteger negatronStart;

@property NSUInteger nPhotons;
@property NSUInteger photonStart;

@property (nonatomic, readonly) NSDictionary *contents;

-(NSArray*)progeny;
-(NSArray*)alphas;
-(NSArray*)betas;
-(NSArray*)positrons;
-(NSArray*)negatrons;
-(NSArray*)photons;

-(NSDictionary*)contents;

-(NSArray*)getDiscrete:(NSString*)fileName nParticles:(NSUInteger)n startPoint:(NSUInteger)s; 
-(NSArray*)getContinuous:(NSString*)fileName nParticles:(NSUInteger)n startPoint:(NSUInteger)s; 

@end

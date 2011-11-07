//
//  RadDataTests.m
//  RadDataTests
//
//  Created by Chris on 11-10-29.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "RadDataTests.h"

@implementation RadDataTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
	rad = [[RadData alloc] init];
	
	first = [rad.isotopes objectAtIndex:0];
	am241 = [rad.isotopes objectAtIndex:12];
	sr90 = [rad.isotopes objectAtIndex:391];
	xe123 = [rad.isotopes objectAtIndex:465];
	last = [rad.isotopes objectAtIndex:496];	
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

-(void)testLength 
{
	STAssertEquals([rad numberOfIsotopes], (uint)497, @"497 nuclides");			
}

- (void)testName
{	
	STAssertTrue([first.name isEqualToString:@"Ac-225"], @"First isotope is Ac-225");
	STAssertTrue([am241.name isEqualToString:@"Am-241"], @"13th isotope is Am-241");
	STAssertTrue([sr90.name isEqualToString:@"Sr-90"], @"391st isotope is Sr-90");
	STAssertTrue([last.name isEqualToString:@"Zr-97"], @"Last isotope is Zr-97");	
}

-(void)testMassAndAtomicNumber
{
	STAssertEquals(first.mass, (uint)225, @"Ac-225 mass is 225");
	STAssertEquals(first.atomicNumber, (uint)89, @"Actinium atomic number is 89");

	STAssertEquals(last.mass, (uint)97, @"Zr-97 mass is 97");
	STAssertEquals(last.atomicNumber, (uint)40, @"Zirconium atomic number is 40");
}

-(void)testHalfLife
{
	STAssertEqualsWithAccuracy([first.halfLifeNumber doubleValue], 10.0, 0.000001, @"Halflife of Ac-225 is 10 days");
	STAssertTrue([first.halfLifeUnit isEqualToString:@"D"], @"Halflife of Ac-225 is 10 days");
	STAssertEqualsWithAccuracy([last.halfLifeNumber doubleValue], 16.9, 0.000001, @"Halflife of Zr-97 is 16.9 hours");
	STAssertTrue([last.halfLifeUnit isEqualToString:@"H"], @"Halflife of Zr-97 is 16.9 hours");	
}

-(void)testProgeny
{
	STAssertEquals(first.nProgeny, (uint)1, @"1 daughter for Ac-225");
	STAssertEquals(am241.nProgeny, (uint)1, @"1 daughter for Am-241");
	STAssertEquals(last.nProgeny, (uint)2, @"2 daughters for Zr-97");

	Progeny *firstDaughter = [first.progeny objectAtIndex:0];	
	STAssertTrue([firstDaughter.name isEqualToString:@"Fr-221"], @"Ac-225's daughter is Fr-221");
	STAssertEqualsWithAccuracy([firstDaughter.probability doubleValue], 1.0, 0.00001, @"Probab of Ac-225 decay is 1.0");

	Progeny *lastDaughter1 = [last.progeny objectAtIndex:0];
	STAssertTrue([lastDaughter1.name isEqualToString:@"Nb-97"], @"Zr-97's first daughter is Nb-97");
	STAssertEqualsWithAccuracy([lastDaughter1.probability doubleValue], 0.053, 0.00001, @"Probab of Zr-97 decay is 0.053");

	Progeny *lastDaughter2 = [last.progeny objectAtIndex:1];
	STAssertTrue([lastDaughter2.name isEqualToString:@"Nb-97m"], @"Zr-97's second daughter is Nb-97m");
	STAssertEqualsWithAccuracy([lastDaughter2.probability doubleValue], 0.947, 0.00001, @"Probab of Zr-97 decay is 0.947");
	
}

-(void)testAlphas
{
	STAssertEquals(first.nAlphas, (uint)13, @"13 alphas for Ac-225");
	STAssertEquals(am241.nAlphas, (uint)6, @"6 alphas for Am-241");
	STAssertEquals(last.nAlphas, (uint)0, @"0 alphas for Zr-97");

	DiscreteParticle *firstAlpha = [first.alphas objectAtIndex:0];
	STAssertEqualsWithAccuracy([firstAlpha.probability doubleValue], 0.002300, 0.00001, @"Ac-225 alpha probability");
	STAssertEqualsWithAccuracy([firstAlpha.energy doubleValue], 5.286000, 0.00001, @"Ac-225 alpha energy");

	DiscreteParticle *secondAlpha = [first.alphas objectAtIndex:1];
	STAssertEqualsWithAccuracy([secondAlpha.probability doubleValue], 0.001300, 0.00001, @"Ac-225 alpha probability");
	STAssertEqualsWithAccuracy([secondAlpha.energy doubleValue], 5.444000, 0.00001, @"Ac-225 alpha energy");
	
	DiscreteParticle *am0 = [am241.alphas objectAtIndex:0];
	STAssertEqualsWithAccuracy([am0.probability doubleValue], 0.01400, 0.00001, @"Am-241 alpha probability");
	STAssertEqualsWithAccuracy([am0.energy doubleValue], 5.388000, 0.00001, @"Am-241 alpha energy");
	
	DiscreteParticle *am1 = [am241.alphas objectAtIndex:1];
	STAssertEqualsWithAccuracy([am1.probability doubleValue], 0.128000, 0.00001, @"Am-241 alpha probability");
	STAssertEqualsWithAccuracy([am1.energy doubleValue], 5.443000, 0.00001, @"Am-241 alpha energy");
}

-(void)testBetas
{
	STAssertEquals(first.nBetas, (uint)0, @"0 betas for Ac-225");
	STAssertEquals(am241.nBetas, (uint)0, @"0 betas for Am-241");
	STAssertEquals(sr90.nBetas, (uint)1, @"1 beta for Sr-90");	
	STAssertEquals(last.nBetas, (uint)10, @"10 betas for Zr-97");	
	
	ContinuousParticle *srBeta = [sr90.betas objectAtIndex:0];
	STAssertEqualsWithAccuracy([srBeta.probability doubleValue], 1.000000, 0.00001, @"Sr-90 beta probability");
	STAssertEqualsWithAccuracy([srBeta.energy doubleValue], 0.195800, 0.00001, @"Sr-90 beta energy");
	STAssertEqualsWithAccuracy([srBeta.maxEnergy doubleValue], 0.546000, 0.00001, @"Sr-90 beta maximum energy");						
}

-(void)testPositrons
{
	STAssertEquals(first.nPositrons, (uint)0, @"0 positrons for Ac-225");
	STAssertEquals(xe123.nPositrons, (uint)4, @"4 positrons for Xe-123");
	STAssertEquals(last.nPositrons, (uint)0, @"0 positrons for Zr-97");
	
	ContinuousParticle *xePos0 = [xe123.positrons objectAtIndex:0];
	STAssertEqualsWithAccuracy([xePos0.probability doubleValue], 0.010600, 0.00001, @"Xe-123 positron probability");
	STAssertEqualsWithAccuracy([xePos0.energy doubleValue], 0.593000, 0.00001, @"Xe-123 positron energy");	
	STAssertEqualsWithAccuracy([xePos0.maxEnergy doubleValue], 1.323700, 0.00001, @"Xe-123 positron maximum energy");	

	ContinuousParticle *xePos3 = [xe123.positrons objectAtIndex:3];
	STAssertEqualsWithAccuracy([xePos3.probability doubleValue], 0.001022, 0.00001, @"Xe-123 positron probability");
	STAssertEqualsWithAccuracy([xePos3.energy doubleValue], 0.257390, 0.00001, @"Xe-123 positron energy");	
	STAssertEqualsWithAccuracy([xePos3.maxEnergy doubleValue], 0.560000, 0.00001, @"Xe-123 positron maximum energy");		
}

-(void)testElectrons
{
	STAssertEquals(first.nNegatrons, (uint)44, @"44 electrons for Ac-225");	
	STAssertEquals(am241.nNegatrons, (uint)16, @"16 electrons for Am-241");
	STAssertEquals(last.nNegatrons, (uint)0, @"0 electrons for Zr-97");	
	
	DiscreteParticle *amNeg13 = [am241.negatrons objectAtIndex:13];
	STAssertEqualsWithAccuracy([amNeg13.probability doubleValue], 0.026925, 0.00001, @"Am-241 negatron probability");
	STAssertEqualsWithAccuracy([amNeg13.energy doubleValue], 0.058036, 0.00001, @"Am-241 negatron energy");
}

-(void)testPhotons
{	
	STAssertEquals(first.nPhotons, (uint)24, @"24 photons for Ac-225");
	STAssertEquals(am241.nPhotons, (uint)5, @"5 photons for Am-241");
	STAssertEquals(last.nPhotons, (uint)26, @"26 photons for Zr-97");
	
	DiscreteParticle *amPho3 = [am241.photons objectAtIndex:3];
	STAssertEqualsWithAccuracy([amPho3.probability doubleValue], 0.359000, 0.00001, @"Am-241 photon probability");
	STAssertEqualsWithAccuracy([amPho3.energy doubleValue], 0.059537, 0.00001, @"Am-241 photon energy");				

	DiscreteParticle *amPho4 = [am241.photons objectAtIndex:4];
	STAssertEqualsWithAccuracy([amPho4.probability doubleValue], 0.001793, 0.00001, @"Am-241 photon probability");
	STAssertEqualsWithAccuracy([amPho4.energy doubleValue], 0.069231, 0.00001, @"Am-241 photon energy");				
}

-(void)testFindIsotopeWithName
{
	NSArray *results = [rad findIsotopeWithName:@"Am-241"];
	STAssertEquals([results count], (uint)1, @"Only one Am-241");	
	
	Radioisotope *result = [results objectAtIndex:0];
	STAssertTrue([result.name isEqualToString:@"Am-241"], @"Found Am-241");
	STAssertEquals(result.nPhotons, (uint)5, @"5 photons for found Am-241");
	DiscreteParticle *amPho3 = [result.photons objectAtIndex:3];
	STAssertEqualsWithAccuracy([amPho3.probability doubleValue], 0.359000, 0.00001, @"Am-241 photon probability");
	STAssertEqualsWithAccuracy([amPho3.energy doubleValue], 0.059537, 0.00001, @"Am-241 photon energy");			
	
	results = [rad findIsotopeWithName:@"x"];
	STAssertEquals([results count], (uint)12, @"12 isotopes with x in name");

	results = [rad findIsotopeWithName:@"y"];
	STAssertEquals([results count], (uint)11, @"11 isotopes with y in name");
	
	results = [rad findIsotopeWithName:@"z"];
	STAssertEquals([results count], (uint)10, @"10 isotopes with z in name");
	
	results = [rad findIsotopeWithName:@"241"];
	STAssertEquals([results count], (uint)2, @"Am-241 and Pu-241");
	
	results = [rad findIsotopeWithName:@"137"];
	STAssertEquals([results count], (uint)3, @"Cs-137, Ba-137m and Xe-137");
}

@end

//
//  LocalHudLayer.m
//  Perfect Prisons
//
//  Created by McCall Saltzman on 5/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "LocalHudLayer.h"
#import "GameState.h"


@implementation LocalHudLayer


-(id) init{
    self = [super init];
    CGSize winSize = [CCDirector sharedDirector].winSize;
    labelP1 = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i",P1walls]fontName:@"Marker Felt" fontSize:24];
    labelP1.position =  ccp(winSize.width - 31, winSize.height/4);
    [self addChild:labelP1];
    labelP2 = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i", P2Walls] fontName:@"Marker Felt" fontSize:24];
    labelP2.position = ccp(winSize.width - 31, 3*winSize.height/4);
    [self addChild:labelP2];
    labelP1.color = ccGREEN;
    labelP2.color = ccRED;
    
    
    return self;
    
}
-(void) updateWithPlayer1:(int)p1num andPlayer2Walls:(int)p2num{
    P1walls = p1num;
    P2Walls = p2num;
    [labelP2 setString:[NSString stringWithFormat:@"%i", p2num]];
    [labelP1 setString:[NSString stringWithFormat:@"%i", p1num]];
}
@end

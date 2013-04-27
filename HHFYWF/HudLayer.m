//
//  HudLayer.m
//  HHFYWF
//
//  Created by McCall Saltzman on 2/3/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "HudLayer.h"
#import "GameState.h"


@implementation HudLayer


-(id) init{
    self = [super init];
    CGSize winSize = [CCDirector sharedDirector].winSize;
    labelSelf = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i",ownWalls]fontName:@"Marker Felt" fontSize:24];
    labelSelf.position =  ccp(winSize.width - 31, winSize.height/4);
    [self addChild:labelSelf];
    labelThem = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i", theirWalls] fontName:@"Marker Felt" fontSize:24];
    labelThem.position = ccp(winSize.width - 31, 3*winSize.height/4);
    [self addChild:labelThem];

    return self;
    
}
-(void) updateWithPlayer1:(int)numSelf andPlayer2Walls:(int)numThem{
    ownWalls = numSelf;
    theirWalls = numThem;
    [labelThem setString:[NSString stringWithFormat:@"%i", theirWalls]];
    [labelSelf setString:[NSString stringWithFormat:@"%i", ownWalls]];
}
-(void)player1IsLocal:(BOOL)isLocal{
    if(isLocal){
        localPlayer = 1;
        labelSelf.color = ccGREEN;
        labelThem.color = ccRED;
    }
    else{
        localPlayer = 2;
        labelSelf.color = ccRED;
        labelThem.color = ccGREEN;
    }
}
@end

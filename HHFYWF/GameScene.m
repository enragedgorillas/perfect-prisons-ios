//
//  GameScene.m
//  HHFYWF
//
//  Created by McCall Saltzman on 2/3/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"
#import "GCTurnBasedMatchHelper.h"
#import "GameLayer.h"

@implementation GameScene


+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameScene *layer = [GameScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}


-(id)init {
    if ((self = [super init])) {
//        _gameLayer = [[[GameLayer alloc]initWithTurnBasedMatch:[GCTurnBasedMatchHelper sharedInstance].currentMatch]autorelease];
        _gameLayer = [GameLayer node];
        [self addChild:_gameLayer z:0];
//        _hudLayer = [HudLayer node];
//        [self addChild:_hudLayer z:1];
    }
    return self;
}

-(void) dealloc{
    //self.gameLayer = nil;
//    self.hudLayer = nil;
    [super dealloc];
}


@end

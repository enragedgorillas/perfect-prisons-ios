//
//  LocalGameScene.m
//  Perfect Prisons
//
//  Created by McCall Saltzman on 5/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "LocalGameScene.h"


@implementation LocalGameScene


+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
    LocalGameLayer *layer = [LocalGameLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}


-(id)init {
    if ((self = [super init])) {
        _gameLayer = [LocalGameLayer node];
        [self addChild:_gameLayer z:0];
    }
    return self;
}

-(void) dealloc{
    [super dealloc];
}


@end

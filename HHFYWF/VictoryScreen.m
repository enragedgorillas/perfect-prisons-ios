//
//  VictoryScreen.m
//  Perfect Prisons
//
//  Created by McCall Saltzman on 4/24/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "VictoryScreen.h"
#import "MainMenu.h"

@implementation VictoryScreen

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	VictoryScreen *layer = [VictoryScreen node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}


-(id)init {
    if ((self = [super init])) {
        CGSize size = [[CCDirector sharedDirector] winSize];
        CCSprite *victory = [CCSprite spriteWithFile:@"Victory.png"];
        [self addChild:victory];
        [self registerWithTouchDispatcher];
        victory.position = CGPointMake(size.width/2, size.height/2);
    
    }
    return self;
}
-(void) registerWithTouchDispatcher
{
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}
-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    return YES;
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchLocation = [touch locationInView:[touch view]];
    CGSize size = [[CCDirector sharedDirector] winSize];
    if(touchLocation.x > size.width*4/5 + 10 && touchLocation.y > size.height * 4/5){
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MainMenu scene] withColor:ccBLACK]];

    }    
}

-(void) dealloc{

    
    [super dealloc];
}
- (void)onExit
{
    [[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
    [super onExit];
}

@end

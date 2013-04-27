//
//  HelpScreen.m
//  Perfect Prisons
//
//  Created by McCall Saltzman on 4/11/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "HelpScreen.h"
#import "MainMenu.h"
#import "CCTouchDispatcher.h"


@implementation HelpScreen


+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
    HelpScreen *layer = [HelpScreen node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init{
    if(self = [super init]){
        currentIndex = 0;
        CGSize size = [[CCDirector sharedDirector] winSize];
        int i = 0;
        instructionArray = [[NSMutableArray arrayWithObjects:[CCSprite spriteWithFile:@"firstSlide.png"],[CCSprite spriteWithFile:@"Yourpawn1.png"],[CCSprite spriteWithFile:@"opponentPawn.png"],[CCSprite spriteWithFile:@"Goal.png"],[CCSprite spriteWithFile:@"enemyGoal.png"],[CCSprite spriteWithFile:@"yourTurn.png"],[CCSprite spriteWithFile:@"placePawn.png"],nil] retain];
                             
        [instructionArray addObject: [CCSprite spriteWithFile:@"noPerfectPrisions.png"]];
        [instructionArray addObject: [CCSprite spriteWithFile:@"moveThroughWalls.png"]];

        [instructionArray addObject:[CCSprite spriteWithFile:@"remainingWalls.png"]];
        [instructionArray addObject:[CCSprite spriteWithFile:@"arrows.png"]];
        
        for(i=0;i<[instructionArray count]; i++){
            [[instructionArray objectAtIndex:i] setPosition:CGPointMake(size.width/2, size.height/2)];

        }
        [self registerWithTouchDispatcher];
        [self addChild:instructionArray[0]];

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
    currentIndex++;
    if(currentIndex > [instructionArray count] - 1){
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MainMenu scene] withColor:ccBLACK]];
    }else{
        [self removeChild:[instructionArray objectAtIndex:currentIndex-1] cleanup:NO];
        [self addChild:[instructionArray objectAtIndex:currentIndex]];
    }
}
-(void)dealloc{
    [super dealloc];
    instructionArray = nil;
}

- (void)onExit
{
    [[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
    [super onExit];
}




@end

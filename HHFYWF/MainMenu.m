//
//  MainMenu.m
//  HHFYWF
//
//  Created by McCall Saltzman on 2/10/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "MainMenu.h"
#import "AppDelegate.h"
#import "GameScene.h"
#import "Options Menu.h"
#import "HelpScreen.h"
#import "VictoryScreen.h"

@implementation MainMenu
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MainMenu *layer = [MainMenu node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
		
		// create and initialize a Label
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Perfect Prisons" fontName:@"Georgia" fontSize:64];
        
		// ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
        
		// position the label on the center of the screen
		label.position =  ccp( size.width /2 , size.height - 58 );
        CCSprite *rightSide = [CCSprite spriteWithFile:@"rightside.png"];
        rightSide.position = ccp(size.width*3/4 + 20, size.height/2 - 37);
        rightSide.scale = .8;
        [self addChild:rightSide];
        CCSprite *leftSide = [CCSprite spriteWithFile:@"leftpawn.png"];
        leftSide.position = ccp(size.width*1/4 - 28, size.height/2 - 25);
        leftSide.scale = .77;
        [self addChild:leftSide];

		// add the label as a child to this Layer
		[self addChild: label];
		
		
		
		//
		// Leaderboards and Achievements
		//
        [CCMenuItemFont setFontSize:28];
        [CCMenuItemFont setFontName:@"Georgia"];

		CCMenuItem *newGame = [CCMenuItemFont itemWithString:@"Play Game" block:^(id sender) {
			
			
            AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
           [[GCTurnBasedMatchHelper sharedInstance] findMatchWithMinPlayers:2 maxPlayers:2 viewController:app.navController];
            
        }];
		// Default font size will be 28 points.
        CCMenuItem *help = [CCMenuItemFont itemWithString:@"Help" block:^(id sender){
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[HelpScreen scene] withColor:ccBLACK]];

        }];
        
        CCMenuItem *options = [CCMenuItemFont itemWithString:@"Options" block:^(id sender){
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.3 scene:[OptionsMenu scene] withColor:ccBLACK]];

        }];
		
		
		CCMenu *menu = [CCMenu menuWithItems:newGame, help, options, nil];
		
		[menu alignItemsVerticallyWithPadding:20];
		[menu setPosition:ccp( size.width/2, size.height/2 - 22)];
		
		// Add the menu to the layer
		[self addChild:menu];
        
	}
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
-(void)newGame{
    [self scheduleOnce:@selector(makeTransition:) delay:0.1];
}




@end

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
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Main Menu" fontName:@"Marker Felt" fontSize:64];
        
		// ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
        
		// position the label on the center of the screen
		label.position =  ccp( size.width /2 , size.height/2 );
		
		// add the label as a child to this Layer
		[self addChild: label];
		
		
		
		//
		// Leaderboards and Achievements
		//
		CCMenuItem *newGame = [CCMenuItemFont itemWithString:@"Play Game" block:^(id sender) {
			
			
            AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
           [[GCTurnBasedMatchHelper sharedInstance] findMatchWithMinPlayers:2 maxPlayers:2 viewController:app.navController];
//			[self newGame];
        }];
		// Default font size will be 28 points.
		[CCMenuItemFont setFontSize:28];
        CCMenuItem *help = [CCMenuItemFont itemWithString:@"Help" block:^(id sender){
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle: @"No Help Menu added yet" message: @"Ask McCall if you need help/instructions for now" delegate: nil cancelButtonTitle: @"OK" otherButtonTitles: nil];
            [[[CCDirector sharedDirector] view] addSubview: alertView];
            [alertView show];
            [alertView release];
        }];
        
		
		
		CCMenu *menu = [CCMenu menuWithItems:newGame, help, nil];
		
		[menu alignItemsHorizontallyWithPadding:20];
		[menu setPosition:ccp( size.width/2, size.height/2 - 60)];
		
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
-(void) makeTransition:(ccTime)dt
{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GameScene scene] withColor:ccWHITE]];
}




@end

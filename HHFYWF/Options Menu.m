//
//  Options Menu.m
//  Perfect Prisons
//
//  Created by McCall Saltzman on 4/10/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Options Menu.h"
#import "MainMenu.h"
#import "UserPreferences.h"
#import "InAppPurchaseManager.h"


@implementation OptionsMenu


+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
    OptionsMenu *layer = [OptionsMenu node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}



-(id) init{
    if(self = [super init]){
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"Options" fontName:@"Georgia" fontSize:64];
        // ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
        [CCMenuItemFont setFontName:@"Georgia"];

        CCMenuItem *mapSelect = [CCMenuItemFont itemWithString: @"Select Board" block:^(id sender){
            UIActionSheet *actSheet;
            if(![[NSUserDefaults standardUserDefaults] valueForKey:@"isFullVersion"]){
                
                actSheet = [[UIActionSheet alloc] initWithTitle:@"Tilesets" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Wooden (Default)", nil];

            }else{
                actSheet = [[UIActionSheet alloc] initWithTitle:@"Tilesets" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Wooden (Default)", @"Minimalist", @"Grass", @"Streets", nil];

            }
            [[[CCDirector sharedDirector] view] addSubview: actSheet];
            [actSheet showInView:[[CCDirector sharedDirector] view]];
            [actSheet release];

        }];
        if(![[NSUserDefaults standardUserDefaults] valueForKey:@"isFullVersion"]){
            upgrade = [CCMenuItemFont itemWithString:@"Restore Full Version" block:^(id sender){
                [[InAppPurchaseManager sharedInstance]restoreFullVersion];
            }];
            [self schedule: @selector(purchaseUpdate:) interval:0.2];

            
        }else{
            upgrade = [CCMenuItemFont itemWithString:@"Full Version Unlocked"];
            upgrade.isEnabled = NO;
        }
        CCMenuItem *back = [CCMenuItemFont itemWithString:@"Back" block:^(id sender){
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MainMenu scene] withColor:ccBLACK]];
        }];
        CCMenu *menu = [CCMenu menuWithItems:mapSelect, upgrade, back, nil];
        
		[menu alignItemsVerticallyWithPadding:40];
		[menu setPosition:ccp( size.width/2, size.height/2 - 37)];
        
        

		// position the label on the center of the screen
		label.position =  ccp( size.width /2 , size.height - 50 );
        
        if([UserPreferences sharedInstance].currentMap == 0){
            currentMap = @"Wooden";
        }else if ([UserPreferences sharedInstance].currentMap == 1){
            currentMap = @"Minimalist";
        }else if([UserPreferences sharedInstance].currentMap == 2){
            currentMap = @"Grass";

        }else if([UserPreferences sharedInstance].currentMap == 3){
            currentMap = @"Streets";
            
        }

        
        current = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Currently Selected: %@",currentMap] fontName:@"Georgia" fontSize:22];
        current.color = ccGREEN;
        
        current.position = ccp(size.width/2, size.height/2 + 13);

		// add the label as a child to this Layer
        [self addChild:current];
		[self addChild: label];
        [self addChild: menu];
        

    }
    return self;
}


-(void)dealloc{
    [super dealloc];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
        [[UserPreferences sharedInstance] changeMap:buttonIndex];
        if(buttonIndex == 0){
            currentMap = @"Wooden";
        }else if (buttonIndex == 1){
            currentMap = @"Minimalist";
        }else if (buttonIndex == 2){
            currentMap = @"Grass";
        }else if(buttonIndex == 3){
            currentMap = @"Streets";
        }
        current.string = [NSString stringWithFormat:@"Currently Selected: %@",currentMap];
    
    
    
}
-(void) purchaseUpdate: (ccTime) dt{
    if(![[NSUserDefaults standardUserDefaults] valueForKey:@"isFullVersion"]){
        return;
    }else{
        [upgrade setString: @"Full Version Unlocked"];
        upgrade.isEnabled = NO;
        [self unschedule:@selector(purchaseUpdate:)];

    }

}





@end

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

        CCMenuItem *mapSelect = [CCMenuItemFont itemWithString: @"Select Map" block:^(id sender){
            UIActionSheet *actSheet = [[UIActionSheet alloc] initWithTitle:@"Tilesets" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Wooden (Default)", @"Minimalist", @"Grass", nil];

            [[[CCDirector sharedDirector] view] addSubview: actSheet];
            [actSheet showInView:[[CCDirector sharedDirector] view]];
            [actSheet release];

        }];
        CCMenuItem *back = [CCMenuItemFont itemWithString:@"Back" block:^(id sender){
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MainMenu scene] withColor:ccBLACK]];
        }];
        CCMenu *menu = [CCMenu menuWithItems:mapSelect, back, nil];
        
		[menu alignItemsVerticallyWithPadding:60];
		[menu setPosition:ccp( size.width/2, size.height/2 - 22)];

		// position the label on the center of the screen
		label.position =  ccp( size.width /2 , size.height - 50 );
        
        if([UserPreferences sharedInstance].currentMap == 0){
            currentMap = @"Wooden";
        }else if ([UserPreferences sharedInstance].currentMap == 1){
            currentMap = @"Minimalist";
        }else if([UserPreferences sharedInstance].currentMap == 2){
            currentMap = @"Grass";

        }
        
        current = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Currently Selected: %@",currentMap] fontName:@"Georgia" fontSize:26];
        current.color = ccGREEN;
        
        current.position = ccp(size.width/2, size.height/2 - 5);

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
    if(buttonIndex == 3){
        return;
    }else{
        [[UserPreferences sharedInstance] setCurrentMap:buttonIndex];
        if(buttonIndex == 0){
            currentMap = @"Wooden";
        }else if (buttonIndex == 1){
            currentMap = @"Minimalist";
        }else if (buttonIndex == 2){
            currentMap = @"Grass";
        }
        current.string = [NSString stringWithFormat:@"Currently Selected: %@",currentMap];

    }
    
    
    
}



//
//- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
//{
//    return 1;
//}
//
//- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
//    return 3;
//}
//
//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    if(row == 0) {
//        return @"Wooden Board (Default)";
//    }
//    if(row == 1){
//        return @"Minimal";
//    }
//    if(row ==2){
//        return @"Grass";
//    }
//    return nil;
//}
//
//- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
//{
//    
//    [[UserPreferences sharedInstance] setCurrentMap:row];
//    NSLog(@"%i selected", row);
//    if(row == 0){
//        currentMap = @"Wooden";
//    }else if (row == 1){
//        currentMap = @"Minimal";
//    }else if (row == 2){
//        currentMap = @"Grass";
//    }
//    [pickerView removeFromSuperview];
//    current.string = [NSString stringWithFormat:@"Currently Selected: %@",currentMap];
//    
//    
//}







@end

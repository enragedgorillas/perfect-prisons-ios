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


-(id) initWithGameState: (GameState *) gameState{
    self = [super init];
    CGSize winSize = [CCDirector sharedDirector].winSize;

    CCLabelTTF * label = [CCLabelTTF labelWithString:@"Walls Remaining" fontName:@"Arial" fontSize:42.0];
    label.color = ccc3(0,0,0);
    label.position = ccp(winSize.width/2, winSize.height/2);
    [self addChild:label];
    return self;
    
}
-(void) updateWithP1Walls:(int)p1WallsLeft andP2Walls:(int)p2WallsLeft{
    
}
@end

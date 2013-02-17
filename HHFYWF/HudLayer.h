//
//  HudLayer.h
//  HHFYWF
//
//  Created by McCall Saltzman on 2/3/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface HudLayer : CCLayer {
    CCLabelTTF * labelSelf;
    CCLabelTTF *labelThem;
    int ownWalls, theirWalls;
}

-(void) updateWithPlayer1: (int)numSelf andPlayer2Walls:(int)numThem;
@end

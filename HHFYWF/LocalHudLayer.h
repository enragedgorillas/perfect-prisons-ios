//
//  LocalHudLayer.h
//  Perfect Prisons
//
//  Created by McCall Saltzman on 5/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface LocalHudLayer : CCLayer {
    CCLabelTTF *labelP1;
    CCLabelTTF *labelP2;
    int P1walls, P2Walls, currentPlayer;
}

-(void) updateWithPlayer1: (int)p1num andPlayer2Walls:(int)p2num;
@end

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
    
}
-(void) updateWithP1Walls: (int)p1WallsLeft andP2Walls:(int)p2WallsLeft;
@end

//
//  GameScene.h
//  HHFYWF
//
//  Created by McCall Saltzman on 2/3/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameLayer.h"
#import "HudLayer.h"

@interface GameScene : CCScene {
    
}
@property(nonatomic, retain)GameLayer *gameLayer;
//@property(nonatomic, retain)HudLayer *hudLayer;
+(CCScene *) scene;


@end

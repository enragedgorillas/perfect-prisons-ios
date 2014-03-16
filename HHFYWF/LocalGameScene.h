//
//  LocalGameScene.h
//  Perfect Prisons
//
//  Created by McCall Saltzman on 5/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "LocalGameLayer.h"
#import "LocalHudLayer.h"


@interface LocalGameScene : CCScene {
    
}
@property (nonatomic,retain) LocalGameLayer *gameLayer;
+(CCScene *) scene;

@end

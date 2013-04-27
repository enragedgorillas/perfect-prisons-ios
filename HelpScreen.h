//
//  HelpScreen.h
//  Perfect Prisons
//
//  Created by McCall Saltzman on 4/11/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface HelpScreen : CCScene<CCTargetedTouchDelegate> {
    NSMutableArray * instructionArray;
    int currentIndex;
}
+(CCScene *) scene;

@end

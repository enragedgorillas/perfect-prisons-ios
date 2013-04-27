//
//  Options Menu.h
//  Perfect Prisons
//
//  Created by McCall Saltzman on 4/10/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface OptionsMenu : CCScene <UIActionSheetDelegate> {
    
    NSString *currentMap;
    CCLabelTTF *current;
}

+(CCScene *) scene;

@end

//
//  MainMenu.h
//  HHFYWF
//
//  Created by McCall Saltzman on 2/10/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GCTurnBasedMatchHelper.h"
#import <iAd/iAd.h>


@interface MainMenu : CCLayer<UIAlertViewDelegate> {
    ADBannerView * adView;
    BOOL isBannerVisible;
}

+(CCScene *) scene;
-(void)newGame;

@end

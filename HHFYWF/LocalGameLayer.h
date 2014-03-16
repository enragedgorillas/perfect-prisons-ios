//
//  LocalGameLayer.h
//  Perfect Prisons
//
//  Created by McCall Saltzman on 5/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameState.h"

@class LocalHudLayer, Pawn, GKTurnBasedMatch, Wall;

@interface LocalGameLayer : CCLayer <UIAlertViewDelegate> {
    CCTMXTiledMap *_tileMap;
    CCTMXLayer *_background;
    BOOL didMove, placedWall, movedPawn;
    CGPoint pawnAtStartOfTurn;
    CCSprite *upArrow, *downArrow;
    int currentPlayer;
    CGPoint gridPosition1;
    CCSprite *leftImageGreen;
    CCSprite *leftImageRed;


}
@property (nonatomic, retain) CCTMXTiledMap *tileMap;
@property (nonatomic, retain) CCTMXLayer *mainTileLayer;
@property (nonatomic, retain) LocalHudLayer *hudLayer;
@property(nonatomic, retain) GameState *currentGameState;
-(CGPoint) tilePointFromGridPoint:(CGPoint) gridPoint andIsWall:(BOOL) isWall andHorizontal: (BOOL) isHorizontal;
-(CGPoint) gridPointFromTile:(CGPoint) tilePoint andIsWall: (BOOL *) isWall andHorizontal:(BOOL *) isHorizontal;
-(BOOL) isValidWall:(Wall *) wall;
-(void) wonMatch;
-(BOOL) isWon;

@end

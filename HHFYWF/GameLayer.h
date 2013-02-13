//
//  GameLayer.h
//  HHFYWF
//
//  Created by McCall Saltzman on 2/3/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameState.h"
@class HudLayer, Pawn, GKTurnBasedMatch, Wall;

@interface GameLayer : CCLayer <UIAlertViewDelegate> {
    CCTMXTiledMap *_tileMap;
    CCTMXLayer *_background;
    BOOL didMove, placedWall, movedPawn, isPlayersTurn;
    CGPoint pawnAtStartOfTurn;

}
@property (nonatomic, retain) CCTMXTiledMap *tileMap;
@property (nonatomic, retain) CCTMXLayer *mainTileLayer;
@property (nonatomic, retain) HudLayer *hudLayer;
@property(nonatomic, retain) GameState *currentGameState;
-(CGPoint) tilePointFromGridPoint:(CGPoint) gridPoint andIsWall:(BOOL) isWall andHorizontal: (BOOL) isHorizontal;
-(CGPoint) gridPointFromTile:(CGPoint) tilePoint andIsWall: (BOOL *) isWall andHorizontal:(BOOL *) isHorizontal;
-(void) initWithTurnBasedMatch:(GKTurnBasedMatch *) match;
-(BOOL) isValidWall:(Wall *) wall;
-(void) wonMatch;
-(BOOL) isWon;

@end

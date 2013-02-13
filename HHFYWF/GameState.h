//
//  GameState.h
//  HHFYWF
//
//  Created by McCall Saltzman on 2/1/13.
//
//
#define UP 1
#define RIGHT 2
#define DOWN 3
#define LEFT 4


#import <Foundation/Foundation.h>
#import "Pawn.h"

@class Wall;
@interface GameState : NSObject<NSCoding>{
    
}

@property(nonatomic, retain) NSMutableArray * wallArray;
@property(nonatomic, retain) Pawn *player1Pawn;
@property(nonatomic, retain) Pawn *player2Pawn;
@property int p1WallsRemaining;
@property int p2WallsRemaining;
@property int currentPlayer;


-(void) addWall:(Wall *) wall;
-(void) movePawn:(int) pawn inDirection:(int) dir;
-(CGPoint) tilePointFromGridPoint:(CGPoint) gridPoint andIsWall:(BOOL) isWall andHorizontal: (BOOL) isHorizontal;
-(CGPoint) gridPointFromTile:(CGPoint) tilePoint andIsWall: (BOOL *) isWall;
-(id) initWithNewMatch;
-(void) removeLastWall;
@end

//
//  PathfinderClass.h
//  HHFYWF
//
//  Created by McCall Saltzman on 2/9/13.
//
//

#import <Foundation/Foundation.h>
@class GameState;

@interface PathfinderClass : NSObject{
@private
	NSMutableArray *spOpenSteps;
	NSMutableArray *spClosedSteps;

}
@property(nonatomic, retain) GameState* gameState;

-(BOOL) isOpenPathForPlayer:(int) player;
- (NSArray *)walkableAdjacentTilesCoordForTileCoord:(CGPoint)tileCoord;
-(id) initWithGameData:(GameState *) gameData;


@end

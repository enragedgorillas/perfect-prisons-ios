//
//  GameState.m
//  HHFYWF
//
//  Created by McCall Saltzman on 2/1/13.
//
//

#import "GameState.h"
#import "Wall.h"
#import "Pawn.h"
#import <GameKit/GameKit.h>

#define ISINPAWNSPACE ((((int)tilePoint.y % 3) == 0) ||(((int)tilePoint.y-1)%3) == 0)&&((((int)tilePoint.x % 3) == 0) ||(((int)tilePoint.x-1)%3) == 0)
#define ISINWALLSPACE ((((int)tilePoint.x %3) == 2) ||(((int)tilePoint.y%3) == 2)&&(!(((int)tilePoint.x %3) == 2) &&(((int)tilePoint.y%3) == 2)))


@implementation GameState
@synthesize wallArray, p1WallsRemaining, p2WallsRemaining, player1Pawn, player2Pawn, currentPlayer;


#pragma mark NSCoding


- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeInt:p1WallsRemaining forKey:@"p1WallsRem"];
    [encoder encodeInt:p2WallsRemaining forKey:@"p2WallsRem"];
    [encoder encodeObject:wallArray forKey:@"wallArray"];
    [encoder encodeObject:player1Pawn forKey:@"p1Pawn"];
    [encoder encodeObject:player2Pawn forKey:@"p2Pawn"];
    [encoder encodeInt:currentPlayer forKey:@"currentPlayer"];

}

- (id)initWithCoder:(NSCoder *)decoder {
    if([decoder containsValueForKey:@"p1Pawn"]){
        self = [super init];
        wallArray = [[decoder decodeObjectForKey:@"wallArray"]retain];
        p1WallsRemaining = [decoder decodeIntForKey:@"p1WallsRem"];
        p2WallsRemaining = [decoder decodeIntForKey:@"p2WallsRem"];
        player1Pawn = [[decoder decodeObjectForKey:@"p1Pawn"]retain];
        player2Pawn = [[decoder decodeObjectForKey:@"p2Pawn"]retain];
        currentPlayer =[decoder decodeIntForKey:@"currentPlayer"];
    return self;
    }else{
        return [self initWithNewMatch];
    }
    
}
-(id) initWithNewMatch{//: (GKTurnBasedMatch *) match{
    self = [super init];
    wallArray = [[NSMutableArray alloc]init];
    p1WallsRemaining = 10;
    p2WallsRemaining = 10;
    player1Pawn = [[Pawn alloc] initWithX:4 andY:8];
    player2Pawn = [[Pawn alloc] initWithX:4 andY:0];
    currentPlayer = 1;
    return self;
}
-(void) addWall:(Wall *) wall{
    [wallArray addObject:wall];
    if(currentPlayer ==1){
        p1WallsRemaining--;
    }
    else if (currentPlayer == 2){
        p2WallsRemaining--;
    }
    
NSLog(@"%@", wallArray[0]);
}
-(void) removeLastWall{
    if(currentPlayer == 1){
        p1WallsRemaining++;
    }else{
        p2WallsRemaining++;
    }
    [wallArray removeLastObject];
}


-(void) movePawn:(int)pawn inDirection:(int) dir{
    if(pawn == 1){
        switch (dir) {
            case UP:
                player1Pawn.y--;
                break;
            case RIGHT:
                player1Pawn.x++;
                break;
            case DOWN:
                player1Pawn.y++;
                break;
            case LEFT:
                player1Pawn.x--;
                break;
            default:
                break;
        }
    }else if (pawn == 2){
        switch (dir) {
            case UP:
                player2Pawn.y--;
                break;
            case RIGHT:
                player2Pawn.x++;
                break;
            case DOWN:
                player2Pawn.y++;
                break;
            case LEFT:
                player2Pawn.x--;
                break;
            default:
                break;
        }

    }
    
}

-(CGPoint) tilePointFromGridPoint:(CGPoint)gridPoint andIsWall:(BOOL)isWall andHorizontal:(BOOL)isHorizontal{
    int topRightX, topRightY;
    
    if(!isWall){
        topRightX = gridPoint.x*3;
        topRightY = gridPoint.y*3;
    }else if(isHorizontal){
        topRightX = gridPoint.x*3;
        topRightY = gridPoint.y*3+2;
    }else{
        topRightY = gridPoint.y*3;
        topRightX = gridPoint.x*3+2;

    }
    return CGPointMake(topRightX, topRightY);
}

-(CGPoint) gridPointFromTile:(CGPoint)tilePoint andIsWall:(BOOL *)isWall{
    
    float topRightX, topRightY;
    if(ISINPAWNSPACE){
        topRightX = (int)(tilePoint.x/3);
        topRightY = (int)(tilePoint.y/3);
        *isWall = NO;
        return (CGPointMake(topRightX, topRightY));
    }else if (ISINWALLSPACE){
        topRightX = (int)(tilePoint.x/3);
        topRightY = (int)(tilePoint.y/3);
        *isWall = YES;
        return (CGPointMake(topRightX, topRightY));
    }else{
        return (CGPointMake(15, 15));
    }

}


@end

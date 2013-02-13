//
//  GameLayer.m
//  HHFYWF
//
//  Created by McCall Saltzman on 2/3/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "GameLayer.h"
#import "HudLayer.h"
#import <GameKit/GameKit.h>
#import "Wall.h"
#import "Pawn.h"
#import "PathfinderClass.h"
#import "GCTurnBasedMatchHelper.h"
#import "MainMenu.h"

#define FOURWAYCROSS 10
#define UPLEFTBLANKSPACE 1
#define UPRIGHTBLANKSPACE 2
#define DOWNLEFTBLANKSPACE 5
#define DOWNRIGHTBLANKSPACE 6
#define HORIZONTALBLANK 13
#define VERTICALBLANK 9
#define UPLEFTPAWNSPACE 3
#define UPRIGHTPAWNSPACE 4
#define DOWNLEFTPAWNSPACE 7
#define DOWNRIGHTPAWNSPACE 8
#define WALLSPACE 14

#define ISINPAWNSPACE ((((int)tilePoint.y % 3) == 0) ||(((int)tilePoint.y-1)%3) == 0)&&((((int)tilePoint.x % 3) == 0) ||(((int)tilePoint.x-1)%3) == 0)
#define ISINWALLSPACE ((((int)tilePoint.x %3) == 2) ||(((int)tilePoint.y%3) == 2)&&(!(((int)tilePoint.x %3) == 2) &&(((int)tilePoint.y%3) == 2)))


@implementation GameLayer
@synthesize mainTileLayer = _mainTileLayer, tileMap = _tileMap, hudLayer = _hudLayer, currentGameState;

-(id) init
{
    if( (self=[super init] )) {
        
        self.tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"tmx1.tmx"];
        self.mainTileLayer = [_tileMap layerNamed:@"Layer 1"];
        
        [self addChild:_tileMap z:-1];
        self.hudLayer = [HudLayer node];
        [self addChild:_hudLayer z:2];
        
        
        
    }
    self.isTouchEnabled = YES;
    currentGameState = [[GameState alloc]initWithNewMatch];
    //remove after gamecenter works
    [self initWithTurnBasedMatch:[[GCTurnBasedMatchHelper sharedInstance] currentMatch]];

    CCMenuItem *back = [CCMenuItemFont itemWithString:@"BACK" block:^(id sender){
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MainMenu scene] withColor:ccWHITE]];

    }];
    CGSize size = [[CCDirector sharedDirector] winSize];
    CCMenu *backMenu = [CCMenu menuWithItems:back, nil];
    [backMenu alignItemsVerticallyWithPadding:20];
    [backMenu setPosition:ccp(size.width - 31, size.height/2)];
    [self addChild:backMenu];
    return self;
}

-(void) initWithTurnBasedMatch:(GKTurnBasedMatch *) match{
    
    //check here if is new match
    GKTurnBasedParticipant *firstParticipant = [match.participants objectAtIndex:0];
    
    if(firstParticipant.lastTurnDate){
        currentGameState = [[NSKeyedUnarchiver unarchiveObjectWithData:match.matchData] retain];
        if(firstParticipant == match.currentParticipant){
            if(currentGameState.currentPlayer == 1){
                isPlayersTurn = YES;
            }else{
                isPlayersTurn= NO;
            }
        }else{
            if(currentGameState.currentPlayer == 2){
                isPlayersTurn = YES;
            }else{
                isPlayersTurn= NO;
            }

        }
    }else{
        isPlayersTurn = YES;
    }
//    [_hudLayer updateWithP1Walls:currGameState.p1WallsRemaining andP2Walls:currGameState.p2WallsRemaining];
    
    [self movePawnFrom: CGPointMake(4, 8) to:CGPointMake(currentGameState.player1Pawn.x, currentGameState.player1Pawn.y)];
    [self movePawnFrom: CGPointMake(4, 0) to:CGPointMake(currentGameState.player2Pawn.x, currentGameState.player2Pawn.y)];
    for(Wall * walls in currentGameState.wallArray){
        [self addVisualWall:walls];
    }
    
    //return self;
}

-(void) dealloc{
    self.mainTileLayer = nil;
    self.tileMap = nil;
    _background = nil;
    self.hudLayer = nil;
//    self.currentGameState = nil;
    [super dealloc];
}


-(void) registerWithTouchDispatcher
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    CGPoint touchLocation = [touch locationInView: [touch view]];
    CGPoint prevLocation = [touch previousLocationInView: [touch view]];
    
    touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
    prevLocation = [[CCDirector sharedDirector] convertToGL: prevLocation];
        
    CGPoint diff = (CGPointMake(0, touchLocation.y-prevLocation.y)); //ccpSub(touchLocation,prevLocation);
    [_tileMap setPosition: ccpAdd(_tileMap.position, diff)];
    
    NSLog(@"%f",_tileMap.position.y);
    
    didMove = YES;
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    didMove = NO;
    return YES;
}
-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    if(didMove){
        return;
    }
    if(!isPlayersTurn){
        return;
    }
    placedWall = NO;
    movedPawn = NO;
    CGPoint touchLocation = [touch locationInView: [touch view]];
    CGPoint tileLocation = [self tilePosFromLocation:touchLocation tileMap:_tileMap];
    BOOL isWall, isHorizontal;
    CGPoint gridPosition = [self gridPointFromTile:tileLocation andIsWall:&isWall andHorizontal:&isHorizontal];
    if(isWall){
        if(gridPosition.x < 8 && gridPosition.y <8){
            Wall *newWall = [[Wall alloc] initWithX:gridPosition.x andY:gridPosition.y andVerticalFlag:!isHorizontal];
            if([self isValidWall:newWall]){
                [currentGameState addWall: newWall];
                PathfinderClass *pathfinder = [[PathfinderClass alloc] initWithGameData:currentGameState];
                if((![pathfinder isOpenPathForPlayer:1]||![pathfinder isOpenPathForPlayer:2])){
                    UIAlertView* myAlertView = [[UIAlertView alloc] initWithTitle: @"Illegal Wall" message: @"Wall creates closed path" delegate: nil cancelButtonTitle: @"OK" otherButtonTitles: nil];
                    [[[CCDirector sharedDirector] view] addSubview: myAlertView];
                    [myAlertView show];
                    [myAlertView release];
                    [currentGameState removeLastWall];
                }
                else{
                    [self addVisualWall:newWall];
                    placedWall = YES;
                }
                [pathfinder dealloc];
            }
        }
    }else if([self validMove:gridPosition]){
        if(currentGameState.currentPlayer == 1){
            CGPoint prevPawnPosition = CGPointMake(currentGameState.player1Pawn.x, currentGameState.player1Pawn.y);
            pawnAtStartOfTurn = prevPawnPosition;
            //move pawn in game state representation
            if(((currentGameState.player1Pawn.x - gridPosition.x == 1 || currentGameState.player1Pawn.x - gridPosition.x == -1)&& currentGameState.player1Pawn.y == gridPosition.y)){
                if((currentGameState.player1Pawn.y - gridPosition.y == -1 || currentGameState.player1Pawn.x - gridPosition.x == -1)){
                   [currentGameState movePawn:1 inDirection:RIGHT];
                }else{
                    [currentGameState movePawn:1 inDirection:LEFT];
                }
            }else{
                if((currentGameState.player1Pawn.y - gridPosition.y == -1 || currentGameState.player1Pawn.x - gridPosition.x == -1)){
                    [currentGameState movePawn:1 inDirection:DOWN];
                }else{
                    [currentGameState movePawn:1 inDirection:UP];
                }

            }
            //move pawn visual
            [self movePawnFrom:prevPawnPosition to:gridPosition];
            movedPawn = YES;
            
            
        }else if(currentGameState.currentPlayer == 2){
            //move pawn in game state representation
            CGPoint prevPawnPosition = CGPointMake(currentGameState.player2Pawn.x, currentGameState.player2Pawn.y);
            pawnAtStartOfTurn = prevPawnPosition;
            if(((currentGameState.player2Pawn.x - gridPosition.x == 1 || currentGameState.player2Pawn.x - gridPosition.x == -1)&& currentGameState.player2Pawn.y == gridPosition.y)){
                if((currentGameState.player2Pawn.y - gridPosition.y == -1 || currentGameState.player2Pawn.x - gridPosition.x == -1)){
                    [currentGameState movePawn:2 inDirection:RIGHT];
                }else{
                    [currentGameState movePawn:2 inDirection:LEFT];
                }
            }else{
                if((currentGameState.player2Pawn.y - gridPosition.y == -1 || currentGameState.player2Pawn.x - gridPosition.x == -1)){
                    [currentGameState movePawn:2 inDirection:DOWN];
                }else{
                    [currentGameState movePawn:2 inDirection:UP];
                }
                
            }
            //move pawn visual
            [self movePawnFrom:prevPawnPosition to:gridPosition];
            movedPawn = YES;

        }

    }
    if([self isWon]){
        [self wonMatch];
    }
    
    
    
    if(movedPawn || placedWall){
        UIAlertView *endTurnAlertView = [[UIAlertView alloc] initWithTitle: @"End Your Turn?" message: nil delegate: self cancelButtonTitle: @"Undo Move" otherButtonTitles: @"End Turn", nil];
        [[[CCDirector sharedDirector] view] addSubview: endTurnAlertView];
        [endTurnAlertView show];
        [endTurnAlertView release];

    }
    
}
-(CGPoint) tilePosFromLocation:(CGPoint)location tileMap:(CCTMXTiledMap*)tileMap
{
	// Tilemap position must be added as an offset, in case the tilemap position is not at 0,0 due to scrolling
    location.y = [CCDirector sharedDirector].winSize.height - location.y;
    
	CGPoint pos = ccpSub(location, tileMap.position);
	
	// scaling tileSize to Retina display size if necessary
	float scaledWidth = tileMap.tileSize.width / CC_CONTENT_SCALE_FACTOR();
	float scaledHeight = tileMap.tileSize.height / CC_CONTENT_SCALE_FACTOR();
	// Cast to int makes sure that result is in whole numbers, tile coordinates will be used as array indices
	pos.x = (int)(pos.x / scaledWidth);
	pos.y = (int)((tileMap.mapSize.height * tileMap.tileSize.height - pos.y) / scaledHeight);
	
	CCLOG(@"touch at (%.0f, %.0f) is at tileCoord (%i, %i)", location.x, location.y, (int)pos.x, (int)pos.y);
	
	// make sure coordinates are within bounds
	pos.x = fminf(fmaxf(pos.x, 0), tileMap.mapSize.width - 1);
	pos.y = fminf(fmaxf(pos.y, 0), tileMap.mapSize.height - 1);
	
	return pos;
}
-(CGPoint) tilePointFromGridPoint:(CGPoint)gridPoint andIsWall:(BOOL)isWall andHorizontal:(BOOL)isHorizontal{
    int topLeftX, topLeftY;
    
    if(!isWall){
        topLeftX = gridPoint.x*3;
        topLeftY = gridPoint.y*3;
    }else if(isHorizontal){
        topLeftX = gridPoint.x*3;
        topLeftY = gridPoint.y*3+2;
    }else{
        topLeftY = gridPoint.y*3;
        topLeftX = gridPoint.x*3+2;
        
    }
    return CGPointMake(topLeftX, topLeftY);
}

-(CGPoint) gridPointFromTile:(CGPoint)tilePoint andIsWall:(BOOL *)isWall andHorizontal:(BOOL *)isHorizontal{
    
    float topLeftX, topLeftY;
    if(ISINPAWNSPACE){
        topLeftX = (int)(tilePoint.x/3);
        topLeftY = (int)(tilePoint.y/3);
        *isWall = NO;
        return (CGPointMake(topLeftX, topLeftY));
    }else if (ISINWALLSPACE){
        topLeftX = (int)(tilePoint.x/3);
        topLeftY = (int)(tilePoint.y/3);
        *isWall = YES;
        if((int)tilePoint.y%3 == 2){
            *isHorizontal = YES;
        }else{
            *isHorizontal = NO;
        }
        return (CGPointMake(topLeftX, topLeftY));
    }else{
        return (CGPointMake(15, 15));
    }
    
}
-(BOOL) isValidWall:(Wall *)wall{
    for(Wall* oldWall in currentGameState.wallArray){
        if(oldWall.topLeftPointX == wall.topLeftPointX && oldWall.topLeftPointY == wall.topLeftPointY){
            return NO;
        }
        if((oldWall.topLeftPointX == wall.topLeftPointX +1 || oldWall.topLeftPointX == wall.topLeftPointX -1) && (oldWall.isVertical == NO && wall.isVertical == NO)){
            return NO;
        }
        if((oldWall.topLeftPointY == wall.topLeftPointY +1 || oldWall.topLeftPointY == wall.topLeftPointY -1) && (oldWall.isVertical == YES && wall.isVertical == YES)){
            return NO;
        }

    }
    return YES;
    
}

-(BOOL) validMove:(CGPoint) move{
    BOOL validHorizontalMove, validVerticalMove, positiveMove, isValid;
    Pawn * pawn;
    isValid = YES;
    if(currentGameState.currentPlayer == 1){
        pawn = currentGameState.player1Pawn;
    }else{
        pawn = currentGameState.player2Pawn;
    }
    validHorizontalMove = ((pawn.x - move.x == 1 || pawn.x - move.x == -1)&& pawn.y == move.y);
    validVerticalMove= ((pawn.y - move.y == 1 || pawn.y - move.y == -1)&& pawn.x == move.x);
    positiveMove = (pawn.y - move.y == -1 || pawn.x - move.x == -1);
//    negativeMove = (pawn.y - move.y == 1 || pawn.x - move.x == 1);
    Wall* walls;
    if(validHorizontalMove){
        for(int i = 0; i<[currentGameState.wallArray count]; i++){
            walls = (Wall*)[currentGameState.wallArray objectAtIndex:i];
            if(walls.isVertical){
                if(positiveMove){
                    if(walls.topLeftPointX == pawn.x && (walls.topLeftPointY == pawn.y || walls.topLeftPointY == pawn.y - 1)){
                        isValid = NO;
                    }
                }else{
                    if(walls.topLeftPointX == pawn.x - 1 && (walls.topLeftPointY == pawn.y || walls.topLeftPointY == pawn.y - 1)){
                        isValid = NO;
                    }

                }
            }
        }
    }else if(validVerticalMove){
        for(int i = 0; i<[currentGameState.wallArray count]; i++){
            walls = (Wall*)[currentGameState.wallArray objectAtIndex:i];

            if(!walls.isVertical){
                if(positiveMove){
                    if(walls.topLeftPointY == pawn.y && (walls.topLeftPointX == pawn.x || walls.topLeftPointX == pawn.x - 1)){
                        isValid = NO;
                    }
                }else{
                    if(walls.topLeftPointY == pawn.y - 1 && (walls.topLeftPointX == pawn.x || walls.topLeftPointX == pawn.x - 1)){
                        isValid = NO;
                    }
                }

            }
        }
    }else{
        isValid = NO;
        
    }
    return isValid;
    
    
}
-(void) movePawnFrom: (CGPoint) fromPoint to:(CGPoint) toPoint{
    CGPoint topLeftFrom, topLeftTo;
    topLeftFrom = [self tilePointFromGridPoint:fromPoint andIsWall:NO andHorizontal:NO];
    topLeftTo = [self tilePointFromGridPoint:toPoint andIsWall:NO andHorizontal:NO];
    
    //blank the old space
    [_mainTileLayer setTileGID:UPLEFTBLANKSPACE at:topLeftFrom];
    [_mainTileLayer setTileGID:UPRIGHTBLANKSPACE at:CGPointMake(topLeftFrom.x + 1, topLeftFrom.y)];
    [_mainTileLayer setTileGID:DOWNRIGHTBLANKSPACE at:CGPointMake(topLeftFrom.x + 1, topLeftFrom.y + 1)];
    [_mainTileLayer setTileGID:DOWNLEFTBLANKSPACE at:CGPointMake(topLeftFrom.x, topLeftFrom.y +1)];
    
    //put a pawn in the new space
    [_mainTileLayer setTileGID:UPLEFTPAWNSPACE at:topLeftTo];
    [_mainTileLayer setTileGID:UPRIGHTPAWNSPACE at:CGPointMake(topLeftTo.x + 1, topLeftTo.y)];
    [_mainTileLayer setTileGID:DOWNRIGHTPAWNSPACE at:CGPointMake(topLeftTo.x + 1, topLeftTo.y + 1)];
    [_mainTileLayer setTileGID:DOWNLEFTPAWNSPACE at:CGPointMake(topLeftTo.x, topLeftTo.y +1)];



    
}
-(void) addVisualWall:(Wall *) wall{
    if(wall.isVertical){
        CGPoint top = [self tilePointFromGridPoint:(CGPointMake(wall.topLeftPointX, wall.topLeftPointY)) andIsWall:YES andHorizontal:NO];
        [_mainTileLayer setTileGID:WALLSPACE at:top];
        [_mainTileLayer setTileGID:WALLSPACE at:(CGPointMake(top.x, top.y +1))];
        [_mainTileLayer setTileGID:WALLSPACE at:(CGPointMake(top.x, top.y +2))];
        [_mainTileLayer setTileGID:WALLSPACE at:(CGPointMake(top.x, top.y +3))];
        [_mainTileLayer setTileGID:WALLSPACE at:(CGPointMake(top.x, top.y +4))];

    }else{
        CGPoint left = [self tilePointFromGridPoint:(CGPointMake(wall.topLeftPointX, wall.topLeftPointY)) andIsWall:YES andHorizontal:YES];
        [_mainTileLayer setTileGID:WALLSPACE at:left];
        [_mainTileLayer setTileGID:WALLSPACE at:(CGPointMake(left.x+1, left.y))];
        [_mainTileLayer setTileGID:WALLSPACE at:(CGPointMake(left.x+2, left.y))];
        [_mainTileLayer setTileGID:WALLSPACE at:(CGPointMake(left.x+3, left.y))];
        [_mainTileLayer setTileGID:WALLSPACE at:(CGPointMake(left.x+4, left.y))];
        
    }

}
-(void) removeVisualWall:(Wall *) wall{
    if(wall.isVertical){
        CGPoint top = [self tilePointFromGridPoint:(CGPointMake(wall.topLeftPointX, wall.topLeftPointY)) andIsWall:YES andHorizontal:NO];
        [_mainTileLayer setTileGID:VERTICALBLANK at:top];
        [_mainTileLayer setTileGID:VERTICALBLANK at:(CGPointMake(top.x, top.y +1))];
        [_mainTileLayer setTileGID:FOURWAYCROSS at:(CGPointMake(top.x, top.y +2))];
        [_mainTileLayer setTileGID:VERTICALBLANK at:(CGPointMake(top.x, top.y +3))];
        [_mainTileLayer setTileGID:VERTICALBLANK at:(CGPointMake(top.x, top.y +4))];
        
    }else{
        CGPoint left = [self tilePointFromGridPoint:(CGPointMake(wall.topLeftPointX, wall.topLeftPointY)) andIsWall:YES andHorizontal:YES];
        [_mainTileLayer setTileGID:HORIZONTALBLANK at:left];
        [_mainTileLayer setTileGID:HORIZONTALBLANK at:(CGPointMake(left.x+1, left.y))];
        [_mainTileLayer setTileGID:FOURWAYCROSS at:(CGPointMake(left.x+2, left.y))];
        [_mainTileLayer setTileGID:HORIZONTALBLANK at:(CGPointMake(left.x+3, left.y))];
        [_mainTileLayer setTileGID:HORIZONTALBLANK at:(CGPointMake(left.x+4, left.y))];
        
    }

}

-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(buttonIndex ==0){
        [self undoLastMove];
    }
    else if(buttonIndex == 1){
        [self endTurn];
    }
}

-(void) undoLastMove{
    if(placedWall){
        [self removeVisualWall:[currentGameState.wallArray lastObject]];
        [currentGameState removeLastWall];
    }else if(movedPawn){
        CGPoint prevPawnPosition = pawnAtStartOfTurn;
        CGPoint currentPawnPosition;
        if(currentGameState.currentPlayer == 1){
            currentPawnPosition = CGPointMake(currentGameState.player1Pawn.x, currentGameState.player1Pawn.y);
            currentGameState.player1Pawn.x = prevPawnPosition.x;
            currentGameState.player1Pawn.y = prevPawnPosition.y;
        }else{
            currentPawnPosition = CGPointMake(currentGameState.player2Pawn.x, currentGameState.player2Pawn.y);
            currentGameState.player2Pawn.x = prevPawnPosition.x;
            currentGameState.player2Pawn.y = prevPawnPosition.y;


        }
        [self movePawnFrom:currentPawnPosition to:prevPawnPosition];
    }
}
-(void) endTurn{
    GKTurnBasedMatch *currentMatch = [[GCTurnBasedMatchHelper sharedInstance] currentMatch];
    if(currentGameState.currentPlayer == 1){
        currentGameState.currentPlayer = 2;
    }else{
        currentGameState.currentPlayer = 1;
    }
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:currentGameState];
    NSLog(@"%i",data.length);
    NSUInteger currentIndex = [currentMatch.participants indexOfObject:currentMatch.currentParticipant];
    GKTurnBasedParticipant *nextParticipant;
    nextParticipant = [currentMatch.participants objectAtIndex: ((currentIndex + 1) % [currentMatch.participants count ])];
    [currentMatch endTurnWithNextParticipant:nextParticipant matchData:data completionHandler:^(NSError *error) {}];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MainMenu scene] withColor:ccWHITE]];

}
-(void) wonMatch{
    GKTurnBasedMatch *currentMatch = [[GCTurnBasedMatchHelper sharedInstance] currentMatch];
    GKTurnBasedParticipant *winner, *loser;
    if(currentGameState.currentPlayer == 1){
        winner = currentMatch.participants[0];
        loser = currentMatch.participants[1];
    }else{
        winner = currentMatch.participants[1];
        loser = currentMatch.participants[0];
    }
    winner.matchOutcome = GKTurnBasedMatchOutcomeWon;
    loser.matchOutcome = GKTurnBasedMatchOutcomeLost;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:currentGameState];
    [currentMatch endMatchInTurnWithMatchData:data completionHandler:^(NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        }
    }];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MainMenu scene] withColor:ccWHITE]];

}
-(BOOL) isWon{
    if(currentGameState.currentPlayer == 1){
        if(currentGameState.player1Pawn.y == 0){
            return YES;
        }
    }else{
        if (currentGameState.player2Pawn.y == 8) {
            return YES;
        }
    }
    return NO;
}

@end

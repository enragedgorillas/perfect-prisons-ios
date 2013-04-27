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
#import "UserPreferences.h"
#import "VictoryScreen.h"
//
// OLD DEFINES FOR SPRITESHEET TAKE 2
//
//#define FOURWAYCROSS 10
//#define UPLEFTBLANKSPACE 1
//#define UPRIGHTBLANKSPACE 2
//#define DOWNLEFTBLANKSPACE 5
//#define DOWNRIGHTBLANKSPACE 6
//#define HORIZONTALBLANK 13
//#define VERTICALBLANK 9
//#define UPLEFTSELFPAWNSPACE 11
//#define UPRIGHTSELFPAWNSPACE 12
//#define DOWNLEFTSELFPAWNSPACE 15
//#define DOWNRIGHTSELFPAWNSPACE 16
//#define UPLEFTOTHERPAWNSPACE 3
//#define UPRIGHTOTHERPAWNSPACE 4
//#define DOWNLEFTOTHERPAWNSPACE 7
//#define DOWNRIGHTOTHERPAWNSPACE 8
//#define WALLSPACE 14
//

/*
 * NEW DEFINES FOR SPRITESHEET TAKE 3
 */

 #define UPLEFTBLANKSPACE 1
 #define UPRIGHTBLANKSPACE 2
 #define DOWNLEFTBLANKSPACE 6
 #define DOWNRIGHTBLANKSPACE 7
 #define UPLEFTSELFPAWNSPACE 16
 #define UPRIGHTSELFPAWNSPACE 17
 #define DOWNLEFTSELFPAWNSPACE 21
 #define DOWNRIGHTSELFPAWNSPACE 22
 #define UPLEFTOTHERPAWNSPACE 4
 #define UPRIGHTOTHERPAWNSPACE 5
 #define DOWNLEFTOTHERPAWNSPACE 9
 #define DOWNRIGHTOTHERPAWNSPACE 10
 #define BLANK 11
 #define LEFTWALLSPACE 12
 #define RIGHTWALLSPACE 15
 #define TOPWALLSPACE 3
 #define BOTTOMWALLSPACE 18
 #define VERTICALWALLSPACE 8
 #define HORIZONTALWALLSPACE 14
 #define FOURWAYWALLCROSS 13



 

#define ISINPAWNSPACE ((((int)tilePoint.y % 3) == 0) ||(((int)tilePoint.y-1)%3) == 0)&&((((int)tilePoint.x % 3) == 0) ||(((int)tilePoint.x-1)%3) == 0)
#define ISINWALLSPACE ((((int)tilePoint.x %3) == 2) ||(((int)tilePoint.y%3) == 2)&&(!(((int)tilePoint.x %3) == 2) &&(((int)tilePoint.y%3) == 2)))


@implementation GameLayer
@synthesize mainTileLayer = _mainTileLayer, tileMap = _tileMap, hudLayer = _hudLayer, currentGameState;

-(id) init
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    if( (self=[super init] )) {
        
        
        //Selects tilemap here
        
        if([UserPreferences sharedInstance].currentMap == 0){
            self.tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"WoodenMap.tmx"];
        }else if ([UserPreferences sharedInstance].currentMap == 1) {
            self.tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"DefaultMap.tmx"];
        }else if ([UserPreferences sharedInstance].currentMap == 2) {
            self.tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"GrassMap.tmx"];
        }

        self.mainTileLayer = [_tileMap layerNamed:@"Layer 1"];
        
        [self addChild:_tileMap z:-1];
        self.hudLayer = [HudLayer node];
        [self addChild:_hudLayer z:2];
        upArrow = [CCSprite spriteWithFile:@"uparrow.png"];
        [upArrow setPosition:ccp(size.width -31, size.height - 30)];
        [upArrow setVisible:YES];
        downArrow = [CCSprite spriteWithFile:@"downarrow.png"];
        [downArrow setPosition:ccp(size.width - 31, 30)];
        [downArrow setVisible:NO];
        [self addChild:upArrow];
        [self addChild:downArrow];
        
    }
    self.isTouchEnabled = YES;
    currentGameState = [[GameState alloc]initWithNewMatch];
    //new match
    
    [self initWithTurnBasedMatch:[[GCTurnBasedMatchHelper sharedInstance] currentMatch]];
    [self.hudLayer updateWithPlayer1:currentGameState.p1WallsRemaining andPlayer2Walls:currentGameState.p2WallsRemaining];
    [CCMenuItemFont setFontName:@"Marker Felt"];
    CCMenuItem *back = [CCMenuItemFont itemWithString:@"BACK" block:^(id sender){
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MainMenu scene] withColor:ccBLACK]];

    }];
    CCMenu *backMenu = [CCMenu menuWithItems:back, nil];
    [backMenu alignItemsVerticallyWithPadding:20];
    [backMenu setPosition:ccp(size.width - 31, size.height/2)];
    [self addChild:backMenu];
    return self;
}

-(void) initWithTurnBasedMatch:(GKTurnBasedMatch *) match{
    
    //check here if is new match
    GKTurnBasedParticipant *firstParticipant = [match.participants objectAtIndex:0];
    
    // If there is a player
    if(firstParticipant.lastTurnDate){
        currentGameState = [[NSKeyedUnarchiver unarchiveObjectWithData:match.matchData] retain];
        if ([match.currentParticipant.playerID isEqualToString:[GKLocalPlayer localPlayer].playerID]) {
            isPlayersTurn = YES;
            localPlayer = currentGameState.currentPlayer;
        }
        else{
            isPlayersTurn = NO;
            if(currentGameState.currentPlayer ==1){
                localPlayer = 2;
            }else{
                localPlayer = 1;
            }
        }
        NSMutableArray *playerIDs = [NSMutableArray arrayWithCapacity:match.participants.count];
        for (GKTurnBasedParticipant *part in match.participants) {
            if([part.playerID isKindOfClass:[NSString class]]){
                [playerIDs addObject:part.playerID];
            }
        }
        
    
        [GKPlayer loadPlayersForIdentifiers:playerIDs withCompletionHandler:^(NSArray *players, NSError *error) {
            [TestFlight passCheckpoint:[NSString stringWithFormat:@"%@ is playing a match with %@", [[players objectAtIndex:0] alias] , [[players objectAtIndex:1] alias]]];

            
            
        }];


    }else{
        isPlayersTurn = YES;
        localPlayer = 1;
    }
    [self.hudLayer player1IsLocal:localPlayer==1];
    [self movePawnFrom: CGPointMake(4, 8) to:CGPointMake(currentGameState.player1Pawn.x, currentGameState.player1Pawn.y) isPlayerSelf:(localPlayer == 1) isSwap:NO];
    [self movePawnFrom: CGPointMake(4, 0) to:CGPointMake(currentGameState.player2Pawn.x, currentGameState.player2Pawn.y) isPlayerSelf:(localPlayer == 2) isSwap:NO];
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
    [_tileMap setPosition: ccpAdd(_tileMap.position, CGPointMake(round(diff.x),round(diff.y)))];
    
    NSLog(@"%f",_tileMap.position.y);
    if (_tileMap.position.y < 0) {
        [downArrow setVisible:YES];
    }else{
        [downArrow setVisible:NO];
        [_tileMap setPosition: CGPointMake(_tileMap.position.x,0)];

    }
    if (_tileMap.position.y < -100) {
        [upArrow setVisible:NO];
        [_tileMap setPosition: CGPointMake(_tileMap.position.x,-100)];

    }else{
        [upArrow setVisible:YES];
    }

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
    gridPosition1 = gridPosition;
    if(isWall){
        if(gridPosition.x < 8 && gridPosition.y <8){
            Wall *newWall = [[Wall alloc] initWithX:gridPosition.x andY:gridPosition.y andVerticalFlag:!isHorizontal];
            if([self isValidWall:newWall]){
                [currentGameState addWall: newWall];
                PathfinderClass *pathfinder = [[PathfinderClass alloc] initWithGameData:currentGameState];
                if((![pathfinder isOpenPathForPlayer:1]||![pathfinder isOpenPathForPlayer:2])){
                    UIAlertView* myAlertView = [[UIAlertView alloc] initWithTitle: @"Illegal Wall" message: @"Wall creates a perfect prison" delegate: nil cancelButtonTitle: @"OK" otherButtonTitles: nil];
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
            if(gridPosition.x == currentGameState.player2Pawn.x && currentGameState.player2Pawn.y == gridPosition.y){
                UIAlertView *swapAlertView = [[UIAlertView alloc] initWithTitle: @"Swap?" message: @"Are you sure you want to swap places with the other player?" delegate: self cancelButtonTitle: @"No" otherButtonTitles: @"Yes", nil];
                swapAlertView.tag = 2;
                [[[CCDirector sharedDirector] view] addSubview: swapAlertView];
                [swapAlertView show];
                [swapAlertView release];
                return;
            }
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
            [self movePawnFrom:prevPawnPosition to:gridPosition isPlayerSelf:YES isSwap:NO];
            movedPawn = YES;
            
            
        }else if(currentGameState.currentPlayer == 2){
            //move pawn in game state representation
            CGPoint prevPawnPosition = CGPointMake(currentGameState.player2Pawn.x, currentGameState.player2Pawn.y);
            if(gridPosition.x == currentGameState.player1Pawn.x && currentGameState.player1Pawn.y == gridPosition.y){
                UIAlertView *swapAlertView = [[UIAlertView alloc] initWithTitle: @"Swap?" message: @"Are you sure you want to swap places with the other player?" delegate: self cancelButtonTitle: @"No" otherButtonTitles: @"Yes", nil];
                swapAlertView.tag = 2;
                [[[CCDirector sharedDirector] view] addSubview: swapAlertView];
                [swapAlertView show];
                [swapAlertView release];
                return;
            }

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
            [self movePawnFrom:prevPawnPosition to:gridPosition isPlayerSelf:YES isSwap:NO];
            movedPawn = YES;

        }

    }
    [self.hudLayer updateWithPlayer1:currentGameState.p1WallsRemaining andPlayer2Walls:currentGameState.p2WallsRemaining];

    if([self isWon]){
        [self wonMatch];
        return;
        
    }
    
    
    
    if(movedPawn || placedWall){
        UIAlertView *endTurnAlertView = [[UIAlertView alloc] initWithTitle: @"End Your Turn?" message: nil delegate: self cancelButtonTitle: @"Undo Move" otherButtonTitles: @"End Turn", nil];
        endTurnAlertView.tag = 1;
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
        if((oldWall.topLeftPointX == wall.topLeftPointX +1 || oldWall.topLeftPointX == wall.topLeftPointX -1) && (wall.topLeftPointY == oldWall.topLeftPointY) && (oldWall.isVertical == NO && wall.isVertical == NO)){
            return NO;
        }
        if((oldWall.topLeftPointY == wall.topLeftPointY +1 || oldWall.topLeftPointY == wall.topLeftPointY -1) && (wall.topLeftPointX == oldWall.topLeftPointX) && (oldWall.isVertical == YES && wall.isVertical == YES)){
            return NO;
        }

    }
    if(currentGameState.currentPlayer == 1){
        if(currentGameState.p1WallsRemaining < 0){
            UIAlertView *badWall = [[UIAlertView alloc] initWithTitle: @"Illegal Wall" message: @"You have no walls left" delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
            [[[CCDirector sharedDirector] view] addSubview: badWall];
            [badWall show];
            [badWall release];
            return NO;

        }
    }else{
        if(currentGameState.p2WallsRemaining < 0){
            UIAlertView *badWall = [[UIAlertView alloc] initWithTitle: @"Illegal Wall" message: @"You have no walls left" delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
            [[[CCDirector sharedDirector] view] addSubview: badWall];
            [badWall show];
            [badWall release];
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
-(void) movePawnFrom: (CGPoint) fromPoint to:(CGPoint) toPoint isPlayerSelf: (BOOL) isPlayerSelf isSwap: (BOOL) isSwap{
    CGPoint topLeftFrom, topLeftTo;
    topLeftFrom = [self tilePointFromGridPoint:fromPoint andIsWall:NO andHorizontal:NO];
    topLeftTo = [self tilePointFromGridPoint:toPoint andIsWall:NO andHorizontal:NO];
    
    if (isSwap) {
        [_mainTileLayer setTileGID:UPLEFTSELFPAWNSPACE at:topLeftTo];
        [_mainTileLayer setTileGID:UPRIGHTSELFPAWNSPACE at:CGPointMake(topLeftTo.x + 1, topLeftTo.y)];
        [_mainTileLayer setTileGID:DOWNRIGHTSELFPAWNSPACE at:CGPointMake(topLeftTo.x + 1, topLeftTo.y + 1)];
        [_mainTileLayer setTileGID:DOWNLEFTSELFPAWNSPACE at:CGPointMake(topLeftTo.x, topLeftTo.y +1)];
        [_mainTileLayer setTileGID:UPLEFTOTHERPAWNSPACE at:topLeftFrom];
        [_mainTileLayer setTileGID:UPRIGHTOTHERPAWNSPACE at:CGPointMake(topLeftFrom.x + 1, topLeftFrom.y)];
        [_mainTileLayer setTileGID:DOWNRIGHTOTHERPAWNSPACE at:CGPointMake(topLeftFrom.x + 1, topLeftFrom.y + 1)];
        [_mainTileLayer setTileGID:DOWNLEFTOTHERPAWNSPACE at:CGPointMake(topLeftFrom.x, topLeftFrom.y +1)];
        return;

    }
    
    //blank the old space
    [_mainTileLayer setTileGID:UPLEFTBLANKSPACE at:topLeftFrom];
    [_mainTileLayer setTileGID:UPRIGHTBLANKSPACE at:CGPointMake(topLeftFrom.x + 1, topLeftFrom.y)];
    [_mainTileLayer setTileGID:DOWNRIGHTBLANKSPACE at:CGPointMake(topLeftFrom.x + 1, topLeftFrom.y + 1)];
    [_mainTileLayer setTileGID:DOWNLEFTBLANKSPACE at:CGPointMake(topLeftFrom.x, topLeftFrom.y +1)];
    
    //put a pawn in the new space
    if(isPlayerSelf){
        [_mainTileLayer setTileGID:UPLEFTSELFPAWNSPACE at:topLeftTo];
        [_mainTileLayer setTileGID:UPRIGHTSELFPAWNSPACE at:CGPointMake(topLeftTo.x + 1, topLeftTo.y)];
        [_mainTileLayer setTileGID:DOWNRIGHTSELFPAWNSPACE at:CGPointMake(topLeftTo.x + 1, topLeftTo.y + 1)];
        [_mainTileLayer setTileGID:DOWNLEFTSELFPAWNSPACE at:CGPointMake(topLeftTo.x, topLeftTo.y +1)];
    }else{
        [_mainTileLayer setTileGID:UPLEFTOTHERPAWNSPACE at:topLeftTo];
        [_mainTileLayer setTileGID:UPRIGHTOTHERPAWNSPACE at:CGPointMake(topLeftTo.x + 1, topLeftTo.y)];
        [_mainTileLayer setTileGID:DOWNRIGHTOTHERPAWNSPACE at:CGPointMake(topLeftTo.x + 1, topLeftTo.y + 1)];
        [_mainTileLayer setTileGID:DOWNLEFTOTHERPAWNSPACE at:CGPointMake(topLeftTo.x, topLeftTo.y +1)];

    }


    
}
-(void) addVisualWall:(Wall *) wall{
    if(wall.isVertical){
        CGPoint top = [self tilePointFromGridPoint:(CGPointMake(wall.topLeftPointX, wall.topLeftPointY)) andIsWall:YES andHorizontal:NO];
        [_mainTileLayer setTileGID:TOPWALLSPACE at:top];
        [_mainTileLayer setTileGID:VERTICALWALLSPACE at:(CGPointMake(top.x, top.y +1))];
        if((int)([_mainTileLayer tileGIDAt:(CGPointMake(top.x, top.y+2))])==HORIZONTALWALLSPACE){
            [_mainTileLayer setTileGID:FOURWAYWALLCROSS at:CGPointMake(top.x, top.y+2)];
        }
        else{
            
            [_mainTileLayer setTileGID:VERTICALWALLSPACE at:(CGPointMake(top.x, top.y +2))];
        }
        [_mainTileLayer setTileGID:VERTICALWALLSPACE at:(CGPointMake(top.x, top.y +3))];
        [_mainTileLayer setTileGID:BOTTOMWALLSPACE at:(CGPointMake(top.x, top.y +4))];

    }else{
        CGPoint left = [self tilePointFromGridPoint:(CGPointMake(wall.topLeftPointX, wall.topLeftPointY)) andIsWall:YES andHorizontal:YES];
        [_mainTileLayer setTileGID:LEFTWALLSPACE at:left];
        [_mainTileLayer setTileGID:HORIZONTALWALLSPACE at:(CGPointMake(left.x+1, left.y))];
        if((int)([_mainTileLayer tileGIDAt:(CGPointMake(left.x+2, left.y))])==VERTICALWALLSPACE){
            [_mainTileLayer setTileGID:FOURWAYWALLCROSS at:CGPointMake(left.x+2, left.y)];
        }
        else{
            
            [_mainTileLayer setTileGID:HORIZONTALWALLSPACE at:(CGPointMake(left.x+2, left.y))];
        }

        [_mainTileLayer setTileGID:HORIZONTALWALLSPACE at:(CGPointMake(left.x+3, left.y))];
        [_mainTileLayer setTileGID:RIGHTWALLSPACE at:(CGPointMake(left.x+4, left.y))];
    }

}
-(void) removeVisualWall:(Wall *) wall{
    if(wall.isVertical){
        CGPoint top = [self tilePointFromGridPoint:(CGPointMake(wall.topLeftPointX, wall.topLeftPointY)) andIsWall:YES andHorizontal:NO];
        [_mainTileLayer setTileGID:BLANK at:top];
        [_mainTileLayer setTileGID:BLANK at:(CGPointMake(top.x, top.y +1))];
        [_mainTileLayer setTileGID:BLANK at:(CGPointMake(top.x, top.y +2))];
        [_mainTileLayer setTileGID:BLANK at:(CGPointMake(top.x, top.y +3))];
        [_mainTileLayer setTileGID:BLANK at:(CGPointMake(top.x, top.y +4))];
    }else{
        CGPoint left = [self tilePointFromGridPoint:(CGPointMake(wall.topLeftPointX, wall.topLeftPointY)) andIsWall:YES andHorizontal:YES];
        [_mainTileLayer setTileGID:BLANK at:left];
        [_mainTileLayer setTileGID:BLANK at:(CGPointMake(left.x+1, left.y))];
        [_mainTileLayer setTileGID:BLANK at:(CGPointMake(left.x+2, left.y))];
        [_mainTileLayer setTileGID:BLANK at:(CGPointMake(left.x+3, left.y))];
        [_mainTileLayer setTileGID:BLANK at:(CGPointMake(left.x+4, left.y))];
        
    }

}

-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 1){
        if(buttonIndex ==0){
            [self undoLastMove:NO];
        }
        else if(buttonIndex == 1){
            [self endTurn];
        }
        [self.hudLayer updateWithPlayer1:currentGameState.p1WallsRemaining andPlayer2Walls:currentGameState.p2WallsRemaining];
    }else if(alertView.tag ==2){
        if(buttonIndex == 1){
            if(currentGameState.currentPlayer ==1){
                CGPoint prevPawnPosition = CGPointMake(currentGameState.player1Pawn.x, currentGameState.player1Pawn.y);
                if(((currentGameState.player1Pawn.x - gridPosition1.x == 1 || currentGameState.player1Pawn.x - gridPosition1.x == -1)&& currentGameState.player1Pawn.y == gridPosition1.y)){
                    if((currentGameState.player1Pawn.y - gridPosition1.y == -1 || currentGameState.player1Pawn.x - gridPosition1.x == -1)){
                        [currentGameState movePawn:1 inDirection:RIGHT];
                        [currentGameState movePawn:2 inDirection:LEFT];
                    }else{
                        [currentGameState movePawn:1 inDirection:LEFT];
                        [currentGameState movePawn:2 inDirection:RIGHT];
                    }
                }else{
                    if((currentGameState.player1Pawn.y - gridPosition1.y == -1 || currentGameState.player1Pawn.x - gridPosition1.x == -1)){
                        [currentGameState movePawn:1 inDirection:DOWN];
                        [currentGameState movePawn:2 inDirection:UP];
                    }else{
                        [currentGameState movePawn:1 inDirection:UP];
                        [currentGameState movePawn:2 inDirection:DOWN];
                    }
                    
                }
                [self movePawnFrom:prevPawnPosition to:gridPosition1 isPlayerSelf:YES isSwap:YES];
                
            }
            else if(currentGameState.currentPlayer ==2){
                CGPoint prevPawnPosition = CGPointMake(currentGameState.player2Pawn.x, currentGameState.player2Pawn.y);
                if(((currentGameState.player2Pawn.x - gridPosition1.x == 1 || currentGameState.player2Pawn.x - gridPosition1.x == -1)&& currentGameState.player2Pawn.y == gridPosition1.y)){
                    if((currentGameState.player2Pawn.y - gridPosition1.y == -1 || currentGameState.player2Pawn.x - gridPosition1.x == -1)){
                        [currentGameState movePawn:2 inDirection:RIGHT];
                        [currentGameState movePawn:1 inDirection:LEFT];
                    }else{
                        [currentGameState movePawn:2 inDirection:LEFT];
                        [currentGameState movePawn:1 inDirection:RIGHT];
                    }
                }else{
                    if((currentGameState.player2Pawn.y - gridPosition1.y == -1 || currentGameState.player2Pawn.x - gridPosition1.x == -1)){
                        [currentGameState movePawn:2 inDirection:DOWN];
                        [currentGameState movePawn:1 inDirection:UP];
                    }else{
                        [currentGameState movePawn:2 inDirection:UP];
                        [currentGameState movePawn:1 inDirection:DOWN];
                    }
                    
                }
                [self movePawnFrom:prevPawnPosition to:gridPosition1 isPlayerSelf:YES isSwap:YES];
                    
                

            }
            [self endTurn];
        }
    }
}

-(void) undoLastMove:(BOOL) isSwap{
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
        [self movePawnFrom:currentPawnPosition to:prevPawnPosition isPlayerSelf:YES isSwap:(isSwap)];
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
    isPlayersTurn = NO;
//    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MainMenu scene] withColor:ccBlack]];

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
    if(currentGameState.currentPlayer == 1){
        currentGameState.currentPlayer = 2;
    }else{
        currentGameState.currentPlayer = 1;
    }

    winner.matchOutcome = GKTurnBasedMatchOutcomeWon;
    loser.matchOutcome = GKTurnBasedMatchOutcomeLost;
    TFLog(@"Someone won a game");
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:currentGameState];
    [currentMatch endMatchInTurnWithMatchData:data completionHandler:^(NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        }
        
    }];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[VictoryScreen scene] withColor:ccWHITE]];

}
-(BOOL) isWon{
    if(currentGameState.currentPlayer == 1){
        if(currentGameState.player1Pawn.y == 0){
            return YES;
        }
    }else{
        if (currentGameState.player2Pawn.y == 8){
            return YES;
        }
    }
    return NO;
}

@end

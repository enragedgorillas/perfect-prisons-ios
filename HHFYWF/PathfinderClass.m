//
//  PathfinderClass.m
//  HHFYWF
//
//  Created by McCall Saltzman on 2/9/13.
//
//

#import "PathfinderClass.h"
#import "GameState.h"
#import "Wall.h"
#import "Pawn.h"
#import "PathfinderStep.h"

@interface PathfinderClass ()
@property (nonatomic, retain) NSMutableArray *spOpenSteps;
@property (nonatomic, retain) NSMutableArray *spClosedSteps;

- (void)insertInOpenSteps:(PathfinderStep *)step;
- (int)computeHScoreFromCoord:(CGPoint)fromCoord toEnd:(int)endRow;
- (int)costToMoveFromStep:(PathfinderStep *)fromStep toAdjacentStep:(PathfinderStep *)toStep;

@end


@implementation PathfinderClass
@synthesize spOpenSteps;
@synthesize spClosedSteps;
@synthesize gameState;

-(id) initWithGameData:(GameState *) gameData{
    self = [super init];
    self.spOpenSteps = nil;
    self.spClosedSteps = nil;
    gameState = gameData;
    
    return self;

}

- (void)dealloc
{
	[spOpenSteps release]; spOpenSteps = nil;
	[spClosedSteps release]; spClosedSteps = nil;
    gameState = nil;    
	[super dealloc];
}
- (BOOL) isOpenPathForPlayer:(int) player
{
    //Get current tile coordinate and end point
    CGPoint fromTileCoord;
    int endYPosition;
    if(player ==1){
        fromTileCoord = CGPointMake(gameState.player1Pawn.x, gameState.player1Pawn.y);
        endYPosition = 0;
    }else{
        fromTileCoord = CGPointMake(gameState.player2Pawn.x, gameState.player2Pawn.y);
        endYPosition = 8;
    }
    BOOL pathFound = NO;
    self.spOpenSteps = [[[NSMutableArray alloc] init] autorelease];
    self.spClosedSteps = [[[NSMutableArray alloc] init] autorelease];
    
    // Start by adding the from position to the open list
    [self insertInOpenSteps:[[[PathfinderStep alloc] initWithPosition:fromTileCoord] autorelease]];
    
    do {
        // Get the lowest F cost step
        // Because the list is ordered, the first step is always the one with the lowest F cost
        PathfinderStep *currentStep = [self.spOpenSteps objectAtIndex:0];
        
        // Add the current step to the closed set
        [self.spClosedSteps addObject:currentStep];
        
        // Remove it from the open list
        // Note that if we wanted to first removing from the open list, care should be taken to the memory
        [self.spOpenSteps removeObjectAtIndex:0];
        
        // If the currentStep is the desired tile coordinate, we are done!
        if (currentStep.position.y == endYPosition) {
            
            pathFound = YES;
            PathfinderStep *tmpStep = currentStep;
            NSLog(@"PATH FOUND :");
            do {
                NSLog(@"%@", tmpStep);
                tmpStep = tmpStep.parent; // Go backward
            } while (tmpStep != nil); // Until there is not more parent
            
            self.spOpenSteps = nil; // Set to nil to release unused memory
            self.spClosedSteps = nil; // Set to nil to release unused memory
            break;
        }
        
        // Get the adjacent tiles coord of the current step
        NSArray *adjSteps = [self walkableAdjacentTilesCoordForTileCoord:currentStep.position];
        
        for (NSValue *v in adjSteps) {
            PathfinderStep *step = [[PathfinderStep alloc] initWithPosition:[v CGPointValue]];
            
            // Check if the step isn't already in the closed set
            if ([self.spClosedSteps containsObject:step]) {
                [step release]; // Must releasing it to not leaking memory ;-)
                continue; // Ignore it
            }
            
            // Compute the cost from the current step to that step
            int moveCost = [self costToMoveFromStep:currentStep toAdjacentStep:step];
            
            // Check if the step is already in the open list
            NSUInteger index = [self.spOpenSteps indexOfObject:step];
            
            if (index == NSNotFound) { // Not on the open list, so add it
                
                // Set the current step as the parent
                step.parent = currentStep;
                
                // The G score is equal to the parent G score + the cost to move from the parent to it
                step.gScore = currentStep.gScore + moveCost;
                
                // Compute the H score which is the estimated movement cost to move from that step to the desired tile coordinate
                step.hScore = [self computeHScoreFromCoord:step.position toEnd:endYPosition];
                
                // Adding it with the function which is preserving the list ordered by F score
                [self insertInOpenSteps:step];
                
                // Done, now release the step
                [step release];
            }
            else { // Already in the open list
                
                [step release]; // Release the freshly created one
                step = [self.spOpenSteps objectAtIndex:index]; // To retrieve the old one (which has its scores already computed ;-)
                
                // Check to see if the G score for that step is lower if we use the current step to get there
                if ((currentStep.gScore + moveCost) < step.gScore) {
                    
                    // The G score is equal to the parent G score + the cost to move from the parent to it
                    step.gScore = currentStep.gScore + moveCost;
                    
                    // Because the G Score has changed, the F score may have changed too
                    // So to keep the open list ordered we have to remove the step, and re-insert it with
                    // the insert function which is preserving the list ordered by F score
                    
                    // We have to retain it before removing it from the list
                    [step retain];
                    
                    // Now we can removing it from the list without be afraid that it can be released
                    [self.spOpenSteps removeObjectAtIndex:index];
                    
                    // Re-insert it with the function which is preserving the list ordered by F score
                    [self insertInOpenSteps:step];
                    
                    // Now we can release it because the oredered list retain it
                    [step release];
                }
            }
        }
        
    } while ([self.spOpenSteps count] > 0);
    return pathFound;
}

- (void)insertInOpenSteps:(PathfinderStep *)step
{
	int stepFScore = [step fScore]; // Compute the step's F score
	int count = [self.spOpenSteps count];
	int i = 0; // This will be the index at which we will insert the step
	for (; i < count; i++) {
		if (stepFScore <= [[self.spOpenSteps objectAtIndex:i] fScore]) { // If the step's F score is lower or equals to the step at index i
			// Then we found the index at which we have to insert the new step
            // Basically we want the list sorted by F score
			break;
		}
	}
	// Insert the new step at the determined index to preserve the F score ordering
	[self.spOpenSteps insertObject:step atIndex:i];
}
- (int)computeHScoreFromCoord:(CGPoint)fromCoord toEnd:(int)endRow
{
	// Here we use the Manhattan method, which calculates the total number of step moved horizontally and vertically to reach the
	// final desired step from the current step, ignoring any obstacles that may be in the way
	return abs(endRow - fromCoord.y);
}

- (int)costToMoveFromStep:(PathfinderStep *)fromStep toAdjacentStep:(PathfinderStep *)toStep
{
	// Because we can't move diagonally and because terrain is just walkable or unwalkable the cost is always the same.
	// But it have to be different if we can move diagonally and/or if there is swamps, hills, etc...
	return 1;
}

- (NSArray *)walkableAdjacentTilesCoordForTileCoord:(CGPoint)tileCoord
{
	NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:4];
    
	// Top
	CGPoint p = CGPointMake(tileCoord.x, tileCoord.y - 1);
	if ([self isValidTileCoord:p] && [self validMoveFrom:tileCoord toPoint:p]) {
		[tmp addObject:[NSValue valueWithCGPoint:p]];
	}
    
	// Left
	p = CGPointMake(tileCoord.x - 1, tileCoord.y);
	if ([self isValidTileCoord:p] && [self validMoveFrom:tileCoord toPoint:p]) {
		[tmp addObject:[NSValue valueWithCGPoint:p]];
	}
    
	// Bottom
	p = CGPointMake(tileCoord.x, tileCoord.y + 1);
	if ([self isValidTileCoord:p] && [self validMoveFrom:tileCoord toPoint:p]) {
		[tmp addObject:[NSValue valueWithCGPoint:p]];
	}
    
	// Right
	p = CGPointMake(tileCoord.x + 1, tileCoord.y);
	if ([self isValidTileCoord:p] && [self validMoveFrom:tileCoord toPoint:p]) {
		[tmp addObject:[NSValue valueWithCGPoint:p]];
	}
    
	return [NSArray arrayWithArray:tmp];
}



-(BOOL) validMoveFrom:(CGPoint) fromPoint toPoint:(CGPoint) toPoint{
    BOOL validHorizontalMove, validVerticalMove, positiveMove, isValid;
    isValid = YES;
    
    validHorizontalMove = ((fromPoint.x - toPoint.x == 1 || fromPoint.x - toPoint.x == -1)&& fromPoint.y == toPoint.y);
    validVerticalMove= ((fromPoint.y - toPoint.y == 1 || fromPoint.y - toPoint.y == -1)&& fromPoint.x == toPoint.x);
    positiveMove = (fromPoint.y - toPoint.y == -1 || fromPoint.x - toPoint.x == -1);
    //    negativeMove = (pawn.y - move.y == 1 || pawn.x - move.x == 1);
    Wall* walls;
    if(validHorizontalMove){
        for(int i = 0; i<[gameState.wallArray count]; i++){
            walls = (Wall*)[gameState.wallArray objectAtIndex:i];
            if(walls.isVertical){
                if(positiveMove){
                    if(walls.topLeftPointX == fromPoint.x && (walls.topLeftPointY == fromPoint.y || walls.topLeftPointY == fromPoint.y - 1)){
                        isValid = NO;
                    }
                }else{
                    if(walls.topLeftPointX == fromPoint.x - 1 && (walls.topLeftPointY == fromPoint.y || walls.topLeftPointY == fromPoint.y - 1)){
                        isValid = NO;
                    }
                    
                }
            }
        }
    }else if(validVerticalMove){
        for(int i = 0; i<[gameState.wallArray count]; i++){
            walls = (Wall*)[gameState.wallArray objectAtIndex:i];
            
            if(!walls.isVertical){
                if(positiveMove){
                    if(walls.topLeftPointY == fromPoint.y && (walls.topLeftPointX == fromPoint.x || walls.topLeftPointX == fromPoint.x - 1)){
                        isValid = NO;
                    }
                }else{
                    if(walls.topLeftPointY == fromPoint.y - 1 && (walls.topLeftPointX == fromPoint.x || walls.topLeftPointX == fromPoint.x - 1)){
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
-(BOOL) isValidTileCoord:(CGPoint) tileCoord{
    if(tileCoord.x >= 0 && tileCoord.y >= 0 && tileCoord.x <= 8 && tileCoord.y <= 8){
        return YES;
    }
    return NO;
}




@end

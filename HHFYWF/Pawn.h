//
//  Pawn.h
//  HHFYWF
//
//  Created by McCall Saltzman on 2/1/13.
//
//

#import <Foundation/Foundation.h>

@interface Pawn : NSObject <NSCoding>{
    /*typedef enum MoveDirection{
        UP, RIGHT, DOWN, LEFT
    };*/
    
}
@property int x;
@property int y;
-(id) initWithX: (int) x1 andY: (int) y1;
//-(void) movePawn:(MoveDirection);

@end
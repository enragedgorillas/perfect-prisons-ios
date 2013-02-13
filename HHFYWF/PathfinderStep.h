//
//  PathfinderStep.h
//  HHFYWF
//
//  Created by McCall Saltzman on 2/9/13.
//
//

#import <Foundation/Foundation.h>

@interface PathfinderStep : NSObject
{
	CGPoint position;
	int gScore;
	int hScore;
	PathfinderStep *parent;
}

@property (nonatomic, assign) CGPoint position;
@property (nonatomic, assign) int gScore;
@property (nonatomic, assign) int hScore;
@property (nonatomic, assign) PathfinderStep *parent;

- (id)initWithPosition:(CGPoint)pos;
- (int)fScore;



@end

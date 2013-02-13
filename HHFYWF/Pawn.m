//
//  Pawn.m
//  HHFYWF
//
//  Created by McCall Saltzman on 2/1/13.
//
//

#import "Pawn.h"

@implementation Pawn
@synthesize x, y;

-(id) initWithX: (int) x1 andY: (int) y1{
    self = [super init];
    self.y = y1;
    self.x = x1;
    return self;
}
-(void)encodeWithCoder:(NSCoder *) encoder{
    [encoder encodeInt:x forKey:@"x"];
    [encoder encodeInt:y forKey:@"y"];
}
-(id) initWithCoder:(NSCoder *)decoder{
    int xd = [decoder decodeIntForKey:@"x"];
    int yd = [decoder decodeIntForKey:@"y"];
    self = [self initWithX:xd andY:yd];
    return self;
}

@end

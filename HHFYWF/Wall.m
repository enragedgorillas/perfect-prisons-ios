//
//  Wall.m
//  HHFYWF
//
//  Created by McCall Saltzman on 2/1/13.
//
//

#import "Wall.h"

@implementation Wall
@synthesize topLeftPointX, topLeftPointY, isVertical;

-(id) initWithX: (int) x andY: (int) y andVerticalFlag: (BOOL) flag{
    self = [super init];
    self.topLeftPointY = y;
    self.topLeftPointX = x;
    self.isVertical = flag;
    return self;
}
-(void)encodeWithCoder:(NSCoder *) encoder{
    [encoder encodeInt:topLeftPointX forKey:@"TopLeftPointX"];
    [encoder encodeInt:topLeftPointY forKey:@"TopLeftPointY"];
    [encoder encodeBool:isVertical forKey:@"IsVertical"];
}
-(id) initWithCoder:(NSCoder *)decoder{
    int xd = [decoder decodeIntForKey:@"TopLeftPointX"];
    int yd = [decoder decodeIntForKey:@"TopLeftPointY"];
    BOOL isVerticald = [decoder decodeBoolForKey:@"IsVertical"];
    self = [self initWithX:xd andY:yd andVerticalFlag:isVerticald];
    return self;
}

@end

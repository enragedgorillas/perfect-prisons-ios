//
//  Wall.h
//  HHFYWF
//
//  Created by McCall Saltzman on 2/1/13.
//
//

#import <Foundation/Foundation.h>

@interface Wall : NSObject<NSCoding>
@property (nonatomic) int topLeftPointX;
@property (nonatomic) int topLeftPointY;
@property (readwrite) BOOL isVertical;
-(id) initWithX: (int) x andY: (int) y andVerticalFlag: (BOOL) flag;

@end

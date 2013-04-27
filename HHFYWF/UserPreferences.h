//
//  UserPreferences.h
//  Perfect Prisons
//
//  Created by McCall Saltzman on 4/15/13.
//
//

#import <Foundation/Foundation.h>

@interface UserPreferences : NSObject
@property int currentMap;
+(UserPreferences *) sharedInstance;
-(void) changeMap:(int) newMapNum;
@end

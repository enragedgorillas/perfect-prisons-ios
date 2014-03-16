//
//  UserPreferences.m
//  Perfect Prisons
//
//  Created by McCall Saltzman on 4/15/13.
//
//

#import "UserPreferences.h"

@implementation UserPreferences
@synthesize currentMap;
static UserPreferences *sharedPreferences = nil;
+(UserPreferences *) sharedInstance{
    if(!sharedPreferences){
        sharedPreferences = [[UserPreferences alloc] init];
    }
    return sharedPreferences;
}

-(id) init{
    if(self = [super init]){
        [self getSavedPreferences];
    }
    return self;
}
-(void) getSavedPreferences{
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"MapSelect"]){
        currentMap =[[NSUserDefaults standardUserDefaults] integerForKey:@"MapSelect"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else{
        currentMap = 0;
    }
}


-(void)changeMap:(int)newMapNum{
    [[NSUserDefaults standardUserDefaults] setInteger:newMapNum forKey:@"MapSelect"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    currentMap = newMapNum;

}

@end

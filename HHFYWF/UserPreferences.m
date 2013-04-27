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
        NSString *path;
        path = [NSString stringWithFormat:@"%@/Library/Preferences/MapSelect.plist",NSHomeDirectory()];
        NSFileManager *objFileManager = [NSFileManager defaultManager];
        if(![objFileManager fileExistsAtPath:path]){
            [self changeMap:0];
        }else{
            [self getSavedPreferences];
        }
    }
    return self;
}
-(void) getSavedPreferences{
    NSString *path;
    NSMutableDictionary *objDictionary;

    path = [NSString stringWithFormat:@"%@/Library/Preferences/MapSelect.plist",NSHomeDirectory()];
    NSFileManager *objFileManager = [NSFileManager defaultManager];
    objDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    if([objFileManager fileExistsAtPath:path]){
        if(objDictionary != NULL){
            currentMap = [objDictionary objectForKey:@"Map Number"];
        }
    }

}
-(void)changeMap:(int)newMapNum{
    NSString *path;
    NSMutableDictionary *objDictionary;
    
    path = [NSString stringWithFormat:@"%@/Library/Preferences/myfile.plist",NSHomeDirectory()];
    objDictionary = [NSMutableDictionary dictionary];
    
    [objDictionary setValue:newMapNum forKey:@"Map Number"];
    [objDictionary writeToFile:path atomically:NO];
    currentMap = newMapNum;

}

@end

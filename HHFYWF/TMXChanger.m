//
//  TMXChanger.m
//  Perfect Prisons
//
//  Created by McCall Saltzman on 4/10/13.
//
//

#import "TMXChanger.h"

@implementation TMXChanger
@synthesize currentSpritesheet, newSpritesheet;

+ (NSString *)dataFilePath:(BOOL)forSave {
    return [[NSBundle mainBundle] pathForResource:@"Party" ofType:@"xml"];
}

+ (Party *)loadMap {
    
    NSString *filePath = [self dataFilePath:FALSE];
    NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    NSError *error;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData
                                                           options:0 error:&error];
    if (doc == nil) { return nil; }
    [[[[[doc.rootElement elementsForName:@"map"] objectAtIndex:0] elementsForName:@"tileset"]objectAtIndex:0] elementsForName:@"image"] 

    [doc release];
    [xmlData release];
    return nil;
    
}

@end

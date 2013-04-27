//
//  GCTurnBasedMatchHelper.h
//  HHFYWF
//
//  Created by McCall Saltzman on 2/11/13.
//
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@interface GCTurnBasedMatchHelper : NSObject <GKTurnBasedMatchmakerViewControllerDelegate, GKTurnBasedEventHandlerDelegate, UIAlertViewDelegate>{
    BOOL gameCenterAvailable;
    BOOL userAuthenticated;
    UIViewController *presentingViewController;

}

@property (retain) GKTurnBasedMatch * currentMatch;
@property (nonatomic) BOOL didLaunchWithMatch;

@property (assign, readonly) BOOL gameCenterAvailable;

+ (GCTurnBasedMatchHelper *)sharedInstance;
- (void)authenticateLocalUser;
- (void)findMatchWithMinPlayers:(int)minPlayers
                     maxPlayers:(int)maxPlayers
                 viewController:(UIViewController *)viewController;

@end

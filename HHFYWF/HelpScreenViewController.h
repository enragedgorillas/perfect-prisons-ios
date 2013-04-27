//
//  HelpScreenViewController.h
//  Perfect Prisons
//
//  Created by McCall Saltzman on 4/22/13.
//
//

#import <UIKit/UIKit.h>

@interface HelpScreenViewController : UIViewController<UIScrollViewDelegate>{

}

@property (nonatomic, strong) IBOutlet UIScrollView* scrollView;
@property (nonatomic, retain) IBOutlet UIPageControl* pageControl;

@end

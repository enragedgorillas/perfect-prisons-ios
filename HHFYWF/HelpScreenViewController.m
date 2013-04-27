//
//  HelpScreenViewController.m
//  Perfect Prisons
//
//  Created by McCall Saltzman on 4/22/13.
//
//

#import "HelpScreenViewController.h"

@interface HelpScreenViewController ()

@end

@implementation HelpScreenViewController
@synthesize scrollView,pageControl;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIImage *img1 = [UIImage imageNamed:@"firstSlide.png"];
    UIImage *img2 = [UIImage imageNamed:@"Yourpawn1.ong"];
    UIImage *img3 = [UIImage imageNamed:@"Goal.png"];
    UIImage *img4 = [UIImage imageNamed:@"enemyGoal.png"];
    UIImage *img5 = [UIImage imageNamed:@"yourTurn.png"];
    UIImage *img6 = [UIImage imageNamed:@"placePawn.png"];
    UIImage *img7 = [UIImage imageNamed:@"noPerfectPrisions.png"];
    UIImage *img8 = [UIImage imageNamed:@"moveThroughWalls.png"];
    UIImage *img9 = [UIImage imageNamed:@"remainingWalls.png"];
    UIImage *img10 = [UIImage imageNamed:@"arrows.png"];
    scrollView.delegate = self;

    
    NSArray *helpImages = [NSArray arrayWithObjects: img1,img2,img3,img4,img5,img6,img7,img8,img9,img10, nil];
    for (int i = 0; i < helpImages.count; i++) {
        CGRect frame;
        frame.origin.x = self.scrollView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.scrollView.frame.size;
        
        UIImageView *subview = [[UIImageView alloc] initWithFrame:frame];
        subview.image = [helpImages objectAtIndex:i];
        [self.scrollView addSubview:subview];
        [subview release];
    }
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * helpImages.count, self.scrollView.frame.size.height);


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}


@end

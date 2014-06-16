//
//  DropitViewController.m
//  Dropit
//
//  Created by myqiqiang on 14-6-15.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import "DropitViewController.h"
#import "Dropitehavior.h"
#import "BezierPath.h"

@interface DropitViewController () <UIDynamicAnimatorDelegate>
@property (weak, nonatomic) IBOutlet BezierPath *gameView;
@property (strong,nonatomic) UIDynamicAnimator *animator;
@property (strong,nonatomic) Dropitehavior *dropitbehavior;
@property (strong,nonatomic) UIAttachmentBehavior *attachment;
@property (strong,nonatomic) UIView *dropingView;

@end

@implementation DropitViewController

static const CGSize DROP_SIZE = {40,40};

-(UIDynamicAnimator *)animator
{
    if(!_animator){
        _animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.gameView];
        _animator.delegate = self;
    }
    return _animator;
}

-(void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator
{
    [self removeCompleteRow];
}

-(BOOL)removeCompleteRow
{
    NSMutableArray *dropsToReove = [[NSMutableArray alloc] init];
    
    for (CGFloat y= self.gameView.bounds.size.height-DROP_SIZE.height/2; y>0; y -= DROP_SIZE.height) {
        BOOL rowIsComplete = YES;
        NSMutableArray *dropsFound = [[NSMutableArray alloc] init];
        for (CGFloat x =DROP_SIZE.width/2; x<=self.gameView.bounds.size.width-DROP_SIZE.width/2; x +=DROP_SIZE.width) {
            UIView *hitview = [self.gameView hitTest:CGPointMake(x, y) withEvent:NULL];
            if ([hitview superview]==self.gameView) {
                [dropsFound addObject:hitview];
            } else {
                rowIsComplete = NO;
                break;
            }
        }
        if (![dropsFound count]) break;
        if(rowIsComplete) [dropsToReove addObjectsFromArray:dropsFound];
    }
    
    if([dropsToReove count]){
        for (UIView *drop in dropsToReove) {
            [self.dropitbehavior removeItem:drop];
        }
        [self animatorRemovingDrops:dropsToReove];
    }
    
    return NO;
}

-(void)animatorRemovingDrops:(NSArray *)dropsToRemove
{
    [UIView animateWithDuration:1.0
                     animations:^{
                         for (UIView *drop in dropsToRemove) {
                             int x = (arc4random()%(int)(self.gameView.bounds.size.width*5))-(int)self.gameView.bounds.size.width*2;
                             int y = self.gameView.bounds.size.height;
                             drop.center = CGPointMake(x,-y);
                         }
                     }
                     completion:^(BOOL finished){
                         [dropsToRemove makeObjectsPerformSelector:@selector(removeFromSuperview)];

                     }];
}

-(Dropitehavior *)dropitbehavior
{
    if (!_dropitbehavior) {
        _dropitbehavior = [[Dropitehavior alloc] init];
        [self.animator addBehavior:_dropitbehavior];
    }
    return _dropitbehavior;
}


- (IBAction)tap:(UITapGestureRecognizer *)sender
{
    [self drop];
}
- (IBAction)pan:(UIPanGestureRecognizer *)sender
{
    CGPoint gesturePoint = [sender locationInView:self.gameView];
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self attachDropingViewToPoint:gesturePoint];
    } else if(sender.state == UIGestureRecognizerStateChanged){
        self.attachment.anchorPoint = gesturePoint;
    } else if(sender.state == UIGestureRecognizerStateEnded){
        [self.animator removeBehavior:self.attachment];
        self.gameView.path = nil;
    }
}

-(void)attachDropingViewToPoint:(CGPoint)anchorPoint
{
    if (self.dropingView) {
        self.attachment = [[UIAttachmentBehavior alloc] initWithItem:self.dropingView attachedToAnchor:anchorPoint];
        UIView *dropingView = self.dropingView;
        __weak DropitViewController *weakself = self;
        self.attachment.action = ^{
            UIBezierPath *path =[[UIBezierPath alloc] init];
            [path moveToPoint:weakself.attachment.anchorPoint];
            [path addLineToPoint:dropingView.center];
            weakself.gameView.path = path;
        };
        self.dropingView = nil;
        [self.animator addBehavior:self.attachment];
    }
    
}

-(void)drop
{
    CGRect frame;
    frame.origin = CGPointZero;
    frame.size = DROP_SIZE;
    int x = (arc4random()%(int)self.gameView.bounds.size.width)/DROP_SIZE.width;
    frame.origin.x = x*DROP_SIZE.width;
    
    UIView *dropView = [[UIView alloc] initWithFrame:frame];
    dropView.backgroundColor = [self randomColor];
    [self.gameView addSubview:dropView];
    
    self.dropingView = dropView;
    
    [self.dropitbehavior addItem:dropView];
}

-(UIColor *)randomColor
{
    switch (arc4random()%5) {
        case 0:
            return [UIColor greenColor];
            break;
        case 1:
            return [UIColor redColor];
            break;
        case 2:
            return [UIColor blueColor];
            break;
        case 3:
            return [UIColor orangeColor];
            break;
        case 4:
            return [UIColor purpleColor];
            break;
    }
    return [UIColor blackColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  ViewController.m
//  Transform
//
//  Created by dongyongzhu on 15/4/1.
//  Copyright (c) 2015年 innovator. All rights reserved.
//

#import "ViewController.h"
#import "TransformView.h"

@interface ViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) IBOutlet UIImageView      *imageview;
@property (nonatomic, strong) IBOutlet TransformView    *transformView;

@property (nonatomic, strong) UITapGestureRecognizer        *tapGesture;
@property (nonatomic, strong) UIPanGestureRecognizer        *moveGesture;
@property (nonatomic, strong) UIPinchGestureRecognizer      *scaleGesture;
@property (nonatomic, strong) UIRotationGestureRecognizer   *rotateGesture;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark - Load Gesture
- (void)loadGesture {
    //单指双击手势
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                              action:@selector(singleTapGesture:)];
    self.tapGesture.numberOfTapsRequired = 2;
    //    self.tapGesture.delegate = self;
    [self.view addGestureRecognizer:self.tapGesture];
    
    //平移手势
    self.moveGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                               action:@selector(moveGesture:)];
    self.moveGesture.delegate = self;
    [self.view addGestureRecognizer:self.moveGesture];
    
    //缩放手势
    self.scaleGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                                                  action:@selector(scaleGesture:)];
    self.scaleGesture.delegate = self;
    [self.view addGestureRecognizer:self.scaleGesture];
    
    
    //旋转手势
    self.rotateGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self
                                                                      action:@selector(rotateGesture:)];
    self.rotateGesture.delegate = self;
    [self.view addGestureRecognizer:self.rotateGesture];
}

#pragma mark -
#pragma mark - UIGesture
- (void)singleTapGesture:(UITapGestureRecognizer*)tapGesture {
    CGPoint point = [tapGesture locationInView:self.transformView];
    
    CGRect rect = self.transformView.bounds;
    CGRect curRect = self.transformView.frame;
    
    if (curRect.size.width / rect.size.width > 3.0) {
        [self.transformView scale:CGSizeMake(1.0/3, 1.0/3) atPoint:point];
    }else {
        [self.transformView scale:CGSizeMake(3, 3) atPoint:point];
    }
}

- (void)scaleGesture:(UIPinchGestureRecognizer*)tapGesture {
    [self.transformView scale:(CGSize){tapGesture.scale, tapGesture.scale}
                      atPoint:[tapGesture locationInView:self.transformView]];
    [tapGesture setScale:1];
}

- (void)moveGesture:(UIPanGestureRecognizer*)moveGesture {
    if (moveGesture.state == UIGestureRecognizerStateBegan ||
        moveGesture.state == UIGestureRecognizerStateChanged ||
        moveGesture.state == UIGestureRecognizerStateRecognized ||
        moveGesture.state == UIGestureRecognizerStateEnded ||
        moveGesture.state == UIGestureRecognizerStatePossible) {
        [self.transformView move:[moveGesture translationInView:self.view]];
    }
    [moveGesture setTranslation:CGPointZero inView:self.transformView];
}

- (void)rotateGesture:(UIRotationGestureRecognizer*)rotateGesture {
    if (rotateGesture.state == UIGestureRecognizerStateBegan ||
        rotateGesture.state == UIGestureRecognizerStateChanged ||
        rotateGesture.state == UIGestureRecognizerStateRecognized ||
        rotateGesture.state == UIGestureRecognizerStateEnded ||
        rotateGesture.state == UIGestureRecognizerStatePossible) {
        [self.transformView rotate:rotateGesture.rotation
                           atPoint:[rotateGesture locationInView:self.transformView]];
        rotateGesture.rotation = 0;
    }
}

#pragma mark - UIGestureRecognizerDelegate
// called when a gesture recognizer attempts to transition out of UIGestureRecognizerStatePossible. returning NO causes it to transition to UIGestureRecognizerStateFailed
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}

// called when the recognition of one of gestureRecognizer or otherGestureRecognizer would be blocked by the other
// return YES to allow both to recognize simultaneously. the default implementation returns NO (by default no two gestures can be recognized simultaneously)
//
// note: returning YES is guaranteed to allow simultaneous recognition. returning NO is not guaranteed to prevent simultaneous recognition, as the other gesture's delegate may return YES
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}


@end

//
//  TransformView.m
//  SingsTeaching
//
//  Created by dongyongzhu on 15/3/19.
//  Copyright (c) 2015年 kdanmobile. All rights reserved.
//

#import "TransformView.h"

@implementation TransformView

#pragma mark -
+ (CGPoint)locationPositionToSuperView:(CGPoint)point view:(UIView*)view  {
    return [view convertPoint:point toView:view.superview];
}

+ (CGPoint)superPositionToSelf:(CGPoint)point view:(UIView*)view  {
    return [view convertPoint:point fromView:view.superview];
}

+ (CGSize)archValueForPoint:(CGPoint)point view:(UIView*)view  {
    CGSize viewSize = view.bounds.size;
    
    return CGSizeMake(point.x/viewSize.width,
                      point.y/viewSize.height);
}

+ (CGPoint)centerWithArchValue:(CGSize)archValue view:(UIView*)view {
    CGSize viewSize = view.bounds.size;
    
    return CGPointMake(nearbyintf(viewSize.width * archValue.width),
                       nearbyintf(viewSize.height * archValue.height));
}

+ (CGPoint)centerPositinInSuperViewWithView:(UIView*)view {
    CGSize viewSize = view.bounds.size;
    
    return [TransformView locationPositionToSuperView:CGPointMake(viewSize.width / 2.0,
                                                                  viewSize.height / 2.0)
                                                 view:view];
}

#pragma mark - Transform
+ (void)scale:(CGSize)scale atPoint:(CGPoint)point forView:(UIView*)view {
    CGAffineTransform transform = view.transform;
    
    CGPoint oCenter = [TransformView locationPositionToSuperView:point view:view];
    CGSize archValue = [TransformView archValueForPoint:point view:view];
    
    transform = CGAffineTransformScale(transform, scale.width, scale.height);
    view.transform = transform;
    
    CGPoint nLocationCenter = [TransformView centerWithArchValue:archValue view:view];
    CGPoint nCenter = [TransformView locationPositionToSuperView:nLocationCenter view:view];
    
    
    CGAffineTransform tTransform = CGAffineTransformInvert(transform);
    tTransform = CGAffineTransformTranslate(tTransform,
                                            nearbyintf(nCenter.x - oCenter.x),
                                            nearbyintf(nCenter.y - oCenter.y));
    view.transform = CGAffineTransformInvert(tTransform);
}

+ (void)rotate:(float)angle atPoint:(CGPoint)point forView:(UIView*)view {
    CGAffineTransform transform = view.transform;
    
    CGPoint oCenter = [TransformView locationPositionToSuperView:point view:view];
    CGSize archValue = [TransformView archValueForPoint:point view:view];
    
    transform = CGAffineTransformRotate(transform, angle);
    view.transform = transform;
    
    CGPoint nLocationCenter = [TransformView centerWithArchValue:archValue view:view];
    CGPoint nCenter = [TransformView locationPositionToSuperView:nLocationCenter view:view];
    
    CGAffineTransform tTransform = CGAffineTransformInvert(transform);
    tTransform = CGAffineTransformTranslate(tTransform,
                                            nearbyintf(nCenter.x - oCenter.x),
                                            nearbyintf(nCenter.y - oCenter.y));
    view.transform = CGAffineTransformInvert(tTransform);
}

+ (void)move:(CGPoint)point forView:(UIView*)view {
    CGAffineTransform transform = view.transform;
    
    CGAffineTransform tTransform = CGAffineTransformInvert(transform);
    tTransform = CGAffineTransformTranslate(tTransform,
                                            -point.x,
                                            -point.y);
    view.transform = CGAffineTransformInvert(tTransform);
}

TransformCode();

@end

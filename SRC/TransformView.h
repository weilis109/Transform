//
//  TransformView.h
//  SingsTeaching
//
//  Created by dongyongzhu on 15/3/19.
//  Copyright (c) 2015年 kdanmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TransformProtocol <NSObject>
@required
- (void)scale:(CGSize)scale atPoint:(CGPoint)point;

- (void)rotate:(float)angle atPoint:(CGPoint)point;

- (void)move:(CGPoint)point;

@end

@interface TransformView : UIView<TransformProtocol>

+ (void)scale:(CGSize)scale atPoint:(CGPoint)point forView:(UIView*)view;

+ (void)rotate:(float)angle atPoint:(CGPoint)point forView:(UIView*)view;

+ (void)move:(CGPoint)point forView:(UIView*)view;

@end

#ifndef TRANSFORM_CODE
#define TRANSFORM_CODE
/** Transform 相关代码
 */
#define TransformCode() \
- (CGPoint)locationPositionToSuperView:(CGPoint)point {\
    return [self convertPoint:point toView:self.superview];\
}\
\
- (CGPoint)superPositionToSelf:(CGPoint)point {\
    return [self convertPoint:point fromView:self.superview];\
}\
\
- (CGSize)archValueForPoint:(CGPoint)point {\
    CGSize viewSize = self.bounds.size;\
    \
    return CGSizeMake(point.x/viewSize.width,\
                      point.y/viewSize.height);\
}\
\
- (CGPoint)centerWithArchValue:(CGSize)archValue {\
    CGSize viewSize = self.bounds.size;\
    \
    return CGPointMake(nearbyintf(viewSize.width * archValue.width),\
                       nearbyintf(viewSize.height * archValue.height));\
}\
\
- (CGPoint)centerPositinInSuperView {\
    CGSize viewSize = self.bounds.size;\
    \
    return [self locationPositionToSuperView:CGPointMake(viewSize.width / 2.0,\
                                                         viewSize.height / 2.0)];\
}\
\
- (void)scale:(CGSize)scale atPoint:(CGPoint)point {\
    CGAffineTransform transform = self.transform;\
    \
    CGPoint oCenter = [self locationPositionToSuperView:point];\
    CGSize archValue = [self archValueForPoint:point];\
    \
    transform = CGAffineTransformScale(transform, scale.width, scale.height);\
    self.transform = transform;\
    \
    CGPoint nLocationCenter = [self centerWithArchValue:archValue];\
    CGPoint nCenter = [self locationPositionToSuperView:nLocationCenter];\
    \
    \
    CGAffineTransform tTransform = CGAffineTransformInvert(transform);\
    tTransform = CGAffineTransformTranslate(tTransform,\
                                            nearbyintf(nCenter.x - oCenter.x),\
                                            nearbyintf(nCenter.y - oCenter.y));\
    self.transform = CGAffineTransformInvert(tTransform);\
}\
\
- (void)rotate:(float)angle atPoint:(CGPoint)point {\
    CGAffineTransform transform = self.transform;\
    \
    CGPoint oCenter = [self locationPositionToSuperView:point];\
    CGSize archValue = [self archValueForPoint:point];\
    \
    transform = CGAffineTransformRotate(transform, angle);\
    self.transform = transform;\
    \
    CGPoint nLocationCenter = [self centerWithArchValue:archValue];\
    CGPoint nCenter = [self locationPositionToSuperView:nLocationCenter];\
    \
    CGAffineTransform tTransform = CGAffineTransformInvert(transform);\
    tTransform = CGAffineTransformTranslate(tTransform,\
                                            nearbyintf(nCenter.x - oCenter.x),\
                                            nearbyintf(nCenter.y - oCenter.y));\
    self.transform = CGAffineTransformInvert(tTransform);\
}\
\
- (void)move:(CGPoint)point {\
    CGAffineTransform transform = self.transform;\
    \
    CGAffineTransform tTransform = CGAffineTransformInvert(transform);\
    tTransform = CGAffineTransformTranslate(tTransform,\
                                            -point.x,\
                                            -point.y);\
    self.transform = CGAffineTransformInvert(tTransform);\
}\

#endif
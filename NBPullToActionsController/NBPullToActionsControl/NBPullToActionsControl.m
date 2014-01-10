//
//  NBPullToActionsControl.m
//  Rakunew
//
//  Created by Xu Zhe on 2013/09/04.
//  Copyright (c) 2013年 RAKUNEW.com. All rights reserved.
//

#import <THObserversAndBinders/THObserversAndBinders.h>
#import "NBPullToActionsControl.h"

#define kShadowHeight               1.0f
#define kMidLinePadding             10.0f

@interface NBPullToActionsControl()

@end

@implementation NBPullToActionsControl {
    UIView *_midLineView;
    NBPullToActionCell *_leftActionCell;
    NBPullToActionCell *_rightActionCell;
    
    CGFloat _deltaOffset;
    UIView *_backgroundView;
}

- (instancetype)initWithLeftActionImage:(UIImage *)leftActionImage leftActionTitle:(NSString *)leftActionTitle rightActionImage:(UIImage *)rightActionImage rightActionTitle:(NSString *)rightActionTitle {
    self = [super init];
    if (self) {
        _type = NBPullToActionTypeUnknown;
        
        [self addSubview:({
            CGSize fullScreenSize = [UIScreen mainScreen].bounds.size;
            _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, self.frame.size.height - fullScreenSize.height, fullScreenSize.width, fullScreenSize.height)];
            _backgroundView.backgroundColor = [UIColor whiteColor];
            _backgroundView;
        })];
        
        if (kShadowHeight > 0.0f) {
            [self.layer addSublayer:({
                // Draw shadow
                CAGradientLayer *gradient = [CAGradientLayer layer];
                [gradient setFrame:CGRectMake(0, self.frame.size.height - kShadowHeight, self.frame.size.width, kShadowHeight)];
                [gradient setStartPoint:CGPointMake(0.0f, 1.0f)];
                [gradient setEndPoint:CGPointMake(0.0f, 0.0f)];
                [gradient setColors:@[(__bridge id)[[UIColor colorWithWhite:0 alpha:0.05] CGColor], (__bridge id)[[UIColor colorWithWhite:0 alpha:0.2] CGColor]]];
                gradient;
            })];
        }
        
        [self addSubview:({
            _midLineView = [[UIView alloc] initWithFrame:CGRectMake(floorf(CGRectGetMidX(self.frame)), kMidLinePadding, 1.0f, self.frame.size.height - kShadowHeight - kMidLinePadding * 2.0f)];
            _midLineView.backgroundColor = [UIColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:0.2f];
            _midLineView;
        })];
        
        [self addSubview:({
            _leftActionCell = [[NBPullToActionCell alloc] initWithImage:leftActionImage title:leftActionTitle];
            _leftActionCell.translatesAutoresizingMaskIntoConstraints = NO;
            _leftActionCell.frame = CGRectMake(0.0f, 0.0f, CGRectGetMinX(_midLineView.frame), self.frame.size.height - kShadowHeight);
            _leftActionCell;
        })];
        
        [self addSubview:({
            _rightActionCell = [[NBPullToActionCell alloc] initWithImage:rightActionImage title:rightActionTitle];
            _rightActionCell.translatesAutoresizingMaskIntoConstraints = NO;
            _rightActionCell.frame = CGRectMake(CGRectGetMaxX(_midLineView.frame), 0.0f, self.frame.size.width - CGRectGetMaxX(_midLineView.frame), self.frame.size.height - kShadowHeight);
            _rightActionCell;
        })];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [UIView animateWithDuration:kDefaultAnimationDuration animations:^{
        _leftActionCell.frame = CGRectMake(0.0f, 0.0f, CGRectGetMinX(_midLineView.frame), self.frame.size.height - kShadowHeight);
        _rightActionCell.frame = CGRectMake(CGRectGetMaxX(_midLineView.frame), 0.0f, self.frame.size.width - CGRectGetMaxX(_midLineView.frame), self.frame.size.height - kShadowHeight);
    }];
}

- (void)hideActivityIndicators {
    [_leftActionCell hideActivityIndicator];
    [_rightActionCell hideActivityIndicator];
}

- (void)endRefreshingWithCompletionBlock:(void (^)(void))block {
    [super endRefreshingWithCompletionBlock:^{
        _midLineView.transform = CGAffineTransformIdentity;
        [self hideActivityIndicators];
        
        if (block) block();
    }];
}

- (void)panGestureRecognized:(UIPanGestureRecognizer *)gestureRecognizer {
    if (_isRefreshing || ![gestureRecognizer isEqual:_panGestureRecognizer]) return;
    
    if (gestureRecognizer.state == UIGestureRecognizerStatePossible || gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        _deltaOffset = 0.0f;
        _type = NBPullToActionTypeUnknown;
    } else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat txWithOutDelta = [gestureRecognizer translationInView:_midLineView].x * 2.0f;
        CGFloat tx = txWithOutDelta - _deltaOffset;
        
        if (self.offset.y * 1.5f < self.frame.size.height) {
            _deltaOffset = txWithOutDelta;  // Make midLine more smooth
            [UIView animateWithDuration:kDefaultAnimationDuration animations:^{
                _midLineView.transform = CGAffineTransformIdentity;
            }];
            return;
        }
        
        CGFloat delta = tx;
        CGFloat midX = floorf(CGRectGetMidX(self.bounds));
        if (midX + tx < -_midLineView.frame.size.width) {
            tx = -(midX + _midLineView.frame.size.width);
            delta -= tx;
            if (_deltaOffset > 0.0f) {
                _deltaOffset += delta;
            } else if (delta < _deltaOffset) {
                _deltaOffset = delta;
            }
        } else if (midX + tx > self.frame.size.width) {
            tx = self.frame.size.width - midX;
            delta -= tx;
            if (_deltaOffset < 0.0f) {
                _deltaOffset += delta;
            } else if (delta > _deltaOffset) {
                _deltaOffset = delta;
            }
        }
        [UIView animateWithDuration:kDefaultAnimationDuration animations:^{
            _midLineView.transform = CGAffineTransformMakeTranslation(tx, 0.0f);
        }];
    } else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if ((self.style == NBPullToActionStyleTop && self.offset.y >= self.frame.size.height) ||
            (self.style == NBPullToActionStyleBottom && -self.offset.y >= self.frame.size.height)) {
            if (_leftActionCell.alpha >= 1.0f) {
                _type = NBPullToActionTypeLeft;
                [_leftActionCell showActivityIndicator];
                [UIView animateWithDuration:kDefaultAnimationDuration animations:^{
                    _midLineView.transform = CGAffineTransformMakeTranslation(floorf(CGRectGetMidX(self.bounds) + _midLineView.frame.size.width), 0.0f);
                }];
            } else if (_rightActionCell.alpha >= 1.0f) {
                _type = NBPullToActionTypeRight;
                [_rightActionCell showActivityIndicator];
                [UIView animateWithDuration:kDefaultAnimationDuration animations:^{
                    _midLineView.transform = CGAffineTransformMakeTranslation(-ceilf(CGRectGetMidX(self.bounds)) - _midLineView.frame.size.width, 0.0f);
                }];
            }
            [self sendActionsForControlEvents:UIControlEventValueChanged];
            if (_type == NBPullToActionTypeUnknown) {
                [UIView animateWithDuration:kDefaultAnimationDuration animations:^{
                    _midLineView.transform = CGAffineTransformIdentity;
                }];
            } else {
                [self beginRefreshing];
            }
        }
    }
}

@end

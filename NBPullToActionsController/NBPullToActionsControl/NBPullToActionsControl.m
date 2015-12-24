//
//  NBPullToActionsControl.m
//  Rakunew
//
//  Created by Xu Zhe on 2013/09/04.
//  Copyright (c) 2014 xuzhe.com. All rights reserved.
//

#import <THObserversAndBinders/THObserversAndBinders.h>
#import "NBPullToActionsControl.h"

#define kShadowHeight               1.0f
#define kMidLineWidth               1.0f
#define kMidLinePadding             10.0f
#define kMaxOffsetPercent           0.3f

@interface NBPullToActionControl (ProtectedProperties)

@property (nonatomic, assign) BOOL isRefreshing;
@property (nonatomic, assign) UIEdgeInsets originalEdgeInsets;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, assign) CGPoint offset;
@property (nonatomic, assign) CGFloat lastSpeed;

@end

@interface NBPullToActionsControl()

@end

@implementation NBPullToActionsControl {
    UIView *_midLineView;
    NBPullToActionCell *_midActionCell;
    NBPullToActionCell *_leftActionCell;
    NBPullToActionCell *_rightActionCell;
    
    BOOL _firstTimePullOut;
    CGFloat _deltaOffset;
    CGFloat _currentOffset;
    CGFloat _offsetPercent;
    UIView *_backgroundView;
}

- (UIView *)makeMidLine:(CGRect)rect {
    UIView * midLineView = [[UIView alloc] initWithFrame:rect];
    midLineView.backgroundColor = [UIColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:0.2f];
    return midLineView;
}

- (instancetype)initWithActionImages:(NSArray *)images actionTitles:(NSArray *)titles {
    self = [super init];
    if (self) {
        NSAssert((images && !titles) || (titles && !images) || (images && titles && [images count] == [titles count]), @"Images & Titles count must be same");
        NSAssert((!images && [titles count] > 1 && [titles count] <= 3) || ([images count] > 1 && [images count] <= 3), @"Only support 2 or 3 actions right now");
        
        _type = NBPullToActionTypeUnknown;
        _currentOffset = floorf(self.frame.size.width * 0.5f);
        
        [self addSubview:({
            CGSize fullScreenSize = [UIScreen mainScreen].bounds.size;
            _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, self.frame.size.height - fullScreenSize.height, self.frame.size.width, fullScreenSize.height)];
            _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
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
        
        NSString *leftActionTitle = nil, *midActionTitle = nil, *rightActionTitle = nil;
        UIImage *leftActionImage = nil, *midActionImage = nil, *rightActionImage = nil;
        
        if (titles) {
            leftActionTitle = [titles firstObject];
            rightActionTitle = [titles lastObject];
            if ([titles count] > 2) {
                midActionTitle = titles[1];
            }
        }
        if (images) {
            leftActionImage = [images firstObject];
            rightActionImage = [images lastObject];
            if ([images count] > 2) {
                midActionImage = images[1];
            }
        }
        
        CGFloat width = floorf(self.frame.size.width / 3.0f);
        [self addSubview:({
            _leftActionCell = [[NBPullToActionCell alloc] initWithImage:leftActionImage title:leftActionTitle];
            _leftActionCell.translatesAutoresizingMaskIntoConstraints = NO;
            _leftActionCell.frame = CGRectMake(0.0f, 0.0f, width, self.frame.size.height - kShadowHeight);
            _leftActionCell;
        })];
        
        [self addSubview:({
            _rightActionCell = [[NBPullToActionCell alloc] initWithImage:rightActionImage title:rightActionTitle];
            _rightActionCell.translatesAutoresizingMaskIntoConstraints = NO;
            _rightActionCell.frame = CGRectMake(self.frame.size.width - width, 0.0f, width, self.frame.size.height - kShadowHeight);
            _rightActionCell;
        })];
        
        if (!midActionImage && !midActionTitle) {
            [self addSubview:({
                _midLineView = [self makeMidLine:CGRectMake(0, kMidLinePadding, kMidLineWidth, self.frame.size.height - kShadowHeight - kMidLinePadding * 2.0f)];
                _midLineView;
            })];
        } else {
            [self addSubview:({
                _midActionCell = [[NBPullToActionCell alloc] initWithImage:midActionImage title:midActionTitle];
                _midActionCell.translatesAutoresizingMaskIntoConstraints = NO;
                _midActionCell.frame = CGRectMake(_currentOffset - floorf(width * 0.5f), 0.0f, width, self.frame.size.height - kShadowHeight);
                _midActionCell;
            })];
            
            [_midActionCell addSubview:({
                UIView *midLineView = [self makeMidLine:CGRectMake(0, kMidLinePadding, kMidLineWidth, self.frame.size.height - kShadowHeight - kMidLinePadding * 2.0f)];
                midLineView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
                midLineView;
            })];
            
            [_midActionCell addSubview:({
                UIView *midLineView = [self makeMidLine:CGRectMake(_midActionCell.bounds.size.width - kMidLineWidth, kMidLinePadding, kMidLineWidth, self.frame.size.height - kShadowHeight - kMidLinePadding * 2.0f)];
                midLineView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                midLineView;
            })];
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat maxWidth = self.frame.size.width;
    CGFloat modifiedOffsetPercent = kMaxOffsetPercent * _offsetPercent;
    
    [UIView animateWithDuration:self.isRefreshing ? kDefaultAnimationDuration : 0.0 animations:^{
        if (_midLineView) {
            _midLineView.transform = CGAffineTransformMakeTranslation(_currentOffset, 0.0f);
            _leftActionCell.frame = CGRectMake(0.0f, 0.0f, CGRectGetMaxX(_midLineView.frame), self.frame.size.height - kShadowHeight);
            _rightActionCell.frame = CGRectMake(CGRectGetMinX(_midLineView.frame), 0.0f, maxWidth - CGRectGetMinX(_midLineView.frame), self.frame.size.height - kShadowHeight);
        } else {
            CGFloat maxMidCellWidth = self.isRefreshing ? maxWidth : 200.0f;
            CGFloat width = MIN(maxWidth - ABS(_currentOffset * 2.0f - maxWidth), maxMidCellWidth) * (self.isRefreshing ? 1.0f : _offsetPercent);
            _midActionCell.frame = CGRectMake(_currentOffset - floorf(width * 0.5f), 0.0f, width, self.frame.size.height - kShadowHeight);
            [_midActionCell displayPercent:_midActionCell.frame.size.width / maxMidCellWidth * (1 - kMaxOffsetPercent) + modifiedOffsetPercent];
            
            _leftActionCell.frame = CGRectMake(0.0f, 0.0f, CGRectGetMinX(_midActionCell.frame), self.frame.size.height - kShadowHeight);
            _rightActionCell.frame = CGRectMake(CGRectGetMaxX(_midActionCell.frame), 0.0f, maxWidth - CGRectGetMaxX(_midActionCell.frame), self.frame.size.height - kShadowHeight);
        }
        
        [_leftActionCell displayPercent:_leftActionCell.frame.size.width / maxWidth * (1 - kMaxOffsetPercent) + modifiedOffsetPercent];
        [_rightActionCell displayPercent:_rightActionCell.frame.size.width / maxWidth * (1 - kMaxOffsetPercent) + modifiedOffsetPercent];
    }];
}

- (void)hideActivityIndicators {
    [_midActionCell hideActivityIndicator];
    [_leftActionCell hideActivityIndicator];
    [_rightActionCell hideActivityIndicator];
}

- (void)endRefreshingWithCompletionBlock:(void (^)(void))block {
    [super endRefreshingWithCompletionBlock:^{
        _currentOffset = floorf(self.frame.size.width * 0.5f);
        [self setNeedsLayout];
        
        [self hideActivityIndicators];
        
        if (block) block();
    }];
}

- (void)setOffset:(CGPoint)offset {
    [super setOffset:offset];
    
    _offsetPercent = MAX(MIN(offset.y / self.height, 1.0f), 0.0f);
    [self setNeedsLayout];
}

- (void)panGestureRecognized:(UIPanGestureRecognizer *)gestureRecognizer {
    if (!self.enabled || self.isRefreshing || ![gestureRecognizer isEqual:self.panGestureRecognizer]) return;
    CGFloat midX = floorf(self.frame.size.width * 0.5f);
    if (gestureRecognizer.state == UIGestureRecognizerStatePossible || gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        _deltaOffset = 0.0f;
        _currentOffset = midX;
        [self setNeedsLayout];
        _type = NBPullToActionTypeUnknown;
        _firstTimePullOut = YES;
    } else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        self.lastSpeed = [gestureRecognizer velocityInView:self].y;
        CGFloat txWithOutDelta = [gestureRecognizer translationInView:self].x * 2.0f;
        
        if (self.offset.y * 1.5f < self.frame.size.height && _firstTimePullOut) {
            _deltaOffset = txWithOutDelta;  // Make midLine more smooth
            _currentOffset = midX;
            [self setNeedsLayout];
            return;
        }
        
        _firstTimePullOut = NO;
        CGFloat tx = txWithOutDelta - _deltaOffset;
        CGFloat delta = tx;
        if (midX + tx < (_midLineView ? -kMidLineWidth : 0.0f)) {
            tx = - (midX + (_midLineView ? kMidLineWidth : 0.0f));
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
        _currentOffset = midX + tx;
        [self setNeedsLayout];
    } else if (gestureRecognizer.state == UIGestureRecognizerStateEnded && abs(self.lastSpeed) <= self.maxActionFireSpeed) {
        if ((self.style == NBPullToActionStyleTop && self.offset.y >= self.frame.size.height) ||
            (self.style == NBPullToActionStyleBottom && -self.offset.y >= self.frame.size.height)) {
            if (_leftActionCell.displayPercent > 0.7f) {
                _type = NBPullToActionTypeLeft;
                [_leftActionCell showActivityIndicator];
                _currentOffset = self.frame.size.width;
                [self setNeedsLayout];
            } else if (_rightActionCell.displayPercent > 0.7f) {
                _type = NBPullToActionTypeRight;
                [_rightActionCell showActivityIndicator];
                _currentOffset = 0.0f;
                [self setNeedsLayout];
            } else if (_midActionCell.displayPercent > 0.7f) {
                _type = NBPullToActionTypeMiddle;
                [_midActionCell showActivityIndicator];
                _currentOffset = midX;
                [self setNeedsLayout];
            }
            if (_type == NBPullToActionTypeUnknown) {
                _currentOffset = midX;
                [self setNeedsLayout];
            } else {
                [self beginRefreshing];
            }
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
    }
}

@end

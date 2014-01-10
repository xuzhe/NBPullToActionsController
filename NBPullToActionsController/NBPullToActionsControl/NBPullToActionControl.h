//
//  NBPullToActionControl.h
//  Rakunew
//
//  Created by zhe on 9/27/13.
//  Copyright (c) 2013 RAKUNEW.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kDefaultAnimationDuration   0.2



/*///////////////////////////////////////////////////////
Usage
    NBPullToActionControl *pullToActionControl = [NBPullToActionControl alloc] init];
    [scrollview addSubview:pullToActionControl];
*////////////////////////////////////////////////////////

typedef enum {
    NBPullToActionStyleTop = 0, // Top as default
    NBPullToActionStyleBottom,
} NBPullToActionStyle;

@interface NBPullToActionCell : UIView

@property (nonatomic, strong, readonly) UIView *arrowView;

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title;

// Activity Indicator
- (void)showActivityIndicator;
- (void)hideActivityIndicator;
- (void)rotateArrowView:(BOOL)toIdentity;
@end

@interface NBPullToActionControl : UIControl <UIGestureRecognizerDelegate> {
    
@protected
    BOOL _isRefreshing;
    UIEdgeInsets _originalEdgeInsets;
    UIPanGestureRecognizer *_panGestureRecognizer;
    CGPoint _offset;
}

// Readonly Property
@property (nonatomic, readonly, assign, getter = _isRefreshing) BOOL refreshing;
@property (nonatomic, readonly, assign) CGPoint offset;

// Readwrite Property
@property (nonatomic, assign) NBPullToActionStyle style;
@property (nonatomic, assign) CGFloat height;

// Public Methods
- (void)beginRefreshing;
- (void)endRefreshing;
- (void)endRefreshingWithCompletionBlock:(void (^)(void))block;

// Static Methods
+ (void)setDefaultFont:(UIFont *)font;

// Initialization Method
- (instancetype)initWithPullToActionCell:(NBPullToActionCell *)cell;
@end

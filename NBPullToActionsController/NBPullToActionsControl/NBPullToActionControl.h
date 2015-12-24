//
//  NBPullToActionControl.h
//  Rakunew
//
//  Created by Xu Zhe on 2013/09/04.
//  Copyright (c) 2014 xuzhe.com. All rights reserved.
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
@property (nonatomic, assign, readonly) CGFloat displayPercent;

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title;

// Activity Indicator
- (void)showActivityIndicator;
- (void)hideActivityIndicator;
- (void)rotateArrowView:(BOOL)toIdentity;
- (void)rotateArrowViewWithPercent:(CGFloat)percent;
- (void)displayPercent:(CGFloat)percent;
@end

@interface NBPullToActionControl : UIControl <UIGestureRecognizerDelegate> {
    
}

// Readonly Property
@property (nonatomic, readonly, assign, getter = _isRefreshing) BOOL refreshing;

// Readwrite Property
@property (nonatomic, assign) NBPullToActionStyle style;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat maxActionFireSpeed;

// Public Methods
- (void)beginRefreshing;
- (void)endRefreshing;
- (void)endRefreshingWithCompletionBlock:(void (^)(void))block;

// Static Methods
+ (void)setDefaultFont:(UIFont *)font;

// Initialization Method
- (instancetype)initWithPullToActionCell:(NBPullToActionCell *)cell;
@end

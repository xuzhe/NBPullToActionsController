//
//  NBPullToActionsControl.h
//  Rakunew
//
//  Created by Xu Zhe on 2013/09/04.
//  Copyright (c) 2014 xuzhe.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NBPullToActionControl.h"

typedef enum {
    NBPullToActionTypeUnknown = 0,
    NBPullToActionTypeLeft = 1,
    NBPullToActionTypeRight = 2,
} NBPullToActionType;

@interface NBPullToActionsControl : NBPullToActionControl
@property (nonatomic, readonly) NBPullToActionType type;

// Init Mehotd
- (instancetype)initWithLeftActionImage:(UIImage *)leftActionImage leftActionTitle:(NSString *)leftActionTitle rightActionImage:(UIImage *)rightActionImage rightActionTitle:(NSString *)rightActionTitle;

@end

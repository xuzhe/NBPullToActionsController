//
//  NBPullToActionsControl.h
//  NBPullToActionControl
//
//  Created by Xu Zhe on 2013/09/04.
//  Copyright (c) 2014 xuzhe.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NBPullToActionControl.h"

typedef enum {
    NBPullToActionTypeUnknown = -1,
    NBPullToActionTypeMiddle = 0,
    NBPullToActionTypeLeft = 1,
    NBPullToActionTypeRight = 2,
} NBPullToActionType;

@interface NBPullToActionsControl : NBPullToActionControl
@property (nonatomic, readonly) NBPullToActionType type;

// Init Mehotd
- (instancetype)initWithActionImages:(NSArray *)images actionTitles:(NSArray *)titles;

@end

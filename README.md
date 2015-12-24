NBPullToActionsController
=====

This control provides an easy to use UIControl to make "Pull to Refresh" and "Pull to Shuffle" possiable at the same time (Up to 3 actions max).

You just need to pull down and swipe to left or right to select which action you want.

![Screenshot](https://raw.githubusercontent.com/xuzhe/NBPullToActionsController/master/Screenshot/Screenshot1.png)

To Add this control, is as simple as add a view to UIScrolView. For example:
----------
```
    // Add the pull to action control
    NBPullToActionsControl *refreshControl = [[NBPullToActionsControl alloc] initWithLeftActionImage:refreshIcon leftActionTitle:refreshTitle rightActionImage:shuffleIcon rightActionTitle:shuffleTitle];
    [self.tableView addSubview:refreshControl];
    
    __weak __typeof(self) weakSelf = self;
    // Handle the UIControlEventValueChanged event. NBPullToActionsControl is inherits from UIControl
    [refreshControl handleControlEvents:UIControlEventValueChanged withBlock:^(id weakSender) {
        [weakSelf handleRefresh];
    }];
```
-----

Development Environment
=====
* Install CocoaPods
* `pod install`
* Open Project use: `NBPullToActionsController.xcworkspace`
* Add all TWO classes in NBPullToActionsControl folder to your project

NBPullToActionsController
=====

This control provides an easy to use view to make "Pull to Refresh" and "Pull to Shuffle" possiable at the same time.

You just need to pull down and swipe to left or right to select which action you want.

![Screenshot](https://raw2.github.com/xuzhe/NBPullToActionsController/master/Screenshot/Screenshot1.png)

To Add this control, is as simple as add a view to UIScrolView. For example:
----------
```
    // Add the pull to action control
    NBPullToActionsControl *refreshControl = [[NBPullToActionsControl alloc] initWithLeftActionImage:refreshIcon leftActionTitle:refreshTitle rightActionImage:shuffleIcon rightActionTitle:shuffleTitle];
    [self.tableView addSubview:refreshControl];
    
    __weak __typeof(self) weakSelf = self;
    // Handle the ValueChanged event
    [refreshControl handleControlEvents:UIControlEventValueChanged withBlock:^(id weakSender) {
        [weakSelf handleRefresh];
    }];
```

-----

Development Environment
=====
* Install CocoaPods
* `pod install`
* open Project use: `NBPullToActionsController.xcworkspace`

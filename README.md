NBPullToActionsController
=====

This control provides an easy to use UIControl to make multiple "pull to refresh" actions possiable at the same time (Up to 3 actions max).

Like Chrome for iOS, you just need to pull down and swipe to left or right to select which action you want.
(Please NOTE, This project was 2 years before Chrome for iOS implementing the similar idea)

![Screenshot](https://raw.githubusercontent.com/xuzhe/NBPullToActionsController/master/Screenshot/Screenshot1.png)

To Add this control is as simple as add a view to UIScrolView. For example:
----------
```
    // Add the pull to action control
    NBPullToActionsControl *refreshControl = [[NBPullToActionsControl alloc] initWithActionImages:imageArray actionTitles:titleArray];
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
Before run the DEMO project:

* Install CocoaPods
* `pod install`
* Open Project use: `NBPullToActionsController.xcworkspace`
* Add all TWO classes in NBPullToActionsControl folder to your project

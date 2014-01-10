//
//  NBTableViewController.m
//  NBPullToActionsController
//
//  Created by zhe on 1/6/14.
//  Copyright (c) 2014 xuzhe.com. All rights reserved.
//

#import "NBTableViewController.h"

#import "NBPullToActionsControl.h"
#import "UIControl+ALActionBlocks.h"
#import "NSArray+Shuffle.h"


#define kMaxDataCount        20
static NSString *CellIdentifier = @"Cell";

@interface NBTableViewController ()

@end

@implementation NBTableViewController {
    NSArray *_dataArray;
    NSMutableArray *_originalArray;
    
    NBPullToActionsControl *_refreshControl;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        _originalArray = [NSMutableArray arrayWithCapacity:kMaxDataCount];
        for (NSUInteger i = 0; i < kMaxDataCount; i++) {
            [_originalArray addObject:[NSString stringWithFormat:@"%lu", (unsigned long)i]];
        }
        _dataArray = _originalArray;
        
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [NBPullToActionsControl setDefaultFont:[UIFont systemFontOfSize:16.0f]];
    
    UIImage *refreshIcon = [UIImage imageNamed:@"refresh"];
    NSString *refreshTitle = NSLocalizedString(@"Refresh", nil);
    UIImage *shuffleIcon = [UIImage imageNamed:@"shuffle"];
    NSString *shuffleTitle = NSLocalizedString(@"Shuffle", nil);

    // Add the pull to action control
    _refreshControl = [[NBPullToActionsControl alloc] initWithLeftActionImage:refreshIcon leftActionTitle:refreshTitle rightActionImage:shuffleIcon rightActionTitle:shuffleTitle];
    [self.tableView addSubview:_refreshControl];
    
    __weak __typeof(self) weakSelf = self;
    // Handle the ValueChanged event
    [_refreshControl handleControlEvents:UIControlEventValueChanged withBlock:^(id weakSender) {
        [weakSelf handleRefresh];
    }];
    
    [self.tableView reloadData];
}

- (void)handleRefresh {
    NBPullToActionType type = ((NBPullToActionsControl *)_refreshControl).type;
    if (type == NBPullToActionTypeRight) {
        _dataArray = [_originalArray shuffle];
    } else if (type == NBPullToActionTypeLeft) {
        _dataArray = _originalArray;
    } else {
        // Unknown action. You should give users a nicer notification here.
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Unknown Action", nil) message:NSLocalizedString(@"Please move your finger to left or right while pulling down", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    }
    [self.tableView reloadData];
    [self handleFinishLoad];
}

- (void)handleFinishLoad {
    // Stop Activity Indicator
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t) (0.1 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        [_refreshControl endRefreshing];
    });
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = _dataArray[indexPath.row];
    
    return cell;
}

@end

//
//  QRCoreListTableViewController.m
//  QRCodeReader
//
//  Created by Shamim Hossain on 19/9/18.
//  Copyright © 2018 Shamim Hossain. All rights reserved.
//

#import "QRCoreListTableViewController.h"
#import "QRPersistanceManager.h"
#import "QRNIDCardTableViewCell.h"
#import "QRNIDCard.h"

@interface QRCoreListTableViewController ()

@property(nonatomic, strong) NSMutableArray *NIDCards;

@end

@implementation QRCoreListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

	self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
	UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
	[refreshControl addTarget:self action:@selector(loadData:) forControlEvents:UIControlEventValueChanged];

	self.tableView.refreshControl = refreshControl;

	self.NIDCards = [NSMutableArray arrayWithCapacity:0];

	[self loadData:nil];
}

- (void)refreshControlValueChanged:(UIRefreshControl *)control
{
	[control endRefreshing];
//	[self loadData];
}

- (void)loadData:(UIRefreshControl *)control
{
	__weak __typeof(self) weakSelf = self;

	[[QRPersistanceManager sharedInstance] fetchNIDCardsWithOffset:self.NIDCards.count limit:100 completionHandler:^(NSArray<QRNIDCard *> *output, NSError *error) {
		[control endRefreshing];

		if (error == nil && output.count > 0) {
			[weakSelf.NIDCards addObjectsFromArray:output];
			[weakSelf.tableView reloadData];
		} else if(weakSelf.NIDCards.count == 0) {
			[weakSelf showNoDataFoundLabel];
		}
	}];
}

- (void)showNoDataFoundLabel
{
	UILabel *label = [[UILabel alloc] initWithFrame:self.tableView.bounds];
	label.numberOfLines = 0;
	label.text = @"No data found. Scanned NID will be listed here";
	label.textAlignment = NSTextAlignmentCenter;
	label.textColor = [UIColor grayColor];
	label.translatesAutoresizingMaskIntoConstraints = NO;
	self.tableView.backgroundView = label;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.NIDCards.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	QRNIDCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QRNIDCardTableViewCell class]) forIndexPath:indexPath];

	QRNIDCard *card = [self.NIDCards objectAtIndex:indexPath.row];
	[cell setupCellInformation:card];

    return cell;
}

@end

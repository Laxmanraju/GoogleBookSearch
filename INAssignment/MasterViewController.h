//
//  MasterViewController.h
//  INAssignment
//
//  Created by Laxman Penmetsa on 6/29/15.
//  Copyright (c) 2015 Laxman Penmetsa. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController<UISearchBarDelegate, UISearchDisplayDelegate, UITextFieldDelegate>

@property (strong, nonatomic) DetailViewController *detailViewController;


@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;


#pragma mark searchBar actions
- (IBAction)searchActionCall:(UIButton *)sender;


@end


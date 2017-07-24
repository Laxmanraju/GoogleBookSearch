//
//  DetailViewController.h
//  INAssignment
//
//  Created by Laxman Penmetsa on 6/29/15.
//  Copyright (c) 2015 Laxman Penmetsa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property(strong, nonatomic) id descriptionItem;
@property(strong, nonatomic) id ratingItem;
@property(strong, nonatomic) id ratingProgressItem;
@property(strong, nonatomic) id authorItem;
@property(strong, nonatomic) id pagesItem;
@property(strong, nonatomic) id publishedDateItem;

@property(strong, nonatomic)UIImage *thumbImage;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (weak, nonatomic) IBOutlet UITextView *detailText;
@property (weak, nonatomic) IBOutlet UIImageView *thumbNailView;
@property (weak, nonatomic) IBOutlet UIProgressView *ratingBar;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *pagesLabel;
@property (weak, nonatomic) IBOutlet UILabel *publishDateLabel;


@end


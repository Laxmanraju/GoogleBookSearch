//
//  DetailViewController.m
//  INAssignment
//
//  Created by Laxman Penmetsa on 6/29/15.
//  Copyright (c) 2015 Laxman Penmetsa. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem  {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        // Update the view.
        [self configureView];
    }
}





- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
    if (self.detailText) {
        self.detailText.text = [self.descriptionItem description];
    }
    if (_ratingLabel) {
        _ratingLabel.text =[self.ratingItem description];
    }
    if (self.thumbNailView) {
        self.thumbNailView.image = [self thumbImage];
    }
    self.ratingBar.progress =2*[[self.ratingProgressItem description] floatValue];
    self.authorLabel.text = [self.authorItem description];
    self.pagesLabel.text = [self.pagesItem description];
    self.publishDateLabel.text = [self.publishedDateItem description];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

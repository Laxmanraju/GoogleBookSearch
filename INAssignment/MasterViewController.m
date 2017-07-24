//
//  MasterViewController.m
//  INAssignment
//
//  Created by Laxman Penmetsa on 6/29/15.
//  Copyright (c) 2015 Laxman Penmetsa. All rights reserved.
//
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1
#define googleBookSearchURL @"https://www.googleapis.com/books/v1/volumes?q=apple&maxResults=20"

#import "MasterViewController.h"
#import "DetailViewController.h"

@interface MasterViewController ()

@property(retain) NSMutableArray *objects;
@end

@implementation MasterViewController

@synthesize searchTextField = _searchTextField;
@synthesize searchButton = _searchButton;

- (void)awakeFromNib {
    [super awakeFromNib];
    self.clearsSelectionOnViewWillAppear = NO;
    self.preferredContentSize = CGSizeMake(320.0, 600.0);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //asynchronus execution of the bloack
    //calling the url and adding data to dataStructures
    dispatch_sync(kBgQueue, ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString: googleBookSearchURL]];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });

    [self.tableView reloadData];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    // alloc called when creating the file 
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
}

//create the dictionary with returnd json respponse
// creatig objects array with items key from jsonResponse which is the only required
- (void)fetchedData:(NSData *)responseData
{
    NSError *error;
    
    if (responseData) {
        NSDictionary *jsonDataDict = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        
        self.objects = [NSMutableArray arrayWithArray:[jsonDataDict objectForKey:@"items"]];
    }
}

// did not focus on this
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender {
    if (!self.objects) {
        self.objects = [[NSMutableArray alloc] init] ;
    }
    [self.objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Segues

// just added description to detailes view.
//added image and description. Can add ratings title and many more
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
       // NSDate *object = self.objects[indexPath.row];
        
        NSDictionary *itemDict = [NSDictionary dictionaryWithDictionary:[self.objects objectAtIndex:indexPath.row]];
        NSDictionary *volumeInfoDict = [itemDict objectForKey:@"volumeInfo"];
        NSString *detailString = [NSString stringWithFormat:@"%@-%@",[volumeInfoDict objectForKey:@"title"],[volumeInfoDict objectForKey:@"subtitle"]];
        NSString *descriptionString  = [volumeInfoDict objectForKey:@"description"];
        
        NSDictionary *imageDict = [volumeInfoDict objectForKey:@"imageLinks"];
        NSString *imgUrlString = [imageDict objectForKey:@"smallThumbnail"];
        
        NSURL *imageUrl = [NSURL URLWithString:imgUrlString];
        NSData *imgData    = [NSData   dataWithContentsOfURL:imageUrl];
        UIImage *thumbImg = [UIImage imageWithData:imgData] ;
        NSMutableArray *authorArray = [volumeInfoDict objectForKey:@"authors"];

        
        
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
         controller.thumbImage = thumbImg;
        [controller setDetailItem:detailString];
        [controller setDescriptionItem:descriptionString];
        [controller setRatingItem:[NSString stringWithFormat:@"Ratings(%@) %@/5",[volumeInfoDict objectForKey:@"ratingsCount"], [volumeInfoDict objectForKey:@"averageRating"]]];
        [controller setRatingProgressItem:[NSString stringWithFormat:@"0.%@",[volumeInfoDict objectForKey:@"averageRating"]]];
        if (authorArray) {
            [controller setAuthorItem:[NSString stringWithFormat:@"Author : %@",[authorArray objectAtIndex:0]]];
        }
        [controller setPagesItem:[NSString stringWithFormat:@"Page Count : %@",[volumeInfoDict objectForKey:@"pageCount"]]];
        [controller setPublishedDateItem:[NSString stringWithFormat:@"Published Date : %@",[volumeInfoDict objectForKey:@"publishedDate"]]];
        
        
        
       
        
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
        
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
  
}

// parsed the json data and added to the cells
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSDictionary *itemDict = [NSDictionary dictionaryWithDictionary:[self.objects objectAtIndex:indexPath.row]];
    NSDictionary *volumeInfoDict = [itemDict objectForKey:@"volumeInfo"];
    NSDictionary *imageDict = [volumeInfoDict objectForKey:@"imageLinks"];
    NSString *imgUrlString = [imageDict objectForKey:@"smallThumbnail"];
    //NSDate *object = self.objects[indexPath.row];
   
    NSURL *imageUrl = [NSURL URLWithString:imgUrlString];
    NSData *imgData    = [NSData   dataWithContentsOfURL:imageUrl];
    UIImage *thumbImg = [UIImage imageWithData:imgData];
    
    cell.imageView.frame = CGRectMake(0, 0, 80, 70);
    cell.imageView.image = thumbImg;
    cell.textLabel.text = [volumeInfoDict objectForKey:@"title"];//[object description];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

#pragma mark -google store search
-(void)filterBookStoreForSearchText:(NSString *)searchText
{
    dispatch_sync(kBgQueue, ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString: [NSString stringWithFormat:@"https://www.googleapis.com/books/v1/volumes?q=%@&maxResults=20",searchText]]];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
    
}


- (IBAction)searchActionCall:(UIButton *)sender {
    
    [self filterBookStoreForSearchText:_searchTextField.text];
    [self.tableView reloadData];
    [self.view endEditing:YES];
}


@end

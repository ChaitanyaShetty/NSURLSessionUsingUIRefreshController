//
//  ViewController.m
//  NSUrlSession2
//
//  Created by chaitanya on 05/10/16.
//  Copyright © 2016 chaitanya. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) NSMutableArray *artistDetails;
@property (strong, nonatomic) NSMutableArray *bundleIdDetails;
@property (strong, nonatomic) NSMutableArray *imageDetails;

@property (strong, nonatomic) NSArray *artistName;
@property (strong, nonatomic) NSArray *results;
@property (strong, nonatomic) NSArray *bundleId;
@property (strong, nonatomic) NSArray *image;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.artistDetails = [[NSMutableArray alloc]init];
    self.bundleIdDetails = [[NSMutableArray alloc]init];
    self.imageDetails = [[NSMutableArray alloc]init];
    
    
    [self session1];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];

    // Do any additional setup after loading the view, typically from a nib.
}

-(void)refresh: (UIRefreshControl *)refreshControl {
    [refreshControl endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)session1 {
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:@"https://itunes.apple.com/search?term=apple&media=software"] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"%@", json);
        
        //        self.json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        //                NSLog(@"%@", _json);
        //
        //
        self.results = [json valueForKey:@"results"];
        self.artistName = [self.results valueForKey:@"artistName"];
        self.bundleId = [self.results valueForKey:@"bundleId"];
        self.image = [self.results valueForKey:@"ipadScreenshotUrls"];
        NSLog(@"Artist name are %@", _artistName);
        [self.artistDetails addObjectsFromArray:self.artistName];
        [self.bundleIdDetails addObjectsFromArray:self.bundleId];
        //[self.images addObjectsFromArray:self.image];
        NSLog(@"Artist Details are %@", _artistDetails);
        for (int i=0; i<_image.count; i++) {
            // self.image = [[self.results objectAtIndex:i]objectForKey:@"ipadScreenshotUrls"];
            
            [self.imageDetails addObjectsFromArray:self.image[i]];
            i++;
            NSLog(@"Image %@",_imageDetails);
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            
        });
        //[self.tableView reloadData];
    }];
    
    [dataTask resume];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.artistDetails.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [self.artistDetails objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [self.bundleIdDetails objectAtIndex:indexPath.row];
    //cell.imageView.image = [self.imageDetails objectAtIndex:indexPath.row];
    //     self.json = [self.image objectAtIndex:indexPath.row];
    ////
    NSURL *url = [NSURL URLWithString:[self.imageDetails objectAtIndex:indexPath.row]];
    NSLog(@"%@",url);
    NSData *imgData = [NSData dataWithContentsOfURL:url];
    //    UIImage *img = [UIImage imageWithData:imgData];
    //    cell.imgOutlet.image = img;
    [cell.imageView setImage:[UIImage imageWithData:imgData]];
    
    //[cell.imgOutlet setBackgroundColor:[UIColor blueColor]];
    //cell.imgOutlet.image=[UIImage imageWithData:imgData];
    // [cell.imgOutlet setBackgroundColor:[UIColor blueColor]];
    
    //    NSData *imgData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:[self.image objectAtIndex:indexPath.row]]];
    //    UIImage *img = [UIImage imageWithData:imgData];
    //    cell.imageView.image = img;
    //
    
    
    return cell;
}



        
    

                                      




@end

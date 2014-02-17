//
//  HistoryViewController.m
//  Facedoor
//
//  Created by Twina, Tamir [ICG-IT] on 2/17/14.
//  Copyright (c) 2014 Twina, Tamir [ICG-IT]. All rights reserved.
//

#import "HistoryViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "HistoryLogModel.h"
#import "LogEntry.h"
#import "LogEntryCell.h"
#import "NSDate+TimeAgo.h"
#import "FacedoorModel.h"

@interface HistoryViewController ()

@property (nonatomic, weak) HistoryLogModel *model;

@end

@implementation HistoryViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.model getHistoryLog] count];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1. Get the cell
    static NSString *CellIdentifier = @"LogCell";
    LogEntryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[LogEntryCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    //3. Setup the cell
    LogEntry *logEntry = [[self.model getHistoryLog] objectAtIndex:indexPath.row];
    cell.message.text = logEntry.message;
    cell.timeAgo.text = [logEntry.timestamp timeAgo];
    cell.eventTitle.text = logEntry.eventId;
    [cell.eventImg displayImageFromURL:[[FacedoorModel sharedInstance] imageUrlForPersonWithEventId:logEntry.eventId]
                     completionHandler:nil];
    //TODO Add place holder image 
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"details for row number %d",indexPath.row];
    
    return cell;
}


//This function is where all the magic happens
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    //1. Setup the CATransform3D structure
    CATransform3D rotation;
    rotation = CATransform3DMakeRotation( (90.0*M_PI)/180, 0.0, 0.7, 0.4);
    rotation.m34 = 1.0/ -600;
    
    
    //2. Define the initial state (Before the animation)
    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
    cell.layer.shadowOffset = CGSizeMake(10, 10);
    cell.alpha = 0;
    
    cell.layer.transform = rotation;
    cell.layer.anchorPoint = CGPointMake(0, 0.5);
    
    //!!!FIX for issue #1 Cell position wrong------------
    if(cell.layer.position.x != 0){
        cell.layer.position = CGPointMake(0, cell.layer.position.y);
    }
    
    //4. Define the final state (After the animation) and commit the animation
    [UIView beginAnimations:@"rotation" context:NULL];
    [UIView setAnimationDuration:0.8];
    cell.layer.transform = CATransform3DIdentity;
    cell.alpha = 1;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    [UIView commitAnimations];
}


//Helper function to get a random float
- (float)randomFloatBetween:(float)smallNumber and:(float)bigNumber {
    float diff = bigNumber - smallNumber;
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + smallNumber;
}

- (UIColor*)colorFromIndex:(int)index{
    UIColor *color;
    
    //Purple
    if(index % 3 == 0){
        color = [UIColor colorWithRed:0.93 green:0.01 blue:0.55 alpha:1.0];
        //Blue
    }else if(index % 3 == 1){
        color = [UIColor colorWithRed:0.00 green:0.68 blue:0.94 alpha:1.0];
        //Blk
    }else if(index % 3 == 2){
        color = [UIColor blackColor];
    }
    else if(index % 3 == 3){
        color = [UIColor colorWithRed:0.00 green:1.0 blue:0.00 alpha:1.0];
    }
    
    
    return color;
    
}

- (HistoryLogModel*)model
{
    return [HistoryLogModel sharedInstance];
}

@end

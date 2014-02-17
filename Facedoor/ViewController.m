//
//  ViewController.m
//  Facedoor
//
//  Created by Twina, Tamir [ICG-IT] on 2/16/14.
//  Copyright (c) 2014 Twina, Tamir [ICG-IT]. All rights reserved.
//

#import "ViewController.h"
#import "FlatUIKit.h"
#import "MNMRemoteImageView.h"
#import "FacedoorModel.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "ALAlertBanner.h"
#import "HistoryLogModel.h"

#define ARC4RANDOM_MAX      0x100000000


@interface ViewController ()

@property (weak, nonatomic) IBOutlet FUIButton *yesButton;
@property (weak, nonatomic) IBOutlet FUIButton *noButton;
@property (weak, nonatomic) IBOutlet FUIButton *showLog;
@property (weak, nonatomic) IBOutlet FUIButton *simulatePush;
@property (weak, nonatomic) IBOutlet MNMRemoteImageView *personImgView;

@property (strong, nonatomic) FacedoorModel *model;
@property (strong, nonatomic) HistoryLogModel *historyLog;

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [self commonInit];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit
{
    self.model = [FacedoorModel sharedInstance];
    self.historyLog = [HistoryLogModel sharedInstance];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pushUpdateArrived)
                                                 name:kPushInfoArrived
                                               object:nil];
}

- (void)viewDidLoad
{
    [self setupAppearance];
    [self.historyLog addLogEntryWithWithEventId:@"testEvent1"
                                        message:@"Tamir Twina arrived at your door"
                                      timestamp:@"1391051169"];

    [self.historyLog addLogEntryWithWithEventId:@"testEvent2"
                                        message:@"Someone's at your door"
                                      timestamp:@"1390551000"];
    
    [self.historyLog addLogEntryWithWithEventId:@"testEvent3"
                                        message:@"Someone's at your door"
                                      timestamp:@"1390350123"];
    
    DDLogVerbose(@"%@",[self.historyLog getHistoryLog]);

}

- (void)setupAppearance
{
    //No button
    self.noButton.buttonColor = [UIColor colorFromHexCode:@"f66051"];
    self.noButton.shadowColor = [UIColor colorFromHexCode:@"6e261f"];
    self.noButton.shadowHeight = 3.0f;
    self.noButton.cornerRadius = 6.0f;
    [self.noButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [self.noButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    
    //Yes button
    self.yesButton.buttonColor = [UIColor turquoiseColor];
    self.yesButton.shadowColor = [UIColor greenSeaColor];
    self.yesButton.shadowHeight = 3.0f;
    self.yesButton.cornerRadius = 6.0f;
    [self.yesButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [self.yesButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];

    //show log button
    self.showLog.buttonColor = [UIColor colorFromHexCode:@"2aaadd"];
    self.showLog.shadowColor = [UIColor colorFromHexCode:@"7bb1ca"];
    self.showLog.shadowHeight = 3.0f;
    self.showLog.cornerRadius = 6.0f;
    [self.showLog setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [self.showLog setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    
    // simulate push button
    self.simulatePush.buttonColor = [UIColor colorFromHexCode:@"bdc3c7"];
    self.simulatePush.shadowColor = [UIColor colorFromHexCode:@"888888"];
    self.simulatePush.shadowHeight = 3.0f;
    self.simulatePush.cornerRadius = 6.0f;
    [self.simulatePush setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [self.simulatePush setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];

}

- (void)viewWillAppear:(BOOL)animated
{
    DDLogVerbose(@"should load remote image");
    
    NSString *eventId = [self.model eventId];
    [self loadImageWithEventId:eventId];
}

- (void)pushUpdateArrived
{
    NSString *eventId = [self.model eventId];
    [self loadImageWithEventId:eventId];
    DDLogVerbose(@"should load remote image %@",eventId);
}

- (void)loadImageWithEventId:(NSString*)eventId
{
    NSString *imgUrl = [self.model imageUrlForPerson];
    [self.personImgView displayImageFromURL:imgUrl
                         completionHandler:^(NSError *error)
    {
         if (error) {
             
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                             message:[error localizedDescription]
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
             [alert show];
         }
     }];
}

- (IBAction)simulatePushMessage
{
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif == nil)
    {
        DDLogVerbose(@"Error: Failed to create local push message");
        return;
    }
    
    double delayInSecs = 2 + ((double)arc4random() / ARC4RANDOM_MAX) * 5;
    
    localNotif.fireDate = [NSDate dateWithTimeInterval:delayInSecs sinceDate:[NSDate date]];
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    localNotif.alertBody = @"There's someone at your door";
    localNotif.alertAction = @"OK";
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    localNotif.applicationIconBadgeNumber = 1;
    localNotif.userInfo = @{
                            @"eventId": @"1234",
                            @"timestamp": @(1392553353)
                            };
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
}


- (IBAction)approveRequest
{
    [self.model respondToDoorAccessRequestApproved:YES
                                       compilition:^
     (NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
     {
         ALAlertBanner *banner = [ALAlertBanner alertBannerForView:self.view
                                                             style:ALAlertBannerStyleSuccess
                                                          position:ALAlertBannerPositionTop
                                                             title:@"Door was opened"
                                                          subtitle:@"You've opened the door for X"
                                                       tappedBlock:^(ALAlertBanner *alertBanner)
                                  {
                                        NSLog(@"tapped!");
                                      [alertBanner hide];
                                  }];
         [banner show];
     }
                                           failure:^
     (NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
     {
           DDLogError(@"fialed send approve request");
         ALAlertBanner *banner = [ALAlertBanner alertBannerForView:self.view
                                                             style:ALAlertBannerStyleFailure
                                                          position:ALAlertBannerPositionTop
                                                             title:@"Door was opened"
                                                          subtitle:@"You've opened the door for X"
                                                       tappedBlock:^(ALAlertBanner *alertBanner)
                                  {
                                      NSLog(@"tapped!");
                                      [alertBanner hide];
                                  }];
         [banner show];
   }];
}

- (IBAction)denyRequest
{
    
    [self.model testApiForStatus];
    return;
    [self.model respondToDoorAccessRequestApproved:YES
                                       compilition:^
     (NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
     {
         ALAlertBanner *banner = [ALAlertBanner alertBannerForView:self.view
                                                             style:ALAlertBannerStyleSuccess
                                                          position:ALAlertBannerPositionTop
                                                             title:@"Door was opened"
                                                          subtitle:@"You've opened the door for X"
                                                       tappedBlock:^(ALAlertBanner *alertBanner)
                                  {
                                      NSLog(@"tapped!");
                                      [alertBanner hide];
                                  }];
         [banner show];
     }
                                           failure:^
     (NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
     {
         DDLogError(@"fialed send approve request");
         ALAlertBanner *banner = [ALAlertBanner alertBannerForView:self.view
                                                             style:ALAlertBannerStyleFailure
                                                          position:ALAlertBannerPositionTop
                                                             title:@"Door was opened"
                                                          subtitle:@"You've opened the door for X"
                                                       tappedBlock:^(ALAlertBanner *alertBanner)
                                  {
                                      NSLog(@"tapped!");
                                      [alertBanner hide];
                                  }];
         [banner show];
     }];
}


@end

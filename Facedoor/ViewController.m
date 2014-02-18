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
#import "IIViewDeckController.h"
#import "TWDraggableView.h"

#define ARC4RANDOM_MAX      0x100000000


@interface ViewController () <DraggableViewDelegate>

@property (weak, nonatomic) IBOutlet FUIButton *yesButton;
@property (weak, nonatomic) IBOutlet FUIButton *noButton;
@property (weak, nonatomic) IBOutlet FUIButton *showLog;
@property (weak, nonatomic) IBOutlet FUIButton *simulatePush;
@property (strong, nonatomic) IBOutlet TWDraggableView *personImgView;
@property (weak, nonatomic) IBOutlet UIView *thanksView;

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
        
    DDLogVerbose(@"%@",[self.historyLog getHistoryLog]);
    self.personImgView.delegate = self;
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
    
    [self.thanksView setAlpha:0.f];
}

- (void)viewWillAppear:(BOOL)animated
{
    DDLogVerbose(@"should load remote image");
    
    NSString *eventId = [self.model eventId];
    [self loadImageWithEventId:eventId];
}

- (void)pushUpdateArrived
{
    if(!self.model.isAuthorized)
    {
        [self handleUnAuthorizedEvent];
    }
    else
    {
        [self handleAuthorizedEvent];
    }
    
    [self.historyLog addLogEntryWithWithEventId:[self.model eventId]
                                        message:[self.model message]
                                      timestamp:[NSString stringWithFormat:@"%f",[[self.model eventTimestamp] timeIntervalSince1970]]];

}

- (void)handleAuthorizedEvent
{
    NSString *eventId = [self.model eventId];
    [self loadImageWithEventId:eventId];
    
    ALAlertBanner *banner = [ALAlertBanner alertBannerForView:self.view
                                                        style:ALAlertBannerStyleSuccess
                                                     position:ALAlertBannerPositionTop
                                                        title:self.model.message
                                                     subtitle:@"Door was opened"
                                                  tappedBlock:^(ALAlertBanner *alertBanner)
                             {
                                 [alertBanner hide];
                             }];
    [banner show];
}

- (void)handleUnAuthorizedEvent
{
    NSString *eventId = [self.model eventId];
    [self loadImageWithEventId:eventId];
    DDLogVerbose(@"should load remote image %@",eventId);
}

- (void)loadImageWithEventId:(NSString*)eventId
{
    if(!self.personImgView)
    {
        self.personImgView = [[TWDraggableView alloc] initWithFrame:(CGRect){40,47,240,233}];
        self.personImgView.delegate = self;
        [UIView animateWithDuration:0.3 animations:^{
            [self.thanksView setAlpha:0];
            [self.view addSubview:self.personImgView];
        }];
    }
    
    NSString *imgUrl = [self.model imageUrlForPersonWithEventId:eventId];
    [self.personImgView loadImageWithUrl:imgUrl];
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
     (AFHTTPRequestOperation *operation, id responseObject)
     {
         ALAlertBanner *banner = [ALAlertBanner alertBannerForView:self.view
                                                             style:ALAlertBannerStyleSuccess
                                                          position:ALAlertBannerPositionTop
                                                             title:@"Door was opened"
                                                          subtitle:nil
                                                       tappedBlock:^(ALAlertBanner *alertBanner)
                                  {
                                        NSLog(@"tapped!");
                                      [alertBanner hide];
                                  }];
         [banner show];
         
        [UIView animateWithDuration:0.3 animations:^{
            [self.thanksView setAlpha:1];
        }];
         self.personImgView = nil;
         [[FacedoorModel sharedInstance] resetModel];
         
     }
                                           failure:^
     (AFHTTPRequestOperation *operation, NSError *error)
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
         [UIView animateWithDuration:0.3 animations:^{
             [self.thanksView setAlpha:1];
         }];
         self.personImgView = nil;
         [[FacedoorModel sharedInstance] resetModel];
         
   }];
}

- (IBAction)denyRequest
{    
    [self.model respondToDoorAccessRequestApproved:NO
                                       compilition:^
     (AFHTTPRequestOperation *operation, id responseObject)
     {
         ALAlertBanner *banner = [ALAlertBanner alertBannerForView:self.view
                                                             style:ALAlertBannerStyleNotify
                                                          position:ALAlertBannerPositionTop
                                                             title:@"Door remains closed"
                                                          subtitle:nil
                                                       tappedBlock:^(ALAlertBanner *alertBanner)
                                  {
                                      NSLog(@"tapped!");
                                      [alertBanner hide];
                                  }];
         [banner show];
         [UIView animateWithDuration:0.3 animations:^{
             [self.thanksView setAlpha:1];
         }];
         self.personImgView = nil;
         [[FacedoorModel sharedInstance] resetModel];
         

     }
                                           failure:^
     (AFHTTPRequestOperation *operation, NSError *error)
     {
         DDLogError(@"fialed send approve request");
         ALAlertBanner *banner = [ALAlertBanner alertBannerForView:self.view
                                                             style:ALAlertBannerStyleNotify
                                                          position:ALAlertBannerPositionTop
                                                             title:@"Door remains closed"
                                                          subtitle:nil
                                                       tappedBlock:^(ALAlertBanner *alertBanner)
                                  {
                                      NSLog(@"tapped!");
                                      [alertBanner hide];
                                  }];
         [banner show];
         [UIView animateWithDuration:0.3 animations:^{
             [self.thanksView setAlpha:1];
         }];
         self.personImgView = nil;
         [[FacedoorModel sharedInstance] resetModel];
         
     }];
}


- (IBAction)toggleLogPane
{
    [self.viewDeckController toggleRightViewAnimated:YES];
}

- (void)notifyResult:(BOOL)yesOrNo
{
    
    if(yesOrNo == YES)
    {
        [self approveRequest];
    }
    else
    {
        [self denyRequest];
    }
    
    
}

@end

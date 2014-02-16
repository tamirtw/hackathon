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

#define kBaseUrl @"http://www.quizz.biz/uploads/quizz/152064/3_8yQNI.jpg"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet FUIButton *yesButton;
@property (weak, nonatomic) IBOutlet FUIButton *noButton;
@property (weak, nonatomic) IBOutlet FUIButton *showLog;
@property (weak, nonatomic) IBOutlet FUIButton *simulatePush;
@property (weak, nonatomic) IBOutlet MNMRemoteImageView *personImgView;

@end

@implementation ViewController


- (void)viewDidLoad
{
    [self setupAppearance];
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


- (IBAction)simulatePushMessage
{
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif == nil)
    {
        NSLog(@"Error: Failed to create local push message");
        return;
    }
    
    localNotif.fireDate = [NSDate dateWithTimeInterval:2.0 sinceDate:[NSDate date]];
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    localNotif.alertBody = @"Just some text";
    localNotif.alertAction = @"OK";
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    localNotif.applicationIconBadgeNumber = 1;
    localNotif.userInfo = @{
                            @"eventId": @"1234",
                            @"timestamp": @(1392553353)
                        };
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"should load remote image");
    
    //TODO get eventID from push message
    [self loadImageWithEventId:nil];
}

- (void)loadImageWithEventId:(NSString*)eventId
{
    [self.personImgView displayImageFromURL:[self urlForImageWithEventId:eventId]
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

- (NSString*)urlForImageWithEventId:(NSString*)eventId
{
    return [NSString stringWithFormat:@"%@%@",kBaseUrl,eventId ? eventId : @""];
     
}

@end

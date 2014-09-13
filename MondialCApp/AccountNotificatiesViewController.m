//
//  AccountNotificatiesViewController.m
//  MondialCApp
//
//  Created by Arthur Hemmer on 7/24/13.
//
//

#import "AccountNotificatiesViewController.h"
#import "PersoonlijkRooster.h"

@interface AccountNotificatiesViewController ()
@property (nonatomic, weak) IBOutlet UISwitch *swNotifications;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *btnDone;

@property (nonatomic) PersoonlijkRooster *account;

-(IBAction)swNotificationsValueChanged:(UISwitch*)sender;
-(IBAction)btnDonePressed:(UIBarButtonItem*)sender;
@end

@implementation AccountNotificatiesViewController

-(PersoonlijkRooster *)account
{
    if (!_account) {
        _account = [PersoonlijkRooster defaultInstance];
    }
    return _account;
}

-(IBAction)btnDonePressed:(UIBarButtonItem *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"finishedCreatingAccount" object:nil];
}

-(void)swNotificationsValueChanged:(UISwitch *)sender
{
    if (sender.isOn == YES) {
        if ([UIApplication sharedApplication].enabledRemoteNotificationTypes != (UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound)) {
            
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound)];
            
            if ([UIApplication sharedApplication].enabledRemoteNotificationTypes == UIRemoteNotificationTypeNone) {
                [self.swNotifications setOn:NO animated:YES];
                [PersoonlijkRooster unregisterForNotifications];
            } else {
                [self.account setNotificaties:YES];
            }
        } else {
            [self.account setNotificaties:YES];
            [PersoonlijkRooster registerForNotifications];
        }
    }
}

@end

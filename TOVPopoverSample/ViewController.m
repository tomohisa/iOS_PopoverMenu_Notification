//
//  ViewController.m
//  TOVPopoverSample
//
//  Created by Tomohisa Takaoka on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "TOVLinkPopoverViewController.h"
#import "JTCAppNotificationManager.h"
@interface ViewController ()

@end

@implementation ViewController{
    id _tweet;
    UIPopoverController *_myPop;
}

- (void)viewDidLoad
{
    _tweet = [NSMutableDictionary dictionaryWithCapacity:0];
    [_tweet setValue:@"test" forKey:@"text"];
    _myPop = nil;
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


#pragma mark - events
-(IBAction)clickedButtonA:(UIBarButtonItem*)sender event:(UIEvent*)event {

    NSMutableArray *arrRows = [NSMutableArray arrayWithCapacity:0];
//    {
//#warning this code only crash on Release Build.... Don't use this
//        NSMutableDictionary * dicRow = [NSMutableDictionary dictionaryWithCapacity:0];
//        [dicRow setValue:NSLocalizedString(@"Pattern 1 Crash",nil) forKey:kDicKeyLinkPopCellText];
//        [arrRows addObject:dicRow];
//        dispatch_block_t block = ^{
//            
//            NSString *str = [NSString stringWithFormat:@"%@",[_tweet valueForKey:@"text"]];
//            
//            [[UIPasteboard generalPasteboard] setString:str];
//            [[JTCAppNotificationManager sharedManger] startTimerNotificationWithMessage:NSLocalizedString(@"Copy succeeded", @"Copy succeeded") dulation:2.5 iconName:@"w17-check.png"];
//
//            
//        };
//        [dicRow setValue:block forKey:kDicKeyLinkPopBlock];
//    }
    {
        NSMutableDictionary * dicRow = [NSMutableDictionary dictionaryWithCapacity:0];
        [dicRow setValue:NSLocalizedString(@"Pattern 2 __block",nil) forKey:kDicKeyLinkPopCellText];
        [arrRows addObject:dicRow];
#warning this code is not the way recommended how to use __block ... not recommended
        __block id bt = _tweet;
        dispatch_block_t block = ^{
            
            NSString *str = [NSString stringWithFormat:@"%@",[bt valueForKey:@"text"]];
            
            [[UIPasteboard generalPasteboard] setString:str];

            [[JTCAppNotificationManager sharedManger] startTimerNotificationWithMessage:NSLocalizedString(@"Copy succeeded", @"Copy succeeded") dulation:2.5 iconName:@"w17-check.png"];
            
        };
        [dicRow setValue:block forKey:kDicKeyLinkPopBlock];
    }
//    {
//        NSMutableDictionary * dicRow = [NSMutableDictionary dictionaryWithCapacity:0];
//        [dicRow setValue:NSLocalizedString(@"Pattern 3 only declare bt crash",nil) forKey:kDicKeyLinkPopCellText];
//        [arrRows addObject:dicRow];
//#warning this code only crash on Release Build.... Don't use this
//        id bt = _tweet;
//        dispatch_block_t block = ^{
//            
//            NSString *str = [NSString stringWithFormat:@"%@",[bt valueForKey:@"text"]];
//            
//            [[UIPasteboard generalPasteboard] setString:str];
//            
//            [[JTCAppNotificationManager sharedManger] startTimerNotificationWithMessage:NSLocalizedString(@"Copy succeeded", @"Copy succeeded") dulation:2.5 iconName:@"w17-check.png"];
//        };
//        [dicRow setValue:block forKey:kDicKeyLinkPopBlock];
//    }
    {
        NSMutableDictionary * dicRow = [NSMutableDictionary dictionaryWithCapacity:0];
        [dicRow setValue:NSLocalizedString(@"USE THIS:Pattern 4 declare bt and copy block",nil) forKey:kDicKeyLinkPopCellText];
        [arrRows addObject:dicRow];
        id bt = _tweet;
        dispatch_block_t block = ^{
            
            NSString *str = [NSString stringWithFormat:@"%@",[bt valueForKey:@"text"]];
            
            [[UIPasteboard generalPasteboard] setString:str];
            
            [[JTCAppNotificationManager sharedManger] startTimerNotificationWithMessage:NSLocalizedString(@"Copy succeeded", @"Copy succeeded") dulation:2.5 iconName:@"w17-check.png"];
        };
        [dicRow setValue:[block copy] forKey:kDicKeyLinkPopBlock];
    }
    
    NSMutableArray *sections = [NSMutableArray arrayWithObject:arrRows];
    TOVLinkPopoverViewController *controller= [[TOVLinkPopoverViewController alloc] init];
    controller.arrayLink = sections;
    _myPop = [[UIPopoverController alloc] initWithContentViewController:controller];
    
    controller.parentPop = _myPop;
    _myPop.popoverContentSize = CGSizeMake(400, 44*arrRows.count+16);
    _myPop.delegate = self;
    //    pop.delegate = self;
    UIView *button;
    for( UITouch* touch in [event allTouches] ) { 
        if( [touch phase] == UITouchPhaseEnded ) { 
            button = [touch view]; 
        } 
    }
    CGRect rect = CGRectMake(button.frame.origin.x + button.superview.frame.origin.x, button.frame.origin.y + button.superview.frame.origin.y, button.frame.size.width, button.frame.size.height);
    
    [_myPop presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];



}

-(IBAction)testIndicatorNotification:(id)sender{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        __block NSNumber* num;
        dispatch_async(dispatch_get_main_queue(), ^{
            num = [[JTCAppNotificationManager sharedManger] startIndicationNotificationWithMessage:NSLocalizedString(@"Indicator Timer Test", nil)];
        });

        
        double delayInSeconds = 5.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [[JTCAppNotificationManager sharedManger] stopNotification:num];
        });
    });

    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        __block NSNumber* num;
        dispatch_async(dispatch_get_main_queue(), ^{
            num = [[JTCAppNotificationManager sharedManger] startIndicationNotificationWithMessage:NSLocalizedString(@"Indicator Timer Test 2", nil)];
        });
        
        double delayInSeconds = 9.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [[JTCAppNotificationManager sharedManger] stopNotification:num];
        });
    });

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        __block NSNumber* num;
        double delayInSeconds = 3.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            num = [[JTCAppNotificationManager sharedManger] startIndicationNotificationWithMessage:NSLocalizedString(@"Indicator Timer Test 3", nil)];
        });
        
        delayInSeconds = 7.0;
        popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [[JTCAppNotificationManager sharedManger] stopNotification:num];
        });
    });

    
}
-(IBAction)testTimerNotification:(id)sender{
    [[JTCAppNotificationManager sharedManger] startTimerNotificationWithMessage:NSLocalizedString(@"Timer Notification Test", nil) dulation:2.5 iconName:@"w17-check.png"];
}

#pragma mark - UIPopoverControlDelegate

/* Called on the delegate when the popover controller will dismiss the popover. Return NO to prevent the dismissal of the view.
 */
- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController{
    return YES;
}

/* Called on the delegate when the user has taken action to dismiss the popover. This is not called when -dismissPopoverAnimated: is called directly.
 */
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
    _myPop=nil;
}



@end

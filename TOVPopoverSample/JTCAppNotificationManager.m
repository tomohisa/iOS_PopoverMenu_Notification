//
//  JTCAppNotificationManager.m
//  TwitOverview
//
//  Created by Tomohisa Takaoka on 4/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JTCAppNotificationManager.h"
#import <QuartzCore/QuartzCore.h>

#define kDicKeyNotificationID @"notificationID"
#define kDicKeyNotificationView @"notificationView"
#define kDicKeyNotificationType @"notificationType"

enum kNotificationType {
    kNotificationTypeIndicator = 1,
    kNotificationTypeMessage,
    };

#define kNTDefaultWidth 500
#define kNTDefaultHeight 50
@implementation JTCAppNotificationManager{
    unsigned int _notificationId;
    NSMutableArray *_arrayNotification;
    UIView *_baseView;
}
-(id) init {
    if ((self=[super init])) {
        _notificationId = 0;
        _baseView = nil;
        _arrayNotification = [NSMutableArray arrayWithCapacity:0];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateRotation)
                                                     name:UIApplicationDidChangeStatusBarOrientationNotification
                                                   object:nil];

    }
    return self;
}
-(NSNumber*) startIndicationNotificationWithMessage:(NSString*)message{
    _notificationId++;
    NSMutableDictionary* node = [NSMutableDictionary dictionaryWithCapacity:0];
    [node setObject:[NSNumber numberWithInt:_notificationId] forKey:kDicKeyNotificationID];
    
    UIWindow*window=[[UIApplication sharedApplication] keyWindow];
    if (!_baseView) {
        _baseView = [[UIView alloc] initWithFrame:window.bounds];
        _baseView.backgroundColor = [UIColor colorWithWhite:0 alpha:.6];
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (orientation==UIInterfaceOrientationPortraitUpsideDown) {
            _baseView.transform = CGAffineTransformMakeRotation(M_PI *(180) / 180.0f);
            _baseView.frame = window.bounds;
        }
        if (orientation==UIInterfaceOrientationLandscapeLeft) {
            _baseView.transform = CGAffineTransformMakeRotation(M_PI *(-90) / 180.0f);
            _baseView.frame = window.bounds;
        }
        if (orientation==UIInterfaceOrientationLandscapeRight) {
            _baseView.transform = CGAffineTransformMakeRotation(M_PI *(90) / 180.0f);
            _baseView.frame = window.bounds;
        }
        UIImageView*imageview=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bigBg.jpg"]];
        imageview.contentMode = UIViewContentModeCenter;
        imageview.frame = _baseView.bounds;
        imageview.center = CGPointMake(_baseView.bounds.size.width/2,_baseView.bounds.size.height/2);
        [_baseView addSubview:imageview];
        imageview.alpha = 0.8;

    }
    if (![_baseView superview]) {
        [window addSubview:_baseView];
    }
    UIView* notificationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kNTDefaultWidth, kNTDefaultHeight)];
    notificationView.center = CGPointMake(_baseView.bounds.size.width/2, _baseView.bounds.size.height/2);
    notificationView.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, notificationView.bounds.size.width - 50, notificationView.bounds.size.height)];
    label.text = message;
    label.numberOfLines = 0;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [notificationView addSubview:label];
    
    [_baseView addSubview:notificationView];
    
    UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    indicator.center = CGPointMake(indicator.frame.size.width/2.0 + 1, notificationView.frame.size.height/2+5);
    [indicator startAnimating];
    [notificationView addSubview:indicator];
    
    [node setObject:notificationView forKey:kDicKeyNotificationView];
    [node setObject:[NSNumber numberWithInt:kNotificationTypeIndicator] forKey:kDicKeyNotificationType];
    [_arrayNotification addObject:node];
    
    [self arrangeNotifications];
    return [node objectForKey:kDicKeyNotificationID];
}

-(NSNumber*) startTimerNotificationWithMessage:(NSString*)message dulation:(float)dul iconName:(NSString*)fileName{
    
    UIWindow*window=[[UIApplication sharedApplication] keyWindow];
    UIView* roundBase=nil;
    if (!roundBase) {
        roundBase = [[UIView alloc] initWithFrame:CGRectZero];
        roundBase.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (orientation==UIInterfaceOrientationPortrait) {
            roundBase.transform = CGAffineTransformMakeRotation(M_PI *(0) / 180.0f);
            roundBase.frame = window.bounds;
        }
        if (orientation==UIInterfaceOrientationPortraitUpsideDown) {
            roundBase.transform = CGAffineTransformMakeRotation(M_PI *(180) / 180.0f);
            roundBase.frame = window.bounds;
        }
        if (orientation==UIInterfaceOrientationLandscapeLeft) {
            roundBase.transform = CGAffineTransformMakeRotation(M_PI *(-90) / 180.0f);
            roundBase.frame = window.bounds;
        }
        if (orientation==UIInterfaceOrientationLandscapeRight) {
            roundBase.transform = CGAffineTransformMakeRotation(M_PI *(90) / 180.0f);
            roundBase.frame = window.bounds;
        }
    }
        [window addSubview:roundBase];
    UIView* notificationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 480, 160)];
    notificationView.center = CGPointMake(roundBase.bounds.size.width/2, roundBase.bounds.size.height/2);
    notificationView.backgroundColor = [UIColor colorWithWhite:0 alpha:.7];
    notificationView.layer.cornerRadius = 30;
    notificationView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    notificationView.layer.borderWidth = 3;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, notificationView.bounds.size.width - 80, notificationView.bounds.size.height)];
    label.text = message;
    label.numberOfLines = 0;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:30];
    label.backgroundColor = [UIColor clearColor];
    [notificationView addSubview:label];
    
    [roundBase addSubview:notificationView];
    
    if (fileName) {
        UIImageView*imageCheck = [[UIImageView alloc] initWithImage:[UIImage imageNamed:fileName]];
        imageCheck.center = CGPointMake(imageCheck.frame.size.width/2.0 + 20, notificationView.frame.size.height/2+5);
        [notificationView addSubview:imageCheck];
    }
    
    [UIView animateWithDuration:.5 delay:dul options:UIViewAnimationCurveEaseInOut animations:^{
        notificationView.center = CGPointMake(roundBase.center.x, -1*roundBase.center.y);
        notificationView.transform = CGAffineTransformMakeRotation(M_PI_4);
    } completion:^(BOOL finished) {
        [roundBase removeFromSuperview];
    }];
    
    return 0;
}

-(void) stopNotification:(NSNumber*)notification{
    for (NSMutableDictionary *dic in _arrayNotification) {
        if ([notification intValue]==[[dic valueForKey:kDicKeyNotificationID] intValue]) {
            UIView* view = [dic valueForKey:kDicKeyNotificationView];
            if ([view superview]) {
                [view removeFromSuperview];
            }
            [_arrayNotification removeObject:dic];
            break;
        }
    }
    if (_arrayNotification.count==0) {
        [_baseView removeFromSuperview];
    }else {
        [self arrangeNotifications];
    }
}

-(void) updateRotation{
    UIWindow*window=[[UIApplication sharedApplication] keyWindow];
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation==UIInterfaceOrientationPortrait) {
        _baseView.transform = CGAffineTransformMakeRotation(M_PI *(0) / 180.0f);
        _baseView.frame = window.bounds;
    }
    if (orientation==UIInterfaceOrientationPortraitUpsideDown) {
        _baseView.transform = CGAffineTransformMakeRotation(M_PI *(180) / 180.0f);
        _baseView.frame = window.bounds;
    }
    if (orientation==UIInterfaceOrientationLandscapeLeft) {
        _baseView.transform = CGAffineTransformMakeRotation(M_PI *(-90) / 180.0f);
        _baseView.frame = window.bounds;
    }
    if (orientation==UIInterfaceOrientationLandscapeRight) {
        _baseView.transform = CGAffineTransformMakeRotation(M_PI *(90) / 180.0f);
        _baseView.frame = window.bounds;
    }
    [self arrangeNotifications];

}

-(void) arrangeNotifications{
    _baseView.frame = [UIApplication sharedApplication].keyWindow.bounds;
    //    float startY = _baseView.bounds.size.height / 2 - ((int)(_arrayNotification.count/2))*kNTDefaultHeight/2;
    float startY = kNTDefaultHeight/2 + 20 + 80;
    for (NSMutableDictionary *dic in _arrayNotification) {
        UIView* view = [dic valueForKey:kDicKeyNotificationView];
        view.center = CGPointMake(_baseView.bounds.size.width / 2, startY);
        startY+=kNTDefaultHeight;
    }
    for (id sub in _baseView.subviews) {
        if ([sub isKindOfClass:[UIImageView class]]) {
            UIImageView* iv=sub;
            iv.frame = _baseView.bounds;
        }
    }
}

+ (JTCAppNotificationManager *)sharedManger{
    static JTCAppNotificationManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[JTCAppNotificationManager alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;

}
@end

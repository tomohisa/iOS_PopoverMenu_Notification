//
//  JTCAppNotificationManager.h
//  TwitOverview
//
//  Created by Tomohisa Takaoka on 4/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JTCAppNotificationManager : NSObject
-(NSNumber*) startIndicationNotificationWithMessage:(NSString*)message;
-(NSNumber*) startTimerNotificationWithMessage:(NSString*)message dulation:(float)dul iconName:(NSString*)fileName;
-(void) stopNotification:(NSNumber*)notification;
+ (JTCAppNotificationManager *)sharedManger;
@end

//
//  TOVLinkPopoverViewController.h
//  TwitOverview
//
//  Created by Tomohisa Takaoka on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kDicKeyLinkPopCellText @"text"
#define kDicKeyLinkPopBlock @"block"
@interface TOVLinkPopoverViewController : UITableViewController
@property (strong) NSMutableArray* arrayLink;
@property (weak) UIPopoverController* parentPop;
@end

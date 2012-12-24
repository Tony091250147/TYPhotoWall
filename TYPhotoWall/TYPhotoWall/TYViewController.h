//
//  TYViewController.h
//  TYPhotoWall
//
//  Created by tony on 12-12-24.
//  Copyright (c) 2012年 tony. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TYPhotoWall.h"

@interface TYViewController : UIViewController <UIScrollViewDelegate, TYPhotoWallDelegate>

@property (nonatomic, strong) IBOutlet UIScrollView * scrollView;

@end

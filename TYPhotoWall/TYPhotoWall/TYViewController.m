//
//  TYViewController.m
//  TYPhotoWall
//
//  Created by tony on 12-12-24.
//  Copyright (c) 2012年 tony. All rights reserved.
//

#import "TYViewController.h"

@interface TYViewController ()
@property (nonatomic, strong) TYPhotoWall *photoWall;
@end

@implementation TYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.photoWall = [[TYPhotoWall alloc] init];
    self.photoWall.delegate = self;
    [self.photoWall setEditMode:YES];
    [self.scrollView addSubview:self.photoWall];
    self.scrollView.contentSize = self.photoWall.frame.size;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollViewDelegate

#pragma mark - TYPhotoWallDelegate
- (void)photoWallPhotoTaped:(NSUInteger)index photoWall:(TYPhotoWall*)wall
{
    
}

- (void)photoWallMovePhotoFromIndex:(NSInteger)index toIndex:(NSInteger)newIndex photoWall:(TYPhotoWall*)wall
{
    
}

static NSUInteger imageIndex = 1;
- (void)photoWallAddAction:(TYPhotoWall*)wall //needs to add photo
{
    NSString *imageName = [NSString stringWithFormat:@"cat%d.jpg",imageIndex];
    imageIndex++;
    if (imageIndex == 4) {
        imageIndex = 1;
    }
    [self.photoWall addPhoto:[UIImage imageNamed:imageName]];
}

- (void)photoWallAddFinish:(TYPhotoWall*)wall
{
    self.scrollView.contentSize = self.photoWall.frame.size;
}

- (void)photoWallDeleteFinishIndex:(NSUInteger)index photoWall:(TYPhotoWall*)wall
{
    self.scrollView.contentSize = self.photoWall.frame.size;
}
@end

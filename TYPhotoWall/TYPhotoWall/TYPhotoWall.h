//
//  TYPhotoWall.h
//  TYPhotoWall
//
//  Created by tony on 12-12-24.
//  Copyright (c) 2012年 tony. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYPhoto.h"
@class TYPhotoWall;

@protocol TYPhotoWallDelegate <NSObject>

- (void)photoWallPhotoTaped:(NSUInteger)index photoWall:(TYPhotoWall*)wall;
- (void)photoWallMovePhotoFromIndex:(NSInteger)index toIndex:(NSInteger)newIndex photoWall:(TYPhotoWall*)wall;
- (void)photoWallAddAction:(TYPhotoWall*)wall;//needs to add photo
- (void)photoWallAddFinish:(TYPhotoWall*)wall;
- (void)photoWallDeleteFinishIndex:(NSUInteger)index photoWall:(TYPhotoWall*)wall;

@end

@interface TYPhotoWall : UIView <TYPhotoDelegate>

@property (assign, nonatomic) id<TYPhotoWallDelegate> delegate;
@property (strong, nonatomic) NSMutableArray *arrayPhotos;

- (void)setPhotos:(NSArray*)photos;
- (void)setEditMode:(BOOL)canEdit;
- (void)addPhoto:(UIImage*)img;
- (void)deletePhotoByIndex:(NSUInteger)index;
@end

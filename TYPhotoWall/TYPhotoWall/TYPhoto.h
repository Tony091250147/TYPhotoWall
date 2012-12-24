//
//  TYPhoto.h
//  TYPhotoWall
//
//  Created by tony on 12-12-24.
//  Copyright (c) 2012年 tony. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TYPhoto;

@protocol TYPhotoDelegate <NSObject>
- (void)photoTaped:(TYPhoto*)photo;
- (void)photoMoveFinished:(TYPhoto*)photo;
- (void)afterDeleteTaped:(TYPhoto*)photo;
@end
/*
@protocol TYPHotoDataSource <NSObject>
- (CGFloat)
@end
 */
typedef enum PhotoType {
    PhotoType_Photo,
    PhotoType_Add,
} PhotoType;
@interface TYPhoto : UIView

@property (assign, nonatomic) id<TYPhotoDelegate> delegate;
@property (assign, nonatomic) NSUInteger index;
- (id)initWithOrigin:(CGPoint)origin;
- (PhotoType)getPhotoType;
- (void)setPhoto:(UIImage*)img;
- (void)moveToPosition:(CGPoint)point;
/*
 * In edit mode, you can:
 *      1.change the sequence of images;
 *      2.delete an image;
 *      3.add an image.
 * While you switch out edit mode, you can ONLY:
 *      1.add an image.
 */
- (void)setEditMode:(BOOL)edit;
- (void)setPhotoType:(PhotoType)type;
@end

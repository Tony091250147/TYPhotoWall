//
//  TYPhoto.m
//  TYPhotoWall
//
//  Created by tony on 12-12-24.
//  Copyright (c) 2012年 tony. All rights reserved.
//

#import "TYPhoto.h"

#import <QuartzCore/QuartzCore.h>
#import "TYPhotoSize.h"

@interface TYPhoto() <UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIView *viewMask;
@property (strong, nonatomic) UIImageView *viewPhoto;
@property (strong, nonatomic) UIButton *delete;

@property (nonatomic, assign) CGPoint pointOrigin;
@property (nonatomic, assign) BOOL editMode;

@property (nonatomic, assign) PhotoType type;
@end


@implementation TYPhoto

- (id)initWithOrigin:(CGPoint)origin
{
    self = [super initWithFrame:CGRectMake(origin.x, origin.y, kPhotoSize, kPhotoSize)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.viewPhoto = [[UIImageView alloc] initWithFrame:self.bounds];
        self.viewPhoto.layer.cornerRadius = 12;
        self.viewPhoto.layer.masksToBounds = YES;
        
        self.viewMask = [[UIView alloc] initWithFrame:self.bounds];
        self.viewMask.alpha = 0.6;
        self.viewMask.backgroundColor = [UIColor blackColor];
        self.viewMask.layer.cornerRadius = 11;
        self.viewMask.layer.masksToBounds = YES;
        
        self.delete = [UIButton buttonWithType:UIButtonTypeCustom];
        self.delete.frame = CGRectMake(self.bounds.size.width-15, -5, kDeleteSize, kDeleteSize);
        [self.delete setImage:[UIImage imageNamed:@"ty_delete.png"] forState:UIControlStateNormal];
        self.delete.backgroundColor = [UIColor clearColor];
        [self.delete addTarget:self action:@selector(afterDeleteTaped:) forControlEvents:UIControlEventTouchDown];
//        [self.delete addTarget:self action:@selector(afterDeleteTaped:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.viewPhoto];
        [self addSubview:self.viewMask];
        [self addSubview:self.delete];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPress:)];
        [self addGestureRecognizer:tapRecognizer];
        
        self.delete.hidden = YES;
        self.editMode = NO;
        self.viewMask.hidden = YES;
    }

    return self;
}

- (void)setPhotoType:(PhotoType)type
{
    _type = type;
    if (_type == PhotoType_Add) {
        
        UIImage *tmpImage = [UIImage imageNamed:@"ty_addPhoto@2x.png"];
//        NSLog(@"PhotoType_Add, is nil:%d ",self.viewPhoto == nil);
//        NSLog(@"Self frame:%@ is Hidden:%d",NSStringFromCGRect(self.frame), self.hidden == YES);
        self.viewPhoto.image = tmpImage;
    }
}

- (PhotoType)getPhotoType
{
    return self.type;
}

- (void)setPhoto:(UIImage *)img
{
    self.viewPhoto.image = img;
}

- (void)moveToPosition:(CGPoint)point
{
    if (self.type == PhotoType_Photo) {
        [UIView animateWithDuration:0.5 animations:^{
            self.frame = CGRectMake(point.x, point.y, self.frame.size.width, self.frame.size.height);
        } completion:nil];
    } else {
        self.frame = CGRectMake(point.x, point.y, self.frame.size.width, self.frame.size.height);
    }
}

- (void)setEditMode:(BOOL)edit
{
    if (self.type == PhotoType_Photo) {
        if (edit) {
            //long press to move picture sequence
            UILongPressGestureRecognizer *longPressreRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
            longPressreRecognizer.delegate = self;
            [self addGestureRecognizer:longPressreRecognizer];
            
            //make delete button work
            self.delete.hidden = NO;
        } else {
            for (UIGestureRecognizer *recognizer in [self gestureRecognizers]) {
                if ([recognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
                    [self removeGestureRecognizer:recognizer];
                    break;
                }
            }
            
            //disabel delete button
            self.delete.hidden = YES;
        }
    }
}

- (void)afterDeleteTaped:(id)sender
{
    [self.delegate afterDeleteTaped:self];
}
#pragma mark - gesture handler
- (void)tapPress:(UITapGestureRecognizer*)tapGesture
{
//    NSLog(@"Tap Press");
    if (tapGesture.state == UIGestureRecognizerStateEnded) {
        CGPoint inDelete = [tapGesture locationInView:self.delete];
        if ([self judgePointInDelete:inDelete]) {
            [self afterDeleteTaped:nil];
        } else
        {
            if ([self.delegate respondsToSelector:@selector(photoTaped:)]) {
                [self.delegate photoTaped:self];
            }
        }
    
    }
    
}

- (BOOL)judgePointInDelete:(CGPoint)p
{
    BOOL result = YES;
    if (p.x < 0 ||
        p.y < 0 ||
        p.x > kDeleteSize ||
        p.y > kDeleteSize) {
        result = NO;
    }
    return result;
}
- (void)handleLongPress:(id)sender
{
    UILongPressGestureRecognizer *recognizer = sender;
    CGPoint point = [recognizer locationInView:self];
    
    CGFloat diffx = 0.;
    CGFloat diffy = 0.;
    
    if (UIGestureRecognizerStateBegan == recognizer.state) {
        self.viewMask.hidden = NO;
        self.pointOrigin = point;
        [self.superview bringSubviewToFront:self];
    } else if (UIGestureRecognizerStateEnded == recognizer.state) {
        self.viewMask.hidden = YES;
        if ([self.delegate respondsToSelector:@selector(photoMoveFinished:)]) {
            [self.delegate photoMoveFinished:self];
        }
    } else {
        diffx = point.x - self.pointOrigin.x;
        diffy = point.y - self.pointOrigin.y;
    }
    
    CGFloat originx = self.frame.origin.x +diffx;
    CGFloat originy = self.frame.origin.y +diffy;
    
    self.frame = CGRectMake(originx, originy, self.frame.size.width, self.frame.size.height);
}

@end

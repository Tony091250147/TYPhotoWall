//
//  TYPhotoWall.m
//  TYPhotoWall
//
//  Created by tony on 12-12-24.
//  Copyright (c) 2012年 tony. All rights reserved.
//

#import "TYPhotoWall.h"


#import "TYPhotoSize.h"
@interface TYPhotoWall() 

@property (strong, nonatomic) NSMutableArray *arrayPhotos;
@property (nonatomic) BOOL isEditMode;

@end



//#define kImagePositionx @"positionx"
//#define kImagePositiony @"positiony"

@implementation TYPhotoWall

- (id)init
{
    self = [super initWithFrame:CGRectMake(0, 0, 320, 0)];
    if (self) {
        self.backgroundColor = [UIColor darkGrayColor];
        self.arrayPhotos = [NSMutableArray arrayWithCapacity:1];
        [self setPhotos:nil];
    }
    
    return self;
}

- (void)setPhotos:(NSArray*)photos
{
    [self.arrayPhotos removeAllObjects];
    
    NSUInteger count;
    if (photos != nil) {
        count = [photos count];
    } else
    {
        count = 0;
    }
    
    for (int i=0; i<count; i++) {
        /*
        NSDictionary *dictionaryTemp = [self.arrayPositions objectAtIndex:i];
        CGFloat originx = [[dictionaryTemp objectForKey:kImagePositionx] floatValue];
        CGFloat originy = [[dictionaryTemp objectForKey:kImagePositiony] floatValue];
         */
        CGPoint origin = [self getOriginByIndex:i];
        TYPhoto *photoTemp = [[TYPhoto alloc] initWithOrigin:origin];
        photoTemp.index = i;
        photoTemp.delegate = self;
        [photoTemp setPhoto:[photos objectAtIndex:i]];
        [self addSubview:photoTemp];
        [self.arrayPhotos addObject:photoTemp];
    }
    
    CGPoint addPhotoOrigin = [self getOriginByIndex:count];

    TYPhoto *photoTemp = [[TYPhoto alloc] initWithOrigin:addPhotoOrigin];
    photoTemp.delegate = self;
//    photoTemp.hidden = YES;
    [photoTemp setPhotoType:PhotoType_Add];
    [self.arrayPhotos addObject:photoTemp];
    [self addSubview:photoTemp];
    
    //take 'add photo' into consideration
    count++;
    NSInteger row = ceil(count/4.0);
    CGFloat frameHeight = kVerticalSpace + (kVerticalSpace+kPhotoSize) * row;
    self.frame = CGRectMake(0., 0., 320., frameHeight);
}

//index starts from 0
- (CGPoint)getOriginByIndex:(NSUInteger)index
{
    CGFloat originX = kHorizonalSpace + (index%4)*(kHorizonalSpace+kPhotoSize);
    CGFloat originY = kVerticalSpace + floor(index/4.0)*(kVerticalSpace+kPhotoSize);
    
    return CGPointMake(originX, originY);
}

- (void)setEditMode:(BOOL)canEdit
{
    self.isEditMode = canEdit;
        
    NSUInteger count = [self.arrayPhotos count]-1;
    for (int i=0; i<count; i++) {
        TYPhoto *viewTemp = [self.arrayPhotos objectAtIndex:i];
        [viewTemp setEditMode:self.isEditMode];
    }
    [self reloadPhotos:NO];
}

- (void)addPhoto:(UIImage*)img
{
    NSUInteger index = [self.arrayPhotos count] - 1;
    CGPoint addPhotoOrigin = [self getOriginByIndex:index];
    
    TYPhoto *photoTemp = [[TYPhoto alloc] initWithOrigin:addPhotoOrigin];
    photoTemp.delegate = self;
    photoTemp.index = index;
    [photoTemp setPhoto:img];
    [photoTemp setEditMode:self.isEditMode];
    
    [self.arrayPhotos insertObject:photoTemp atIndex:index];
    [self addSubview:photoTemp];
    [self reloadPhotos:YES];
    [self.delegate photoWallAddFinish:self];
}

- (void)deletePhotoByIndex:(NSUInteger)index
{
    TYPhoto *photoTemp = [self.arrayPhotos objectAtIndex:index];
    [self.arrayPhotos removeObject:photoTemp];
    [photoTemp removeFromSuperview];
    for (NSUInteger iter = index; iter < self.arrayPhotos.count; iter++) {
        TYPhoto *p = [self.arrayPhotos objectAtIndex:iter];
        p.index = iter;
    }
    [self reloadPhotos:YES];
    [self.delegate photoWallDeleteFinishIndex:index photoWall:self];
}

#pragma mark - TYPhotoDelegate
- (void)photoTaped:(TYPhoto*)photo
{
    NSUInteger type = [photo getPhotoType];
    if (type == PhotoType_Add) {
        if ([self.delegate respondsToSelector:@selector(photoWallAddAction:)]) {
            [self.delegate photoWallAddAction:self];
        }
    } else if (type == PhotoType_Photo) {
        /*
        NSUInteger index = [self.arrayPhotos indexOfObject:photo];
        if ([self.delegate respondsToSelector:@selector(photoWallPhotoTaped:photoWall:)]) {
            [self.delegate photoWallPhotoTaped:index photoWall:self];
        }
         */
    if ([self.delegate respondsToSelector:@selector(photoWallPhotoTaped:photoWall:)]) {
        [self.delegate photoWallPhotoTaped:photo.index photoWall:self];
    }
    }
}

- (void)photoMoveFinished:(TYPhoto*)photo
{
    CGPoint pointPhoto = CGPointMake(photo.frame.origin.x, photo.frame.origin.y);
    CGFloat space = -1;
//    NSUInteger oldIndex = [self.arrayPhotos indexOfObject:photo];
    NSUInteger oldIndex = photo.index;
    NSUInteger newIndex = -1;
    
    NSUInteger count = [self.arrayPhotos count] - 1;
    for (int i=0; i<count; i++) {
        
        CGPoint pointTemp = [self getOriginByIndex:i];
        CGFloat spaceTemp = [self spaceToPoint:pointPhoto FromPoint:pointTemp];
        if (space < 0) {
            space = spaceTemp;
            newIndex = i;
        } else {
            if (spaceTemp < space) {
                space = spaceTemp;
                newIndex = i;
            }
        }
    }
    photo.index = newIndex;
    [self.arrayPhotos removeObject:photo];
    [self.arrayPhotos insertObject:photo atIndex:newIndex];
    
    [self reloadPhotos:NO];
    
    if ([self.delegate respondsToSelector:@selector(photoWallMovePhotoFromIndex:toIndex:photoWall:)]) {
        [self.delegate photoWallMovePhotoFromIndex:oldIndex toIndex:newIndex photoWall:self];
    }
}

- (void)afterDeleteTaped:(TYPhoto *)photo
{
    [self deletePhotoByIndex:photo.index];
}

- (void)reloadPhotos:(BOOL)add
{
    NSUInteger count = -1;
    if (add) {
        count = [self.arrayPhotos count];
    } else {
        count = [self.arrayPhotos count] - 1;
    }
    for (int i=0; i<count; i++) {
        CGPoint origin = [self getOriginByIndex:i];
        TYPhoto *photoTemp = [self.arrayPhotos objectAtIndex:i];
        [photoTemp moveToPosition:origin];
    }
    

    NSUInteger countPhoto = [self.arrayPhotos count];
    CGFloat frameHeight = kVerticalSpace + (kVerticalSpace+kPhotoSize) * ceil(countPhoto/4.0);
    self.frame = CGRectMake(0., 0., 320., frameHeight);
}


- (CGFloat)spaceToPoint:(CGPoint)point FromPoint:(CGPoint)otherPoint
{
    float x = point.x - otherPoint.x;
    float y = point.y - otherPoint.y;
    return sqrt(x * x + y * y);
}


@end

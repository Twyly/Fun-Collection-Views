//
//  TJWDeckLayout.m
//  CollectionViewFun
//
//  Created by Teddy Wyly on 8/12/13.
//  Copyright (c) 2013 Teddy Wyly. All rights reserved.
//

#import "TJWDeckLayout.h"

static NSString *const TJWDECKLAYOUTCARDCELLKIND = @"Card Cell";
static NSUInteger const RotationCount = 32;
static NSUInteger const RotationStride = 3;

@interface TJWDeckLayout ()

@property (strong, nonatomic) NSDictionary *layoutInfo;
@property (strong, nonatomic) NSArray *rotations;

@end

@implementation TJWDeckLayout


- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.itemInsets = UIEdgeInsetsMake(22.0f, 22.0f, 13.0f, 22.0f);
    self.itemSize = CGSizeMake(55.0f, 55.0f);
    self.interItemSpacingY = 12.0f;
    self.numberOfColums = 4;
    
    // create rotations at load so that they are consistent during prepareLayout
    NSMutableArray *rotations = [NSMutableArray arrayWithCapacity:RotationCount];
    
    CGFloat percentage = 0.0f;
    for (NSInteger i = 0; i < RotationCount; i++) {
        // ensure that each angle is different enough to be seen
        CGFloat newPercentage = 0.0f;
        do {
            newPercentage = ((CGFloat)(arc4random() % 220) - 110) * 0.0001f;
        } while (fabsf(percentage - newPercentage) < 0.006);
        percentage = newPercentage;
        
        CGFloat angle = 2 * M_PI * (1.0f + percentage);
        CATransform3D transform = CATransform3DMakeRotation(angle, 0.0f, 0.0f, 1.0f);
        
        [rotations addObject:[NSValue valueWithCATransform3D:transform]];
    
    self.rotations = rotations;
    
    }
    
}

- (void)setItemInsets:(UIEdgeInsets)itemInsets
{
    if (UIEdgeInsetsEqualToEdgeInsets(_itemInsets, itemInsets)) return;
    
    _itemInsets = itemInsets;
    
    [self invalidateLayout];
}

- (void)setItemSize:(CGSize)itemSize
{
    if (CGSizeEqualToSize(_itemSize, itemSize)) return;
    
    _itemSize = itemSize;
    
    [self invalidateLayout];
}

- (void)setInterItemSpacingY:(CGFloat)interItemSpacingY
{
    if (_interItemSpacingY == interItemSpacingY) return;
    
    _interItemSpacingY = interItemSpacingY;
    
    [self invalidateLayout];
}

- (void)setNumberOfColums:(NSInteger)numberOfColums
{
    if (_numberOfColums == numberOfColums) return;
    
    _numberOfColums = numberOfColums;
    
    [self invalidateLayout];
}

- (CGRect)frameForCardAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        
        CGFloat spacingX = self.collectionView.bounds.size.width - self.itemInsets.left - self.itemInsets.right - (self.numberOfColums * self.itemSize.width);
        if (self.numberOfColums > 1) spacingX = spacingX / (self.numberOfColums - 1);
        
        CGFloat originX = floorf(self.itemInsets.left + (self.itemSize.width + spacingX) * (self.numberOfColums - 1));
        CGFloat originY = floorf(self.itemInsets.top + (self.itemSize.height + self.interItemSpacingY) * 0);
        
        return CGRectMake(originX, originY, self.itemSize.width, self.itemSize.height);
        
    }
    
    
    NSInteger row = indexPath.item / self.numberOfColums;
    NSInteger column = indexPath.item % self.numberOfColums;
    
    CGFloat spacingX = self.collectionView.bounds.size.width - self.itemInsets.left - self.itemInsets.right - (self.numberOfColums * self.itemSize.width);
    
    if (self.numberOfColums > 1) spacingX = spacingX / (self.numberOfColums - 1);
    
    CGFloat originX = floorf(self.itemInsets.left + (self.itemSize.width + spacingX) * column);
    
    CGFloat originY = floor(self.itemInsets.top +
                            (self.itemSize.height + self.interItemSpacingY) * (row + 1));
    
    return CGRectMake(originX, originY, self.itemSize.width, self.itemSize.height);
}

- (void)prepareLayout
{
    NSMutableDictionary *newLayoutInfo = [NSMutableDictionary dictionary];
    NSMutableDictionary *cellLayoutInfo = [NSMutableDictionary dictionary];
    
    NSInteger sectionCount = [self.collectionView numberOfSections];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    
    for (NSInteger section = 0; section < sectionCount; section++) {
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
        
        for (NSInteger item  = 0; item < itemCount; item++) {
            indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            UICollectionViewLayoutAttributes *itemAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            itemAttributes.frame = [self frameForCardAtIndexPath:indexPath];
            if (indexPath.section == 1) {
                itemAttributes.transform3D = [self transformForCardAtIndex:indexPath];
                itemAttributes.zIndex = -indexPath.item;
            }
            
            cellLayoutInfo[indexPath] = itemAttributes;
        }
    }
    
    
    newLayoutInfo[TJWDECKLAYOUTCARDCELLKIND] = cellLayoutInfo;
    self.layoutInfo = newLayoutInfo;
    
    
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *allAttributes = [NSMutableArray arrayWithCapacity:[self.layoutInfo count]];
    
    [self.layoutInfo enumerateKeysAndObjectsUsingBlock:^(NSString *elementIdentifier,
                                                         NSDictionary *elementsInfo,
                                                         BOOL *stop) {
        [elementsInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath,
                                                          UICollectionViewLayoutAttributes *attributes,
                                                          BOOL *innerStop) {
            if (CGRectIntersectsRect(rect, attributes.frame)) {
                [allAttributes addObject:attributes];
            }
        }];
    }];
    
    return allAttributes;
    
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.layoutInfo[TJWDECKLAYOUTCARDCELLKIND][indexPath];
}

- (CGSize)collectionViewContentSize
{
    NSInteger rowCount = [self.collectionView numberOfItemsInSection:0] / self.numberOfColums;
    // make sure we count another row if one is only partially filled
    if ([self.collectionView numberOfItemsInSection:0] % self.numberOfColums) rowCount++;
    
    CGFloat height = self.itemInsets.top +
    rowCount * self.itemSize.height + (rowCount - 1) * self.interItemSpacingY +
    self.itemInsets.bottom;
    
    return CGSizeMake(self.collectionView.bounds.size.width, height);
}

- (CATransform3D)transformForCardAtIndex:(NSIndexPath *)indexPath
{
    NSInteger offset = (indexPath.section * RotationStride + indexPath.item);
    return [self.rotations[offset % RotationCount] CATransform3DValue];
}



@end

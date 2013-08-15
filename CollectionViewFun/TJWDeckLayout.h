//
//  TJWDeckLayout.h
//  CollectionViewFun
//
//  Created by Teddy Wyly on 8/12/13.
//  Copyright (c) 2013 Teddy Wyly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJWDeckLayout : UICollectionViewLayout

@property (nonatomic) UIEdgeInsets itemInsets;
@property (nonatomic) CGSize itemSize;
@property (nonatomic) CGFloat interItemSpacingY;
@property (nonatomic) NSInteger numberOfColums;

@end

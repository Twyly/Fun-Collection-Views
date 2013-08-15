//
//  TJWViewController.m
//  CollectionViewFun
//
//  Created by Teddy Wyly on 8/12/13.
//  Copyright (c) 2013 Teddy Wyly. All rights reserved.
//

#import "TJWViewController.h"
#import "TJWDeckLayout.h"
#import "TJWCardCell.h"
#import "CCoverflowCollectionViewLayout.h"

static NSString *const DECKCELLIDENTIFIER = @"Deck Cell";
static NSUInteger const NUMBEROFVISABLECARDS = 5;

@interface TJWViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) NSMutableArray *cards;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet TJWDeckLayout *deckLayout;
@property (nonatomic) NSUInteger numberOfVisableCards;

@end

@implementation TJWViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[TJWCardCell class] forCellWithReuseIdentifier:DECKCELLIDENTIFIER];
    
    const NSInteger numberOfColors = 20;
    
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:numberOfColors];
    
    for (NSInteger i = 0; i < numberOfColors; i++)
    {
        CGFloat redValue = (arc4random() % 255) / 255.0f;
        CGFloat blueValue = (arc4random() % 255) / 255.0f;
        CGFloat greenValue = (arc4random() % 255) / 255.0f;
        
        [tempArray addObject:[UIColor colorWithRed:redValue green:greenValue blue:blueValue alpha:1.0f]];
    }
    
    self.numberOfVisableCards = NUMBEROFVISABLECARDS;
    
    self.cards = [NSMutableArray arrayWithArray:tempArray];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)coverFlowButtonPressed:(UIButton *)sender
{
    [self.collectionView.collectionViewLayout invalidateLayout];
    CCoverflowCollectionViewLayout *layout = [[CCoverflowCollectionViewLayout alloc] init];
    [self.collectionView setCollectionViewLayout:layout animated:YES];
}

- (IBAction)dealCard:(UIBarButtonItem *)sender
{
    int indexOfTopCard = [self.cards count] - self.numberOfVisableCards - 1;
    if ([self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:indexOfTopCard inSection:1]]) {
        [self.collectionView performBatchUpdates:^{
            self.numberOfVisableCards++;
            //int indexOfTopCard = [self.cards count] - self.numberOfVisableCards - 1;
            [self.collectionView moveItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1] toIndexPath:[NSIndexPath indexPathForItem:self.numberOfVisableCards - 1 inSection:0]];
        } completion:nil];
    }
}

- (IBAction)tapGestureRecognized:(UITapGestureRecognizer *)sender
{
    CGPoint tapLocation = [sender locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:tapLocation];
    if (indexPath && indexPath.section == 0) {
        [self.collectionView performBatchUpdates:^{
            self.numberOfVisableCards--;
            [self.cards removeObjectAtIndex:indexPath.item];
            [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
        } completion:nil];
    }


}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.numberOfVisableCards;
    }
    else {
        return [self.cards count] - self.numberOfVisableCards;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TJWCardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DECKCELLIDENTIFIER forIndexPath:indexPath];
    
    cell.backgroundColor = (indexPath.section == 0) ? self.cards[indexPath.item] : self.cards[indexPath.item];
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        self.deckLayout.numberOfColums = 3;
        
        // handle insets for iPhone 4 or 5
        CGFloat sideInset = [UIScreen mainScreen].preferredMode.size.width == 1136.0f ?
        45.0f : 25.0f;
        
        self.deckLayout.itemInsets = UIEdgeInsetsMake(22.0f, sideInset, 13.0f, sideInset);
        
    } else {
        self.deckLayout.numberOfColums = 2;
        self.deckLayout.itemInsets = UIEdgeInsetsMake(22.0f, 22.0f, 13.0f, 22.0f);
    }
}

@end

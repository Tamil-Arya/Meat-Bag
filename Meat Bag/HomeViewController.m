//
//  HomeViewController.m
//  Meat Bag
//
//  Created by Tamil Selvan R on 20/05/17.
//  Copyright © 2017 Tamil Selvan R. All rights reserved.
//

#import "HomeViewController.h"
#import "SWRevealViewController.h"
#import "HomeTableViewCell.h"
#import "CollectionViewCell.h"
#import "ContainerCollectionViewCell.h"
#import "LGHorizontalLinearFlowLayout.h"


@interface HomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic) IBOutlet UIBarButtonItem* revealButtonItem;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *bottomCollectionView;

@property (strong, nonatomic) NSArray *dataSource;

@property (strong, nonatomic) LGHorizontalLinearFlowLayout *collectionViewLayout;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (readonly, nonatomic) CGFloat pageWidth;
@property (readonly, nonatomic) CGFloat contentOffset;

@property (assign, nonatomic) NSUInteger animationsCount;
@property (nonatomic) NSArray * adsArray;
@property (nonatomic) NSArray * bottomArray;

@end
@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _adsArray = [[NSArray alloc]initWithObjects:@"1.jpg",@"2.jpg",@"3.jpg", nil];
    
    _bottomArray = [[NSArray alloc]initWithObjects:@"1.jpg",@"4.jpg",@"5.jpg",@"6.jpg",@"2.jpg",@"3.jpg",@"4.jpg",@"5.jpg",@"6.jpg",@"1.jpg", nil];

    [self customSetup];
    [self configureDataSource];
    [self configureCollectionView];
    [self configurePageControl];
    
}

#pragma UICollectionView - datasource


- (void)configureDataSource {
    NSMutableArray *datasource = [NSMutableArray new];
    for (NSUInteger i = 0; i < _adsArray.count; i++) {
        [datasource addObject:[NSString stringWithFormat:@"Page %@", @(i)]];
    }
    self.dataSource = datasource;
}

- (void)configurePageControl {
    self.pageControl.numberOfPages = self.dataSource.count;
}



#pragma mark - Actions

- (IBAction)pageControlValueChanged:(id)sender {
    [self scrollToPage:self.pageControl.currentPage animated:YES];
}

- (IBAction)nextButtonAction:(id)sender {
    [self scrollToPage:self.pageControl.currentPage + 1 animated:YES];
}

- (IBAction)previousButtonAction:(id)sender {
    [self scrollToPage:self.pageControl.currentPage - 1 animated:YES];
}

- (void)scrollToPage:(NSUInteger)page animated:(BOOL)animated {
    self.collectionView.userInteractionEnabled = NO;
    self.animationsCount++;
    CGFloat pageOffset = page * self.pageWidth - self.collectionView.contentInset.left;
    [self.collectionView setContentOffset:CGPointMake(pageOffset, 0) animated:animated];
    self.pageControl.currentPage = page;
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.collectionView) {
        return self.dataSource.count;
    }
    return _bottomArray.count;

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell * cell;
    
    if (collectionView == self.collectionView) {
        cell=
        (CollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell"
                                                                        forIndexPath:indexPath];
        
        cell.imageView.image= [UIImage imageNamed:[NSString stringWithFormat:@"%@", [_adsArray objectAtIndex:indexPath.row]]];
        

    }
    else if(collectionView == self.bottomCollectionView){
      ContainerCollectionViewCell*   cell=
        (ContainerCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell2"
                                                                        forIndexPath:indexPath];
        cell.imageView.image= [UIImage imageNamed:[NSString stringWithFormat:@"%@", [_bottomArray objectAtIndex:indexPath.row]]];
        return cell;

    }
        return cell;
    
   }

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.isDragging || collectionView.isDecelerating || collectionView.isTracking) return;
    
    NSUInteger selectedPage = indexPath.row;
    
    if (selectedPage == self.pageControl.currentPage) {
        NSLog(@"Did select center item");
    }
    else {
        [self scrollToPage:selectedPage animated:YES];
    }
}
- (void)configureCollectionView {
  
    self.collectionViewLayout = [LGHorizontalLinearFlowLayout layoutConfiguredWithCollectionView:self.collectionView
                                                                                        itemSize:CGSizeMake(372, 172)
                                                                              minimumLineSpacing:0];
}

#pragma mark - UICollectionViewDelegate

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (--self.animationsCount > 0) return;
    self.collectionView.userInteractionEnabled = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.pageControl.currentPage = self.contentOffset / self.pageWidth;
}

#pragma mark - Convenience

- (CGFloat)pageWidth {
    return self.collectionViewLayout.itemSize.width + self.collectionViewLayout.minimumLineSpacing;
}

- (CGFloat)contentOffset {
    return self.collectionView.contentOffset.x + self.collectionView.contentInset.left;
}

- (void)customSetup
{
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.revealButtonItem setTarget: self.revealViewController];
        [self.revealButtonItem setAction: @selector( revealToggle: )];
        [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

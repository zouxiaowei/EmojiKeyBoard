//
//  EmojiKeyboardView.m
//  EmojiKeyBoard
//
//  Created by zou on 2018/9/19.
//  Copyright © 2018年 zou. All rights reserved.
//

#import "EmojiKeyboardView.h"
#import "EmojiItemViewCell.h"
#import "AllEmojiModel.h"

@interface EmojiKeyboardView()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UICollectionView *emojiArea;
@property (nonatomic,strong) UIPageControl *emojiControl;
@property (nonatomic,strong) UIButton *addEmojiCateButton;
@property (nonatomic,strong) UIButton *sendMessageButton;
@property (nonatomic,strong) UIScrollView *emojiCateScrollView;


@property (nonatomic) CGFloat ScreenWidth;

@end

@implementation EmojiKeyboardView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
        [self createUI];
    }
    return self;
}
-(void)setup{
    self.backgroundColor=[UIColor redColor];
    self.ScreenWidth=[UIScreen mainScreen].bounds.size.width;
//    self.emojiLists=[NSArray array];
    self.currentEmojiCateIndex=0;
    self.allEmojiModel=[[AllEmojiModel alloc]init];
}


-(void)createUI{
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    self.emojiArea=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 120) collectionViewLayout:layout];
    [self addSubview:self.emojiArea];
    self.emojiArea.delegate=self;
    self.emojiArea.dataSource=self;
    self.emojiArea.backgroundColor=[UIColor whiteColor];
    self.emojiArea.pagingEnabled=YES;
    self.emojiArea.showsHorizontalScrollIndicator=NO;
    self.emojiArea.showsVerticalScrollIndicator=NO;
    [self.emojiArea registerClass:[EmojiItemViewCell class] forCellWithReuseIdentifier:@"EmojiItemViewCell"];
    
    self.emojiControl=[[UIPageControl alloc]initWithFrame:CGRectMake(0, 120, self.frame.size.width, 40)];
    [self addSubview:self.emojiControl];
    self.emojiControl.numberOfPages=3;
    self.emojiControl.backgroundColor=[UIColor whiteColor];
    self.emojiControl.currentPageIndicatorTintColor=[UIColor grayColor];
    self.emojiControl.pageIndicatorTintColor=[UIColor lightGrayColor];

    
    self.addEmojiCateButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 160, 40, 40)];
    [self addSubview:self.addEmojiCateButton];
    [self.addEmojiCateButton setTitle:@"add" forState:UIControlStateNormal];
//    [self.addEmojiCateButton addTarget:self action:@selector(addEmoji:) forControlEvents:UIControlEventTouchUpInside];

    
    self.sendMessageButton=[[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width-40,160 , 40, 40)];
    [self addSubview:self.sendMessageButton];
    [self.sendMessageButton setTitle:@"send" forState:UIControlStateNormal];
    [self.sendMessageButton addTarget:self action:@selector(sendMessageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.emojiCateScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(40, 160, self.frame.size.width-80, 40)];
    [self addSubview:self.emojiCateScrollView];
    self.emojiCateScrollView.backgroundColor=[UIColor yellowColor];
    self.emojiCateScrollView.contentSize=CGSizeMake(self.frame.size.width-79, 40);

}

+(BOOL)requiresConstraintBasedLayout{
    return YES;
}


-(void) sendMessageButtonClick:(UIButton *)sender{
    [self.delegate didclickSend];
}

- (NSUInteger)getNumOfSections:(EmojiCategory *)emojiCate{
    int divNum=0;
    if(emojiCate==nil||emojiCate.emojiKind<1){
        return 0;
    }else{
        if(emojiCate.emojiKind==1){
            divNum=20;
        }else{
            divNum=8;
        }
    }
    NSUInteger page=ceil((float)emojiCate.EmojiItems.count/divNum);
    return page;
}

- (NSUInteger)getSectionIndexByEmojiCateIndex:(NSUInteger)index{
    int sum=0;
    for(int i=0;i<index;i++){
        sum+=[self getNumOfSections:self.allEmojiModel.allEmojis[i]];
    }
    return sum;
}

-(void) initWithAllEmojiModel:(AllEmojiModel *)allEmojiModel{
    self.allEmojiModel=allEmojiModel;
    for(int i=0;i<self.allEmojiModel.allEmojis.count;i++){
        UIButton *cateButton=[[UIButton alloc]initWithFrame:CGRectMake(i*40, 0, 40, 40)];
        [cateButton setImage:[UIImage imageNamed:self.allEmojiModel.allEmojis[i].cateImg] forState:UIControlStateNormal];
        [cateButton setTag:i];
        [cateButton addTarget:self action:@selector(changeEmojiCate:) forControlEvents:UIControlEventTouchUpInside];
        [self.emojiCateScrollView addSubview:cateButton];
    }
    
    [self.emojiArea reloadData];
}

-(void) changeEmojiCate:(UIButton *)sender{
    if(self.currentEmojiCateIndex==sender.tag){
        return;
    }
    [self changeEmojiListTo:(int)sender.tag];
}


-(void) changeEmojiListTo:(int)cateIndex{
    self.currentEmojiCateIndex=cateIndex;
    self.emojiControl.numberOfPages=[self getNumOfSections:self.allEmojiModel.allEmojis[cateIndex]];
    self.emojiControl.currentPage=0;
    NSIndexPath* indexPath=[NSIndexPath indexPathForItem:0 inSection:[self getSectionIndexByEmojiCateIndex:cateIndex]];
    [self.emojiArea scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}

-(EmojiItem *) caculateEmojiItemForIndexpath:(NSIndexPath *)indexPath{
    NSInteger section=indexPath.section;
    NSInteger item=indexPath.item;
    
    for(EmojiCategory *emojiCate in self.allEmojiModel.allEmojis){
        if(section >=[self getNumOfSections:emojiCate]){
            section-=[self getNumOfSections:emojiCate];
        }else break;
    }

    if(item%20==0&&item>0){
        //删除键
        EmojiItem *deleteEmoji=[EmojiItem new];
        deleteEmoji.Word=@"delete";
        return deleteEmoji;
    }else{
        //正常表情
        int index=floor((float)item/3)+(item%3)*7+section*20;
        
        if(index<self.allEmojiModel.allEmojis[self.currentEmojiCateIndex].EmojiItems.count)
        {
            return self.allEmojiModel.allEmojis[self.currentEmojiCateIndex].EmojiItems[index];
        }else{
            //空白区域
            return [EmojiItem new];
        }
    }
    
}

-(NSUInteger)caculateCateIndexBySection:(NSUInteger)section{
    NSUInteger cateIndex=0;
    while(section>=[self getNumOfSections:self.allEmojiModel.allEmojis[cateIndex]]){
        section-=[self getNumOfSections:self.allEmojiModel.allEmojis[cateIndex]];
        cateIndex++;
    }
    return cateIndex;
}

#pragma mark - collectionView代理
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    int sum=0;
    for(EmojiCategory *emojiCate in self.allEmojiModel.allEmojis){
        sum+=[self getNumOfSections:emojiCate];
    }
    return sum;
//    return [[self.sectionNumForEachList valueForKeyPath:@"@sum.intValue"] intValue];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 21;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    self.currentEmojiCateIndex=[self caculateCateIndexBySection:indexPath.section];
    
    EmojiItemViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"EmojiItemViewCell" forIndexPath:indexPath];
    cell.backgroundColor=collectionView.backgroundColor;
    cell.emoji=[self caculateEmojiItemForIndexpath:indexPath];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((int)self.ScreenWidth/7, 40);
    
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0,0,0,0);
}


// UICollectionViewCell最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

// UICollectionViewCell最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    EmojiItem * emoji=[self caculateEmojiItemForIndexpath:indexPath];
    [self.delegate didclickEmoji:emoji];
    NSLog(@"emoji img :%@",emoji.Word);
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    int section=round(targetContentOffset->x/_ScreenWidth);
    int emojiCateIndex=(int)[self caculateCateIndexBySection:section];
    
    self.emojiControl.numberOfPages=[self getNumOfSections:self.allEmojiModel.allEmojis[emojiCateIndex]];
    for(int i=0;i<self.allEmojiModel.allEmojis.count;i++){
        if(section>=[self getNumOfSections:self.allEmojiModel.allEmojis[i]]){
            section-=[self getNumOfSections:self.allEmojiModel.allEmojis[i]];
        }else break;
    }
    self.emojiControl.currentPage=section;
}

@end

//
//  EmojiKeyboardView.m
//  EmojiKeyBoard
//
//  Created by zou on 2018/9/19.
//  Copyright © 2018年 zou. All rights reserved.
//

#import "EmojiKeyboardView.h"
#import "SlideLineButton.h"


@interface EmojiKeyboardView()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

//emoji区 UIcollectionview
@property (nonatomic,strong) UICollectionView *emojiArea;

//下方pagecontrol圆点
@property (nonatomic,strong) UIPageControl *emojiControl;

//左下+号button
@property (nonatomic,strong) SlideLineButton *addEmojiCateButton;

//发送button
@property (nonatomic,strong) SlideLineButton *sendMessageButton;

//删除表情button
@property (nonatomic,strong) SlideLineButton *deleteEmojiButton;

//下方表情类别
@property (nonatomic,strong) UIScrollView *emojiCateScrollView;

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
    self.screenWidth=[UIScreen mainScreen].bounds.size.width;
    self.currentEmojiCateIndex=0;
    self.allEmojiModel=[[AllEmojiModel alloc]init];
}


-(void)createUI{
    self.backgroundColor=[UIColor colorWithWhite:0.95 alpha:1];
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];

    //emoji区 UICollectionView
    self.emojiArea = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 120) collectionViewLayout:layout];
    
    [self addSubview:self.emojiArea];
    self.emojiArea.delegate = self;
    self.emojiArea.dataSource = self;
    self.emojiArea.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    self.emojiArea.pagingEnabled = YES;
    self.emojiArea.showsHorizontalScrollIndicator = NO;
    self.emojiArea.showsVerticalScrollIndicator = NO;
    [self.emojiArea registerClass:[EmojiItemViewCell class] forCellWithReuseIdentifier:@"EmojiItemViewCell"];
    
    //pageControl 圆点标识
    self.emojiControl=[[UIPageControl alloc]initWithFrame:CGRectMake(0, 120, self.frame.size.width, 40)];
    [self addSubview:self.emojiControl];
    self.emojiControl.numberOfPages=3;
    self.emojiControl.backgroundColor=[UIColor colorWithWhite:0.95 alpha:1];
    self.emojiControl.currentPageIndicatorTintColor=[UIColor grayColor];
    self.emojiControl.pageIndicatorTintColor=[UIColor lightGrayColor];

    //+号button
//    self.addEmojiCateButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 160, 40, 40)];
    self.addEmojiCateButton = [[SlideLineButton alloc]initWithFrame:CGRectMake(0, 160, 40, 40)
                                                   SlideButtonStyle:slideButtonStyleRight
                                                           andColor:[UIColor lightGrayColor]];
    [self addSubview:self.addEmojiCateButton];
    [self.addEmojiCateButton setTitle:@"+" forState:UIControlStateNormal];
    [self.addEmojiCateButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.addEmojiCateButton addTarget:self action:@selector(addEmojiCateButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.addEmojiCateButton setBackgroundColor:[UIColor whiteColor]];
    
    //删除emoji按钮
    self.deleteEmojiButton =[[SlideLineButton alloc]initWithFrame:CGRectMake(self.frame.size.width-80,160 , 40, 40)
                                                 SlideButtonStyle:slideButtonStyleLeft
                                                         andColor:[UIColor lightGrayColor]];
    [self addSubview:self.deleteEmojiButton];
    [self.deleteEmojiButton setTitle:@"del" forState:UIControlStateNormal];
    [self.deleteEmojiButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.deleteEmojiButton addTarget:self action:@selector(deleteEmojiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.deleteEmojiButton setBackgroundColor:[UIColor whiteColor]];
    
    //发送消息button
    self.sendMessageButton = [[SlideLineButton alloc]initWithFrame:CGRectMake(self.frame.size.width-40,160 , 40, 40)
                                                   SlideButtonStyle:slideButtonStyleLeft
                                                           andColor:[UIColor lightGrayColor]];
    [self addSubview:self.sendMessageButton];
    [self.sendMessageButton setTitle:@"发送" forState:UIControlStateNormal];
    [self.sendMessageButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.sendMessageButton addTarget:self action:@selector(sendMessageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.sendMessageButton setBackgroundColor:[UIColor whiteColor]];
    
    
    
    //表情类别图标 UIScrollView
    self.emojiCateScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(40, 160, self.frame.size.width-120, 40)];
    [self addSubview:self.emojiCateScrollView];
    self.emojiCateScrollView.backgroundColor=[UIColor whiteColor];
    self.emojiCateScrollView.contentSize=CGSizeMake(self.frame.size.width-119, 40);
    self.emojiCateScrollView.showsHorizontalScrollIndicator = NO;
    self.emojiCateScrollView.showsVerticalScrollIndicator = NO;

}

- (void)drawRect:(CGRect)rect{
    
    
    [super drawRect:rect];
}

//controller 中数据源发生变化后需要调用此方法进行重新配置view
- (void)reloadAllData:(AllEmojiModel *)emojiModel {
    self.allEmojiModel = emojiModel;
    [self initCatePanelWithAllEmojiModel:self.allEmojiModel];
    [self.emojiArea reloadData];
}


+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

//委托
- (void)addEmojiCateButtonClick:(SlideLineButton *)sender {
    NSLog(@"add emoji button click");
    [self.delegate didClickAdd];
    if ([self.delegate respondsToSelector:@selector(didClickAdd)]) {
        [self.delegate didClickAdd];
    }
}

//委托 对应的Controller中实现didclickSend方法
- (void)sendMessageButtonClick:(SlideLineButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didClickSend)]) {
        [self.delegate didClickSend];
    }
}

//委托
- (void) deleteEmojiButtonClick:(SlideLineButton *)sender {
    if([self.delegate respondsToSelector:@selector(didClickDelete)]){
        [self.delegate didClickDelete];
    }
    if(self.didDeleteHandler) {
        self.didDeleteHandler();
    }
}

/*
 * 1.传入indexpath 计算对应的emojiItem
 * 2.可能是空emoji/正常emoji
 * 3.emojiItem.imgName 为空或者是img
 *   emojiItem.word 为空，emojiword
 */
-(EmojiItem *) getEmojiItemByIndexpath:(NSIndexPath *)indexPath{
    NSUInteger section = indexPath.section;
    NSUInteger item = indexPath.item;
    EmojiCategory *currentEmojiCate = self.allEmojiModel.allEmojis[section];
    NSUInteger numInOnePage = currentEmojiCate.rowNum*3;
    NSUInteger pageIndex = item/numInOnePage;
    item = item - pageIndex * numInOnePage;
    item = (item%3)*currentEmojiCate.rowNum +item/3 + pageIndex * numInOnePage;
    
    return currentEmojiCate.emojiItems[item];
    

}


/*
 * 用一个AllEmojiModel对象初始化此view
 */
- (void)initCatePanelWithAllEmojiModel:(AllEmojiModel *)allEmojiModel{
    [self.emojiCateScrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    for(int i=0; i<allEmojiModel.allEmojis.count; i++){
        //下方表情类别按钮
        SlideLineButton *cateSlideButton = [[SlideLineButton alloc]initWithFrame:CGRectMake(i*40, 0, 40, 40) SlideButtonStyle:slideButtonStyleRight andColor:[UIColor lightGrayColor]];
        cateSlideButton.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        [cateSlideButton setImage:[UIImage imageNamed:allEmojiModel.allEmojis[i].cateImg] forState:UIControlStateNormal];
        [cateSlideButton setTag:i];
        [cateSlideButton addTarget:self action:@selector(changeEmojiCate:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.emojiCateScrollView addSubview:cateSlideButton];
    }
}

/*
 * 1.根据下方scrollview中button tag跳转
 * 2.sbutton action
 */
- (void)changeEmojiCate:(UIButton *)sender{
    [self changeEmojiListTo:(int)sender.tag];
}

/*
 * 1. 跳转到对应类别的页面
 * 2. 修改pagecontrol小圆点个数和currentpage
 * 3. 根据cateindex计算section，生成对饮的indexpath并跳转
 */
- (void)changeEmojiListTo:(int)cateIndex{
    self.currentEmojiCateIndex=cateIndex;
    EmojiCategory *emojiCate = self.allEmojiModel.allEmojis[cateIndex];
    
    self.emojiControl.numberOfPages=ceil((double)emojiCate.emojiItems.count/(emojiCate.rowNum*3));
    
    self.emojiControl.currentPage = 0;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:cateIndex];
    [self.emojiArea scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

#pragma mark - collectionView代理
//section数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.allEmojiModel.allEmojis.count;
}

//每个section中emoji数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.allEmojiModel.allEmojis[section].emojiItems.count;
}

//indexpath对应的cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    EmojiItemViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EmojiItemViewCell" forIndexPath:indexPath];
    cell.backgroundColor = collectionView.backgroundColor;
    cell.emoji = [self getEmojiItemByIndexpath:indexPath];
    return cell;
}


//indexpath对应cell大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    
    EmojiCategory *emojiCate = self.allEmojiModel.allEmojis[indexPath.section];
    NSInteger width = floor((float)self.screenWidth/(emojiCate.rowNum));
    NSInteger item = indexPath.item;
    NSInteger rowNum = emojiCate.rowNum;
    NSInteger subLength = self.screenWidth % rowNum;
    
    //判断是否是右边界的emoji 如果是 宽度需要加长sublength ，使得一行表情宽度和等于屏幕宽度
    if(((item/3+1)%rowNum) == 0){
        width += subLength;
    }
    return CGSizeMake(width, 40);
    
}

//section 对应的inset
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

//点击emoji
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    EmojiItem * emoji=[self getEmojiItemByIndexpath:indexPath];
    if(emoji==nil){

    }else{
        if ([self.delegate respondsToSelector:@selector(didClickEmoji:)]){
            [self.delegate didClickEmoji:emoji];
            NSLog(@"emoji img :%@",emoji.word);
        }
    }
   
}

#pragma mark - scrollview delegate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    int section = 0;
    EmojiCategory *emojiCate;
    int pageNum=0;
    CGFloat targetOffsetX = targetContentOffset ->x;
    while(targetOffsetX >= 0) {
        emojiCate= self.allEmojiModel.allEmojis[section];
        pageNum = ceil((double)emojiCate.emojiItems.count/(emojiCate.rowNum*3));
        targetOffsetX -= pageNum*self.screenWidth;
        section++;
    }
    self.currentEmojiCateIndex = --section;
    targetOffsetX +=pageNum*self.screenWidth;
    self.emojiControl.numberOfPages = pageNum;
    self.emojiControl.currentPage = ceil(targetOffsetX/self.screenWidth);
    
}


@end

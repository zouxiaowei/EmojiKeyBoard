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
    self.backgroundColor=[UIColor whiteColor];
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];

    //emoji区 UICollectionView
    self.emojiArea = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 120) collectionViewLayout:layout];
    
    [self addSubview:self.emojiArea];
    self.emojiArea.delegate = self;
    self.emojiArea.dataSource = self;
    self.emojiArea.backgroundColor = [UIColor whiteColor];
    self.emojiArea.pagingEnabled = YES;
    self.emojiArea.showsHorizontalScrollIndicator = NO;
    self.emojiArea.showsVerticalScrollIndicator = NO;
    [self.emojiArea registerClass:[EmojiItemViewCell class] forCellWithReuseIdentifier:@"EmojiItemViewCell"];
    
    //pageControl 圆点标识
    self.emojiControl=[[UIPageControl alloc]initWithFrame:CGRectMake(0, 120, self.frame.size.width, 40)];
    [self addSubview:self.emojiControl];
    self.emojiControl.numberOfPages=3;
    self.emojiControl.backgroundColor=[UIColor whiteColor];
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
    
    //删除emoji按钮
    self.deleteEmojiButton =[[SlideLineButton alloc]initWithFrame:CGRectMake(self.frame.size.width-80,160 , 40, 40)
                                                 SlideButtonStyle:slideButtonStyleLeft
                                                         andColor:[UIColor lightGrayColor]];
    [self addSubview:self.deleteEmojiButton];
    [self.deleteEmojiButton setTitle:@"delete" forState:UIControlStateNormal];
    [self.deleteEmojiButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.deleteEmojiButton addTarget:self action:@selector(deleteEmojiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //发送消息button
//    self.sendMessageButton=[[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width-40,160 , 40, 40)];
    self.sendMessageButton = [[SlideLineButton alloc]initWithFrame:CGRectMake(self.frame.size.width-40,160 , 40, 40)
                                                   SlideButtonStyle:slideButtonStyleLeft
                                                           andColor:[UIColor lightGrayColor]];
    [self addSubview:self.sendMessageButton];
    [self.sendMessageButton setTitle:@"发送" forState:UIControlStateNormal];
    [self.sendMessageButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.sendMessageButton addTarget:self action:@selector(sendMessageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    //表情类别图标 UIScrollView
    self.emojiCateScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(40, 160, self.frame.size.width-80, 40)];
    [self addSubview:self.emojiCateScrollView];
    self.emojiCateScrollView.backgroundColor=[UIColor whiteColor];
    self.emojiCateScrollView.contentSize=CGSizeMake(self.frame.size.width-79, 40);

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
- (void)addEmojiCateButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didClickAdd)]) {
        [self.delegate didClickAdd];
    }
}

//委托 对应的Controller中实现didclickSend方法
- (void)sendMessageButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didClickSend)]) {
        [self.delegate didClickSend];
    }
}

//委托
- (void) deleteEmojiButtonClick:(UIButton *)sender {
    if([self.delegate respondsToSelector:@selector(didClickDelete)]){
        [self.delegate didClickDelete];
    }
}

/*
 * 1. 传入一组表情，计算该表情占多少页
 * 2. EmojiCategory 中包含 emoji数据 类别图标 表情类别
 * 3. 返回page数根据emoji数据量和表情类别确定
 */
//- (NSUInteger)getNumOfSections:(EmojiCategory *)emojiCate{
//    long divNum=0;
//    if(emojiCate==nil){
//        return 0;
//    }else{
//        divNum = emojiCate.rowNum*kEmojiCollumNum;
//    }
//    NSUInteger page=ceil((float)emojiCate.EmojiItems.count/divNum);
//    return page;
//}

/*
 * 1. 传入表情index（如emoji表情 0 ，颜文字 1，动作 2）
 * 2. 输出该类表情起始section（即返回其前面所有表情页数）
 */
//- (NSUInteger)getSectionIndexByEmojiCateIndex:(NSUInteger)index{
//    int sum=0;
//    for(int i=0;i<index;i++){
//        sum+=[self getNumOfSections:self.allEmojiModel.allEmojis[i]];
//    }
//    return sum;
//}


/*
 * 1.传入indexpath 计算对应的emojiItem
 * 2.可能是空emoji/正常emoji/删除emoji
 * 3.emojiItem.imgName 为空或者是img
 *   emojiItem.word 为空，emojiword，delete
 */
-(EmojiItem *) getEmojiItemByIndexpath:(NSIndexPath *)indexPath{
    NSUInteger section = indexPath.section;
    NSUInteger item = indexPath.item;
    EmojiCategory *currentEmojiCate = self.allEmojiModel.allEmojis[section];
    NSUInteger numInOnePage = currentEmojiCate.rowNum*3;
    NSUInteger pageIndex = item/numInOnePage;
    item = item - pageIndex * numInOnePage;
    item = (item%3)*currentEmojiCate.rowNum +item/3 + pageIndex * numInOnePage;
    
    return currentEmojiCate.EmojiItems[item];
    
//    self.currentEmojiCateIndex=[self getCateIndexBySection:indexPath.section];
//    EmojiKind emojiKind=self.allEmojiModel.allEmojis[self.currentEmojiCateIndex].emojiKind;
//
//    for(EmojiCategory *emojiCate in self.allEmojiModel.allEmojis){
//        if(section >=[self getNumOfSections:emojiCate]){
//            section-=[self getNumOfSections:emojiCate];
//        }else break;
//    }
//
//    switch (emojiKind) {
//        case EmojiKindNormal:{
//            //emoji表情 3*7 每页20个表情 1个删除
//            if(item%20==0&&item>0){
//                //删除键
//                EmojiItem *deleteEmoji=[EmojiItem new];
//                deleteEmoji.Word=@"delete";
//                return deleteEmoji;
//            }else{
//                //横纵section.item映射
//                int index=floor((float)item/3)+(item%3)*7+section*20;
//
//                if(index<self.allEmojiModel.allEmojis[self.currentEmojiCateIndex].EmojiItems.count){
//                    //正常表情
//                    return self.allEmojiModel.allEmojis[self.currentEmojiCateIndex].EmojiItems[index];
//                }else{
//                    //空白区域
//                    return [EmojiItem new];
//                }
//            }
//        }
//            break;
//        case EmojiKindText:{
//            //文字表情 3*3 每页8个表情 1个删除
//            if(item%8==0&&item>0){
//                //删除键
//                EmojiItem *deleteEmoji=[EmojiItem new];
//                deleteEmoji.Word=@"delete";
//                return deleteEmoji;
//            }else{
//                //横纵section.item映射
//                int index=floor((float)item/3)+(item%3)*3+section*8;
//
//                if(index<self.allEmojiModel.allEmojis[self.currentEmojiCateIndex].EmojiItems.count){
//                    //正常表情
//                    return self.allEmojiModel.allEmojis[self.currentEmojiCateIndex].EmojiItems[index];
//                }else{
//                    //空白区域
//                    return [EmojiItem new];
//                }
//            }
//        }
//        default:
//            break;
//    }


}

/*
 * 1.传入section，计算当前是第几类表情
 */
//-(NSUInteger)getCateIndexBySection:(NSUInteger)section{
//    NSUInteger cateIndex = 0;
//    while(section >= [self getNumOfSections:self.allEmojiModel.allEmojis[cateIndex]]){
//        section -= [self getNumOfSections:self.allEmojiModel.allEmojis[cateIndex]];
//        cateIndex++;
//    }
//    return cateIndex;
//}

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
    
    self.emojiControl.numberOfPages=ceil((double)emojiCate.EmojiItems.count/(emojiCate.rowNum*3));
//    self.emojiControl.currentPage=0;
//    NSIndexPath* indexPath=[NSIndexPath indexPathForItem:0 inSection:[self getSectionIndexByEmojiCateIndex:cateIndex]];
    
    self.emojiControl.currentPage = 0;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:cateIndex];
    [self.emojiArea scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

#pragma mark - collectionView代理
//section数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
//    int sum=0;
//    for(EmojiCategory *emojiCate in self.allEmojiModel.allEmojis){
//        sum += [self getNumOfSections:emojiCate];
//    }
//    return sum;
    
    return self.allEmojiModel.allEmojis.count;
}

//每个section中emoji数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    NSUInteger cateIndex = [self getCateIndexBySection:section];
//    EmojiCategory *emojiCate = self.allEmojiModel.allEmojis[cateIndex];
//    return emojiCate.rowNum*kEmojiCollumNum;
//    if(emojiKind == EmojiKindNormal){
//       return 21;
//    }else if(emojiKind==EmojiKindText){
//        return 9;
//    }else{
//        return 0;
//    }
    return self.allEmojiModel.allEmojis[section].EmojiItems.count;
}

//indexpath对应的cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
//    self.currentEmojiCateIndex = [self getCateIndexBySection:indexPath.section];
//    EmojiItemViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EmojiItemViewCell" forIndexPath:indexPath];
//    cell.backgroundColor = collectionView.backgroundColor;
//    cell.emoji = [self getEmojiItemByIndexpath:indexPath];
    
    EmojiItemViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EmojiItemViewCell" forIndexPath:indexPath];
    cell.backgroundColor = collectionView.backgroundColor;
    cell.emoji = [self getEmojiItemByIndexpath:indexPath];// self.allEmojiModel.allEmojis[indexPath.section].EmojiItems[indexPath.item];
    return cell;
}


//indexpath对应cell大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    NSUInteger cateIndex=[self getCateIndexBySection:indexPath.section];
//    EmojiKind emojiKind=self.allEmojiModel.allEmojis[cateIndex].emojiKind;
//
//    if(emojiKind==EmojiKindNormal){
//        return CGSizeMake((int)self.screenWidth/7, 40);
//    }else{
//        return CGSizeMake((int)self.screenWidth/3, 40);
//    }
    
    EmojiCategory *emojiCate = self.allEmojiModel.allEmojis[indexPath.section];
    return CGSizeMake((int)self.screenWidth/(emojiCate.rowNum), 40);
    
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

    }else if([emoji.Word isEqualToString:@"delete"]){
        if ([self.delegate respondsToSelector:@selector(didClickDelete)]) {
            [self.delegate didClickDelete];
        }
    }else{
        if ([self.delegate respondsToSelector:@selector(didClickEmoji:)]) {
            [self.delegate didClickEmoji:emoji];
        }
    }
    NSLog(@"emoji img :%@",emoji.Word);
}

#pragma mark - scrollview delegate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    int section = 0;
    EmojiCategory *emojiCate;
    int pageNum=0;
    CGFloat targetOffsetX = targetContentOffset ->x;
    while(targetOffsetX >= 0) {
        emojiCate= self.allEmojiModel.allEmojis[section];
        pageNum = ceil((double)emojiCate.EmojiItems.count/(emojiCate.rowNum*3));
        targetOffsetX -= pageNum*self.screenWidth;
        section++;
    }
    self.currentEmojiCateIndex = --section;
    targetOffsetX +=pageNum*self.screenWidth;
    self.emojiControl.numberOfPages = pageNum;
    self.emojiControl.currentPage = ceil(targetOffsetX/self.screenWidth);
    
//    int section = round(targetContentOffset->x / _screenWidth);
//    self.currentEmojiCateIndex=(int)[self getCateIndexBySection:section];
//
//    self.emojiControl.numberOfPages = [self getNumOfSections:self.allEmojiModel.allEmojis[self.currentEmojiCateIndex]];
//    for(int i=0;i<self.allEmojiModel.allEmojis.count;i++){
//        if(section>=[self getNumOfSections:self.allEmojiModel.allEmojis[i]]){
//            section-=[self getNumOfSections:self.allEmojiModel.allEmojis[i]];
//        }else break;
//    }
//    self.emojiControl.currentPage=section;
}


@end

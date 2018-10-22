//
//  ViewController.m
//  EmojiKeyBoard
//
//  Created by zou on 2018/9/19.
//  Copyright © 2018年 zou. All rights reserved.
//

#import "ViewController.h"
#import "EmojiKeyboardView.h"
#import <Masonry/Masonry.h>

typedef NS_ENUM(NSInteger, CurrentKeyBoardType){
    currentKeyBoardTypeNone,       //无键盘
    currentKeyBoardTypeNormal,     //常规键盘
    currentKeyBoardTypeEmoji,      //表情键盘
};

@interface ViewController ()<UITextViewDelegate,EmojiKeyboardViewDelegate>

@property (nonatomic) CurrentKeyBoardType currentKeyBoardType;
@property (nonatomic,strong) UITextView *inputTextView;
@property (nonatomic,strong) UIButton *emojiKeyboardButton;

@property (nonatomic,strong) EmojiKeyboardView *emojiKeyboardView;
@property (nonatomic,strong) AllEmojiModel *allEmojiModel;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    [self createUI];
    [self loadData];
}

- (void)setup{
    self.currentKeyBoardType = currentKeyBoardTypeNone;
    self.allEmojiModel = [[AllEmojiModel alloc]init];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keyBoardWillShow:)
                                                name:UIKeyboardWillShowNotification
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keyBoardWillHide:)
                                                name:UIKeyboardWillHideNotification
                                              object:nil];
}

- (void)createUI{
    self.view.backgroundColor = [UIColor whiteColor];
    
    //输出框
    self.inputTextView = [[UITextView alloc]init];
    self.inputTextView.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:self.inputTextView];
    self.inputTextView.delegate = self;
    [self.inputTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.height.equalTo(@40);
        make.bottom.equalTo(self.view);
        make.width.equalTo(@(self.view.bounds.size.width-40));
    }];
    
    //表情键盘开关
    self.emojiKeyboardButton = [[UIButton alloc]init];
    [self.view addSubview:self.emojiKeyboardButton];
    [self.emojiKeyboardButton setBackgroundColor:[UIColor grayColor]];
    [self.emojiKeyboardButton setTitle:@"emo" forState:UIControlStateNormal];
    [self.emojiKeyboardButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.inputTextView.mas_right);
        make.bottom.equalTo(self.inputTextView);
        make.height.equalTo(@40);
        make.width.equalTo(@40);
    }];
    [self.emojiKeyboardButton addTarget:self
                                 action:@selector(changeKeyboard:)
                       forControlEvents:UIControlEventTouchUpInside];
    
    //表情键盘
    self.emojiKeyboardView = [[EmojiKeyboardView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    self.emojiKeyboardView.delegate = self;
    [self.view addSubview:self.emojiKeyboardView];
    [self.emojiKeyboardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.equalTo(@200);
        
    }];
    [self.emojiKeyboardView setHidden:YES];

}

- (void)loadData {
    NSMutableArray<EmojiItem *> *emojis = [NSMutableArray array];
    NSMutableArray<EmojiItem *> *textEmojis = [NSMutableArray array];
    NSMutableArray<EmojiItem *> *wordsEmojis = [NSMutableArray array];
    
    //emoji表情
    NSString *emojiPath = [[NSBundle mainBundle] pathForResource:@"emoji" ofType:@"plist"];
    NSArray <EmojiItem *> *emojiList = [NSArray arrayWithContentsOfFile:emojiPath];
    for(NSDictionary *emoji in emojiList){
        EmojiItem *emojiObj = [[EmojiItem alloc]init];
        emojiObj.word = emoji[@"Word"];
        emojiObj.imageName = emoji[@"ImageName"];
        [emojis addObject:emojiObj];
    }
    int pageNum = ceil((float)emojis.count/21);
    while (emojis.count < pageNum*21){
        [emojis addObject:[EmojiItem new]];
    }
    EmojiCategory *aEmojiCate = [EmojiCategory new];
    aEmojiCate.emojiItems = emojis;
    aEmojiCate.emojiKind = EmojiKindNormal;
    aEmojiCate.cateImg = @"alien";
    aEmojiCate.rowNum = 7;
    
    //读取颜文字
    NSString *path1 = [[NSBundle mainBundle]pathForResource:@"emotion" ofType:@"txt"];
    NSArray *lines1 = [NSArray arrayWithArray:[[NSString stringWithContentsOfFile:path1
                                                                        encoding:NSUTF8StringEncoding
                                                                           error:nil]
                                               componentsSeparatedByString:@"\n"]];
    for(NSString *textEmoji in lines1){
        EmojiItem *tempEmoji = [EmojiItem new];
        tempEmoji.word = [textEmoji stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        tempEmoji.imageName = nil;
        [textEmojis addObject:tempEmoji];
    }
    EmojiCategory *textEmojiCate = [EmojiCategory new];
    textEmojiCate.emojiItems = textEmojis;
    textEmojiCate.emojiKind = EmojiKindText;
    textEmojiCate.cateImg = @"zzz";
    textEmojiCate.rowNum = 3;
    int pageNum2 = ceil((float)textEmojis.count/21);
    while (textEmojis.count < pageNum2*9){
        [textEmojis addObject:[EmojiItem new]];
    }
    
    //读取动作
    NSString *path2=[[NSBundle mainBundle]pathForResource:@"words" ofType:@"txt"];
    NSArray *lines2=[NSArray arrayWithArray:[[NSString stringWithContentsOfFile:path2
                                                                       encoding:NSUTF8StringEncoding
                                                                          error:nil]
                                             componentsSeparatedByString:@"\n"]];
    
    for(NSString *wordsEmoji in lines2){
        EmojiItem *tempEmoji = [EmojiItem new];
        tempEmoji.word = [wordsEmoji stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        tempEmoji.imageName = nil;
        [wordsEmojis addObject:tempEmoji];
    }
    
    EmojiCategory *wordsEmojiCate = [EmojiCategory new];
    wordsEmojiCate.emojiItems = wordsEmojis;
    wordsEmojiCate.emojiKind = EmojiKindText;
    wordsEmojiCate.cateImg = @"x";
    wordsEmojiCate.rowNum = 3;
    int pageNum3 = ceil((float)wordsEmojis.count/9);
    while (wordsEmojis.count < pageNum3*9){
        [wordsEmojis addObject:[EmojiItem new]];
    }
    
    //构造emojiModel
    self.allEmojiModel.allEmojis = [NSArray arrayWithObjects:aEmojiCate,textEmojiCate,wordsEmojiCate,nil];
    
    [self.emojiKeyboardView reloadAllData:self.allEmojiModel]; //刷新数据源
}

//空白区域收回键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [self.emojiKeyboardView setHidden:YES];
    self.currentKeyBoardType=currentKeyBoardTypeNone;
    [self.inputTextView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
    }];
}

-(void)changeKeyboard:(UIButton *)sender{
    
    switch (self.currentKeyBoardType) {
            case currentKeyBoardTypeNormal:{
                //系统键盘下，打开表情键盘
                self.currentKeyBoardType=currentKeyBoardTypeEmoji;
                [self.inputTextView endEditing:YES];
                [self.emojiKeyboardView setHidden:NO];
                [self.inputTextView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(self.view).offset(-200);
                }];
            }
            break;
            case currentKeyBoardTypeNone:{
                //无键盘情况下，打开表情键盘
                self.currentKeyBoardType=currentKeyBoardTypeEmoji;
                [self.inputTextView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(self.view).offset(-200);
                }];
                [self.emojiKeyboardView setHidden:NO];
            
            }
            break;
            case currentKeyBoardTypeEmoji:{
                //表情键盘下，打开系统键盘
                self.currentKeyBoardType=currentKeyBoardTypeNormal;
                [self.emojiKeyboardView setHidden:YES];
                [self.inputTextView becomeFirstResponder];
                [self.inputTextView reloadInputViews];
            }
            break;
            
        default:
            break;
    }
}

#pragma mark - textview
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    self.currentKeyBoardType=currentKeyBoardTypeNormal;
    return YES;
}


#pragma mark --键盘的显示隐藏--
-(void)keyBoardWillShow:(NSNotification *)notification{
    //键盘最后的frame
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat height = keyboardFrame.size.height;
    //需要移动的距离
    if (height > 0) {
        [self.inputTextView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(-height);
        }];
        //[self.view updateConstraintsIfNeeded];
        
    }
}
-(void)keyBoardWillHide:(NSNotification *)notification{
    [self.inputTextView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
    }];
}


#pragma mark - emojiViewDelegate
- (void)didClickEmoji:(EmojiItem *)emojiItem{
    if(emojiItem.word){
        self.inputTextView.text=[self.inputTextView.text stringByAppendingString:emojiItem.word];
    }
}
- (void)didClickSend{
    NSLog(@"%@",self.inputTextView.text);
    self.inputTextView.text=@"";
}

- (void)didClickDelete{
    NSString *str=self.inputTextView.text;
    if(str.length>0){
        self.inputTextView.text=[str substringToIndex:str.length-1];
    }

}

- (void)didClickAdd {
    NSLog(@"delegate add click");

    return;
}

@end

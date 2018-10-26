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

@property (nonatomic,strong) NSTimer *timer;

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


/*
 * 1. 检查本地文件是否有emoji数据，有则读取，无则从工程资源中导入
 */
- (void)loadData {
    NSString *documentPath = [self documentPath];
    NSString *normalEmojiPath = [documentPath stringByAppendingPathComponent:@"emoji.plist"];
    NSString *wordEmojiPath = [documentPath stringByAppendingPathComponent:@"words.txt"];
    NSString *emotionPath = [documentPath stringByAppendingPathComponent:@"emotion.txt"];
    NSMutableArray *emojiCateArray = [NSMutableArray array];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:normalEmojiPath]){
        NSString *tempEmojiPath = [[NSBundle mainBundle] pathForResource:@"emoji" ofType:@"plist"];
        NSArray *emojiList = [[NSArray alloc]initWithContentsOfFile:tempEmojiPath];
        [emojiList writeToFile:normalEmojiPath atomically:YES];
    }
    
    if(![fileManager fileExistsAtPath:wordEmojiPath]){
        NSString *tempEmojiPath = [[NSBundle mainBundle] pathForResource:@"words" ofType:@"txt"];
        NSString *wordEmojis = [[NSString alloc]initWithContentsOfFile:tempEmojiPath encoding:NSUTF8StringEncoding error:nil];
        [wordEmojis writeToFile:wordEmojiPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    
    if(![fileManager fileExistsAtPath:emotionPath]){
        NSString *tempEmojiPath = [[NSBundle mainBundle] pathForResource:@"emotion" ofType:@"txt"];
        NSString *emotions = [[NSString alloc]initWithContentsOfFile:tempEmojiPath encoding:NSUTF8StringEncoding error:nil];
        [emotions writeToFile:emotionPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    
    EmojiCategory *aEmojiCate = [EmojiCategory emojiCateWithFile:normalEmojiPath emojiKind:EmojiKindNormal cateImg:@"alien" andRowNum:7];

    EmojiCategory *wordEmojiCate = [EmojiCategory emojiCateWithFile:wordEmojiPath emojiKind:EmojiKindText cateImg:@"zzz" andRowNum:3];

    EmojiCategory *emotionEmojiCate = [EmojiCategory emojiCateWithFile:emotionPath emojiKind:EmojiKindText cateImg:@"x" andRowNum:3];

    //构造emojiModel
    self.allEmojiModel.allEmojis = [NSArray arrayWithObjects:aEmojiCate,wordEmojiCate,emotionEmojiCate,nil];
    
    [self.emojiKeyboardView reloadAllData:self.allEmojiModel]; //刷新数据源
}

- (NSString *)documentPath{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    return documentPath;
}

- (NSArray *) emojiItemsFromFile:(NSString *)filePath andNumPerPage:(NSInteger)num{
    NSMutableArray<EmojiItem *> *emojiItems = [NSMutableArray array];
    
    if([filePath hasSuffix:@"plist"]){
        NSArray *plistNormalEmojis = [NSArray arrayWithContentsOfFile:filePath];
        for(NSDictionary *emoji in plistNormalEmojis){
            EmojiItem *emojiObj = [[EmojiItem alloc]init];
            emojiObj.word = emoji[@"Word"];
            emojiObj.imageName = emoji[@"ImageName"];
            [emojiItems addObject:emojiObj];
        }
    }else if([filePath hasSuffix:@"txt"]){
        NSString *linesString = [[NSString alloc]initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        NSArray *lines = [linesString componentsSeparatedByString:@"\r\n"];
        
        for(NSString *textEmoji in lines){
            EmojiItem *tempEmoji = [EmojiItem new];
            tempEmoji.word = [textEmoji stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            tempEmoji.imageName = nil;
            [emojiItems addObject:tempEmoji];
        }

    }
    
    int pageNum = ceil((float)emojiItems.count/num);
    while (emojiItems.count < pageNum*num){
        [emojiItems addObject:[EmojiItem new]];
    }
    
    return emojiItems;

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

- (void)startLongPressDelete{
    [self.timer invalidate];
    self.timer = nil;
    if (@available(iOS 10.0, *)) {
        self.timer = [NSTimer timerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            [self didClickDelete];
        }];
    } else {
        // Fallback on earlier versions
    }
    [[NSRunLoop mainRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
    
}

- (void)endLongPressDelete{
    [self.timer invalidate];
    self.timer = nil;
}

@end

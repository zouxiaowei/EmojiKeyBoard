//
//  ViewController.m
//  EmojiKeyBoard
//
//  Created by zou on 2018/9/19.
//  Copyright © 2018年 zou. All rights reserved.
//

#import "ViewController.h"
#import "AllEmojiModel.h"
#import "EmojiKeyboardView.h"
#import <Masonry/Masonry.h>
typedef NS_ENUM(NSInteger, CurrentKeyBoardType){
    currentKeyBoardTypeNone,       //无键盘
    currentKeyBoardTypeNormal,     //常规键盘
    currentKeyBoardTypeEmoji,      //表情键盘
};

@interface ViewController ()<UITextViewDelegate>
@property (nonatomic) CurrentKeyBoardType currentKeyBoardType;
//@property (nonatomic,strong)
@property (nonatomic,strong) UITextView *inputTextView;
@property (nonatomic,strong) UIButton *emojiKeyboardButton;
@property (nonatomic,strong) EmojiKeyboardView *emojiKeyboardView;
@property (nonatomic,strong) NSMutableArray<EmojiItem *> *emojis;
@property (nonatomic,strong) NSMutableArray<NSArray *> *emojiLists;
@property (nonatomic,strong) AllEmojiModel *allEmojiModel;
@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setup];
    [self createUI];
    
}

-(void)setup{
    
    self.emojis=[NSMutableArray array];
    self.emojiLists=[NSMutableArray array];
    self.currentKeyBoardType=currentKeyBoardTypeNone;
    self.allEmojiModel=[[AllEmojiModel alloc]init];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    NSString *emojiPath=[[NSBundle mainBundle]pathForResource:@"emoji" ofType:@"plist"];
    
    NSArray <EmojiItem *> *emojiList=[NSArray arrayWithContentsOfFile:emojiPath];
    
    for(NSDictionary *emoji in emojiList){
        EmojiItem *emojiObj=[[EmojiItem alloc]init];
        emojiObj.Word=emoji[@"Word"];
        emojiObj.ImageName=emoji[@"ImageName"];
        [self.emojis addObject:emojiObj];
    }
    EmojiCategory *aEmojiCate=[[EmojiCategory alloc]init];
    
    aEmojiCate.EmojiItems=self.emojis;
    aEmojiCate.emojiKind=EmojiKindNormal;
    aEmojiCate.cateImg=@"alien";
    self.allEmojiModel.allEmojis=[NSArray arrayWithObjects:aEmojiCate,aEmojiCate,aEmojiCate,nil];
    
    [self.emojiLists addObject:self.emojis];
    [self.emojiLists addObject:self.emojis];
    [self.emojiLists addObject:self.emojis];
    

    NSLog(@"asdadasd");

}
-(void)createUI{
    self.view.backgroundColor=[UIColor lightGrayColor];
    
    self.inputTextView=[[UITextView alloc]init];
    self.inputTextView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.inputTextView];
    self.inputTextView.delegate=self;
    [self.inputTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.height.equalTo(@40);
        make.bottom.equalTo(self.view);
        make.width.equalTo(@(self.view.bounds.size.width-40));
    }];
    
    
    self.emojiKeyboardButton=[[UIButton alloc]init];
    [self.view addSubview:self.emojiKeyboardButton];
    [self.emojiKeyboardButton setTitle:@"emo" forState:UIControlStateNormal];
    [self.emojiKeyboardButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.inputTextView.mas_right);
        make.bottom.equalTo(self.inputTextView);
        make.height.equalTo(@40);
        make.width.equalTo(@40);
    }];
    [self.emojiKeyboardButton addTarget:self action:@selector(changeKeyboard:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.emojiKeyboardView=[[EmojiKeyboardView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
//    [self.emojiKeyboardView initWithEmojiLists:self.emojiLists];
    [self.emojiKeyboardView initWithAllEmojiModel:self.allEmojiModel];
    [self.view addSubview:self.emojiKeyboardView];
    
    [self.emojiKeyboardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.equalTo(@200);
        
    }];
    [self.emojiKeyboardView updateConstraintsIfNeeded];
    [self.emojiKeyboardView setHidden:YES];
   
}


//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self.view endEditing:YES];
//    [self.emojiKeyboardView setHidden:YES];
//    self.currentKeyBoardType=currentKeyBoardTypeNone;
//    [self.inputTextView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.view);
//    }];
//}


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

//- (void)textViewDidBeginEditing:(UITextView *)textView{
//    self.currentKeyBoardType=currentKeyBoardTypeNormal;
//}

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

@end

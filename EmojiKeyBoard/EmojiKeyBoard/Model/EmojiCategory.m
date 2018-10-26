//
//  EmojiCategory.m
//  EmojiKeyBoard
//
//  Created by zou on 2018/9/25.
//  Copyright © 2018年 zou. All rights reserved.
//

#import "EmojiCategory.h"

@implementation EmojiCategory

+ (instancetype)emojiCateWithFile:(NSString *)filePath emojiKind:(EmojiKind)emojikind cateImg:(NSString *)cateImgUrl andRowNum:(NSInteger)num{
    
    EmojiCategory *aEmojiCate = [EmojiCategory new];
    aEmojiCate.emojiItems = [self emojiItemsFromFile:filePath andNumPerPage:num*3];
    aEmojiCate.emojiKind = EmojiKindNormal;
    aEmojiCate.cateImg = cateImgUrl;
    aEmojiCate.rowNum = num;
    
    return aEmojiCate;
}

+ (NSArray *) emojiItemsFromFile:(NSString *)filePath andNumPerPage:(NSInteger)num{
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

@end

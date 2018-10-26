//
//  BaseModel.h
//  yuxiCopy
//
//  Created by zou on 2018/8/10.
//  Copyright © 2018年 zou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject

- (instancetype)initWithDcitionary:(NSDictionary *)dict;
+ (instancetype)modelWithDictionary:(NSDictionary *)dict;

@end

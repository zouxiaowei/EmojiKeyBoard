//
//  BaseModel.m
//  yuxiCopy
//
//  Created by zou on 2018/8/10.
//  Copyright © 2018年 zou. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

- (instancetype)initWithDcitionary:(NSDictionary *)dict {
    if(self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
+ (instancetype)modelWithDictionary:(NSDictionary *)dict {
    return [[[self class] alloc] initWithDcitionary:dict];
}

@end

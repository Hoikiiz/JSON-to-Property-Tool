//
//  TGClassObject.m
//  JSONToProperty
//
//  Created by SunYang on 2017/10/31.
//  Copyright © 2017年 SunYang. All rights reserved.
//

#import "TGClassObject.h"

@implementation TGClassObject


+ (NSArray *)handleDictionary:(NSDictionary *)dict container:(NSMutableArray *)classes {
    NSMutableArray *temp = [NSMutableArray array];
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull value, BOOL * _Nonnull stop) {
        NSString *string;
        if ([value isKindOfClass:[NSNumber class]]) {
            string = [NSString stringWithFormat:@"@property (strong, nonatomic) NSNumber *%@;", key];
        }
        if ([value isKindOfClass:[NSString class]]) {
            string = [NSString stringWithFormat:@"@property (copy, nonatomic) NSString *%@;", key];
        }
        
        if ([value isKindOfClass:[NSDictionary class]]) {
            NSString *className = [@"Model" stringByAppendingString:key];
            string = [NSString stringWithFormat:@"@property (copy, nonatomic) %@ *%@;", className, key];
            if (![self hasClass:className classes:classes]) {
                TGClassObject *classObject = [TGClassObject new];
                classObject.className = className;
                classObject.properties = [TGClassObject handleDictionary:value container:classes];
                [classes addObject:classObject];
            }
            
        }
        
        if ([value isKindOfClass:[NSArray class]]) {
            NSString *className = [self handleArrayClass:[value firstObject] key:key];
            string = [NSString stringWithFormat:@"@property (copy, nonatomic) NSArray<%@ *> *%@;", className, key];
            if ([className containsString:@"Model"] && ![self hasClass:className classes:classes]) {
                TGClassObject *classObject = [TGClassObject new];
                classObject.className = className;
                classObject.properties = [TGClassObject handleArray:value container:classes];
                [classes addObject:classObject];
            }
        }
        [temp addObject:string];
    }];
    return [temp copy];
}

+ (NSArray *)handleArray:(NSArray *)array container:(NSMutableArray *)classes {
    
    id object = array.firstObject;
    
    if ([object isKindOfClass:[NSArray class]]) {
        return [self handleArray:object container:classes];
    } else {
        return [self handleDictionary:object container:classes];
    }
}

+ (NSString *)handleArrayClass:(id)object key:(NSString *)key{
    if ([object isKindOfClass:[NSNumber class]]) {
        return @"NSNumber";
    }
    else if ([object isKindOfClass:[NSString class]]) {
        return @"NSString";
    } else if ([object isKindOfClass:[NSArray class]]) {
        return [NSString stringWithFormat:@"NSArray<%@ *>", [self handleArrayClass:[object firstObject] key:key]];
    }
    else {
        return [NSString stringWithFormat:@"Model%@", key];
    }
}

+ (BOOL)hasClass:(NSString *)className classes:(NSArray<TGClassObject *> *)classes {
    for (TGClassObject *classObject in classes) {
        if ([className isEqualToString:classObject.className]) {
            return true;
        }
    }
    return false;
}

@end





























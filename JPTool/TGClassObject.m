//
//  TGClassObject.m
//  JSONToProperty
//
//  Created by SunYang on 2017/10/31.
//  Copyright © 2017年 SunYang. All rights reserved.
//

#import "TGClassObject.h"

@implementation TGClassObject


+ (NSArray *)handleDictionary:(NSDictionary *)dict container:(NSMutableArray<TGClassObject *> *)classes {
    NSMutableArray *temp = [NSMutableArray array];
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull value, BOOL * _Nonnull stop) {
        if ([value isKindOfClass:[NSNull class]]) {
            value = @"";
            [classes.firstObject.nullProperties addObject:key];
        }
        NSString *string;
        if ([value isKindOfClass:[NSNumber class]]) {
            string = [self handleNumberType:key];
        }
        if ([value isKindOfClass:[NSString class]]) {
            string = [NSString stringWithFormat:@"@property (copy, nonatomic) NSString *%@;", key];
        }
        
        if ([value isKindOfClass:[NSDictionary class]]) {
            NSString *className = [[key capitalizedString] stringByAppendingString:@"Model"];
            string = [NSString stringWithFormat:@"@property (strong, nonatomic) %@ *%@;", className, key];
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

+ (NSArray *)handleArray:(NSArray *)array container:(NSMutableArray<TGClassObject *> *)classes {
    
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
        return [NSString stringWithFormat:@"%@Model", [key capitalizedString]];
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

- (NSMutableArray<NSString *> *)nullProperties {
    if (_nullProperties == nil) {
        _nullProperties = [NSMutableArray array];
    }
    return _nullProperties;
}

+ (NSString *)handleNumberType:(NSString *)key {
    if (self.trueNumberType) {
        NSString * formatKey = [NSString stringWithFormat:@"\"%@\":", key];
        NSArray *lines = [self.metaJSONString componentsSeparatedByString:@"\n"];
        for (NSString *line in lines) {
            if ([line containsString:formatKey]) {
                NSLog(@"line is %@", line);
                NSString *value = [[[(NSString *)[line componentsSeparatedByString:@":"].lastObject stringByReplacingOccurrencesOfString:@"," withString:@""] stringByReplacingOccurrencesOfString:@"\"" withString:@""] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                if ([value containsString:@"."]) {
                    NSString *digPart = [value componentsSeparatedByString:@"."].lastObject;
                    if (digPart.length <= 8) {
                        return [NSString stringWithFormat:@"@property (assign, nonatomic) float %@;", key];
                    } else {
                        return [NSString stringWithFormat:@"@property (assign, nonatomic) double %@;", key];
                    }
                } else if ([value isEqualToString:@"true"] || [value isEqualToString:@"false"]){
                    return [NSString stringWithFormat:@"@property (assign, nonatomic) BOOL %@;", key];
                } else {
                    return [NSString stringWithFormat:@"@property (assign, nonatomic) NSInteger %@;", key];
                }
            }
        }
        return @"";
    } else {
        return [NSString stringWithFormat:@"@property (strong, nonatomic) NSNumber *%@;", key];
    }
}

#pragma Class Properties

static BOOL _trueNumberType;
static NSString *_metaJSONString;

+ (BOOL)trueNumberType {
    return _trueNumberType;
}

+ (void)setTrueNumberType:(BOOL)trueNumberType {
    _trueNumberType = trueNumberType;
}

+ (NSString *)metaJSONString {
    return _metaJSONString;
}

+ (void)setMetaJSONString:(NSString *)metaJSONString {
    _metaJSONString = metaJSONString;
}

@end





























//
//  TGClassObject.h
//  JSONToProperty
//
//  Created by SunYang on 2017/10/31.
//  Copyright © 2017年 SunYang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TGClassObject : NSObject

@property (copy, nonatomic) NSString *className;
@property (copy, nonatomic) NSArray *properties;
@property (assign, nonatomic, class) BOOL trueNumberType;
@property (copy, nonatomic, class) NSString *metaJSONString;

/**
 null values in JSON, defualt set to an empty string such as:
 
 "name": null -> "name": ""
 */
@property (strong, nonatomic) NSMutableArray<NSString *> *nullProperties;


+ (NSArray *)handleDictionary:(NSDictionary *)dict container:(NSMutableArray<TGClassObject *> *)classes;
+ (NSArray *)handleArray:(NSArray *)array container:(NSMutableArray<TGClassObject *> *)classes;
+ (NSString *)handleArrayClass:(id)object key:(NSString *)key;
@end

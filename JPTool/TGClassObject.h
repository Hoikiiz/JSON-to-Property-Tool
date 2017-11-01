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


+ (NSArray *)handleDictionary:(NSDictionary *)dict container:(NSMutableArray *)classes;
+ (NSArray *)handleArray:(NSArray *)array container:(NSMutableArray *)classes;
+ (NSString *)handleArrayClass:(id)object key:(NSString *)key;
@end

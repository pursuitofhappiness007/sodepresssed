//
//  Fountain+log.m
//  用分类重写字典和数组的打印
//
//  Created by romance on 15/6/5.
//  Copyright (c) 2015年 romance. All rights reserved.
//

#import <Foundation/Foundation.h>

@implementation NSDictionary(log)
-(NSString *)descriptionWithLocale:(id)locale{
    NSMutableString *str=[NSMutableString string];
    [str appendString:@"{\n"];
    //遍历所有字典
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [str appendFormat:@"%@=%@,\n",key,obj];
    }];
    [str appendString:@"}"];
    NSRange range=[str rangeOfString:@"," options:NSBackwardsSearch];
    if(range.length!=0){
        [str deleteCharactersInRange:range];}

    return str;
}
@end

@implementation NSArray(log)
-(NSString *)descriptionWithLocale:(id)locale{
        NSMutableString *str=[NSMutableString string];
        [str appendString:@"[\n"];
        //遍历所有字典
        [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [str appendFormat:@"%@,\n",obj];
        }        ];
       [str appendString:@"]"];
        NSRange range=[str rangeOfString:@"," options:NSBackwardsSearch];
    if(range.length!=0){
        [str deleteCharactersInRange:range];}
    
        return str;
    }



@end

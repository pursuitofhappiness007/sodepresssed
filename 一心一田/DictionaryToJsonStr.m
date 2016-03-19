//
//  DictionaryToJsonStr.m
//  一心一田餐饮
//
//  Created by xipin on 15/11/10.
//  Copyright © 2015年 yose. All rights reserved.
//

#import "DictionaryToJsonStr.h"

@implementation DictionaryToJsonStr
+(NSString *)dictToJsonStr:(NSDictionary *)dict{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;

}
+(NSDictionary *)JsonStrToDict:(NSString *)string{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return  [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
}
@end

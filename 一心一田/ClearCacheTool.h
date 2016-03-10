//
//  ClearCacheTool.h
//  一心一田餐饮
//
//  Created by xipin on 15/10/20.
//  Copyright © 2015年 yose. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClearCacheTool : NSObject
+(float)fileSizeAtPath:(NSString *)path;
+(float)folderSizeAtPath:(NSString *)path;
+(void)clearCache:(NSString *)path;
@end

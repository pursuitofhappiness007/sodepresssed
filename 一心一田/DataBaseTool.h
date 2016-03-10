//
//  DataBaseTool.h
//  广盐健康大厨房
//
//  Created by xipin on 15/11/25.
//  Copyright © 2015年 xipin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FMDatabase;

@interface DataBaseTool : NSObject
+(FMDatabase *)creatAdatabase:(NSString *)filename;
-(BOOL)select:(NSString *)sqlstring database:(FMDatabase *)db;
-(BOOL)update:(NSString *)urlstring database:(FMDatabase *)db;
-(BOOL)insert:(NSString *)sqlstring database:(FMDatabase *)db;
-(BOOL)deleteitem:(NSString *)sqlstring database:(FMDatabase *)db;


@end

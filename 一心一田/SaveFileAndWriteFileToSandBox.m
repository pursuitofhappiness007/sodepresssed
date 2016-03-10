//
//  SaveFileAndWriteFileToSandBox.m
//  整体框架搭建
//
//  Created by xipin on 15/8/24.
//  Copyright © 2015年 yose. All rights reserved.
//

#import "SaveFileAndWriteFileToSandBox.h"

@implementation SaveFileAndWriteFileToSandBox
static SaveFileAndWriteFileToSandBox  *_singletonInstance = nil;
+(SaveFileAndWriteFileToSandBox *)singletonInstance{
    @synchronized([SaveFileAndWriteFileToSandBox class])
    {
        if (!_singletonInstance)
            _singletonInstance = [[self alloc] init];
        return _singletonInstance;
    }
    
    return nil;


}
+(id)alloc
{
    @synchronized([SaveFileAndWriteFileToSandBox class])
    {
        NSAssert(_singletonInstance == nil, @"Attempted to allocate a second instance of a singleton.");
        _singletonInstance = [super alloc];
        return _singletonInstance;
    }
    
    return nil;
}
-(void)savefiletosandbox:(NSDictionary *)content filepath:(NSString *)filepath{
    
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *doc=[paths objectAtIndex:0];
    
    
    if(!doc){
        NSLog(@"目录未找到");
    }
    NSError *error;
    NSString *filepath1=[doc stringByAppendingPathComponent:filepath];
    
    NSData *jsondata=[NSJSONSerialization dataWithJSONObject:content options:kNilOptions error:&error];
    [jsondata writeToFile:filepath1 options:NSDataWritingAtomic error:&error];
//    NSString *str=[NSString stringWithFormat:@"%@",content];
//    [str writeToFile:filepath1 atomically:YES encoding:NSUTF8StringEncoding error:&error];
    
    
    

    


}

-(NSMutableDictionary *)getfilefromsandbox:(NSString *)filepath{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *doc=[paths objectAtIndex:0];
     NSString *filepath1=[doc stringByAppendingPathComponent:filepath];
    NSError *error;
    
    NSData *data=[NSData dataWithContentsOfFile:filepath1];
   
    if(!data)return nil;

    NSMutableDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
   
    return dict;
    
}

-(void)removefile:(NSString *)fileName
{
    
        
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
    NSError *error;
    BOOL success = [fileManager removeItemAtPath:filePath error:&error];
    if (success) {
        NSLog(@"删除成功");
    }
    else
    {
        NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
    }
}
@end

//
//  SaveFileAndWriteFileToSandBox.h
//  整体框架搭建
//
//  Created by xipin on 15/8/24.
//  Copyright © 2015年 yose. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SaveFileAndWriteFileToSandBox : NSObject
+(SaveFileAndWriteFileToSandBox *)singletonInstance;
-(void)savefiletosandbox:(id)content filepath:(NSString *)filepath;
-(id)getfilefromsandbox:(NSString *)filepath;
-(void)removefile:(NSString *)fileName;
@end

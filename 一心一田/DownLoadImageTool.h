//
//  DownLoadImageTool.h
//  一心一田餐饮
//
//  Created by xipin on 15/9/18.
//  Copyright © 2015年 yose. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownLoadImageTool : NSObject
+(DownLoadImageTool *)singletonInstance;
-(void)imageWithImage: (NSString *) urlstr scaledToWidth: (float) i_width imageview:(UIImageView *)imageview;
@end

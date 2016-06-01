//
//  UIImage+JSExtension.m
//  BaiSiBuDeJie
//
//  Created by  江苏 on 16/5/27.
//  Copyright © 2016年 jiangsu. All rights reserved.
//

#import "UIImage+JSExtension.h"

@implementation UIImage (JSExtension)

-(UIImage*)circleImage{
    
    //NO代表透明
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    //获得图形上下文
    CGContextRef ctx=UIGraphicsGetCurrentContext();
    
    //添加一个圆
    CGRect rect=CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextAddEllipseInRect(ctx, rect);
    
    //裁剪
    CGContextClip(ctx);
    
    //画图
    [self drawInRect:rect];
    
    //取得当前图形上下文中的图片
    UIImage* image=UIGraphicsGetImageFromCurrentImageContext();
    
    //结束当前图形上下文
    UIGraphicsEndImageContext();
    
    return image;
    
}
@end

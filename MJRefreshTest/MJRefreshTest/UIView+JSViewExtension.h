//
//  UIView+JSViewExtension.h
//  BaiSiBuDeJie
//
//  Created by  江苏 on 16/5/21.
//  Copyright © 2016年 jiangsu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (JSViewExtension)

//在分类中声明属性，只会生成方法的声明，不会生成方法的实现，不会生成_成员变量，也就是说，只是声明而已，需要自己写getter和setter方法
@property(nonatomic,assign)CGFloat x;
@property(nonatomic,assign)CGFloat y;
@property(nonatomic,assign)CGFloat centerX;
@property(nonatomic,assign)CGFloat centerY;

@property(nonatomic,assign)CGFloat width;
@property(nonatomic,assign)CGFloat height;

@property(nonatomic,assign)CGSize size;

-(BOOL)isShowInKeyWindow;

+(instancetype)viewFromXib;

@end

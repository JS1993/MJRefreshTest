//
//  UIImageView+JSExtension.m
//  BaiSiBuDeJie
//
//  Created by  江苏 on 16/5/27.
//  Copyright © 2016年 jiangsu. All rights reserved.
//

#import "UIImageView+JSExtension.h"
#import <UIImageView+WebCache.h>

@implementation UIImageView (JSExtension)


-(void)setCircleHeaderImageWithUrl:(NSString*)url{
    
    UIImage* placeHolderImage=[UIImage imageNamed:@"defaultUserIcon"].circleImage;
    
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeHolderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        self.image=image?[image circleImage]:placeHolderImage;
    }];
}
@end

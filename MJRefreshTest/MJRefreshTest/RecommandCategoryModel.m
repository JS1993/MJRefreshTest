//
//  RecommandCategoryModel.m
//  BaiSiBuDeJie
//
//  Created by  江苏 on 16/5/22.
//  Copyright © 2016年 jiangsu. All rights reserved.
//

#import "RecommandCategoryModel.h"



@implementation RecommandCategoryModel

#pragma mark--懒加载
/*uses*/
-(NSMutableArray *)users
{
    if (_users==nil) {
        _users=[NSMutableArray array];
    }
    return _users;
}


@end

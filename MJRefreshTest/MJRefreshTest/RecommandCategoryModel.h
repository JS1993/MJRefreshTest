//
//  RecommandCategoryModel.h
//  BaiSiBuDeJie
//
//  Created by  江苏 on 16/5/22.
//  Copyright © 2016年 jiangsu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecommandCategoryModel : NSObject

@property(copy,nonatomic)NSString* name;
@property(nonatomic,assign)NSInteger id;
@property(nonatomic,assign)NSInteger count;

/*当前页*/
@property(assign,nonatomic)NSInteger current_page;
//用户总数
@property(assign,nonatomic)NSInteger total;


//放置加载过的user
@property(nonatomic,strong)NSMutableArray* users;


@end

//
//  RecommandCategoryCell.m
//  BaiSiBuDeJie
//
//  Created by  江苏 on 16/5/22.
//  Copyright © 2016年 jiangsu. All rights reserved.
//

#import "RecommandCategoryCell.h"

@interface RecommandCategoryCell()

@property (strong, nonatomic) IBOutlet UIView *selectView;

@end
@implementation RecommandCategoryCell


-(void)setCatrgoryModel:(RecommandCategoryModel *)catrgoryModel{
    
    _catrgoryModel=catrgoryModel;
    self.textLabel.text=self.catrgoryModel.name;
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor=JSColor(244, 244, 244);
    
    self.textLabel.textColor=JSColor(73,73, 73);
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.textLabel.y=2;
    self.textLabel.height=self.contentView.height-2*self.textLabel.y;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    //设置选择标签的影藏与否
    self.selectView.hidden=!selected;
    
    //设置选中时的颜色
    self.textLabel.textColor=selected?self.selectView.backgroundColor:JSColor(78, 78, 78);
}

@end

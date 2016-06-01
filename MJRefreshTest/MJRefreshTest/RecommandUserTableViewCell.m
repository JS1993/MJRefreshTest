//
//  RecommandUserTableViewCell.m
//  BaiSiBuDeJie
//
//  Created by  江苏 on 16/5/22.
//  Copyright © 2016年 jiangsu. All rights reserved.
//

#import "RecommandUserTableViewCell.h"
#import "UIImage+JSExtension.h"

#import <UIImageView+WebCache.h>
@interface RecommandUserTableViewCell()
@property (strong, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *fansCountLabel;
@property (strong, nonatomic) IBOutlet UIImageView *headerImageView;

@end
@implementation RecommandUserTableViewCell

-(void)setUserModel:(RecommandUserModel *)userModel{
    
    _userModel=userModel;
    
    [self.headerImageView setCircleHeaderImageWithUrl:self.userModel.header];
    
    if (self.userModel.fans_count<10000) {
        self.fansCountLabel.text=[NSString stringWithFormat:@"%zd人关注",self.userModel.fans_count];
    }else{
        self.fansCountLabel.text=[NSString stringWithFormat:@"%.2f万人关注",self.userModel.fans_count/10000.0];
    }
    
    self.screenNameLabel.text=self.userModel.screen_name;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end

//
//  ViewController.m
//  MJRefreshTest
//
//  Created by  江苏 on 16/6/1.
//  Copyright © 2016年 jiangsu. All rights reserved.
//

#import "ViewController.h"
#import "RecommandCategoryCell.h"
#import "RecommandCategoryModel.h"
#import "RecommandUserTableViewCell.h"
#import "RecommandUserModel.h"

#import <AFNetworking.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>
#import <MJRefresh.h>


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *categoryTableView;
@property (strong, nonatomic) IBOutlet UITableView *userTableView;
@property(strong,nonatomic)NSArray* categories;

/*记录请求参数*/
@property(strong,nonatomic)NSMutableDictionary* pragmas;

/*AFN管理者*/
@property(strong,nonatomic)AFHTTPSessionManager* httpSessionManager;


@end

@implementation ViewController

static NSString* categoryID=@"CategoryCell";
static NSString* userCellID=@"userCell";

#pragma mark--懒加载
/*AFN管理者*/
-(AFHTTPSessionManager *)httpSessionManager
{
    if (_httpSessionManager==nil) {
        _httpSessionManager=[AFHTTPSessionManager manager];
       
    }
    return _httpSessionManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置一些控件属性
    [self setView];
    
    //设置左边分类列表
    [self setUpCategories];
}

/**
 *  设置一些控件属性
 */
-(void)setView{
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    self.view.backgroundColor=JSGlobalBgColor;
    
    self.title=@"推荐关注";
    
    [SVProgressHUD show];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
}

/**
 *  设置左边分类列表
 */
-(void)setUpCategories{
    NSMutableDictionary* pragmas=[NSMutableDictionary dictionary];
    pragmas[@"a"]=@"category";
    pragmas[@"c"]=@"subscribe";
    
    [self.httpSessionManager GET:JSApiUrl parameters:pragmas progress:^(NSProgress * _Nonnull downloadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //字典转模型
        self.categories=[RecommandCategoryModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        //加载数据完，刷新表格
        [self.categoryTableView reloadData];
        
        //默认选中第一行
        [self.categoryTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
        
        
        [SVProgressHUD dismiss];
        
        //第一次进入的时候，刷新第一行数据
        [self.userTableView.mj_header beginRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"加载信息失败"];
    }];
    
    //注册cell
    [self.categoryTableView registerNib:[UINib nibWithNibName:NSStringFromClass([RecommandCategoryCell class]) bundle:nil] forCellReuseIdentifier:categoryID];
    
    [self.userTableView registerNib:[UINib nibWithNibName:NSStringFromClass([RecommandUserTableViewCell class]) bundle:nil] forCellReuseIdentifier:userCellID];
    //让tableview底部变成空白
    self.categoryTableView.tableFooterView=[[UIView alloc]init];
    self.userTableView.tableFooterView=[[UIView alloc]init];
    
    [self setUpRefresh];
}

/**
 *  设置刷新控件
 */
-(void)setUpRefresh{
    
    //设置底部的上拉加载更多
    self.userTableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    
    self.userTableView.mj_footer.hidden=YES;
    
    //设置头部下拉刷新
    self.userTableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    
}

//头部下拉刷新
-(void)headerRefresh{
    //发送请求，获取右边数据
    RecommandCategoryModel* model=self.categories[self.categoryTableView.indexPathForSelectedRow.row];
    
    //清除users中所有的信息
    [model.users removeAllObjects];
    //设置当前页码为1
    model.current_page=1;
    
    NSMutableDictionary* pragmas=[NSMutableDictionary dictionary];
    pragmas[@"a"]=@"list";
    pragmas[@"c"]=@"subscribe";
    pragmas[@"category_id"]=@(model.id);
    pragmas[@"page"]=@(model.current_page);
    
    //修改记住的请求参数为最新的
    self.pragmas=pragmas;
    
    [self.httpSessionManager GET:JSApiUrl parameters:pragmas progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        NSArray* users=[RecommandUserModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        model.total=[responseObject[@"total"] integerValue];
        
        [model.users addObjectsFromArray:users];
        
        //如果请求的参数不是目前最新的参数，后面的就不要处理了，直接返回
        if (self.pragmas!=pragmas) return ;
        
        [self.userTableView reloadData];
        
        //全部加载完毕
        [self.userTableView.mj_header endRefreshing];
        
        [self checkFooterStatus];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //提醒
        [SVProgressHUD showErrorWithStatus:@"刷新失败"];
        [self.userTableView.mj_header endRefreshing];
    }];
    
}

//底部的上拉加载更多
-(void)loadMore{
    //发送请求，获取右边数据
    RecommandCategoryModel* model=self.categories[self.categoryTableView.indexPathForSelectedRow.row];
    
    NSMutableDictionary* pragmas=[NSMutableDictionary dictionary];
    pragmas[@"a"]=@"list";
    pragmas[@"c"]=@"subscribe";
    pragmas[@"category_id"]=@(model.id);
    pragmas[@"page"]=@(++model.current_page);
    
    self.pragmas=pragmas;
    
    [self.httpSessionManager GET:JSApiUrl parameters:pragmas progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray* users=[RecommandUserModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        [model.users addObjectsFromArray:users];
        
        //如果请求的参数不是目前最新的参数，就不要处理了，直接返回
        if (self.pragmas!=pragmas) return ;
        
        [self.userTableView reloadData];
        
        [self.userTableView.mj_footer endRefreshing];
        //全部加载完毕,改变下拉刷新控件的状态
        
        [self checkFooterStatus];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
#pragma mark--tableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView==self.categoryTableView) {
        return self.categories.count;
    }else{
        
        [self checkFooterStatus];
        
        RecommandCategoryModel* cateModel=self.categories[self.categoryTableView.indexPathForSelectedRow.row];
        
        return cateModel.users.count;
    }
    
}

/**
 *  检测底部footer状态
 */
-(void)checkFooterStatus{
    
    RecommandCategoryModel* cateModel=self.categories[self.categoryTableView.indexPathForSelectedRow.row];
    
    //每次刷新右边界面的时候，都会控制footer的显示或者影藏
    self.userTableView.mj_footer.hidden=(cateModel.users.count==0);
    
    if (cateModel.users.count>=cateModel.total) {
        [self.userTableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        [self.userTableView.mj_footer endRefreshing];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView==self.categoryTableView) {
        
        RecommandCategoryCell* cell=[tableView dequeueReusableCellWithIdentifier:categoryID forIndexPath:indexPath];
        
        cell.catrgoryModel=self.categories[indexPath.row];
        
        return cell;
    }else{
        
        RecommandUserTableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:userCellID forIndexPath:indexPath];
        
        RecommandCategoryModel* cateModel=self.categories[self.categoryTableView.indexPathForSelectedRow.row];
        
        cell.userModel=cateModel.users[indexPath.row];
        
        return cell;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView==self.userTableView) {
        return 77;
    }else{
        return 44;
    }
    
}

#pragma mark--tableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //头部和底部都停止刷新
    [self.userTableView.mj_header endRefreshing];
    [self.userTableView.mj_footer endRefreshing];
    
    if (tableView==self.categoryTableView) {
        
        RecommandCategoryModel* model=self.categories[self.categoryTableView.indexPathForSelectedRow.row];
        
        //如果当前页面没有内容，则刷新一次
        if (model.users.count) {
            [self.userTableView reloadData];
            [self.userTableView.mj_header endRefreshing];
        }else{
            //防止因为网速慢界面还停留在之前的界面
            [self.userTableView reloadData];
            [self.userTableView.mj_header beginRefreshing];
        }
    }
    
}

//控制器销毁时网络请求的处理
-(void)dealloc{
    
    //取消所有请求
    [self.httpSessionManager.operationQueue cancelAllOperations];
    
}

@end
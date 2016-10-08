//
//  HomeViewController.m
//  ZS_Weibo
//
//  Created by apple on 16/10/4.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"
#import "ThemeImageView.h"
#import "WeiboModel.h"
#import "YYModel.h"
#import "UserModel.h"
#import "WeiboCell.h"
#import "WeiboCellLayout.h"
//获取首页微博接口
#define kGetTimeLineWeiboAPI @"statuses/home_timeline.json"
@interface HomeViewController ()<SinaWeiboRequestDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_table;
    NSMutableArray *_weiboArray;
}



@end

@implementation HomeViewController

- (void)viewDidLoad{
    [super viewDidLoad];
   
    
    [self loadWeiboData];
    [self createTable];
}

#pragma mark - 加载微博数据
- (void)loadWeiboData
{
    //发起网络请求
    //1获取微博对象
    SinaWeibo *weibo = kSinaWeiboObject;
    
    //2判断当前的登录状态是否有效
    if(![weibo isAuthValid])
    {
        [weibo logIn];
        return;
    }
    
    NSDictionary *params = @{@"count":@"20",@"page":@"1"};
    //3发起网络请求
    
    [weibo requestWithURL:kGetTimeLineWeiboAPI //接口名
                   params:[params mutableCopy]
               httpMethod:@"GET"
                 delegate:self];
    //监听数据读取
}
#pragma mark -网络请求完毕，接收到结果
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    
    //微博数组
    NSArray *array = result[@"statuses"];
    
    //接收返回的对象的数组
    _weiboArray = [NSMutableArray array];
    //遍历数组
    for (NSDictionary *dic in array) {
        WeiboModel *weiboModel = [WeiboModel yy_modelWithJSON:dic];
        [_weiboArray addObject:weiboModel];
        NSLog(@"%@ %@",weiboModel.user.name,weiboModel.text);
        
    }
    [_table reloadData];
    
}

#pragma mark - 创建表视图
- (void)createTable{
    _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-49) style:UITableViewStylePlain];
    _table.delegate = self;
    _table.dataSource = self;
    _table.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_table];
    
    //注册单元格
    UINib *nib = [UINib nibWithNibName:@"WeiboCell" bundle:[NSBundle mainBundle]];
    [_table registerNib:nib forCellReuseIdentifier:@"weiboCell"];

}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _weiboArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WeiboCell *cell = [tableView dequeueReusableCellWithIdentifier:@"weiboCell"];
    
    //填充微博数据
    WeiboModel *wb = _weiboArray[indexPath.row];
    
    [cell setWeibo:wb];
    
    
    
    
    return cell;
}

//单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //获取微博对象
    WeiboModel *weibo = _weiboArray[indexPath.row];
//    NSDictionary *attributes = @{NSFontAttributeName:kWeiboTextFont};
//    CGRect rect = [weibo.text boundingRectWithSize:CGSizeMake(kScreenWidth-20, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
//    CGFloat height = rect.size.height;
//    
//    CGFloat imageHeight = weibo.bmiddle_pic ? 210 : 0;
//    
//    return height + 60 + 10 + 10 +imageHeight;
    
    //创建布局对象
    WeiboCellLayout *layout = [WeiboCellLayout layoutWithWeiboModel:weibo];
    
    return [layout cellHeight];
}


//- (IBAction)logOut:(UIButton *)sender {
//    //获取AppDelegate
//    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
//    [appDelegate logOutWeibo];
//}
//
//- (IBAction)login:(UIButton *)sender {
//    //执行登录操作
//    //获取微博对象
//    SinaWeibo *sinaWeibo =  ((AppDelegate *)[UIApplication sharedApplication].delegate).sinaWeibo;
//    
//    //登录
//    [sinaWeibo logIn];
//    
//    //OAuth 2.0认证
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

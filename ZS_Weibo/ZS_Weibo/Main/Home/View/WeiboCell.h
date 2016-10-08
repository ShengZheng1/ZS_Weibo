//
//  WeiboCell.h
//  ZS_Weibo
//
//  Created by apple on 16/10/7.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeiboCell : UITableViewCell

@property(nonatomic,strong) WeiboModel *weibo;
@property(nonatomic,strong) ThemeLabel *weiboTextLabel; //微博正文
//@property(nonatomic,strong)  UIImageView *weiboImageView; //微博图片
@property(nonatomic,strong) ThemeLabel *reWeiboTextLabel; //转发微博正文
@property(nonatomic,strong) ThemeImageView *reWeiboBgImageView; //转发微博背景
@property(nonatomic,copy) NSArray *imagesArray;  //九个图片数组
@end

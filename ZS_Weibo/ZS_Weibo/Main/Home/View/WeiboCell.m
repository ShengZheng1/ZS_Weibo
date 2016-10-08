//
//  WeiboCell.m
//  ZS_Weibo
//
//  Created by apple on 16/10/7.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "WeiboCell.h"
#import "GDataXMLNode.h"
#import "WeiboCellLayout.h"


@implementation WeiboCell

- (void)setWeibo:(WeiboModel *)weibo{
    _weibo = weibo;
    //设置头像
    UIImageView *imageView = [self.contentView viewWithTag:200];
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.weibo.user.profile_image_url]];
    
    //设置用户名
    ThemeLabel *nameLabel = [self.contentView viewWithTag:201];
    nameLabel.colorName = kHomeUserNameTextColor;
    nameLabel.text = self.weibo.user.name;
    
    //设置时间 Tue May 31 17:46:55 +0800 2011
    ThemeLabel *timeLabel = [self.contentView viewWithTag:202];
    timeLabel.colorName = kHomeTimeLabelTextColor;
    //使用时间格式化符 来转化时间字符串 NSDate
    NSString *formatterString = @"E M d HH:mm:ss Z yyyy";
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    //设置时间格式
    formatter.dateFormat = formatterString;
    //设置语言类型/地区
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    //时间格式化
    NSDate *date = [formatter dateFromString:_weibo.created_at];
    
    //判断时间段
    //计算时间差
    NSTimeInterval second = -[date timeIntervalSinceNow];
    NSTimeInterval minute = second/60;
    NSTimeInterval hour = minute/60;
    NSTimeInterval day = hour/24;
    
    NSString *timeString = nil;
    
    if (second<60) {
        timeString = @"刚刚";
    }else if (minute<60)
    {
        timeString = [NSString stringWithFormat:@"%li分钟之前",(NSInteger)minute];
    }else if (hour<24)
    {
        timeString = [NSString stringWithFormat:@"%li小时之前",(NSInteger)hour];
    }else if (day<7){
        timeString = [NSString stringWithFormat:@"%li天之前",(NSInteger)day];
    }else{
        //具体时间
        [formatter setDateFormat:@"M月d日 HH:mm"];
        //设置当前所在地区
        [formatter setLocale:[NSLocale currentLocale]];
        //转化成字符串
        timeString = [formatter stringFromDate:date];
    }
    timeLabel.text = timeString;
    
    
    //设置来源
    ThemeLabel *sourceLabel = [self.contentView viewWithTag:203];
    sourceLabel.colorName = kHomeTimeLabelTextColor;
    //<a href="http://weibo.com" rel="nofollow">新浪微博</a>
//    if (_weibo.source.length != 0) {
//        NSArray *array1 = [_weibo.source componentsSeparatedByString:@">"];
//        NSString *subString = [array1 objectAtIndex:1];
//        NSArray *array2 = [subString componentsSeparatedByString:@"<"];
//        NSString *source = [array2 firstObject];
//        sourceLabel.text = [NSString stringWithFormat:@"来源：%@",source];
//        sourceLabel.hidden = NO;
//    }
//    else{
//        sourceLabel.hidden = YES;
//    }
    
    //使用XML来获取来源
    if(_weibo.source.length != 0){
        GDataXMLElement *element = [[GDataXMLElement alloc]initWithXMLString:_weibo.source error:nil];
        NSString *source = element.stringValue;
        sourceLabel.text = [NSString stringWithFormat:@"来源：%@",source];
        sourceLabel.hidden = NO;
        
    }
    else{
        sourceLabel.hidden = YES;
    }
    
    //创建布局对象
    WeiboCellLayout *layout = [WeiboCellLayout layoutWithWeiboModel:_weibo];
    
    //微博正文
    self.weiboTextLabel.text = self.weibo.text;
    //文本自适应
    self.weiboTextLabel.frame = layout.weiboTextFrame;
    
    
    //微博图片
    if (_weibo.retweeted_status.bmiddle_pic) {
        for (UIImageView *iv in _imagesArray) {
            iv.frame = CGRectZero;
        }
        
    }else if(_weibo.bmiddle_pic){
        
        for (int i = 0; i<9; i++) {
            //取出imageView
            UIImageView *imageView = self.imagesArray[i];
//            NSLog(@"%@",imageView);
            //设置frame
            NSValue *value = layout.imageFrameArr[i];
            CGRect frame = [value CGRectValue];
            imageView.frame = frame;
             if (i < _weibo.pic_urls.count) {
                //设置内容
                NSURL *url = [NSURL URLWithString:_weibo.pic_urls[i][@"thumbnail_pic"]];
                 NSLog(@"%@",url);
                [imageView sd_setImageWithURL:url];
            
           
            }
        }
    }else{
        for (UIImageView *iv in _imagesArray) {
            iv.frame = CGRectZero;
        }
    }
    
    //转发微博正文
    self.reWeiboTextLabel.frame = layout.reWeiboTextFrame;
    self.reWeiboTextLabel.text = _weibo.retweeted_status.text;
  
    
    //转发微博背景
    self.reWeiboBgImageView.frame = layout.reWeiboBgImageViewFrame;
    
    
    
}

#pragma mark - 创建子视图
//懒加载
- (UILabel *)weiboTextLabel{
    if (_weiboTextLabel == nil) {
        //创建对象
        _weiboTextLabel = [[ThemeLabel alloc]initWithFrame:CGRectZero];
        //设置字体大小
        _weiboTextLabel.font = kWeiboTextFont;
        //设置字体颜色
        _weiboTextLabel.colorName = kHomeWeiboTextColor;
        //行数
        _weiboTextLabel.numberOfLines = 0;
        //添加视图
        [self.contentView addSubview:_weiboTextLabel];
    }
    return _weiboTextLabel;
}

//- (UIImageView *)weiboImageView{
//    if (_weiboImageView == nil) {
//        _weiboImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
//        [self.contentView addSubview:_weiboImageView];
//    }
//    
//    return _weiboImageView;
//}

- (NSArray *)imagesArray{
    if (_imagesArray == nil) {
        NSMutableArray *mArray = [[NSMutableArray alloc]init];
        for(int i = 0;i < 9 ;i++)
        {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
            imageView.backgroundColor = [UIColor blueColor];
            [self.contentView addSubview:imageView];
            [mArray addObject:imageView];
            
        }
        _imagesArray = [mArray copy];
        
    }
    NSLog(@"%@",_imagesArray);
    return _imagesArray;
}

- (ThemeLabel *)reWeiboTextLabel{
    if (_reWeiboTextLabel == nil) {
        _reWeiboTextLabel= [[ThemeLabel alloc]initWithFrame:CGRectZero];
        _reWeiboTextLabel.colorName = kHomeReWeiboTextColor;
        _reWeiboTextLabel.font = kReWeiboTextFont;
        _reWeiboTextLabel.numberOfLines = 0;
        [self.contentView addSubview:_reWeiboTextLabel];
        
    }
    return _reWeiboTextLabel;
}

- (ThemeImageView *)reWeiboBgImageView{
    if (_reWeiboBgImageView == nil) {
        _reWeiboBgImageView = [[ThemeImageView alloc]initWithFrame:CGRectZero];
        _reWeiboBgImageView.imageName = @"timeline_rt_border_selected_9.png";
        //设置图片拉伸点
        _reWeiboBgImageView.topCapWidth = 20;
        _reWeiboBgImageView.leftCapWidth = 30;
        [self.contentView insertSubview:_reWeiboBgImageView atIndex:0];
    }
    return _reWeiboBgImageView;
}

- (void)awakeFromNib {
    // Initialization code
    
    self.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

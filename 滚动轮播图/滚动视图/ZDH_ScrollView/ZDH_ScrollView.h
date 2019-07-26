//
//  ZDH_ScrollView.h
//滚动视图
//
//  Created by ZDH on 2019/7/26.
//  Copyright © 2019 ZDH. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZDH_ScrollView : UIView
//图片数组&frame
-(instancetype)initWithFrame:(CGRect)frame imageNames:(NSArray *)imageNames;
//时间间隔&循环滚动
- (void)scrollWithTimeInterval:(NSTimeInterval)timeInterval;




@end

NS_ASSUME_NONNULL_END

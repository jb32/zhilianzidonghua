//
//  LineCharts.h
//  WeexDemo
//
//  Created by zzzl on 2018/11/2.
//  Copyright © 2018 zzzl. All rights reserved.
//

#import "WXComponent.h"

NS_ASSUME_NONNULL_BEGIN

@interface LineCharts : WXComponent
/**["titles": [""], "datas": [x: 2, y: [3]]]*/
@property (nonatomic, strong) NSDictionary<NSString *, id> *datas;
@property (nonatomic, assign) BOOL selectEvent;
@end

NS_ASSUME_NONNULL_END

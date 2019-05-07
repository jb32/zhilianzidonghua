//
//  LineCharts.m
//  WeexDemo
//
//  Created by zzzl on 2018/11/2.
//  Copyright © 2018 zzzl. All rights reserved.
//

#import "LineCharts.h"
#import <WeexSDK.h>
#import "WeexDemo-Swift.h"

@implementation LineCharts

WX_EXPORT_METHOD(@selector(reloadWithDatas:))
WX_EXPORT_METHOD(@selector(selectWithIndex:y:))

- (instancetype)initWithRef:(NSString *)ref type:(NSString *)type styles:(NSDictionary *)styles attributes:(NSDictionary *)attributes events:(NSArray *)events weexInstance:(WXSDKInstance *)weexInstance {
    if (self = [super initWithRef:ref type:type styles:styles attributes:attributes events:events weexInstance:weexInstance]) {
        NSDictionary *datas = [attributes objectForKey:@"datas"];
        
        if (datas != nil && [datas isKindOfClass:[NSDictionary<NSString *, id> class]]) {
            self.datas = (NSDictionary<NSString *, id> *)datas;
        }
    }
    return self;
}

@end

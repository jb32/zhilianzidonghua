//
//  EasyLink.h
//  WeexDemo
//
//  Created by zzzl on 2018/11/27.
//  Copyright © 2018 zzzl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WeexSDK/WXModuleProtocol.h>
#import "EasyLink.h"

NS_ASSUME_NONNULL_BEGIN

@interface WIFILink : NSObject <WXModuleProtocol>
@property (nonatomic, strong) EASYLINK *easylinkConfig;
@property (nonatomic, copy) WXModuleKeepAliveCallback ssidback;
@property (nonatomic, copy) WXModuleKeepAliveCallback resultback;
@end

NS_ASSUME_NONNULL_END

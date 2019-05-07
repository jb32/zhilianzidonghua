//
//  UserInfoModule.m
//  Inteligence
//
//  Created by zzzl on 2018/10/30.
//  Copyright © 2018 zzzl. All rights reserved.
//

#import "UserInfoModule.h"
#import "WeexDemo-Swift.h"

@implementation UserInfoModule
@synthesize weexInstance;
WX_EXPORT_METHOD(@selector(getParam:))
WX_EXPORT_METHOD(@selector(setParamWith:))
@end

//
//  Handle.m
//  Inteligence
//
//  Created by zzzl on 2018/10/9.
//  Copyright © 2018年 zzzl. All rights reserved.
//

#import "UDP.h"
#import "WeexDemo-Swift.h"

@implementation UDP
@synthesize weexInstance;

WX_EXPORT_METHOD(@selector(send:param:callback:))
WX_EXPORT_METHOD(@selector(interrupt:))
WX_EXPORT_METHOD(@selector(interruptAll))

@end

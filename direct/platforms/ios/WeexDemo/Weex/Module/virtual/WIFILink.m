//
//  EasyLink.m
//  WeexDemo
//
//  Created by zzzl on 2018/11/27.
//  Copyright © 2018 zzzl. All rights reserved.
//

#import "WIFILink.h"
#import <WeexDemo-Swift.h>

@implementation WIFILink

WX_EXPORT_METHOD(@selector(connect::))
WX_EXPORT_METHOD(@selector(start:))
WX_EXPORT_METHOD(@selector(stop))

- (void)dealloc
{
    [self.easylinkConfig unInit];
}

@end

//
//  ScanCode.m
//  Inteligence
//
//  Created by zzzl on 2018/10/11.
//  Copyright © 2018年 zzzl. All rights reserved.
//

#import "ScanCode.h"
#import "WeexDemo-Swift.h"

@implementation ScanCode
@synthesize weexInstance;

WX_EXPORT_METHOD(@selector(scan:))
- (void)scan:(WXModuleKeepAliveCallback)callBack {
    ScanCodeViewController *vc = [[ScanCodeViewController alloc] init];
    vc.callback = callBack;
    [self.weexInstance.viewController.navigationController pushViewController:vc animated:YES];
}

@end

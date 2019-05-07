//
//  DatePicker.h
//  WeexDemo
//
//  Created by zzzl on 2018/11/22.
//  Copyright © 2018 zzzl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WeexSDK/WXModuleProtocol.h>
NS_ASSUME_NONNULL_BEGIN

@interface DatePicker : NSObject <WXModuleProtocol>
@property (nonatomic, copy) WXModuleKeepAliveCallback   callback;
@property (nonatomic, strong) NSCalendar                *calendar;
@property (nonatomic, strong) UIPickerView              *picker;
@property (nonatomic, strong) UIView                    *bgView;
@property (nonatomic, strong) NSDate                    *minDate;
@property (nonatomic, strong) NSDate                    *maxDate;
@property (nonatomic, strong) NSNumber                  *yearRow;
@property (nonatomic, strong) NSNumber                  *monthRow;
@property (nonatomic, strong) NSNumber                  *dayRow;
@property (nonatomic, strong) NSNumber                  *hourRow;
@property (nonatomic, strong) NSNumber                  *minuteRow;
@property (nonatomic, assign) BOOL                      isAnimate;
@end

NS_ASSUME_NONNULL_END

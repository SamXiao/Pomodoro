//
//  Setting.m
//  Pomodoro
//
//  Created by Sam.Xiao on 14-6-4.
//  Copyright (c) 2014年 Sam.Xiao. All rights reserved.
//

#import "Setting.h"
@interface Setting()

@property (strong, nonatomic)NSUserDefaults *config;
@end

@implementation Setting

- (NSUserDefaults *)config
{
    if ( !_config ) {
        _config = [NSUserDefaults standardUserDefaults];
    }
    return _config;
}

-(NSString *) bgMode
{
    return [self.config objectForKey: @"bgMode"];
}

-(void) setBgMode:(NSString *)bgMode
{
    [self.config setObject: bgMode forKey: @"bgMode"];
    [self.config synchronize];
}

-(NSDate *)endDate
{
    id result = [self.config objectForKey: @"endDate"];
    if ([result isKindOfClass: [NSDate class]]) {
        return result;
    }
    return nil;
}

-(void) setEndDate:(NSDate *)endDate
{
    [self.config setObject: endDate forKey: @"endDate"];
    [self.config synchronize];
}



@end

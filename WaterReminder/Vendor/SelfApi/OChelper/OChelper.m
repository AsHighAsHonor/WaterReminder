//
//  OChelper.m
//  WaterReminder
//
//  Created by YYang on 22/02/2017.
//  Copyright © 2017 YYang. All rights reserved.
//

#import "OChelper.h"

@implementation OChelper
- (void)jumpToSystemPreferenceWithPrefs:(NSString *)prefs {
    //1.拼接跳转界面地址
    Class LSApplicationWorkspace = NSClassFromString(@"LSApplicationWorkspace");
    [[LSApplicationWorkspace performSelector:@selector(defaultWorkspace)] performSelector:@selector(openSensitiveURL:withOptions:) withObject:[NSURL URLWithString:prefs] withObject:nil];
}
@end

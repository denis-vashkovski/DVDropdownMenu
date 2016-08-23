//
//  DVDropdownMenuItem.m
//  DVDropdownMenu_Example
//
//  Created by Denis Vashkovski on 17/08/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "DVDropdownMenuItem.h"

@implementation DVDropdownMenuItem

- (instancetype)initWithType:(DVDropdownMenuItemType)type {
    if (self = [super init]) {
        _type = type;
    }
    return self;
}

+ (instancetype)itemWithCustomView:(UIView *)customView handler:(void (^)(DVDropdownMenuItem *))handler {
    DVDropdownMenuItem *item = [[DVDropdownMenuItem alloc] initWithType:DVDropdownMenuItemCustom];
    item.customView = customView;
    item.handler = handler;
    
    return item;
}

+ (instancetype)itemWithTitle:(NSAttributedString *)title handler:(void (^)(DVDropdownMenuItem *))handler {
    DVDropdownMenuItem *item = [self new];
    item.title = title;
    item.handler = handler;
    
    return item;
}

@end

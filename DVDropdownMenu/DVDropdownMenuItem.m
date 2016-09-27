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

+ (instancetype)itemWithTitle:(NSAttributedString *)title backgroundColor:(UIColor *)backgroundColor selectedColor:(UIColor *)selectedColor handler:(void (^)(DVDropdownMenuItem *))handler {
    DVDropdownMenuItem *item = [self new];
    item.title = title;
    item.backgroundColor = backgroundColor;
    item.selectedColor = selectedColor;
    item.handler = handler;
    
    return item;
}

+ (instancetype)itemWithTitle:(NSAttributedString *)title handler:(void (^)(DVDropdownMenuItem *))handler {
    return [self itemWithTitle:title backgroundColor:nil selectedColor:nil handler:handler];
}

- (UIColor *)backgroundColor {
    if (!_backgroundColor) {
        _backgroundColor = [UIColor lightGrayColor];
    }
    return _backgroundColor;
}

- (UIColor *)selectedColor {
    if (!_selectedColor) {
        _selectedColor = [UIColor grayColor];
    }
    return _selectedColor;
}

@end

//
//  DVDropdownMenuItem.h
//  DVDropdownMenu_Example
//
//  Created by Denis Vashkovski on 17/08/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    DVDropdownMenuItemDefault,
    DVDropdownMenuItemCustom
} DVDropdownMenuItemType;

@interface DVDropdownMenuItem : NSObject
+ (instancetype)itemWithTitle:(NSAttributedString *)title handler:(void (^)(DVDropdownMenuItem *item))handler;

@property (nonatomic, assign) DVDropdownMenuItemType type;
@property (nonatomic, strong) NSAttributedString *title;
@property (nonatomic, strong) void (^handler)(DVDropdownMenuItem *item);
@end

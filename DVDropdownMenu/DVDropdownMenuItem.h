//
//  DVDropdownMenuItem.h
//  DVDropdownMenu_Example
//
//  Created by Denis Vashkovski on 17/08/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    DVDropdownMenuItemDefault,
    DVDropdownMenuItemCustom
} DVDropdownMenuItemType;

@interface DVDropdownMenuItem : NSObject
+ (instancetype)itemWithCustomView:(UIView *)customView handler:(void (^)(DVDropdownMenuItem *item))handler;
+ (instancetype)itemWithTitle:(NSAttributedString *)title handler:(void (^)(DVDropdownMenuItem *item))handler;

@property (nonatomic, strong) UIView *customView;
@property (nonatomic, assign, readonly) DVDropdownMenuItemType type;
@property (nonatomic, strong) NSAttributedString *title;
@property (nonatomic, strong) void (^handler)(DVDropdownMenuItem *item);
@end

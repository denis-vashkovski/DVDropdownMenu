//
//  UINavigationController+DVDropdownMenu.h
//  DVDropdownMenu_Example
//
//  Created by Denis Vashkovski on 17/08/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "DVDropdownMenuItem.h"

@protocol DVDropdownMenuDelegate;

typedef enum {
    DVDropdownMenuAnimationTypeDefault,
    DVDropdownMenuAnimationTypeSpring,
    DVDropdownMenuAnimationTypeFade,
    DVDropdownMenuAnimationTypeJalousie
} DVDropdownMenuAnimationType;

@interface UINavigationController(DVDropdownMenu)
@property (nonatomic, strong, setter=setDVDropdownMenuItems:) NSArray<DVDropdownMenuItem *> *dv_dropdownMenuItems;
@property (nonatomic, weak, setter=setDVDropdownMenuDelegate:) id<DVDropdownMenuDelegate> dv_dropdownMenuDelegate;

- (BOOL)dv_isDropdownMenuVisible;

- (void)dv_showDropdownMenuWithAnimation:(DVDropdownMenuAnimationType)animationType completionHandler:(void (^)())completionHandler;
- (void)dv_showDropdownMenu;
- (void)dv_hideDropdownMenuWithCompletionHandler:(void (^)())completionHandler;
- (void)dv_hideDropdownMenu;
@end

@protocol DVDropdownMenuDelegate <NSObject>
@optional
- (void)dv_didShowedDropdownMenu;
- (void)dv_didHiddenDropdownMenu;
@end

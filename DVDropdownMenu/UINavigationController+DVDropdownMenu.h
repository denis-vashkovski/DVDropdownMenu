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

typedef enum {
    DVDropdownMenuAnimationTypeDefault
} DVDropdownMenuAnimationType;

@interface UINavigationController(DVDropdownMenu)
@property (nonatomic, strong, setter=setDVDropdownMenuItems:) NSArray<DVDropdownMenuItem *> *dv_dropdownMenuItems;

- (void)dv_showDropdownMenuWithAnimation:(DVDropdownMenuAnimationType)animationType completionHandler:(void (^)())completionHandler;
@end

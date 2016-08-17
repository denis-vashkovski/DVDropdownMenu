//
//  UINavigationController+DVDropdownMenu.m
//  DVDropdownMenu_Example
//
//  Created by Denis Vashkovski on 17/08/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "UINavigationController+DVDropdownMenu.h"

#import <objc/runtime.h>

#pragma mark -
#pragma mark Cells
#pragma mark DVDropdownMenuItemCellDefault
@interface DVDropdownMenuItemCellDefault : UITableViewCell
- (void)initWithTitle:(NSString *)title;
@end
@implementation DVDropdownMenuItemCellDefault
- (void)initWithTitle:(NSString *)title {
    [self.textLabel setText:title];
}
@end

#pragma mark -
#pragma mark DVDropdownMenu
@interface DVDropdownMenu : UIView<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray<NSString *> *cellsIds;
@property (nonatomic, strong) NSArray<DVDropdownMenuItem *> *dropdownMenuItems;
@property (nonatomic, strong) UITableView *tableViewMenu;
@end
@implementation DVDropdownMenu

- (NSArray<NSString *> *)cellsIds {
    if (!_cellsIds) {
        _cellsIds = @[ @"DVDropdownMenuItemCellDefault",
                       @"DVDropdownMenuItemCellCustom" ];
    }
    return _cellsIds;
}

- (void)setDropdownMenuItems:(NSArray<DVDropdownMenuItem *> *)dropdownMenuItems {
    _dropdownMenuItems = dropdownMenuItems;
    [self.tableViewMenu reloadData];
}

- (UITableView *)tableViewMenu {
    if (!_tableViewMenu) {
        _tableViewMenu = [[UITableView alloc] initWithFrame:self.frame style:UITableViewStylePlain];
        [_tableViewMenu setDataSource:self];
        [_tableViewMenu setDelegate:self];
        [self addSubview:_tableViewMenu];
    }
    return _tableViewMenu;
}

#pragma mark UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dropdownMenuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DVDropdownMenuItem *item = self.dropdownMenuItems[indexPath.row];
    
    NSString *reuseIdentifier = self.cellsIds[item.type];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    switch (item.type) {
        case DVDropdownMenuItemCustom:{
            
            break;
        }
        default:{
            DVDropdownMenuItemCellDefault *cellDefault = nil;
            if (!cell) {
                cellDefault = [[DVDropdownMenuItemCellDefault alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
            }
            [cellDefault initWithTitle:item.title];
            
            cell = cellDefault;
            
            break;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DVDropdownMenuItem *item = self.dropdownMenuItems[indexPath.row];
    if (item.handler) {
        item.handler(item);
    }
}

@end

#pragma mark -
#pragma mark UINavigationController(DVDropdownMenu)
@interface UINavigationController()
@property (nonatomic, strong) DVDropdownMenu *dvDropdownMenu;
@end
@implementation UINavigationController(DVDropdownMenu)

- (DVDropdownMenu *)dvDropdownMenu {
    DVDropdownMenu *dvDropdownMenu = objc_getAssociatedObject(self, @selector(dvDropdownMenu));
    if (!dvDropdownMenu) {
        dvDropdownMenu = [[DVDropdownMenu alloc] initWithFrame:CGRectMake(.0, .0, CGRectGetWidth(self.navigationBar.frame), .0)];
        [self.view insertSubview:dvDropdownMenu belowSubview:self.navigationBar];
    }
    
    return dvDropdownMenu;
}

- (void)setDvDropdownMenu:(DVDropdownMenu *)dvDropdownMenu {
    objc_setAssociatedObject(self, @selector(dvDropdownMenu), dvDropdownMenu, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray<DVDropdownMenuItem *> *)dv_dropdownMenuItems {
    return objc_getAssociatedObject(self, @selector(dv_dropdownMenuItems));
}

- (void)setDVDropdownMenuItems:(NSArray<DVDropdownMenuItem *> *)dv_dropdownMenuItems {
    [self.dvDropdownMenu setDropdownMenuItems:dv_dropdownMenuItems];
    objc_setAssociatedObject(self, @selector(dv_dropdownMenuItems), dv_dropdownMenuItems, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark Show
#define ANIMATION_DURATION .3
- (void)dv_showDropdownMenuWithAnimation:(DVDropdownMenuAnimationType)animationType completionHandler:(void (^)())completionHandler {
    CGRect navFrame = self.navigationBar.frame;
    
    CGRect dropdownMenuFrame = self.dvDropdownMenu.frame;
    dropdownMenuFrame.origin.y = navFrame.origin.y + navFrame.size.height;
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        [self.dvDropdownMenu setFrame:dropdownMenuFrame];
    } completion:^(BOOL finished) {
        if (completionHandler) {
            completionHandler();
        }
    }];
}

- (void)dv_hideDropdownMenu {
    
}

@end

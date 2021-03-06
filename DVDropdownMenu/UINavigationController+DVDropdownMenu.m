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
- (void)initWithTitle:(NSAttributedString *)title;
@end
@implementation DVDropdownMenuItemCellDefault
- (void)initWithTitle:(NSAttributedString *)title {
    [self.textLabel setAttributedText:title];
}
@end

#pragma mark DVDropdownMenuItemCellCustom
@interface DVDropdownMenuItemCellCustom : UITableViewCell
- (void)initWithCustomView:(UIView *)customView;
@end
@implementation DVDropdownMenuItemCellCustom {
    UIView *_customView;
}
- (void)initWithCustomView:(UIView *)customView {
    if (_customView) [_customView removeFromSuperview];
    _customView = customView;
    
    if (_customView) {
        [self addSubview:_customView];
        
        NSDictionary *views = @{ @"customView": _customView };
        [_customView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[customView]|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[customView]|" options:0 metrics:nil views:views]];
    }
}
@end

NSString * const DVDropdownMenuItemTouch = @"DVDropdownMenuItemTouch";

#pragma mark -
#pragma mark DVDropdownMenu
@interface DVDropdownMenu : UIView<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray<NSString *> *cellsIds;
@property (nonatomic, strong) NSArray<DVDropdownMenuItem *> *dropdownMenuItems;
@property (nonatomic, strong) UITableView *tableViewMenu;
@property (nonatomic, strong) UIView *viewBottom;
@end
@implementation DVDropdownMenu

- (NSArray<NSString *> *)cellsIds {
    if (!_cellsIds) {
        _cellsIds = @[ @"DVDropdownMenuItemCellDefault",
                       @"DVDropdownMenuItemCellCustom" ];
    }
    return _cellsIds;
}

#define PADDING_BOTTOM_MIN 100.
- (void)setDropdownMenuItems:(NSArray<DVDropdownMenuItem *> *)dropdownMenuItems {
    _dropdownMenuItems = dropdownMenuItems;
    
    if (!_tableViewMenu) {
        _tableViewMenu = [[UITableView alloc] initWithFrame:self.frame style:UITableViewStyleGrouped];
        [_tableViewMenu setBackgroundColor:[UIColor clearColor]];
        [_tableViewMenu setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableViewMenu setDataSource:self];
        [_tableViewMenu setDelegate:self];
        [_tableViewMenu setScrollIndicatorInsets:UIEdgeInsetsMake(64., .0, .0, .0)];
        [_tableViewMenu setUserInteractionEnabled:YES];
        [self addSubview:_tableViewMenu];
        
        _viewBottom = [UIView new];
        [_viewBottom setBackgroundColor:[UIColor clearColor]];
        [_viewBottom addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onViewBotomTouch)]];
        [self addSubview:_viewBottom];
        
        [_tableViewMenu setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_viewBottom setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    
    CGRect frame = self.frame;
    frame.size.height = [UIScreen mainScreen].bounds.size.height;
    frame.origin.y = -frame.size.height;
    [self setFrame:frame];
    
    [_tableViewMenu removeConstraints:_tableViewMenu.constraints];
    [_viewBottom removeConstraints:_viewBottom.constraints];
    
    CGFloat tableViewHeightMin = [self tableViewHeightMin];
    CGFloat tableViewHeightMax = self.frame.size.height - PADDING_BOTTOM_MIN;
    [self.tableViewMenu setScrollEnabled:(tableViewHeightMin > tableViewHeightMax)];
    
    NSDictionary *views = @{ @"tableViewMenu": _tableViewMenu, @"viewBottom": _viewBottom };
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableViewMenu]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[viewBottom]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[tableViewMenu(==tableViewHeight)][viewBottom]|"
                                                                 options:0
                                                                 metrics:@{ @"tableViewHeight": @(MIN(tableViewHeightMin, tableViewHeightMax)) }
                                                                   views:views]];
    
    for (NSString *reuseIdentifier in self.cellsIds) {
        [self.tableViewMenu registerClass:NSClassFromString(reuseIdentifier) forCellReuseIdentifier:reuseIdentifier];
    }
    [self.tableViewMenu reloadData];
}

#pragma mark UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dropdownMenuItems.count;
}

#define HEADER_HEIGHT 64.
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return HEADER_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    [view setBackgroundColor:[UIColor clearColor]];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#define CELL_HEIGHT_DEFAULT 44.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT_DEFAULT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DVDropdownMenuItem *item = self.dropdownMenuItems[indexPath.row];
    
    NSString *reuseIdentifier = self.cellsIds[item.type];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    switch (item.type) {
        case DVDropdownMenuItemCustom:{
            DVDropdownMenuItemCellCustom *cellCustom = (DVDropdownMenuItemCellCustom *)cell;
            if (!cellCustom) {
                cellCustom = [[DVDropdownMenuItemCellCustom alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
            }
            [cellCustom initWithCustomView:item.customView];
            
            cell = cellCustom;
            
            break;
        }
        default:{
            DVDropdownMenuItemCellDefault *cellDefault = (DVDropdownMenuItemCellDefault *)cell;
            if (!cellDefault) {
                cellDefault = [[DVDropdownMenuItemCellDefault alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
            }
            [cellDefault initWithTitle:item.title];
            
            cell = cellDefault;
            
            break;
        }
    }
    
    UIView *selectionView = [UIView new];
    [selectionView setBackgroundColor:item.selectedColor];
    [cell setSelectedBackgroundView:selectionView];
    
    [cell setBackgroundColor:item.backgroundColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DVDropdownMenuItem *item = self.dropdownMenuItems[indexPath.row];
    if (item.handler) item.handler(item);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:DVDropdownMenuItemTouch object:nil];
}

#pragma mark - Actions
- (void)onViewBotomTouch {
    [[NSNotificationCenter defaultCenter] postNotificationName:DVDropdownMenuItemTouch object:nil];
}

#pragma mark Utils
- (CGFloat)tableViewHeightMin {
    return CELL_HEIGHT_DEFAULT * self.dropdownMenuItems.count + HEADER_HEIGHT;
}

@end

#pragma mark -
#pragma mark UINavigationController(DVDropdownMenu)
@interface UINavigationController()
@property (nonatomic, strong) DVDropdownMenu *dvDropdownMenu;
@property (nonatomic, assign) DVDropdownMenuAnimationType dvDropdownMenuAnimationType;
@end
@implementation UINavigationController(DVDropdownMenu)

- (DVDropdownMenu *)dvDropdownMenu {
    DVDropdownMenu *dvDropdownMenu = objc_getAssociatedObject(self, @selector(dvDropdownMenu));
    if (!dvDropdownMenu) {
        dvDropdownMenu = [[DVDropdownMenu alloc] initWithFrame:CGRectMake(.0, .0, CGRectGetWidth(self.navigationBar.frame), .0)];
        [self.view insertSubview:dvDropdownMenu belowSubview:self.navigationBar];
        [self setDvDropdownMenu:dvDropdownMenu];
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dv_hideDropdownMenu) name:DVDropdownMenuItemTouch object:nil];
    [self.dvDropdownMenu setDropdownMenuItems:dv_dropdownMenuItems];
    objc_setAssociatedObject(self, @selector(dv_dropdownMenuItems), dv_dropdownMenuItems, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id<DVDropdownMenuDelegate>)dv_dropdownMenuDelegate {
    return objc_getAssociatedObject(self, @selector(dv_dropdownMenuDelegate));
}

- (void)setDVDropdownMenuDelegate:(id<DVDropdownMenuDelegate>)dv_dropdownMenuDelegate {
    objc_setAssociatedObject(self, @selector(dv_dropdownMenuDelegate), dv_dropdownMenuDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)dv_isDropdownMenuVisible {
    return CGRectGetMinY(self.dvDropdownMenu.frame) >= 0.f;
}

- (DVDropdownMenuAnimationType)dvDropdownMenuAnimationType {
    return [objc_getAssociatedObject(self, @selector(dvDropdownMenuAnimationType)) intValue];
}

- (void)setDvDropdownMenuAnimationType:(DVDropdownMenuAnimationType)dvDropdownMenuAnimationType {
    objc_setAssociatedObject(self,
                             @selector(dvDropdownMenuAnimationType),
                             [NSNumber numberWithInt:dvDropdownMenuAnimationType],
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DVDropdownMenuItemTouch object:nil];
}

#pragma mark Show
#define ANIMATION_DURATION .3
- (void)dv_showDropdownMenuWithAnimation:(DVDropdownMenuAnimationType)animationType completionHandler:(void (^)())completionHandler {
    if (self.dv_isDropdownMenuVisible) return;
    
    self.dvDropdownMenuAnimationType = animationType;
    
    [self dv_dropdownMenuVisible:YES animationType:animationType completionHandler:^{
        if (completionHandler) completionHandler();
        if (self.dv_dropdownMenuDelegate && [self.dv_dropdownMenuDelegate respondsToSelector:@selector(dv_didShowedDropdownMenu)]) {
            [self.dv_dropdownMenuDelegate dv_didShowedDropdownMenu];
        }
    }];
}

- (void)dv_showDropdownMenu {
    [self dv_showDropdownMenuWithAnimation:DVDropdownMenuAnimationTypeDefault completionHandler:nil];
}

- (void)dv_hideDropdownMenuWithCompletionHandler:(void (^)())completionHandler {
    if (!self.dv_isDropdownMenuVisible) return;
    
    [self dv_dropdownMenuVisible:NO animationType:self.dvDropdownMenuAnimationType completionHandler:^{
        self.dvDropdownMenuAnimationType = 0;
        
        if (completionHandler) completionHandler();
        if (self.dv_dropdownMenuDelegate && [self.dv_dropdownMenuDelegate respondsToSelector:@selector(dv_didHiddenDropdownMenu)]) {
            [self.dv_dropdownMenuDelegate dv_didHiddenDropdownMenu];
        }
    }];
}

- (void)dv_hideDropdownMenu {
    [self dv_hideDropdownMenuWithCompletionHandler:nil];
}

- (void)dv_dropdownReloadItems {
    [self.dvDropdownMenu.tableViewMenu reloadData];
}

#pragma mark Actions
- (void)onOutsideTouch {
    [self dv_hideDropdownMenu];
}

#pragma mark - Utils
- (void)dv_dropdownMenuVisible:(BOOL)visible animationType:(DVDropdownMenuAnimationType)animationType completionHandler:(void (^)())completionHandler {
    switch (animationType) {
        case DVDropdownMenuAnimationTypeSpring:{
            CGRect dropdownMenuFrame = self.dvDropdownMenu.frame;
            dropdownMenuFrame.origin.y = visible ? .0 : -CGRectGetHeight(dropdownMenuFrame);
            [UIView animateWithDuration:ANIMATION_DURATION
                                  delay:.0
                 usingSpringWithDamping:.5
                  initialSpringVelocity:.2
                                options:0
                             animations:
             ^{
                 [self.dvDropdownMenu setFrame:dropdownMenuFrame];
             } completion:^(BOOL finished) {
                 if (completionHandler) completionHandler();
             }];
            
            break;
        }
        case DVDropdownMenuAnimationTypeFade:{
            if (visible) {
                [self.dvDropdownMenu setAlpha:.0];
                
                CGRect dropdownMenuFrame = self.dvDropdownMenu.frame;
                dropdownMenuFrame.origin.y = .0;
                [self.dvDropdownMenu setFrame:dropdownMenuFrame];
            }
            
            [UIView animateWithDuration:ANIMATION_DURATION animations:^{
                [self.dvDropdownMenu setAlpha:(visible ? 1. : .0)];
            } completion:^(BOOL finished) {
                if (!visible) {
                    CGRect dropdownMenuFrame = self.dvDropdownMenu.frame;
                    dropdownMenuFrame.origin.y = -CGRectGetHeight(dropdownMenuFrame);
                    [self.dvDropdownMenu setFrame:dropdownMenuFrame];
                    [self.dvDropdownMenu setAlpha:1.];
                }
                
                if (completionHandler) completionHandler();
            }];
            
            break;
        }
//        case DVDropdownMenuAnimationTypeJalousie:{
//            CGRect dropdownMenuFrame = self.dvDropdownMenu.frame;
//            dropdownMenuFrame.origin.y = .0;
//            [self.dvDropdownMenu setFrame:dropdownMenuFrame];
//            
//            for (UITableViewCell *cell in self.dvDropdownMenu.tableViewMenu.visibleCells) {
//                if (visible) {
//                    CATransform3D transform = CATransform3DIdentity;
//                    transform.m34 = -1. / 1500.;
//                    transform = CATransform3DRotate(transform, M_PI_2, 1., .0, .0);
//                    cell.layer.transform = transform;
//                }
//                
//                [UIView animateWithDuration:ANIMATION_DURATION animations:^{
//                    CATransform3D transform = CATransform3DRotate(cell.layer.transform, (visible ? -M_PI_2 : M_PI_2), .1, .0, .0);
//                    cell.layer.transform = transform;
//                } completion:^(BOOL finished) {
//                    if (!visible) {
//                        CGRect dropdownMenuFrame = self.dvDropdownMenu.frame;
//                        dropdownMenuFrame.origin.y = -CGRectGetHeight(dropdownMenuFrame);
//                        [self.dvDropdownMenu setFrame:dropdownMenuFrame];
//                    }
//                    if (completionHandler) completionHandler();
//                }];
//            }
//            
//            break;
//        }
        default:{
            CGRect dropdownMenuFrame = self.dvDropdownMenu.frame;
            dropdownMenuFrame.origin.y = visible ? .0 : -CGRectGetHeight(dropdownMenuFrame);
            [UIView animateWithDuration:ANIMATION_DURATION animations:^{
                [self.dvDropdownMenu setFrame:dropdownMenuFrame];
            } completion:^(BOOL finished) {
                if (completionHandler) completionHandler();
            }];
            
            break;
        }
    }
}

@end

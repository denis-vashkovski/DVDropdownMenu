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
+ (Class)layerClass {
    return [CATransformLayer class];
}
- (void)initWithTitle:(NSAttributedString *)title {
    [self.textLabel setAttributedText:title];
}
@end

NSString * const DVDropdownMenuItemTouch = @"DVDropdownMenuItemTouch";

#pragma mark -
#pragma mark DVDropdownMenu
@interface DVDropdownMenu : UIView<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray<NSString *> *cellsIds;
@property (nonatomic, strong) NSArray<DVDropdownMenuItem *> *dropdownMenuItems;
@property (nonatomic, strong) UITableView *tableViewMenu;
@end
@implementation DVDropdownMenu

#define DV_ITEM_CELL_DEFAULT @"DVDropdownMenuItemCellDefault"
- (NSArray<NSString *> *)cellsIds {
    if (!_cellsIds) {
        _cellsIds = @[ DV_ITEM_CELL_DEFAULT,
                       @"DVDropdownMenuItemCellCustom" ];
    }
    return _cellsIds;
}

- (void)setDropdownMenuItems:(NSArray<DVDropdownMenuItem *> *)dropdownMenuItems {
    _dropdownMenuItems = dropdownMenuItems;
    
    [self updateView];
    
    [self.tableViewMenu registerClass:[DVDropdownMenuItemCellDefault class] forCellReuseIdentifier:DV_ITEM_CELL_DEFAULT];
    [self.tableViewMenu reloadData];
}

- (UITableView *)tableViewMenu {
    if (!_tableViewMenu) {
        _tableViewMenu = [[UITableView alloc] initWithFrame:self.frame style:UITableViewStyleGrouped];
        [_tableViewMenu setBackgroundColor:[UIColor clearColor]];
        [_tableViewMenu setScrollEnabled:NO];
        [_tableViewMenu setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableViewMenu setDataSource:self];
        [_tableViewMenu setDelegate:self];
        [self addSubview:_tableViewMenu];
        
        NSDictionary *views = @{ @"tableViewMenu": _tableViewMenu };
        [_tableViewMenu setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableViewMenu]|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[tableViewMenu]|" options:0 metrics:nil views:views]];
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
    
    [cell setBackgroundColor:[UIColor lightGrayColor]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DVDropdownMenuItem *item = self.dropdownMenuItems[indexPath.row];
    if (item.handler) item.handler(item);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:DVDropdownMenuItemTouch object:nil];
}

#pragma mark Utils
- (void)updateView {
    CGRect frame = self.frame;
    frame.size.height = CELL_HEIGHT_DEFAULT * self.dropdownMenuItems.count + HEADER_HEIGHT;
    frame.origin.y = -frame.size.height;
    [self setFrame:frame];
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
                }
                
                if (completionHandler) completionHandler();
            }];
            
            break;
        }
        case DVDropdownMenuAnimationTypeJalousie:{
            CGRect dropdownMenuFrame = self.dvDropdownMenu.frame;
            dropdownMenuFrame.origin.y = .0;
            [self.dvDropdownMenu setFrame:dropdownMenuFrame];
            
            for (UITableViewCell *cell in self.dvDropdownMenu.tableViewMenu.visibleCells) {
                if (visible) {
                    CATransform3D transform = CATransform3DIdentity;
                    transform.m34 = -1. / 1500.;
                    transform = CATransform3DRotate(transform, M_PI_2, 1., .0, .0);
                    cell.layer.transform = transform;
                }
                
                [UIView animateWithDuration:ANIMATION_DURATION animations:^{
                    CATransform3D transform = CATransform3DRotate(cell.layer.transform, (visible ? -M_PI_2 : M_PI_2), .1, .0, .0);
//                    transform = CATransform3DScale(transform, 1.09, 1., 1.);
                    cell.layer.transform = transform;
                } completion:^(BOOL finished) {
                    if (!visible) {
                        CGRect dropdownMenuFrame = self.dvDropdownMenu.frame;
                        dropdownMenuFrame.origin.y = -CGRectGetHeight(dropdownMenuFrame);
                        [self.dvDropdownMenu setFrame:dropdownMenuFrame];
                    }
                    if (completionHandler) completionHandler();
                }];
            }
            
            break;
        }
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

//
//  ViewController.m
//  DVDropdownMenu_Example
//
//  Created by Denis Vashkovski on 17/08/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "ViewController.h"

#import "UINavigationController+DVDropdownMenu.h"
#import "DVDropdownMenuItem.h"

@interface ViewController ()<DVDropdownMenuDelegate>
@property (nonatomic, strong) UIButton *navigationButton;
@property (weak, nonatomic) IBOutlet UILabel *labelCenter;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    [paragraph setAlignment:NSTextAlignmentCenter];
    
    [self.navigationController setDVDropdownMenuItems:@[ [DVDropdownMenuItem itemWithTitle:[[NSAttributedString alloc] initWithString:@"Test1"
                                                                                                                           attributes:@{ NSParagraphStyleAttributeName: paragraph }]
                                                                                   handler:^(DVDropdownMenuItem *item) {
                                                                                       [self.labelCenter setText:item.title.string];
                                                                                   }],
                                                         [DVDropdownMenuItem itemWithTitle:[[NSAttributedString alloc] initWithString:@"Test2"
                                                                                                                           attributes:@{ NSParagraphStyleAttributeName: paragraph }]
                                                                                   handler:^(DVDropdownMenuItem *item) {
                                                                                       [self.labelCenter setText:item.title.string];
                                                                                   }],
                                                         [DVDropdownMenuItem itemWithTitle:[[NSAttributedString alloc] initWithString:@"Test3"
                                                                                                                           attributes:@{ NSParagraphStyleAttributeName: paragraph }]
                                                                                   handler:^(DVDropdownMenuItem *item) {
                                                                                       [self.labelCenter setText:item.title.string];
                                                                                   }] ]];
    [self.navigationController setDVDropdownMenuDelegate:self];
    
    self.navigationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.navigationButton setBounds:CGRectMake(.0, .0, 100., CGRectGetHeight(self.navigationController.navigationBar.frame))];
    [self.navigationButton setTitle:@"Open" forState:UIControlStateNormal];
    [self.navigationButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.navigationButton addTarget:self action:@selector(onButtonTestTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setTitleView:self.navigationButton];
    
    [self.labelCenter setText:nil];
}

#pragma mark - DVDropdownMenuDelegate
- (void)dv_didShowedDropdownMenu {
    [self.navigationButton setTitle:@"Close" forState:UIControlStateNormal];
}

- (void)dv_didHiddenDropdownMenu {
    [self.navigationButton setTitle:@"Open" forState:UIControlStateNormal];
}

#pragma mark - Actions
- (void)onButtonTestTouch:(UIButton *)sender {
    if (self.navigationController.dv_isDropdownMenuVisible) {
        [self.navigationController dv_hideDropdownMenuWithCompletionHandler:nil];
    } else {
        [self.navigationController dv_showDropdownMenuWithAnimation:DVDropdownMenuAnimationTypeSpring completionHandler:nil];
    }
}

@end

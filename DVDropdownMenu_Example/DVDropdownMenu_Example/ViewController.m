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

@interface ViewController ()<DVDropdownMenuDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, strong) UIButton *navigationButton;
@property (weak, nonatomic) IBOutlet UILabel *labelCenter;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerViewAnimationTypes;

@property (nonatomic, strong) NSArray<NSString *> *animationTypes;
@property (nonatomic) NSUInteger selectedAnimationType;
@end

@implementation ViewController

- (NSArray<NSString *> *)animationTypes {
    if (!_animationTypes) {
        _animationTypes = @[ @"Default",
                             @"Spring",
                             @"Fade" ];
    }
    return _animationTypes;
}

- (void)prepareDropdownMenu {
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    [paragraph setAlignment:NSTextAlignmentCenter];
    
    void (^dropdownMenuItemHandler)(NSString *title) = ^(NSString *title){
        [self.labelCenter setText:[NSString stringWithFormat:@"Item selected: %@", title]];
    };
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_apple"]];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    [self.navigationController setDVDropdownMenuItems:@[ [DVDropdownMenuItem itemWithTitle:[[NSAttributedString alloc] initWithString:@"Test1"
                                                                                                                           attributes:@{ NSParagraphStyleAttributeName: paragraph }]
                                                                           backgroundColor:[UIColor redColor]
                                                                                   handler:^(DVDropdownMenuItem *item) {
                                                                                       dropdownMenuItemHandler(item.title.string);
                                                                                   }],
                                                         [DVDropdownMenuItem itemWithCustomView:imageView
                                                                                        handler:^(DVDropdownMenuItem *item) {
                                                                                            dropdownMenuItemHandler(@"Image");
                                                                                        }],
                                                         [DVDropdownMenuItem itemWithTitle:[[NSAttributedString alloc] initWithString:@"Test3"
                                                                                                                           attributes:@{ NSParagraphStyleAttributeName: paragraph }]
                                                                                   handler:^(DVDropdownMenuItem *item) {
                                                                                       dropdownMenuItemHandler(item.title.string);
                                                                                   }] ]];
    [self.navigationController setDVDropdownMenuDelegate:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareDropdownMenu];
    
    self.navigationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.navigationButton setBounds:CGRectMake(.0, .0, 100., CGRectGetHeight(self.navigationController.navigationBar.frame))];
    [self.navigationButton setTitle:@"Open" forState:UIControlStateNormal];
    [self.navigationButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.navigationButton addTarget:self action:@selector(onButtonTestTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setTitleView:self.navigationButton];
    
    [self.labelCenter setText:nil];
    
    [self.pickerViewAnimationTypes setBackgroundColor:[UIColor lightGrayColor]];
    [self.pickerViewAnimationTypes setDataSource:self];
    [self.pickerViewAnimationTypes setDelegate:self];
    [self.pickerViewAnimationTypes selectRow:self.selectedAnimationType inComponent:0 animated:NO];
}

#pragma mark - UIPickerViewDataSource, UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.animationTypes.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.animationTypes[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectedAnimationType = row;
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
        [self.navigationController dv_showDropdownMenuWithAnimation:(DVDropdownMenuAnimationType)self.selectedAnimationType
                                                  completionHandler:nil];
    }
}

@end

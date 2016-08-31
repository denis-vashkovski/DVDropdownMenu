# DVDropdownMenu

<p align="center">
<img src="DVDropdownMenu_Example/DVDropdownMenu_Example.gif" alt="Sample">
</p>

Dropdown menu for UINavigationBar

## Installation
*DVDropdownMenu requires iOS 7.1 or later.*

### iOS 7

1.  Copying all the files from DVDropdownMenu folder into your project.
2.  Make sure that the files are added to the Target membership.

### Using [CocoaPods](http://cocoapods.org)

1.  Add the pod `DVDropdownMenu` to your [Podfile](http://guides.cocoapods.org/using/the-podfile.html).

        pod 'DVDropdownMenu', :git => 'https://github.com/denis-vashkovski/DVDropdownMenu.git'

2.  Run `pod install` from Terminal, then open your app's `.xcworkspace` file to launch Xcode.

## Basic Usage

Import the classes header.

``` objective-c
#import "UINavigationController+DVDropdownMenu.h"
#import "DVDropdownMenuItem.h"
```

Just create and set your items for dropdown menu and set a delegate if needed.

``` objective-c
- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self.navigationController setDVDropdownMenuItems:@[ [DVDropdownMenuItem itemWithTitle:[[NSAttributedString alloc] initWithString:@"Item1"
                                                                                                                           attributes:@{ NSParagraphStyleAttributeName: paragraph }]
                                                                                   handler:^(DVDropdownMenuItem *item) {
                                                                                       // do something
                                                                                   }],
                                                         [DVDropdownMenuItem itemWithCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image"]]
                                                                                        handler:^(DVDropdownMenuItem *item) {
                                                                                            // do something
                                                                                        }],
                                                         [DVDropdownMenuItem itemWithTitle:[[NSAttributedString alloc] initWithString:@"Item3"
                                                                                                                           attributes:@{ NSParagraphStyleAttributeName: paragraph }]
                                                                                   handler:^(DVDropdownMenuItem *item) {
                                                                                       // do something
                                                                                   }] ]];
    [self.navigationController setDVDropdownMenuDelegate:self];
}
```

Call the method `dv_showDropdownMenuWithAnimation:completionHandler:` for show dropdown menu.

```objective-c
- (void)onButtonDropdownShowTouch:(UIButton *)sender {
    [self.navigationController dv_showDropdownMenuWithAnimation:DVDropdownMenuAnimationTypeDefault
                                                  completionHandler:nil];
}
```

Call the method `dv_hideDropdownMenuWithCompletionHandler:` for show dropdown menu.

```objective-c
- (void)onButtonDropdownHideTouch:(UIButton *)sender {
    [self.navigationController dv_hideDropdownMenuWithCompletionHandler:nil];
}
```

## Delegate (optional)

`DVDropdownMenu` provides two delegate methods. The method `dv_didShowedDropdownMenu` called when dropdown menu appears. The method `dv_didHiddenDropdownMenu` called when dropdown menu disappears.

```objective-c
@interface ViewController () <DVDropdownMenuDelegate>
```

Then implement the delegate functions.

```objective-c
// Called when dropdown menu appears.
- (void)dv_didShowedDropdownMenu {
    // do something
}

// Called when dropdown menu disappears.
- (void)dv_didHiddenDropdownMenu {
    // do something
}
```

## Demo

Build and run the `DVDropdownMenu_Example` project in Xcode to see `DVDropdownMenu` in action.

## Contact

Denis Vashkovski

- https://github.com/denis-vashkovski
- denis.vashkovski.vv@gmail.com

## License

This project is is available under the MIT license. See the LICENSE file for more info. Attribution by linking to the [project page](https://github.com/denis-vashkovski/DVDropdownMenu) is appreciated.

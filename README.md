# PKAlertView - Work In Progress
PKAlertView is a drop-in replacement for UIAlertView that allows the developer to customize the presentation of an alert.

## Dependencies ##
https://github.com/Masonry/Masonry

https://github.com/nicklockwood/FXBlurView

## Installation ##

Simply add `PKAlertView.h + PKAlertView.m` to your xcode project and `#include PKAlertView.h` in the files you want to use PKAlertView. 
Now you're set to go!

## Usage ##

 
 PKAlertView uses `initWithType:​Title:​description:​cancelButtonTitle:​actionButtonTitle:​withCancelCompletion:​withActionCompletion:`  and `show` methods to create and display your alert view. 
 From there PKAlertView handles laying out and animating the view. 

AlertView with two buttons and UITextField :

![PKAlertView](https://raw.githubusercontent.com/paperkite/PKAlertView/master/screenshots/screenshot1.png)


```objective-c

- (void)simpleAlert
{
    PKAlertView *alertView = [[PKAlertView alloc]  initWithType:PKAlertViewTextField
                                                           title:[[NSMutableAttributedString alloc] initWithString:@"Bonjour"]
                                                     description:[[NSMutableAttributedString alloc] initWithString:@"Comment allez-vous ?"]
                                               cancelButtonTitle:[[NSMutableAttributedString alloc] initWithString:@"Cancel"]
                                               actionButtonTitle:[[NSMutableAttributedString alloc] initWithString:@"OK"]
                                            withCancelCompletion:^{
                                                
                                            } withActionCompletion:^(NSString *textFieldString) {

                                            }];
    [alertView show];
}

```

AlertView with single button :

![PKAlertView](https://raw.githubusercontent.com/paperkite/PKAlertView/master/screenshots/screenshot2.png)

```objective-c

- (void)simpleAlert
{
    PKAlertView *alertView = [[PKAlertView alloc]  initWithType:PKAlertViewTextField
                                                          title:[[NSMutableAttributedString alloc] initWithString:@"Bonjour"]
                                                    description:[[NSMutableAttributedString alloc] initWithString:@"Comment allez-vous ?"]
                                              actionButtonTitle:[[NSMutableAttributedString alloc] initWithString:@"OK"]
                                           withActionCompletion:^{
                                               
                                           }];
    
    [alertView show];
}

```

PKAlertView properties
----------------


#### alertViewType

PKAlertView supports two types of alert :

* `PKAlertViewPlain` :Title + message + buttons.
* `PKAlertViewTextField` : Title + message + buttons + UITextField.

```objective-c

- (void)simpleAlert
{
   ...
   alertView.alertViewType = PKAlertViewPlain;
   ...
}

```

#### enterAnimationStyle

* `PKAlertViewPopup` : The PKAlertView will popup from the center of the screen.
* `PKAlertViewSlideDown` : The PKAlertView will slide from the top of the screen.

```objective-c

- (void)simpleAlert
{
   ...
   alertView.enterAnimationStyle = PKAlertViewPopup;
   ...
}

```

![PKAlertView](https://raw.githubusercontent.com/paperkite/PKAlertView/master/screenshots/screenshot3.gif)
![PKAlertView](https://raw.githubusercontent.com/paperkite/PKAlertView/master/screenshots/screenshot4.gif)

#### blurRadius

* Control the blur of the background

```objective-c

- (void)simpleAlert
{
   ...
   alertView.blurRadius =  20;
   ...
}

```

#### blurColor

* The color of the blur in the background, use some alpha to let the background appear.

```objective-c

- (void)simpleAlert
{
   ...
   alertView.blurColor =  [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
   ...
}

```

#### bordersColor

* The border of the button + the UITextField.

```objective-c

- (void)simpleAlert
{
   ...
   alertView.bordersColor =  [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
   ...
}

```

#### alertBackgroundColor

* The background of the alert box.

```objective-c

- (void)simpleAlert
{
   ...
   alertView.alertBackgroundColor =  [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
   ...
}

```

#### cornerRadius

* The corner radius of the alert box.

```objective-c

- (void)simpleAlert
{
   ...
   alertView.cornerRadius =  10;
   ...
}

```

#### textPadding

* The padding for each text in the PKAlertView


#### textField

* The textField when using `PKAlertViewTextField`


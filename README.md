# PKAlertView
PKAlertView is a drop-in replacement for UIAlertView that allows the developer to customize the presentation of an alert.

## Dependencies ##
https://github.com/Masonry/Masonry
https://github.com/nicklockwood/FXBlurView

## Installation ##

Simply add PKAlertView.h + PKAlertView.m to your xcode project and `#include PKAlertView.h` in the files you want to use PKAlertView. Now you're set to go!

## Usage ##

 
 PKAlertView uses `initWithType:​Title:​description:​cancelButtonTitle:​actionButtonTitle:​withCancelCompletion:​withActionCompletion:`  and `show` methods to create and display your alert view. From there PKAlertView handles laying out and animating the view. 

Lets see some code:

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


PKAlertView supports two types of alert.

PKAlertViewType
--------------------

### PKAlertViewPlain ###

Classical AlertView, with title + message + buttons.

### PKAlertViewTextField ###

AlertView, with title + message + buttons + UITextField.







//
//  PKAlertView.h
//  PKAlertView
//
//  Created by Walig Castain on 20/10/14.
//  Copyright (c) 2014 Walig Castain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FXBlurView/FXBlurView.h>
#import "PKAppearance.h"

typedef NS_ENUM(NSInteger, PKAlertViewType) {
    PKAlertViewPlain,
    PKAlertViewTextField,
};

typedef NS_ENUM(NSInteger, PKAlertViewAnimationStyle) {
    PKAlertViewPopup,
    PKAlertViewSlideDown,
};

@interface PKAlertView : FXBlurView <UITextFieldDelegate>

@property (nonatomic, strong) UIColor *blurColor; // color of the background
@property (nonatomic, strong) UIColor *bordersColor; // color of the button border background
@property (nonatomic, strong) UIColor *alertBackgroundColor; // color of the alert background

@property (nonatomic, assign) int cornerRadius;
@property (nonatomic, assign) int textPadding;

@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, assign) PKAlertViewAnimationStyle enterAnimationStyle;
@property (nonatomic, assign) PKAlertViewType alertViewType;

- (instancetype)initWithType:(PKAlertViewType)type title:(NSAttributedString *)title description:(NSAttributedString *)description cancelButtonTitle:(NSAttributedString *)cancelButtonTitle actionButtonTitle:(NSAttributedString *)actionButtonTitle withCancelCompletion:(void (^)())cancelBlock withActionCompletion:(void (^)(NSString *textFieldString))actionBlock;
- (instancetype)initWithType:(PKAlertViewType)type title:(NSAttributedString *)title description:(NSAttributedString *)description actionButtonTitle:(NSAttributedString *)actionButtonTitle withActionCompletion:(void (^)())actionBlock;
- (void)show;
- (void)hide;

# pragma mark - Add method for PKAppearance
+ (id)appearance;

- (void)setTitleAttributes:(NSDictionary *)titleAttributes;
- (void)setDescriptionAttributes:(NSDictionary *)descriptionAttributes;
- (void)setCancelButtonAttributes:(NSDictionary *)cancelButtonAttributes;
- (void)setActionButtonAttributes:(NSDictionary *)actionButtonAttributes;
- (void)setTextFieldBackgroundColor:(UIColor *)backgroundColor;
- (void)setTextFieldTextColor:(UIColor *)textColor;
- (void)setTextFieldPlaceholderColor:(UIColor *)textColor;

@end

//
//  PKAlertView.h
//  PKAlertView
//
//  Created by Walig Castain on 20/10/14.
//  Copyright (c) 2014 Walig Castain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FXBlurView/FXBlurView.h>

@interface PKAlertView : FXBlurView

@property (nonatomic, strong) UIColor *blurColor; // color of the background
@property (nonatomic, strong, getter=alertBackgroundColor, setter=alertBackgroundColor:) UIColor *alertBackgroundColor; // color of the alert background

- (instancetype)initWithTitle:(NSAttributedString *)title description:(NSAttributedString *)description cancelButtonTitle:(NSAttributedString *)cancelButtonTitle actionButtonTitle:(NSAttributedString *)actionButtonTitle withCancelCompletion:(void (^)())cancelBlock withActionCompletion:(void (^)())actionBlock;
- (void)show;
- (void)hide;

@end

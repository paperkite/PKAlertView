//
//  PKAlert.h
//  PKAlertView
//
//  Created by Walig Castain on 20/10/14.
//  Copyright (c) 2014 Walig Castain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FXBlurView/FXBlurView.h>

@interface PKAlert : FXBlurView

@property (nonatomic, strong) UIView *boxView; // view of the box
@property (nonatomic, strong) UIView *backgroundBlurColorView;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;

@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) NSString *cancelButtonTitle;

@property (nonatomic, strong) UIButton *actionButton;
@property (nonatomic, strong) NSString *actionButtonTitle;

@property (nonatomic, strong) UIColor *backgroundColor;

@property (nonatomic, copy) void (^cancelBlock)();
@property (nonatomic, copy) void (^actionBlock)();

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle actionButtonTitle:(NSString *)actionButtonTitle withCancelCompletion:(void (^)())cancelBlock withActionCompletion:(void (^)())actionBlock;
- (void)show;
- (void)hide;



@end

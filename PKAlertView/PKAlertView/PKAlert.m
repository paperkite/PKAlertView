//
//  PKAlert.m
//  PKAlertView
//
//  Created by Walig Castain on 20/10/14.
//  Copyright (c) 2014 Walig Castain. All rights reserved.
//

#import "PKAlert.h"
#import <Masonry/Masonry.h>

@interface PKAlert ()



@end

const int kPadding = 25;
const int kAlertPadding = 45;

@implementation PKAlert

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle actionButtonTitle:(NSString *)actionButtonTitle withCancelCompletion:(void (^)())cancelBlock withActionCompletion:(void (^)())actionBlock
{
    self = [super init];
    if (self) {
        
        self.blurRadius = 10;
        
        self.titleLabel.text = title;
        self.messageLabel.text = message;
        self.cancelButtonTitle = cancelButtonTitle;
        self.actionButtonTitle = actionButtonTitle;
        self.cancelBlock = cancelBlock;
        self.actionBlock = actionBlock;
        
        [self setupView];
        
    }
    
    return self;
}

- (void)cancelButtonAction:(id)sender
{
    [self hide];
    self.cancelBlock();
}

- (void)actionButtonAction:(id)sender
{
    self.actionBlock();
}

- (void)setupView
{
    [self addSubview:self.backgroundBlurColorView];
    
    self.boxView.backgroundColor = self.backgroundColor;
    
    [self.boxView addSubview:self.titleLabel];
    [self.boxView addSubview:self.messageLabel];
    [self.boxView addSubview:self.cancelButton];
    [self.boxView addSubview:self.actionButton];
}

- (void)layoutInWindow:(UIWindow *)window
{

    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.superview);
    }];
    
    [self.backgroundBlurColorView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.backgroundBlurColorView.superview);
    }];
    
    
    [self.boxView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.boxView.superview);
        make.width.equalTo(self.boxView.superview.mas_width).with.offset(-kAlertPadding);
        make.height.equalTo(self.messageLabel.mas_height).with.offset(42*3 + kPadding);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.superview).with.offset(kPadding-10);
        make.centerX.equalTo(self.titleLabel.superview);
        make.width.equalTo(self.boxView.mas_width);
        make.height.equalTo(@42);
    }];

    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(kPadding-10);
        make.width.equalTo(self.boxView.mas_width).with.offset(-kPadding);
        make.centerX.equalTo(self.boxView);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.boxView.mas_bottom).offset(1);
        make.left.equalTo(self.boxView.mas_left).offset(-1);
        make.width.equalTo(self.boxView.mas_width).dividedBy(2);
        make.height.equalTo(@42);
    }];
    
    [self.actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.boxView.mas_bottom).with.offset(1);
        make.right.equalTo(self.boxView.mas_right).with.offset(1); // hide left border
        make.width.equalTo(self.boxView.mas_width).dividedBy(2);
        make.height.equalTo(@42);
    }];
    
}

- (void)show
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];

    self.alpha = 0;
    self.boxView.alpha = 0;
    
    [self addSubview:self.boxView];
    
    [window addSubview:self];
    
    [self layoutInWindow:window];
    

    [UIView animateWithDuration:0.45f
                     animations:^{
                         self.alpha = 1;
                         self.boxView.alpha = 1;
                     }
                     completion:^(BOOL finished) {
                         self.boxView.layer.shouldRasterize = NO;
                     }];
    

    [self.boxView.layer addAnimation:[self slideDownAnimation] forKey:@"popup"];

}

- (void)hide
{
    self.layer.shouldRasterize = YES;

    [UIView animateWithDuration:0.45f
                     animations:^{
                         self.alpha = 0;
                         self.boxView.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         self.boxView.layer.shouldRasterize = NO;
                         [self removeFromSuperview];
                     }];

}

- (CGSize)calculatedHeightWithWidth:(float)textWidth
{
    CGSize maximumLabelSize = CGSizeMake(textWidth, 9999);
    CGSize expectSize = [self.messageLabel sizeThatFits:maximumLabelSize];
    
    return expectSize;
}

- (CAKeyframeAnimation *)popUpAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    CATransform3D scale1 = CATransform3DMakeScale(0.0, 0.0, 1);
    CATransform3D scale2 = CATransform3DMakeScale(1.03, 1.03, 1);
    CATransform3D scale3 = CATransform3DMakeScale(0.97, 0.97, 1);
    CATransform3D scale4 = CATransform3DMakeScale(1.0, 1.0, 1);
    
    NSArray *frameValues = [NSArray arrayWithObjects:
                            [NSValue valueWithCATransform3D:scale1],
                            [NSValue valueWithCATransform3D:scale2],
                            [NSValue valueWithCATransform3D:scale3],
                            [NSValue valueWithCATransform3D:scale4],
                            nil];
    [animation setValues:frameValues];
    
    NSArray *frameTimes = [NSArray arrayWithObjects:
                           [NSNumber numberWithFloat:0.0],
                           [NSNumber numberWithFloat:0.5],
                           [NSNumber numberWithFloat:0.75],
                           [NSNumber numberWithFloat:1.0],
                           nil];
    [animation setKeyTimes:frameTimes];
    
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.duration = .45;
    
    return animation;
}

- (CAKeyframeAnimation *)slideDownAnimation
{
    [self layoutSubviews];

    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position.y"];
    
    NSMutableArray * positionYValues = [NSMutableArray array];
    [positionYValues addObject:[NSNumber numberWithFloat:0]];
    [positionYValues addObject:[NSNumber numberWithFloat:([[UIScreen mainScreen] bounds].size.height/2) + 30]];
    [positionYValues addObject:[NSNumber numberWithFloat:([[UIScreen mainScreen] bounds].size.height/2)]];

    [animation setValues:positionYValues];
    
    NSArray *frameTimes = [NSArray arrayWithObjects:
                           [NSNumber numberWithFloat:0.0],
                           [NSNumber numberWithFloat:0.5],
                           [NSNumber numberWithFloat:1.0],
                           nil];
    [animation setKeyTimes:frameTimes];
    
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = YES;
    animation.duration = .45;
    
    return animation;
}

#pragma mark - Getters
- (UIView *)backgroundBlurColorView
{
    if (!_backgroundBlurColorView) {
        _backgroundBlurColorView = [[UIView alloc] init];
    }
    return _backgroundBlurColorView;
}

- (UIView *)boxView
{
    if (!_boxView) {
        _boxView = [[UIView alloc] init];
        _boxView.layer.cornerRadius = 5;
        _boxView.layer.masksToBounds = YES;
    }
    return _boxView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = self.titleLabel.text;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont fontWithName:@"Avenir-Black" size:18];
        _titleLabel.textColor = [UIColor blackColor];
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}

- (UILabel *)messageLabel
{
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.text = self.titleLabel.text;
        _messageLabel.textAlignment = NSTextAlignmentLeft;
        _messageLabel.font = [UIFont fontWithName:@"Avenir-Black" size:15];
        _messageLabel.textColor = [UIColor blackColor];
        _messageLabel.numberOfLines = 0;
        _messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [_messageLabel sizeToFit];
    }
    return _messageLabel;
}

- (UIColor *)backgroundColor
{
    if (!_backgroundColor) {
        _backgroundColor = [UIColor whiteColor];
    }
    return _backgroundColor;
}

- (UIButton *)cancelButton
{
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] init];
        _cancelButton.backgroundColor = [UIColor clearColor];
        _cancelButton.titleLabel.textColor = [UIColor blackColor];
        _cancelButton.layer.borderWidth = 1.0f;
        [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_cancelButton setTitle:@"I'll sign up later" forState:UIControlStateNormal];
    }
    return _cancelButton;
}

- (UIButton *)actionButton
{
    if (!_actionButton) {
        _actionButton = [[UIButton alloc] init];
        _actionButton.backgroundColor = [UIColor clearColor];
        _actionButton.titleLabel.textColor = [UIColor blackColor];
        _actionButton.layer.borderWidth = 1.0f;
        _actionButton.layer.borderColor = [UIColor blackColor].CGColor;
        [_actionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_actionButton addTarget:self action:@selector(actionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_actionButton setTitle:self.actionButtonTitle forState:UIControlStateNormal];
    }
    return _actionButton;
}

@end

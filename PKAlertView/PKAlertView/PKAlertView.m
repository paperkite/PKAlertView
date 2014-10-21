//
//  PKAlertView.m
//  PKAlertView
//
//  Created by Walig Castain on 20/10/14.
//  Copyright (c) 2014 Walig Castain. All rights reserved.
//
#import "PKAlertView.h"
#import <Masonry/Masonry.h>

@interface PKAlertView ()

@property (nonatomic, strong) UIView *alertView; 
@property (nonatomic, strong) UIView *backgroundBlurColorView;

@property (nonatomic, strong) NSAttributedString *titleAttributedString;
@property (nonatomic, strong) NSAttributedString *descriptionAttributedString;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;

@property (nonatomic, strong) NSAttributedString *cancelButtonTitle;
@property (nonatomic, strong) NSAttributedString *actionButtonTitle;

@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *actionButton;

@property (nonatomic, assign) NSInteger alertViewOffSet;

@property (nonatomic, copy) void (^cancelBlock)();
@property (nonatomic, copy) void (^actionBlock)();

@end

const int kAlertPadding = 45;

@implementation PKAlertView

@synthesize bordersColor = _bordersColor;
@synthesize alertBackgroundColor = _alertBackgroundColor; 
@synthesize cornerRadius = _cornerRadius;
@synthesize textPadding = _textPadding;

- (instancetype)initWithType:(PKAlertViewType)type title:(NSAttributedString *)title description:(NSAttributedString *)description cancelButtonTitle:(NSAttributedString *)cancelButtonTitle actionButtonTitle:(NSAttributedString *)actionButtonTitle withCancelCompletion:(void (^)())cancelBlock withActionCompletion:(void (^)(NSString *textFieldString))actionBlock
{
    self = [super init];
    if (self) {
        
        self.alertViewOffSet = 0;
        self.blurRadius = 10;
        self.tintColor = [UIColor blackColor];
        
        self.enterAnimationStyle = PKAlertViewSlideDown;
        self.alertViewType = type;

        self.titleAttributedString = title;
        self.descriptionAttributedString = description;
        
        self.cancelButtonTitle = cancelButtonTitle;
        self.actionButtonTitle = actionButtonTitle;
        
        self.cancelBlock = cancelBlock;
        self.actionBlock = actionBlock;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];

        [self setupView];
    }
    
    return self;
}

- (instancetype)initWithType:(PKAlertViewType)type title:(NSAttributedString *)title description:(NSAttributedString *)description actionButtonTitle:(NSAttributedString *)actionButtonTitle withActionCompletion:(void (^)())actionBlock
{
    self = [super init];
    if (self) {
        
        self.alertViewOffSet = 0;
        self.blurRadius = 10;
        self.tintColor = [UIColor blackColor];
        
        self.enterAnimationStyle = PKAlertViewSlideDown;
        self.alertViewType = type;
        
        self.titleAttributedString = title;
        self.descriptionAttributedString = description;
        
        self.actionButtonTitle = actionButtonTitle;
        
        self.actionBlock = actionBlock;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
        
        [self setupView];
    }
    
    return self;
}

- (void)setupView
{
    [self addSubview:self.backgroundBlurColorView];
    
    self.alertView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.alertView addSubview:self.titleLabel];
    [self.alertView addSubview:self.descriptionLabel];
    [self.alertView addSubview:self.actionButton];
    
    // if there is a cancel title
    if (self.cancelButtonTitle) {
        [self.alertView addSubview:self.cancelButton];
    }
    
    if (self.alertViewType == PKAlertViewTextField) {
        [self.alertView addSubview:self.textField];
    }
}

- (void)layoutSubviews
{
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.superview);
    }];
    
    [self.backgroundBlurColorView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.backgroundBlurColorView.superview);
    }];
    
    [self.alertView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.alertView.superview);
        make.centerY.equalTo(self.alertView.superview).with.offset(self.alertViewOffSet);
        make.width.equalTo(self.alertView.superview.mas_width).with.offset(-kAlertPadding);
        make.bottom.equalTo(self.actionButton.mas_bottom).with.offset(-1);
    }];

    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.superview).with.offset(self.textPadding);
        make.centerX.equalTo(self.titleLabel.superview);
        make.width.equalTo(self.alertView.mas_width);
        make.height.equalTo(@42);
    }];

    [self.descriptionLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(0);
        make.width.equalTo(self.alertView.mas_width).with.offset(-self.textPadding);
        make.centerX.equalTo(self.alertView);
    }];

    // if there is a textField
    if (self.alertViewType == PKAlertViewTextField) {
        
        [self.textField mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.descriptionLabel.mas_bottom).with.offset(self.textPadding);
            make.left.equalTo(self.alertView.mas_left).with.offset(self.textPadding); // hide left border
            make.right.equalTo(self.alertView.mas_right).with.offset(-self.textPadding); // hide left border
            make.height.equalTo(@30);
        }];

    }

    // if there is a cancel title update the button
    if (self.cancelButtonTitle) {
        
        [self.cancelButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.alertView.mas_left).offset(-1);
            make.width.equalTo(self.alertView.mas_width).dividedBy(2).offset(2);
            make.height.equalTo(self.actionButton.mas_height);

            if (self.alertViewType == PKAlertViewTextField) {
                make.top.equalTo(self.textField.mas_bottom).with.offset(self.textPadding);
            } else {
                make.top.equalTo(self.descriptionLabel.mas_bottom).with.offset(self.textPadding);
            }
        }];
    }

    [self.actionButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.alertView.mas_right).with.offset(1); // hide left border
        make.height.equalTo(@42);

        if (self.alertViewType == PKAlertViewTextField) {
            make.top.equalTo(self.textField.mas_bottom).with.offset(self.textPadding);
        } else {
            make.top.equalTo(self.descriptionLabel.mas_bottom).with.offset(self.textPadding);
        }
        
        if (self.cancelButtonTitle) {
            make.width.equalTo(self.alertView.mas_width).dividedBy(2).offset(1);
        } else {
            make.width.equalTo(self.alertView.mas_width).with.offset(3); // hide borders
        }
    }];

    [super layoutSubviews];
}

# pragma mark - Show / Hide
- (void)show
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];

    self.alpha = 0;
    self.alertView.alpha = 0;
    
    [self addSubview:self.alertView];
    [window addSubview:self];
    
    [self layoutSubviews];

    [UIView animateWithDuration:0.45f
                     animations:^{
                         self.alpha = 1;
                         self.alertView.alpha = 1;
                     }
                     completion:^(BOOL finished) {
                         self.alertView.layer.shouldRasterize = NO;
                     }];
    
    
    if (self.enterAnimationStyle == PKAlertViewSlideDown) {
        [self.alertView.layer addAnimation:[self slideDownAnimation] forKey:@"popup"];
    }else {
        [self.alertView.layer addAnimation:[self popUpAnimation] forKey:@"popup"];
    }
}

- (void)hide
{
    self.layer.shouldRasterize = YES;

    [UIView animateWithDuration:0.45f
                     animations:^{
                         self.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         self.alertView.layer.shouldRasterize = NO;
                         
                         [self removeFromSuperview];
                     }];

}

# pragma mark - Animations
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
    [positionYValues addObject:[NSNumber numberWithDouble:0]];
    [positionYValues addObject:[NSNumber numberWithDouble:([[UIScreen mainScreen] bounds].size.height/2) + 20]];
    [positionYValues addObject:[NSNumber numberWithDouble:([[UIScreen mainScreen] bounds].size.height/2)]];

    [animation setValues:positionYValues];
    
    NSArray *frameTimes = [NSArray arrayWithObjects:
                           [NSNumber numberWithFloat:0.0f],
                           [NSNumber numberWithFloat:0.6f],
                           [NSNumber numberWithFloat:1.0f],
                           nil];
    [animation setKeyTimes:frameTimes];
    
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = YES;
    animation.duration = .45;
    
    return animation;
}


# pragma mark - Button actions
- (void)cancelButtonAction:(id)sender
{
    [self hide];
    self.cancelBlock();
}

- (void)actionButtonAction:(id)sender
{
    [self hide];
    self.actionBlock(self.textField.text);
}

# pragma mark - Keyboard notification
- (void)keyboardWillChange:(NSNotification *)notification
{
    CGRect keyboardRect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];

    self.alertViewOffSet = (long)-keyboardRect.size.height;

    [UIView animateWithDuration:0.3 animations:^{
        [self layoutSubviews];
    }];
}

# pragma mark - TextField Action
- (void)textFieldFinished:(id)sender
{
    [sender resignFirstResponder];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

# pragma mark - UITextField Protocol
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.alertViewOffSet = 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutSubviews];
    }];
}


#pragma mark - Getters
- (UIView *)backgroundBlurColorView
{
    if (!_backgroundBlurColorView) {
        _backgroundBlurColorView = [[UIView alloc] init];
    }
    return _backgroundBlurColorView;
}

- (UIView *)alertView
{
    if (!_alertView) {
        _alertView = [[UIView alloc] init];
        _alertView.backgroundColor = self.alertBackgroundColor;
        _alertView.layer.cornerRadius = 5;
        _alertView.layer.masksToBounds = YES;
    }
    return _alertView;
}

- (int)cornerRadius
{
    if (!_cornerRadius) {
        _cornerRadius = 5;
    }
    return _cornerRadius;
}

- (int)textPadding
{
    if (!_textPadding) {
        _textPadding = 25;
    }
    return _textPadding;
}

- (UIColor *)alertBackgroundColor
{
    if (!_alertBackgroundColor) {
        _alertBackgroundColor = [UIColor whiteColor];
    }
    return _alertBackgroundColor;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont fontWithName:@"Avenir-Black" size:18];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.attributedText = self.titleAttributedString;
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}

- (UILabel *)descriptionLabel
{
    if (!_descriptionLabel) {
        _descriptionLabel = [[UILabel alloc] init];
        _descriptionLabel.textAlignment = NSTextAlignmentCenter;
        _descriptionLabel.textColor = [UIColor blackColor];
        _descriptionLabel.font = [UIFont fontWithName:@"Avenir-Black" size:15];
        _descriptionLabel.numberOfLines = 0;
        _descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _descriptionLabel.attributedText = self.descriptionAttributedString;
        [_descriptionLabel sizeToFit];
    }
    return _descriptionLabel;
}

- (UIButton *)cancelButton
{
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] init];
        _cancelButton.backgroundColor = [UIColor clearColor];
        _cancelButton.layer.borderColor = self.bordersColor.CGColor;
        _cancelButton.layer.borderWidth = 1.0f;
        [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_cancelButton setAttributedTitle:self.cancelButtonTitle forState:UIControlStateNormal];
    }
    return _cancelButton;
}

- (UIButton *)actionButton
{
    if (!_actionButton) {
        _actionButton = [[UIButton alloc] init];
        _actionButton.backgroundColor = [UIColor clearColor];
        _actionButton.titleLabel.textColor = [UIColor blackColor];
        _actionButton.layer.borderColor = self.bordersColor.CGColor;
        _actionButton.layer.borderWidth = 1.0f;
        _actionButton.layer.borderColor = [UIColor blackColor].CGColor;
        [_actionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_actionButton addTarget:self action:@selector(actionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_actionButton setAttributedTitle:self.actionButtonTitle forState:UIControlStateNormal];
    }
    return _actionButton;
}

- (UIColor *)bordersColor
{
    if (!_bordersColor) {
        _bordersColor = [UIColor blackColor];
    }
    return _bordersColor;
}

- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.backgroundColor = [UIColor whiteColor];
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.layer.borderColor = self.bordersColor.CGColor;
        _textField.layer.borderWidth =  1.0f;
        _textField.keyboardType = UIKeyboardTypeDefault;
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _textField.leftViewMode = UITextFieldViewModeAlways;
        _textField.delegate = self;
        _textField.font = [UIFont fontWithName:@"Avenir-Book" size:15];
        _textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(10,0,7,26)];
        [_textField addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];

    }
    return _textField;
    
}

#pragma mark - Setters
- (void)setBlurColor:(UIColor *)blurColor
{
    _blurColor = blurColor;
    self.backgroundBlurColorView.backgroundColor = blurColor;
    [self setNeedsDisplay];
}

- (void)setAlertBackgroundColor:(UIColor *)alertBackgroundColor
{
    _alertBackgroundColor = alertBackgroundColor;
    self.alertView.backgroundColor = alertBackgroundColor;
}

- (void)setCornerRadius:(int)cornerRadius
{
    _cornerRadius = cornerRadius;
    _alertView.layer.cornerRadius = cornerRadius;
}

- (void)setTextPadding:(int)textPadding
{
    _textPadding = textPadding;
    [self updateConstraints];
}

- (void)setBordersColor:(UIColor *)bordersColor
{
    _bordersColor = bordersColor;

    _actionButton.layer.borderColor = bordersColor.CGColor;
    
    _cancelButton.layer.borderColor = bordersColor.CGColor;
    
    _textField.layer.borderColor = bordersColor.CGColor;
}

@end

//
//  FTPickerView.m
//  FTSchedulePicker
//
//  Created by Fabio Takahara on 03/03/16.
//  Copyright © 2016 Fabio Takahara. All rights reserved.
//

#import "FTPickerView.h"

@implementation FTPickerView

- (id)initWithFrame:(CGRect)frame andObject:(FTSchedulePickerObject*)pickerObject{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        _startRect = frame;
        
        self.backgroundColor = [UIColor whiteColor];
        
        _timeTextField = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, 200, frame.size.height)];
        _timeTextField.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:38.0f];
        _timeTextField.text = [self stringFromDate:pickerObject.pickerTime];
        _timeTextField.textAlignment = NSTextAlignmentLeft;
        _timeTextField.delegate = self;
        
        UIDatePicker *timePicker = [[UIDatePicker alloc] init];
        timePicker.datePickerMode = UIDatePickerModeTime;
        timePicker.date = pickerObject.pickerTime;
        [timePicker addTarget:self action:@selector(timeIsChanged:) forControlEvents:UIControlEventValueChanged];
        //timePicker.timeZone = [NSTimeZone localTimeZone];
        [_timeTextField setInputView:timePicker];
        
        [self addSubview:_timeTextField];
        
        
        if (pickerObject.enable == YES) {
            
            self.layer.shadowColor = [UIColor colorWithRed:52./255. green:109./255. blue:241./255. alpha:1.0].CGColor;
            self.layer.shadowOpacity = 1;
            self.layer.shadowOffset = CGSizeMake(1, 1);
            self.layer.masksToBounds = NO;
            _timeTextField.textColor = [UIColor colorWithRed:52./255. green:109./255. blue:241./255. alpha:.6];
            
        }else {
            
            self.layer.shadowColor = [UIColor blackColor].CGColor;
            self.layer.shadowOpacity = 0.4;
            self.layer.shadowOffset = CGSizeMake(1, 1);
            self.layer.masksToBounds = NO;
            _timeTextField.textColor = [UIColor lightGrayColor];
        }
        
        
        JTMaterialSwitch *materialSwitch = [[JTMaterialSwitch alloc] initWithSize:JTMaterialSwitchSizeNormal style:JTMaterialSwitchStyleDefault state:JTMaterialSwitchStateOn];
        materialSwitch.frame = CGRectMake(frame.size.width - 60, 15, 50, 30);
        materialSwitch.isOn = pickerObject.enable;
        [materialSwitch addTarget:self action:@selector(stateChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:materialSwitch];
        
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
        [self addGestureRecognizer:panGestureRecognizer];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andAddString:(NSString*)addString {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.shadowColor = [UIColor colorWithRed:52./255. green:109./255. blue:241./255. alpha:1.0].CGColor;
        self.layer.shadowOpacity = 1;
        self.layer.shadowOffset = CGSizeMake(1, 1);
        self.layer.masksToBounds = NO;
        
        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        addButton.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        addButton.titleLabel.textColor = [UIColor colorWithRed:52./255. green:109./255. blue:241./255. alpha:.6];
        addButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:24.0f];
        addButton.backgroundColor = [UIColor colorWithRed:52./255. green:109./255. blue:241./255. alpha:1];
        [addButton setTitle:@"Adicionar horário" forState:UIControlStateNormal];
        [addButton addTarget:_customDelegate action:@selector(addNewSchedule) forControlEvents:UIControlEventTouchDown];
        [self addSubview:addButton];
        
    }
    return self;
}

- (void)handlePan:(UIPanGestureRecognizer*)recognizer {
    
    CGPoint translation = [recognizer translationInView:self];
    
    if (recognizer.state == UIGestureRecognizerStateChanged) {
    
        float currentTransition = translation.x;
        if (currentTransition > 0) currentTransition = -currentTransition;
        
        CGRect btFrame = self.frame;
        btFrame.origin.x = translation.x + 10;
        self.frame = btFrame;
        self.alpha = 1 - (currentTransition / -200);
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        
        if (translation.x > -120 && translation.x < 120) {
            
            [UIView animateWithDuration:0.3 animations:^{
                self.frame = _startRect;
                self.alpha = 1;
            }];
            
        }else {
            
            int dismissFrame = 500;
            
            if (translation.x < 0) dismissFrame = -500;
            
            [UIView animateWithDuration:0.3 animations:^{
                self.frame = CGRectMake(dismissFrame, _startRect.origin.y, _startRect.size.width, _startRect.size.height);
                self.alpha = 0;
                
            } completion:^(BOOL finished) {
                
                if ([_customDelegate respondsToSelector:@selector(pickerDidDismissWithIndex:)]) {
                    [_customDelegate performSelector:@selector(pickerDidDismissWithIndex:) withObject:[NSNumber numberWithInt:_index]];
                }
                
                [self removeFromSuperview];
            }];
        }
    }
}

- (void)stateChanged:(JTMaterialSwitch*)sender {
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        if (sender.isOn) {
            
            [UIView transitionWithView:self duration:.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                
                _timeTextField.textColor = [UIColor colorWithRed:52./255. green:109./255. blue:241./255. alpha:.6];
                self.layer.shadowColor = [UIColor colorWithRed:52./255. green:109./255. blue:241./255. alpha:1.0].CGColor;
                self.layer.shadowOpacity = 1;
                
            } completion:nil];
            
        }else {
            
            [UIView transitionWithView:self duration:.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                
                _timeTextField.textColor = [UIColor lightGrayColor];
                self.layer.shadowColor = [UIColor blackColor].CGColor;
                self.layer.shadowOpacity = 0.4;
                
            } completion:nil];
        }
    });
}

#pragma mark - Action Methods

- (void)timeIsChanged:(id)sender {
    
    UIDatePicker *timePicker = (UIDatePicker*)sender;
    
    NSDateFormatter *datePickerFormat = [[NSDateFormatter alloc] init];
    [datePickerFormat setDateFormat:@"HH mm"];
    NSString *datePickerString = [datePickerFormat stringFromDate:timePicker.date];
    NSArray *timeStringArray = [datePickerString componentsSeparatedByString:@" "];

    _timeTextField.text = [NSString stringWithFormat:@"%@:%@", timeStringArray[0], timeStringArray[1]];
}

#pragma mark - Conversion Methods

- (NSString*)stringFromDate:(NSDate*)date {
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat: @"HH:mm"];
    return [dateFormat stringFromDate:date];
}

#pragma mark - UITextfieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if ([_customDelegate respondsToSelector:@selector(selectPickerAtIndex:)]) {
        [_customDelegate performSelector:@selector(selectPickerAtIndex:) withObject:[NSNumber numberWithInt:_index]];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40);
    doneButton.backgroundColor = [UIColor lightGrayColor];
    doneButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:24.0f];
    doneButton.titleLabel.textColor = [UIColor whiteColor];
    [doneButton setTitle:@"Concluir" forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(donePressed) forControlEvents:UIControlEventTouchDown];
    
    textField.inputAccessoryView = doneButton;
    
    return YES;
}

- (void)donePressed {
    
    [_timeTextField resignFirstResponder];
    if ([_customDelegate respondsToSelector:@selector(doneAction)]) {
        [_customDelegate performSelector:@selector(doneAction)];
    }
    if ([_customDelegate respondsToSelector:@selector(selectPickerAtIndex:)]) {
        [_customDelegate performSelector:@selector(selectPickerAtIndex:) withObject:[NSNumber numberWithInt:0]];
    }
}

#pragma mark - Discard

- (void)selectPickerAtIndex:(NSNumber*)index {
    
}

@end

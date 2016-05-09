//
//  FTSchedulePickerView.m
//  FTSchedulePicker
//
//  Created by Fabio Takahara on 03/03/16.
//  Copyright © 2016 Fabio Takahara. All rights reserved.
//

#import "FTSchedulePickerView.h"

@implementation FTSchedulePickerView

- (id)initWithFrame:(CGRect)frame andObjects:(NSArray*)pickerObjects {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.contentSize = CGSizeMake(0, 1000);
        _pickerViewArray = @[].mutableCopy;
        
        for (int i = 0; i < pickerObjects.count + 1; i++) {
            
            if (i == pickerObjects.count) {
                
                FTPickerView *pickerView = [[FTPickerView alloc]initWithFrame:CGRectMake(10, (70 * i) + 5, frame.size.width - 20, 60) andAddString:@"Adicionar horário"];
                [_pickerViewArray addObject:pickerView];
                [self addSubview:pickerView];
                
            }else {
                
                FTSchedulePickerObject *ftPickerObject = (FTSchedulePickerObject*)pickerObjects[i];
                FTPickerView *pickerView = [[FTPickerView alloc]initWithFrame:CGRectMake(10, (70 * i) + 5, frame.size.width - 20, 60)andObject:ftPickerObject];
                pickerView.customDelegate = self;
                pickerView.index = i;
                [self addSubview:pickerView];
                
                [_pickerViewArray addObject:pickerView];
            }
        }
    }
    return self;
}

#pragma mark - FTSchedulePickerViewDelegate

- (void)pickerDidDismissWithIndex:(NSNumber*)index {
 
    [_pickerViewArray removeObjectAtIndex:[index intValue]];
    
    for (int i = 0; i < _pickerViewArray.count; i++) {
        
        FTPickerView *ftPickerView = _pickerViewArray[i];
        ftPickerView.index = i;
        
        if (i >= [index intValue]) {
            
            [UIView animateWithDuration:0.3 animations:^{
                
                CGRect frame = ftPickerView.frame;
                frame.origin.y = frame.origin.y - 70;
                ftPickerView.frame = frame;
                ftPickerView.startRect = frame;
                
            }];
        }
        [_pickerViewArray replaceObjectAtIndex:i withObject:ftPickerView];
    }
}

- (void)addNewSchedule {
    
    FTPickerView *ftPickerView = [_pickerViewArray lastObject];
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect frame = ftPickerView.frame;
        frame.origin.y = frame.origin.y + 70;
        ftPickerView.frame = frame;
        ftPickerView.startRect = frame;
        
    }];
    
    FTSchedulePickerObject *ftPickerObject = [[FTSchedulePickerObject alloc]init];
    ftPickerObject.enable = YES;
    ftPickerObject.pickerTime = [self startDate];
    
    FTPickerView *pickerView = [[FTPickerView alloc]initWithFrame:CGRectMake(500, (70 * (_pickerViewArray.count - 1)) + 5, self.frame.size.width - 20, 60)andObject:ftPickerObject];
    pickerView.customDelegate = self;
    pickerView.index = (int)_pickerViewArray.count - 1;
    [self addSubview:pickerView];
    
    [UIView animateWithDuration:.6 animations:^{
        pickerView.frame = CGRectMake(10, (70 * (_pickerViewArray.count - 1)) + 5, self.frame.size.width - 20, 60);
    }completion:^(BOOL finished) {
        [pickerView.timeTextField becomeFirstResponder];
    }];
    
    [_pickerViewArray insertObject:pickerView atIndex:_pickerViewArray.count - 1];
}

- (void)selectPickerAtIndex:(NSNumber*)index {
    
    [self setContentOffset:CGPointMake(0, [index intValue] * 70) animated:YES];
}

- (void)doneAction {
    
    NSMutableArray *pickerArray = @[].mutableCopy;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm"];
    
    for (FTPickerView *ftPickerView in _pickerViewArray) {
        
        FTSchedulePickerObject *pickerObject = [[FTSchedulePickerObject alloc]init];
        pickerObject.enable = ftPickerView.enable;
        pickerObject.pickerTime = [dateFormatter dateFromString:ftPickerView.timeTextField.text];
        
        [pickerArray addObject:pickerObject];
    }
    
    [pickerArray removeLastObject];
    
    if ([_customDelegate respondsToSelector:@selector(getPickerViewArray:)]) {
        [_customDelegate performSelector:@selector(getPickerViewArray:) withObject:pickerArray];
    }
}

#pragma mark - Convertion Methods

- (NSDate*)startDate {
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond ) fromDate:[NSDate date]];
    
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    
    return [cal dateFromComponents:components];
}

@end

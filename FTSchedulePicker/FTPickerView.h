//
//  FTPickerView.h
//  FTSchedulePicker
//
//  Created by Fabio Takahara on 03/03/16.
//  Copyright © 2016 Fabio Takahara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTMaterialSwitch.h"
#import "FTSchedulePickerObject.h"
#import "FTSchedulePickerView.h"

@protocol FTPickerViewCustomDelegate <NSObject>
- (void)pickerDidDismissWithIndex:(NSNumber*)index;
- (void)addNewSchedule;
- (void)selectPickerAtIndex:(NSNumber*)index;
- (void)doneAction;
@end

@interface FTPickerView : UIView <UITextFieldDelegate>

- (id)initWithFrame:(CGRect)frame andObject:(FTSchedulePickerObject*)pickerObject;
- (id)initWithFrame:(CGRect)frame andAddString:(NSString*)addString;

@property (nonatomic, strong) UITextField *timeTextField;
@property (nonatomic, assign) CGRect startRect;
@property (nonatomic, strong) id customDelegate;
@property (nonatomic, assign) int index;

@end

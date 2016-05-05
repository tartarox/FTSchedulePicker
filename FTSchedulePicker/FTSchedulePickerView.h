//
//  FTSchedulePickerView.h
//  FTSchedulePicker
//
//  Created by Fabio Takahara on 03/03/16.
//  Copyright © 2016 Fabio Takahara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTPickerView.h"
#import "FTSchedulePickerObject.h"

@interface FTSchedulePickerView : UIScrollView <UIPickerViewDelegate>{
    
}

- (id)initWithFrame:(CGRect)frame andObjects:(NSArray*)pickerObjects;

@property (nonatomic, strong) NSMutableArray *pickerViewArray;

@end

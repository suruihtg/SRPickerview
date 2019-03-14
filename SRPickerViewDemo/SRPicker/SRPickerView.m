//
//  SRPickerView.m
//  TupianKankan
//
//  Created by ryan on 2019/3/13.
//  Copyright © 2019 HAMAN. All rights reserved.
//

#import "SRPickerView.h"

@interface SRPickerView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *myPicker;
//@property (nonatomic, strong) UIToolbar *myToolBar;
@property (nonatomic, strong) UIView *pickerViewContainerView;
@property (nonatomic, strong) UIView *pickerContainerView;
@property (nonatomic, strong) UIView *pickerTopBarView;

@property (nonatomic, strong) UIButton *doneButton;
@property (nonatomic, strong) UIButton *cancelButton;

// color
@property (nonatomic, strong) UIColor *btnColor;
@property (nonatomic, strong) UIColor *pickerColor;
@property (nonatomic, strong) UIColor *toolBarColor;

// data
@property (nonatomic, strong) NSArray <SupportPickerData *> *dataArray;
@property (nonatomic, strong) SupportPickerData *currentData;

@property (copy) void (^onDismissCompletion)(NSString *, NSString *);

@property (nonatomic, copy) NSString *lastSelect;

@end

@implementation SRPickerView

#pragma mark - 单例

+ (SRPickerView *)targetView{
    static dispatch_once_t onceToken;
    static SRPickerView *targetView;
    dispatch_once(&onceToken, ^{
        targetView = [[self alloc] init];
    });
    return targetView;
}


#pragma mark - Show Method

+ (void)showPickerViewInView:(UIView *)showView
               withOriString:(NSString *)oriString
               withDataArray:(NSArray <SupportPickerData *> *)dataArray
                  completion:(void(^)(NSString *selectString, NSString *selectId))completion{
 
    [[self targetView] initializePickerViewWithData:dataArray last:oriString];
    [[self targetView] setPickerHidden:NO];
    [self targetView].onDismissCompletion = completion;
    if (showView == nil) {
        [[UIApplication sharedApplication].keyWindow addSubview:[self targetView]];
    }else{
        [showView addSubview:[self targetView]];
    }
}

#pragma mark - Init

- (void)initializePickerViewWithData:(NSArray <SupportPickerData *> *)data last:(NSString *)last{
 
    CGRect pickBounds = [UIApplication sharedApplication].keyWindow.bounds;
    
    [self setupColor];
    
    _dataArray = [NSArray arrayWithArray:data];
    
    _currentData = data.firstObject;
    
    [self setFrame:pickBounds];
    [self setBackgroundColor:[UIColor clearColor]];
    
    _pickerViewContainerView = [[UIView alloc] initWithFrame:pickBounds];
    [_pickerViewContainerView setBackgroundColor:[UIColor colorWithRed:0.412 green:0.412 blue:0.412 alpha:0.7]];
    
    [self addSubview:_pickerViewContainerView];
    
    _pickerContainerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, _pickerViewContainerView.bounds.size.height - 260.0, CGRectGetWidth([UIScreen mainScreen].bounds), 260)];
    
     [_pickerViewContainerView addSubview:_pickerContainerView];
    
    _pickerContainerView.backgroundColor = _pickerColor;
    
    _myPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 44.0, CGRectGetWidth([UIScreen mainScreen].bounds), 216.f)];
    [_myPicker setDelegate:self];
    [_myPicker setDataSource:self];
    [_myPicker setShowsSelectionIndicator:YES];
    [_pickerContainerView addSubview:_myPicker];
    
    
    _pickerTopBarView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, _pickerContainerView.frame.size.width, 44.f)];
    [_pickerContainerView addSubview:_pickerTopBarView];
    [_pickerTopBarView setBackgroundColor:_toolBarColor];
    
    _doneButton = [[UIButton alloc] initWithFrame:CGRectMake(_pickerContainerView.frame.size.width - 60.f, 10, 60, 24.f)];
    _doneButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_doneButton setTitleColor:_btnColor forState:UIControlStateNormal];
    [_doneButton setTitle:@"确定" forState:UIControlStateNormal];
    [_doneButton addTarget:self action:@selector(choosePicker) forControlEvents:UIControlEventTouchUpInside];
    [_pickerTopBarView addSubview:_doneButton];
    
    _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 10.f, 60.f, 24.f)];
    [_cancelButton setTitleColor:_btnColor forState:UIControlStateNormal];
    _cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelButton addTarget:self action:@selector(dismissPicker) forControlEvents:UIControlEventTouchUpInside];
    [_pickerTopBarView addSubview:_cancelButton];
    
    
    [_pickerContainerView setTransform:CGAffineTransformMakeTranslation(0.0, CGRectGetHeight(_pickerContainerView.frame))];
    
    if (last) {
        // select
        [_dataArray enumerateObjectsUsingBlock:^(SupportPickerData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([last isEqualToString:obj.name]) {
                [self.myPicker selectRow:idx inComponent:0 animated:YES];
            }
        }];
    }
}

- (void)setupColor{
 
    self.btnColor = [UIColor blueColor];
    
    self.toolBarColor = [UIColor whiteColor];
    
    self.pickerColor = [UIColor whiteColor];
}


- (void)choosePicker{
 
    self.onDismissCompletion(self.currentData.name, self.currentData.uploadId);
    
    [self dismissPicker];
}


#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
 
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
 
    return self.dataArray.count > 0 ? self.dataArray.count : 0;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
 
    SupportPickerData *data = self.dataArray[row];
    
    return data.name?:@"";
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    SupportPickerData *data = self.dataArray[row];
    
    self.currentData = data;
}


#pragma mark - Dismiss Method

- (void)removePickerView{
    
    [self removeFromSuperview];
}

- (void)setPickerHidden:(BOOL)isHidden{
 
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        if (isHidden) {
            [weakSelf.pickerViewContainerView setAlpha:0.0];
            [weakSelf.pickerContainerView setTransform:CGAffineTransformMakeTranslation(0.0, CGRectGetHeight(weakSelf.pickerContainerView.frame))];
        }else{
            [weakSelf.pickerViewContainerView setAlpha:1.0];
            [weakSelf.pickerContainerView setTransform:CGAffineTransformIdentity];
        }
    } completion:^(BOOL finished) {
        if (isHidden) {
            [weakSelf removePickerView];
        }
    }];
    
}

- (void)dismissPicker{
    
    [self setPickerHidden:YES];
}



+ (void)dismissPicker{
 
    [[self targetView] dismissPicker];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

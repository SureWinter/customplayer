//
//  PlayBackView.m
//  TVMTV
//
//  Created by surewinter on 15/2/4.
//  Copyright (c) 2015年 surewinter. All rights reserved.
//

#import "PlayBackView.h"
#define GET_IMG(_IMG_)  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:_IMG_ ofType:@"png"]]

#define Screen_width   (([[UIScreen mainScreen] bounds].size.height<[[UIScreen mainScreen] bounds].size.width)?[[UIScreen mainScreen] bounds].size.height:[[UIScreen mainScreen] bounds].size.width)

@implementation UISlider (PlayBack)



@end

@implementation PlayBackView


@synthesize delegate=_delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled=YES;
        [self setClipsToBounds:YES];
        [self setBackgroundColor:[UIColor clearColor]];
        [self setImage:GET_IMG(@"livebar")];
        _btPlay=[UIButton buttonWithType:UIButtonTypeCustom];
        [_btPlay setFrame:CGRectMake(5, 0, 44, 44)];
        [_btPlay setBackgroundImage:GET_IMG(@"r_play") forState:UIControlStateNormal];
        [_btPlay setBackgroundImage:GET_IMG(@"r_pause") forState:UIControlStateSelected];
        [_btPlay addTarget:self action:@selector(onPlayOrPause:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btPlay];
        _btPlay.selected=NO;
        _labMin=[[UILabel alloc] initWithFrame:CGRectMake(44, 0, 50, self.frame.size.height)];
        _labMin.textColor=[UIColor whiteColor];
        [_labMin setTextAlignment:NSTextAlignmentRight];
        [self addSubview:_labMin];
        


        _slider=[[UISlider alloc] initWithFrame:CGRectMake(105, 2, self.frame.size.width-105-105-45, self.frame.size.height)];
        [self addSubview:_slider];
        _slider.enabled=NO;
        _slider.continuous=YES;
        [_slider setMinimumTrackImage:GET_IMG(@"slider_left") forState:UIControlStateNormal];
        [_slider setMaximumTrackImage:GET_IMG(@"slider_right") forState:UIControlStateNormal];
        [_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        _labMax=[[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width-105+10-45, 0, 50, self.frame.size.height)];
        _labMax.textColor=[UIColor whiteColor];
        [_labMax setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:_labMax];
        
        _volumeView =
        [[MPVolumeView alloc] initWithFrame: CGRectMake(self.frame.size.width-45-45, 0, 44, 44)];
        [_volumeView setShowsVolumeSlider:NO];
        [self addSubview: _volumeView];


    }
    return self;
}

-(void)unableSlider{
    [_slider setValue:0 animated:YES];
    _slider.enabled=NO;
    _labMax.text=@"";
    _labMin.text=@"";
}
-(void)relayout{
    [_slider setFrame:CGRectMake(105, 0, self.frame.size.width-105-105-45, self.frame.size.height)];
    [_labMax setFrame:CGRectMake(self.frame.size.width-105+10-50, 0, 50, self.frame.size.height)];
    [_volumeView setFrame:CGRectMake(self.frame.size.width-50-45, 0, 44, 44)];
    [_btTurn setFrame:CGRectMake(self.frame.size.width-45, 2, 40, 40)];
    _btTurn.selected=self.frame.size.width>Screen_width;

}
-(void)setTime:(float)fromValue To:(float)value{
    _slider.enabled=YES;
    [_slider setMinimumValue:0];
    [_slider setMaximumValue:value];
    if ((int)value/60/60) {
        _labMax.text=[NSString stringWithFormat:@"%d:%.2d:%.2d",(int)value/60/60,(int)value/60%60,(int)value%60];
    }
    else{
        _labMax.text=[NSString stringWithFormat:@"%d:%.2d",(int)value/60,(int)value%60];
    }
    if ((int)fromValue%60<0) {
        fromValue=0;
    }
    [_slider setValue:fromValue];
    if ((int)fromValue/60/60>0) {
        _labMin.text=[NSString stringWithFormat:@"%d:%.2d:%.2d",(int)fromValue/60/60,((int)fromValue/60)%60,(int)fromValue%60];
    }
    else{
        _labMin.text=[NSString stringWithFormat:@"%d:%.2d",(int)fromValue/60,(int)fromValue%60];
    }
}
-(void)sliderValueChanged:(UISlider*)slider{

    [self.delegate SlideValue:slider.value];
}
-(void)setPlayDuration:(float)fromValue{
    if ((int)fromValue%60<0) {
        fromValue=0;
    }
    if ((int)fromValue/60/60>0) {
        _labMin.text=[NSString stringWithFormat:@"%d:%.2d:%.2d",(int)fromValue/60/60,((int)fromValue/60)%60,(int)fromValue%60];
    }
    else{
        _labMin.text=[NSString stringWithFormat:@"%d:%.2d",(int)fromValue/60,(int)fromValue%60];
    }
    [_slider setValue:fromValue animated:YES];
}
-(void)asyPlayOrPause:(BOOL)b{
    _btPlay.selected=b;
}
-(void)onPlayOrPause:(UIButton*)sender{
    sender.selected=!sender.selected;
    [self.delegate PlayOrPause:sender.selected];
}
-(void)onTurn:(UIButton*)sender{
    sender.selected=!sender.selected;
    [self.delegate TurnToLand:sender.selected];
}
@end

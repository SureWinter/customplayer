//
//  PlayBackView.h
//  TVMTV
//
//  Created by surewinter on 15/2/4.
//  Copyright (c) 2015年 surewinter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MediaPlayer/MediaPlayer.h"

@protocol PlayBackViewDelegate<NSObject>
-(void)PlayOrPause:(BOOL)b;
-(void)SlideValue:(float)value;
-(void)TurnToLand:(BOOL)b;

@end

@interface UISlider (PlayBack)
@end
@interface PlayBackView : UIImageView{
    UIButton *_btPlay;
    UISlider *_slider;
    UILabel  *_labMin;
    UILabel  *_labMax;
    UIButton   *_btTurn;
    MPVolumeView *_volumeView;
    id<PlayBackViewDelegate> _delegate;

}

@property(nonatomic)id<PlayBackViewDelegate> delegate;
-(void)setTime:(float)from To:(float)value;
-(void)setPlayDuration:(float)time;
-(void)asyPlayOrPause:(BOOL)b;
-(void)relayout;
-(void)unableSlider;

@end

//
//  ViewController.m
//  player
//
//  Created by surewinter on 15/2/4.
//  Copyright (c) 2015年 surewinter. All rights reserved.
//

#import "ViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "PlayBackView.h"


@interface ViewController ()<PlayBackViewDelegate>
@property (nonatomic,strong) MPMoviePlayerController *mplayer;
@property (nonatomic,strong) PlayBackView *playBack;
@property (nonatomic,strong) NSTimer *timer;
@end
#define Screen_width   (([[UIScreen mainScreen] bounds].size.height<[[UIScreen mainScreen] bounds].size.width)?[[UIScreen mainScreen] bounds].size.height:[[UIScreen mainScreen] bounds].size.width)
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerAvailable:) name:MPMovieDurationAvailableNotification
                                               object:self.mplayer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerPlaybackStateDidChange:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:self.mplayer];
    NSURL *url = [NSURL URLWithString:@"http://175.25.168.16/flv2.bn.netease.com/videolib3/1508/10/sQuXC2423/SD/sQuXC2423-mobile.mp4?wsiphost=ipdb&crazycache=1"];
    self.mplayer= [[MPMoviePlayerController alloc] initWithContentURL:url];
    self.mplayer.view.frame = CGRectMake(0, 20, Screen_width, Screen_width*9/16);
    [self.view addSubview:self.mplayer.view];
    self.mplayer.shouldAutoplay = YES;
    [self.mplayer play];
    [self.mplayer setControlStyle:MPMovieControlStyleNone];
        self.playBack = [[PlayBackView alloc] initWithFrame:CGRectMake(0, self.mplayer.view.frame.size.height-44, Screen_width, 44)];
    [self.playBack setDelegate:self];
    [self.mplayer.view addSubview:self.playBack];

}
#pragma mark playback delegate
-(void)cancelPlaySlider{
    [self.timer invalidate];
    self.timer=nil;
}
-(void)loadPlayCurrentTime{
    if (!self.playBack.hidden) {
        [self.playBack setPlayDuration:self.mplayer.currentPlaybackTime];
        [_timer invalidate];
        _timer=nil;
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(loadPlayCurrentTime) userInfo:nil repeats:NO];
    }
}
-(void)moviePlayerAvailable:(NSNotification*)notification{
    [self.playBack setTime:self.mplayer.currentPlaybackTime To:self.mplayer.duration];
}
- (void)moviePlayerPlaybackStateDidChange:(NSNotification*)notification{
    switch (self.mplayer.playbackState)
    {
            /* The end of the movie was reached. */
        case MPMoviePlaybackStatePlaying:
        {
            [self.playBack asyPlayOrPause:YES];
            [self loadPlayCurrentTime];
            if (!self.playBack.hidden) {
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hidTools) object:nil];
                [self performSelector:@selector(hidTools) withObject:nil afterDelay:5.f];
            }
        }
            break;
            
        default:{
            [self.playBack asyPlayOrPause:NO];
            [self cancelPlaySlider];
        }
            break;
    }
}
-(void)hidTools{
    self.playBack.hidden=YES;
}

-(void)PlayOrPause:(BOOL)b{
    if (b) {
        [self.mplayer play];
    }
    else{
        [self.mplayer pause];
    }
}
-(void)SlideValue:(float)value{
    [self cancelPlaySlider];
    [self.mplayer setCurrentPlaybackTime:value];
    [self.mplayer play];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches
           withEvent:(UIEvent *)event{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hidTools) object:nil];
    UITouch* touch = [touches anyObject];
    CGPoint point=[touch locationInView:self.view];
            self.playBack.hidden=!self.playBack.hidden;


    [super touchesBegan:touches withEvent:event];
}


@end

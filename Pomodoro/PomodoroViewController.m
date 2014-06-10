//
//  PomodoroViewController.m
//  Pomodoro
//
//  Created by Sam.Xiao on 14-3-3.
//  Copyright (c) 2014年 Sam.Xiao. All rights reserved.
//

#import "PomodoroViewController.h"
#import "Task.h"
#import "Setting.h"

@interface PomodoroViewController ()

@property (strong, nonatomic) Setting *settings;
@property (weak, nonatomic) IBOutlet UILabel *labelTimer;
@property (weak, nonatomic) IBOutlet UIButton *buttonStart;
@property (weak, nonatomic) IBOutlet UIButton *buttonCancel;

@property (strong, nonatomic) Task *task;
@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic) int secondsOfTimer;

@end

@implementation PomodoroViewController

#pragma mark - Getter & Setter

-(Setting *)settings
{
    if (!_settings) {
        _settings = [[Setting alloc] init];
    }
    return _settings;
}

- (Task *)task
{
    if(!_task) _task = [[Task alloc]init];
    return _task;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(refreshView) name: UIApplicationDidBecomeActiveNotification object: nil];
    }
    return self;
}

#pragma mark - Event

- (IBAction)onStartButtonClicked:(UIButton *)sender {
    [self startTimerWithTimeInterval: self.task.time];
}
- (IBAction)onCancelButtonClicked:(UIButton *)sender {
    self.settings.endDate = nil;
    [self stopTimer];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [self refreshView];
    if ( [self.settings.bgMode isEqual: @"black"] ) {
        self.view.backgroundColor = [UIColor blackColor];
        self.labelTimer.textColor = [UIColor lightGrayColor];
        self.buttonCancel.titleLabel.textColor = [UIColor lightGrayColor];
        self.buttonStart.titleLabel.textColor = [UIColor lightGrayColor];
    }else{
        self.view.backgroundColor = [UIColor whiteColor];
        self.labelTimer.textColor = [UIColor darkTextColor];
        self.buttonCancel.titleLabel.textColor = [UIColor darkTextColor];
        self.buttonStart.titleLabel.textColor = [UIColor darkTextColor];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)refreshView
{
    [self.timer invalidate];
    NSDate *endDate = self.settings.endDate;
    int seconds = [endDate timeIntervalSinceNow];
    NSLog(@"End Date is %@", endDate);
    NSLog(@"Seconds is %d", seconds);
    if (seconds > 0) {
        [self startTimerWithTimeInterval: seconds];
    }
    
    
}


#pragma mark - Timer

- (void) setSecondsOfTimer:(int)timeCount
{
    _secondsOfTimer = timeCount;
    int seconds = timeCount % 60;
    int minutes = (timeCount / 60) % 60;
    
    self.labelTimer.text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}

- (void)timerFire
{
    self.secondsOfTimer--;
    if (self.secondsOfTimer == 0) {
        [self stopTimer];
    }
}

- (void)startTimerWithTimeInterval: (int)seconds
{
    self.secondsOfTimer = seconds;
    self.settings.endDate = [[NSDate alloc]initWithTimeIntervalSinceNow: self.secondsOfTimer];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval: 1.0
                                                  target: self
                                                selector: @selector(timerFire)
                                                userInfo: nil
                                                 repeats: YES];
    
    
    self.buttonStart.hidden = YES;
    self.buttonCancel.hidden = NO;
    [UIApplication sharedApplication].idleTimerDisabled = YES;

}

- (void)stopTimer
{
    [self.timer invalidate];
    self.secondsOfTimer = 0;
    
    
    self.buttonStart.hidden = NO;
    self.buttonCancel.hidden = YES;
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    
}

@end

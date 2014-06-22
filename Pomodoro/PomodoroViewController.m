//
//  PomodoroViewController.m
//  Pomodoro
//
//  Created by Sam.Xiao on 14-3-3.
//  Copyright (c) 2014年 Sam.Xiao. All rights reserved.
//

#import "PomodoroViewController.h"
#import "WorkTask.h"
#import "RestTask.h"
#import "Setting.h"

@interface PomodoroViewController ()

@property (strong, nonatomic) Setting *settings;
@property (weak, nonatomic) IBOutlet UILabel *labelTimer;
@property (weak, nonatomic) IBOutlet UIButton *buttonStart;
@property (weak, nonatomic) IBOutlet UIButton *buttonCancel;

@property (strong, nonatomic) Task *task;
@property (strong, nonatomic) NSString *currentTaskType;
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
    if(!_task) {
        if ( [self.currentTaskType isEqualToString: @"work"] ) {
            _task = [[RestTask alloc]init];
            self.currentTaskType = @"rest";
        }else{
            _task = [[WorkTask alloc]init];
            self.currentTaskType = @"work";
        }
        
    }
    return _task;
}

- (void) setSecondsOfTimer:(int)timeCount
{
    _secondsOfTimer = timeCount;
    int seconds = timeCount % 60;
    int minutes = (timeCount / 60) % 60;
    
    self.labelTimer.text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}

- (NSString *)currentTaskType
{
    if (!_currentTaskType) {
        _currentTaskType = @"rest";
    }
    return _currentTaskType;
}


#pragma mark - Event

- (IBAction)onStartButtonClicked:(UIButton *)sender {
    [self startTimerWithTimeInterval: self.task.time];
}

- (IBAction)onCancelButtonClicked:(UIButton *)sender {
    [self cancelTimer];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(refreshView:)
                                                 name: UIApplicationDidBecomeActiveNotification
                                               object: nil];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    if ( [self.settings.bgMode isEqual: @"black"] ) {
        self.labelTimer.textColor = [UIColor lightGrayColor];
        [self.view setBackgroundColor: [UIColor blackColor]];
        [self.buttonCancel setTitleColor: [UIColor lightGrayColor] forState: UIControlStateNormal];
        [self.buttonStart setTitleColor: [UIColor lightGrayColor] forState: UIControlStateNormal];
    }else{
        self.view.backgroundColor = [UIColor whiteColor];
        self.labelTimer.textColor = [UIColor darkTextColor];
        [self.buttonCancel setTitleColor: [UIColor darkTextColor] forState: UIControlStateNormal];
        [self.buttonStart setTitleColor: [UIColor darkTextColor] forState: UIControlStateNormal];
    }
    
//    [self refreshView: nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onTouch:(UITapGestureRecognizer *)sender {
    if ( self.navigationController.navigationBar.hidden ) {
        self.navigationController.navigationBar.hidden = NO;
    }else{
        self.navigationController.navigationBar.hidden = YES;
    }
}


- (void)refreshView: (NSNotification *)notification
{
    [self stopTimer];
    int seconds = [self.settings.endDate timeIntervalSinceNow];
    NSLog(@"Seconds is %d", seconds);
    if (seconds > 0) {
        [self startTimerWithTimeInterval: seconds];
    }
}


- (void)fireLoaclNotification
{
    UILocalNotification *alertLocalNotification = [[UILocalNotification alloc] init];
    alertLocalNotification.alertBody = @"Time is up";
    alertLocalNotification.alertAction = @"Time is up";
    alertLocalNotification.fireDate = self.settings.endDate;
    alertLocalNotification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication]scheduleLocalNotification: alertLocalNotification];
}

#pragma mark - Timer



- (void)timerFire
{
    self.secondsOfTimer--;
    if (self.secondsOfTimer == 0) {
        [self finishTimer];
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
    [self fireLoaclNotification];
    self.buttonStart.hidden = YES;
    self.buttonCancel.hidden = NO;

}

- (void)stopTimer
{
    [self.timer invalidate];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    self.secondsOfTimer = self.task.time;
    
    self.buttonStart.hidden = NO;
    self.buttonCancel.hidden = YES;
    
}

- (void)cancelTimer
{
    self.settings.endDate = nil;
    [self stopTimer];
}

- (void)finishTimer
{
    self.task = nil;
    [self stopTimer];
    [self showFinishAlert];
}

- (void)showFinishAlert
{
    UIAlertView *finishAlert = [[UIAlertView alloc] initWithTitle: @"完成"
                                                          message: @""
                                                         delegate: nil
                                                cancelButtonTitle: @"OK"
                                                otherButtonTitles: nil, nil];
    [finishAlert show];
}

@end

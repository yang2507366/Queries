//
//  MemoryTracer.m
//  Queries
//
//  Created by yangzexin on 10/19/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "MemoryTracer.h"
#import "SystemUtils.h"

@interface MemoryTracer ()

@property(nonatomic, assign)unsigned int bytesMemoryOfStartup;
@property(nonatomic, retain)UILabel *displayLabel;
@property(nonatomic, assign)BOOL tracing;

@end

@implementation MemoryTracer

+ (id)sharedInstance
{
    static id instance = nil;
    @synchronized(self.class){
        if(instance == nil){
            instance = [[MemoryTracer alloc] init];
        }
    }
    return instance;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.displayLabel = nil;
    [super dealloc];
}

- (id)init
{
    self = [super init];
    
    self.bytesMemoryOfStartup = [SystemUtils bytesOfMemoryUsed];
    
    self.displayLabel = [[[UILabel alloc] init] autorelease];
    self.displayLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.50f];
    self.displayLabel.textColor = [UIColor whiteColor];
    self.displayLabel.textAlignment = NSTextAlignmentCenter;
    self.displayLabel.font = [UIFont systemFontOfSize:12.0f];
    self.displayLabel.frame = CGRectMake(0, 0, 40, _displayLabel.font.lineHeight);
    self.displayLabel.adjustsFontSizeToFitWidth = YES;
    [[[[UIApplication sharedApplication] windows] lastObject] addSubview:self.displayLabel];
    
    [self updateDisplayLabelLocation];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(interfaceOrientationDidChangeNotification:)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
    
    return self;
}

- (void)start
{
    self.displayLabel.hidden = NO;
    self.tracing = YES;
    [self trace];
}

- (void)stop
{
    self.displayLabel.hidden = YES;
    self.tracing = NO;
}

- (void)trace
{
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    [window bringSubviewToFront:self.displayLabel];
    self.displayLabel.text = [NSString stringWithFormat:@"%uk", ([SystemUtils bytesOfMemoryUsed] - self.bytesMemoryOfStartup) / 1024];
    if(self.tracing){
        [self performSelector:@selector(trace) withObject:nil afterDelay:0.50f];
    }
}

- (void)updateDisplayLabelLocation
{
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if(interfaceOrientation == UIInterfaceOrientationPortrait){
        self.displayLabel.transform = CGAffineTransformMakeRotation(0.0f);
        
        CGRect tmpRect = self.displayLabel.frame;
        tmpRect.origin.x = [UIScreen mainScreen].bounds.size.width - tmpRect.size.width;
        tmpRect.origin.y = 20;
        self.displayLabel.frame = tmpRect;
    }else if(interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown){
        self.displayLabel.transform = CGAffineTransformMakeRotation(180.0f * M_PI / 180.0f);
        
        CGRect tmpRect = self.displayLabel.frame;
        tmpRect.origin.x = 0;
        tmpRect.origin.y = [UIScreen mainScreen].bounds.size.height - tmpRect.size.height - 20;
        self.displayLabel.frame = tmpRect;
    }else if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft){
        self.displayLabel.transform = CGAffineTransformMakeRotation(270.0f * M_PI / 180.0f);
        
        CGRect tmpRect = self.displayLabel.frame;
        tmpRect.origin.x = 20;
        tmpRect.origin.y = 0;
        self.displayLabel.frame = tmpRect;
    }else if(interfaceOrientation == UIInterfaceOrientationLandscapeRight){
        self.displayLabel.transform = CGAffineTransformMakeRotation(90.0f * M_PI / 180.0f);
        
        CGRect tmpRect = self.displayLabel.frame;
        tmpRect.origin.x = [UIScreen mainScreen].bounds.size.width - tmpRect.size.width - 20;
        tmpRect.origin.y = [UIScreen mainScreen].bounds.size.height - tmpRect.size.height;
        self.displayLabel.frame = tmpRect;
    }
}

- (void)interfaceOrientationDidChangeNotification:(NSNotification *)notification
{
    [self updateDisplayLabelLocation];
}

+ (void)start
{
    MemoryTracer *instance = [MemoryTracer sharedInstance];
    [instance start];
}

+ (void)stop
{
    MemoryTracer *instance = [MemoryTracer sharedInstance];
    [instance stop];
}

@end

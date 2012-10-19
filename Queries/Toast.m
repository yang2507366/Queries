//
//  Toast.m
//  imyvoa
//
//  Created by gewara on 12-6-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Toast.h"
#import <QuartzCore/QuartzCore.h>
#import "DelayController.h"

#define ROUND_RECT_ALPHA 0.72f

@interface Toast () <DelayControllerDelegate>

@property(nonatomic, retain)UIView *view;
@property(nonatomic, retain)UIView *roundRectView;
@property(nonatomic, retain)UILabel *label;

@property(nonatomic, retain)DelayController *delayController;
@property(nonatomic, retain)DelayController *animationDelayController;

@end

@implementation Toast

@synthesize view = _view;
@synthesize roundRectView = _roundRectView;
@synthesize label = _label;

@synthesize delayController = _delayController;
@synthesize animationDelayController = _animationDelayController;

+ (Toast *)defaultToast
{
    static Toast *instance = nil;
    @synchronized(instance){
        if(!instance){
            instance = [[Toast alloc] init];
        }
    }
    
    return instance;
}

- (void)dealloc
{
    [_view release];
    [_roundRectView release];
    [_label release];
    
    [_delayController cancel]; [_delayController release];
    [_animationDelayController cancel]; [_animationDelayController release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    
    self.view = [[[UIView alloc] init] autorelease];
    self.view.hidden = YES;
    self.view.userInteractionEnabled = NO;
    
    self.roundRectView = [[[UIView alloc] init] autorelease];
    [self.view addSubview:self.roundRectView];
    self.roundRectView.layer.cornerRadius = 7.0f;
    self.roundRectView.backgroundColor = [UIColor blackColor];
    self.roundRectView.alpha = ROUND_RECT_ALPHA;
    
    self.label = [[[UILabel alloc] init] autorelease];
    [self.view addSubview:self.label];
    self.label.backgroundColor = [UIColor clearColor];
    self.label.textColor = [UIColor whiteColor];
    self.label.font = [UIFont systemFontOfSize:14.0f];
    self.label.numberOfLines = 0;
    self.label.textAlignment = NSTextAlignmentCenter;
    
    return self;
}

#pragma mark - override methods
- (oneway void)release
{

}

- (id)retain
{
    return self;
}

- (id)autorelease
{
    return self;
}

#pragma mark - private methods

#pragma mark - instance methods
+ (void)showToastWithString:(NSString *)string hideAfterInterval:(NSTimeInterval)interval
{
    [[self.class defaultToast] showToastWithString:string hideAfterInterval:interval];
}

- (void)showToastInView:(UIView *)parentView withString:(NSString *)string hideAfterInterval:(NSTimeInterval)interval
{
    if(!parentView){
        parentView = [[[UIApplication sharedApplication] windows] lastObject];
    }
    [self.view removeFromSuperview];
    [parentView addSubview:self.view];
    self.view.frame = parentView.bounds;
    self.roundRectView.alpha = ROUND_RECT_ALPHA;
    self.label.alpha = 1.0f;
    
    self.label.text = string;
    
    CGFloat paddingLabel = 10;
    CGFloat paddingRoundRect = 10;
    
    CGFloat stringMaxWidth = self.view.frame.size.width - paddingRoundRect * 2 - paddingLabel * 2;
    CGSize stringSize = [string sizeWithFont:self.label.font];
    CGFloat labelWidth = stringSize.width;
    CGFloat labelHeight = self.label.font.lineHeight;
    if(stringSize.width > stringMaxWidth){
        labelWidth = stringMaxWidth;
        labelHeight = [string sizeWithFont:self.label.font 
                         constrainedToSize:CGSizeMake(labelWidth, 1000) 
                             lineBreakMode:self.label.lineBreakMode].height;
    }
    CGFloat labelX = (self.view.frame.size.width - labelWidth) / 2;
    CGFloat labelY = (self.view.frame.size.height - labelHeight) / 2;
    self.label.frame = CGRectMake(labelX, labelY, labelWidth, labelHeight);
    self.roundRectView.frame = CGRectMake(labelX - paddingLabel, 
                                          labelY - paddingLabel, 
                                          labelWidth + paddingLabel * 2, 
                                          labelHeight + paddingLabel * 2);
    [self.view.superview bringSubviewToFront:self.view];
    self.view.hidden = NO;
    
    if(self.animationDelayController){
        [self.animationDelayController cancel];
        self.animationDelayController = nil;
    }
    if(self.delayController){
        [self.delayController cancel];
        self.delayController = nil;
    }
    self.delayController = [[[DelayController alloc] initWithInterval:interval] autorelease];
    self.delayController.delegate = self;
    [self.delayController start];
}

- (void)showToastWithString:(NSString *)string hideAfterInterval:(NSTimeInterval)interval
{
    [self showToastInView:nil withString:string hideAfterInterval:interval];
}

#pragma mark - DelayControllerDelegate
- (void)delayControllerDidFinishDelay:(DelayController *)controller
{
    if(controller == self.delayController){
        NSTimeInterval animationDuration = 0.25f;
        
        if(self.animationDelayController){
            [self.animationDelayController cancel];
            self.animationDelayController = nil;
        }
        self.animationDelayController = [[[DelayController alloc] initWithInterval:animationDuration] autorelease];
        self.animationDelayController.delegate = self;
        [self.animationDelayController start];
        
//        self.roundRectView.alpha = 0.2f;
//        self.label.alpha = 0.2f;
//        CGRect frame = CGRectMake(self.view.frame.size.width / 2, self.view.frame.size.height, 0, 0);
        [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:animationDuration];
        
        self.roundRectView.alpha = 0.0f;
        self.label.alpha = 0.0f;
//        self.roundRectView.frame = frame;
//        self.label.frame = frame;
        
        [UIView commitAnimations];
    }else if(controller == self.animationDelayController){
        self.view.hidden = YES;
    }
}

@end

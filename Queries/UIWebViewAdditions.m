//
//  UIWebViewAdditions.m
//  Fragment_alpha_0
//
//  Created by yzx on 11-5-29.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "UIWebViewAdditions.h"


@implementation UIWebView (WebViewAdditions)

- (CGPoint)scrollOffset
{
    CGPoint point;
    point.x = [[self stringByEvaluatingJavaScriptFromString:@"window.pageXOffset"] integerValue];
    point.y = [[self stringByEvaluatingJavaScriptFromString:@"window.pageYOffset"] integerValue];
    
    return point;
}

-(CGSize)windowSize
{
    CGSize size;
    size.width = [[self stringByEvaluatingJavaScriptFromString:@"window.innerWidth"] integerValue];
    size.height = [[self stringByEvaluatingJavaScriptFromString:@"window.innerHeight"] integerValue];
    
    return size;
}

- (NSString *)loadJavascript:(NSString *)fileName;
{
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    NSString *jsPath = [bundlePath stringByAppendingPathComponent:fileName];
    NSString *jsCode = [NSString stringWithContentsOfFile:jsPath encoding:NSASCIIStringEncoding error:nil];
    return jsCode;
}

- (void)replaceLinkHref
{
    NSString *jsCode = [self loadJavascript:@"replaceLinkHref.js"];
    [self stringByEvaluatingJavaScriptFromString:jsCode];
    NSString *method = @"replaceLinkHref()";
    [self stringByEvaluatingJavaScriptFromString:method];
}

- (void)disableWebViewContextMenu
{
    [self stringByEvaluatingJavaScriptFromString:@"document.body.style.webkitTouchCallout='none';"];
}

- (NSString *)getALinkAtPoint:(CGPoint)point
{
    NSString *jsCode = [self loadJavascript:@"getElementsAtPoint.js"];
	//NSLog(@"jsCode:%@", jsCode);
    [self stringByEvaluatingJavaScriptFromString:jsCode];
    NSString *method = [NSString stringWithFormat:@"getElementsAtPoint(%d, %d)", (NSInteger)point.x, (NSInteger)point.y];
    NSString *result = [self stringByEvaluatingJavaScriptFromString:method];
    //NSLog(@"result:%@", result);
    return result;
}

- (NSString *)getPageTitle
{
    NSString *jsCode = @"document.title";
    NSString *title = [self stringByEvaluatingJavaScriptFromString:jsCode];
    if([[[self.request URL] absoluteString] isEqualToString:@"about:blank"]){
        title = @"about:blank";
    }
    
    return title;
}

- (void)gotoAddress:(NSString *)address
{
    if ([self isLoading]) {
        [self stopLoading];
    }
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:address]];
    [self loadRequest:req];
}

- (NSString *)getSelectedText
{
    NSString *js = @"document.getSelection().toString()";
    NSString *selectedText = [self stringByEvaluatingJavaScriptFromString:js];
    
    return selectedText;
}

- (void)removeShadow
{
    self.backgroundColor = [UIColor clearColor];
    for(UIView *subview in [self subviews]){
        if([subview isKindOfClass:[UIScrollView class]]){
            UIScrollView *scrollView = (id)subview;
            scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
            for(UIView *view in [subview subviews]){
                if([view isKindOfClass:[UIImageView class]]){
                    [view removeFromSuperview];
                }
            }
            break;
        }
    }
}

- (UIScrollView *)getScrollView
{
    if([self respondsToSelector:@selector(scrollView)]){
        return self.scrollView;
    }else{
        for(UIView *subview in [self subviews]){
            if([subview isKindOfClass:[UIScrollView class]]){
                return (id)subview;
            }
        }
    }
    return nil;
}

@end

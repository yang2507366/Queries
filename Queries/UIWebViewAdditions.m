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
    point.x = [[self stringByEvaluatingJavaScriptFromString:@"window.pageXOffset"] floatValue];
    point.y = [[self stringByEvaluatingJavaScriptFromString:@"window.pageYOffset"] floatValue];
    
    return point;
}

-(CGSize)windowSize
{
    CGSize size;
    size.width = [[self stringByEvaluatingJavaScriptFromString:@"window.innerWidth"] floatValue];
    size.height = [[self stringByEvaluatingJavaScriptFromString:@"window.innerHeight"] floatValue];
    
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
    NSString *js =
    @"function replaceTag(targetTag){\
        var allLinks = document.getElementsByTagName(targetTag);\
        if (allLinks) {\
            var i;\
            for (i=0; i<allLinks.length; i++) {\
                var link = allLinks[i];\
                if(link.href){\
                    if(link.href.indexOf('mylink:') == -1){\
                        link.href = 'mylink:' + link.href;\
                    }\
                }\
            }\
        }\
    }\
    function replaceLinkHref() {\
        replaceTag('a');\
    }";
    [self stringByEvaluatingJavaScriptFromString:js];
    NSString *method = @"replaceLinkHref()";
    [self stringByEvaluatingJavaScriptFromString:method];
}

- (void)disableWebViewContextMenu
{
    [self stringByEvaluatingJavaScriptFromString:@"document.body.style.webkitTouchCallout='none';"];
}

- (NSString *)getLinkSRCAtPoint:(CGPoint)point
{
    NSString *jsCode =
    @"function MyAppGetLinkSRCAtPoint(x,y) {\n\
        var tags = '';\n\
        var e = '';\n\
        var offset = 0;\n\
        while ((tags.length == 0) && (offset < 20)) {\n\
            e = document.elementFromPoint(x,y+offset);\n\
            while (e) {\n\
                if (e.src) {\n\
                    tags += e.src;\n\
                    break;\n\
                }\n\
                e = e.parentNode;\n\
            }\n\
            if (tags.length == 0) {\n\
                e = document.elementFromPoint(x,y-offset);\n\
                while (e) {\n\
                    if (e.src) {\n\
                        tags += e.src;\n\
                        break;\n\
                    }\n\
                    e = e.parentNode;\n\
                }\n\
            }\n\
            offset++;\n\
        }\n\
        return tags;\n\
    }";
	//NSLog(@"jsCode:%@", jsCode);
    [self stringByEvaluatingJavaScriptFromString:jsCode];
    NSString *method = [NSString stringWithFormat:@"MyAppGetLinkSRCAtPoint(%d, %d)", (NSInteger)point.x, (NSInteger)point.y];
    NSString *result = [self stringByEvaluatingJavaScriptFromString:method];
    //NSLog(@"result:%@", result);
    return result;
}

- (NSString *)getALinkAtPoint:(CGPoint)point
{
    NSString *URLString = nil;
    NSString *src = [self getLinkSRCAtPoint:point];
    NSString *href = [self getLinkHREFAtPoint:point];
    NSString *elements = [self getHTMLElementsAtPoint:point];
    if([elements rangeOfString:@",IMG,"].location != NSNotFound){
        URLString = src;
    }
    if([elements rangeOfString:@",A,"].location != NSNotFound){
        URLString = href;
    }
    
    return URLString;
}

- (NSString *)getLinkHREFAtPoint:(CGPoint)point
{
    NSString *js =
    @"function MyAppGetLinkHREFAtPoint(x,y) {\n\
        var tags = \"\";\n\
        var e = \"\";\n\
        var offset = 0;\n\
        while ((tags.length == 0) && (offset < 20)) {\n\
            e = document.elementFromPoint(x,y+offset);\n\
            while (e) {\n\
                if (e.href) {\n\
                    tags += e.href;\n\
                    break;\n\
                }\n\
                e = e.parentNode;\n\
            }\n\
            if (tags.length == 0) {\n\
                e = document.elementFromPoint(x,y-offset);\n\
                while (e) {\n\
                    if (e.href) {\n\
                        tags += e.href;\n\
                        break;\n\
                    }\n\
                    e = e.parentNode;\n\
                }\n\
            }\n\
            offset++;\n\
        }\n\
        return tags;\n\
    }";
    [self stringByEvaluatingJavaScriptFromString:js];
    NSString *method = [NSString stringWithFormat:@"MyAppGetLinkHREFAtPoint(%d, %d)", (NSInteger)point.x, (NSInteger)point.y];
    NSString *result = [self stringByEvaluatingJavaScriptFromString:method];
    //NSLog(@"result:%@", result);
    return result;
}

- (NSString *)getHTMLElementsAtPoint:(CGPoint)point
{
    NSString *js =
    @"function MyAppGetHTMLElementsAtPoint(x,y) {\n\
        var tags = '';\n\
        var e;\n\
        var offset = 0;\n\
        while ((tags.search(',(A|IMG),') < 0) && (offset < 20)) {\n\
            tags = ',';\n\
            e = document.elementFromPoint(x,y+offset);\n\
            while (e) {\n\
                if (e.tagName) {\n\
                    tags += e.tagName + ',';\n\
                }\n\
                e = e.parentNode;\n\
            }\n\
            if (tags.search(',(A|IMG),') < 0) {\n\
                e = document.elementFromPoint(x,y-offset);\n\
                while (e) {\n\
                    if (e.tagName) {\n\
                        tags += e.tagName + ',';\n\
                    }\n\
                    e = e.parentNode;\n\
                }\n\
            }\n\
            offset++;\n\
        }\n\
        return tags;\n\
    }";
    [self stringByEvaluatingJavaScriptFromString:js];
    return [self stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"MyAppGetHTMLElementsAtPoint(%f, %f)", point.x, point.y]];
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

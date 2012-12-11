//
//  UIWebViewAdditions.h
//  Fragment_alpha_0
//
//  Created by yzx on 11-5-29.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIWebView (WebViewAdditions)

- (CGPoint)scrollOffset;
- (CGSize)windowSize;
- (void)replaceLinkHref;
- (void)disableWebViewContextMenu;
- (NSString *)getALinkAtPoint:(CGPoint)point;
- (void)gotoAddress:(NSString *)address;
- (NSString *)getPageTitle;
- (NSString *)getSelectedText;
- (void)removeShadow;
- (UIScrollView *)getScrollView;
@end

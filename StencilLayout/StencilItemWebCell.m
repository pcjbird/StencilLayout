//
//  StencilItemWebCell.m
//  StencilLayout
//
//  Created by pcjbird on 2016/11/10.
//  Copyright © 2016年 Zero Status. All rights reserved.
//

#import "StencilItemWebCell.h"
#import "StencilStringUtil.h"
#import "StencilLayoutViewController+Web.h"


@interface StencilItemWebCell()


@property (weak, nonatomic) IBOutlet id webView;
@end

@implementation StencilItemWebCell

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.preferWKWebView = YES;
    if(self.parentViewController)
    {
        if(self.parentViewController.delegate && [self.parentViewController.delegate respondsToSelector:@selector(stencilLayoutViewControllerPreferWKWebView:)])
        {
            BOOL bPreferWKWebView = [self.parentViewController.delegate stencilLayoutViewControllerPreferWKWebView:self.parentViewController];
            self.preferWKWebView = bPreferWKWebView;
        }
    }
    
    id webview = [self createRealWebView];
    [self addSubview:webview];
    self.webView = webview;
    NSArray *constraints_h=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[webview]-0-|"
                                                                   options:0
                                                                   metrics:nil
                                                                     views:NSDictionaryOfVariableBindings(webview)];
    
    NSArray *constraints_v=[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[webview]-0-|"
                                                                   options:0
                                                                   metrics:nil
                                                                     views:NSDictionaryOfVariableBindings(webview)];
    
    [self addConstraints:constraints_h];
    [self addConstraints:constraints_v];
}

-(void) configWithItem:(StencilItem*)item
{
    [super configWithItem:item];
    NSString *pageUrl = item.pageUrl;
    if([self.parentViewController isKindOfClass:[StencilLayoutViewController class]])
    {
        pageUrl = [self.parentViewController prepareForWebUrl:pageUrl];
    }
    if([StencilStringUtil isStringBlank:pageUrl])
    {
        pageUrl = item.pageUrl;
    }
    NSURL *url = [NSURL URLWithString:[StencilStringUtil isStringHasChineseCharacter:pageUrl] ?[pageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] : pageUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url];
    [self loadRequest:request];
    
}

-(void)loadRequest:(NSURLRequest*)request
{
    if([self.webView isKindOfClass:[UIWebView class]])
    {
        [(UIWebView*)self.webView loadRequest:request];
    }
    else if([self.webView isKindOfClass:[WKWebView class]])
    {
        [(WKWebView*)self.webView loadRequest:request];
    }
}

- (id)createRealWebView
{
    Class wkwebviewClass = NSClassFromString(@"WKWebView");
    if(wkwebviewClass&&self.preferWKWebView)
    {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        // 设置偏好设置
        config.preferences = [[WKPreferences alloc] init];
        // 默认为0
        config.preferences.minimumFontSize = 10;
        // 默认认为YES
        config.preferences.javaScriptEnabled = YES;
        // 在iOS上默认为NO，表示不能自动通过窗口打开
        config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
        // web内容处理池
        config.processPool = [[WKProcessPool alloc] init];
        
        // 通过JS与webview内容交互
        config.userContentController = [[WKUserContentController alloc] init];
        
        WKWebView* webview = [[WKWebView alloc] initWithFrame:self.bounds configuration:config];
        [webview setBackgroundColor:[UIColor clearColor]];
        webview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:webview];
        return webview;
    }
    else
    {
        UIWebView* webview = [[UIWebView alloc] initWithFrame:self.bounds];
        [webview setBackgroundColor:[UIColor clearColor]];
        webview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:webview];
        
        return webview;
    }
}


@end

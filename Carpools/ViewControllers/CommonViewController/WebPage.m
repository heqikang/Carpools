//
//  WebPage.m
//  Carpool
//
//  Created by ZhengBob on 28/11/2016.
//  Copyright © 2016 Client. All rights reserved.
//

#import "WebPage.h"
#import "AppDelegate.h"

@interface WebPage ()

@property (nonatomic, strong) UIButton *coverBtn;

@end

@implementation WebPage

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    self.title = self.titleString;
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
    
    [self.view addSubview: webView];
    [webView loadRequest:request];
    
    
}


@end

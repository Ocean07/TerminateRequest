//
//  ViewController.m
//  TerminateRequest
//
//  Created by Bloveocean on 2019/9/28.
//  Copyright © 2019 Auth. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com/"];
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"data = %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    }] resume];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate:) name:UIApplicationWillTerminateNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 1.需求：程序在 Terminate 之前发送一个网络请求，在用户kill app的时候发送请求到服务器
 2.分析：将要kill app时，会触发运行最后一轮runloop，runloop结束时，app就会被terminate，所以
 要堵塞runloop的当前线程 -->
 1> 使用同步方法发送请求，堵塞当前线程
 2> 发送异步请求，使用sleep 堵塞当前线程
 */
- (void)applicationWillTerminate:(NSNotification *)nofity {
    NSLog(@"2--> will term, %@", [NSThread currentThread]);
    
    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com/"];
    
//    // 1. OK
//    NSURLResponse *resp;
//    NSError *error;
//    NSData *data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:url] returningResponse:&resp error:&error];
//    NSLog(@"data = %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    // 2. ok
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"data --> %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    }] resume];
    [NSThread sleepForTimeInterval:5.0];
    
    NSLog(@"end --->");
    
}


@end

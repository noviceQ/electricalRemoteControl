//
//  ViewController.m
//  CarRemoteControl
//
//  Created by Qiao on 2016/11/9.
//  Copyright © 2016年 xinmei365. All rights reserved.
//

#import "ViewController.h"
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
@interface ViewController ()
{
    int _clientSocketHandler;
}
@property (weak, nonatomic) IBOutlet UILabel *displayLabel;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _clientSocketHandler = -1;
    // Do any additional setup after loading the view, typically from a nib.
}

/*
 客服端的
 第一步：创建socket并配置socket
 第三步：调用connect连接服务器
 第四步：调用getsockname获取套接字信息
 第五步：调用send发送消息到服务器端
 第六步：调用close关闭socket
 */
- (void)bsicSetting {
    self.view.userInteractionEnabled = NO;
    if (_clientSocketHandler != -1) {
        close(_clientSocketHandler);
        _clientSocketHandler = -1;
    }
    int err = -1;
    _clientSocketHandler = socket(AF_INET, SOCK_STREAM, 0);
    if (_clientSocketHandler == -1 ) {
        [self alertDisplay:@"创建socket失败"];
        return;
    }
    if (_clientSocketHandler != -1) {
        //设置服务器信息
        struct sockaddr_in serverAddr;
        memset(&serverAddr, 0, sizeof(serverAddr));
        serverAddr.sin_len = sizeof(serverAddr);
        serverAddr.sin_family = AF_INET;
        serverAddr.sin_port = htons(1234);
        serverAddr.sin_addr.s_addr = inet_addr([@"172.16.2.123" UTF8String]);
        NSLog(@"start connecting .....");
        err = connect(_clientSocketHandler, (const struct  sockaddr *)&serverAddr, sizeof(serverAddr));
        if (err != 0) {
            [self alertDisplay:@"链接失败"];
            return;
        }
        struct sockaddr_in localAddr;
        socklen_t sock_len = sizeof(localAddr);
        err = getsockname(_clientSocketHandler, (struct sockaddr *)&localAddr, &sock_len);
        if (err != 0) {
            [self alertDisplay:@"获取信息失败"];
            return;
        }
        printf("success ...> local ip:%s port:%hu\n",inet_ntoa(localAddr.sin_addr),ntohs(localAddr.sin_port));
        self.view.userInteractionEnabled = YES;
        [self alertDisplay:@"链接成功"];
    }
}


- (void)sendMsg:(NSString *)str {
    int err = -1;
    //创建socket
    NSString *messageStr = @"hello word";
    const char *message = [str UTF8String];
    if (_clientSocketHandler == -1) {
        [self alertDisplay:@"socket 错误"];
        return;
    }
    send(_clientSocketHandler,message ,messageStr.length, 0);
    char buffer[1024];
    read(_clientSocketHandler, buffer, 1024);
    printf("recev = %s\n",buffer);
}

- (void)alertDisplay:(NSString *)message {
    self.view.userInteractionEnabled = YES;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"error" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        
    }]];
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)turnUp:(id)sender {
    self.displayLabel.text = @"Up";
    [self sendMsg:@"Up"];
}

- (IBAction)turnRight:(id)sender {
    self.displayLabel.text = @"Right";
    [self sendMsg:@"Right"];
}
- (IBAction)turnDown:(id)sender {
    self.displayLabel.text = @"Down";
    [self sendMsg:@"Down"];
}
- (IBAction)turnLeft:(id)sender {
    self.displayLabel.text = @"Left";
    [self sendMsg:@"Left"];
}
- (IBAction)Reconnect:(id)sender {
    [self bsicSetting];
}


@end

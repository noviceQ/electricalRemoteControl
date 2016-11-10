//
//  CRSendMessageOperation.h
//  CarRemoteControl
//
//  Created by Qiao on 2016/11/9.
//  Copyright © 2016年 xinmei365. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CRSendMessageOperationDelegate <NSObject>
- (void)errorWithMessage:(NSString *)message;
@end

@interface CRSendMessageOperation : NSOperation
@property (nonatomic,strong) NSString *needSendMessage;
@end

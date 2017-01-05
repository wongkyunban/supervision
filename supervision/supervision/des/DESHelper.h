//
//  DES1Helper.h
//  GHBusinessSv
//
//  Created by RockeyCai on 2016/11/14.
//  Copyright © 2016年 RockeyCai. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <Security/Security.h>


@interface DESHelper : NSObject


/**
 DES加密

 @param str 原文
 @param key 密匙

 @return    大写
 */
+ (NSString *) encode:(NSString *)str key:(NSString *)key;

@end

//
//  FileFunctionLevelFormatter.m
//
//  Created by Julien Grimault on 23/1/12.
//  Copyright (c) 2012 Julien Grimault. All rights reserved.
//

#import "FileFunctionLevelFormatter.h"

@implementation FileFunctionLevelFormatter


- (NSString*)formatLogMessage:(DDLogMessage *)logMessage
{
  NSString* logLevel = nil;
  switch (logMessage->logLevel) {
    case LOG_FLAG_ERROR : logLevel = @"E"; break;
    case LOG_FLAG_WARN  : logLevel = @"W"; break;
    case LOG_FLAG_INFO  : logLevel = @"I"; break;
    default             : logLevel = @"V"; break;
  }
  
  return [NSString stringWithFormat:@"[%@][%@ %@][%d] %@",
          logLevel,
          logMessage.fileName,
          logMessage.methodName,
          logMessage->lineNumber,
          logMessage->logMsg];
}
@end

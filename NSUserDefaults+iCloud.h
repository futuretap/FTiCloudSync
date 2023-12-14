//
//  NSUserDefaults+iCloud.h
//  FTiCloudSync
//
//  Copyright (c) 2012:
//  Ortwin Gentz, FutureTap GmbH, http://www.futuretap.com
//  All rights reserved.
//
//  Licensed under CC-BY-SA 3.0: http://creativecommons.org/licenses/by-sa/3.0/
//  You are free to share, adapt and make commercial use of the work as long as you give attribution and keep this license.
//  To give credit, we suggest this text: "Uses FTiCloudSync by Ortwin Gentz", with a link to the GitHub page

#import <Foundation/Foundation.h>

extern NSString* const FTiCloudSyncDidUpdateNotification;
extern NSString* const FTiCloudSyncChangedKeys;
extern NSString* const FTiCloudSyncRemovedKeys;
extern NSString* FTiCloudIgnoreListRegex;

@interface NSUserDefaults(iCloud)
+ (void)updateFromiCloud:(NSNotification*) notificationObject;
- (void)my_setObject:(id)value forKey:(NSString *)defaultName;
- (void)my_removeObjectForKey:(NSString *)defaultName;
- (void)my_synchronize;
@end
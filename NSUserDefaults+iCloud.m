//
//  NSUserDefaults+iCloud.m
//  FTiCloudSync
//
//  Copyright (c) 2012:
//  Ortwin Gentz, FutureTap GmbH, http://www.futuretap.com
//  All rights reserved.
//
//  Licensed under CC-BY-SA 3.0: http://creativecommons.org/licenses/by-sa/3.0/
//  You are free to share, adapt and make commercial use of the work as long as you give attribution and keep this license.
//  To give credit, we suggest this text: "Uses FTiCloudSync by Ortwin Gentz", with a link to the GitHub page

#import "NSUserDefaults+iCloud.h"

#import "MethodSwizzling.h"
#import "RegexKitLite.h"

NSString* const FTiCloudSyncDidUpdateNotification = @"FTiCloudSyncDidUpdateNotification";
NSString* const FTiCloudSyncChangedKeys = @"changedKeys";
NSString* const FTiCloudSyncRemovedKeys = @"removedKeys";
NSString* const iCloudBlacklistRegex = @"(^!|^Apple|^ATOutputLevel|Hockey|DateOfVersionInstallation|^MF|^NS|Quincy|^BIT|^TV|UsageTime|^Web|preferredLocaleIdentifier)";
NSString* FTiCloudIgnoreListRegex = @"";

@implementation NSUserDefaults(Additions)

#pragma mark - Swizzling to get a hook for iCloud
+(void)initialize {
	if(NSClassFromString(@"NSUbiquitousKeyValueStore")) { // is iOS 5?
		Swizzle([NSUserDefaults class], @selector(setObject:forKey:), @selector(my_setObject:forKey:));
		Swizzle([NSUserDefaults class], @selector(removeObjectForKey:), @selector(my_removeObjectForKey:));
		Swizzle([NSUserDefaults class], @selector(synchronize), @selector(my_synchronize));
        
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(updateFromiCloud:)
													 name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification
												   object:nil];
	}
}

+ (void)updateFromiCloud:(NSNotification*)notificationObject {
	if ([[[notificationObject userInfo] objectForKey:NSUbiquitousKeyValueStoreChangeReasonKey] intValue] == NSUbiquitousKeyValueStoreQuotaViolationChange) {
		NSLog(@"NSUbiquitousKeyValueStoreQuotaViolationChange");
	}
	NSMutableArray *changedKeys = [NSMutableArray array];
	NSMutableArray *removedKeys = nil;
	@synchronized(self) {
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		NSDictionary *dict = [[NSUbiquitousKeyValueStore defaultStore] dictionaryRepresentation];
        
		[dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
			if (![key isMatchedByRegex:iCloudBlacklistRegex] && ![key isMatchedByRegex:FTiCloudIgnoreListRegex] && ![[defaults valueForKey:key] isEqual:obj]) {
				[defaults my_setObject:obj forKey:key]; // call original implementation
				[changedKeys addObject:key];
			}
		}];
		
		removedKeys = [NSMutableArray arrayWithArray:[defaults dictionaryRepresentation].allKeys];
		[removedKeys removeObjectsInArray:dict.allKeys];
		[removedKeys enumerateObjectsUsingBlock:^(id key, NSUInteger idx, BOOL *stop) {
			if (![key isMatchedByRegex:iCloudBlacklistRegex] && ![key isMatchedByRegex:FTiCloudIgnoreListRegex]) {
				[defaults my_removeObjectForKey:key]; // non-swizzled/original implementation
			}
		}];
		
		[defaults my_synchronize];  // call original implementation (don't sync with iCloud again)
	}
    [[NSNotificationCenter defaultCenter] postNotificationName:FTiCloudSyncDidUpdateNotification
														object:self
													  userInfo:[NSDictionary dictionaryWithObjectsAndKeys:changedKeys, FTiCloudSyncChangedKeys, removedKeys, FTiCloudSyncRemovedKeys, nil]];
}

- (void)my_setObject:(id)object forKey:(NSString *)key {
	BOOL equal = [[self objectForKey:key] isEqual:object];
	[self my_setObject:object forKey:key];
	if (!equal && ![key isMatchedByRegex:iCloudBlacklistRegex] && ![key isMatchedByRegex:FTiCloudIgnoreListRegex] && [NSUbiquitousKeyValueStore defaultStore]) {
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
			[[NSUbiquitousKeyValueStore defaultStore] setObject:object forKey:key];
		});
	}
}

- (void)my_removeObjectForKey:(NSString *)key {
	BOOL exists = !![self objectForKey:key];
	[self my_removeObjectForKey:key]; // call original implementation
	
	if (exists && ![key isMatchedByRegex:iCloudBlacklistRegex] && ![key isMatchedByRegex:FTiCloudIgnoreListRegex] && [NSUbiquitousKeyValueStore defaultStore]) {
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
			[[NSUbiquitousKeyValueStore defaultStore] removeObjectForKey:key];
		});
	}
}

- (void)my_synchronize {
	[self my_synchronize]; // call original implementation
	if ([NSUbiquitousKeyValueStore defaultStore]) {
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
			if(![[NSUbiquitousKeyValueStore defaultStore] synchronize]) {
				NSLog(@"iCloud sync failed");
			}
		});
	}
}

@end

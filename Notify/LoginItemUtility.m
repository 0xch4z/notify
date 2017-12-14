//
//  LoginItemUtility.m
//  Notify
//
//  Created by Charles Kenney on 12/13/17.
//  Copyright © 2017 Charles Kenney. All rights reserved.
//

#import "LoginItemUtility.h"

#pragma GCC diagnostic ignored "-Wdeprecated-declarations"

@implementation LoginItemUtility

/**
 * Use LSSharedFileListRef is depreciated in favor of the
 * System Management framework, however LSSharedFileRef allows
 * the user to manage the login item in settings, without the
 * app. This is most preferable as it is more accessable to the user.
 */

// adds to shared login items
+ (void)addToLoginItems {
  LSSharedFileListRef list = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
  NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
  NSURL *bundleUrl = [NSURL fileURLWithPath:bundlePath];
  
  if (list) {
    LSSharedFileListItemRef listItem = LSSharedFileListInsertItemURL(list, kLSSharedFileListItemLast, NULL, NULL, (__bridge CFURLRef)bundleUrl, NULL, NULL);
    if (listItem) {
      CFRelease(listItem);
    }
    CFRelease(list);
    NSLog(@"Successfully added login item");
  } else {
    NSLog(@"Error adding login item");
  }
}

@end

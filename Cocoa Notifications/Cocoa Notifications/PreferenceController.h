//
//  PreferenceController.h
//  Cocoa Preferences Panel
//
//  Created by Nikola Grujic on 15/01/2020.
//  Copyright © 2020 Mac Developers. All rights reserved.
//

#import <Cocoa/Cocoa.h>

extern NSString *const WindowBackgroundColor;
extern NSString *const WindowResizeEnabledFlag;
extern NSString *const WindowColorChangedNotification;
extern NSString *const WindowResizeEnabledFlagChangedNotification;

@interface PreferenceController : NSWindowController
{
    IBOutlet NSColorWell *colorWell;
    IBOutlet NSButton *checkbox;
}

+ (NSColor*)preferenceWindowBackgroundColor;
+ (void)setPreferenceWindowBackgroundColor: (NSColor*)color;
+ (BOOL)preferenceWindowResizeEnabledFlag;
+ (void)setPreferenceWindowResizeEnabledFlag: (BOOL)resizeEnabled;

- (IBAction)changeBackgroundColor:(id)sender;
- (IBAction)changeResizeEnabled:(id)sender;

- (void)postNotification: (NSString*) notificationName userInfo: (NSDictionary*) data;

@end

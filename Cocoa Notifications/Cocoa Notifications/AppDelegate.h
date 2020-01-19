//
//  AppDelegate.h
//  Cocoa Preferences Panel
//
//  Created by Nikola Grujic on 15/01/2020.
//  Copyright © 2020 Mac Developers. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class PreferenceController;

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    PreferenceController *preferenceController;
}

@property (weak) IBOutlet NSWindow *window;

+ (void)registerDefaultPreferences;
- (void)registerAsObserver;

- (void)handleColorChange:(NSNotification *)notification;
- (void)handleResizeChange:(NSNotification *)notification;

- (void)setBackgroundColor:(NSColor*) color;
- (void)setResizeEnabled:(BOOL) enabled;

- (IBAction)showPreferencePanel:(id)sender;

@end


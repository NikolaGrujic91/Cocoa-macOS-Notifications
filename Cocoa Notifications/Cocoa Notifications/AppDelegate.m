//
//  AppDelegate.m
//  Cocoa Preferences Panel
//
//  Created by Nikola Grujic on 15/01/2020.
//  Copyright © 2020 Mac Developers. All rights reserved.
//

#import "AppDelegate.h"
#import "PreferenceController.h"

@implementation AppDelegate

#pragma mark Class methods

+(void)initialize
{
    [self registerDefaultPreferences];
}

+ (void)registerDefaultPreferences
{
    NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary];
    
    NSError *error = nil;
    NSData *colorAsData = [NSKeyedArchiver archivedDataWithRootObject:[NSColor yellowColor]
                                                requiringSecureCoding:YES
                                                                error:&error];
    
    if (error != nil)
    {
        NSLog(@"Error code:%d", (int)error.code);
    }
    
    [defaultValues setObject:colorAsData forKey:WindowBackgroundColor];
    [defaultValues setObject:[NSNumber numberWithBool:YES] forKey:WindowResizeEnabledFlag];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
}

- (void)registerAsObserver
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter addObserver:self
                           selector:@selector(handleColorChange:)
                               name:WindowColorChangedNotification
                             object:nil];
    
    [notificationCenter addObserver:self
                           selector:@selector(handleResizeChange:)
                               name:WindowResizeEnabledFlagChangedNotification
                             object:nil];
}

- (void)handleColorChange:(NSNotification *)notification
{
    NSColor *color = [[notification userInfo] objectForKey:@"color"];
    [self setBackgroundColor:color];
}

- (void)handleResizeChange:(NSNotification *)notification
{
    NSNumber *state = [[notification userInfo] objectForKey:@"state"];
    [self setResizeEnabled:[state intValue]];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib
{
    [self setBackgroundColor:[PreferenceController preferenceWindowBackgroundColor]];
    [self setResizeEnabled:[PreferenceController preferenceWindowResizeEnabledFlag]];
    [self registerAsObserver];
}

- (void)setBackgroundColor:(NSColor*) color
{
    [_window setBackgroundColor:color];
}

- (void)setResizeEnabled:(BOOL) enabled
{
    if (enabled == YES)
    {
        _window.styleMask |= NSWindowStyleMaskResizable;
    }
    else
    {
        _window.styleMask &= ~NSWindowStyleMaskResizable;
    }
}

#pragma mark Action methods

- (IBAction)showPreferencePanel:(id)sender
{
    if (!preferenceController)
    {
        preferenceController = [[PreferenceController alloc] init];
    }
    
    [preferenceController showWindow:self];
}

@end

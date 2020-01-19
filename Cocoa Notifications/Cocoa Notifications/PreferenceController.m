//
//  PreferenceController.m
//  Cocoa Preferences Panel
//
//  Created by Nikola Grujic on 15/01/2020.
//  Copyright © 2020 Mac Developers. All rights reserved.
//

#import "PreferenceController.h"

NSString *const WindowBackgroundColor = @"WindowBackgroundColor";
NSString *const WindowResizeEnabledFlag = @"WindowResizeEnabledFlag";
NSString *const WindowColorChangedNotification = @"WindowColorChangedNotification";
NSString *const WindowResizeEnabledFlagChangedNotification = @"WindowResizeEnabledFlagChangedNotification";

@implementation PreferenceController

- (id)init
{
    self = [super initWithWindowNibName:@"Preferences"];
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    [colorWell setColor:[PreferenceController preferenceWindowBackgroundColor]];
    [checkbox setState:[PreferenceController preferenceWindowResizeEnabledFlag]];
}

#pragma mark Class methods

+ (NSColor*)preferenceWindowBackgroundColor
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *colorAsData = [defaults objectForKey:WindowBackgroundColor];
    NSError *error = nil;
    NSColor *color = [NSKeyedUnarchiver unarchivedObjectOfClass:NSColor.class
                                                       fromData:colorAsData
                                                          error:&error];
    
    if (error != nil)
    {
        NSLog(@"Error code:%d", (int)error.code);
        return [NSColor yellowColor];
    }
    
    return color;
}

+ (void)setPreferenceWindowBackgroundColor: (NSColor*)color
{
    NSError *error = nil;
    NSData *colorAsData = [NSKeyedArchiver archivedDataWithRootObject:color
                                                requiringSecureCoding:YES
                                                                error:&error];
    
    if (error != nil)
    {
        NSLog(@"Error code:%d", (int)error.code);
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:colorAsData forKey:WindowBackgroundColor];
}

+ (BOOL)preferenceWindowResizeEnabledFlag
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:WindowResizeEnabledFlag];
}

+ (void)setPreferenceWindowResizeEnabledFlag: (BOOL)resizeEnabled
{
    [[NSUserDefaults standardUserDefaults] setBool:resizeEnabled forKey:WindowResizeEnabledFlag];
}

#pragma mark Action methods

- (IBAction)changeBackgroundColor:(id)sender
{
    NSColor *color = [colorWell color];
    [PreferenceController setPreferenceWindowBackgroundColor:color];
    NSDictionary *data = [NSDictionary dictionaryWithObject:color forKey:@"color"];
    [self postNotification:WindowColorChangedNotification userInfo:data];
}

- (IBAction)changeResizeEnabled:(id)sender
{
    NSInteger state = [checkbox state];
    [PreferenceController setPreferenceWindowResizeEnabledFlag:state];
    NSDictionary *data = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:state]
                                                     forKey:@"state"];
    [self postNotification:WindowResizeEnabledFlagChangedNotification userInfo:data];
}

- (void)postNotification: (NSString*) notificationName userInfo: (NSDictionary*) data
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:notificationName
                                      object:self
                                    userInfo:data];
}

@end

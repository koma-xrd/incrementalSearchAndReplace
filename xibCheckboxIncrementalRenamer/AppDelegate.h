//
//  AppDelegate.h
//  xibCheckboxIncrementalRenamer
//
//  Created by Martin Kötzing on 29.03.17.
//  Copyright © 2017 mk. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property NSURL* filepath;


- (IBAction)addPath:(id)sender;
- (IBAction)removePath:(id)sender;
@property (weak) IBOutlet NSTextField *pathLabel;
@property (weak) IBOutlet NSTextField *replaceStringLabel;
- (IBAction)startReplacement:(id)sender;

@property (unsafe_unretained) IBOutlet NSTextView *log;


@end


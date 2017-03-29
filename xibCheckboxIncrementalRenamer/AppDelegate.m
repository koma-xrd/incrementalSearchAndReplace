//
//  AppDelegate.m
//  xibCheckboxIncrementalRenamer
//
//  Created by Martin Kötzing on 29.03.17.
//  Copyright © 2017 mk. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
	// Insert code here to tear down your application
}


- (IBAction)addPath:(id)sender {
	NSOpenPanel* openDialog = [NSOpenPanel openPanel];
	[openDialog setCanChooseDirectories:NO];
	[openDialog setCanChooseFiles:YES];
	[openDialog setAllowsMultipleSelection:NO];
	
	if ( [openDialog runModal] == NSModalResponseOK)
	{
		NSArray* files = [openDialog URLs];
		self.filepath = [files firstObject];
		[self.pathLabel setStringValue:self.filepath.path];
	}
}

- (IBAction)removePath:(id)sender {
	self.filepath = nil;
	[self.pathLabel setStringValue:@""];
}

- (IBAction)startReplacement:(id)sender {
	if (!self.filepath || self.replaceStringLabel.stringValue.length<1) {
		[self.log setString:[self.log.string stringByAppendingString:@"No FilePath or Replacestring specified"]];
		NSLog(@"No FilePath or Replacestring specified");
		return;
	}
	
	
	NSString *filecontent = [NSString stringWithContentsOfURL:self.filepath encoding:NSUTF8StringEncoding error:nil];
	
	NSString *toFind = self.replaceStringLabel.stringValue;
	[self.log setString:[self.log.string stringByAppendingString:[NSString stringWithFormat:@"find all: %@", toFind]]];
	NSLog(@"find all: %@", toFind);
	
	NSInteger i = 0;
	// Initialise the searching range to the whole string
	NSRange searchRange = NSMakeRange(0, [filecontent length]);
	do {
		// Search for next occurrence
		NSRange range = [filecontent rangeOfString:toFind options:0 range:searchRange];
		if (range.location != NSNotFound) {
			
			NSString* stringToReplace = [filecontent substringWithRange:range];
			
			// If found, range contains the range of the current iteration
			NSString* replaceString = [self.replaceStringLabel.stringValue stringByAppendingString:[NSString stringWithFormat:@"%ld",i]];
			filecontent = [filecontent stringByReplacingCharactersInRange:range withString:replaceString];
			
			NSLog(@"%@ to %@ at %@",stringToReplace,replaceString,NSStringFromRange(range));
			[self.log setString:[self.log.string stringByAppendingString:[NSString stringWithFormat:@"%@ to %@ at %@",stringToReplace,replaceString,NSStringFromRange(range)]]];
			// Reset search range for next attempt to start after the current found range
			searchRange.location = range.location + range.length;
			searchRange.length = [filecontent length] - searchRange.location;
			i++;
		} else {
			// If we didn't find it, we have no more occurrences
			NSError *error;
			BOOL succeed = [filecontent writeToURL:self.filepath atomically:YES encoding:NSUTF8StringEncoding error:&error];
			if (!succeed){
				NSLog(@"string not written to file");
				[self.log setString:[self.log.string stringByAppendingString:@"string not written to file"]];
			}
			
			break;
		}
	} while (1);
}

@end

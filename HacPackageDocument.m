#import "HacPackageDocument.h"

#import "NSString+TemporaryDirectoryAdditions.h"

@implementation HacPackageDocument

#pragma mark -
#pragma mark Document Lifecycle

- (id)init
{
    self = [super init];
    if (self)
	{
    }
    return self;
}

- (void)dealloc
{
	[package release];

	[super dealloc];
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
// Start extracting as soon as the window loads.
{
	[super windowControllerDidLoadNib:aController];

	[self showWindows];
	
	// [self setStatusMessage:@"Opening..."];

	[package beginExtraction];

	[self showLoadingSheet];
}


- (void)close
// Remove all temporary files when the document is closed.
{
	[package cleanUp];

	[super close];
}

#pragma mark -
#pragma mark Document Methods

- (NSString *)windowNibName
{
    return @"MyDocument";
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
// This method would be used if the application could save documents.
{
	if (outError != NULL)
	{
		*outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
	}
	return nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    if (outError != NULL)
	{
		*outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
	}
    return YES;
}

- (BOOL)readFromURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)outError
// Recover the payload of a package and extract its contents.
{
	// This is the original package on disk.
	package = [[HacPackage alloc] init];
	[package setDelegate:self];
	[package setPackagePath:[absoluteURL path]];

	return YES;
}

#pragma mark -
#pragma mark Interface Actions

- (IBAction)extractSelectedFiles:(id)sender
{
	[dialogManager saveFilesAtTemporaryPaths:[outlineViewController selectedBasePaths]];
}

- (IBAction)extractSelectedFilesToDesktop:(id)sender
{
	[dialogManager saveFilesAtTemporaryPaths:[outlineViewController selectedBasePaths]
								 toDirectory:[@"~/Desktop" stringByExpandingTildeInPath]];
}

- (BOOL)validateToolbarItem:(NSToolbarItem *)theItem
{
	int numberOfSelectedFiles = [[outlineViewController selectedBasePaths] count];
	return (numberOfSelectedFiles == 1);
}

#pragma mark -
#pragma mark Loading Sheet

- (void)showLoadingSheet
// Show the progress indicator.
{
	[progressIndicator setUsesThreadedAnimation:YES];
	[progressIndicator startAnimation:nil];

	[NSApp beginSheet:progressWindow
	   modalForWindow:documentWindow
		modalDelegate:self
	   didEndSelector:nil
		  contextInfo:nil];

	//[NSApp runModalForWindow:progressWindow];
}

- (void)hideLoadingSheet
// Hide the progress indicator.
{
	//[NSApp stopModalWithCode:1];

	[NSApp endSheet:progressWindow];
	[progressWindow orderOut:nil];

	[progressIndicator stopAnimation:nil];
}

#pragma mark -
#pragma mark Package Delegate

- (void)setStatusMessage:(NSString *)newMessage
{
	[progressLabel setStringValue:newMessage];
}

- (void)extractionFailedWithError:(NSString *)errorMessage
{
	[self hideLoadingSheet];

	NSAlert *alert = [[[NSAlert alloc] init] autorelease];
	[alert addButtonWithTitle:@"OK"];
	[alert setMessageText:@"Extraction Failed"];
	[alert setInformativeText:errorMessage];
	[alert setAlertStyle:NSInformationalAlertStyle];
	[alert beginSheetModalForWindow:documentWindow
					  modalDelegate:self
					 didEndSelector:nil
						contextInfo:nil];
}

- (void)extractionSucceded
{
	[self hideLoadingSheet];

	[outlineViewController setPayloadDirectory:[package payloadDirectory]];
	[outlineView reloadData];

	// If the first item is an Applications folder, expand it by default.
	if ([[outlineView itemAtRow:0] isEqualToString:[[package payloadDirectory] stringByAppendingPathComponent:@"Applications"]])
		[outlineView expandItem:[outlineView itemAtRow:0]];
}

@end

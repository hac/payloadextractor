#import "HacFileDialogManager.h"

#import "NSFileManager+TigerCompatibilityAdditions.h"

#import "NSString+TemporaryDirectoryAdditions.h"

@implementation HacFileDialogManager

- (void)showCopyFilePanel
{
	NSString *pathToCopy = [pathsToCopy objectAtIndex:0];
	
	NSSavePanel *extractPanel = [[[NSSavePanel alloc] init] autorelease];
	[extractPanel beginSheetForDirectory:nil
									file:[pathToCopy lastPathComponent]
						  modalForWindow:window
						   modalDelegate:self
						  didEndSelector:@selector(copyFilePanelDidEnd:returnCode:contextInfo:)
							 contextInfo:[pathToCopy retain]];
}

- (void)copyFilePanelDidEnd:(NSSavePanel *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo
{    
    if (returnCode != NSOKButton)
		return;
	
	NSString *filename = [sheet filename];
	[[NSFileManager defaultManager] copyPath:[pathsToCopy objectAtIndex:0]
									  toPath:filename
									 handler:nil];
}

/* The below is for saving multiple files at once. */
/* It needs some work. */
/*
- (void)checkForExistingFiles:(NSArray *)pathsToCopy
				  inDirectory:(NSString *)destinationDirectory
{
	NSMutableArray *existingFiles = [NSMutableArray array], *existingFileShortNames = [NSMutableArray array];
	int i;
	for (i = 0; i < [pathsToCopy count]; i++)
	{
		NSString *pathToCopy = [pathsToCopy objectAtIndex:i];
		NSString *pathToCopyTo = [destinationDirectory stringByAppendingLastPathComponentOfPath:pathToCopy];
		
		if ([[NSFileManager defaultManager] fileExistsAtPath:pathToCopyTo])
		{
			[existingFiles addObject:pathToCopy];
			[existingFileShortNames addObject:[pathToCopy lastPathComponent]];
		}
	}
	
	if ([existingFiles count])
	{
		NSAlert *alert = [[[NSAlert alloc] init] autorelease];
		[alert addButtonWithTitle:@"Replace"];
		[alert addButtonWithTitle:@"Cancel"];
		
		if ([existingFiles count] == 1)
		{
			NSString *messageFormat = @"\"%@\" already exists. Do you want to replace it?";
			[alert setMessageText:[NSString stringWithFormat:messageFormat, [existingFileShortNames objectAtIndex:0]]];
			NSString *textFormat = @"A file or folder with the same name already exists in the folder %@. Replacing it will overwrite its current contents.";
			[alert setInformativeText:[NSString stringWithFormat:textFormat, [destinationDirectory lastPathComponent]]];
		}
		else
		{
			NSString *messageFormat = @"%d of the selected items already exist. Do you want to replace them?";
			[alert setMessageText:[NSString stringWithFormat:messageFormat, [existingFileShortNames count]]];
			NSString *textFormat = @"Multiples files and/or folders will be overwritten if the selected items are extracted to %@.";
			[alert setInformativeText:[NSString stringWithFormat:textFormat, [destinationDirectory lastPathComponent]]];
		}
		[alert setAlertStyle:NSWarningAlertStyle];
		[alert beginSheetModalForWindow:documentWindow
						  modalDelegate:self
						 didEndSelector:@selector(someMethodDidEnd:returnCode:contextInfo:)
							contextInfo:nil];	
	}
}

- (void)copyFiles:(NSArray *)pathsToCopy
	  toDirectory:(NSString *)destinationDirectory
{
	for (i = 0; i < [pathsToCopy count]; i++)
	{
		NSString *pathToCopy = [pathsToCopy objectAtIndex:i];
		
		[[NSFileManager defaultManager] copyPath:pathToCopy
										  toPath:[destinationDirectory stringByAppendingLastPathComponentOfPath:pathToCopy]
										 handler:nil];
	}
}

- (void)showCopyMultipleFilesPanel
{
	NSOpenPanel *extractPanel = [[[NSOpenPanel alloc] init] autorelease];
	
	// Make the user select a directory:
	[extractPanel setCanChooseFiles:NO];
	[extractPanel setCanChooseDirectories:YES];
	
	[[extractPanel defaultButtonCell] setTitle:@"Save"];
	
	[extractPanel beginSheetForDirectory:[@"~/Desktop" stringByExpandingTildeInPath]
									file:nil
						  modalForWindow:window
						   modalDelegate:self
						  didEndSelector:@selector(saveMultipleFilesPanelDidEnd:returnCode:contextInfo:)
							 contextInfo:nil];
}

- (void)saveMultipleFilesPanelDidEnd:(NSOpenPanel *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo
{    
    if (returnCode != NSOKButton)
		return;
	
	[self copyFiles:pathsToCopy
		toDirectory:[sheet filename]];
}
 */

- (void)saveFilesAtTemporaryPaths:(NSArray *)paths
{
	[pathsToCopy release];
	pathsToCopy = [paths retain];
	
	if ([pathsToCopy count] == 1)
	{
		[self showCopyFilePanel];
	}
	else if ([pathsToCopy count] > 1)
	{
		//[self showCopyMultipleFilesPanel];
	}
	
}

- (void)saveFilesAtTemporaryPaths:(NSArray *)paths
					  toDirectory:(NSString *)destinationDirectory
{
	if ([paths count] == 1)
	{
		NSString *filePath = [paths objectAtIndex:0];
		
		// Copy with the workspace so this app doesn't hang:
		// (This is also faster than using NSFileManager.)
		
		[[NSWorkspace sharedWorkspace] performFileOperation:NSWorkspaceCopyOperation
													 source:[filePath stringByDeletingLastPathComponent]
												destination:destinationDirectory
													  files:[NSArray arrayWithObject:[filePath lastPathComponent]]
														tag:0];
	}
	else if ([paths count] > 1)
	{
	}
}

- (void)dealloc
{
	[pathsToCopy release];
	
	[super dealloc];
}

@end

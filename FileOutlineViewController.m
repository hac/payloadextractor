#import "FileOutlineViewController.h"

#import "FileOutlineViewCell.h"

@implementation FileOutlineViewController

- (void)awakeFromNib
{
	[[outlineView outlineTableColumn] setDataCell:[[[FileOutlineViewCell alloc] init] autorelease]];
}

- (void)dealloc
{
	[selectedBasePaths release];
	[payloadDirectory release];
	
	[super dealloc];
}

- (NSString *)payloadDirectory
{
    return [[payloadDirectory retain] autorelease];
}

- (void)setPayloadDirectory:(NSString *)value
{
    if (payloadDirectory != value)
	{
        [payloadDirectory release];
        payloadDirectory = [value copy];
    }
}

#pragma mark -
#pragma mark Outline View Data Source

- (BOOL)outlineView:(NSOutlineView *)ov
   isItemExpandable:(id)item
// Return yes for directories and no for anything else.
{
	BOOL isDirectory;
	[[NSFileManager defaultManager] fileExistsAtPath:item isDirectory:&isDirectory];

	return isDirectory && [[item pathExtension] isEqualToString:@""];
}

- (int)outlineView:(NSOutlineView *)ov
numberOfChildrenOfItem:(id)item
// How many files are in the directory?
{
	if (item == nil)
		item = [self payloadDirectory];

	NSArray *directoryContents = [[NSFileManager defaultManager] directoryContentsAtPath:item];
	return [directoryContents count];
}

- (id)outlineView:(NSOutlineView *)ov
			child:(int)index
		   ofItem:(id)item
// What files are in the directory?
{
	if (item == nil)
		item = [self payloadDirectory];

	NSArray *directoryContents = [[NSFileManager defaultManager] directoryContentsAtPath:item];
	return [[item stringByAppendingPathComponent:[directoryContents objectAtIndex:index]] retain];
}

- (id)outlineView:(NSOutlineView *)ov
objectValueForTableColumn:(NSTableColumn*)col
		   byItem:(id)item
// What should be displayed in a row of the outline view?
{
	return [item lastPathComponent];
}

- (BOOL)outlineView:(NSOutlineView *)anOutlineView
		 writeItems:(NSArray *)items
	   toPasteboard:(NSPasteboard *)pasteboard
// Get ready to copy a file.
{
	[pasteboard declareTypes:[NSArray arrayWithObjects: nil] owner:self];
	[pasteboard declareTypes:[NSArray arrayWithObjects: NSFilenamesPboardType, nil] owner:self];

	[pasteboard setPropertyList:[NSArray arrayWithObjects: nil] forType:NSFilenamesPboardType];
	[pasteboard setPropertyList:items forType:NSFilenamesPboardType];

	return YES;
}

#pragma mark -
#pragma mark Outline View Delegate

- (void)outlineView:(NSOutlineView *)outlineView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
	NSImage *icon = [[NSWorkspace sharedWorkspace] iconForFile:item];
	//[icon setSize:NSMakeSize(16, 16)];
	[cell setImage:icon];
	[cell setLeaf:YES];
}

- (void)outlineViewSelectionDidChange:(NSNotification *)notification
{
	[selectedBasePaths release];
	selectedBasePaths = [[outlineView selectedBasePaths] retain];
}

- (NSArray *)selectedBasePaths
{
	return selectedBasePaths;
}

@end

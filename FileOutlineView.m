#import "FileOutlineView.h"

#import "NSString+TemporaryDirectoryAdditions.h"

@implementation FileOutlineView

- (NSDragOperation)draggingSourceOperationMaskForLocal:(BOOL)isLocal
{
	// Copy, don't move, dragged files.
	return NSDragOperationCopy;
}

- (BOOL)canDragRowsWithIndexes:(NSIndexSet *)rowIndexes atPoint:(NSPoint)mouseDownPoint
{
	// All files are draggable.
	return YES;
}

- (NSArray *)selectedItems
// Return the paths of all the selected files.
{
	NSIndexSet *selectedRowIndexes = [self selectedRowIndexes];
	int maxCount = [selectedRowIndexes count];
	unsigned int buffer[maxCount];
	[selectedRowIndexes getIndexes:buffer maxCount:maxCount inIndexRange:NULL];
	
	NSMutableArray *nodes = [[[NSMutableArray alloc] init] autorelease];
	int i;
	for (i = 0; i < maxCount; i++)
	{
		[nodes addObject:[self itemAtRow:buffer[i]]];
	}
	
	return [NSArray arrayWithArray:nodes];
}

+ (BOOL)pathIsBasePath:(NSString *)pathToAdd
			   ofPaths:(NSArray *)opponentPaths
{
	int j;
	for (j = 0; j < [opponentPaths count]; j++)
	{
		NSString *opponentPath = [opponentPaths objectAtIndex:j];
		
		if ([pathToAdd isSubpathOfPath:opponentPath])
			return NO;
	}
	
	return YES;
}

- (NSArray *)selectedBasePaths
// Return the paths of all the selected files that aren't inside of a selected directory.
// We use this when copying multiple files.
{
	NSArray *paths = [self selectedItems];
	NSMutableArray *basePaths = [NSMutableArray array];
	
	int i;
	for (i = 0; i < [paths count]; i++)
	{
		NSString *pathToAdd = [paths objectAtIndex:i];
		if ([FileOutlineView pathIsBasePath:pathToAdd ofPaths:paths])
			[basePaths addObject:pathToAdd];
		
	}
	
	return [NSArray arrayWithArray:basePaths];
}

- (void)keyUp:(NSEvent *)theEvent
{
	if ([[theEvent characters] isEqualToString:@" "])
	{
		// This is where QuickLook support would go (requires Snow Leopard).
		/*
		NSString *path = [self itemAtRow:[self selectedRow]];

		[[QLPreviewPanel sharedPreviewPanel] setURLs:[NSArray arrayWithObject:[NSURL fileURLWithPath:path]] currentIndex:0 preservingDisplayState:YES];

		// Fade in.
		[[QLPreviewPanel sharedPreviewPanel] makeKeyAndOrderFrontWithEffect:1];
		 */
	}
}

@end

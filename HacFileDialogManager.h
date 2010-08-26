#import <Cocoa/Cocoa.h>

@interface HacFileDialogManager : NSObject
{
	IBOutlet NSWindow *window;
	
	NSArray *pathsToCopy;
}

- (void)saveFilesAtTemporaryPaths:(NSArray *)paths;
- (void)saveFilesAtTemporaryPaths:(NSArray *)paths
					  toDirectory:(NSString *)destinationDirectory;

@end

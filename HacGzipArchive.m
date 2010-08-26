#import "HacGzipArchive.h"

#import "NSFileManager+TigerCompatibilityAdditions.h"

#import "NSTask+InitializerAdditions.h"

#import "NSString+TemporaryDirectoryAdditions.h"

// This exists in OS X 10.4, 10.5 and 10.6
#define gunzip @"/usr/bin/gunzip"

@implementation HacGzipArchive

- (BOOL)extractArchiveContentsToDirectory:(NSString *)directory
{
	NSString *finalPath = [directory stringByAppendingLastPathComponentOfPath:[archivePath stringByDeletingPathExtension]];
	
	// Create the unarchived file.
	[[NSFileManager defaultManager] createFileAtPath:finalPath contents: @"" attributes:nil];
	
	NSTask *task = [NSTask taskWithLaunchPath:gunzip
											arguments:[NSArray arrayWithObjects:@"-c", archivePath, nil]
									   standardOutput:[NSFileHandle fileHandleForWritingAtPath:finalPath]
									 workingDirectory:nil];
	
	// Write the unarchived file.
	BOOL result = [self validateAndLaunchTask:task];
	
	if (!result)
		// If writing failed...
	{
		// Delete the unarchived file.
		[[NSFileManager defaultManager] removeFileAtPath:finalPath
												 handler:nil];
	}
	
	return result;
}

@end

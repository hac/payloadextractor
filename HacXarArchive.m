#import "HacXarArchive.h"

#import "NSTask+InitializerAdditions.h"

// This is a universal binary for 10.4 or later.
#define xar [[NSBundle mainBundle] pathForResource:@"xar" ofType:@""]

@implementation HacXarArchive

- (BOOL)extractArchiveContentsToDirectory:(NSString *)directory
{
	NSTask *task = [NSTask taskWithLaunchPath:xar
											arguments:[NSArray arrayWithObjects:@"-x", @"-f", archivePath, nil]
									   standardOutput:nil
									 workingDirectory:directory];
	
	return [self validateAndLaunchTask:task];
}

@end

#import "HacPaxArchive.h"

#import "NSTask+InitializerAdditions.h"

// This exists in OS X 10.4, 10.5 and 10.6
#define pax @"/bin/pax"

@implementation HacPaxArchive

- (BOOL)extractArchiveContentsToDirectory:(NSString *)directory
{
	NSTask *task = [NSTask taskWithLaunchPath:pax
											arguments:[NSArray arrayWithObjects:@"-r", @"-s", @"-^/--", @"-f", archivePath, nil]
									   standardOutput:nil
									 workingDirectory:directory];
	
	return [self validateAndLaunchTask:task];
}

@end

#import "NSTask+InitializerAdditions.h"

#import "NSFileManager+TigerCompatibilityAdditions.h"

@implementation NSTask (InitializerAdditions)

+ (NSTask *)taskWithLaunchPath:(NSString *)launchPath
					 arguments:(NSArray *)arguments
				standardOutput:(id)standardOutput
			  workingDirectory:(NSString *)workingDirectory
{
	NSTask *task = [[NSTask alloc] init];

	if (launchPath)
		[task setLaunchPath:launchPath];

	if (arguments)
		[task setArguments:arguments];

	if (standardOutput)
		[task setStandardOutput:standardOutput];

	if (workingDirectory && [[NSFileManager defaultManager] directoryExistsAtPath:workingDirectory])
		[task setCurrentDirectoryPath:workingDirectory];

	return [task autorelease];
}

+ (NSTask *)launchedTaskWithLaunchPath:(NSString *)launchPath
							 arguments:(NSArray *)arguments
						standardOutput:(id)standardOutput
					  workingDirectory:(NSString *)workingDirectory
{
	NSTask *task = [self taskWithLaunchPath:launchPath
								  arguments:arguments
							 standardOutput:standardOutput
						   workingDirectory:workingDirectory];
	[task launch];
	return task;
}

+ (NSString *)errorMessageForLaunchPath:(NSString *)launchPath
{
	if (![[NSFileManager defaultManager] fileExistsAtPath:launchPath])
		return [NSString stringWithFormat:@"The command-line tool %@ does not exist.", launchPath];
		
	if ([[NSFileManager defaultManager] directoryExistsAtPath:launchPath])
		return [NSString stringWithFormat:@"The command-line tool %@ does not exist. I found a directory in its place.", launchPath];
	
	if (![[NSFileManager defaultManager] isExecutableFileAtPath:launchPath])
		return [NSString stringWithFormat:@"The command-line tool %@ exists, but it is not executable. Try running \"sudo chmod +x %@\" in Terminal, then opening this package again.", launchPath, launchPath];
	
	return nil;
}

@end

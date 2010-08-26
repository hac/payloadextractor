#import "HacFileArchive.h"

#import "NSFileManager+TigerCompatibilityAdditions.h"

#import "NSString+TemporaryDirectoryAdditions.h"

#import "NSTask+InitializerAdditions.h"

@implementation HacFileArchive

+ (HacFileArchive *)archiveAtPath:(NSString *)path
{
	HacFileArchive *archive = [[self alloc] init];
	[archive setArchivePath:path];
	return [archive autorelease];
}

- (NSString *)errorMessage
{
	return errorMessage;
}

- (void)setErrorMessage:(NSString *)value
{
	if (errorMessage != value)
	{
		[errorMessage release];
		errorMessage = [value retain];
	}
}

- (NSString *)archivePath
{
    return archivePath;
}

- (void)setArchivePath:(NSString *)value
{
    if (archivePath != value)
	{
        [archivePath release];
        archivePath = [value retain];
    }
}

- (BOOL)archiveExists
{
	return ([archivePath length] && [[NSFileManager defaultManager] fileNotDirectoryExistsAtPath:archivePath]);
}

- (BOOL)extractArchiveContentsToDirectory:(NSString *)directory
{
	return NO;
}

- (NSString *)extractArchiveContentsToTemporaryDirectory
{
	NSString *temporaryDirectory = [NSString temporaryDirectory];

	if ([self extractArchiveContentsToDirectory:temporaryDirectory])
	{
		return temporaryDirectory;
	}

	[temporaryDirectory deleteTemporaryDirectory];
	return nil;
}

- (BOOL)validateAndLaunchTask:(NSTask *)task
{
	if (![self archiveExists]) return NO;
	
	NSString *error = [NSTask errorMessageForLaunchPath:[task launchPath]];
	if (error)
	{
		[self setErrorMessage:error];
		return NO;
	}
	
	[task launch];
	[task waitUntilExit];
	
	return YES;
}

@end

#import "HacPackage.h"

#import "HacGzipArchive.h"
#import "HacPaxArchive.h"
#import "HacXarArchive.h"

// This category adds some Leopard-only features to NSFileManager so we can use them on Tiger.
#import "NSFileManager+TigerCompatibilityAdditions.h"

#import "NSString+TemporaryDirectoryAdditions.h"

@implementation HacPackage

#pragma mark -
#pragma mark Life Cycle

- (id)init
{
	if (self = [super init])
	{
		packagePath = nil;
		extractionFailed = NO;
	}

	return self;
}

- (void)dealloc
{
	[destinationDirectory release];
	[packagePath release];

	[super dealloc];
}

#pragma mark -
#pragma mark Accessor Methods

- (id <HacPackageDelegate>)delegate
{
	return delegate;
}

- (void)setDelegate:(id <HacPackageDelegate>)newDelegate
{
	delegate = newDelegate;
}

- (NSString *)packagePath
{
    return packagePath;
}

- (void)setPackagePath:(NSString *)value
{
    if (packagePath != value)
	{
        [packagePath release];
        packagePath = [value retain];
    }
}

- (NSString *)payloadDirectory
// This is the directory in the temporary directory that the extracted payload contents go in.
{
	return destinationDirectory;
}

#pragma mark -
#pragma mark Delegate Methods

- (void)setStatusMessage:(NSString *)newMessage
{
	[delegate performSelectorOnMainThread:@selector(setStatusMessage:)
							   withObject:newMessage
							waitUntilDone:YES];
}

- (void)extractionFailedWithError:(NSString *)errorMessage
{
	if (!extractionFailed)
	{
		extractionFailed = YES;
		[delegate performSelectorOnMainThread:@selector(extractionFailedWithError:)
								   withObject:errorMessage
								waitUntilDone:YES];
	}
}

- (void)extractionSucceded
{
	[delegate performSelectorOnMainThread:@selector(extractionSucceded)
							   withObject:nil
							waitUntilDone:YES];
}

#pragma mark -
#pragma mark Steps

- (BOOL)copyPayloadToPath:(NSString *)payloadDestination
// Extract the payload of a bundle (pre-Leopard) package.
{
	NSString *payloadPath = [packagePath stringByAppendingPathComponent:@"Contents/Archive.pax.gz"];

	return [[NSFileManager defaultManager] copyPath:payloadPath toPath:payloadDestination handler:nil];
}

- (BOOL)copyPayloadFromFlatPackageToPath:(NSString *)payloadDestination
// Extract the payload of a flat (Leopard) package.
{
	BOOL success;

	HacFileArchive *xarArchive = [HacXarArchive archiveAtPath:packagePath];
	NSString *extractedPackageDirectory = [xarArchive extractArchiveContentsToTemporaryDirectory];
	
	if (!extractedPackageDirectory)
	{
		if ([xarArchive errorMessage])
			[self extractionFailedWithError:[xarArchive errorMessage]];
		return NO;
	}

	NSArray *packageContents = [[NSFileManager defaultManager] directoryContentsAtPath:extractedPackageDirectory];

	NSString *extractedPackage = nil;

	int i;
	for (i = 0; i < [packageContents count]; i++)
	{
		NSString *file = [packageContents objectAtIndex:i];
		if ([[file pathExtension] isEqualToString:@"pkg"])
		{
			extractedPackage = [extractedPackageDirectory stringByAppendingPathComponent:file];
			break;
		}
	}

	if (!extractedPackage)
	{
		[self extractionFailedWithError:@"This file does not appear to contain any packages."];
		return NO;
	}

	NSString *payloadPath = [extractedPackage stringByAppendingPathComponent:@"Payload"];

	success = [[NSFileManager defaultManager] movePath:payloadPath
												toPath:payloadDestination
											   handler:nil];
	if (!success) return NO;

	success = [extractedPackageDirectory deleteTemporaryDirectory];

	return success;
}

#pragma mark -
#pragma mark Extraction

- (BOOL)makeDestinationDirectory
// Make a directory to files extracted from a payload.
{
	destinationDirectory = [[NSString temporaryDirectory] retain];
	
	BOOL result = [[NSFileManager defaultManager] directoryExistsAtPath:destinationDirectory];
	
	if (!result)
	{
		[self extractionFailedWithError:@"I could not extract the package because I could not create a temporary directory."];
	}
	
	return result;
}

- (BOOL)extract
// Go through all of the steps nenecessary to extract the contents of a package.
// Sorry if this method is a little hard to follow. Hopefully it will be removed in a later version of the app.
{
	/* Set up. */
	
	BOOL success;

	[self makeDestinationDirectory];
	
	if (extractionFailed) return NO;

	/* 1. Move the payoad(s) (.pax.gz) from the package into a temporary directory: */
	
	[self setStatusMessage:@"Retrieving Payload..."];

	NSString *payloadDirectory = [NSString temporaryDirectory];

	// Discover what kind of package we are dealing with and find the payload accordingly:
	NSString *payloadPath = [payloadDirectory stringByAppendingPathComponent:@"Payload.pax.gz"];

	if ([[NSFileManager defaultManager] directoryExistsAtPath:packagePath])
		success = [self copyPayloadToPath:payloadPath];
	else
		success = [self copyPayloadFromFlatPackageToPath:payloadPath];

	if (!success)
	{
		[self extractionFailedWithError:@"Something bad happened when I tried to get the payload."];
	}

	if (extractionFailed)
	{
		[payloadDirectory deleteTemporaryDirectory];
		return NO;
	}
	
	/* 2. Decompress the payload(s) from .pax.gx to .pax. */

	[self setStatusMessage:@"Decompressing..."];

	HacFileArchive *gzipArchive = [HacGzipArchive archiveAtPath:payloadPath];
	NSString *gzipContentsDirectory = [gzipArchive extractArchiveContentsToTemporaryDirectory];
	
	[payloadDirectory deleteTemporaryDirectory];

	if (!gzipContentsDirectory)
	{
		if ([gzipArchive errorMessage])
			[self extractionFailedWithError:[gzipArchive errorMessage]];
		else
			[self extractionFailedWithError:@"Something bad happened when I tried to decompress the payload."];
	}

	if (extractionFailed) return NO;
	
	/* 3. Extract the files from the payload(s) (.pax) into a temporary directory. */

	[self setStatusMessage:@"Extracting Files..."];
	
	payloadPath = [gzipContentsDirectory stringByAppendingPathComponent:@"Payload.pax"];
	
	// Unflatten the payload from its cpio format.
	HacFileArchive *paxArchive = [HacPaxArchive archiveAtPath:payloadPath];
	success = [paxArchive extractArchiveContentsToDirectory:destinationDirectory];

	[gzipContentsDirectory deleteTemporaryDirectory];

	if (!success)
	{
		if ([paxArchive errorMessage])
			[self extractionFailedWithError:[paxArchive errorMessage]];
		else
			[self extractionFailedWithError:@"Something bad happened when I tried to extract files from the payload."];
	}

	if (extractionFailed) return NO;
	
	/* Finish. */

	[self extractionSucceded];

	return YES;
}

- (BOOL)extractInAutoreleasePool
{
	NSAutoreleasePool *autoreleasePool = [[NSAutoreleasePool alloc] init];

	BOOL result = [self extract];

	[autoreleasePool release];

	return result;
}

- (void)beginExtraction
{
	[NSThread detachNewThreadSelector:@selector(extractInAutoreleasePool)
							 toTarget:self
						   withObject:nil];
}

- (void)cleanUp
{
	[destinationDirectory deleteTemporaryDirectory];
}

@end

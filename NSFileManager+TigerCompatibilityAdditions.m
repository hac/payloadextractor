#import "NSFileManager+TigerCompatibilityAdditions.h"

@implementation NSFileManager (TigerCompatibilityAdditions)

- (BOOL)directoryExistsAtPath:(NSString *)path
{
	BOOL isDirectory;
	return [self fileExistsAtPath:path isDirectory:&isDirectory] && isDirectory;
}

- (BOOL)fileNotDirectoryExistsAtPath:(NSString *)path
{
	BOOL isDirectory;
	return [self fileExistsAtPath:path isDirectory:&isDirectory] && !isDirectory;
}

- (BOOL)createDirectoryAtPath:(NSString *)path
  withIntermediateDirectories:(BOOL)createIntermediates
				   attributes:(NSDictionary *)attributes
{
	if (createIntermediates)
	{
		NSString *parentDirectory = [path stringByDeletingLastPathComponent];

		if (![self directoryExistsAtPath:parentDirectory])
		{
			if (![self createDirectoryAtPath:parentDirectory
				 withIntermediateDirectories:createIntermediates
								  attributes:attributes])
				return NO;
		}
	}

	return [self createDirectoryAtPath:path
							attributes:attributes];
}

@end

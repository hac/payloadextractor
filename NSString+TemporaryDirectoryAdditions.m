#import "NSString+TemporaryDirectoryAdditions.h"

#import "NSFileManager+TigerCompatibilityAdditions.h"

@implementation NSString (TemporaryDirectoryAdditions)

+ (NSString *)temporaryDirectory
{
	NSString *directory = NSTemporaryDirectory();
	//directory = [directory stringByAppendingPathComponent:[[NSProcessInfo processInfo] globallyUniqueString]];
	directory = [directory stringByAppendingPathComponent:[[NSBundle mainBundle] bundleIdentifier]];
	directory = [directory stringByAppendingPathComponent:[NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]]];

	[[NSFileManager defaultManager] createDirectoryAtPath:directory
							  withIntermediateDirectories:YES
											   attributes:nil];

	return directory;
}

- (BOOL)deleteTemporaryDirectory
{
	return [[NSFileManager defaultManager] removeFileAtPath:self
											 handler:nil];
}

- (BOOL)isSubpathOfPath:(NSString *)parentPath
{
	NSArray *parentComponents = [parentPath pathComponents];
	NSArray *childComponents = [self pathComponents];
	
	if ([parentComponents count] == [childComponents count])
		return NO;
	
	if ([parentComponents count] > [childComponents count])
		return NO;
	
	childComponents = [childComponents subarrayWithRange:NSMakeRange(0, [parentComponents count])];

	return [parentComponents isEqualToArray:childComponents];
}

- (NSString *)stringByAppendingLastPathComponentOfPath:(NSString *)path
{
	return [self stringByAppendingPathComponent:[path lastPathComponent]];
}

@end

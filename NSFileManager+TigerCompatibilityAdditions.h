#import <Cocoa/Cocoa.h>

@interface NSFileManager (TigerCompatibilityAdditions)

- (BOOL)directoryExistsAtPath:(NSString *)path;
- (BOOL)fileNotDirectoryExistsAtPath:(NSString *)path;

- (BOOL)createDirectoryAtPath:(NSString *)path
  withIntermediateDirectories:(BOOL)createIntermediates
				   attributes:(NSDictionary *)attributes;

@end

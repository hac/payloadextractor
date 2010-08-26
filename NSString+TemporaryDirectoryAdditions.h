#import <Cocoa/Cocoa.h>

@interface NSString (TemporaryDirectoryAdditions)

+ (NSString *)temporaryDirectory;
- (BOOL)deleteTemporaryDirectory;

- (BOOL)isSubpathOfPath:(NSString *)parentPath;

- (NSString *)stringByAppendingLastPathComponentOfPath:(NSString *)path;

@end

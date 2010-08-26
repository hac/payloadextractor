#import <Cocoa/Cocoa.h>

@interface HacFileArchive : NSObject
{
	NSString *archivePath, *errorMessage;
}

+ (HacFileArchive *)archiveAtPath:(NSString *)path;

- (NSString *)errorMessage;
- (void)setErrorMessage:(NSString *)value;

- (NSString *)archivePath;
- (void)setArchivePath:(NSString *)value;

- (BOOL)archiveExists;

- (BOOL)extractArchiveContentsToDirectory:(NSString *)directory;

- (NSString *)extractArchiveContentsToTemporaryDirectory;

- (BOOL)validateAndLaunchTask:(NSTask *)task;

@end

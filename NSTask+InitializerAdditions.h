#import <Cocoa/Cocoa.h>

@interface NSTask (InitializerAdditions)

+ (NSTask *)taskWithLaunchPath:(NSString *)launchPath
					 arguments:(NSArray *)arguments
				standardOutput:(id)standardOutput
			  workingDirectory:(NSString *)workingDirectory;

+ (NSTask *)launchedTaskWithLaunchPath:(NSString *)launchPath
							 arguments:(NSArray *)arguments
						standardOutput:(id)standardOutput
					  workingDirectory:(NSString *)workingDirectory;

+ (NSString *)errorMessageForLaunchPath:(NSString *)launchPath;

@end

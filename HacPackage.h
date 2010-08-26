#import <Cocoa/Cocoa.h>

@protocol HacPackageDelegate <NSObject>

- (void)setStatusMessage:(NSString *)newMessage;
- (void)extractionFailedWithError:(NSString *)errorMessage;
- (void)extractionSucceded;

@end


@interface HacPackage : NSObject
{
	NSObject <HacPackageDelegate> *delegate;

	NSString *packagePath;
	NSString *destinationDirectory;

	BOOL extractionFailed;
}

- (id <HacPackageDelegate>)delegate;
- (void)setDelegate:(id <HacPackageDelegate>)newDelegate;

- (NSString *)packagePath;
- (void)setPackagePath:(NSString *)value;

- (NSString *)payloadDirectory;

- (BOOL)extract;
- (void)beginExtraction;

- (void)cleanUp;

@end

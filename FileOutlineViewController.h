#import <Cocoa/Cocoa.h>

#import "FileOutlineView.h"

@interface FileOutlineViewController : NSObject
{
	NSString *payloadDirectory;
	NSArray *selectedBasePaths;

	IBOutlet FileOutlineView *outlineView;
}

- (NSString *)payloadDirectory;
- (void)setPayloadDirectory:(NSString *)value;

- (NSArray *)selectedBasePaths;

@end

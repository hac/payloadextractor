#import "HacHelpController.h"

@implementation HacHelpController

#pragma mark -
#pragma mark User Help

- (void)openCompanyURL:(id)sender
{
	NSString *homePageURL = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Company URL"];
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:homePageURL]];
}

- (void)openAppURL:(id)sender
{
	NSString *homePageURL = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Application URL"];
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:homePageURL]];
}

@end

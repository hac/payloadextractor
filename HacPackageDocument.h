#import <Cocoa/Cocoa.h>

#import "FileOutlineViewController.h"
#import "FileOutlineView.h"

#import "HacFileDialogManager.h"

#import "HacPackage.h"

@interface HacPackageDocument : NSDocument <HacPackageDelegate>
{
	IBOutlet FileOutlineViewController *outlineViewController;
	IBOutlet FileOutlineView *outlineView;
	
	IBOutlet NSToolbarItem *extractToolbarItem, *extractToDesktopToolbarItem;
	IBOutlet HacFileDialogManager *dialogManager;

	IBOutlet NSTextField *progressLabel;
	IBOutlet NSProgressIndicator *progressIndicator;
	IBOutlet NSWindow *documentWindow;
	IBOutlet NSWindow *progressWindow;

	HacPackage *package;
}


- (IBAction)extractSelectedFiles:(id)sender;
- (IBAction)extractSelectedFilesToDesktop:(id)sender;

- (void)showLoadingSheet;
- (void)hideLoadingSheet;

@end

#import <Cocoa/Cocoa.h>

@interface FileOutlineView : NSOutlineView
{
}

- (NSArray *)selectedItems;
- (NSArray *)selectedBasePaths;

@end

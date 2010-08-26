//
// This class is based on FSBrowserCell by Chuck Pisula.
// Some parts Copyright (c) 2001-2004, Apple Computer, Inc., all rights reserved.
//

#import "FileOutlineViewCell.h"

#define ICON_INSET_VERT		1.0	/* The size of empty space between the icon end the top/bottom of the cell */
#define ICON_SIZE 		16.0	/* Our Icons are ICON_SIZE x ICON_SIZE */
#define ICON_INSET_HORIZ	4.0	/* Distance to inset the icon from the left edge. */
#define ICON_TEXT_SPACING	4.0	/* Distance between the end of the icon and the text part */

@implementation FileOutlineViewCell

- (NSImage *)image
// Prevent the superclass from drawing the icon. We will draw in this class.
{
	return nil;
}

- (void)setImage:(NSImage *)image
{
	[image setSize:NSMakeSize(ICON_SIZE,ICON_SIZE)];
	[super setImage:image];
}

- (NSSize)cellSizeForBounds:(NSRect)aRect
{
    // Make our cells a bit higher than normal to give some additional space for the icon to fit.
    NSSize theSize = [super cellSizeForBounds:aRect];
    theSize.width += [[super image] size].width + ICON_INSET_HORIZ + ICON_INSET_HORIZ;
    theSize.height = ICON_SIZE + ICON_INSET_VERT * 2.0;
    return theSize;
}

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
	NSImage *iconImage = [super image];

    if (!iconImage)
		// At least draw something if we couldn't find an icon.
	{
		[super drawInteriorWithFrame:cellFrame inView:controlView];
		return;
	}

	NSSize	imageSize = [iconImage size];
	NSRect	imageFrame, textFrame;

	// Divide the cell into 2 parts, the image part (on the left) and the text part.
	NSDivideRect(cellFrame, &imageFrame, &textFrame, ICON_INSET_HORIZ + ICON_TEXT_SPACING + imageSize.width, NSMinXEdge);

	imageFrame.origin.x += ICON_INSET_HORIZ;
	imageFrame.size = imageSize;

	// Adjust the icon to be one pixel higher like in the Finder;
	imageFrame.origin.y--;

	// Adjust the image frame top account for the fact that we may or may not be in a flipped control view, since when compositing
	// the online documentation states: "The image will have the orientation of the base coordinate system, regardless of the destination coordinates".
	if ([controlView isFlipped])
	{
		imageFrame.origin.y += ceil((textFrame.size.height + imageFrame.size.height) / 2);
	}
	else
	{
		imageFrame.origin.y += ceil((textFrame.size.height - imageFrame.size.height) / 2);
	}

	// Blit the image.
	[iconImage compositeToPoint:imageFrame.origin operation:NSCompositeSourceOver];

	// Have NSBrowser kindly draw the text part, since it knows how to do that for us, no need to re-invent what it knows how to do.
	[super drawInteriorWithFrame:textFrame inView:controlView];
}

@end


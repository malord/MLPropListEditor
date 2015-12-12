#import "MyDocument.h"
#import "../MLPropListController.h"

@implementation MyDocument

- (id)init
{
	if (self = [super init], ! self)
		return nil;

	return self;
}

- (NSString *)windowNibName
{
    return @"MyDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];

	propListController = [[MLPropListController alloc] init];

	NSView *propListView = [propListController parentView];

	[parentViewForPropList addSubview:propListView];
	[parentViewForPropList setNextKeyView:propListView];
	[propListView setFrame:[parentViewForPropList bounds]];
}

@end

#import <Cocoa/Cocoa.h>

@class MLPropListController;

@interface MyDocument : NSDocument {
	IBOutlet NSView *parentViewForPropList;

	MLPropListController *propListController;
}

@end

#import "MLPropListItem.h"
#import "MLPropListControllerDelegate.h"

@interface MLPropListController : NSObject {
	IBOutlet NSView *parentView;
	IBOutlet NSOutlineView *outlineView;
	
	IBOutlet NSButtonCell *booleanCell;
	IBOutlet NSTextFieldCell *integerCell;
	IBOutlet NSTextFieldCell *realCell;
	IBOutlet NSTextFieldCell *stringCell;
	IBOutlet NSTextFieldCell *dateTimeCell;
	IBOutlet NSTextFieldCell *blankCell;
	IBOutlet NSTextFieldCell *readOnlyStringCell;
	
	NSWindow *windowForSheets;
	
	MLPropListItem *root;
	
	id delegate;
}

- (id)init;

- (void)setWindowForSheets:(NSWindow *)aWindow;

- (NSView *)parentView;

- (MLPropListItem *)root;

- (void)reload;

- (void)setDelegate:(id)aDelegate;

- (id)delegate;

- (IBAction)add:(id)sender;

- (IBAction)delete:(id)sender;

@end

#import "MLPropListController.h"

// Private methods.
@interface MLPropListController ()

- (void)addItemAsChildOfItem:(MLPropListItem *)parent atIndex:(NSInteger)parentIndex;

@end

//
// MLPropListController implementation
//

@implementation MLPropListController

- (id)init
{
	if (self = [super init], ! self)
		return nil;

	if (! [NSBundle loadNibNamed:@"MLPropListEditor" owner:self]) {
		[self release];
		return nil;
	}
	
	root = [[MLPropListItem alloc] init];
	[root setEmptyDictionaryValue];
	
	[root addItem:[[[MLPropListItem alloc] initWithStringValue:@"Hello, world!" name:@"Greeting"] autorelease]];
	
	MLPropListItem *array = [[[MLPropListItem alloc] initWithEmptyArrayValueWithName:@"An Array"] autorelease];
	[array addItem:[[[MLPropListItem alloc] initWithStringValue:@"First!" name:nil] autorelease]];
	[array addItem:[[[MLPropListItem alloc] initWithStringValue:@"Second!" name:nil] autorelease]];
	[array addItem:[[[MLPropListItem alloc] initWithStringValue:@"Third!" name:nil] autorelease]];
	[array addItem:[[[MLPropListItem alloc] initWithStringValue:@"Forth!" name:nil] autorelease]];
	
	MLPropListItem *dict = [[[MLPropListItem alloc] initWithEmptyDictionaryValueWithName:@"Options"] autorelease];
	[dict addItem:[[[MLPropListItem alloc] initWithIntegerValue:47 name:@"An Integer"] autorelease]];
	[dict addItem:[[[MLPropListItem alloc] initWithRealValue:47.1234 name:@"A Real"] autorelease]];
	[dict addItem:[[[MLPropListItem alloc] initWithBooleanValue:YES name:@"A Boolean"] autorelease]];
	[dict addItem:[[[MLPropListItem alloc] initWithDataStringValue:@"Hello\\!" name:@"A Data"] autorelease]];
	[dict addItem:[[[MLPropListItem alloc] initWithDateTimeValue:[NSDate date] name:@"A Date/Time"] autorelease]];
	
	[dict addItem:array];
	
	[root addItem:dict];
	
	return self;
}

- (void)dealloc
{
	[root release];
	[parentView release];
	
	[super dealloc];
}

- (void)setDelegate:(id)aDelegate
{
	delegate = aDelegate;
}

- (id)delegate
{
	return delegate;
}

- (MLPropListItem *)root
{
	return root;
}

- (void)reload
{
	[outlineView reloadData];
}

- (void)setWindowForSheets:(NSWindow *)aWindow
{
	windowForSheets = aWindow;
}

- (NSView *)parentView
{
	return parentView;
}

- (void)awakeFromNib
{
	// TODO: register for drag and drop
    // [outlineView registerForDraggedTypes:[NSArray arrayWithObject:SIMPLE_BPOARD_TYPE]];
    // [outlineView setDraggingSourceOperationMask:NSDragOperationEvery forLocal:YES];
    // [outlineView setDraggingSourceOperationMask:NSDragOperationEvery forLocal:NO];
}

- (void)outlineViewSelectionDidChange:(NSNotification *)aNotification
{
}

- (void)outlineViewItemDidCollapse:(NSNotification *)aNotification
{
}

- (NSInteger)outlineView:(NSOutlineView *)anOutlineView numberOfChildrenOfItem:(id)item
{
	if (! item)
		item = root;
		
	return [item itemCount];
}

- (id)outlineView:(NSOutlineView *)anOutlineView child:(NSInteger)anIndex ofItem:(id)item
{
	if (! item)
		item = root;
		
	return [(MLPropListItem *) item itemAtIndex:anIndex];
}

- (BOOL)outlineView:(NSOutlineView *)anOutlineView isItemExpandable:(id)item
{
	return [(MLPropListItem *) item canHaveItems];
}

- (NSCell *)outlineView:(NSOutlineView *)anOutlineView dataCellForTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
	NSInteger row = [anOutlineView rowForItem:item];

	MLPropListItem *propListItem = item;
	
	if ([[tableColumn identifier] isEqualToString:@"Value"]) {
		switch ([propListItem type]) {
			case MLBooleanPropListType:
				return booleanCell;
				
			case MLIntegerPropListType:
				return integerCell;
				
			case MLRealPropListType:
				return realCell;
				
			case MLStringPropListType:
				return stringCell;
				
			case MLDataPropListType:
				return stringCell;
				
			case MLDateTimePropListType:
				return dateTimeCell;
				
			case MLNullPropListType:
			case MLArrayPropListType:
			case MLDictionaryPropListType: 
				return blankCell;
		}
	}
	
	if ([[tableColumn identifier] isEqualToString:@"Name"]) {
		if ([propListItem parent] && [[propListItem parent] type] == MLArrayPropListType)
			return readOnlyStringCell;
		else
			return stringCell;
	}
	
	return [tableColumn dataCellForRow:row];
}

- (id)outlineView:(NSOutlineView *)anOutlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
	MLPropListItem *propListItem = item;
	
	if ([[tableColumn identifier] isEqualToString:@"Type"])
		return [NSNumber numberWithInt:[propListItem type]];
		
	if ([[tableColumn identifier] isEqualToString:@"Name"]) {
		// Don't display a name if the item is in an array. The placeholder text for the cell will be set to the
		// element index.
		if ([propListItem parent] && [[propListItem parent] type] == MLArrayPropListType)
			return nil;
			
		return [propListItem name];
	}
		
	if ([[tableColumn identifier] isEqualToString:@"Value"]) {
		if ([propListItem canHaveItems])
			return @"";
			
		return [propListItem value];
	}
		
	return nil;
}

- (void)outlineView:(NSOutlineView *)anOutlineView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
	MLPropListItem *propListItem = item;
	
	if ([[tableColumn identifier] isEqualToString:@"Value"]) {	
		switch ([propListItem type]) {
			case MLBooleanPropListType:
				[propListItem setBooleanValue:[object boolValue]];
				break;
			
			case MLIntegerPropListType:
				[propListItem setIntegerValue:[object longLongValue]];
				break;
			
			case MLRealPropListType:
				[propListItem setRealValue:[object doubleValue]];
				break;
			
			case MLDateTimePropListType:
				[propListItem setDateTimeValue:object];
				break;
			
			case MLStringPropListType:
				[propListItem setStringValue:object];
				break;
			
			case MLDataPropListType:
				[propListItem setDataStringValue:object];
				break;
			
			case MLNullPropListType:
			case MLArrayPropListType:
			case MLDictionaryPropListType:
				return;
		}
		
		if ([delegate respondsToSelector:@selector(propListController:didChangeValueOfItem:)])
			[delegate propListController:self didChangeValueOfItem:propListItem];
		
		return;
	}
	
	if ([[tableColumn identifier] isEqualToString:@"Type"]) {
		[propListItem convertToType:(MLPropListType) [object intValue]];
		[anOutlineView reloadData];
		
		if ([delegate respondsToSelector:@selector(propListController:didChangeTypeOfItem:)])
			[delegate propListController:self didChangeTypeOfItem:propListItem];

		return;
	}
	
	if ([[tableColumn identifier] isEqualToString:@"Name"]) {
		NSString *oldName = [[propListItem name] copy];
		
		[propListItem setName:[object description]];

		if ([delegate respondsToSelector:@selector(propListController:didChangeNameOfItem:oldName:)])
			[delegate propListController:self didChangeNameOfItem:propListItem oldName:oldName];
			
		[oldName release];			
		return;
	}
}

- (BOOL)outlineView:(NSOutlineView *)anOutlineView writeItems:(NSArray *)items toPasteboard:(NSPasteboard *)pboard
{
	// TODO
	return NO;
}

- (NSDragOperation)outlineView:(NSOutlineView *)anOutlineView validateDrop:(id <NSDraggingInfo>)info proposedItem:(id)item proposedChildIndex:(NSInteger)childIndex
{
	// TODO
	return NSDragOperationNone;
}

- (BOOL)outlineView:(NSOutlineView *)anOutlineView acceptDrop:(id <NSDraggingInfo>)info item:(id)item childIndex:(NSInteger)childIndex
{
	// TODO
	return NO;
}

- (void)outlineView:(NSOutlineView *)anOutlineView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
	MLPropListItem *propListItem = item;
	
	if ([[tableColumn identifier] isEqualToString:@"Value"]) {
		if ([cell respondsToSelector:@selector(setPlaceholderString:)]) {
			if ([propListItem canHaveItems])
				[cell setPlaceholderString:[NSString stringWithFormat:@"%lu item%@", (unsigned long int)[propListItem itemCount], [propListItem itemCount] == 1 ? @"" : @"s"]];
			else
				[cell setPlaceholderString:nil];
		}
	}

	if ([[tableColumn identifier] isEqualToString:@"Name"]) {
		if ([cell respondsToSelector:@selector(setPlaceholderString:)]) 
			[cell setPlaceholderString:[NSString stringWithFormat:@"%lu", (long int) ([propListItem parentIndex] + 1)]];
	}
}

- (IBAction)add:(id)sender
{
	NSInteger row = [outlineView selectedRow];
	
	if (row < 0) {
		[self addItemAsChildOfItem:root atIndex:-1];
		return;
	}
	
	MLPropListItem *selectedItem = [outlineView itemAtRow:row];
	if (selectedItem == root)
		return;
	
	if ([selectedItem canHaveItems] && [outlineView isItemExpanded:selectedItem]) {
		[self addItemAsChildOfItem:selectedItem atIndex:0];
		return;
	}
	
	[self addItemAsChildOfItem:[selectedItem parent] atIndex:[selectedItem parentIndex] + 1];
}

- (void)addItemAsChildOfItem:(MLPropListItem *)parent atIndex:(NSInteger)parentIndex
{
	if (parentIndex < 0)
		parentIndex = [parent itemCount];
		
	MLPropListItem *newItem = [[MLPropListItem alloc] init];
	[newItem setStringValue:@""];
	
	if ([parent type] != MLArrayPropListType) {
		// Need a name
		for (int i = 1; ; ++i) {
			NSString *name = [NSString stringWithFormat:@"Property %d", i];
			if (! [parent findItemWithName:name]) {
				[newItem setName:name];
				break;
			}
		}
	}
	
	[parent insertItem:newItem atIndex:parentIndex];
	
	[outlineView reloadData];
	
	NSInteger row = [outlineView rowForItem:newItem];
	
	if (row >= 0) {	
		[outlineView selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];

		[outlineView editColumn:[outlineView columnWithIdentifier:@"Name"] row:row withEvent:nil select:YES];
	}
	
	if ([delegate respondsToSelector:@selector(propListController:didInsertItem:)])
		[delegate propListController:self didInsertItem:newItem];

	[newItem release];
}

- (IBAction)delete:(id)sender
{
	NSIndexSet *indexes = [outlineView selectedRowIndexes];
	NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:[indexes count]];
	for (NSUInteger i = [indexes firstIndex]; i != NSNotFound; i = [indexes indexGreaterThanIndex:i]) {
		MLPropListItem *item = [outlineView itemAtRow:i];
		if (item == root)
			continue;
		
		MLPropListItem *parent;
		for (parent = [item parent]; parent; parent = [parent parent]) {
			if ([items containsObject:parent]) 
				break;
		}
		
		if (! parent)
			[items addObject:item];
	}	
	
	for (MLPropListItem *item in items) {
		[item removeFromParent];

		if ([delegate respondsToSelector:@selector(propListController:didRemoveItem:)]) 
			[delegate propListController:self didRemoveItem:item];
	}

	[outlineView reloadData];
	
	// This is optional.
	[outlineView selectRowIndexes:[NSIndexSet indexSet] byExtendingSelection:NO];
		
	[items release];
}

@end

#import "MLPropListItem.h"

@class MLPropListController;

@interface NSObject (MLPropListControllerDelegateInformalProtocol)

- (void)propListController:(MLPropListController *)aController didChangeValueOfItem:(MLPropListItem *)anItem;

- (void)propListController:(MLPropListController *)aController didChangeTypeOfItem:(MLPropListItem *)anItem;

- (void)propListController:(MLPropListController *)aController didChangeNameOfItem:(MLPropListItem *)anItem oldName:(NSString *)oldName;

- (void)propListController:(MLPropListController *)aController didInsertItem:(MLPropListItem *)anItem;

/// This method will be called repeatedly for each item immediately after it has been removed from its parent
/// (so that [anItem parentIndex] is correct). If multiple items are removed, this method will be invoked for
/// each item in turn. The delegate must take care to not perform any other modifications to the property list
/// while items are being removed.
- (void)propListController:(MLPropListController *)aController didRemoveItem:(MLPropListItem *)anItem;

@end

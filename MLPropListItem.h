#import <Cocoa/Cocoa.h>

typedef enum MLPropListType {
	MLNullPropListType,
	MLBooleanPropListType,
	MLIntegerPropListType,
	MLRealPropListType,
	MLStringPropListType,
	MLDataPropListType,
	MLDateTimePropListType,
	MLArrayPropListType,
	MLDictionaryPropListType,
} MLPropListType;

typedef intmax_t MLPropListInteger;
typedef double MLPropListReal;

@interface MLPropListItem : NSObject <NSCopying> {
	MLPropListItem *parent;
	NSInteger parentIndex;
	NSString *name;
	MLPropListType type;
	id value;
};

- (id)init;

- (id)initWithName:(NSString *)aName;

- (id)initWithBooleanValue:(BOOL)aValue name:(NSString *)aName;

- (id)initWithIntegerValue:(MLPropListInteger)aValue name:(NSString *)aName;

- (id)initWithIntegerNumberValue:(NSNumber *)aValue name:(NSString *)aName;

- (id)initWithRealValue:(MLPropListReal)aValue name:(NSString *)aName;

- (id)initWithRealNumberValue:(NSNumber *)aValue name:(NSString *)aName;

- (id)initWithStringValue:(NSString *)aValue name:(NSString *)aName;

- (id)initWithDataStringValue:(NSString *)aValue name:(NSString *)aName;

- (id)initWithDateTimeValue:(NSDate *)aValue name:(NSString *)aName;

- (id)initWithEmptyArrayValueWithName:(NSString *)aName;

- (id)initWithEmptyDictionaryValueWithName:(NSString *)aName;

- (MLPropListItem *)parent;

- (NSInteger)parentIndex;

- (MLPropListType)type;

- (id)value;

- (NSString *)name;

- (NSString *)nameOrIndexString;

- (void)setName:(NSString *)aName;

- (void)setNullValue;

- (void)setBooleanValue:(BOOL)newValue;

- (void)setIntegerValue:(MLPropListInteger)newValue;

- (void)setIntegerNumberValue:(NSNumber *)newNumber;

- (void)setRealValue:(MLPropListReal)newValue;

- (void)setRealNumberValue:(NSNumber *)newNumber;

- (void)setStringValue:(NSString *)newValue;

- (void)setDataStringValue:(NSString *)newValue;

- (void)setDateTimeValue:(NSDate *)newValue;

- (void)setEmptyArrayValue;

- (void)setEmptyDictionaryValue;

- (void)addItem:(MLPropListItem *)anItem;

- (void)insertItem:(MLPropListItem *)anItem atIndex:(NSInteger)anIndex;

- (NSInteger)itemCount;

- (BOOL)canHaveItems;

- (MLPropListItem *)itemAtIndex:(NSInteger)index;

- (MLPropListItem *)findItemWithName:(NSString *)aName;

- (id)value;

- (void)convertToType:(MLPropListType)newType;

/// Moves all the child items of anItem and makes them our own, leaving anItem with no child items.
- (void)moveItemsFromItem:(MLPropListItem *)anItem;

- (void)removeFromParent;

- (BOOL)isEqualToItem:(MLPropListItem *)anItem;

/// Searches our child items for one which exactly matches anItem and returns it, or nil. Does not remove the item.
- (MLPropListItem *)findEqualItem:(MLPropListItem *)anItem;

/// Returns an NSArray containing the path to this item (pointers to all this item's descendants, then a pointer to
/// this item).
- (NSArray *)path;

@end

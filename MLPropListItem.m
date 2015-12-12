#import "MLPropListItem.h"

@interface MLPropListItem ()

- (void)removeAllItems;

- (void)setParent:(MLPropListItem *)aParent index:(NSInteger)anIndex;

- (void)removeItem:(MLPropListItem *)anItem;

@end

@implementation MLPropListItem

- (id)init
{
	if (self = [super init], ! self)
		return nil;
		
	return self;
}

- (id)initWithName:(NSString *)aName
{
	if (self = [self init], ! self)
		return nil;
		
	name = [aName copy];
	return self;
}

- (void)dealloc
{
	[self removeAllItems];
	
	[name release];
	[value release];
	
	[super dealloc];
}

- (void)removeAllItems
{
	if ([self canHaveItems]) {
		for (MLPropListItem *item in (NSMutableDictionary *) value)
			[item setParent:nil index:0];
			
		[value release];
		value = nil;
	}
}

- (id)initWithBooleanValue:(BOOL)aValue name:(NSString *)aName
{
	if (self = [self initWithName:aName], ! self)
		return nil;
		
	[self setBooleanValue:aValue];
	return self;
}

- (id)initWithIntegerValue:(MLPropListInteger)aValue name:(NSString *)aName
{
	if (self = [self initWithName:aName], ! self)
		return nil;
		
	[self setIntegerValue:aValue];
	return self;
}

- (id)initWithIntegerNumberValue:(NSNumber *)aValue name:(NSString *)aName
{
	if (self = [self initWithName:aName], ! self)
		return nil;
		
	[self setIntegerNumberValue:aValue];
	return self;
}

- (id)initWithRealValue:(MLPropListReal)aValue name:(NSString *)aName
{
	if (self = [self initWithName:aName], ! self)
		return nil;
		
	[self setRealValue:aValue];
	return self;
}

- (id)initWithRealNumberValue:(NSNumber *)aValue name:(NSString *)aName
{
	if (self = [self initWithName:aName], ! self)
		return nil;
		
	[self setRealNumberValue:aValue];
	return self;
}

- (id)initWithStringValue:(NSString *)aValue name:(NSString *)aName
{
	if (self = [self initWithName:aName], ! self)
		return nil;
		
	[self setStringValue:aValue];
	return self;
}

- (id)initWithDataStringValue:(NSString *)aValue name:(NSString *)aName
{
	if (self = [self initWithName:aName], ! self)
		return nil;
		
	[self setDataStringValue:aValue];
	return self;
}

- (id)initWithDateTimeValue:(NSDate *)aValue name:(NSString *)aName
{
	if (self = [self initWithName:aName], ! self)
		return nil;
		
	[self setDateTimeValue:aValue];
	return self;
}

- (id)initWithEmptyArrayValueWithName:(NSString *)aName
{
	if (self = [self initWithName:aName], ! self)
		return nil;
		
	[self setEmptyArrayValue];
	return self;
}

- (id)initWithEmptyDictionaryValueWithName:(NSString *)aName
{
	if (self = [self initWithName:aName], ! self)
		return nil;
		
	[self setEmptyDictionaryValue];
	return self;
}

- (void)setParent:(MLPropListItem *)aParent index:(NSInteger)anIndex
{
	parent = aParent;
	parentIndex = anIndex;
}

- (MLPropListItem *)parent
{
	return parent;
}

- (NSInteger)parentIndex
{
	return parentIndex;
}

- (MLPropListType)type
{
	return type;
}

- (id)value
{
	return value;
}

- (NSString *)name
{
	return name;
}

- (NSString *)nameOrIndexString
{
	return name ? name : [NSString stringWithFormat:@"%ld", (long int) parentIndex];
}

- (void)setType:(MLPropListType)newType
{
	type = newType;
	
	[value autorelease]; // autorelease in case it's being used as our new value
	value = nil;
}

- (void)setName:(NSString *)aName
{
	if (name != aName) {
		aName = [aName copy];
		[name release];
		name = aName;
	}
}

- (void)setNullValue
{
	[self setType:MLNullPropListType];
}

- (void)setBooleanValue:(BOOL)newValue
{
	[self setType:MLBooleanPropListType];
	value = [[NSNumber alloc] initWithBool:newValue];
}

- (void)setIntegerValue:(MLPropListInteger)newValue
{
	[self setType:MLIntegerPropListType];
	value = [[NSNumber alloc] initWithLongLong:newValue];
}

- (void)setIntegerNumberValue:(NSNumber *)newNumber
{
	[self setType:MLIntegerPropListType];
	value = [newNumber copy];
}

- (void)setRealValue:(MLPropListReal)newValue
{
	[self setType:MLRealPropListType];
	value = [[NSNumber alloc] initWithDouble:newValue];
}

- (void)setRealNumberValue:(NSNumber *)newNumber
{
	[self setType:MLRealPropListType];
	value = [newNumber copy];
}

- (void)setStringValue:(NSString *)newValue
{
	[self setType:MLStringPropListType];
	value = [newValue copy];
}

- (void)setDataStringValue:(NSString *)newValue
{
	[self setType:MLDataPropListType];
	value = [newValue copy];
}

- (void)setDateTimeValue:(NSDate *)newValue
{
	[self setType:MLDateTimePropListType];
	value = [newValue copy];
}

- (void)setEmptyArrayValue
{
	[self setType:MLArrayPropListType];
}

- (void)setEmptyDictionaryValue
{
	[self setType:MLDictionaryPropListType];
}

- (void)addItem:(MLPropListItem *)anItem
{
	NSAssert([self canHaveItems], @"item cannot have child items.");
	// NSAssert([anItem parent] == nil, @"item cannot be in two property lists."); // need to check object is still in other item's array
	
	if (! value)
		value = [[NSMutableArray alloc] initWithCapacity:10];
	
	[(NSMutableArray *) value addObject:anItem];
	
	[anItem setParent:self index:[(NSMutableArray *) value count] - 1];
}

- (void)insertItem:(MLPropListItem *)anItem atIndex:(NSInteger)anIndex
{
	if (! value)
		value = [[NSMutableArray alloc] initWithCapacity:10];
		
	NSMutableArray *array = value;

	[array insertObject:anItem atIndex:anIndex];
	
	NSInteger count = [array count];
	for (NSInteger i = anIndex; i != count; ++i)
		[(MLPropListItem *) [array objectAtIndex:i] setParent:self index:i];
}

- (NSArray *)path
{
	NSMutableArray *path = [[[NSMutableArray alloc] initWithCapacity:10] autorelease];
	
	for (MLPropListItem *item = self; [item parent]; item = [item parent]) 
		[path insertObject:item atIndex:0];
		
	return path;
}

- (BOOL)canHaveItems
{
	return type == MLArrayPropListType || type == MLDictionaryPropListType;
}

- (NSInteger)itemCount
{
	if ([self canHaveItems])
		return [(NSMutableArray *) value count];
		
	return 0;
}

- (MLPropListItem *)itemAtIndex:(NSInteger)anIndex
{
	NSAssert([self canHaveItems], @"item cannot have child items.");
	
	return [(NSMutableArray *) value objectAtIndex:(NSUInteger) anIndex];
}

- (void)convertToType:(MLPropListType)newType
{
	switch (newType) {
		case MLNullPropListType:
			[self setType:MLNullPropListType];
			break;
		case MLBooleanPropListType:
			if ([value respondsToSelector:@selector(boolValue)])
				[self setBooleanValue:[value boolValue]];
			else
				[self setBooleanValue:NO];
			break;
		case MLIntegerPropListType:
			if ([value respondsToSelector:@selector(longLongValue)])
				[self setIntegerValue:[value longLongValue]];
			else
				[self setIntegerValue:0];
			break;
		case MLRealPropListType:
			if ([value respondsToSelector:@selector(doubleValue)])
				[self setRealValue:[value doubleValue]];
			else
				[self setRealValue:0];
			break;
		case MLDateTimePropListType:
			if (type != newType)
				[self setDateTimeValue:[NSDate date]];
			break;
		case MLStringPropListType:
			if ([value respondsToSelector:@selector(stringValue)])
				[self setStringValue:[value stringValue]];
			else if ([value respondsToSelector:@selector(UTF8String)]) // crap test for a string
				[self setStringValue:value];
			else
				[self setStringValue:@""];
			break;
		case MLDataPropListType:
			if ([value respondsToSelector:@selector(stringValue)])
				[self setDataStringValue:[value stringValue]];
			else if ([value respondsToSelector:@selector(UTF8String)]) // crap test for a string
				[self setDataStringValue:value];
			else
				[self setDataStringValue:@""];
			break;
		case MLArrayPropListType:
			// dictionary -> array would make some sense.
			[self setType:MLArrayPropListType];
			break;
		case MLDictionaryPropListType:
			// array -> dictionary would make some sense.
			[self setType:MLDictionaryPropListType];
			break;
	}
}

- (void)moveItemsFromItem:(MLPropListItem *)anItem
{
	NSAssert([anItem canHaveItems], @"source item does not have child items.");
	
	if (anItem == self)
		return;
	
	[self removeAllItems];
	
	type = anItem->type;

	value = anItem->value;
	anItem->value = nil;

	for (MLPropListItem *child in (NSMutableArray *) value) 
		child->parent = self;
}

- (id)copyWithZone:(NSZone *)aZone
{
	MLPropListItem *copy = [[MLPropListItem allocWithZone:aZone] init];
	
	[copy setName:name];
	[copy setType:type];
	copy->value = [value copy];
	
	return copy;
}

- (MLPropListItem *)findItemWithName:(NSString *)aName
{
	NSAssert([self canHaveItems], @"item does not have child items.");
	
	// TODO: consider a lookup table

	for (MLPropListItem *child in (NSMutableArray *) value) {
		if ([[child name] isEqualToString:aName])
			return child;
	}
	
	return nil;
}

- (void)removeItem:(MLPropListItem *)anItem
{
	if (! [self canHaveItems])
		return;
	
	if ([anItem parent] != self)
		return;
		
	NSMutableArray *array = value;
	NSInteger itemIndex = [anItem parentIndex];
	
	if ([array count] <= (NSUInteger) itemIndex || [array objectAtIndex:itemIndex] != anItem)
		return;
	
	[array removeObjectAtIndex:itemIndex];

	NSInteger count = [array count];
	for (NSInteger i = itemIndex; i != count; ++i)
		[(MLPropListItem *) [array objectAtIndex:i] setParent:self index:i];
}

- (void)removeFromParent
{
	[parent removeItem:self];
}

- (MLPropListItem *)findEqualItem:(MLPropListItem *)anItem
{
	if (! [self canHaveItems])
		return nil;
	
	NSMutableArray *array = value;
	for (MLPropListItem *child in array) {
		if ([anItem isEqualToItem:child])
			return child;
	}
	
	return nil;
}

- (BOOL)isEqualToItem:(MLPropListItem *)anItem
{
	if (type != anItem->type)
		return NO;
		
	if (! [name isEqualToString:anItem->name])
		return NO;
	
	switch (type) {
		case MLNullPropListType:
			break;
			
		case MLBooleanPropListType:
			return ([value boolValue] ? 1 : 0) == ([anItem->value boolValue] ? 1: 0);
			
		case MLIntegerPropListType:
			return [value longLongValue] == [anItem->value longLongValue];
			
		case MLRealPropListType:
			return [value doubleValue] == [anItem->value doubleValue];
			
		case MLDateTimePropListType:
			return [value isEqualToDate:anItem->value];
			
		case MLStringPropListType:
			return [value isEqualToString:anItem->value];

		case MLDataPropListType:
			return [value isEqualToString:anItem->value];

		case MLArrayPropListType: 
		case MLDictionaryPropListType: {
			NSArray *ourArray = value;
			NSArray *theirArray = anItem->value;
			
			if ([ourArray count] != [theirArray count])
				return NO;
				
			NSUInteger count = [ourArray count];				
			for (NSUInteger i = 0; i != count; ++i) {
				if (! [(MLPropListItem *) [ourArray objectAtIndex:i] isEqualToItem:[theirArray objectAtIndex:i]])
					return NO;
			}
			
			return YES;
		}
	}
	
	return YES;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"MLPropListItem \"%@\"", name ? name : @"(nil)"];
}

@end

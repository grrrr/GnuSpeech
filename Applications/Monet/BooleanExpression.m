#import "BooleanExpression.h"

#import <Foundation/Foundation.h>
#import "NSObject-Extensions.h"

@implementation BooleanExpression

- (id)init;
{
    if ([super init] == nil)
        return nil;

    operation = NO_OP;
    expressions = [[NSMutableArray alloc] initWithCapacity:4];

    return self;
}

- (void)dealloc;
{
    [expressions release];

    [super dealloc];
}

- (int)operation;
{
    return operation;
}

- (void)setOperation:(int)newOperation;
{
    operation = newOperation;
}

- (void)addSubExpression:(BooleanExpression *)newExpression;
{
    [expressions addObject:newExpression];
}

- (BooleanExpression *)operandOne;
{
    if  ([expressions count] > 0)
        return [expressions objectAtIndex:0];

    return nil;
}

- (BooleanExpression *)operandTwo;
{
    if  ([expressions count] > 1)
        return [expressions objectAtIndex:1];

    return nil;
}

- (NSString *)opString;
{
    switch (operation) {
      default:
      case NO_OP: return @"";
      case NOT_OP: return @" not ";
      case OR_OP: return @" or ";
      case AND_OP: return @" and ";
      case XOR_OP: return @" xor ";
    }

    return @"";
}

//
// Methods common to "BooleanNode" -- for both BooleanExpress, BooleanTerminal
//

- (int)evaluate:(CategoryList *)categories;
{
    switch (operation) {
      case NOT_OP:
          return ![[self operandOne] evaluate:categories];
          break;

      case AND_OP:
          if (![[self operandOne] evaluate:categories]) return 0;
          return [[self operandTwo] evaluate:categories];
          break;

      case OR_OP:
          if ([[self operandOne] evaluate:categories]) return 1;
          return [[self operandTwo] evaluate:categories];
          break;

      case XOR_OP:
          return ([[self operandOne] evaluate:categories] ^ [[self operandTwo] evaluate:categories]);
          break;

      default: return 1;
    }

    return 0;
}

- (void)optimize;
{
}

- (void)optimizeSubExpressions;
{
    int count, index;

    count = [expressions count];
    for (index = 0; index < count; index++)
        [[expressions objectAtIndex:index] optimizeSubExpressions];

    [self optimize];
}

- (int)maxExpressionLevels;
{
    int count, index;
    int max = 0;
    int temp;

    count = [expressions count];
    for (index = 0; index < count; index++) {
        temp = [[expressions objectAtIndex:index] maxExpressionLevels];
        if (temp > max)
            max = temp;
    }

    return max + 1;
}

- (NSString *)expressionString;
{
    NSMutableString *resultString;

    resultString = [NSMutableString string];
    [self expressionString:resultString];

    return resultString;
}

- (void)expressionString:(NSMutableString *)resultString;
{
    NSString *opString;

    opString = [self opString];

    [resultString appendString:@"("];

    if (operation == NOT_OP) {
        [resultString appendString:@"not "];
        if ([expressions count] > 0)
            [[expressions objectAtIndex:0] expressionString:resultString];
    } else {
        int count, index;

        count = [expressions count];
        for (index = 0; index < count; index++) {
            if (index != 0)
                [resultString appendString:opString];
            [[expressions objectAtIndex:index] expressionString:resultString];
	}
    }

    [resultString appendString:@")"];
}

- (BOOL)isCategoryUsed:aCategory;
{
    int count, index;

    count = [expressions count];
    for (index = 0; index < count; index++) {
        if ([[expressions objectAtIndex:index] isCategoryUsed:aCategory])
            return YES;
    }

    return NO;
}

//
// Archiving
//

- (id)initWithCoder:(NSCoder *)aDecoder;
{
    unsigned archivedVersion;
    int numExpressions, maxExpressions;
    int i;

    if ([super initWithCoder:aDecoder] == nil)
        return nil;

    //NSLog(@"[%p]<%@>  > %s", self, NSStringFromClass([self class]), _cmd);
    archivedVersion = [aDecoder versionForClassName:NSStringFromClass([self class])];
    //NSLog(@"aDecoder version for class %@ is: %u", NSStringFromClass([self class]), archivedVersion);

    [aDecoder decodeValuesOfObjCTypes:"iii", &operation, &numExpressions, &maxExpressions];
    //NSLog(@"operation: %d, numExpressions: %d, maxExpressions: %d", operation, numExpressions, maxExpressions);
    expressions = [[NSMutableArray alloc] init];

    for (i = 0; i < numExpressions; i++) {
        BooleanExpression *anExpression;

        anExpression = [aDecoder decodeObject];
        if (anExpression != nil)
            [self addSubExpression:anExpression];
    }

    //NSLog(@"[%p]<%@> <  %s", self, NSStringFromClass([self class]), _cmd);
    return self;
}

#ifdef PORTING
- (void)encodeWithCoder:(NSCoder *)aCoder;
{
    int i;

    [aCoder encodeValuesOfObjCTypes:"iii", &operation, &numExpressions, &maxExpressions];
    for (i = 0; i < numExpressions; i++)
        [aCoder encodeObject:expressions[i]];
}
#endif

- (NSString *)description;
{
    return [NSString stringWithFormat:@"<%@>[%p]: operation: %d, expressions: %@, expressionString: %@",
                     NSStringFromClass([self class]), self, operation, expressions, [self expressionString]];
}

@end

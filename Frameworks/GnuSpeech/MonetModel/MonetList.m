//  This file is part of Gnuspeech, an extensible, text-to-speech package, based on real-time, articulatory, speech-synthesis-by-rules. 
//  Copyright 1991-2012 David R. Hill, Leonard Manzara, Craig Schock

#import "MonetList.h"

#import "NSObject-Extensions.h"
#import "NSString-Extensions.h"

@implementation MonetList
{
    NSMutableArray *ilist;
}

- (id)init;
{
    if ((self = [super init])) {
        ilist = [[NSMutableArray alloc] init];
    }
    
    NSParameterAssert([self class] != [MonetList class]);
    
    return self;
}

- (void)dealloc;
{
    [ilist release];

    [super dealloc];
}

#pragma mark - Debugging

- (NSString *)description;
{
    return [ilist description];
}

#pragma mark -

@synthesize ilist;

- (void)appendXMLToString:(NSMutableString *)resultString elementName:(NSString *)elementName level:(NSUInteger)level;
{
    NSUInteger count = [self.ilist count];
    if (count > 0) {
        [resultString indentToLevel:level];
        [resultString appendFormat:@"<%@>\n", elementName];

        for (id object in self.ilist) {
            [object appendXMLToString:resultString level:level+1];
        }
        
        [resultString indentToLevel:level];
        [resultString appendFormat:@"</%@>\n", elementName];
    }
}

- (void)appendXMLForObjectPointersToString:(NSMutableString *)resultString elementName:(NSString *)elementName level:(NSUInteger)level;
{
    NSUInteger count = [self.ilist count];
    if (count > 0) {
        [resultString indentToLevel:level];
        [resultString appendFormat:@"<%@>\n", elementName];
        
        for (id object in self.ilist) {
            [resultString indentToLevel:level + 1];
            [resultString appendFormat:@"<object ptr=\"%p\" class=\"%@\"/>\n", object, NSStringFromClass([object class])];
        }
        
        [resultString indentToLevel:level];
        [resultString appendFormat:@"</%@>\n", elementName];
    }
}

@end

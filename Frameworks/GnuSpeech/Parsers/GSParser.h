//  This file is part of Gnuspeech, an extensible, text-to-speech package, based on real-time, articulatory, speech-synthesis-by-rules. 
//  Copyright 1991-2012 David R. Hill, Leonard Manzara, Craig Schock

#import <Foundation/Foundation.h>

extern NSString *GSParserSyntaxErrorException;

@interface GSParser : NSObject
{
    NSString *nonretained_parseString;
    NSScanner *scanner;
    NSString *symbolString;

    NSUInteger startOfTokenLocation;
    NSRange errorRange;
    NSMutableString *errorMessage;
}

- (id)init;
- (void)dealloc;

- (NSString *)symbolString;
- (void)setSymbolString:(NSString *)newString;

- (id)parseString:(NSString *)aString;
- (id)beginParseString;

// Error reporting
- (NSRange)errorRange;
- (NSString *)errorMessage;
- (void)appendErrorFormat:(NSString *)format, ...;

@end

//  This file is part of Gnuspeech, an extensible, text-to-speech package, based on real-time, articulatory, speech-synthesis-by-rules. 
//  Copyright 1991-2012 David R. Hill, Leonard Manzara, Craig Schock

#import <Foundation/Foundation.h>

@class EventList;

// TODO (2004-08-09): absoluteTime is derived from offsetTime and beatTime.  And beatTime is derived from ruleIndex and eventList.

@interface MMIntonationPoint : NSObject
{
    EventList *nonretained_eventList;

    double semitone; // Value of the point in semitones
    double offsetTime; // Points are timed wrt a beat + this offset
    double slope;  // Slope of point

    NSUInteger ruleIndex; // Index of the rule for the phone which is the focus of this point
}

- (id)init;

- (EventList *)eventList;
- (void)setEventList:(EventList *)newEventList;

- (double)semitone;
- (void)setSemitone:(double)newSemitone;

- (double)offsetTime;
- (void)setOffsetTime:(double)newOffsetTime;

- (double)slope;
- (void)setSlope:(double)newSlope;

- (NSInteger)ruleIndex;
- (void)setRuleIndex:(NSInteger)newRuleIndex;

- (double)absoluteTime;
- (double)beatTime;

- (double)semitoneInHertz;
- (void)setSemitoneInHertz:(double)newHertzValue;

- (void)incrementSemitone;
- (void)decrementSemitone;

- (void)incrementRuleIndex;
- (void)decrementRuleIndex;

- (NSComparisonResult)compareByAscendingAbsoluteTime:(MMIntonationPoint *)otherIntonationPoint;

// XML - Archiving
- (void)appendXMLToString:(NSMutableString *)resultString level:(NSUInteger)level;
- (id)initWithXMLAttributes:(NSDictionary *)attributes context:(id)context;
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict;
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName;

// Debugging
- (NSString *)description;

@end

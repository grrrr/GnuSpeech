#import "StringParser.h"

#include <sys/time.h>
#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#import "NSScanner-Extensions.h"

#import "AppController.h"
#import "EventList.h"
#import "EventListView.h"
#import "IntonationView.h"
#import "MModel.h"
#import "MMPosture.h"
#import "MMSynthesisParameters.h"
#import "PhoneList.h"
#include "driftGenerator.h"

@implementation StringParser

+ (NSCharacterSet *)gsStringParserWhitespaceCharacterSet;
{
    static NSCharacterSet *characterSet = nil;

    if (characterSet == nil) {
        NSMutableCharacterSet *aSet;

        aSet = [[NSCharacterSet whitespaceCharacterSet] mutableCopy];
        [aSet addCharactersInString:@"_"];
        characterSet = [aSet copy];

        [aSet release];
    }

    return characterSet;
}

+ (NSCharacterSet *)gsStringParserDefaultCharacterSet;
{
    static NSCharacterSet *characterSet = nil;

    if (characterSet == nil) {
        NSMutableCharacterSet *aSet;

        aSet = [[NSCharacterSet letterCharacterSet] mutableCopy];
        [aSet addCharactersInString:@"^'#"];
        characterSet = [aSet copy];

        [aSet release];
    }

    return characterSet;
}

- (id)init;
{
    if ([super init] == nil)
        return nil;

    eventList = [[EventList alloc] initWithCapacity:1000];
    NXNameObject(@"mainEventList", eventList, NSApp);

    return self;
}

- (void)dealloc;
{
    [eventList release];
    [model release];

    [super dealloc];
}

- (MModel *)model;
{
    return model;
}

- (void)setModel:(MModel *)newModel;
{
    if (newModel == model)
        return;

    [model release];
    model = [newModel retain];
}

- (void)parseStringButton:(id)sender;
{
    struct timeval tp1, tp2;
    struct timezone tzp;
    int i;
    float intonationParameters[5];

    NSLog(@" > %s", _cmd);

    //[self parseString:[stringTextField stringValue]];

    gettimeofday(&tp1, &tzp);

    [eventList setUp];

    [eventList setPitchMean:[[[self model] synthesisParameters] pitch]];
    [eventList setGlobalTempo:[tempoField doubleValue]];
    [eventList setShouldStoreParameters:[parametersStore state]];

    [eventList setShouldUseMacroIntonation:[[intonationMatrix cellAtRow:0 column:0] state]];
    [eventList setShouldUseMicroIntonation:[[intonationMatrix cellAtRow:1 column:0] state]];
    [eventList setShouldUseDrift:[[intonationMatrix cellAtRow:2 column:0] state]];
    setDriftGenerator([driftDeviationField floatValue], 500, [driftCutoffField floatValue]);

    [eventList setRadiusMultiply:[radiusMultiplyField doubleValue]];

    //[eventList setIntonation:[intonationFlag state]];
    for (i = 0; i < 5; i++)
        intonationParameters[i] = [[intonParmsField cellAtIndex:i] floatValue];
    [eventList setIntonParms:intonationParameters];

    [self parsePhoneString:[stringTextField stringValue]];

    [eventList generateEventList];

    if ([smoothIntonationSwitch state])
        [[intonationView documentView] applySmoothIntonation];
    else
        [[intonationView documentView] applyIntonation];

    [eventList setShouldUseSmoothIntonation:[smoothIntonationSwitch state]];

    gettimeofday(&tp2, &tzp);
    NSLog(@"%ld", (tp2.tv_sec*1000000 + tp2.tv_usec) - (tp1.tv_sec*1000000 + tp1.tv_usec));

    NSLog(@"\n***\n");
    [eventList printDataStructures];
#if 0
    for (i = 0; i < [eventList count]; i++) {
        printf("Time: %d  | ", [[eventList objectAt:i] time]);
        for (j = 0 ; j < 16; j++) {
            printf("%.3f ", [[eventList objectAt:i] getValueAtIndex:j]);
        }
        printf("\n");
    }
#endif

    if ([sender tag]) {
        NSLog(@"this case, trying to synthesize to file.");
        if ([[filenameField stringValue] length])
            [eventList synthesizeToFile:[filenameField stringValue]];
        else
            NSBeep();
    } else
        [eventList synthesizeToFile:nil];

    [eventList generateOutput];

    [eventListView setEventList:eventList];

    [[intonationView documentView] setEventList:eventList];

    [stringTextField selectText:self];

    NSLog(@"<  %s", _cmd);
}

- (void)synthesizeWithSoftware:(id)sender;
{
    unsigned int index;
    float intonationParameters[5];
    //char commandLine[256];

    NSLog(@" > %s", _cmd);
    //NSLog(@"eventList: %@", eventList);
    //[[NSApp delegate] generateXML:@"before software synthesis"];

    [[[self model] synthesisParameters] writeToFile:@"/tmp/Monet.parameters" includeComments:YES];

    [eventList setUp];
    [eventList setShouldUseSoftwareSynthesis:YES];

    [eventList setPitchMean:[[[self model] synthesisParameters] pitch]];
    [eventList setGlobalTempo:[tempoField doubleValue]];
    [eventList setShouldStoreParameters:[parametersStore state]];

    [eventList setShouldUseMacroIntonation:[[intonationMatrix cellAtRow:0 column:0] state]];
    [eventList setShouldUseMicroIntonation:[[intonationMatrix cellAtRow:1 column:0] state]];
    [eventList setShouldUseDrift:[[intonationMatrix cellAtRow:2 column:0] state]];
    setDriftGenerator([driftDeviationField floatValue], 500, [driftCutoffField floatValue]);

    [eventList setRadiusMultiply:[radiusMultiplyField doubleValue]];

    // TODO (2004-03-25): Should we set up the intonation parameters, like the hardware synthesis did?
#if 1
    //[eventList setIntonation:[intonationFlag state]];
    for (index = 0; index < 5; index++)
        intonationParameters[index] = [[intonParmsField cellAtIndex:index] floatValue];
    [eventList setIntonParms:intonationParameters];
#endif

    [self parsePhoneString:[stringTextField stringValue]];

    [eventList generateEventList];
#if 1
    NSLog(@"[smoothIntonationSwitch state]: %d", [smoothIntonationSwitch state]);
    if ([smoothIntonationSwitch state])
        [[intonationView documentView] applySmoothIntonation];
    else
        [[intonationView documentView] applyIntonation];

    [eventList setShouldUseSmoothIntonation:[smoothIntonationSwitch state]];
#else
    // TODO (2004-03-25): What about checking for smooth intonation, like the hardware synthesis did?
    [[intonationView documentView] applyIntonation];
#endif

    [eventList printDataStructures];
    [eventList generateOutput];

    [eventListView setEventList:eventList];
    [eventListView display]; // TODO (2004-03-17): It's not updating otherwise

    [[intonationView documentView] setEventList:eventList];

    [stringTextField selectText:self];

#if 0
    sprintf(commandLine,"/bin/tube /tmp/Monet.parameters %s\n", [[filenameField stringValue] cString]);
    system(commandLine);
    sprintf(commandLine,"sndplay %s\n", [[filenameField stringValue] cString]);
    system(commandLine);
#endif

    NSLog(@"<  %s", _cmd);
}

- (void)setUpDataStructures;
{
    [eventList setUp];

    [self parsePhoneString:[stringTextField stringValue]];

    [eventList generateEventList];

    [eventListView setEventList:eventList];

    [[intonationView documentView] setEventList:eventList];

    [stringTextField selectText:self];
}

- (void)automaticIntonation:(id)sender;
{
    float intonationParameters[5];
    int i;

    for (i = 0; i < 5; i++)
        intonationParameters[i] = [[intonParmsField cellAtIndex:i] floatValue];

    [eventList setIntonParms:intonationParameters];

    [eventList applyIntonation];
    [intonationView display];

    NSLog(@"contour:\n%@", [[intonationView documentView] contourString]);
}

- (void)parsePhoneString:(NSString *)str;
{
    MMPosture *aPhone;
    //int chunk = 0;
    int lastFoot = 0, markedFoot = 0;
    double footTempo = 1.0;
    double ruleTempo = 1.0;
    double phoneTempo = 1.0;
    double aDouble;
    PhoneList *mainPhoneList;
    NSScanner *scanner;
    NSCharacterSet *whitespaceCharacterSet = [StringParser gsStringParserWhitespaceCharacterSet];
    NSCharacterSet *defaultCharacterSet = [StringParser gsStringParserDefaultCharacterSet]; // I know, it's not a great name.
    NSString *buffer;

    NSLog(@" > %s", _cmd);

    mainPhoneList = [[self model] postures];
    NSLog(@"mainPhoneList: %p", mainPhoneList);

    aPhone = [mainPhoneList findPhone:@"^"];
    [eventList newPhoneWithObject:aPhone];

    scanner = [[[NSScanner alloc] initWithString:str] autorelease];
    [scanner setCharactersToBeSkipped:nil];

    while ([scanner isAtEnd] == NO) {
        [scanner scanCharactersFromSet:whitespaceCharacterSet intoString:NULL];
        if ([scanner isAtEnd] == YES)
            break;

        if ([scanner scanString:@"/" intoString:NULL] == YES) {
            /* Handle "/" escape sequences */
            if ([scanner scanString:@"0" intoString:NULL] == YES) {
                /* Tone group 0. Statement */
                NSLog(@"Tone group 0. Statement");
                [eventList setCurrentToneGroupType:STATEMENT];
            } else if ([scanner scanString:@"1" intoString:NULL] == YES) {
                /* Tone group 1. Exclaimation */
                NSLog(@"Tone group 1. Exclaimation");
                [eventList setCurrentToneGroupType:EXCLAIMATION];
            } else if ([scanner scanString:@"2" intoString:NULL] == YES) {
                /* Tone group 2. Question */
                NSLog(@"Tone group 2. Question");
                [eventList setCurrentToneGroupType:QUESTION];
            } else if ([scanner scanString:@"3" intoString:NULL] == YES) {
                /* Tone group 3. Continuation */
                NSLog(@"Tone group 3. Continuation");
                [eventList setCurrentToneGroupType:CONTINUATION];
            } else if ([scanner scanString:@"4" intoString:NULL] == YES) {
                /* Tone group 4. Semi-colon */
                NSLog(@"Tone group 4. Semi-colon");
                [eventList setCurrentToneGroupType:SEMICOLON];
            } else if ([scanner scanString:@" " intoString:NULL] == YES || [scanner scanString:@"_" intoString:NULL] == YES) {
                /* New foot */
                NSLog(@"New foot");
                [eventList newFoot];
                if (lastFoot)
                    [eventList setCurrentFootLast];
                footTempo = 1.0;
                lastFoot = 0;
                markedFoot = 0;
            } else if ([scanner scanString:@"*" intoString:NULL] == YES) {
                /* New Marked foot */
                NSLog(@"New Marked foot");
                [eventList newFoot];
                [eventList setCurrentFootMarked];
                if (lastFoot)
                    [eventList setCurrentFootLast];

                footTempo = 1.0;
                lastFoot = 0;
                markedFoot = 1;
            } else if ([scanner scanString:@"/" intoString:NULL] == YES) {
                /* New Tone Group */
                NSLog(@"New Tone Group");
                [eventList newToneGroup];
            } else if ([scanner scanString:@"c" intoString:NULL] == YES) {
                /* New Chunk */
                NSLog(@"New Chunk -- not sure that this is working.");
#ifdef PORTING
                if (chunk) {
                    //aPhone = [mainPhoneList findPhone:"#"];
                    //[eventList newPhoneWithObject:aPhone];
                    //aPhone = [mainPhoneList findPhone:"^"];
                    //[eventList newPhoneWithObject:aPhone];
                    index--;
                    return index;
                } else {
                    chunk++;
                    index++;
                }
#endif
            } else if ([scanner scanString:@"l" intoString:NULL] == YES) {
                /* Last Foot in tone group marker */
                NSLog(@"Last Foot in tone group");
                lastFoot = 1;
            } else if ([scanner scanString:@"f" intoString:NULL] == YES) {
                /* Foot tempo indicator */
                NSLog(@"Foot tempo indicator - 'f'");
                [scanner scanCharactersFromSet:whitespaceCharacterSet intoString:NULL];
                if ([scanner scanDouble:&aDouble] == YES) {
                    NSLog(@"current foot tempo: %g", aDouble);
                    [eventList setCurrentFootTempo:aDouble];
                }
            } else if ([scanner scanString:@"r" intoString:NULL] == YES) {
                /* Foot tempo indicator */
                NSLog(@"Foot tempo indicator - 'r'");
                [scanner scanCharactersFromSet:whitespaceCharacterSet intoString:NULL];
                if ([scanner scanDouble:&aDouble] == YES) {
                    NSLog(@"ruleTemp = %g", aDouble);
                    ruleTempo = aDouble;
                }
            } else {
                // Skip character
                [scanner scanCharacter:NULL];
            }
        } else if ([scanner scanString:@"." intoString:NULL] == YES) {
            /* Syllable Marker */
            NSLog(@"Syllable Marker");
            [eventList setCurrentPhoneSyllable];
        } else if ([scanner scanDouble:&aDouble] == YES) {
            // TODO (2004-03-05): The original scanned digits and '.', and then used atof.
            NSLog(@"phoneTempo = %g", aDouble);
            phoneTempo = aDouble;
        } else {
            if ([scanner scanCharactersFromSet:defaultCharacterSet intoString:&buffer] == YES) {
                NSLog(@"Scanned this: '%@'", buffer);
                if (markedFoot)
                    buffer = [buffer stringByAppendingString:@"'"];
                aPhone = [mainPhoneList findPhone:buffer];
                NSLog(@"aPhone: %p, eventList: %p", aPhone, eventList);
                if (aPhone) {
                    [eventList newPhoneWithObject:aPhone];
                    [eventList setCurrentPhoneTempo:phoneTempo];
                    [eventList setCurrentPhoneRuleTempo:(float)ruleTempo];
                }
                phoneTempo = 1.0;
                ruleTempo = 1.0;
            } else {
                break;
            }
        }
    }

    NSLog(@"<  %s", _cmd);
}

@end

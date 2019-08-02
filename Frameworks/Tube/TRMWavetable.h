//  This file is part of Gnuspeech, an extensible, text-to-speech package, based on real-time, articulatory, speech-synthesis-by-rules. 
//  Copyright 1991-2012 David R. Hill, Leonard Manzara, Craig Schock

#import <Foundation/Foundation.h>

#import "TRMInputParameters.h" // For TRMWaveFormType
#import "TRMFIRFilter.h"

@interface TRMWavetable : NSObject
{
    TRMFIRFilter *_FIRFilter;
    double *_wavetable;
    
    int32_t _tableDiv1;
    int32_t _tableDiv2;
    double _tnLength;
    double _tnDelta;
    
    double _basicIncrement;
    double _currentPosition;
}

- (id)initWithWaveform:(unsigned long)waveForm throttlePulse:(double)tp tnMin:(double)tnMin tnMax:(double)tnMax sampleRate:(double)sampleRate;

- (void)update:(double)amplitude;
- (double)oscillator:(double)frequency;

@end

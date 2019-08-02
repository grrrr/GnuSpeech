//  This file is part of Gnuspeech, an extensible, text-to-speech package, based on real-time, articulatory, speech-synthesis-by-rules. 
//  Copyright 1991-2012 David R. Hill, Leonard Manzara, Craig Schock

#import <Foundation/Foundation.h>
#import "TRMRingBuffer.h"

// Sample Rate Conversion Constants
#define ZERO_CROSSINGS            13                           // Source cutoff frequency
#define LP_CUTOFF                 (11.0/13.0)                  // 0.846 of Nyquist

#define N_BITS                    16
#define L_BITS                    8
#define L_RANGE                   256                          // must be 2^L_BITS
#define M_BITS                    8
#define M_RANGE                   256                          // must be 2^M_BITS
#define FRACTION_BITS             (L_BITS + M_BITS)
#define FRACTION_RANGE            65536                        // must be 2^FRACTION_BITS
#define FILTER_LENGTH             (ZERO_CROSSINGS * L_RANGE)
#define FILTER_LIMIT              (FILTER_LENGTH - 1)

#define N_MASK                    0xFFFF0000
#define L_MASK                    0x0000FF00
#define M_MASK                    0x000000FF
#define FRACTION_MASK             0x0000FFFF

#define nValue(x)                 (((x) & N_MASK) >> FRACTION_BITS)
#define lValue(x)                 (((x) & L_MASK) >> M_BITS)
#define mValue(x)                 ((x) & M_MASK)
#define fractionValue(x)          ((x) & FRACTION_MASK)

#define OUTPUT_SRATE_LOW          22050.0
#define OUTPUT_SRATE_HIGH         44100.0

#define BETA                      5.658        // Kaiser window parameters

@interface TRMSampleRateConverter : NSObject
{
    double _sampleRateRatio;
    double _h[FILTER_LENGTH];
    double _deltaH[FILTER_LENGTH];
    uint32_t _timeRegisterIncrement;
    uint32_t _filterIncrement;
    uint32_t _phaseIncrement;
    uint32_t _timeRegister;
    
    // Temporary sample storage values
    double _maximumSampleValue;
    int32_t _numberSamples;
    NSOutputStream *_outputStream;
    
    TRMRingBuffer *_ringBuffer;
}

- (id)initWithInputRate:(double)inputRate outputRate:(double)outputRate;

- (void)dataFill:(double)data;
- (void)flush;

@property (assign) double maximumSampleValue;
@property (assign) int32_t numberSamples;

// The samples are doubles
@property (nonatomic, readonly) NSData *resampledData;

@end

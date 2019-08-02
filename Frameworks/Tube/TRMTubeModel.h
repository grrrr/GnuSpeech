//  This file is part of Gnuspeech, an extensible, text-to-speech package, based on real-time, articulatory, speech-synthesis-by-rules. 
//  Copyright 1991-2012 David R. Hill, Leonard Manzara, Craig Schock

#import <Foundation/Foundation.h>

#import "TRMParameters.h"
#import "TRMTubeModel.h"
#import "TRMUtility.h"
#import "TRMFilters.h"
#import "TRMSampleRateConverter.h"
#import "TRMWavetable.h"


@class TRMDataList;

@interface TRMTubeModel : NSObject
{
    // Derived values
    int32_t _controlPeriod;
    int32_t _sampleRate;
    double _actualTubeLength;            // actual length in cm
    
    double _dampingFactor;             // calculated damping factor
    double _crossmixFactor;              // calculated crossmix factor
    
    double _breathinessFactor;
    
    TRMNoiseGenerator _noiseGenerator;
    TRMLowPassFilter2 _noiseFilter;             // One-zero lowpass filter.
    
    // Mouth reflection filter: Is a variable, one-pole lowpass filter,            whose cutoff       is determined by the mouth aperture coefficient.
    // Mouth radiation filter:  Is a variable, one-zero, one-pole highpass filter, whose cutoff point is determined by the mouth aperture coefficient.
    TRMRadiationReflectionFilter _mouthFilterPair;
    
    // Nasal reflection filter: Is a one-pole lowpass filter,            used for terminating the end of            the nasal cavity.
    // Nasal radiation filter:  Is a one-zero, one-pole highpass filter, used for the radiation characteristic from the nasal cavity.
    TRMRadiationReflectionFilter _nasalFilterPair;
    
    TRMLowPassFilter _throatLowPassFilter;      // Simulates the radiation of sound through the walls of the throat.
    double _throatGain;
    
    TRMBandPassFilter _fricationBandPassFilter; // Frication bandpass filter, with variable center frequency and bandwidth.
    
    // Memory for tue and tube coefficients
    double _oropharynx[TOTAL_SECTIONS][2][2];
    double _oropharynx_coeff[TOTAL_COEFFICIENTS];
    
    double _nasal[TOTAL_NASAL_SECTIONS][2][2];
    double _nasal_coeff[TOTAL_NASAL_COEFFICIENTS];
    
    double _alpha[TOTAL_ALPHA_COEFFICIENTS];
    NSUInteger _currentIndex;
    NSUInteger _previousIndex;
    
    // Memory for frication taps
    double _fricationTap[TOTAL_FRIC_COEFFICIENTS];
    
    // Variables for interpolation
    TRMParameters *_currentParameters;
    TRMParameters *_currentDelta;
    TRMParameters *_previousParameters;

    TRMSampleRateConverter *_sampleRateConverter;
    NSInputStream *_inputStream;
    
    TRMWavetable *_wavetable;
    
    TRMDataList *_inputData;
    int _inputPosition;
    
    BOOL _verbose;
}

@property (readonly) TRMDataList *inputData;
@property (nonatomic, readonly) TRMInputParameters *inputParameters;
@property (readonly) TRMSampleRateConverter *sampleRateConverter;

- (id)initWithInputData:(TRMDataList *)inputData;

- (void)synthesize;
- (BOOL)saveOutputToFile:(NSString *)filename error:(NSError **)error;

- (void)printInputData;

- (NSData *)generateWAVData;

@end

//  This file is part of Gnuspeech, an extensible, text-to-speech package, based on real-time, articulatory, speech-synthesis-by-rules. 
//  Copyright 1991-2012 David R. Hill, Leonard Manzara, Craig Schock

#import "TRMInputParameters.h"

#import "TRMTubeModel.h"

#pragma mark - TRMSoundFileFormat

NSString *TRMSoundFileFormatDescription(TRMSoundFileFormat format)
{
    switch (format) {
        case TRMSoundFileFormat_AU:   return @"AU";
        case TRMSoundFileFormat_AIFF: return @"AIFF";
        case TRMSoundFileFormat_WAVE: return @"WAVE";
    }
    
    return @"Unknown";
}

NSString *TRMSoundFileFormatExtension(TRMSoundFileFormat format)
{
    switch (format) {
        case TRMSoundFileFormat_AU:   return @"au";
        case TRMSoundFileFormat_AIFF: return @"aiff";
        case TRMSoundFileFormat_WAVE: return @"wav";
    }
    
    return @"Unknown";
}

#pragma mark - TRMWaveFormType

NSString *TRMWaveFormTypeDescription(TRMWaveFormType type)
{
    switch (type) {
        case TRMWaveFormType_Pulse: return @"Pulse";
        case TRMWaveFormType_Sine:  return @"Sine";
    }
    
    return @"Unknown";
}

#pragma mark -

@implementation TRMInputParameters

@synthesize outputFileFormat = _outputFileFormat; // file format
@synthesize outputRate = _outputRate;                    // output sample rate (22.05, 44.1 KHz)
@synthesize controlRate = _controlRate;                   // 1.0-1000.0 input tables/second (Hz)

@synthesize volume = _volume;                       // master volume (0 - 60 dB)
@synthesize channels = _channels;                 // # of sound output channels (1, 2)
@synthesize balance = _balance;                      // stereo balance (-1 to +1)

@synthesize waveform = _waveform;            // GS waveform type
@synthesize tp = _tp;                           // % glottal pulse rise time
@synthesize tnMin = _tnMin;                        // % glottal pulse fall time minimum
@synthesize tnMax = _tnMax;                        // % glottal pulse fall time maximum
@synthesize breathiness = _breathiness;                  // % glottal source breathiness

@synthesize length = _length;                       // nominal tube length (10 - 20 cm)
@synthesize temperature = _temperature;                  // tube temperature (25 - 40 C)
@synthesize lossFactor = _lossFactor;                   // junction loss factor in (0 - 5 %)

@synthesize apScale = _apScale;                      // aperture scl. radius (3.05 - 12 cm)
@synthesize mouthCoef = _mouthCoef;                    // mouth aperture coefficient
@synthesize noseCoef = _noseCoef;                     // nose aperture coefficient

@synthesize throatCutoff = _throatCutoff;                 // throat lp cutoff (50 - nyquist Hz)
@synthesize throatVol = _throatVol;                    // throat volume (0 - 48 dB)

@synthesize usesModulation = _usesModulation;                 // pulse mod. of noise
@synthesize mixOffset = _mixOffset;                    // noise crossmix offset (30 - 60 dB)

- (double *)noseRadius;
{
    return _noseRadius;
}

@end

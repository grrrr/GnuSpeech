//  This file is part of Gnuspeech, an extensible, text-to-speech package, based on real-time, articulatory, speech-synthesis-by-rules. 
//  Copyright 1991-2012 David R. Hill, Leonard Manzara, Craig Schock

#import "TRMSampleRateConverter.h"
#import "TRMUtility.h"

@interface TRMSampleRateConverter () <TRMRingBufferDelegate>

@property (assign) double sampleRateRatio;
@property (assign) uint32_t timeRegisterIncrement;
@property (assign) uint32_t filterIncrement;
@property (assign) uint32_t phaseIncrement;
@property (assign) uint32_t timeRegister;

@end

#pragma mark -

@implementation TRMSampleRateConverter

@synthesize maximumSampleValue = _maximumSampleValue;
@synthesize numberSamples = _numberSamples;

@synthesize sampleRateRatio = _sampleRateRatio;
@synthesize timeRegisterIncrement = _timeRegisterIncrement;
@synthesize filterIncrement = _filterIncrement;
@synthesize phaseIncrement = _phaseIncrement;
@synthesize timeRegister = _timeRegister;

- (id)initWithInputRate:(double)inputRate outputRate:(double)outputRate;
{
    if ((self = [super init])) {
        _timeRegister = 0;
        _maximumSampleValue = 0.0;
        _numberSamples = 0;
        
        // Initialize filter impulse response
        [self _initializeFilter];
        
        // Calculate sample rate ratio
        _sampleRateRatio = outputRate / inputRate;
        
        // Calculate time register increment
        _timeRegisterIncrement = (int)rint(pow(2.0, FRACTION_BITS) / _sampleRateRatio);
        
        // Calculate rounded sample rate ratio
        double roundedSampleRateRatio = pow(2.0, FRACTION_BITS) / (double)_timeRegisterIncrement;
        
        // Calculate phase or filter increment
        if (_sampleRateRatio >= 1.0) {
            _filterIncrement = L_RANGE;
        } else {
            _phaseIncrement = (uint32_t)rint(_sampleRateRatio * (double)FRACTION_RANGE);
        }
        
        // Calculate pad size
        int32_t padSize = (_sampleRateRatio >= 1.0) ? ZERO_CROSSINGS : (int32_t)((float)ZERO_CROSSINGS / roundedSampleRateRatio) + 1;
        
        _ringBuffer = [[TRMRingBuffer alloc] initWithPadSize:padSize];
        _ringBuffer.delegate = self;
        
        _outputStream = [[NSOutputStream alloc] initToMemory];
        [_outputStream open];
    }

    return self;
}

// Initializes filter impulse response and impulse delta values.

- (void)_initializeFilter;
{
    // Initialize the filter impulse response
    _h[0] = LP_CUTOFF;
    double x = M_PI / (double)L_RANGE;
    for (NSUInteger index = 1; index < FILTER_LENGTH; index++) {
        double y = (double)index * x;
        _h[index] = sin(y * LP_CUTOFF) / y;
    }
    
    // Apply a Kaiser window to the impulse response
    double IBeta = 1.0 / Izero(BETA);
    for (NSUInteger index = 0; index < FILTER_LENGTH; index++) {
        double temp = (double)index / FILTER_LENGTH;
        _h[index] *= Izero(BETA * sqrt(1.0 - (temp * temp))) * IBeta;
    }
    
    // Initialize the filter impulse response delta values
    for (NSUInteger index = 0; index < FILTER_LIMIT; index++)
        _deltaH[index] = _h[index+1] - _h[index];
    _deltaH[FILTER_LIMIT] = 0.0 - _h[FILTER_LIMIT];
}

- (void)dealloc;
{
    [_outputStream close];
}

#pragma mark -

- (double *)h;
{
    return _h;
}

- (double *)deltaH;
{
    return _deltaH;
}

#pragma mark - TRMRingBufferDelegate

// Converts available portion of the input signal to the new sampling
// rate, and outputs the samples to the sound struct.

- (void)processDataFromRingBuffer:(TRMRingBuffer *)ringBuffer;
{
    int32_t endPtr;
    
    // Calculate end pointer
    endPtr = ringBuffer.fillPtr - ringBuffer.padSize;
    
    // Adjust the end pointer, if less than zero
    if (endPtr < 0)
        endPtr += TRMRingBufferSize;
    
    // Adjust the endpoint, if less then the empty pointer
    if (endPtr < ringBuffer.emptyPtr)
        endPtr += TRMRingBufferSize;
    
    // Upsample loop (slightly more efficient than downsampling)
    if (_sampleRateRatio >= 1.0) {
        //printf("Upsampling...\n");
        while (ringBuffer.emptyPtr < endPtr) {
            int32_t index;
            uint32_t filterIndex;
            double output, interpolation, absoluteSampleValue;
            
            // Reset accumulator to zero
            output = 0.0;
            
            // Calculate interpolation value (static when upsampling)
            interpolation = (double)mValue(_timeRegister) / (double)M_RANGE;
            
            // Compute the left side of the filter convolution
            index = ringBuffer.emptyPtr;
            for (filterIndex = lValue(_timeRegister);
                 filterIndex < FILTER_LENGTH;
                 [TRMRingBuffer decrementIndex:&index], filterIndex += _filterIncrement) {
                output += ringBuffer.buffer[index] * (_h[filterIndex] + _deltaH[filterIndex] * interpolation);
            }
            
            // Adjust values for right side calculation
            _timeRegister = ~_timeRegister;
            interpolation = (double)mValue(_timeRegister) / (double)M_RANGE;
            
            // Compute the right side of the filter convolution
            index = ringBuffer.emptyPtr;
            [TRMRingBuffer incrementIndex:&index];
            for (filterIndex = lValue(_timeRegister);
                 filterIndex < FILTER_LENGTH;
                 [TRMRingBuffer incrementIndex:&index], filterIndex += _filterIncrement) {
                output += ringBuffer.buffer[index] * (_h[filterIndex] + _deltaH[filterIndex] * interpolation);
            }
            
            // Record maximum sample value
            absoluteSampleValue = fabs(output);
            if (absoluteSampleValue > _maximumSampleValue)
                _maximumSampleValue = absoluteSampleValue;
            
            // Increment sample number
            _numberSamples++;
            
            // Output the sample to the temporary data
            NSInteger result = [_outputStream write:(void *)&output maxLength:sizeof(output)];
            NSParameterAssert(result == sizeof(output));

            // Change time register back to original form
            _timeRegister = ~_timeRegister;
            
            // Increment the time register
            _timeRegister += _timeRegisterIncrement;
            
            // Increment the empty pointer, adjusting it and end pointer
            ringBuffer.emptyPtr += nValue(_timeRegister);
            
            if (ringBuffer.emptyPtr >= TRMRingBufferSize) {
                ringBuffer.emptyPtr -= TRMRingBufferSize;
                endPtr -= TRMRingBufferSize;
            }
            
            // Clear N part of time register
            _timeRegister &= (~N_MASK);
        }
    } else {
        //printf("Downsampling...\n");
        // Downsampling conversion loop
        while (ringBuffer.emptyPtr < endPtr) {
            int32_t index;
            uint32_t phaseIndex, impulseIndex;
            double absoluteSampleValue, output, impulse;
            
            // Reset accumulator to zero
            output = 0.0;
            
            // Compute P prime
            phaseIndex = (uint32_t)rint( ((double)fractionValue(_timeRegister)) * _sampleRateRatio);
            
            // Compute the left side of the filter convolution
            index = ringBuffer.emptyPtr;
            while ((impulseIndex = (phaseIndex >> M_BITS)) < FILTER_LENGTH) {
                impulse = _h[impulseIndex] + (_deltaH[impulseIndex] *
                                                        (((double)mValue(phaseIndex)) / (double)M_RANGE));
                output += (ringBuffer.buffer[index] * impulse);
                [TRMRingBuffer decrementIndex:&index];
                phaseIndex += _phaseIncrement;
            }
            
            // Compute P prime, adjusted for right side
            phaseIndex = (unsigned int)rint( ((double)fractionValue(~_timeRegister)) * _sampleRateRatio);
            
            // Compute the right side of the filter convolution
            index = ringBuffer.emptyPtr;
            [TRMRingBuffer incrementIndex:&index];
            while ((impulseIndex = (phaseIndex>>M_BITS)) < FILTER_LENGTH) {
                impulse = _h[impulseIndex] + (_deltaH[impulseIndex] *
                                                        (((double)mValue(phaseIndex)) / (double)M_RANGE));
                output += (ringBuffer.buffer[index] * impulse);
                [TRMRingBuffer incrementIndex:&index];
                phaseIndex += _phaseIncrement;
            }
            
            // Record maximum sample value
            absoluteSampleValue = fabs(output);
            if (absoluteSampleValue > _maximumSampleValue)
                _maximumSampleValue = absoluteSampleValue;
            
            // Increment sample number
            _numberSamples++;
            
            // Output the sample to the temporary data
            NSInteger result = [_outputStream write:(void *)&output maxLength:sizeof(output)];
            NSParameterAssert(result == sizeof(output));

            // Increment the time register
            _timeRegister += _timeRegisterIncrement;
            
            // Increment the empty pointer, adjusting it and end pointer
            ringBuffer.emptyPtr += nValue(_timeRegister);
            if (ringBuffer.emptyPtr >= TRMRingBufferSize) {
                ringBuffer.emptyPtr -= TRMRingBufferSize;
                endPtr -= TRMRingBufferSize;
            }
            
            // Clear N part of time register
            _timeRegister &= (~N_MASK);
        }
    }
}

#pragma mark -

- (void)dataFill:(double)data;
{
    [_ringBuffer dataFill:data];
}

- (void)flush;
{
    [_ringBuffer flush];
}

- (NSData *)resampledData;
{
    return [_outputStream propertyForKey:NSStreamDataWrittenToMemoryStreamKey];
}

@end

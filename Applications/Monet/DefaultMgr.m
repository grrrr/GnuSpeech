#import "DefaultMgr.h"

#import <Foundation/Foundation.h>
#import "NSUserDefaults-Extensions.h"
#import "MonetDefaults.h"

/*
	Revision Information
	_Author: fedor $
	_Date: 2002/12/15 05:05:09 $
	_Revision: 1.2 $
	_Source: /cvsroot/gnuspeech/gnuspeech/trillium/ObjectiveC/Monet/DefaultMgr.m,v $
	_State: Exp $
*/

/*===========================================================================

	File: DefaultMgr.m

	Purpose: All defaults database access/storage is handled in this
		file.

		This object provides two methods for each default database
		item.  One method sets the item and the other returns the
		current value of the item.

	NOTE: All default "#defines" are in file "MonetDefaults.h"

===========================================================================*/

#define MonetDefCount 22

static NSString *MonetDefVal[] = {
    MASTER_VOLUME_DEF,
    VOCAL_TRACT_LENGTH_DEF,
    TEMPERATURE_DEF,
    BALANCE_DEF,
    BREATHINESS_DEF,
    LOSS_FACTOR_DEF,
    THROAT_CUTTOFF_DEF,
    THROAT_VOLUME_DEF,
    APERTURE_SCALING_DEF,
    MOUTH_COEF_DEF,
    NOSE_COEF_DEF,
    MIX_OFFSET_DEF,
    N1_DEF,
    N2_DEF,
    N3_DEF,
    N4_DEF,
    N5_DEF,
    TP_DEF,
    TN_MIN_DEF,
    TN_MAX_DEF,
    GP_SHAPE_DEF,
    NOISE_MODULATION_DEF,
    nil
};

static NSString *MonetDefKeys[] = {
    MDK_MASTER_VOLUME,
    MDK_VOCAL_TRACT_LENGTH,
    MDK_TEMPERATURE,
    MDK_BALANCE,
    MDK_BREATHINESS,
    MDK_LOSS_FACTOR,
    MDK_THROAT_CUTTOFF,
    MDK_THROAT_VOLUME,
    MDK_APERTURE_SCALING,
    MDK_MOUTH_COEF,
    MDK_NOSE_COEF,
    MDK_MIX_OFFSET,
    MDK_N1,
    MDK_N2,
    MDK_N3,
    MDK_N4,
    MDK_N5,
    MDK_TP,
    MDK_TN_MIN,
    MDK_TN_MAX,
    MDK_GP_SHAPE,
    MDK_NOISE_MODULATION,
    nil
};

@implementation DefaultMgr

+ (void)initialize;
{
    NSDictionary *dict;

    dict = [NSDictionary dictionaryWithObjects:MonetDefVal
                         forKeys:MonetDefKeys
                         count:MonetDefCount];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dict];
}

- (void)updateDefaults;
{
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)writeDefaults;
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    int index;

    for (index = 0; index < MonetDefCount; index++)
        [def setObject:MonetDefVal[index] forKey:MonetDefKeys[index]];
}

- (double)masterVolume;
{
    return [[NSUserDefaults standardUserDefaults] doubleForKey:MDK_MASTER_VOLUME];
}

- (void)setMasterVolume:(double)value;
{
    [[NSUserDefaults standardUserDefaults] setDouble:value forKey:MDK_MASTER_VOLUME];
}

- (double)vocalTractLength;
{
    return [[NSUserDefaults standardUserDefaults] doubleForKey:MDK_VOCAL_TRACT_LENGTH];
}

- (void)setVocalTractLength:(double)value;
{
    [[NSUserDefaults standardUserDefaults] setDouble:value forKey:MDK_VOCAL_TRACT_LENGTH];
}

- (double)temperature;
{
    return [[NSUserDefaults standardUserDefaults] doubleForKey:MDK_TEMPERATURE];
}

- (void)setTemperature:(double)value;
{
    [[NSUserDefaults standardUserDefaults] setDouble:value forKey:MDK_TEMPERATURE];
}

- (double)balance;
{
    return [[NSUserDefaults standardUserDefaults] doubleForKey:MDK_BALANCE];
}

- (void)setBalance:(double)value;
{
    [[NSUserDefaults standardUserDefaults] setDouble:value forKey:MDK_BALANCE];
}

- (double)breathiness;
{
    return [[NSUserDefaults standardUserDefaults] doubleForKey:MDK_BREATHINESS];
}

- (void)setBreathiness:(double)value;
{
    [[NSUserDefaults standardUserDefaults] setDouble:value forKey:MDK_BREATHINESS];
}

- (double)lossFactor;
{
    return [[NSUserDefaults standardUserDefaults] doubleForKey:MDK_LOSS_FACTOR];
}

- (void)setLossFactor:(double)value;
{
    [[NSUserDefaults standardUserDefaults] setDouble:value forKey:MDK_LOSS_FACTOR];
}

- (double)throatCuttoff;
{
    return [[NSUserDefaults standardUserDefaults] doubleForKey:MDK_THROAT_CUTTOFF];
}

- (void)setThroatCuttoff:(double)value;
{
    [[NSUserDefaults standardUserDefaults] setDouble:value forKey:MDK_THROAT_CUTTOFF];
}

- (double)throatVolume;
{
    return [[NSUserDefaults standardUserDefaults] doubleForKey:MDK_THROAT_VOLUME];
}

- (void)setThroatVolume:(double)value;
{
    [[NSUserDefaults standardUserDefaults] setDouble:value forKey:MDK_THROAT_VOLUME];
}

- (double)apertureScaling;
{
    return [[NSUserDefaults standardUserDefaults] doubleForKey:MDK_APERTURE_SCALING];
}

- (void)setApertureScaling:(double)value;
{
    [[NSUserDefaults standardUserDefaults] setDouble:value forKey:MDK_APERTURE_SCALING];
}

- (double)mouthCoef;
{
    return [[NSUserDefaults standardUserDefaults] doubleForKey:MDK_MOUTH_COEF];
}

- (void)setMouthCoef:(double)value;
{
    [[NSUserDefaults standardUserDefaults] setDouble:value forKey:MDK_MOUTH_COEF];
}

- (double)noseCoef;
{
    return [[NSUserDefaults standardUserDefaults] doubleForKey:MDK_NOSE_COEF];
}

- (void)setNoseCoef:(double)value;
{
    [[NSUserDefaults standardUserDefaults] setDouble:value forKey:MDK_NOSE_COEF];
}

- (double)mixOffset;
{
    return [[NSUserDefaults standardUserDefaults] doubleForKey:MDK_MIX_OFFSET];
}

- (void)setMixOffset:(double)value;
{
    [[NSUserDefaults standardUserDefaults] setDouble:value forKey:MDK_MIX_OFFSET];
}

- (double)n1;
{
    return [[NSUserDefaults standardUserDefaults] doubleForKey:MDK_N1];
}

- (void)setn1:(double)value;
{
    [[NSUserDefaults standardUserDefaults] setDouble:value forKey:MDK_N1];
}

- (double)n2;
{
    return [[NSUserDefaults standardUserDefaults] doubleForKey:MDK_N2];
}

- (void)setn2:(double)value;
{
    [[NSUserDefaults standardUserDefaults] setDouble:value forKey:MDK_N2];
}

- (double)n3;
{
    return [[NSUserDefaults standardUserDefaults] doubleForKey:MDK_N3];
}

- (void)setn3:(double)value;
{
    [[NSUserDefaults standardUserDefaults] setDouble:value forKey:MDK_N3];
}

- (double)n4;
{
    return [[NSUserDefaults standardUserDefaults] doubleForKey:MDK_N4];
}

- (void)setn4:(double)value;
{
    [[NSUserDefaults standardUserDefaults] setDouble:value forKey:MDK_N4];
}

- (double)n5;
{
    return [[NSUserDefaults standardUserDefaults] doubleForKey:MDK_N5];
}

- (void)setn5:(double)value;
{
    [[NSUserDefaults standardUserDefaults] setDouble:value forKey:MDK_N5];
}

- (double)tp;
{
    return [[NSUserDefaults standardUserDefaults] doubleForKey:MDK_TP];
}

- (void)setTp:(double)value;
{
    [[NSUserDefaults standardUserDefaults] setDouble:value forKey:MDK_TP];
}

- (double)tnMin;
{
    return [[NSUserDefaults standardUserDefaults] doubleForKey:MDK_TN_MIN];
}

- (void)setTnMin:(double)value;
{
    [[NSUserDefaults standardUserDefaults] setDouble:value forKey:MDK_TN_MIN];
}

- (double)tnMax;
{
    return [[NSUserDefaults standardUserDefaults] doubleForKey:MDK_TN_MAX];
}

- (void)setTnMax:(double)value;
{
    [[NSUserDefaults standardUserDefaults] setDouble:value forKey:MDK_TN_MAX];
}

- (NSString *)glottalPulseShape;
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:MDK_GP_SHAPE];
}

- (void)setGlottalPulseShape:(NSString *)value;
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:MDK_GP_SHAPE];
}

- (NSString *)noiseModulation;
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:MDK_NOISE_MODULATION];
}

- (void)setNoiseModulation:(NSString *)value;
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:MDK_NOISE_MODULATION];
}

@end

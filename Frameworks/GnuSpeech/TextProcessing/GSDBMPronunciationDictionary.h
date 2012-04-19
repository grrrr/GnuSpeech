//  Copyright 1991-2009 David R. Hill, Leonard Manzara, Craig Schock

#import "GSPronunciationDictionary.h"
#include <fcntl.h>
#include <ndbm.h>

@class GSSimplePronunciationDictionary;

@interface GSDBMPronunciationDictionary : GSPronunciationDictionary
{
    DBM *db;
}

+ (NSString *)mainFilename;
+ (BOOL)createDatabase:(NSString *)aFilename fromSimpleDictionary:(GSSimplePronunciationDictionary *)simpleDictionary;

- (id)initWithFilename:(NSString *)aFilename;
- (void)dealloc;

- (NSDate *)modificationDate;
- (BOOL)loadDictionary;

- (NSString *)lookupPronunciationForWord:(NSString *)aWord;

@end

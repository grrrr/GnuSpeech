//  This file is part of Gnuspeech, an extensible, text-to-speech package, based on real-time, articulatory, speech-synthesis-by-rules.
//  Copyright 1991-2012 David R. Hill, Leonard Manzara, Craig Schock

#import "categories.h"
#import "template.h"

/*  GLOBAL VARIABLES, LOCAL TO THIS FILE  */
static int number_of_categories;


void readFromFileCategories(FILE *fp1)
{
    int i;
    char temp[SYMBOL_LENGTH_MAX+1];

    /*  READ CATEGORY SYMBOLS FROM FILE, DUMP INTO BIT BUCKET  */
    fread((char *)&number_of_categories,sizeof(number_of_categories),1,fp1);
    for (i = 0; i < number_of_categories; i++) {
        fread((char *)&temp,SYMBOL_LENGTH_MAX+1,1,fp1);
    }
}

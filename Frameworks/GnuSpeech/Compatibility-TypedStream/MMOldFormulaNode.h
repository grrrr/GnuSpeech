//  This file is part of Gnuspeech, an extensible, text-to-speech package, based on real-time, articulatory, speech-synthesis-by-rules. 
//  Copyright 1991-2009 David R. Hill, Leonard Manzara, Craig Schock

#import "MMFormulaNode.h"

@interface MMOldFormulaNode : MMFormulaNode
{
    int precedence;
}

- (int)precedence;
- (void)setPrecedence:(int)newPrecedence;

@end

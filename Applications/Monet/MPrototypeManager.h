//  This file is part of Gnuspeech, an extensible, text-to-speech package, based on real-time, articulatory, speech-synthesis-by-rules. 
//  Copyright 1991-2012 David R. Hill, Leonard Manzara, Craig Schock

#import "MWindowController.h"

@class MMEquation, MMFormulaParser, MModel, MMTransition;
@class SpecialView, TransitionView;

@interface MPrototypeManager : MWindowController <NSOutlineViewDataSource, NSOutlineViewDelegate>

- (id)initWithModel:(MModel *)aModel;

- (MModel *)model;
- (void)setModel:(MModel *)newModel;

- (NSUndoManager *)undoManager;

- (void)updateViews;
- (void)expandOutlines;
- (void)_updateEquationDetails;
- (void)_updateTransitionDetails;
- (void)_updateSpecialTransitionDetails;

- (MMEquation *)selectedEquation;
- (MMTransition *)selectedTransition;
- (MMTransition *)selectedSpecialTransition;

// Equations
- (IBAction)addEquationGroup:(id)sender;
- (IBAction)addEquation:(id)sender;
- (IBAction)removeEquation:(id)sender;
- (IBAction)setEquation:(id)sender;
- (IBAction)revertEquation:(id)sender;

// Transitions
- (IBAction)addTransitionGroup:(id)sender;
- (IBAction)addTransition:(id)sender;
- (IBAction)removeTransition:(id)sender;
- (IBAction)editTransition:(id)sender;


// Special Transitions
- (IBAction)addSpecialTransitionGroup:(id)sender;
- (IBAction)addSpecialTransition:(id)sender;
- (IBAction)removeSpecialTransition:(id)sender;
- (IBAction)editSpecialTransition:(id)sender;

// Equation usage caching
- (void)clearEquationUsageCache;
- (NSArray *)usageOfEquation:(MMEquation *)anEquation;
- (NSArray *)usageOfEquation:(MMEquation *)anEquation recache:(BOOL)shouldRecache;
- (BOOL)isEquationUsed:(MMEquation *)anEquation;

// Transition usage caching
- (void)clearTransitionUsageCache;
- (NSArray *)usageOfTransition:(MMTransition *)aTransition;
- (NSArray *)usageOfTransition:(MMTransition *)aTransition recache:(BOOL)shouldRecache;
- (BOOL)isTransitionUsed:(MMTransition *)aTransition;

- (IBAction)doubleHit:(id)sender;

@end

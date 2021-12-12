//
//  ORInstructions.h
//  oc2mango
//
//  Created by Jiang on 2021/12/7.
//  Copyright © 2021 SilverFruity. All rights reserved.
//

#ifndef ORInstructions_h
#define ORInstructions_h

// 64 bit
#pragma mark - Stack OP
#define PUSH
#define POP

#pragma mark - Integer Op
#define ADD
#define SUB
#define MULTI
#define DIV
#define MOD

#pragma mark - Double Op
#define D_ADD
#define D_SUB
#define D_MULTI
#define D_DIV

#pragma mark - Bit Op
#define BIT_AND
#define BIT_OR
#define BIT_NOT
#define SHIFT_LEFT
#define SHIFT_RIGTH

#pragma mark - Logic Op
#define LOGIC_AND
#define LOGIC_OR
#define LOGIC_NOT

#pragma mark - JUMP
#define JEQ
#define JNE
#define JGT
#define JLT
#define JGTE
#define JLTE
#define JMP

#pragma mark - Section
#define SECTION_POTINER
#define SECTION_LOCAL
#define SECTION_GLOBAL
#define SECTION_STATIC
#define SECTION_LINKED_CLASS
#define SECTION_LINKED_CFUNCTION

// write ivar and the ivar not defined in script
#define SECTOIN_IVARS
#define SECTION_UNKNOWN_IDENTIFIER

#pragma mark - Objc Method
#define SECTION_DYNAMIC_METHOD
#define SECTION_METHOD

#pragma mark - Procedure Call OP
#define START_PUSH_ARGS

#define CALL
#define OBJC_CALL

// call the unknown method, it's not defined in script
#define OBJC_CALL_UNKNOWN



#endif /* ORInstructions_h */

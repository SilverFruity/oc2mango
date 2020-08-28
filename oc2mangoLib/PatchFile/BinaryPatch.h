//  BinaryPatch.h
//  Generate By BinaryPatchGenerator
//  Created by Jiang on 1598646865
//  Copyright © 2020 SilverFruity. All rights reserved.

#import <Foundation/Foundation.h>
@class ORPatchFile;
#define _ORNodeFields \
uint64_t nodeType;\
uint64_t length;

#pragma pack(1)
#pragma pack(show)
typedef struct {
    _ORNodeFields
}_ORNode;

static uint64_t _ORNodeLength = 16;

typedef struct {
    _ORNodeFields
    uint64_t count;
    _ORNode **nodes;
}_ListNode;

typedef struct {
    _ORNodeFields
    uint64_t offset;
    uint64_t strLen;
}_StringNode;
static uint64_t _StringNodeLength = 16 + 16;

typedef struct {
    _ORNodeFields
    char *buffer;
    uint64_t cursor;
}_StringsNode;

typedef struct {
    _ORNodeFields
    _StringNode *appVersion;
    _StringNode *osVersion;
    _ListNode *nodes;
    _StringsNode *strings;
    BOOL enable;
}_PatchNode;
#pragma pack()
#pragma pack(show)

_PatchNode *_PatchNodeConvert(ORPatchFile *patch);
ORPatchFile *_PatchNodeDeConvert(_PatchNode *node);
//  BinaryPatchHelper.h
//  Generate By BinaryPatchGenerator
//  Created by Jiang on 1606095812
//  Copyright © 2020 SilverFruity. All rights reserved.

#import <Foundation/Foundation.h>
@class ORPatchFile;
#define _ORNodeFields \
uint8_t nodeType;\

#pragma pack(1)
#pragma pack(show)
typedef struct {
    _ORNodeFields
}_ORNode;

static uint32_t _ORNodeLength = 1;

typedef struct {
    _ORNodeFields
    uint32_t count;
    _ORNode **nodes;
}_ListNode;
static uint32_t _ListNodeBaseLength = 5;

typedef struct {
    _ORNodeFields
    uint32_t offset;
    uint32_t strLen;
}_StringNode;
static uint32_t _StringNodeBaseLength = 9;

typedef struct {
    _ORNodeFields
    uint32_t cursor;
    char *buffer;
}_StringsNode;
static uint32_t _StringsNodeBaseLength = 5;

typedef struct {
    _ORNodeFields
    BOOL enable;
    _StringsNode *strings;
    _StringNode *appVersion;
    _StringNode *osVersion;
    _ListNode *nodes;
}_PatchNode;
static uint32_t _PatchNodeBaseLength = 2;

#pragma pack()
#pragma pack(show)

_PatchNode *_PatchNodeConvert(ORPatchFile *patch, uint32_t *length);
ORPatchFile *_PatchNodeDeConvert(_PatchNode *node);
void _PatchNodeSerialization(_PatchNode *node, void *buffer, uint32_t *cursor);
_PatchNode *_PatchNodeDeserialization(void *buffer, uint32_t *cursor, uint32_t bufferLength);
void _PatchNodeDestroy(_PatchNode *node);
ORPatchFile *_PatchNodeGenerateCheckFile(void *buffer, uint32_t bufferLength);
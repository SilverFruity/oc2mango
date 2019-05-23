/* A Bison parser, made by GNU Bison 2.3.  */

/* Skeleton implementation for Bison's Yacc-like parsers in C

   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Bison version.  */
#define YYBISON_VERSION "2.3"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Using locations.  */
#define YYLSP_NEEDED 0



/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     TYPE = 258,
     VARIABLE = 259,
     IDENTIFIER = 260,
     STRING_LITERAL = 261,
     TYPEDEF = 262,
     IF = 263,
     ENDIF = 264,
     IFDEF = 265,
     IFNDEF = 266,
     UNDEF = 267,
     IMPORT = 268,
     INCLUDE = 269,
     TILDE = 270,
     QUESTION = 271,
     _return = 272,
     _break = 273,
     _continue = 274,
     _goto = 275,
     _else = 276,
     _while = 277,
     _do = 278,
     _in = 279,
     _for = 280,
     _case = 281,
     _switch = 282,
     _default = 283,
     _enum = 284,
     _typeof = 285,
     _struct = 286,
     _sizeof = 287,
     INTERFACE = 288,
     IMPLEMENTATION = 289,
     PROTOCOL = 290,
     END = 291,
     CLASS_DECLARE = 292,
     PROPERTY = 293,
     WEAK = 294,
     STRONG = 295,
     COPY = 296,
     ASSIGN_MEM = 297,
     NONATOMIC = 298,
     ATOMIC = 299,
     READONLY = 300,
     READWRITE = 301,
     NONNULL = 302,
     NULLABLE = 303,
     EXTERN = 304,
     STATIC = 305,
     CONST = 306,
     _NONNULL = 307,
     _NULLABLE = 308,
     _STRONG = 309,
     _WEAK = 310,
     _BLOCK = 311,
     _BRIDGE = 312,
     COMMA = 313,
     COLON = 314,
     SEMICOLON = 315,
     LP = 316,
     RP = 317,
     RIP = 318,
     LB = 319,
     RB = 320,
     LC = 321,
     RC = 322,
     DOT = 323,
     AT = 324,
     PS = 325,
     POINT = 326,
     EQ = 327,
     NE = 328,
     LT = 329,
     LE = 330,
     GT = 331,
     GE = 332,
     LOGIC_AND = 333,
     LOGIC_OR = 334,
     NOT = 335,
     AND = 336,
     OR = 337,
     POWER = 338,
     SUB = 339,
     ADD = 340,
     DIV = 341,
     ASTERISK = 342,
     AND_ASSIGN = 343,
     OR_ASSIGN = 344,
     POWER_ASSIGN = 345,
     SUB_ASSIGN = 346,
     ADD_ASSIGN = 347,
     DIV_ASSIGN = 348,
     ASTERISK_ASSIGN = 349,
     INCREMENT = 350,
     DECREMENT = 351,
     SHIFTLEFT = 352,
     SHIFTRIGHT = 353,
     MOD = 354,
     ASSIGN = 355,
     MOD_ASSIGN = 356,
     _self = 357,
     _super = 358,
     _nil = 359,
     _NULL = 360,
     _YES = 361,
     _NO = 362,
     _Class = 363,
     _id = 364,
     _void = 365,
     _BOOL = 366,
     _SEL = 367,
     _CHAR = 368,
     _SHORT = 369,
     _INT = 370,
     _LONG = 371,
     _LLONG = 372,
     _UCHAR = 373,
     _USHORT = 374,
     _UINT = 375,
     _ULONG = 376,
     _ULLONG = 377,
     _DOUBLE = 378,
     _FLOAT = 379,
     _instancetype = 380,
     INTETER_LITERAL = 381,
     DOUBLE_LITERAL = 382,
     SELECTOR = 383
   };
#endif
/* Tokens.  */
#define TYPE 258
#define VARIABLE 259
#define IDENTIFIER 260
#define STRING_LITERAL 261
#define TYPEDEF 262
#define IF 263
#define ENDIF 264
#define IFDEF 265
#define IFNDEF 266
#define UNDEF 267
#define IMPORT 268
#define INCLUDE 269
#define TILDE 270
#define QUESTION 271
#define _return 272
#define _break 273
#define _continue 274
#define _goto 275
#define _else 276
#define _while 277
#define _do 278
#define _in 279
#define _for 280
#define _case 281
#define _switch 282
#define _default 283
#define _enum 284
#define _typeof 285
#define _struct 286
#define _sizeof 287
#define INTERFACE 288
#define IMPLEMENTATION 289
#define PROTOCOL 290
#define END 291
#define CLASS_DECLARE 292
#define PROPERTY 293
#define WEAK 294
#define STRONG 295
#define COPY 296
#define ASSIGN_MEM 297
#define NONATOMIC 298
#define ATOMIC 299
#define READONLY 300
#define READWRITE 301
#define NONNULL 302
#define NULLABLE 303
#define EXTERN 304
#define STATIC 305
#define CONST 306
#define _NONNULL 307
#define _NULLABLE 308
#define _STRONG 309
#define _WEAK 310
#define _BLOCK 311
#define _BRIDGE 312
#define COMMA 313
#define COLON 314
#define SEMICOLON 315
#define LP 316
#define RP 317
#define RIP 318
#define LB 319
#define RB 320
#define LC 321
#define RC 322
#define DOT 323
#define AT 324
#define PS 325
#define POINT 326
#define EQ 327
#define NE 328
#define LT 329
#define LE 330
#define GT 331
#define GE 332
#define LOGIC_AND 333
#define LOGIC_OR 334
#define NOT 335
#define AND 336
#define OR 337
#define POWER 338
#define SUB 339
#define ADD 340
#define DIV 341
#define ASTERISK 342
#define AND_ASSIGN 343
#define OR_ASSIGN 344
#define POWER_ASSIGN 345
#define SUB_ASSIGN 346
#define ADD_ASSIGN 347
#define DIV_ASSIGN 348
#define ASTERISK_ASSIGN 349
#define INCREMENT 350
#define DECREMENT 351
#define SHIFTLEFT 352
#define SHIFTRIGHT 353
#define MOD 354
#define ASSIGN 355
#define MOD_ASSIGN 356
#define _self 357
#define _super 358
#define _nil 359
#define _NULL 360
#define _YES 361
#define _NO 362
#define _Class 363
#define _id 364
#define _void 365
#define _BOOL 366
#define _SEL 367
#define _CHAR 368
#define _SHORT 369
#define _INT 370
#define _LONG 371
#define _LLONG 372
#define _UCHAR 373
#define _USHORT 374
#define _UINT 375
#define _ULONG 376
#define _ULLONG 377
#define _DOUBLE 378
#define _FLOAT 379
#define _instancetype 380
#define INTETER_LITERAL 381
#define DOUBLE_LITERAL 382
#define SELECTOR 383




/* Copy the first part of user declarations.  */
#line 1 "cal.y"

#import <Foundation/Foundation.h>
#import "Log.h"
#import "MakeDeclare.h"
#import "Parser.h"
#define YYDEBUG 1
#define YYERROR_VERBOSE
#define _retained(type) (__bridge_retained type)
#define _vretained _retained(void *)
#define _transfer(type) (__bridge_transfer type)
#define _typeId _transfer(id)
extern int yylex (void);
extern void yyerror(const char *s);


/* Enabling traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 0
#endif

/* Enabling the token table.  */
#ifndef YYTOKEN_TABLE
# define YYTOKEN_TABLE 0
#endif

#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
#line 15 "cal.y"
{
    void *identifier;
    void *include;
    void *type;
    void *declare;
    void *implementation;
    void *statement;
    void *expression;
    int Operator;
}
/* Line 193 of yacc.c.  */
#line 378 "cal.tab.c"
	YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif



/* Copy the second part of user declarations.  */


/* Line 216 of yacc.c.  */
#line 391 "cal.tab.c"

#ifdef short
# undef short
#endif

#ifdef YYTYPE_UINT8
typedef YYTYPE_UINT8 yytype_uint8;
#else
typedef unsigned char yytype_uint8;
#endif

#ifdef YYTYPE_INT8
typedef YYTYPE_INT8 yytype_int8;
#elif (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
typedef signed char yytype_int8;
#else
typedef short int yytype_int8;
#endif

#ifdef YYTYPE_UINT16
typedef YYTYPE_UINT16 yytype_uint16;
#else
typedef unsigned short int yytype_uint16;
#endif

#ifdef YYTYPE_INT16
typedef YYTYPE_INT16 yytype_int16;
#else
typedef short int yytype_int16;
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif ! defined YYSIZE_T && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned int
# endif
#endif

#define YYSIZE_MAXIMUM ((YYSIZE_T) -1)

#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(msgid) dgettext ("bison-runtime", msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(msgid) msgid
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(e) ((void) (e))
#else
# define YYUSE(e) /* empty */
#endif

/* Identity function, used to suppress warnings about constant conditions.  */
#ifndef lint
# define YYID(n) (n)
#else
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static int
YYID (int i)
#else
static int
YYID (i)
    int i;
#endif
{
  return i;
}
#endif

#if ! defined yyoverflow || YYERROR_VERBOSE

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#     ifndef _STDLIB_H
#      define _STDLIB_H 1
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's `empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (YYID (0))
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined _STDLIB_H \
       && ! ((defined YYMALLOC || defined malloc) \
	     && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef _STDLIB_H
#    define _STDLIB_H 1
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* ! defined yyoverflow || YYERROR_VERBOSE */


#if (! defined yyoverflow \
     && (! defined __cplusplus \
	 || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yytype_int16 yyss;
  YYSTYPE yyvs;
  };

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (sizeof (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (sizeof (yytype_int16) + sizeof (YYSTYPE)) \
      + YYSTACK_GAP_MAXIMUM)

/* Copy COUNT objects from FROM to TO.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(To, From, Count) \
      __builtin_memcpy (To, From, (Count) * sizeof (*(From)))
#  else
#   define YYCOPY(To, From, Count)		\
      do					\
	{					\
	  YYSIZE_T yyi;				\
	  for (yyi = 0; yyi < (Count); yyi++)	\
	    (To)[yyi] = (From)[yyi];		\
	}					\
      while (YYID (0))
#  endif
# endif

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack)					\
    do									\
      {									\
	YYSIZE_T yynewbytes;						\
	YYCOPY (&yyptr->Stack, Stack, yysize);				\
	Stack = &yyptr->Stack;						\
	yynewbytes = yystacksize * sizeof (*Stack) + YYSTACK_GAP_MAXIMUM; \
	yyptr += yynewbytes / sizeof (*yyptr);				\
      }									\
    while (YYID (0))

#endif

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  157
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   3312

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  129
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  59
/* YYNRULES -- Number of rules.  */
#define YYNRULES  241
/* YYNRULES -- Number of states.  */
#define YYNSTATES  483

/* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   383

#define YYTRANSLATE(YYX)						\
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[YYLEX] -- Bison symbol number corresponding to YYLEX.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37,    38,    39,    40,    41,    42,    43,    44,
      45,    46,    47,    48,    49,    50,    51,    52,    53,    54,
      55,    56,    57,    58,    59,    60,    61,    62,    63,    64,
      65,    66,    67,    68,    69,    70,    71,    72,    73,    74,
      75,    76,    77,    78,    79,    80,    81,    82,    83,    84,
      85,    86,    87,    88,    89,    90,    91,    92,    93,    94,
      95,    96,    97,    98,    99,   100,   101,   102,   103,   104,
     105,   106,   107,   108,   109,   110,   111,   112,   113,   114,
     115,   116,   117,   118,   119,   120,   121,   122,   123,   124,
     125,   126,   127,   128
};

#if YYDEBUG
/* YYPRHS[YYN] -- Index of the first RHS symbol of rule number YYN in
   YYRHS.  */
static const yytype_uint16 yyprhs[] =
{
       0,     0,     3,     4,     6,     8,    11,    13,    15,    17,
      19,    21,    23,    30,    39,    42,    44,    47,    50,    52,
      54,    63,    66,    72,    78,    84,    90,    92,    96,   100,
     106,   117,   120,   123,   126,   132,   138,   142,   145,   150,
     156,   161,   166,   171,   177,   181,   184,   187,   193,   198,
     204,   207,   209,   213,   214,   218,   220,   222,   224,   226,
     228,   230,   232,   234,   236,   238,   239,   241,   245,   249,
     252,   261,   263,   265,   267,   269,   271,   273,   275,   277,
     279,   281,   283,   285,   287,   289,   290,   292,   296,   301,
     306,   309,   317,   319,   323,   328,   333,   338,   343,   349,
     358,   363,   371,   373,   377,   379,   382,   385,   388,   392,
     395,   398,   406,   416,   422,   431,   439,   443,   446,   451,
     457,   460,   463,   465,   469,   479,   489,   491,   493,   495,
     497,   499,   501,   502,   505,   508,   509,   511,   515,   517,
     519,   521,   523,   525,   527,   529,   531,   533,   535,   539,
     541,   547,   552,   554,   558,   560,   564,   566,   570,   572,
     576,   578,   582,   584,   588,   592,   594,   598,   602,   606,
     610,   612,   616,   620,   622,   626,   630,   632,   636,   640,
     644,   646,   649,   652,   655,   658,   661,   664,   669,   672,
     675,   678,   681,   683,   685,   689,   695,   697,   699,   701,
     703,   705,   707,   711,   715,   720,   724,   729,   734,   739,
     742,   745,   747,   752,   754,   756,   758,   760,   762,   765,
     770,   773,   778,   780,   782,   784,   786,   788,   790,   792,
     794,   796,   798,   800,   802,   804,   806,   808,   810,   812,
     814,   822
};

/* YYRHS -- A `-1'-separated list of the rules' RHS.  */
static const yytype_int16 yyrhs[] =
{
     130,     0,    -1,    -1,   131,    -1,   132,    -1,   131,   132,
      -1,   133,    -1,   140,    -1,   139,    -1,   141,    -1,   157,
      -1,   166,    -1,   187,     5,    61,   150,    62,    60,    -1,
     187,     5,    61,   150,    62,    66,   167,    67,    -1,    70,
     134,    -1,   138,    -1,    37,     5,    -1,    37,     3,    -1,
      13,    -1,    14,    -1,   134,    74,     5,    86,     5,    68,
       5,    76,    -1,   134,     6,    -1,    31,     5,    66,   143,
      67,    -1,    31,    66,   143,    67,     5,    -1,    29,     5,
      66,   137,    67,    -1,    29,    66,   137,    67,     5,    -1,
       5,    -1,     5,   100,   126,    -1,   137,    58,     5,    -1,
     137,    58,     5,   100,   126,    -1,     7,   187,    61,    83,
       5,    62,    61,   150,    62,    60,    -1,   136,    60,    -1,
     135,    60,    -1,     7,   138,    -1,    35,     5,    74,     3,
      76,    -1,   139,    38,   145,   146,    60,    -1,   139,   151,
      60,    -1,   139,    36,    -1,    33,     5,    59,     3,    -1,
      33,     5,    61,     5,    62,    -1,    33,     5,    61,    62,
      -1,   140,    74,   142,    76,    -1,   140,    66,   143,    67,
      -1,   140,    38,   145,   146,    60,    -1,   140,   151,    60,
      -1,   140,    36,    -1,    34,     5,    -1,    34,     5,    61,
       5,    62,    -1,   141,    66,   143,    67,    -1,   141,   151,
      66,   167,    67,    -1,   141,    36,    -1,     5,    -1,   142,
      58,     5,    -1,    -1,   143,   146,    60,    -1,    42,    -1,
      39,    -1,    40,    -1,    41,    -1,    43,    -1,    44,    -1,
      45,    -1,    46,    -1,    47,    -1,    48,    -1,    -1,    61,
      -1,   145,   144,    58,    -1,   145,   144,    62,    -1,   187,
     185,    -1,   187,    61,    83,   185,    62,    61,   150,    62,
      -1,    49,    -1,    50,    -1,    51,    -1,    47,    -1,    48,
      -1,    54,    -1,    55,    -1,    56,    -1,    57,    -1,    52,
      -1,    53,    -1,    51,    -1,   146,    -1,   187,    -1,    -1,
     149,    -1,   150,    58,   149,    -1,    84,    61,   187,    62,
      -1,    85,    61,   187,    62,    -1,   151,     5,    -1,   151,
       5,    59,    61,   187,    62,     5,    -1,   185,    -1,   185,
      59,   168,    -1,   152,   185,    59,   168,    -1,    64,     5,
     152,    65,    -1,    64,     3,   152,    65,    -1,    64,   186,
     152,    65,    -1,    83,   187,    66,   167,    67,    -1,    83,
     187,    61,   150,    62,    66,   167,    67,    -1,    83,    66,
     167,    67,    -1,    83,    61,   150,    62,    66,   167,    67,
      -1,   146,    -1,   146,   100,   156,    -1,   171,    -1,   170,
      60,    -1,   155,    60,    -1,    17,    60,    -1,    17,   156,
      60,    -1,    18,    60,    -1,    19,    60,    -1,     8,    61,
     156,    62,    66,   167,    67,    -1,   158,    21,     8,    61,
     156,    62,    66,   167,    67,    -1,   158,    21,    66,   167,
      67,    -1,    23,    66,   167,    67,    22,    61,   156,    62,
      -1,    22,    61,   156,    62,    66,   167,    67,    -1,    26,
     186,    59,    -1,    28,    59,    -1,   161,    66,   167,    67,
      -1,    27,    61,   156,    62,    66,    -1,   162,   161,    -1,
     162,    67,    -1,   156,    -1,   163,    60,   156,    -1,    25,
      61,   155,    60,   163,    62,    66,   167,    67,    -1,    25,
      61,   146,    24,   156,    62,    66,   167,    67,    -1,   158,
      -1,   162,    -1,   160,    -1,   159,    -1,   164,    -1,   165,
      -1,    -1,   167,   157,    -1,   167,   166,    -1,    -1,   156,
      -1,   168,    58,   156,    -1,   100,    -1,    88,    -1,    89,
      -1,    90,    -1,    92,    -1,    91,    -1,    93,    -1,    94,
      -1,   101,    -1,   171,    -1,   186,   169,   171,    -1,   172,
      -1,   172,    16,   171,    59,   171,    -1,   172,    16,    59,
     171,    -1,   173,    -1,   172,    79,   172,    -1,   174,    -1,
     173,    78,   174,    -1,   175,    -1,   174,    82,   175,    -1,
     176,    -1,   175,    83,   176,    -1,   177,    -1,   176,    81,
     177,    -1,   178,    -1,   177,    72,   178,    -1,   177,    73,
     178,    -1,   179,    -1,   178,    74,   179,    -1,   178,    75,
     179,    -1,   178,    76,   179,    -1,   178,    77,   179,    -1,
     180,    -1,   179,    97,   180,    -1,   179,    98,   180,    -1,
     181,    -1,   180,    85,   181,    -1,   180,    84,   181,    -1,
     182,    -1,   181,    87,   182,    -1,   181,    86,   182,    -1,
     181,    99,   182,    -1,   186,    -1,    80,   182,    -1,    84,
     182,    -1,    87,   182,    -1,    81,   182,    -1,    15,   182,
      -1,    32,   182,    -1,    61,   187,    62,   182,    -1,   182,
      95,    -1,   182,    96,    -1,    95,   182,    -1,    96,   182,
      -1,   126,    -1,   127,    -1,   170,    59,   170,    -1,   184,
      58,   170,    59,   170,    -1,     4,    -1,     5,    -1,   185,
      -1,   102,    -1,   103,    -1,   153,    -1,   186,    68,   185,
      -1,   186,    71,   185,    -1,   186,    61,   168,    62,    -1,
      61,   156,    62,    -1,    69,    66,   184,    67,    -1,    69,
      64,   168,    65,    -1,    69,    61,   156,    62,    -1,    69,
     183,    -1,    69,     6,    -1,   128,    -1,    35,    61,     5,
      62,    -1,     6,    -1,   154,    -1,   183,    -1,   104,    -1,
     105,    -1,   147,   187,    -1,   187,    74,   187,    76,    -1,
     187,   148,    -1,    30,    61,   156,    62,    -1,   118,    -1,
     119,    -1,   120,    -1,   121,    -1,   122,    -1,   113,    -1,
     114,    -1,   115,    -1,   116,    -1,   117,    -1,   123,    -1,
     124,    -1,   108,    -1,   111,    -1,   110,    -1,   125,    -1,
       3,    -1,   109,    -1,   187,    61,    83,    62,    61,   150,
      62,    -1,   187,    87,    -1
};

/* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,    52,    52,    53,    55,    56,    59,    60,    61,    62,
      63,    67,    71,    75,    84,    85,    86,    90,    93,    94,
      95,    96,   100,   104,   110,   114,   124,   128,   132,   138,
     148,   152,   153,   154,   158,   162,   163,   164,   168,   175,
     179,   183,   189,   195,   207,   208,   212,   217,   221,   227,
     235,   237,   244,   254,   258,   267,   268,   269,   270,   271,
     272,   273,   274,   275,   276,   280,   284,   289,   295,   304,
     308,   316,   317,   318,   319,   320,   321,   322,   323,   324,
     327,   328,   329,   333,   334,   337,   340,   346,   355,   359,
     363,   369,   380,   386,   393,   403,   410,   417,   429,   437,
     449,   457,   473,   480,   490,   493,   494,   495,   499,   503,
     507,   514,   519,   526,   536,   543,   558,   562,   566,   574,
     579,   585,   593,   599,   606,   616,   627,   628,   629,   630,
     631,   632,   637,   640,   646,   655,   656,   662,   671,   675,
     679,   683,   687,   691,   695,   699,   703,   710,   711,   721,
     722,   730,   741,   742,   752,   753,   762,   763,   772,   773,
     783,   784,   794,   795,   802,   811,   812,   819,   826,   833,
     842,   843,   850,   859,   860,   867,   877,   878,   885,   892,
     902,   903,   909,   915,   921,   927,   933,   939,   943,   949,
     955,   961,   970,   974,   980,   986,   995,   996,  1000,  1004,
    1008,  1012,  1013,  1023,  1032,  1047,  1051,  1055,  1059,  1063,
    1067,  1071,  1075,  1079,  1083,  1084,  1085,  1089,  1097,  1101,
    1102,  1103,  1107,  1111,  1115,  1119,  1123,  1127,  1131,  1135,
    1139,  1143,  1147,  1151,  1155,  1159,  1163,  1167,  1177,  1181,
    1186,  1190
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || YYTOKEN_TABLE
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "TYPE", "VARIABLE", "IDENTIFIER",
  "STRING_LITERAL", "TYPEDEF", "IF", "ENDIF", "IFDEF", "IFNDEF", "UNDEF",
  "IMPORT", "INCLUDE", "TILDE", "QUESTION", "_return", "_break",
  "_continue", "_goto", "_else", "_while", "_do", "_in", "_for", "_case",
  "_switch", "_default", "_enum", "_typeof", "_struct", "_sizeof",
  "INTERFACE", "IMPLEMENTATION", "PROTOCOL", "END", "CLASS_DECLARE",
  "PROPERTY", "WEAK", "STRONG", "COPY", "ASSIGN_MEM", "NONATOMIC",
  "ATOMIC", "READONLY", "READWRITE", "NONNULL", "NULLABLE", "EXTERN",
  "STATIC", "CONST", "_NONNULL", "_NULLABLE", "_STRONG", "_WEAK", "_BLOCK",
  "_BRIDGE", "COMMA", "COLON", "SEMICOLON", "LP", "RP", "RIP", "LB", "RB",
  "LC", "RC", "DOT", "AT", "PS", "POINT", "EQ", "NE", "LT", "LE", "GT",
  "GE", "LOGIC_AND", "LOGIC_OR", "NOT", "AND", "OR", "POWER", "SUB", "ADD",
  "DIV", "ASTERISK", "AND_ASSIGN", "OR_ASSIGN", "POWER_ASSIGN",
  "SUB_ASSIGN", "ADD_ASSIGN", "DIV_ASSIGN", "ASTERISK_ASSIGN", "INCREMENT",
  "DECREMENT", "SHIFTLEFT", "SHIFTRIGHT", "MOD", "ASSIGN", "MOD_ASSIGN",
  "_self", "_super", "_nil", "_NULL", "_YES", "_NO", "_Class", "_id",
  "_void", "_BOOL", "_SEL", "_CHAR", "_SHORT", "_INT", "_LONG", "_LLONG",
  "_UCHAR", "_USHORT", "_UINT", "_ULONG", "_ULLONG", "_DOUBLE", "_FLOAT",
  "_instancetype", "INTETER_LITERAL", "DOUBLE_LITERAL", "SELECTOR",
  "$accept", "compile_util", "definition_list", "definition", "PS_Define",
  "includeHeader", "struct_declare", "enum_declare",
  "enum_identifier_list", "typedef_declare", "protocol_declare",
  "class_declare", "class_implementation", "protocol_list",
  "class_private_varibale_declare", "class_property_type",
  "class_property_declare", "declare_variable", "declare_left_attribute",
  "declare_right_attribute", "block_parametere_type",
  "func_declare_parameters", "method_declare",
  "objc_method_call_pramameters", "objc_method_call",
  "block_implementation", "declare_expression", "expression",
  "expression_statement", "if_statement", "dowhile_statement",
  "while_statement", "case_statement", "switch_statement",
  "for_parameter_list", "for_statement", "forin_statement",
  "control_statement", "function_implementation", "expression_list",
  "assign_operator", "assign_expression", "ternary_expression",
  "logic_or_expression", "logic_and_expression", "bite_or_expression",
  "bite_xor_expression", "bite_and_expression", "equality_expression",
  "relational_expression", "bite_shift_expression", "additive_expression",
  "multiplication_expression", "unary_expression", "numerical_value_type",
  "dict_entry", "whole_identifier", "primary_expression", "type_specified", 0
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[YYLEX-NUM] -- Internal token number corresponding to
   token YYLEX-NUM.  */
static const yytype_uint16 yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
     275,   276,   277,   278,   279,   280,   281,   282,   283,   284,
     285,   286,   287,   288,   289,   290,   291,   292,   293,   294,
     295,   296,   297,   298,   299,   300,   301,   302,   303,   304,
     305,   306,   307,   308,   309,   310,   311,   312,   313,   314,
     315,   316,   317,   318,   319,   320,   321,   322,   323,   324,
     325,   326,   327,   328,   329,   330,   331,   332,   333,   334,
     335,   336,   337,   338,   339,   340,   341,   342,   343,   344,
     345,   346,   347,   348,   349,   350,   351,   352,   353,   354,
     355,   356,   357,   358,   359,   360,   361,   362,   363,   364,
     365,   366,   367,   368,   369,   370,   371,   372,   373,   374,
     375,   376,   377,   378,   379,   380,   381,   382,   383
};
# endif

/* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,   129,   130,   130,   131,   131,   132,   132,   132,   132,
     132,   132,   132,   132,   133,   133,   133,   133,   134,   134,
     134,   134,   135,   135,   136,   136,   137,   137,   137,   137,
     138,   138,   138,   138,   139,   139,   139,   139,   140,   140,
     140,   140,   140,   140,   140,   140,   141,   141,   141,   141,
     141,   142,   142,   143,   143,   144,   144,   144,   144,   144,
     144,   144,   144,   144,   144,   145,   145,   145,   145,   146,
     146,   147,   147,   147,   147,   147,   147,   147,   147,   147,
     148,   148,   148,   149,   149,   150,   150,   150,   151,   151,
     151,   151,   152,   152,   152,   153,   153,   153,   154,   154,
     154,   154,   155,   155,   156,   157,   157,   157,   157,   157,
     157,   158,   158,   158,   159,   160,   161,   161,   161,   162,
     162,   162,   163,   163,   164,   165,   166,   166,   166,   166,
     166,   166,   167,   167,   167,   168,   168,   168,   169,   169,
     169,   169,   169,   169,   169,   169,   169,   170,   170,   171,
     171,   171,   172,   172,   173,   173,   174,   174,   175,   175,
     176,   176,   177,   177,   177,   178,   178,   178,   178,   178,
     179,   179,   179,   180,   180,   180,   181,   181,   181,   181,
     182,   182,   182,   182,   182,   182,   182,   182,   182,   182,
     182,   182,   183,   183,   184,   184,   185,   185,   186,   186,
     186,   186,   186,   186,   186,   186,   186,   186,   186,   186,
     186,   186,   186,   186,   186,   186,   186,   186,   187,   187,
     187,   187,   187,   187,   187,   187,   187,   187,   187,   187,
     187,   187,   187,   187,   187,   187,   187,   187,   187,   187,
     187,   187
};

/* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     0,     1,     1,     2,     1,     1,     1,     1,
       1,     1,     6,     8,     2,     1,     2,     2,     1,     1,
       8,     2,     5,     5,     5,     5,     1,     3,     3,     5,
      10,     2,     2,     2,     5,     5,     3,     2,     4,     5,
       4,     4,     4,     5,     3,     2,     2,     5,     4,     5,
       2,     1,     3,     0,     3,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     0,     1,     3,     3,     2,
       8,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     0,     1,     3,     4,     4,
       2,     7,     1,     3,     4,     4,     4,     4,     5,     8,
       4,     7,     1,     3,     1,     2,     2,     2,     3,     2,
       2,     7,     9,     5,     8,     7,     3,     2,     4,     5,
       2,     2,     1,     3,     9,     9,     1,     1,     1,     1,
       1,     1,     0,     2,     2,     0,     1,     3,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     3,     1,
       5,     4,     1,     3,     1,     3,     1,     3,     1,     3,
       1,     3,     1,     3,     3,     1,     3,     3,     3,     3,
       1,     3,     3,     1,     3,     3,     1,     3,     3,     3,
       1,     2,     2,     2,     2,     2,     2,     4,     2,     2,
       2,     2,     1,     1,     3,     5,     1,     1,     1,     1,
       1,     1,     3,     3,     4,     3,     4,     4,     4,     2,
       2,     1,     4,     1,     1,     1,     1,     1,     2,     4,
       2,     4,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       7,     2
};

/* YYDEFACT[STATE-NAME] -- Default rule to reduce with in state
   STATE-NUM when YYTABLE doesn't specify something else to do.  Zero
   means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       2,   238,   196,   197,   213,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,    74,    75,    71,    72,    73,    76,    77,
      78,    79,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,   199,   200,   216,   217,   234,   239,   236,
     235,   227,   228,   229,   230,   231,   222,   223,   224,   225,
     226,   232,   233,   237,   192,   193,   211,     0,     3,     4,
       6,     0,     0,    15,     8,     7,     9,   102,     0,   201,
     214,     0,    10,   126,   129,   128,   127,   130,   131,    11,
       0,   147,   149,   152,   154,   156,   158,   160,   162,   165,
     170,   173,   176,   215,   198,   180,     0,    33,     0,     0,
       0,   185,   180,   107,     0,   104,   109,   110,     0,   132,
       0,     0,     0,     0,     0,     0,    53,   186,     0,    46,
       0,     0,    17,    16,     0,     0,     0,   197,     0,     0,
     210,     0,   135,     0,   209,    18,    19,    14,   181,   184,
      85,   132,     0,   182,   183,   190,   191,     1,     5,    32,
      31,    37,    65,     0,     0,     0,    45,    65,    53,     0,
       0,    50,    53,     0,     0,   218,   106,     0,     0,     0,
     121,   120,   105,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,   188,   189,   135,     0,     0,   139,   140,   141,
     143,   142,   144,   145,   138,   146,     0,   197,    82,    80,
      81,     0,     0,   241,   220,    69,     0,     0,   108,     0,
       0,   102,     0,     0,     0,     0,    26,     0,     0,    53,
       0,     0,     0,     0,     0,     0,   205,     0,     0,     0,
      92,     0,     0,     0,   136,     0,     0,     0,    21,     0,
      83,    86,     0,    84,     0,    85,   132,    66,     0,     0,
       0,    90,    36,     0,     0,    51,     0,    44,     0,   132,
     103,     0,   132,     0,   117,   132,     0,     0,   153,   155,
     157,   159,   161,   163,   164,   166,   167,   168,   169,   171,
     172,   175,   174,   178,   177,   179,     0,   202,   203,   148,
      85,     0,     0,     0,     0,     0,     0,   133,   134,     0,
       0,     0,     0,     0,     0,     0,   221,     0,     0,     0,
      38,     0,    40,     0,     0,   212,     0,   187,    96,     0,
     135,    95,    97,   208,     0,   207,     0,     0,   206,     0,
       0,     0,   100,     0,     0,    56,    57,    58,    55,    59,
      60,    61,    62,    74,    75,     0,     0,     0,     0,     0,
       0,    42,     0,    41,    48,     0,     0,     0,   116,     0,
     151,     0,   204,     0,     0,     0,   219,     0,   132,   132,
       0,     0,   122,     0,   119,    24,    27,    28,    25,    22,
      23,    54,    39,    47,    34,   135,    93,   137,   194,     0,
       0,    87,   132,     0,    98,    67,    68,    35,    88,    89,
       0,    43,    52,    49,     0,   113,   118,   150,     0,    85,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    94,
       0,     0,     0,   132,     0,     0,    12,   132,     0,    85,
      85,   111,   115,     0,   132,   123,   132,    29,   195,     0,
     101,     0,     0,   132,     0,   240,     0,     0,   114,     0,
       0,     0,    99,    91,     0,    13,    70,     0,   125,   124,
      20,   112,    30
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,    67,    68,    69,    70,   147,    71,    72,   237,    73,
      74,    75,    76,   276,   240,   365,   268,    77,    78,   224,
     261,   262,   165,   249,    79,    80,    81,   254,   317,    83,
      84,    85,   181,    86,   393,    87,    88,   318,   230,   255,
     216,    90,    91,    92,    93,    94,    95,    96,    97,    98,
      99,   100,   101,   102,   103,   257,   104,   112,   233
};

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
#define YYPACT_NINF -262
static const yytype_int16 yypact[] =
{
     472,  -262,  -262,  -262,  -262,  2785,   -39,  2621,  2487,   -41,
     -28,    36,    79,    41,    74,    30,    87,    34,  2621,   155,
     166,    10,    89,  -262,  -262,  -262,  -262,  -262,  -262,  -262,
    -262,  -262,  2362,   233,    -1,    95,  2621,  2621,  2814,  2621,
    2621,  2621,  2621,  -262,  -262,  -262,  -262,  -262,  -262,  -262,
    -262,  -262,  -262,  -262,  -262,  -262,  -262,  -262,  -262,  -262,
    -262,  -262,  -262,  -262,  -262,  -262,  -262,    67,   472,  -262,
    -262,   196,   203,  -262,   131,   127,   138,    97,  3187,  -262,
    -262,   210,  -262,   205,  -262,  -262,   151,  -262,  -262,  -262,
     214,  -262,    -7,   109,   200,   213,   218,   108,   215,   122,
     150,    17,   146,  -262,  -262,   187,    25,  -262,   331,  2621,
     240,   146,   114,  -262,   245,  -262,  -262,  -262,  2621,  -262,
    3187,  2621,   243,   312,  2621,   252,  -262,   146,   111,   264,
     267,   340,  -262,  -262,   286,   199,   261,   261,  2621,    46,
    -262,  2621,  2621,  2621,  -262,  -262,  -262,    15,   146,   146,
    3187,  -262,   232,   146,   146,   146,   146,  -262,  -262,  -262,
    -262,  -262,   289,   290,   295,    77,  -262,   289,  -262,   353,
      93,  -262,  -262,    39,  2621,   375,  -262,    45,  2434,   303,
    -262,   297,  -262,  2537,  2621,  2621,  2621,  2621,  2621,  2621,
    2621,  2621,  2621,  2621,  2621,  2621,  2621,  2621,  2621,  2621,
    2621,  2621,  -262,  -262,  2621,   261,   261,  -262,  -262,  -262,
    -262,  -262,  -262,  -262,  -262,  -262,  2621,   304,  -262,  -262,
    -262,   283,  3187,  -262,  -262,  -262,   284,   307,  -262,   311,
     598,   -21,   314,    32,   316,   312,   276,   -42,   324,  -262,
    2910,   388,    13,   389,   392,   337,  -262,   317,  2621,    50,
     345,    57,    69,   346,  -262,     1,   348,    43,  -262,   404,
    -262,  -262,    62,    32,   724,  2939,  -262,  -262,  2688,  3187,
    3187,   354,  -262,  2688,  3035,  -262,   -38,  -262,  3063,  -262,
    -262,   355,  -262,   105,  -262,  -262,  2621,   356,   338,   200,
     213,   218,   108,   215,   215,   122,   122,   122,   122,   150,
     150,    17,    17,   146,   146,   146,    70,  -262,  -262,  -262,
    3187,     7,   281,    51,   359,   363,   397,  -262,  -262,  2621,
    2621,   364,    73,   294,   416,   429,  -262,  3159,   430,   378,
    -262,   377,  -262,   379,   368,  -262,   384,   146,  -262,   391,
    2621,  -262,  -262,  -262,  2621,  -262,  2621,  2621,  -262,   361,
    3187,   382,  -262,   128,   850,  -262,  -262,  -262,  -262,  -262,
    -262,  -262,  -262,   137,   159,   170,   393,   319,   336,   394,
     398,  -262,   452,  -262,  -262,   976,  2621,  1102,  -262,  1228,
    -262,  2621,  -262,   171,   399,   401,  -262,   403,  -262,  -262,
     405,   406,  -262,   136,  -262,  -262,  -262,   367,  -262,  -262,
    -262,  -262,  -262,  -262,  -262,  2621,   413,  -262,  -262,   400,
     467,  -262,  -262,   407,  -262,  -262,  -262,  -262,  -262,  -262,
    3187,  -262,  -262,  -262,   419,  -262,  -262,  -262,    -2,  3187,
     421,   422,  1354,  1480,  2621,   418,  2621,   420,   362,   413,
    2621,   417,  1606,  -262,   350,   426,  -262,  -262,   182,  3187,
    3187,  -262,  -262,   431,  -262,  -262,  -262,  -262,  -262,   491,
    -262,  1732,   493,  -262,  1858,  -262,   185,   191,  -262,  1984,
    2110,   424,  -262,  -262,  2236,  -262,  -262,   448,  -262,  -262,
    -262,  -262,  -262
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -262,  -262,  -262,   442,  -262,  -262,  -262,  -262,   277,   506,
    -262,  -262,  -262,  -262,  -158,  -262,   347,  -119,  -262,  -262,
     163,  -261,   239,   120,  -262,  -262,   395,    20,    23,  -262,
    -262,  -262,  -262,  -262,  -262,  -262,  -262,    27,  -143,  -178,
    -262,  -137,     9,   332,  -262,   333,   339,   330,   342,   118,
     130,   148,   129,     6,   490,  -262,   -49,     0,     2
};

/* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule which
   number is the opposite.  If zero, do what YYDEFACT says.
   If YYTABLE_NINF, syntax error.  */
#define YYTABLE_NINF -65
static const yytype_int16 yytable[] =
{
     105,   231,   106,   319,   353,   140,   256,   108,   264,   183,
     274,     2,     3,   111,   278,   130,   324,   115,   331,   116,
     372,   258,   109,    82,   127,   325,   306,    89,   114,     2,
     217,   260,   117,   139,   135,   122,     2,     3,   373,   125,
     152,   115,   148,   149,   271,   153,   154,   155,   156,   383,
       2,     3,   134,   281,     2,     3,   387,   225,   446,   344,
     141,     2,     3,   142,   447,   143,   345,   157,   105,   384,
     106,   131,   184,     2,     3,   332,   218,   219,   220,   174,
     175,   327,   271,   218,   219,   220,   221,   250,   250,   259,
     250,    82,   132,   221,   133,    89,   123,   118,   271,   222,
     126,   347,   120,   199,   200,   279,   222,   204,   145,   146,
     348,   282,   223,   384,   205,   338,   201,   206,   115,   223,
     350,   329,   341,   354,   351,    64,    65,   115,   344,   227,
     115,   324,   382,   115,   342,   121,   375,   272,   229,   377,
     395,   234,   379,   105,   238,   119,   260,   115,   124,   366,
     115,   115,   263,   277,   370,   329,   307,   308,   134,   329,
     128,   253,   406,   166,   378,   167,   204,   161,   448,   162,
     241,   129,   242,   205,   171,   204,   206,   178,   283,   179,
     189,   190,   205,   115,   225,   206,   350,   185,   466,   467,
     413,   260,   287,   168,   280,   -63,   436,   174,   437,   -63,
     339,   169,   339,   339,   172,   303,   304,   305,   329,   408,
     409,   163,   164,   115,   225,   163,   164,   -64,   180,   195,
     196,   -64,   163,   164,   312,   309,   177,   439,   415,   350,
     105,   260,   416,   428,   197,   198,   136,     2,   137,     4,
     350,   202,   203,   350,   465,   432,   433,   476,   204,   350,
     218,   219,   220,   477,   337,   205,   159,   251,   206,   252,
     247,   248,   385,   160,   105,     2,     3,   263,   110,   442,
     176,   367,   368,   222,   182,   207,   208,   209,   210,   211,
     212,   213,   186,   218,   219,   220,   223,   214,   215,   191,
     192,   193,   194,   265,   138,   380,   187,    33,   266,   188,
     461,   131,    34,   458,   464,   228,   222,   293,   294,   235,
     260,   469,   263,   470,   170,   173,    38,   236,   239,   223,
     474,   295,   296,   297,   298,   243,   301,   302,   115,   115,
     260,   260,   218,   219,   220,    43,    44,    45,    46,   391,
     392,   244,   247,   299,   300,   245,   105,   105,   246,   115,
     267,   269,   263,   115,   105,   222,   270,   386,   275,    64,
      65,    66,   284,   285,   407,   310,   311,   313,   223,   314,
     218,   219,   220,   315,   320,   105,   323,   105,   321,   105,
     247,   418,   218,   219,   220,   115,   326,   218,   219,   220,
     427,   330,   226,   222,   333,   334,   424,   247,   419,   335,
     336,   218,   219,   220,   340,   222,   223,   346,   343,   349,
     222,   247,   462,   369,   115,   381,   376,   184,   223,   390,
     396,   397,   444,   223,   222,   388,   218,   219,   220,   389,
     394,   263,   105,   105,   398,   400,   247,   223,   401,   402,
     105,   403,   105,   115,   404,   115,   384,   410,   412,   222,
     405,   263,   263,   417,   453,   420,   455,   422,   421,   440,
     429,   105,   223,   430,   105,   431,   434,   438,   435,   105,
     105,   344,   441,   443,   105,     1,     2,     3,     4,     5,
       6,   445,   449,   450,   454,   459,   456,     7,   457,     8,
       9,    10,   463,   468,    11,    12,   471,    13,   473,    14,
     480,    15,    16,    17,    18,    19,    20,    21,   482,    22,
     158,   107,   322,   411,   273,   232,   288,   291,   289,    23,
      24,    25,    26,    27,   144,   290,    28,    29,    30,    31,
     292,     0,     0,    32,     0,     0,    33,     0,     0,     0,
       0,    34,    35,     0,     0,     0,     0,     0,     0,     0,
       0,     0,    36,    37,     0,    38,    39,     0,     0,    40,
       0,     0,     0,     0,     0,     0,     0,    41,    42,     0,
       0,     0,     0,     0,    43,    44,    45,    46,     0,     0,
      47,    48,    49,    50,     0,    51,    52,    53,    54,    55,
      56,    57,    58,    59,    60,    61,    62,    63,    64,    65,
      66,     1,     2,     3,     4,     0,     6,     0,     0,     0,
       0,     0,     0,     7,     0,     8,     9,    10,     0,     0,
      11,    12,     0,    13,     0,    14,     0,     0,    16,     0,
      18,     0,     0,   110,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,    23,    24,    25,    26,    27,
       0,     0,    28,    29,    30,    31,     0,     0,     0,    32,
       0,     0,    33,     0,     0,   316,     0,    34,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    36,    37,
       0,    38,    39,     0,     0,    40,     0,     0,     0,     0,
       0,     0,     0,    41,    42,     0,     0,     0,     0,     0,
      43,    44,    45,    46,     0,     0,    47,    48,    49,    50,
       0,    51,    52,    53,    54,    55,    56,    57,    58,    59,
      60,    61,    62,    63,    64,    65,    66,     1,     2,     3,
       4,     0,     6,     0,     0,     0,     0,     0,     0,     7,
       0,     8,     9,    10,     0,     0,    11,    12,     0,    13,
       0,    14,     0,     0,    16,     0,    18,     0,     0,   110,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,    23,    24,    25,    26,    27,     0,     0,    28,    29,
      30,    31,     0,     0,     0,    32,     0,     0,    33,     0,
       0,   352,     0,    34,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,    36,    37,     0,    38,    39,     0,
       0,    40,     0,     0,     0,     0,     0,     0,     0,    41,
      42,     0,     0,     0,     0,     0,    43,    44,    45,    46,
       0,     0,    47,    48,    49,    50,     0,    51,    52,    53,
      54,    55,    56,    57,    58,    59,    60,    61,    62,    63,
      64,    65,    66,     1,     2,     3,     4,     0,     6,     0,
       0,     0,     0,     0,     0,     7,     0,     8,     9,    10,
       0,     0,    11,    12,     0,    13,     0,    14,     0,     0,
      16,     0,    18,     0,     0,   110,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,    23,    24,    25,
      26,    27,     0,     0,    28,    29,    30,    31,     0,     0,
       0,    32,     0,     0,    33,     0,     0,   414,     0,    34,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
      36,    37,     0,    38,    39,     0,     0,    40,     0,     0,
       0,     0,     0,     0,     0,    41,    42,     0,     0,     0,
       0,     0,    43,    44,    45,    46,     0,     0,    47,    48,
      49,    50,     0,    51,    52,    53,    54,    55,    56,    57,
      58,    59,    60,    61,    62,    63,    64,    65,    66,     1,
       2,     3,     4,     0,     6,     0,     0,     0,     0,     0,
       0,     7,     0,     8,     9,    10,     0,     0,    11,    12,
       0,    13,     0,    14,     0,     0,    16,     0,    18,     0,
       0,   110,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,    23,    24,    25,    26,    27,     0,     0,
      28,    29,    30,    31,     0,     0,     0,    32,     0,     0,
      33,     0,     0,   423,     0,    34,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,    36,    37,     0,    38,
      39,     0,     0,    40,     0,     0,     0,     0,     0,     0,
       0,    41,    42,     0,     0,     0,     0,     0,    43,    44,
      45,    46,     0,     0,    47,    48,    49,    50,     0,    51,
      52,    53,    54,    55,    56,    57,    58,    59,    60,    61,
      62,    63,    64,    65,    66,     1,     2,     3,     4,     0,
       6,     0,     0,     0,     0,     0,     0,     7,     0,     8,
       9,    10,     0,     0,    11,    12,     0,    13,     0,    14,
       0,     0,    16,     0,    18,     0,     0,   110,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    23,
      24,    25,    26,    27,     0,     0,    28,    29,    30,    31,
       0,     0,     0,    32,     0,     0,    33,     0,     0,   425,
       0,    34,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,    36,    37,     0,    38,    39,     0,     0,    40,
       0,     0,     0,     0,     0,     0,     0,    41,    42,     0,
       0,     0,     0,     0,    43,    44,    45,    46,     0,     0,
      47,    48,    49,    50,     0,    51,    52,    53,    54,    55,
      56,    57,    58,    59,    60,    61,    62,    63,    64,    65,
      66,     1,     2,     3,     4,     0,     6,     0,     0,     0,
       0,     0,     0,     7,     0,     8,     9,    10,     0,     0,
      11,    12,     0,    13,     0,    14,     0,     0,    16,     0,
      18,     0,     0,   110,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,    23,    24,    25,    26,    27,
       0,     0,    28,    29,    30,    31,     0,     0,     0,    32,
       0,     0,    33,     0,     0,   426,     0,    34,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    36,    37,
       0,    38,    39,     0,     0,    40,     0,     0,     0,     0,
       0,     0,     0,    41,    42,     0,     0,     0,     0,     0,
      43,    44,    45,    46,     0,     0,    47,    48,    49,    50,
       0,    51,    52,    53,    54,    55,    56,    57,    58,    59,
      60,    61,    62,    63,    64,    65,    66,     1,     2,     3,
       4,     0,     6,     0,     0,     0,     0,     0,     0,     7,
       0,     8,     9,    10,     0,     0,    11,    12,     0,    13,
       0,    14,     0,     0,    16,     0,    18,     0,     0,   110,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,    23,    24,    25,    26,    27,     0,     0,    28,    29,
      30,    31,     0,     0,     0,    32,     0,     0,    33,     0,
       0,   451,     0,    34,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,    36,    37,     0,    38,    39,     0,
       0,    40,     0,     0,     0,     0,     0,     0,     0,    41,
      42,     0,     0,     0,     0,     0,    43,    44,    45,    46,
       0,     0,    47,    48,    49,    50,     0,    51,    52,    53,
      54,    55,    56,    57,    58,    59,    60,    61,    62,    63,
      64,    65,    66,     1,     2,     3,     4,     0,     6,     0,
       0,     0,     0,     0,     0,     7,     0,     8,     9,    10,
       0,     0,    11,    12,     0,    13,     0,    14,     0,     0,
      16,     0,    18,     0,     0,   110,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,    23,    24,    25,
      26,    27,     0,     0,    28,    29,    30,    31,     0,     0,
       0,    32,     0,     0,    33,     0,     0,   452,     0,    34,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
      36,    37,     0,    38,    39,     0,     0,    40,     0,     0,
       0,     0,     0,     0,     0,    41,    42,     0,     0,     0,
       0,     0,    43,    44,    45,    46,     0,     0,    47,    48,
      49,    50,     0,    51,    52,    53,    54,    55,    56,    57,
      58,    59,    60,    61,    62,    63,    64,    65,    66,     1,
       2,     3,     4,     0,     6,     0,     0,     0,     0,     0,
       0,     7,     0,     8,     9,    10,     0,     0,    11,    12,
       0,    13,     0,    14,     0,     0,    16,     0,    18,     0,
       0,   110,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,    23,    24,    25,    26,    27,     0,     0,
      28,    29,    30,    31,     0,     0,     0,    32,     0,     0,
      33,     0,     0,   460,     0,    34,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,    36,    37,     0,    38,
      39,     0,     0,    40,     0,     0,     0,     0,     0,     0,
       0,    41,    42,     0,     0,     0,     0,     0,    43,    44,
      45,    46,     0,     0,    47,    48,    49,    50,     0,    51,
      52,    53,    54,    55,    56,    57,    58,    59,    60,    61,
      62,    63,    64,    65,    66,     1,     2,     3,     4,     0,
       6,     0,     0,     0,     0,     0,     0,     7,     0,     8,
       9,    10,     0,     0,    11,    12,     0,    13,     0,    14,
       0,     0,    16,     0,    18,     0,     0,   110,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    23,
      24,    25,    26,    27,     0,     0,    28,    29,    30,    31,
       0,     0,     0,    32,     0,     0,    33,     0,     0,   472,
       0,    34,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,    36,    37,     0,    38,    39,     0,     0,    40,
       0,     0,     0,     0,     0,     0,     0,    41,    42,     0,
       0,     0,     0,     0,    43,    44,    45,    46,     0,     0,
      47,    48,    49,    50,     0,    51,    52,    53,    54,    55,
      56,    57,    58,    59,    60,    61,    62,    63,    64,    65,
      66,     1,     2,     3,     4,     0,     6,     0,     0,     0,
       0,     0,     0,     7,     0,     8,     9,    10,     0,     0,
      11,    12,     0,    13,     0,    14,     0,     0,    16,     0,
      18,     0,     0,   110,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,    23,    24,    25,    26,    27,
       0,     0,    28,    29,    30,    31,     0,     0,     0,    32,
       0,     0,    33,     0,     0,   475,     0,    34,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    36,    37,
       0,    38,    39,     0,     0,    40,     0,     0,     0,     0,
       0,     0,     0,    41,    42,     0,     0,     0,     0,     0,
      43,    44,    45,    46,     0,     0,    47,    48,    49,    50,
       0,    51,    52,    53,    54,    55,    56,    57,    58,    59,
      60,    61,    62,    63,    64,    65,    66,     1,     2,     3,
       4,     0,     6,     0,     0,     0,     0,     0,     0,     7,
       0,     8,     9,    10,     0,     0,    11,    12,     0,    13,
       0,    14,     0,     0,    16,     0,    18,     0,     0,   110,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,    23,    24,    25,    26,    27,     0,     0,    28,    29,
      30,    31,     0,     0,     0,    32,     0,     0,    33,     0,
       0,   478,     0,    34,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,    36,    37,     0,    38,    39,     0,
       0,    40,     0,     0,     0,     0,     0,     0,     0,    41,
      42,     0,     0,     0,     0,     0,    43,    44,    45,    46,
       0,     0,    47,    48,    49,    50,     0,    51,    52,    53,
      54,    55,    56,    57,    58,    59,    60,    61,    62,    63,
      64,    65,    66,     1,     2,     3,     4,     0,     6,     0,
       0,     0,     0,     0,     0,     7,     0,     8,     9,    10,
       0,     0,    11,    12,     0,    13,     0,    14,     0,     0,
      16,     0,    18,     0,     0,   110,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,    23,    24,    25,
      26,    27,     0,     0,    28,    29,    30,    31,     0,     0,
       0,    32,     0,     0,    33,     0,     0,   479,     0,    34,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
      36,    37,     0,    38,    39,     0,     0,    40,     0,     0,
       0,     0,     0,     0,     0,    41,    42,     0,     0,     0,
       0,     0,    43,    44,    45,    46,     0,     0,    47,    48,
      49,    50,     0,    51,    52,    53,    54,    55,    56,    57,
      58,    59,    60,    61,    62,    63,    64,    65,    66,     1,
       2,     3,     4,     0,     6,     0,     0,     0,     0,     0,
       0,     7,     0,     8,     9,    10,     0,     0,    11,    12,
       0,    13,     0,    14,     0,     0,    16,     0,    18,     0,
       0,   110,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,    23,    24,    25,    26,    27,     0,     0,
      28,    29,    30,    31,     0,     0,     0,    32,     0,     0,
      33,     0,     0,   481,     0,    34,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,    36,    37,     0,    38,
      39,     0,     0,    40,     0,     0,     0,     0,     0,     0,
       0,    41,    42,     0,     0,     0,     0,     0,    43,    44,
      45,    46,     0,     0,    47,    48,    49,    50,     0,    51,
      52,    53,    54,    55,    56,    57,    58,    59,    60,    61,
      62,    63,    64,    65,    66,     1,     2,     3,     4,     0,
       0,     0,     0,     0,     0,     0,     0,     7,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,    16,     0,    18,     0,     0,   110,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    23,
      24,    25,    26,    27,     0,     0,    28,    29,    30,    31,
       0,     0,     0,    32,     0,     0,    33,     0,     0,     0,
       0,    34,     0,     0,     0,     0,     0,     0,     2,     3,
       4,     0,    36,    37,     0,    38,    39,     0,     0,    40,
       0,     0,     0,     0,     0,     0,     0,    41,    42,     0,
       0,     0,     0,     0,    43,    44,    45,    46,     0,   110,
      47,    48,    49,    50,     0,    51,    52,    53,    54,    55,
      56,    57,    58,    59,    60,    61,    62,    63,    64,    65,
      66,     2,     3,     4,     0,   138,     0,     0,    33,     0,
       0,     0,     7,    34,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,    38,     0,    18,
       0,     0,   110,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,    43,    44,    45,    46,
       0,     2,     3,     4,     0,     0,     0,   113,    32,     0,
       0,    33,     7,     0,     0,     0,    34,     0,     0,     0,
      64,    65,    66,     0,     0,     0,     0,    36,    37,    18,
      38,    39,   110,     0,    40,     0,     0,     0,     0,     0,
       0,     0,    41,    42,     0,     0,     0,     0,     0,    43,
      44,    45,    46,     0,     0,     0,   286,     0,    32,     0,
       0,    33,     0,     0,     0,     0,    34,     0,     0,     0,
       0,     0,     0,    64,    65,    66,     0,    36,    37,     0,
      38,    39,     0,     0,    40,     2,     3,     4,     0,     0,
       0,     0,    41,    42,     0,     0,     7,     0,     0,    43,
      44,    45,    46,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,    18,     0,     0,   110,     0,     0,     0,
       0,     0,     0,    64,    65,    66,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,    32,     0,     0,    33,     0,     0,     0,     0,
      34,     1,     0,     0,     0,     0,     0,     0,     0,     0,
       0,    36,    37,     0,    38,    39,     0,     0,    40,     0,
       0,     0,     0,     0,     0,     0,    41,    42,    16,     0,
       0,     0,     0,    43,    44,    45,    46,   355,   356,   357,
     358,   359,   360,   361,   362,   363,   364,    25,    26,    27,
       0,     0,    28,    29,    30,    31,     0,    64,    65,    66,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     1,     0,
       0,     0,     5,     0,     0,     0,    47,    48,    49,    50,
       0,    51,    52,    53,    54,    55,    56,    57,    58,    59,
      60,    61,    62,    63,    15,    16,    17,     1,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,    23,    24,    25,    26,    27,     0,     0,    28,
      29,    30,    31,     0,    16,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,    23,    24,    25,    26,    27,     0,     0,    28,    29,
      30,    31,     0,     0,     0,   150,     0,     0,     0,     0,
     151,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,    47,    48,    49,    50,     0,    51,    52,
      53,    54,    55,    56,    57,    58,    59,    60,    61,    62,
      63,     0,     0,     1,     0,     0,     0,     0,     0,     0,
       0,     0,    47,    48,    49,    50,     0,    51,    52,    53,
      54,    55,    56,    57,    58,    59,    60,    61,    62,    63,
      16,     0,     1,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,    23,    24,    25,
      26,    27,     0,     0,    28,    29,    30,    31,     0,    16,
       0,     0,     0,     0,     0,     0,     0,   328,     0,     0,
       0,     0,     0,     0,     0,     0,    23,    24,    25,    26,
      27,     0,     0,    28,    29,    30,    31,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    47,    48,
      49,    50,   336,    51,    52,    53,    54,    55,    56,    57,
      58,    59,    60,    61,    62,    63,     0,     0,     1,     0,
       0,     0,     0,     0,     0,     0,     0,    47,    48,    49,
      50,     0,    51,    52,    53,    54,    55,    56,    57,    58,
      59,    60,    61,    62,    63,    16,     1,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,    23,    24,    25,    26,    27,     0,     0,    28,
      29,    30,    31,    16,     0,     0,     0,     0,     0,     0,
       0,     0,   371,     0,     0,     0,     0,     0,     0,     0,
      23,    24,    25,    26,    27,     0,     0,    28,    29,    30,
      31,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     374,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,    47,    48,    49,    50,     0,    51,    52,
      53,    54,    55,    56,    57,    58,    59,    60,    61,    62,
      63,     0,     1,     0,     0,     0,     0,     0,     0,     0,
       0,    47,    48,    49,    50,     0,    51,    52,    53,    54,
      55,    56,    57,    58,    59,    60,    61,    62,    63,    16,
       1,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,    23,    24,    25,    26,
      27,     0,     0,    28,    29,    30,    31,    16,     0,     0,
       0,     0,     0,     0,     0,     0,   399,     0,     0,     0,
       0,     0,     0,     0,    23,    24,    25,    26,    27,     0,
       0,    28,    29,    30,    31,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,    47,    48,    49,
      50,     0,    51,    52,    53,    54,    55,    56,    57,    58,
      59,    60,    61,    62,    63,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,    47,    48,    49,    50,     0,
      51,    52,    53,    54,    55,    56,    57,    58,    59,    60,
      61,    62,    63
};

static const yytype_int16 yycheck[] =
{
       0,   120,     0,    24,   265,     6,   143,     5,   151,    16,
     168,     4,     5,     7,   172,     5,    58,     8,     5,    60,
      58,     6,    61,     0,    18,    67,   204,     0,     8,     4,
       5,   150,    60,    33,    32,     5,     4,     5,    76,     5,
      38,    32,    36,    37,     5,    39,    40,    41,    42,   310,
       4,     5,    32,     8,     4,     5,     5,   106,    60,    58,
      61,     4,     5,    64,    66,    66,    65,     0,    68,    62,
      68,    61,    79,     4,     5,    62,    51,    52,    53,   100,
      78,   239,     5,    51,    52,    53,    61,   136,   137,    74,
     139,    68,     3,    61,     5,    68,    66,    61,     5,    74,
      66,    58,    61,    86,    87,    66,    74,    61,    13,    14,
      67,    66,    87,    62,    68,    65,    99,    71,   109,    87,
      58,   240,    65,   266,    62,   126,   127,   118,    58,   109,
     121,    58,    62,   124,    65,    61,   279,    60,   118,   282,
      67,   121,   285,   143,   124,    66,   265,   138,    61,   268,
     141,   142,   150,    60,   273,   274,   205,   206,   138,   278,
       5,   141,   340,    36,    59,    38,    61,    36,   429,    38,
      59,     5,    61,    68,    36,    61,    71,    26,   178,    28,
      72,    73,    68,   174,   233,    71,    58,    78,   449,   450,
      62,   310,   183,    66,   174,    58,    60,   100,    62,    62,
     249,    74,   251,   252,    66,   199,   200,   201,   327,   346,
     347,    84,    85,   204,   263,    84,    85,    58,    67,    97,
      98,    62,    84,    85,   222,   216,    21,   405,    58,    58,
     230,   350,    62,    62,    84,    85,     3,     4,     5,     6,
      58,    95,    96,    58,    62,   388,   389,    62,    61,    58,
      51,    52,    53,    62,   248,    68,    60,   137,    71,   139,
      61,    62,   311,    60,   264,     4,     5,   265,    35,   412,
      60,   269,   270,    74,    60,    88,    89,    90,    91,    92,
      93,    94,    82,    51,    52,    53,    87,   100,   101,    74,
      75,    76,    77,    61,    61,   286,    83,    64,    66,    81,
     443,    61,    69,   440,   447,    60,    74,   189,   190,    66,
     429,   454,   310,   456,    75,    76,    83,     5,    66,    87,
     463,   191,   192,   193,   194,    61,   197,   198,   319,   320,
     449,   450,    51,    52,    53,   102,   103,   104,   105,   319,
     320,    74,    61,   195,   196,     5,   346,   347,    62,   340,
      61,    61,   350,   344,   354,    74,    61,    76,     5,   126,
     127,   128,    59,    66,   344,    61,    83,    83,    87,    62,
      51,    52,    53,    62,    60,   375,   100,   377,    62,   379,
      61,    62,    51,    52,    53,   376,    62,    51,    52,    53,
     381,     3,    61,    74,     5,     3,   376,    61,    62,    62,
      83,    51,    52,    53,    59,    74,    87,    59,    62,     5,
      74,    61,    62,    59,   405,    59,    61,    79,    87,    22,
     126,     5,   420,    87,    74,    66,    51,    52,    53,    66,
      66,   429,   432,   433,     5,     5,    61,    87,    60,    62,
     440,    62,   442,   434,    76,   436,    62,    86,    66,    74,
      59,   449,   450,    60,   434,    61,   436,     5,    60,    59,
      61,   461,    87,    62,   464,    62,    61,   100,    62,   469,
     470,    58,     5,    66,   474,     3,     4,     5,     6,     7,
       8,    62,    61,    61,    66,    68,    66,    15,   126,    17,
      18,    19,    66,    62,    22,    23,     5,    25,     5,    27,
      76,    29,    30,    31,    32,    33,    34,    35,    60,    37,
      68,     5,   235,   350,   167,   120,   184,   187,   185,    47,
      48,    49,    50,    51,    34,   186,    54,    55,    56,    57,
     188,    -1,    -1,    61,    -1,    -1,    64,    -1,    -1,    -1,
      -1,    69,    70,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    80,    81,    -1,    83,    84,    -1,    -1,    87,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    95,    96,    -1,
      -1,    -1,    -1,    -1,   102,   103,   104,   105,    -1,    -1,
     108,   109,   110,   111,    -1,   113,   114,   115,   116,   117,
     118,   119,   120,   121,   122,   123,   124,   125,   126,   127,
     128,     3,     4,     5,     6,    -1,     8,    -1,    -1,    -1,
      -1,    -1,    -1,    15,    -1,    17,    18,    19,    -1,    -1,
      22,    23,    -1,    25,    -1,    27,    -1,    -1,    30,    -1,
      32,    -1,    -1,    35,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    47,    48,    49,    50,    51,
      -1,    -1,    54,    55,    56,    57,    -1,    -1,    -1,    61,
      -1,    -1,    64,    -1,    -1,    67,    -1,    69,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    80,    81,
      -1,    83,    84,    -1,    -1,    87,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    95,    96,    -1,    -1,    -1,    -1,    -1,
     102,   103,   104,   105,    -1,    -1,   108,   109,   110,   111,
      -1,   113,   114,   115,   116,   117,   118,   119,   120,   121,
     122,   123,   124,   125,   126,   127,   128,     3,     4,     5,
       6,    -1,     8,    -1,    -1,    -1,    -1,    -1,    -1,    15,
      -1,    17,    18,    19,    -1,    -1,    22,    23,    -1,    25,
      -1,    27,    -1,    -1,    30,    -1,    32,    -1,    -1,    35,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    47,    48,    49,    50,    51,    -1,    -1,    54,    55,
      56,    57,    -1,    -1,    -1,    61,    -1,    -1,    64,    -1,
      -1,    67,    -1,    69,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    80,    81,    -1,    83,    84,    -1,
      -1,    87,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    95,
      96,    -1,    -1,    -1,    -1,    -1,   102,   103,   104,   105,
      -1,    -1,   108,   109,   110,   111,    -1,   113,   114,   115,
     116,   117,   118,   119,   120,   121,   122,   123,   124,   125,
     126,   127,   128,     3,     4,     5,     6,    -1,     8,    -1,
      -1,    -1,    -1,    -1,    -1,    15,    -1,    17,    18,    19,
      -1,    -1,    22,    23,    -1,    25,    -1,    27,    -1,    -1,
      30,    -1,    32,    -1,    -1,    35,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    47,    48,    49,
      50,    51,    -1,    -1,    54,    55,    56,    57,    -1,    -1,
      -1,    61,    -1,    -1,    64,    -1,    -1,    67,    -1,    69,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      80,    81,    -1,    83,    84,    -1,    -1,    87,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    95,    96,    -1,    -1,    -1,
      -1,    -1,   102,   103,   104,   105,    -1,    -1,   108,   109,
     110,   111,    -1,   113,   114,   115,   116,   117,   118,   119,
     120,   121,   122,   123,   124,   125,   126,   127,   128,     3,
       4,     5,     6,    -1,     8,    -1,    -1,    -1,    -1,    -1,
      -1,    15,    -1,    17,    18,    19,    -1,    -1,    22,    23,
      -1,    25,    -1,    27,    -1,    -1,    30,    -1,    32,    -1,
      -1,    35,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    47,    48,    49,    50,    51,    -1,    -1,
      54,    55,    56,    57,    -1,    -1,    -1,    61,    -1,    -1,
      64,    -1,    -1,    67,    -1,    69,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    80,    81,    -1,    83,
      84,    -1,    -1,    87,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    95,    96,    -1,    -1,    -1,    -1,    -1,   102,   103,
     104,   105,    -1,    -1,   108,   109,   110,   111,    -1,   113,
     114,   115,   116,   117,   118,   119,   120,   121,   122,   123,
     124,   125,   126,   127,   128,     3,     4,     5,     6,    -1,
       8,    -1,    -1,    -1,    -1,    -1,    -1,    15,    -1,    17,
      18,    19,    -1,    -1,    22,    23,    -1,    25,    -1,    27,
      -1,    -1,    30,    -1,    32,    -1,    -1,    35,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    47,
      48,    49,    50,    51,    -1,    -1,    54,    55,    56,    57,
      -1,    -1,    -1,    61,    -1,    -1,    64,    -1,    -1,    67,
      -1,    69,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    80,    81,    -1,    83,    84,    -1,    -1,    87,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    95,    96,    -1,
      -1,    -1,    -1,    -1,   102,   103,   104,   105,    -1,    -1,
     108,   109,   110,   111,    -1,   113,   114,   115,   116,   117,
     118,   119,   120,   121,   122,   123,   124,   125,   126,   127,
     128,     3,     4,     5,     6,    -1,     8,    -1,    -1,    -1,
      -1,    -1,    -1,    15,    -1,    17,    18,    19,    -1,    -1,
      22,    23,    -1,    25,    -1,    27,    -1,    -1,    30,    -1,
      32,    -1,    -1,    35,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    47,    48,    49,    50,    51,
      -1,    -1,    54,    55,    56,    57,    -1,    -1,    -1,    61,
      -1,    -1,    64,    -1,    -1,    67,    -1,    69,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    80,    81,
      -1,    83,    84,    -1,    -1,    87,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    95,    96,    -1,    -1,    -1,    -1,    -1,
     102,   103,   104,   105,    -1,    -1,   108,   109,   110,   111,
      -1,   113,   114,   115,   116,   117,   118,   119,   120,   121,
     122,   123,   124,   125,   126,   127,   128,     3,     4,     5,
       6,    -1,     8,    -1,    -1,    -1,    -1,    -1,    -1,    15,
      -1,    17,    18,    19,    -1,    -1,    22,    23,    -1,    25,
      -1,    27,    -1,    -1,    30,    -1,    32,    -1,    -1,    35,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    47,    48,    49,    50,    51,    -1,    -1,    54,    55,
      56,    57,    -1,    -1,    -1,    61,    -1,    -1,    64,    -1,
      -1,    67,    -1,    69,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    80,    81,    -1,    83,    84,    -1,
      -1,    87,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    95,
      96,    -1,    -1,    -1,    -1,    -1,   102,   103,   104,   105,
      -1,    -1,   108,   109,   110,   111,    -1,   113,   114,   115,
     116,   117,   118,   119,   120,   121,   122,   123,   124,   125,
     126,   127,   128,     3,     4,     5,     6,    -1,     8,    -1,
      -1,    -1,    -1,    -1,    -1,    15,    -1,    17,    18,    19,
      -1,    -1,    22,    23,    -1,    25,    -1,    27,    -1,    -1,
      30,    -1,    32,    -1,    -1,    35,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    47,    48,    49,
      50,    51,    -1,    -1,    54,    55,    56,    57,    -1,    -1,
      -1,    61,    -1,    -1,    64,    -1,    -1,    67,    -1,    69,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      80,    81,    -1,    83,    84,    -1,    -1,    87,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    95,    96,    -1,    -1,    -1,
      -1,    -1,   102,   103,   104,   105,    -1,    -1,   108,   109,
     110,   111,    -1,   113,   114,   115,   116,   117,   118,   119,
     120,   121,   122,   123,   124,   125,   126,   127,   128,     3,
       4,     5,     6,    -1,     8,    -1,    -1,    -1,    -1,    -1,
      -1,    15,    -1,    17,    18,    19,    -1,    -1,    22,    23,
      -1,    25,    -1,    27,    -1,    -1,    30,    -1,    32,    -1,
      -1,    35,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    47,    48,    49,    50,    51,    -1,    -1,
      54,    55,    56,    57,    -1,    -1,    -1,    61,    -1,    -1,
      64,    -1,    -1,    67,    -1,    69,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    80,    81,    -1,    83,
      84,    -1,    -1,    87,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    95,    96,    -1,    -1,    -1,    -1,    -1,   102,   103,
     104,   105,    -1,    -1,   108,   109,   110,   111,    -1,   113,
     114,   115,   116,   117,   118,   119,   120,   121,   122,   123,
     124,   125,   126,   127,   128,     3,     4,     5,     6,    -1,
       8,    -1,    -1,    -1,    -1,    -1,    -1,    15,    -1,    17,
      18,    19,    -1,    -1,    22,    23,    -1,    25,    -1,    27,
      -1,    -1,    30,    -1,    32,    -1,    -1,    35,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    47,
      48,    49,    50,    51,    -1,    -1,    54,    55,    56,    57,
      -1,    -1,    -1,    61,    -1,    -1,    64,    -1,    -1,    67,
      -1,    69,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    80,    81,    -1,    83,    84,    -1,    -1,    87,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    95,    96,    -1,
      -1,    -1,    -1,    -1,   102,   103,   104,   105,    -1,    -1,
     108,   109,   110,   111,    -1,   113,   114,   115,   116,   117,
     118,   119,   120,   121,   122,   123,   124,   125,   126,   127,
     128,     3,     4,     5,     6,    -1,     8,    -1,    -1,    -1,
      -1,    -1,    -1,    15,    -1,    17,    18,    19,    -1,    -1,
      22,    23,    -1,    25,    -1,    27,    -1,    -1,    30,    -1,
      32,    -1,    -1,    35,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    47,    48,    49,    50,    51,
      -1,    -1,    54,    55,    56,    57,    -1,    -1,    -1,    61,
      -1,    -1,    64,    -1,    -1,    67,    -1,    69,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    80,    81,
      -1,    83,    84,    -1,    -1,    87,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    95,    96,    -1,    -1,    -1,    -1,    -1,
     102,   103,   104,   105,    -1,    -1,   108,   109,   110,   111,
      -1,   113,   114,   115,   116,   117,   118,   119,   120,   121,
     122,   123,   124,   125,   126,   127,   128,     3,     4,     5,
       6,    -1,     8,    -1,    -1,    -1,    -1,    -1,    -1,    15,
      -1,    17,    18,    19,    -1,    -1,    22,    23,    -1,    25,
      -1,    27,    -1,    -1,    30,    -1,    32,    -1,    -1,    35,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    47,    48,    49,    50,    51,    -1,    -1,    54,    55,
      56,    57,    -1,    -1,    -1,    61,    -1,    -1,    64,    -1,
      -1,    67,    -1,    69,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    80,    81,    -1,    83,    84,    -1,
      -1,    87,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    95,
      96,    -1,    -1,    -1,    -1,    -1,   102,   103,   104,   105,
      -1,    -1,   108,   109,   110,   111,    -1,   113,   114,   115,
     116,   117,   118,   119,   120,   121,   122,   123,   124,   125,
     126,   127,   128,     3,     4,     5,     6,    -1,     8,    -1,
      -1,    -1,    -1,    -1,    -1,    15,    -1,    17,    18,    19,
      -1,    -1,    22,    23,    -1,    25,    -1,    27,    -1,    -1,
      30,    -1,    32,    -1,    -1,    35,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    47,    48,    49,
      50,    51,    -1,    -1,    54,    55,    56,    57,    -1,    -1,
      -1,    61,    -1,    -1,    64,    -1,    -1,    67,    -1,    69,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      80,    81,    -1,    83,    84,    -1,    -1,    87,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    95,    96,    -1,    -1,    -1,
      -1,    -1,   102,   103,   104,   105,    -1,    -1,   108,   109,
     110,   111,    -1,   113,   114,   115,   116,   117,   118,   119,
     120,   121,   122,   123,   124,   125,   126,   127,   128,     3,
       4,     5,     6,    -1,     8,    -1,    -1,    -1,    -1,    -1,
      -1,    15,    -1,    17,    18,    19,    -1,    -1,    22,    23,
      -1,    25,    -1,    27,    -1,    -1,    30,    -1,    32,    -1,
      -1,    35,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    47,    48,    49,    50,    51,    -1,    -1,
      54,    55,    56,    57,    -1,    -1,    -1,    61,    -1,    -1,
      64,    -1,    -1,    67,    -1,    69,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    80,    81,    -1,    83,
      84,    -1,    -1,    87,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    95,    96,    -1,    -1,    -1,    -1,    -1,   102,   103,
     104,   105,    -1,    -1,   108,   109,   110,   111,    -1,   113,
     114,   115,   116,   117,   118,   119,   120,   121,   122,   123,
     124,   125,   126,   127,   128,     3,     4,     5,     6,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    15,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    30,    -1,    32,    -1,    -1,    35,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    47,
      48,    49,    50,    51,    -1,    -1,    54,    55,    56,    57,
      -1,    -1,    -1,    61,    -1,    -1,    64,    -1,    -1,    -1,
      -1,    69,    -1,    -1,    -1,    -1,    -1,    -1,     4,     5,
       6,    -1,    80,    81,    -1,    83,    84,    -1,    -1,    87,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    95,    96,    -1,
      -1,    -1,    -1,    -1,   102,   103,   104,   105,    -1,    35,
     108,   109,   110,   111,    -1,   113,   114,   115,   116,   117,
     118,   119,   120,   121,   122,   123,   124,   125,   126,   127,
     128,     4,     5,     6,    -1,    61,    -1,    -1,    64,    -1,
      -1,    -1,    15,    69,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    83,    -1,    32,
      -1,    -1,    35,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,   102,   103,   104,   105,
      -1,     4,     5,     6,    -1,    -1,    -1,    60,    61,    -1,
      -1,    64,    15,    -1,    -1,    -1,    69,    -1,    -1,    -1,
     126,   127,   128,    -1,    -1,    -1,    -1,    80,    81,    32,
      83,    84,    35,    -1,    87,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    95,    96,    -1,    -1,    -1,    -1,    -1,   102,
     103,   104,   105,    -1,    -1,    -1,    59,    -1,    61,    -1,
      -1,    64,    -1,    -1,    -1,    -1,    69,    -1,    -1,    -1,
      -1,    -1,    -1,   126,   127,   128,    -1,    80,    81,    -1,
      83,    84,    -1,    -1,    87,     4,     5,     6,    -1,    -1,
      -1,    -1,    95,    96,    -1,    -1,    15,    -1,    -1,   102,
     103,   104,   105,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    32,    -1,    -1,    35,    -1,    -1,    -1,
      -1,    -1,    -1,   126,   127,   128,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    61,    -1,    -1,    64,    -1,    -1,    -1,    -1,
      69,     3,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    80,    81,    -1,    83,    84,    -1,    -1,    87,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    95,    96,    30,    -1,
      -1,    -1,    -1,   102,   103,   104,   105,    39,    40,    41,
      42,    43,    44,    45,    46,    47,    48,    49,    50,    51,
      -1,    -1,    54,    55,    56,    57,    -1,   126,   127,   128,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,     3,    -1,
      -1,    -1,     7,    -1,    -1,    -1,   108,   109,   110,   111,
      -1,   113,   114,   115,   116,   117,   118,   119,   120,   121,
     122,   123,   124,   125,    29,    30,    31,     3,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    47,    48,    49,    50,    51,    -1,    -1,    54,
      55,    56,    57,    -1,    30,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    47,    48,    49,    50,    51,    -1,    -1,    54,    55,
      56,    57,    -1,    -1,    -1,    61,    -1,    -1,    -1,    -1,
      66,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,   108,   109,   110,   111,    -1,   113,   114,
     115,   116,   117,   118,   119,   120,   121,   122,   123,   124,
     125,    -1,    -1,     3,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,   108,   109,   110,   111,    -1,   113,   114,   115,
     116,   117,   118,   119,   120,   121,   122,   123,   124,   125,
      30,    -1,     3,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    47,    48,    49,
      50,    51,    -1,    -1,    54,    55,    56,    57,    -1,    30,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    67,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    47,    48,    49,    50,
      51,    -1,    -1,    54,    55,    56,    57,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,   108,   109,
     110,   111,    83,   113,   114,   115,   116,   117,   118,   119,
     120,   121,   122,   123,   124,   125,    -1,    -1,     3,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,   108,   109,   110,
     111,    -1,   113,   114,   115,   116,   117,   118,   119,   120,
     121,   122,   123,   124,   125,    30,     3,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    47,    48,    49,    50,    51,    -1,    -1,    54,
      55,    56,    57,    30,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    67,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      47,    48,    49,    50,    51,    -1,    -1,    54,    55,    56,
      57,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      67,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,   108,   109,   110,   111,    -1,   113,   114,
     115,   116,   117,   118,   119,   120,   121,   122,   123,   124,
     125,    -1,     3,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,   108,   109,   110,   111,    -1,   113,   114,   115,   116,
     117,   118,   119,   120,   121,   122,   123,   124,   125,    30,
       3,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    47,    48,    49,    50,
      51,    -1,    -1,    54,    55,    56,    57,    30,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    67,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    47,    48,    49,    50,    51,    -1,
      -1,    54,    55,    56,    57,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,   108,   109,   110,
     111,    -1,   113,   114,   115,   116,   117,   118,   119,   120,
     121,   122,   123,   124,   125,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,   108,   109,   110,   111,    -1,
     113,   114,   115,   116,   117,   118,   119,   120,   121,   122,
     123,   124,   125
};

/* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
   symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,     3,     4,     5,     6,     7,     8,    15,    17,    18,
      19,    22,    23,    25,    27,    29,    30,    31,    32,    33,
      34,    35,    37,    47,    48,    49,    50,    51,    54,    55,
      56,    57,    61,    64,    69,    70,    80,    81,    83,    84,
      87,    95,    96,   102,   103,   104,   105,   108,   109,   110,
     111,   113,   114,   115,   116,   117,   118,   119,   120,   121,
     122,   123,   124,   125,   126,   127,   128,   130,   131,   132,
     133,   135,   136,   138,   139,   140,   141,   146,   147,   153,
     154,   155,   157,   158,   159,   160,   162,   164,   165,   166,
     170,   171,   172,   173,   174,   175,   176,   177,   178,   179,
     180,   181,   182,   183,   185,   186,   187,   138,   187,    61,
      35,   182,   186,    60,   156,   171,    60,    60,    61,    66,
      61,    61,     5,    66,    61,     5,    66,   182,     5,     5,
       5,    61,     3,     5,   156,   187,     3,     5,    61,   186,
       6,    61,    64,    66,   183,    13,    14,   134,   182,   182,
      61,    66,   187,   182,   182,   182,   182,     0,   132,    60,
      60,    36,    38,    84,    85,   151,    36,    38,    66,    74,
     151,    36,    66,   151,   100,   187,    60,    21,    26,    28,
      67,   161,    60,    16,    79,    78,    82,    83,    81,    72,
      73,    74,    75,    76,    77,    97,    98,    84,    85,    86,
      87,    99,    95,    96,    61,    68,    71,    88,    89,    90,
      91,    92,    93,    94,   100,   101,   169,     5,    51,    52,
      53,    61,    74,    87,   148,   185,    61,   156,    60,   156,
     167,   146,   155,   187,   156,    66,     5,   137,   156,    66,
     143,    59,    61,    61,    74,     5,    62,    61,    62,   152,
     185,   152,   152,   156,   156,   168,   170,   184,     6,    74,
     146,   149,   150,   187,   167,    61,    66,    61,   145,    61,
      61,     5,    60,   145,   143,     5,   142,    60,   143,    66,
     156,     8,    66,   186,    59,    66,    59,   171,   172,   174,
     175,   176,   177,   178,   178,   179,   179,   179,   179,   180,
     180,   181,   181,   182,   182,   182,   168,   185,   185,   171,
      61,    83,   187,    83,    62,    62,    67,   157,   166,    24,
      60,    62,   137,   100,    58,    67,    62,   143,    67,   146,
       3,     5,    62,     5,     3,    62,    83,   182,    65,   185,
      59,    65,    65,    62,    58,    65,    59,    58,    67,     5,
      58,    62,    67,   150,   167,    39,    40,    41,    42,    43,
      44,    45,    46,    47,    48,   144,   146,   187,   187,    59,
     146,    67,    58,    76,    67,   167,    61,   167,    59,   167,
     171,    59,    62,   150,    62,   185,    76,     5,    66,    66,
      22,   156,   156,   163,    66,    67,   126,     5,     5,    67,
       5,    60,    62,    62,    76,    59,   168,   156,   170,   170,
      86,   149,    66,    62,    67,    58,    62,    60,    62,    62,
      61,    60,     5,    67,   156,    67,    67,   171,    62,    61,
      62,    62,   167,   167,    61,    62,    60,    62,   100,   168,
      59,     5,   167,    66,   187,    62,    60,    66,   150,    61,
      61,    67,    67,   156,    66,   156,    66,   126,   170,    68,
      67,   167,    62,    66,   167,    62,   150,   150,    62,   167,
     167,     5,    67,     5,   167,    67,    62,    62,    67,    67,
      76,    67,    60
};

#define yyerrok		(yyerrstatus = 0)
#define yyclearin	(yychar = YYEMPTY)
#define YYEMPTY		(-2)
#define YYEOF		0

#define YYACCEPT	goto yyacceptlab
#define YYABORT		goto yyabortlab
#define YYERROR		goto yyerrorlab


/* Like YYERROR except do call yyerror.  This remains here temporarily
   to ease the transition to the new meaning of YYERROR, for GCC.
   Once GCC version 2 has supplanted version 1, this can go.  */

#define YYFAIL		goto yyerrlab

#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)					\
do								\
  if (yychar == YYEMPTY && yylen == 1)				\
    {								\
      yychar = (Token);						\
      yylval = (Value);						\
      yytoken = YYTRANSLATE (yychar);				\
      YYPOPSTACK (1);						\
      goto yybackup;						\
    }								\
  else								\
    {								\
      yyerror (YY_("syntax error: cannot back up")); \
      YYERROR;							\
    }								\
while (YYID (0))


#define YYTERROR	1
#define YYERRCODE	256


/* YYLLOC_DEFAULT -- Set CURRENT to span from RHS[1] to RHS[N].
   If N is 0, then set CURRENT to the empty location which ends
   the previous symbol: RHS[0] (always defined).  */

#define YYRHSLOC(Rhs, K) ((Rhs)[K])
#ifndef YYLLOC_DEFAULT
# define YYLLOC_DEFAULT(Current, Rhs, N)				\
    do									\
      if (YYID (N))                                                    \
	{								\
	  (Current).first_line   = YYRHSLOC (Rhs, 1).first_line;	\
	  (Current).first_column = YYRHSLOC (Rhs, 1).first_column;	\
	  (Current).last_line    = YYRHSLOC (Rhs, N).last_line;		\
	  (Current).last_column  = YYRHSLOC (Rhs, N).last_column;	\
	}								\
      else								\
	{								\
	  (Current).first_line   = (Current).last_line   =		\
	    YYRHSLOC (Rhs, 0).last_line;				\
	  (Current).first_column = (Current).last_column =		\
	    YYRHSLOC (Rhs, 0).last_column;				\
	}								\
    while (YYID (0))
#endif


/* YY_LOCATION_PRINT -- Print the location on the stream.
   This macro was not mandated originally: define only if we know
   we won't break user code: when these are the locations we know.  */

#ifndef YY_LOCATION_PRINT
# if defined YYLTYPE_IS_TRIVIAL && YYLTYPE_IS_TRIVIAL
#  define YY_LOCATION_PRINT(File, Loc)			\
     fprintf (File, "%d.%d-%d.%d",			\
	      (Loc).first_line, (Loc).first_column,	\
	      (Loc).last_line,  (Loc).last_column)
# else
#  define YY_LOCATION_PRINT(File, Loc) ((void) 0)
# endif
#endif


/* YYLEX -- calling `yylex' with the right arguments.  */

#ifdef YYLEX_PARAM
# define YYLEX yylex (YYLEX_PARAM)
#else
# define YYLEX yylex ()
#endif

/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)			\
do {						\
  if (yydebug)					\
    YYFPRINTF Args;				\
} while (YYID (0))

# define YY_SYMBOL_PRINT(Title, Type, Value, Location)			  \
do {									  \
  if (yydebug)								  \
    {									  \
      YYFPRINTF (stderr, "%s ", Title);					  \
      yy_symbol_print (stderr,						  \
		  Type, Value); \
      YYFPRINTF (stderr, "\n");						  \
    }									  \
} while (YYID (0))


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

/*ARGSUSED*/
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_symbol_value_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
#else
static void
yy_symbol_value_print (yyoutput, yytype, yyvaluep)
    FILE *yyoutput;
    int yytype;
    YYSTYPE const * const yyvaluep;
#endif
{
  if (!yyvaluep)
    return;
# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyoutput, yytoknum[yytype], *yyvaluep);
# else
  YYUSE (yyoutput);
# endif
  switch (yytype)
    {
      default:
	break;
    }
}


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_symbol_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
#else
static void
yy_symbol_print (yyoutput, yytype, yyvaluep)
    FILE *yyoutput;
    int yytype;
    YYSTYPE const * const yyvaluep;
#endif
{
  if (yytype < YYNTOKENS)
    YYFPRINTF (yyoutput, "token %s (", yytname[yytype]);
  else
    YYFPRINTF (yyoutput, "nterm %s (", yytname[yytype]);

  yy_symbol_value_print (yyoutput, yytype, yyvaluep);
  YYFPRINTF (yyoutput, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_stack_print (yytype_int16 *bottom, yytype_int16 *top)
#else
static void
yy_stack_print (bottom, top)
    yytype_int16 *bottom;
    yytype_int16 *top;
#endif
{
  YYFPRINTF (stderr, "Stack now");
  for (; bottom <= top; ++bottom)
    YYFPRINTF (stderr, " %d", *bottom);
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)				\
do {								\
  if (yydebug)							\
    yy_stack_print ((Bottom), (Top));				\
} while (YYID (0))


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_reduce_print (YYSTYPE *yyvsp, int yyrule)
#else
static void
yy_reduce_print (yyvsp, yyrule)
    YYSTYPE *yyvsp;
    int yyrule;
#endif
{
  int yynrhs = yyr2[yyrule];
  int yyi;
  unsigned long int yylno = yyrline[yyrule];
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %lu):\n",
	     yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      fprintf (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr, yyrhs[yyprhs[yyrule] + yyi],
		       &(yyvsp[(yyi + 1) - (yynrhs)])
		       		       );
      fprintf (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)		\
do {					\
  if (yydebug)				\
    yy_reduce_print (yyvsp, Rule); \
} while (YYID (0))

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args)
# define YY_SYMBOL_PRINT(Title, Type, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef	YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif



#if YYERROR_VERBOSE

# ifndef yystrlen
#  if defined __GLIBC__ && defined _STRING_H
#   define yystrlen strlen
#  else
/* Return the length of YYSTR.  */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static YYSIZE_T
yystrlen (const char *yystr)
#else
static YYSIZE_T
yystrlen (yystr)
    const char *yystr;
#endif
{
  YYSIZE_T yylen;
  for (yylen = 0; yystr[yylen]; yylen++)
    continue;
  return yylen;
}
#  endif
# endif

# ifndef yystpcpy
#  if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
#   define yystpcpy stpcpy
#  else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static char *
yystpcpy (char *yydest, const char *yysrc)
#else
static char *
yystpcpy (yydest, yysrc)
    char *yydest;
    const char *yysrc;
#endif
{
  char *yyd = yydest;
  const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
#  endif
# endif

# ifndef yytnamerr
/* Copy to YYRES the contents of YYSTR after stripping away unnecessary
   quotes and backslashes, so that it's suitable for yyerror.  The
   heuristic is that double-quoting is unnecessary unless the string
   contains an apostrophe, a comma, or backslash (other than
   backslash-backslash).  YYSTR is taken from yytname.  If YYRES is
   null, do not copy; instead, return the length of what the result
   would have been.  */
static YYSIZE_T
yytnamerr (char *yyres, const char *yystr)
{
  if (*yystr == '"')
    {
      YYSIZE_T yyn = 0;
      char const *yyp = yystr;

      for (;;)
	switch (*++yyp)
	  {
	  case '\'':
	  case ',':
	    goto do_not_strip_quotes;

	  case '\\':
	    if (*++yyp != '\\')
	      goto do_not_strip_quotes;
	    /* Fall through.  */
	  default:
	    if (yyres)
	      yyres[yyn] = *yyp;
	    yyn++;
	    break;

	  case '"':
	    if (yyres)
	      yyres[yyn] = '\0';
	    return yyn;
	  }
    do_not_strip_quotes: ;
    }

  if (! yyres)
    return yystrlen (yystr);

  return yystpcpy (yyres, yystr) - yyres;
}
# endif

/* Copy into YYRESULT an error message about the unexpected token
   YYCHAR while in state YYSTATE.  Return the number of bytes copied,
   including the terminating null byte.  If YYRESULT is null, do not
   copy anything; just return the number of bytes that would be
   copied.  As a special case, return 0 if an ordinary "syntax error"
   message will do.  Return YYSIZE_MAXIMUM if overflow occurs during
   size calculation.  */
static YYSIZE_T
yysyntax_error (char *yyresult, int yystate, int yychar)
{
  int yyn = yypact[yystate];

  if (! (YYPACT_NINF < yyn && yyn <= YYLAST))
    return 0;
  else
    {
      int yytype = YYTRANSLATE (yychar);
      YYSIZE_T yysize0 = yytnamerr (0, yytname[yytype]);
      YYSIZE_T yysize = yysize0;
      YYSIZE_T yysize1;
      int yysize_overflow = 0;
      enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
      char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
      int yyx;

# if 0
      /* This is so xgettext sees the translatable formats that are
	 constructed on the fly.  */
      YY_("syntax error, unexpected %s");
      YY_("syntax error, unexpected %s, expecting %s");
      YY_("syntax error, unexpected %s, expecting %s or %s");
      YY_("syntax error, unexpected %s, expecting %s or %s or %s");
      YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s");
# endif
      char *yyfmt;
      char const *yyf;
      static char const yyunexpected[] = "syntax error, unexpected %s";
      static char const yyexpecting[] = ", expecting %s";
      static char const yyor[] = " or %s";
      char yyformat[sizeof yyunexpected
		    + sizeof yyexpecting - 1
		    + ((YYERROR_VERBOSE_ARGS_MAXIMUM - 2)
		       * (sizeof yyor - 1))];
      char const *yyprefix = yyexpecting;

      /* Start YYX at -YYN if negative to avoid negative indexes in
	 YYCHECK.  */
      int yyxbegin = yyn < 0 ? -yyn : 0;

      /* Stay within bounds of both yycheck and yytname.  */
      int yychecklim = YYLAST - yyn + 1;
      int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
      int yycount = 1;

      yyarg[0] = yytname[yytype];
      yyfmt = yystpcpy (yyformat, yyunexpected);

      for (yyx = yyxbegin; yyx < yyxend; ++yyx)
	if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR)
	  {
	    if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
	      {
		yycount = 1;
		yysize = yysize0;
		yyformat[sizeof yyunexpected - 1] = '\0';
		break;
	      }
	    yyarg[yycount++] = yytname[yyx];
	    yysize1 = yysize + yytnamerr (0, yytname[yyx]);
	    yysize_overflow |= (yysize1 < yysize);
	    yysize = yysize1;
	    yyfmt = yystpcpy (yyfmt, yyprefix);
	    yyprefix = yyor;
	  }

      yyf = YY_(yyformat);
      yysize1 = yysize + yystrlen (yyf);
      yysize_overflow |= (yysize1 < yysize);
      yysize = yysize1;

      if (yysize_overflow)
	return YYSIZE_MAXIMUM;

      if (yyresult)
	{
	  /* Avoid sprintf, as that infringes on the user's name space.
	     Don't have undefined behavior even if the translation
	     produced a string with the wrong number of "%s"s.  */
	  char *yyp = yyresult;
	  int yyi = 0;
	  while ((*yyp = *yyf) != '\0')
	    {
	      if (*yyp == '%' && yyf[1] == 's' && yyi < yycount)
		{
		  yyp += yytnamerr (yyp, yyarg[yyi++]);
		  yyf += 2;
		}
	      else
		{
		  yyp++;
		  yyf++;
		}
	    }
	}
      return yysize;
    }
}
#endif /* YYERROR_VERBOSE */


/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

/*ARGSUSED*/
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep)
#else
static void
yydestruct (yymsg, yytype, yyvaluep)
    const char *yymsg;
    int yytype;
    YYSTYPE *yyvaluep;
#endif
{
  YYUSE (yyvaluep);

  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  switch (yytype)
    {

      default:
	break;
    }
}


/* Prevent warnings from -Wmissing-prototypes.  */

#ifdef YYPARSE_PARAM
#if defined __STDC__ || defined __cplusplus
int yyparse (void *YYPARSE_PARAM);
#else
int yyparse ();
#endif
#else /* ! YYPARSE_PARAM */
#if defined __STDC__ || defined __cplusplus
int yyparse (void);
#else
int yyparse ();
#endif
#endif /* ! YYPARSE_PARAM */



/* The look-ahead symbol.  */
int yychar;

/* The semantic value of the look-ahead symbol.  */
YYSTYPE yylval;

/* Number of syntax errors so far.  */
int yynerrs;



/*----------.
| yyparse.  |
`----------*/

#ifdef YYPARSE_PARAM
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
int
yyparse (void *YYPARSE_PARAM)
#else
int
yyparse (YYPARSE_PARAM)
    void *YYPARSE_PARAM;
#endif
#else /* ! YYPARSE_PARAM */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
int
yyparse (void)
#else
int
yyparse ()

#endif
#endif
{
  
  int yystate;
  int yyn;
  int yyresult;
  /* Number of tokens to shift before error messages enabled.  */
  int yyerrstatus;
  /* Look-ahead token as an internal (translated) token number.  */
  int yytoken = 0;
#if YYERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYSIZE_T yymsg_alloc = sizeof yymsgbuf;
#endif

  /* Three stacks and their tools:
     `yyss': related to states,
     `yyvs': related to semantic values,
     `yyls': related to locations.

     Refer to the stacks thru separate pointers, to allow yyoverflow
     to reallocate them elsewhere.  */

  /* The state stack.  */
  yytype_int16 yyssa[YYINITDEPTH];
  yytype_int16 *yyss = yyssa;
  yytype_int16 *yyssp;

  /* The semantic value stack.  */
  YYSTYPE yyvsa[YYINITDEPTH];
  YYSTYPE *yyvs = yyvsa;
  YYSTYPE *yyvsp;



#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  YYSIZE_T yystacksize = YYINITDEPTH;

  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;


  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY;		/* Cause a token to be read.  */

  /* Initialize stack pointers.
     Waste one element of value and location stack
     so that they stay on the same level as the state stack.
     The wasted elements are never initialized.  */

  yyssp = yyss;
  yyvsp = yyvs;

  goto yysetstate;

/*------------------------------------------------------------.
| yynewstate -- Push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
 yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;

 yysetstate:
  *yyssp = yystate;

  if (yyss + yystacksize - 1 <= yyssp)
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYSIZE_T yysize = yyssp - yyss + 1;

#ifdef yyoverflow
      {
	/* Give user a chance to reallocate the stack.  Use copies of
	   these so that the &'s don't force the real ones into
	   memory.  */
	YYSTYPE *yyvs1 = yyvs;
	yytype_int16 *yyss1 = yyss;


	/* Each stack pointer address is followed by the size of the
	   data in use in that stack, in bytes.  This used to be a
	   conditional around just the two extra args, but that might
	   be undefined if yyoverflow is a macro.  */
	yyoverflow (YY_("memory exhausted"),
		    &yyss1, yysize * sizeof (*yyssp),
		    &yyvs1, yysize * sizeof (*yyvsp),

		    &yystacksize);

	yyss = yyss1;
	yyvs = yyvs1;
      }
#else /* no yyoverflow */
# ifndef YYSTACK_RELOCATE
      goto yyexhaustedlab;
# else
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
	goto yyexhaustedlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
	yystacksize = YYMAXDEPTH;

      {
	yytype_int16 *yyss1 = yyss;
	union yyalloc *yyptr =
	  (union yyalloc *) YYSTACK_ALLOC (YYSTACK_BYTES (yystacksize));
	if (! yyptr)
	  goto yyexhaustedlab;
	YYSTACK_RELOCATE (yyss);
	YYSTACK_RELOCATE (yyvs);

#  undef YYSTACK_RELOCATE
	if (yyss1 != yyssa)
	  YYSTACK_FREE (yyss1);
      }
# endif
#endif /* no yyoverflow */

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;


      YYDPRINTF ((stderr, "Stack size increased to %lu\n",
		  (unsigned long int) yystacksize));

      if (yyss + yystacksize - 1 <= yyssp)
	YYABORT;
    }

  YYDPRINTF ((stderr, "Entering state %d\n", yystate));

  goto yybackup;

/*-----------.
| yybackup.  |
`-----------*/
yybackup:

  /* Do appropriate processing given the current state.  Read a
     look-ahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to look-ahead token.  */
  yyn = yypact[yystate];
  if (yyn == YYPACT_NINF)
    goto yydefault;

  /* Not known => get a look-ahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid look-ahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = YYLEX;
    }

  if (yychar <= YYEOF)
    {
      yychar = yytoken = YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yyn == 0 || yyn == YYTABLE_NINF)
	goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  if (yyn == YYFINAL)
    YYACCEPT;

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the look-ahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);

  /* Discard the shifted token unless it is eof.  */
  if (yychar != YYEOF)
    yychar = YYEMPTY;

  yystate = yyn;
  *++yyvsp = yylval;

  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- Do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     `$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
        case 10:
#line 64 "cal.y"
    {
                [LibAst.globalStatements addObject:_transfer(id) (yyvsp[(1) - (1)].statement)];
            ;}
    break;

  case 11:
#line 68 "cal.y"
    {
                [LibAst.globalStatements addObject:_transfer(id) (yyvsp[(1) - (1)].statement)];
            ;}
    break;

  case 12:
#line 72 "cal.y"
    {
                addVariableSymbol(_typeId (yyvsp[(2) - (6)].identifier));
            ;}
    break;

  case 13:
#line 76 "cal.y"
    {
                addVariableSymbol(_typeId (yyvsp[(2) - (8)].identifier));
                BlockImp *imp = (BlockImp *)makeValue(OCValueBlock);
                imp.declare = makeFuncDeclare(_transfer(id)(yyvsp[(2) - (8)].identifier),_transfer(id)(yyvsp[(4) - (8)].declare));
                imp.funcImp = _transfer(id)(yyvsp[(7) - (8)].expression);
                [LibAst.globalStatements addObject:_transfer(id) (yyvsp[(1) - (8)].expression)];
            ;}
    break;

  case 16:
#line 87 "cal.y"
    {
              addTypeSymbol(_typeId (yyvsp[(2) - (2)].identifier));
          ;}
    break;

  case 22:
#line 101 "cal.y"
    {
                addTypeSymbol(_typeId (yyvsp[(2) - (5)].identifier));
            ;}
    break;

  case 23:
#line 105 "cal.y"
    {
                addTypeSymbol(_typeId (yyvsp[(5) - (5)].identifier));
            ;}
    break;

  case 24:
#line 111 "cal.y"
    {
                addTypeSymbol(_typeId (yyvsp[(2) - (5)].identifier));
            ;}
    break;

  case 25:
#line 115 "cal.y"
    {
                addTypeSymbol(_typeId (yyvsp[(5) - (5)].identifier));
                NSMutableArray *list  = _typeId (yyvsp[(3) - (5)].include);
                for (NSString *element in list){
                    addVariableSymbol(element);
                }
            ;}
    break;

  case 26:
#line 125 "cal.y"
    {
                (yyval.include) = _vretained [@[_typeId (yyvsp[(1) - (1)].identifier)] mutableCopy];
            ;}
    break;

  case 27:
#line 129 "cal.y"
    {
                (yyval.include) = _vretained [@[_typeId (yyvsp[(1) - (3)].identifier)] mutableCopy];
            ;}
    break;

  case 28:
#line 133 "cal.y"
    {
                NSMutableArray *list  = _typeId (yyvsp[(1) - (3)].include);
                [list addObject:_typeId (yyvsp[(3) - (3)].identifier)];
                (yyval.include) = _vretained list;
            ;}
    break;

  case 29:
#line 139 "cal.y"
    {
                NSMutableArray *list  = _typeId (yyvsp[(1) - (5)].include);
                [list addObject:_typeId (yyvsp[(3) - (5)].identifier)];
                (yyval.include) = _vretained list;
            ;}
    break;

  case 30:
#line 149 "cal.y"
    {
                addTypeSymbol(_typeId (yyvsp[(4) - (10)].identifier));
            ;}
    break;

  case 34:
#line 159 "cal.y"
    {
                addTypeSymbol(_typeId (yyvsp[(2) - (5)].identifier));
            ;}
    break;

  case 38:
#line 169 "cal.y"
    {
                OCClass *occlass = [LibAst classForName:_transfer(id)(yyvsp[(2) - (4)].identifier)];
                occlass.superClassName = _transfer(id)(yyvsp[(4) - (4)].identifier);
                (yyval.declare) = _vretained occlass;
            ;}
    break;

  case 39:
#line 176 "cal.y"
    {
                (yyval.declare) = _vretained [LibAst classForName:_transfer(id)(yyvsp[(2) - (5)].identifier)];
            ;}
    break;

  case 40:
#line 180 "cal.y"
    {
                (yyval.declare) = _vretained [LibAst classForName:_transfer(id)(yyvsp[(2) - (4)].identifier)];
            ;}
    break;

  case 41:
#line 184 "cal.y"
    {
                OCClass *occlass = _transfer(OCClass *) (yyvsp[(1) - (4)].declare);
                occlass.protocols = _transfer(id) (yyvsp[(3) - (4)].declare);
                (yyval.declare) = _vretained occlass;
            ;}
    break;

  case 42:
#line 190 "cal.y"
    {
                OCClass *occlass = _transfer(OCClass *) (yyvsp[(1) - (4)].declare);
                [occlass.privateVariables addObjectsFromArray:_transfer(id) (yyvsp[(3) - (4)].declare)];
                (yyval.declare) = _vretained occlass;
            ;}
    break;

  case 43:
#line 196 "cal.y"
    {
                OCClass *occlass = _transfer(OCClass *) (yyvsp[(1) - (5)].declare);

                PropertyDeclare *property = [PropertyDeclare new];
                property.keywords = _transfer(NSMutableArray *) (yyvsp[(3) - (5)].declare);
                property.var = _transfer(VariableDeclare *) (yyvsp[(4) - (5)].declare);
                
                [occlass.properties addObject:property];
                (yyval.declare) = _vretained occlass;
            ;}
    break;

  case 46:
#line 213 "cal.y"
    {
                (yyval.implementation) = _vretained [LibAst classForName:_transfer(id)(yyvsp[(2) - (2)].identifier)];
            ;}
    break;

  case 47:
#line 218 "cal.y"
    {
                (yyval.implementation) = _vretained [LibAst classForName:_transfer(id)(yyvsp[(2) - (5)].identifier)];
            ;}
    break;

  case 48:
#line 222 "cal.y"
    {
                OCClass *occlass = _transfer(OCClass *) (yyvsp[(1) - (4)].implementation);
                [occlass.privateVariables addObjectsFromArray:_transfer(id) (yyvsp[(3) - (4)].declare)];
                (yyval.implementation) = _vretained occlass;
            ;}
    break;

  case 49:
#line 228 "cal.y"
    {
                MethodImplementation *imp = makeMethodImplementation(_transfer(MethodDeclare *) (yyvsp[(2) - (5)].declare));
                imp.imp = _transfer(FunctionImp *) (yyvsp[(4) - (5)].expression);
                OCClass *occlass = _transfer(OCClass *) (yyvsp[(1) - (5)].implementation);
                [occlass.methods addObject:imp];
                (yyval.implementation) = _vretained occlass;
            ;}
    break;

  case 51:
#line 238 "cal.y"
    {
				NSMutableArray *list = [NSMutableArray array];
				NSString *identifier = (__bridge_transfer NSString *)(yyvsp[(1) - (1)].identifier);
				[list addObject:identifier];
				(yyval.declare) = (__bridge_retained void *)list;
			;}
    break;

  case 52:
#line 245 "cal.y"
    {
				NSMutableArray *list = (__bridge_transfer NSMutableArray *)(yyvsp[(1) - (3)].declare);
				NSString *identifier = (__bridge_transfer NSString *)(yyvsp[(3) - (3)].identifier);
				[list addObject:identifier];
				(yyval.declare) = (__bridge_retained void *)list;
			;}
    break;

  case 53:
#line 254 "cal.y"
    {
                NSMutableArray *list = [NSMutableArray array];
				(yyval.declare) = (__bridge_retained void *)list;
            ;}
    break;

  case 54:
#line 259 "cal.y"
    {
                NSMutableArray *list = _transfer(NSMutableArray *) (yyvsp[(1) - (3)].declare);
				[list addObject:_transfer(VariableDeclare *) (yyvsp[(2) - (3)].declare)];
				(yyval.declare) = (__bridge_retained void *)list;
            ;}
    break;

  case 65:
#line 280 "cal.y"
    {
                NSMutableArray *list = [NSMutableArray array];
				(yyval.declare) = (__bridge_retained void *)list;
            ;}
    break;

  case 66:
#line 285 "cal.y"
    {
                NSMutableArray *list = [NSMutableArray array];
				(yyval.declare) = (__bridge_retained void *)list;
            ;}
    break;

  case 67:
#line 290 "cal.y"
    {
                NSMutableArray *list = _transfer(NSMutableArray *) (yyvsp[(1) - (3)].declare);
				[list addObject:_transfer(NSString *) (yyvsp[(2) - (3)].identifier)];
				(yyval.declare) = (__bridge_retained void *)list;
            ;}
    break;

  case 68:
#line 296 "cal.y"
    {
                NSMutableArray *list = _transfer(NSMutableArray *) (yyvsp[(1) - (3)].declare);
				[list addObject:_transfer(NSString *) (yyvsp[(2) - (3)].identifier)];
				(yyval.declare) = (__bridge_retained void *)list;
            ;}
    break;

  case 69:
#line 305 "cal.y"
    {
                (yyval.declare) = _vretained makeVariableDeclare((__bridge TypeSpecial *)(yyvsp[(1) - (2)].expression),(__bridge NSString *)(yyvsp[(2) - (2)].identifier));
            ;}
    break;

  case 70:
#line 309 "cal.y"
    {
                (yyval.declare) = _vretained makeVariableDeclare(makeTypeSpecial(SpecialTypeBlock),(__bridge NSString *)(yyvsp[(4) - (8)].identifier));
            ;}
    break;

  case 85:
#line 337 "cal.y"
    {
                (yyval.declare) = _vretained [NSMutableArray array];
            ;}
    break;

  case 86:
#line 341 "cal.y"
    {
                NSMutableArray *array = [NSMutableArray array];
                [array addObject:_transfer(id)(yyvsp[(1) - (1)].expression)];
                (yyval.declare) = _vretained array;
            ;}
    break;

  case 87:
#line 347 "cal.y"
    {
                NSMutableArray *array = _transfer(NSMutableArray *)(yyvsp[(1) - (3)].declare);
                [array addObject:_transfer(id) (yyvsp[(3) - (3)].expression)];
                (yyval.declare) = _vretained array;
            ;}
    break;

  case 88:
#line 356 "cal.y"
    {   
                (yyval.declare) = _vretained makeMethodDeclare(NO,_transfer(TypeSpecial *) (yyvsp[(3) - (4)].expression));
            ;}
    break;

  case 89:
#line 360 "cal.y"
    {
                (yyval.declare) = _vretained makeMethodDeclare(YES,_transfer(TypeSpecial *) (yyvsp[(3) - (4)].expression));
            ;}
    break;

  case 90:
#line 364 "cal.y"
    {
                MethodDeclare *method = _transfer(MethodDeclare *)(yyval.declare);
                [method.methodNames addObject:_transfer(NSString *) (yyvsp[(2) - (2)].identifier)];
                (yyval.declare) = _vretained method;
            ;}
    break;

  case 91:
#line 370 "cal.y"
    {
                MethodDeclare *method = _transfer(MethodDeclare *)(yyval.declare);
                [method.methodNames addObject:_transfer(NSString *) (yyvsp[(2) - (7)].identifier)];
                [method.parameterTypes addObject:_transfer(TypeSpecial *) (yyvsp[(5) - (7)].expression)];
                [method.parameterNames addObject:_transfer(NSString *) (yyvsp[(7) - (7)].identifier)];
                (yyval.declare) = _vretained method;
            ;}
    break;

  case 92:
#line 381 "cal.y"
    {
            OCMethodCallNormalElement *element = makeMethodCallElement(OCMethodCallNormalCall);
            [element.names addObject:_transfer(NSString *)(yyvsp[(1) - (1)].identifier)];
            (yyval.expression) = _vretained element;
        ;}
    break;

  case 93:
#line 387 "cal.y"
    {
            OCMethodCallNormalElement *element = makeMethodCallElement(OCMethodCallNormalCall);
            [element.names addObject:_transfer(NSString *)(yyvsp[(1) - (3)].identifier)];
            [element.values addObjectsFromArray:_transfer(id)(yyvsp[(3) - (3)].expression)];
            (yyval.expression) = _vretained element;
        ;}
    break;

  case 94:
#line 394 "cal.y"
    {
            OCMethodCallNormalElement *element = _transfer(OCMethodCallNormalElement *)(yyvsp[(1) - (4)].expression);
            [element.names addObject:_transfer(NSString *)(yyvsp[(2) - (4)].identifier)];
            [element.values addObjectsFromArray:_transfer(id)(yyvsp[(4) - (4)].expression)];
            (yyval.expression) = _vretained element;
        ;}
    break;

  case 95:
#line 404 "cal.y"
    {
             OCMethodCall *methodcall = (OCMethodCall *) makeValue(OCValueMethodCall);
             methodcall.caller =  makeValue(OCValueClassType,_typeId (yyvsp[(2) - (4)].identifier));
             methodcall.element = _transfer(id <OCMethodElement>)(yyvsp[(3) - (4)].expression);
             (yyval.expression) = _vretained methodcall;
        ;}
    break;

  case 96:
#line 411 "cal.y"
    {
             OCMethodCall *methodcall = (OCMethodCall *) makeValue(OCValueMethodCall);
             methodcall.caller =  makeValue(OCValueClassType,_typeId (yyvsp[(2) - (4)].identifier));
             methodcall.element = _transfer(id <OCMethodElement>)(yyvsp[(3) - (4)].expression);
             (yyval.expression) = _vretained methodcall;
        ;}
    break;

  case 97:
#line 418 "cal.y"
    {
             OCMethodCall *methodcall = (OCMethodCall *) makeValue(OCValueMethodCall);
             OCValue *caller = _transfer(OCValue *)(yyvsp[(2) - (4)].expression);
             methodcall.caller =  caller;
             methodcall.element = _transfer(id <OCMethodElement>)(yyvsp[(3) - (4)].expression);
             (yyval.expression) = _vretained methodcall;
        ;}
    break;

  case 98:
#line 430 "cal.y"
    {
            BlockImp *imp = (BlockImp *)makeValue(OCValueBlock);
            imp.funcImp = _transfer(id)(yyvsp[(4) - (5)].expression);
            imp.declare = makeFuncDeclare(_transfer(id)(yyvsp[(2) - (5)].expression),nil);
            (yyval.expression) = _vretained imp; 
        ;}
    break;

  case 99:
#line 438 "cal.y"
    {
            NSMutableArray *list = _typeId (yyvsp[(4) - (8)].declare);
            for (VariableDeclare *decalre in list){
               addVariableSymbol(decalre.name);
            }
            BlockImp *imp = (BlockImp *)makeValue(OCValueBlock);
            imp.declare = makeFuncDeclare(_transfer(id)(yyvsp[(2) - (8)].expression),list);
            imp.funcImp = _transfer(id)(yyvsp[(7) - (8)].expression);
            (yyval.expression) = _vretained imp; 
        ;}
    break;

  case 100:
#line 450 "cal.y"
    {
            BlockImp *imp = (BlockImp *)makeValue(OCValueBlock);
            imp.declare = makeFuncDeclare(makeTypeSpecial(SpecialTypeVoid),nil);
            imp.funcImp = _transfer(id)(yyvsp[(3) - (4)].expression);
            (yyval.expression) = _vretained imp; 
        ;}
    break;

  case 101:
#line 458 "cal.y"
    {
            NSMutableArray *list = _typeId (yyvsp[(3) - (7)].declare);
            for (VariableDeclare *decalre in list){
               addVariableSymbol(decalre.name);
            }
            BlockImp *imp = (BlockImp *)makeValue(OCValueBlock);
            log(list);
            imp.declare = makeFuncDeclare(makeTypeSpecial(SpecialTypeVoid),list);
            imp.funcImp = _transfer(id)(yyvsp[(6) - (7)].expression);
            (yyval.expression) = _vretained imp; 
        ;}
    break;

  case 102:
#line 474 "cal.y"
    {
             VariableDeclare *declare = _typeId (yyvsp[(1) - (1)].declare);
             log(@(declare.type.type));
             addVariableSymbol(declare.name);
             (yyval.expression) = _vretained makeDeclareExpression(declare);
         ;}
    break;

  case 103:
#line 481 "cal.y"
    {
             VariableDeclare *declare = _typeId (yyvsp[(1) - (3)].declare);
             addVariableSymbol(declare.name);
             DeclareExpression *exp = makeDeclareExpression(declare);
             exp.expression = _transfer(id) (yyvsp[(3) - (3)].expression);
             (yyval.expression) = _vretained exp;
         ;}
    break;

  case 107:
#line 496 "cal.y"
    {
            (yyval.statement) = _vretained makeReturnStatement(nil);
        ;}
    break;

  case 108:
#line 500 "cal.y"
    {
            (yyval.statement) = _vretained makeReturnStatement(_transfer(id)(yyvsp[(2) - (3)].expression));
        ;}
    break;

  case 109:
#line 504 "cal.y"
    {
            (yyval.statement) = _vretained makeBreakStatement();
        ;}
    break;

  case 110:
#line 508 "cal.y"
    {
            (yyval.statement) = _vretained makeContinueStatement();
        ;}
    break;

  case 111:
#line 515 "cal.y"
    {
            IfStatement *statement = makeIfStatement(_transfer(id) (yyvsp[(3) - (7)].expression),_transfer(FunctionImp *)(yyvsp[(5) - (7)].identifier));
            (yyval.statement) = _vretained statement;
         ;}
    break;

  case 112:
#line 520 "cal.y"
    {
            IfStatement *statement = _transfer(IfStatement *)(yyvsp[(1) - (9)].statement);
            IfStatement *elseIfStatement = makeIfStatement(_transfer(id) (yyvsp[(5) - (9)].expression),_transfer(FunctionImp *)(yyvsp[(8) - (9)].expression));
            elseIfStatement.last = statement;
            (yyval.statement)  = _vretained elseIfStatement;
        ;}
    break;

  case 113:
#line 527 "cal.y"
    {
            IfStatement *statement = _transfer(IfStatement *)(yyvsp[(1) - (5)].statement);
            IfStatement *elseStatement = makeIfStatement(nil,_transfer(FunctionImp *)(yyvsp[(4) - (5)].expression));
            elseStatement.last = statement;
            (yyval.statement)  = _vretained elseStatement;
        ;}
    break;

  case 114:
#line 537 "cal.y"
    {
            DoWhileStatement *statement = makeDoWhileStatement(_transfer(id)(yyvsp[(5) - (8)].identifier),_transfer(FunctionImp *)(yyvsp[(3) - (8)].expression));
            (yyval.statement) = _vretained statement;
        ;}
    break;

  case 115:
#line 544 "cal.y"
    {
            WhileStatement *statement = makeWhileStatement(_transfer(id)(yyvsp[(3) - (7)].expression),_transfer(FunctionImp *)(yyvsp[(6) - (7)].expression));
            (yyval.statement) = _vretained statement;
        ;}
    break;

  case 116:
#line 559 "cal.y"
    {
             (yyval.statement) = _vretained makeCaseStatement(_transfer(OCValue *)(yyvsp[(2) - (3)].expression));
         ;}
    break;

  case 117:
#line 563 "cal.y"
    {
            (yyval.statement) = _vretained makeCaseStatement(nil);
        ;}
    break;

  case 118:
#line 567 "cal.y"
    {
            CaseStatement *statement =  _transfer(CaseStatement *)(yyvsp[(1) - (4)].statement);
            statement.funcImp = _transfer(FunctionImp *) (yyvsp[(3) - (4)].expression);
            (yyval.statement) = _vretained statement;
        ;}
    break;

  case 119:
#line 575 "cal.y"
    {
             SwitchStatement *statement = makeSwitchStatement(_transfer(id) (yyvsp[(3) - (5)].expression));
             (yyval.statement) = _vretained statement;
         ;}
    break;

  case 120:
#line 580 "cal.y"
    {
            SwitchStatement *statement = _transfer(SwitchStatement *)(yyvsp[(1) - (2)].statement);
            [statement.cases addObject:_transfer(id) (yyvsp[(2) - (2)].statement)];
            (yyval.statement) = _vretained statement;
        ;}
    break;

  case 122:
#line 594 "cal.y"
    {
            NSMutableArray *expressions = [NSMutableArray array];
            [expressions addObject:_transfer(id)(yyvsp[(1) - (1)].expression)];
            (yyval.expression) = _vretained expressions;
        ;}
    break;

  case 123:
#line 600 "cal.y"
    {
            NSMutableArray *expressions = _transfer(NSMutableArray *)(yyval.expression);
            [expressions addObject:_transfer(id) (yyvsp[(3) - (3)].expression)];
            (yyval.expression) = _vretained expressions;
        ;}
    break;

  case 124:
#line 607 "cal.y"
    {
            ForStatement* statement = makeForStatement(_transfer(FunctionImp *) (yyvsp[(8) - (9)].expression));
            NSMutableArray *list = _typeId (yyvsp[(5) - (9)].expression);
            [list insertObject:_typeId (yyvsp[(3) - (9)].expression) atIndex:0];
            statement.expressions = list;
            (yyval.statement) = _vretained statement;
        ;}
    break;

  case 125:
#line 617 "cal.y"
    {
            ForInStatement * statement = makeForInStatement(_transfer(FunctionImp *)(yyvsp[(8) - (9)].expression));
            statement.declare = _transfer(id) (yyvsp[(3) - (9)].declare);
            statement.value = _transfer(id)(yyvsp[(5) - (9)].expression);
            (yyval.statement) = _vretained statement;
        ;}
    break;

  case 132:
#line 637 "cal.y"
    {
            (yyval.expression) = _vretained makeFuncImp();
        ;}
    break;

  case 133:
#line 641 "cal.y"
    {
            FunctionImp *imp = _transfer(FunctionImp *)(yyvsp[(1) - (2)].expression);
            [imp.statements addObject:_transfer(id) (yyvsp[(2) - (2)].statement)];
            (yyval.expression) = _vretained imp;
        ;}
    break;

  case 134:
#line 647 "cal.y"
    {
            FunctionImp *imp = _transfer(FunctionImp *)(yyvsp[(1) - (2)].expression);
            [imp.statements addObject:_transfer(id) (yyvsp[(2) - (2)].statement)];
            (yyval.expression) = _vretained imp;
        ;}
    break;

  case 136:
#line 657 "cal.y"
    {
            NSMutableArray *list = [NSMutableArray array];
            [list addObject:_transfer(id)(yyvsp[(1) - (1)].expression)];
            (yyval.expression) = _vretained list;
        ;}
    break;

  case 137:
#line 663 "cal.y"
    {
            NSMutableArray *list = (__bridge_transfer NSMutableArray *)(yyvsp[(1) - (3)].expression);
            [list addObject:_transfer(id) (yyvsp[(3) - (3)].expression)];
            (yyval.expression) = (__bridge_retained void *)list;
        ;}
    break;

  case 138:
#line 672 "cal.y"
    {
            (yyval.Operator) = AssignOperatorAssign;
        ;}
    break;

  case 139:
#line 676 "cal.y"
    {
            (yyval.Operator) = AssignOperatorAssignAnd;
        ;}
    break;

  case 140:
#line 680 "cal.y"
    {
            (yyval.Operator) = AssignOperatorAssignOr;
        ;}
    break;

  case 141:
#line 684 "cal.y"
    {
            (yyval.Operator) = AssignOperatorAssignXor;
        ;}
    break;

  case 142:
#line 688 "cal.y"
    {
            (yyval.Operator) = AssignOperatorAssignAdd;
        ;}
    break;

  case 143:
#line 692 "cal.y"
    {
            (yyval.Operator) = AssignOperatorAssignSub;
        ;}
    break;

  case 144:
#line 696 "cal.y"
    {
            (yyval.Operator) = AssignOperatorAssignDiv;
        ;}
    break;

  case 145:
#line 700 "cal.y"
    {
            (yyval.Operator) = AssignOperatorAssignMuti;
        ;}
    break;

  case 146:
#line 704 "cal.y"
    {
            (yyval.Operator) = AssignOperatorAssignMod;
        ;}
    break;

  case 148:
#line 712 "cal.y"
    {
        AssignExpression *expression = makeAssignExpression((yyvsp[(2) - (3)].Operator));
        expression.expression = _transfer(id) (yyvsp[(1) - (3)].expression);
        expression.value = _transfer(OCValue *)(yyvsp[(3) - (3)].expression);
        (yyval.expression) = _vretained expression;
    ;}
    break;

  case 150:
#line 723 "cal.y"
    {
        TernaryExpression *expression = makeTernaryExpression();
        expression.expression = _transfer(id)(yyvsp[(1) - (5)].expression);
        [expression.values addObject:_transfer(id)(yyvsp[(3) - (5)].expression)];
        [expression.values addObject:_transfer(id)(yyvsp[(5) - (5)].expression)];
        (yyval.expression) = _vretained expression;
    ;}
    break;

  case 151:
#line 731 "cal.y"
    {
        TernaryExpression *expression = makeTernaryExpression();
        expression.expression = _transfer(id)(yyvsp[(1) - (4)].expression);
        [expression.values addObject:_transfer(id)(yyvsp[(4) - (4)].expression)];
        (yyval.expression) = _vretained expression;
    ;}
    break;

  case 153:
#line 743 "cal.y"
    {
        BinaryExpression *exp = makeBinaryExpression(BinaryOperatorLOGIC_OR);
        exp.left = _transfer(id) (yyvsp[(1) - (3)].expression);
        exp.right = _transfer(id) (yyvsp[(3) - (3)].expression);
        (yyval.expression) = _vretained exp;
    ;}
    break;

  case 155:
#line 754 "cal.y"
    {
        BinaryExpression *exp = makeBinaryExpression(BinaryOperatorLOGIC_AND);
        exp.left = _transfer(id) (yyvsp[(1) - (3)].expression);
        exp.right = _transfer(id) (yyvsp[(3) - (3)].expression);
        (yyval.expression) = _vretained exp;
    ;}
    break;

  case 157:
#line 764 "cal.y"
    {
        BinaryExpression *exp = makeBinaryExpression(BinaryOperatorOr);
        exp.left = _transfer(id) (yyvsp[(1) - (3)].expression);
        exp.right = _transfer(id) (yyvsp[(3) - (3)].expression);
        (yyval.expression) = _vretained exp;
    ;}
    break;

  case 159:
#line 774 "cal.y"
    {
        BinaryExpression *exp = makeBinaryExpression(BinaryOperatorXor);
        exp.left = _transfer(id) (yyvsp[(1) - (3)].expression);
        exp.right = _transfer(id) (yyvsp[(3) - (3)].expression);
        (yyval.expression) = _vretained exp;
    ;}
    break;

  case 161:
#line 785 "cal.y"
    {
        BinaryExpression *exp = makeBinaryExpression(BinaryOperatorAnd);
        exp.left = _transfer(id) (yyvsp[(1) - (3)].expression);
        exp.right = _transfer(id) (yyvsp[(3) - (3)].expression);
        (yyval.expression) = _vretained exp;
    ;}
    break;

  case 163:
#line 796 "cal.y"
    {
        BinaryExpression *exp = makeBinaryExpression(BinaryOperatorEqual);
        exp.left = _transfer(id) (yyvsp[(1) - (3)].expression);
        exp.right = _transfer(id) (yyvsp[(3) - (3)].expression);
        (yyval.expression) = _vretained exp;
    ;}
    break;

  case 164:
#line 803 "cal.y"
    {
        BinaryExpression *exp = makeBinaryExpression(BinaryOperatorNotEqual);
        exp.left = _transfer(id) (yyvsp[(1) - (3)].expression);
        exp.right = _transfer(id) (yyvsp[(3) - (3)].expression);
        (yyval.expression) = _vretained exp;
    ;}
    break;

  case 166:
#line 813 "cal.y"
    {
        BinaryExpression *exp = makeBinaryExpression(BinaryOperatorLT);
        exp.left = _transfer(id) (yyvsp[(1) - (3)].expression);
        exp.right = _transfer(id) (yyvsp[(3) - (3)].expression);
        (yyval.expression) = _vretained exp;
    ;}
    break;

  case 167:
#line 820 "cal.y"
    {
        BinaryExpression *exp = makeBinaryExpression(BinaryOperatorLE);
        exp.left = _transfer(id) (yyvsp[(1) - (3)].expression);
        exp.right = _transfer(id) (yyvsp[(3) - (3)].expression);
        (yyval.expression) = _vretained exp;
    ;}
    break;

  case 168:
#line 827 "cal.y"
    {
        BinaryExpression *exp = makeBinaryExpression(BinaryOperatorGT);
        exp.left = _transfer(id) (yyvsp[(1) - (3)].expression);
        exp.right = _transfer(id) (yyvsp[(3) - (3)].expression);
        (yyval.expression) = _vretained exp;
    ;}
    break;

  case 169:
#line 834 "cal.y"
    {
        BinaryExpression *exp = makeBinaryExpression(BinaryOperatorGE);
        exp.left = _transfer(id) (yyvsp[(1) - (3)].expression);
        exp.right = _transfer(id) (yyvsp[(3) - (3)].expression);
        (yyval.expression) = _vretained exp;
    ;}
    break;

  case 171:
#line 844 "cal.y"
    {
        BinaryExpression *exp = makeBinaryExpression(BinaryOperatorShiftLeft);
        exp.left = _transfer(id) (yyvsp[(1) - (3)].expression);
        exp.right = _transfer(id) (yyvsp[(3) - (3)].expression);
        (yyval.expression) = _vretained exp;
    ;}
    break;

  case 172:
#line 851 "cal.y"
    {
        BinaryExpression *exp = makeBinaryExpression(BinaryOperatorShiftRight);
        exp.left = _transfer(id) (yyvsp[(1) - (3)].expression);
        exp.right = _transfer(id) (yyvsp[(3) - (3)].expression);
        (yyval.expression) = _vretained exp;
    ;}
    break;

  case 174:
#line 861 "cal.y"
    {
        BinaryExpression *exp = makeBinaryExpression(BinaryOperatorAdd);
        exp.left = _transfer(id) (yyvsp[(1) - (3)].expression);
        exp.right = _transfer(id) (yyvsp[(3) - (3)].expression);
        (yyval.expression) = _vretained exp;
    ;}
    break;

  case 175:
#line 868 "cal.y"
    {
        BinaryExpression *exp = makeBinaryExpression(BinaryOperatorSub);
        exp.left = _transfer(id) (yyvsp[(1) - (3)].expression);
        exp.right = _transfer(id) (yyvsp[(3) - (3)].expression);
        (yyval.expression) = _vretained exp;
    ;}
    break;

  case 177:
#line 879 "cal.y"
    {
        BinaryExpression *exp = makeBinaryExpression(BinaryOperatorMulti);
        exp.left = _transfer(id) (yyvsp[(1) - (3)].expression);
        exp.right = _transfer(id) (yyvsp[(3) - (3)].expression);
        (yyval.expression) = _vretained exp;
    ;}
    break;

  case 178:
#line 886 "cal.y"
    {
        BinaryExpression *exp = makeBinaryExpression(BinaryOperatorDiv);
        exp.left = _transfer(id) (yyvsp[(1) - (3)].expression);
        exp.right = _transfer(id) (yyvsp[(3) - (3)].expression);
        (yyval.expression) = _vretained exp;
    ;}
    break;

  case 179:
#line 893 "cal.y"
    {
        BinaryExpression *exp = makeBinaryExpression(BinaryOperatorMod);
        exp.left = _transfer(id) (yyvsp[(1) - (3)].expression);
        exp.right = _transfer(id) (yyvsp[(3) - (3)].expression);
        (yyval.expression) = _vretained exp;
    ;}
    break;

  case 181:
#line 904 "cal.y"
    {
        UnaryExpression *exp = makeUnaryExpression(UnaryOperatorNot);
        exp.value = _transfer(id)(yyvsp[(2) - (2)].expression);
        (yyval.expression) = _vretained exp;
    ;}
    break;

  case 182:
#line 910 "cal.y"
    {
        UnaryExpression *exp = makeUnaryExpression(UnaryOperatorNegative);
        exp.value = _transfer(id)(yyvsp[(2) - (2)].expression);
        (yyval.expression) = _vretained exp;
    ;}
    break;

  case 183:
#line 916 "cal.y"
    {
        UnaryExpression *exp = makeUnaryExpression(UnaryOperatorPointValue);
        exp.value = _transfer(id)(yyvsp[(2) - (2)].expression);
        (yyval.expression) = _vretained exp;
    ;}
    break;

  case 184:
#line 922 "cal.y"
    {
        UnaryExpression *exp = makeUnaryExpression(UnaryOperatorAdressPoint);
        exp.value = _transfer(id)(yyvsp[(2) - (2)].expression);
        (yyval.expression) = _vretained exp;
    ;}
    break;

  case 185:
#line 928 "cal.y"
    {
        UnaryExpression *exp = makeUnaryExpression(UnaryOperatorBiteNot);
        exp.value = _transfer(id)(yyvsp[(2) - (2)].expression);
        (yyval.expression) = _vretained exp;
    ;}
    break;

  case 186:
#line 934 "cal.y"
    {
        UnaryExpression *exp = makeUnaryExpression(UnaryOperatorSizeOf);
        exp.value = _transfer(id)(yyvsp[(2) - (2)].expression);
        (yyval.expression) = _vretained exp;
    ;}
    break;

  case 187:
#line 940 "cal.y"
    {
        (yyval.expression) = (yyvsp[(4) - (4)].expression);
    ;}
    break;

  case 188:
#line 944 "cal.y"
    {
        UnaryExpression *exp = makeUnaryExpression(UnaryOperatorIncrementSuffix);
        exp.value = _transfer(id)(yyvsp[(1) - (2)].expression);
        (yyval.expression) = _vretained exp;
    ;}
    break;

  case 189:
#line 950 "cal.y"
    {
        UnaryExpression *exp = makeUnaryExpression(UnaryOperatorDecrementSuffix);
        exp.value = _transfer(id)(yyvsp[(1) - (2)].expression);
        (yyval.expression) = _vretained exp;
    ;}
    break;

  case 190:
#line 956 "cal.y"
    {
        UnaryExpression *exp = makeUnaryExpression(UnaryOperatorIncrementPrefix);
        exp.value = _transfer(id)(yyvsp[(2) - (2)].expression);
        (yyval.expression) = _vretained exp;
    ;}
    break;

  case 191:
#line 962 "cal.y"
    {
        UnaryExpression *exp = makeUnaryExpression(UnaryOperatorDecrementPrefix);
        exp.value = _transfer(id)(yyvsp[(2) - (2)].expression);
        (yyval.expression) = _vretained exp;
    ;}
    break;

  case 192:
#line 971 "cal.y"
    {
            (yyval.expression) = _vretained makeValue(OCValueInt,_transfer(id)(yyvsp[(1) - (1)].identifier));
        ;}
    break;

  case 193:
#line 975 "cal.y"
    {
            (yyval.expression) = _vretained makeValue(OCValueInt,_transfer(id)(yyvsp[(1) - (1)].identifier));
        ;}
    break;

  case 194:
#line 981 "cal.y"
    {
            NSMutableArray *array = [NSMutableArray array];
            [array addObject:@[_transfer(id)(yyvsp[(1) - (3)].expression),_transfer(id)(yyvsp[(3) - (3)].expression)]];
            (yyval.expression) = _vretained array;
        ;}
    break;

  case 195:
#line 987 "cal.y"
    {
            NSMutableArray *array = _transfer(id)(yyvsp[(1) - (5)].expression);
            [array addObject:@[_transfer(id)(yyvsp[(3) - (5)].expression),_transfer(id)(yyvsp[(5) - (5)].expression)]];
            (yyval.expression) = _vretained array;
        ;}
    break;

  case 198:
#line 1001 "cal.y"
    {
            (yyval.expression) = _vretained makeValue(OCValueVariable,_transfer(id) (yyvsp[(1) - (1)].identifier));
        ;}
    break;

  case 199:
#line 1005 "cal.y"
    {
            (yyval.expression) = _vretained makeValue(OCValueSelf);
        ;}
    break;

  case 200:
#line 1009 "cal.y"
    {
            (yyval.expression) = _vretained makeValue(OCValueSuper);
        ;}
    break;

  case 202:
#line 1014 "cal.y"
    {
            OCMethodCall *methodcall = (OCMethodCall *) makeValue(OCValueMethodCall);
            methodcall.caller =  _transfer(OCValue *)(yyvsp[(1) - (3)].expression);
            OCMethodCallGetElement *element = makeMethodCallElement(OCMethodCallDotGet);
            element.name = _transfer(NSString *)(yyvsp[(3) - (3)].identifier);
            methodcall.element = element;
            (yyval.expression) = _vretained methodcall;

        ;}
    break;

  case 203:
#line 1024 "cal.y"
    {
            OCMethodCall *methodcall = (OCMethodCall *) makeValue(OCValueMethodCall);
            methodcall.caller =  _transfer(OCValue *)(yyvsp[(1) - (3)].expression);
            OCMethodCallGetElement *element = makeMethodCallElement(OCMethodCallDotGet);
            element.name = _transfer(NSString *)(yyvsp[(3) - (3)].identifier);
            methodcall.element = element;
            (yyval.expression) = _vretained methodcall;
        ;}
    break;

  case 204:
#line 1033 "cal.y"
    {
            id object = _transfer(id) (yyvsp[(1) - (4)].expression);
            if([object isKindOfClass:[NSString class]]){
                CFuncCall *call = (CFuncCall *)makeValue(OCValueFuncCall);
                call.name = _transfer(id) (yyvsp[(1) - (4)].expression);
                call.expressions = _transfer(id) (yyvsp[(3) - (4)].expression);
                (yyval.expression) = _vretained call;
            }else if([object isKindOfClass:[OCMethodCall class]]){
                OCMethodCall *methodcall = _transfer(OCMethodCall *) (yyvsp[(1) - (4)].expression);
                OCMethodCallGetElement *element = methodcall.element;
                [element.values addObjectsFromArray:_transfer(id) (yyvsp[(3) - (4)].expression)];
                (yyval.expression) = _vretained methodcall;
            }
        ;}
    break;

  case 205:
#line 1048 "cal.y"
    {
            (yyval.expression) = (yyvsp[(2) - (3)].expression);
        ;}
    break;

  case 206:
#line 1052 "cal.y"
    {
            (yyval.expression) = _vretained makeValue(OCValueDictionary,_transfer(id)(yyvsp[(3) - (4)].expression));
        ;}
    break;

  case 207:
#line 1056 "cal.y"
    {
            (yyval.expression) = _vretained makeValue(OCValueArray,_transfer(id)(yyvsp[(3) - (4)].expression));
        ;}
    break;

  case 208:
#line 1060 "cal.y"
    {
            (yyval.expression) = _vretained makeValue(OCValueNSNumber,_transfer(id)(yyvsp[(3) - (4)].expression));
        ;}
    break;

  case 209:
#line 1064 "cal.y"
    {
            (yyval.expression) = _vretained makeValue(OCValueNSNumber,_transfer(id)(yyvsp[(2) - (2)].expression));
        ;}
    break;

  case 210:
#line 1068 "cal.y"
    {
            (yyval.expression) = _vretained makeValue(OCValueString);
        ;}
    break;

  case 211:
#line 1072 "cal.y"
    {
            (yyval.expression) = _vretained makeValue(OCValueSelector,_transfer(id)(yyvsp[(1) - (1)].identifier));
        ;}
    break;

  case 212:
#line 1076 "cal.y"
    {
            (yyval.expression) = _vretained makeValue(OCValueProtocol,_transfer(id)(yyvsp[(3) - (4)].identifier));
        ;}
    break;

  case 213:
#line 1080 "cal.y"
    {
            (yyval.expression) = _vretained makeValue(OCValueCString,_transfer(id)(yyvsp[(1) - (1)].identifier));
        ;}
    break;

  case 216:
#line 1086 "cal.y"
    {
            (yyval.expression) = _vretained makeValue(OCValueNil);
        ;}
    break;

  case 217:
#line 1090 "cal.y"
    {
            (yyval.expression) = _vretained makeValue(OCValueNULL);
        ;}
    break;

  case 218:
#line 1098 "cal.y"
    {
                (yyval.expression) = (yyvsp[(2) - (2)].expression);
            ;}
    break;

  case 221:
#line 1104 "cal.y"
    {
                (yyval.expression) = _vretained makeTypeSpecial(SpecialTypeObject,@"typeof");
            ;}
    break;

  case 222:
#line 1108 "cal.y"
    {
                 (yyval.expression) = _vretained makeTypeSpecial(SpecialTypeUChar);
            ;}
    break;

  case 223:
#line 1112 "cal.y"
    {
                (yyval.expression) = _vretained makeTypeSpecial(SpecialTypeUShort);
            ;}
    break;

  case 224:
#line 1116 "cal.y"
    {
                (yyval.expression) = _vretained makeTypeSpecial(SpecialTypeUInt);
            ;}
    break;

  case 225:
#line 1120 "cal.y"
    {
                (yyval.expression) = _vretained makeTypeSpecial(SpecialTypeULong);
            ;}
    break;

  case 226:
#line 1124 "cal.y"
    {
                (yyval.expression) = _vretained makeTypeSpecial(SpecialTypeULongLong);
            ;}
    break;

  case 227:
#line 1128 "cal.y"
    {
                (yyval.expression) = _vretained makeTypeSpecial(SpecialTypeChar);
            ;}
    break;

  case 228:
#line 1132 "cal.y"
    {
                (yyval.expression) = _vretained makeTypeSpecial(SpecialTypeShort);
            ;}
    break;

  case 229:
#line 1136 "cal.y"
    {
                (yyval.expression) = _vretained makeTypeSpecial(SpecialTypeInt);
            ;}
    break;

  case 230:
#line 1140 "cal.y"
    {
                (yyval.expression) = _vretained makeTypeSpecial(SpecialTypeLong);
            ;}
    break;

  case 231:
#line 1144 "cal.y"
    {
                (yyval.expression) = _vretained makeTypeSpecial(SpecialTypeLongLong);
            ;}
    break;

  case 232:
#line 1148 "cal.y"
    {
                (yyval.expression) = _vretained makeTypeSpecial(SpecialTypeDouble);
            ;}
    break;

  case 233:
#line 1152 "cal.y"
    {
                (yyval.expression) = _vretained makeTypeSpecial(SpecialTypeFloat);
            ;}
    break;

  case 234:
#line 1156 "cal.y"
    {
                (yyval.expression) = _vretained makeTypeSpecial(SpecialTypeClass);
            ;}
    break;

  case 235:
#line 1160 "cal.y"
    {
                (yyval.expression) = _vretained makeTypeSpecial(SpecialTypeBOOL);
            ;}
    break;

  case 236:
#line 1164 "cal.y"
    {
                (yyval.expression) = _vretained makeTypeSpecial(SpecialTypeVoid);
            ;}
    break;

  case 237:
#line 1168 "cal.y"
    {
                (yyval.expression) = _vretained makeTypeSpecial(SpecialTypeId);
            ;}
    break;

  case 238:
#line 1178 "cal.y"
    {
                (yyval.expression) = _vretained makeTypeSpecial(SpecialTypeObject,(__bridge NSString *)(yyvsp[(1) - (1)].identifier));
            ;}
    break;

  case 239:
#line 1182 "cal.y"
    {
                (yyval.expression) = _vretained makeTypeSpecial(SpecialTypeId);
            ;}
    break;

  case 240:
#line 1187 "cal.y"
    {
                (yyval.expression) = _vretained makeTypeSpecial(SpecialTypeBlock);
            ;}
    break;

  case 241:
#line 1191 "cal.y"
    {
                TypeSpecial *type = _transfer(id) (yyvsp[(1) - (2)].expression);
                type.isPointer = YES;
                (yyval.expression) = _vretained type;
            ;}
    break;


/* Line 1267 of yacc.c.  */
#line 4000 "cal.tab.c"
      default: break;
    }
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;


  /* Now `shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */

  yyn = yyr1[yyn];

  yystate = yypgoto[yyn - YYNTOKENS] + *yyssp;
  if (0 <= yystate && yystate <= YYLAST && yycheck[yystate] == *yyssp)
    yystate = yytable[yystate];
  else
    yystate = yydefgoto[yyn - YYNTOKENS];

  goto yynewstate;


/*------------------------------------.
| yyerrlab -- here on detecting error |
`------------------------------------*/
yyerrlab:
  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if ! YYERROR_VERBOSE
      yyerror (YY_("syntax error"));
#else
      {
	YYSIZE_T yysize = yysyntax_error (0, yystate, yychar);
	if (yymsg_alloc < yysize && yymsg_alloc < YYSTACK_ALLOC_MAXIMUM)
	  {
	    YYSIZE_T yyalloc = 2 * yysize;
	    if (! (yysize <= yyalloc && yyalloc <= YYSTACK_ALLOC_MAXIMUM))
	      yyalloc = YYSTACK_ALLOC_MAXIMUM;
	    if (yymsg != yymsgbuf)
	      YYSTACK_FREE (yymsg);
	    yymsg = (char *) YYSTACK_ALLOC (yyalloc);
	    if (yymsg)
	      yymsg_alloc = yyalloc;
	    else
	      {
		yymsg = yymsgbuf;
		yymsg_alloc = sizeof yymsgbuf;
	      }
	  }

	if (0 < yysize && yysize <= yymsg_alloc)
	  {
	    (void) yysyntax_error (yymsg, yystate, yychar);
	    yyerror (yymsg);
	  }
	else
	  {
	    yyerror (YY_("syntax error"));
	    if (yysize != 0)
	      goto yyexhaustedlab;
	  }
      }
#endif
    }



  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse look-ahead token after an
	 error, discard it.  */

      if (yychar <= YYEOF)
	{
	  /* Return failure if at end of input.  */
	  if (yychar == YYEOF)
	    YYABORT;
	}
      else
	{
	  yydestruct ("Error: discarding",
		      yytoken, &yylval);
	  yychar = YYEMPTY;
	}
    }

  /* Else will try to reuse look-ahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:

  /* Pacify compilers like GCC when the user code never invokes
     YYERROR and the label yyerrorlab therefore never appears in user
     code.  */
  if (/*CONSTCOND*/ 0)
     goto yyerrorlab;

  /* Do not reclaim the symbols of the rule which action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;	/* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (yyn != YYPACT_NINF)
	{
	  yyn += YYTERROR;
	  if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
	    {
	      yyn = yytable[yyn];
	      if (0 < yyn)
		break;
	    }
	}

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
	YYABORT;


      yydestruct ("Error: popping",
		  yystos[yystate], yyvsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  if (yyn == YYFINAL)
    YYACCEPT;

  *++yyvsp = yylval;


  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", yystos[yyn], yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;

/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;

#ifndef yyoverflow
/*-------------------------------------------------.
| yyexhaustedlab -- memory exhaustion comes here.  |
`-------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  /* Fall through.  */
#endif

yyreturn:
  if (yychar != YYEOF && yychar != YYEMPTY)
     yydestruct ("Cleanup: discarding lookahead",
		 yytoken, &yylval);
  /* Do not reclaim the symbols of the rule which action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
		  yystos[*yyssp], yyvsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
#if YYERROR_VERBOSE
  if (yymsg != yymsgbuf)
    YYSTACK_FREE (yymsg);
#endif
  /* Make sure YYID is used.  */
  return YYID (yyresult);
}


#line 1199 "cal.y"

void yyerror(const char *s){
    extern unsigned long yylineno , yycolumn , yylen;
    extern char const *st_source_string;
    NSArray *lines = [[NSString stringWithUTF8String:st_source_string] componentsSeparatedByString:@"\n"];
    if(lines.count < yylineno) return;
    NSString *line = lines[yylineno - 1];
    unsigned long location = yycolumn - yylen - 1;
    unsigned long len = yylen;
    NSMutableString *str = [NSMutableString string];
    for (unsigned i = 0; i < location; i++){
        [str appendString:@" "];
    }
    for (unsigned i = 0; i < len; i++){
        [str appendString:@"^"];
    }
    NSString *errorInfo = [NSString stringWithFormat:@"\n------yyerror------\n%@\n%@\n error: %s\n-------------------\n",line,str,s];
    OCParser.error = errorInfo;
    log(OCParser.error);
    log(LibAst.globalStatements);

}


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
     IF = 258,
     ENDIF = 259,
     IFDEF = 260,
     IFNDEF = 261,
     UNDEF = 262,
     IMPORT = 263,
     INCLUDE = 264,
     QUESTION = 265,
     _return = 266,
     _break = 267,
     _continue = 268,
     _goto = 269,
     _else = 270,
     _while = 271,
     _do = 272,
     _in = 273,
     _for = 274,
     _case = 275,
     _switch = 276,
     _default = 277,
     _enum = 278,
     _typeof = 279,
     _struct = 280,
     INTERFACE = 281,
     IMPLEMENTATION = 282,
     PROTOCOL = 283,
     END = 284,
     CLASS_DECLARE = 285,
     PROPERTY = 286,
     WEAK = 287,
     STRONG = 288,
     COPY = 289,
     ASSIGN_MEM = 290,
     NONATOMIC = 291,
     ATOMIC = 292,
     READONLY = 293,
     READWRITE = 294,
     NONNULL = 295,
     NULLABLE = 296,
     EXTERN = 297,
     STATIC = 298,
     CONST = 299,
     _NONNULL = 300,
     _NULLABLE = 301,
     _STRONG = 302,
     _WEAK = 303,
     _BLOCK = 304,
     IDENTIFIER = 305,
     STRING_LITERAL = 306,
     COMMA = 307,
     COLON = 308,
     SEMICOLON = 309,
     LP = 310,
     RP = 311,
     RIP = 312,
     LB = 313,
     RB = 314,
     LC = 315,
     RC = 316,
     DOT = 317,
     AT = 318,
     PS = 319,
     EQ = 320,
     NE = 321,
     LT = 322,
     LE = 323,
     GT = 324,
     GE = 325,
     LOGIC_AND = 326,
     LOGIC_OR = 327,
     LOGIC_NOT = 328,
     AND = 329,
     OR = 330,
     POWER = 331,
     SUB = 332,
     ADD = 333,
     DIV = 334,
     ASTERISK = 335,
     AND_ASSIGN = 336,
     OR_ASSIGN = 337,
     POWER_ASSIGN = 338,
     SUB_ASSIGN = 339,
     ADD_ASSIGN = 340,
     DIV_ASSIGN = 341,
     ASTERISK_ASSIGN = 342,
     INCREMENT = 343,
     DECREMENT = 344,
     SHIFTLEFT = 345,
     SHIFTRIGHT = 346,
     MOD = 347,
     ASSIGN = 348,
     MOD_ASSIGN = 349,
     _self = 350,
     _super = 351,
     _nil = 352,
     _NULL = 353,
     _YES = 354,
     _NO = 355,
     _Class = 356,
     _id = 357,
     _void = 358,
     _BOOL = 359,
     _SEL = 360,
     _CHAR = 361,
     _SHORT = 362,
     _INT = 363,
     _LONG = 364,
     _LLONG = 365,
     _UCHAR = 366,
     _USHORT = 367,
     _UINT = 368,
     _ULONG = 369,
     _ULLONG = 370,
     _DOUBLE = 371,
     _FLOAT = 372,
     _instancetype = 373,
     INTETER_LITERAL = 374,
     DOUBLE_LITERAL = 375,
     SELECTOR = 376
   };
#endif
/* Tokens.  */
#define IF 258
#define ENDIF 259
#define IFDEF 260
#define IFNDEF 261
#define UNDEF 262
#define IMPORT 263
#define INCLUDE 264
#define QUESTION 265
#define _return 266
#define _break 267
#define _continue 268
#define _goto 269
#define _else 270
#define _while 271
#define _do 272
#define _in 273
#define _for 274
#define _case 275
#define _switch 276
#define _default 277
#define _enum 278
#define _typeof 279
#define _struct 280
#define INTERFACE 281
#define IMPLEMENTATION 282
#define PROTOCOL 283
#define END 284
#define CLASS_DECLARE 285
#define PROPERTY 286
#define WEAK 287
#define STRONG 288
#define COPY 289
#define ASSIGN_MEM 290
#define NONATOMIC 291
#define ATOMIC 292
#define READONLY 293
#define READWRITE 294
#define NONNULL 295
#define NULLABLE 296
#define EXTERN 297
#define STATIC 298
#define CONST 299
#define _NONNULL 300
#define _NULLABLE 301
#define _STRONG 302
#define _WEAK 303
#define _BLOCK 304
#define IDENTIFIER 305
#define STRING_LITERAL 306
#define COMMA 307
#define COLON 308
#define SEMICOLON 309
#define LP 310
#define RP 311
#define RIP 312
#define LB 313
#define RB 314
#define LC 315
#define RC 316
#define DOT 317
#define AT 318
#define PS 319
#define EQ 320
#define NE 321
#define LT 322
#define LE 323
#define GT 324
#define GE 325
#define LOGIC_AND 326
#define LOGIC_OR 327
#define LOGIC_NOT 328
#define AND 329
#define OR 330
#define POWER 331
#define SUB 332
#define ADD 333
#define DIV 334
#define ASTERISK 335
#define AND_ASSIGN 336
#define OR_ASSIGN 337
#define POWER_ASSIGN 338
#define SUB_ASSIGN 339
#define ADD_ASSIGN 340
#define DIV_ASSIGN 341
#define ASTERISK_ASSIGN 342
#define INCREMENT 343
#define DECREMENT 344
#define SHIFTLEFT 345
#define SHIFTRIGHT 346
#define MOD 347
#define ASSIGN 348
#define MOD_ASSIGN 349
#define _self 350
#define _super 351
#define _nil 352
#define _NULL 353
#define _YES 354
#define _NO 355
#define _Class 356
#define _id 357
#define _void 358
#define _BOOL 359
#define _SEL 360
#define _CHAR 361
#define _SHORT 362
#define _INT 363
#define _LONG 364
#define _LLONG 365
#define _UCHAR 366
#define _USHORT 367
#define _UINT 368
#define _ULONG 369
#define _ULLONG 370
#define _DOUBLE 371
#define _FLOAT 372
#define _instancetype 373
#define INTETER_LITERAL 374
#define DOUBLE_LITERAL 375
#define SELECTOR 376




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
#line 14 "cal.y"
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
#line 363 "cal.tab.c"
	YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif



/* Copy the second part of user declarations.  */


/* Line 216 of yacc.c.  */
#line 376 "cal.tab.c"

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
#define YYFINAL  140
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   2830

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  122
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  55
/* YYNRULES -- Number of rules.  */
#define YYNRULES  216
/* YYNRULES -- Number of states.  */
#define YYNSTATES  397

/* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   376

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
     115,   116,   117,   118,   119,   120,   121
};

#if YYDEBUG
/* YYPRHS[YYN] -- Index of the first RHS symbol of rule number YYN in
   YYRHS.  */
static const yytype_uint16 yyprhs[] =
{
       0,     0,     3,     4,     6,     8,    11,    13,    15,    17,
      19,    21,    24,    26,    28,    37,    40,    45,    51,    56,
      61,    64,    70,    74,    77,    80,    86,    89,    95,    98,
     100,   104,   106,   110,   113,   115,   117,   119,   121,   123,
     125,   127,   129,   131,   133,   134,   136,   140,   144,   147,
     149,   150,   155,   157,   160,   163,   168,   171,   174,   177,
     180,   183,   186,   189,   192,   195,   198,   201,   204,   207,
     210,   213,   215,   218,   221,   223,   225,   227,   229,   231,
     233,   235,   237,   239,   241,   243,   245,   251,   256,   261,
     266,   268,   270,   271,   273,   277,   282,   287,   290,   298,
     299,   301,   305,   307,   310,   314,   321,   325,   332,   334,
     336,   338,   342,   347,   349,   354,   360,   369,   374,   382,
     384,   386,   388,   393,   396,   399,   401,   406,   408,   410,
     412,   414,   419,   421,   423,   425,   430,   432,   434,   437,
     440,   442,   444,   446,   448,   450,   452,   454,   456,   458,
     460,   462,   464,   466,   468,   470,   472,   474,   476,   478,
     480,   482,   489,   494,   498,   501,   503,   505,   507,   509,
     511,   513,   515,   517,   519,   522,   526,   528,   530,   532,
     536,   538,   541,   543,   545,   549,   551,   553,   555,   559,
     563,   566,   569,   572,   580,   590,   596,   605,   613,   617,
     620,   625,   631,   634,   637,   639,   643,   651,   661,   663,
     665,   667,   669,   671,   673,   674,   677
};

/* YYRHS -- A `-1'-separated list of the rules' RHS.  */
static const yytype_int16 yyrhs[] =
{
     123,     0,    -1,    -1,   124,    -1,   125,    -1,   124,   125,
      -1,   126,    -1,   128,    -1,   129,    -1,   166,    -1,   175,
      -1,    64,   127,    -1,     8,    -1,     9,    -1,   127,    67,
      50,    79,    50,    62,    50,    69,    -1,   127,    51,    -1,
      26,    50,    53,    50,    -1,    26,    50,    55,    50,    56,
      -1,    26,    50,    55,    56,    -1,   128,    67,   130,    69,
      -1,   128,   131,    -1,   128,    31,   133,   134,    54,    -1,
     128,   143,    54,    -1,   128,    29,    -1,    27,    50,    -1,
      27,    50,    55,    50,    56,    -1,   129,   131,    -1,   129,
     143,    60,   176,    61,    -1,   129,    29,    -1,    50,    -1,
     130,    52,    50,    -1,    60,    -1,   131,   134,    54,    -1,
     131,    61,    -1,    35,    -1,    32,    -1,    33,    -1,    34,
      -1,    36,    -1,    37,    -1,    38,    -1,    39,    -1,    40,
      -1,    41,    -1,    -1,    55,    -1,   133,   132,    52,    -1,
     133,   132,    56,    -1,   136,    50,    -1,   139,    -1,    -1,
      67,   136,    69,   135,    -1,    80,    -1,   135,   138,    -1,
     137,   136,    -1,    24,    55,   161,    56,    -1,   111,   135,
      -1,   112,   135,    -1,   113,   135,    -1,   114,   135,    -1,
     115,   135,    -1,   106,   135,    -1,   107,   135,    -1,   108,
     135,    -1,   109,   135,    -1,   110,   135,    -1,   116,   135,
      -1,   117,   135,    -1,   101,   135,    -1,   104,   135,    -1,
     103,   135,    -1,   118,    -1,    50,   135,    -1,   102,   135,
      -1,   140,    -1,    42,    -1,    43,    -1,    44,    -1,    40,
      -1,    41,    -1,    47,    -1,    48,    -1,    49,    -1,    45,
      -1,    46,    -1,    44,    -1,   136,    55,    76,    50,    56,
      -1,   139,    55,   142,    56,    -1,   136,    55,    76,    56,
      -1,   140,    55,   142,    56,    -1,   134,    -1,   136,    -1,
      -1,   141,    -1,   142,    52,   141,    -1,    77,    55,   136,
      56,    -1,    78,    55,   136,    56,    -1,   143,    50,    -1,
     143,    50,    53,    55,   136,    56,    50,    -1,    -1,   161,
      -1,   144,    52,   161,    -1,    62,    -1,    77,    69,    -1,
     151,   145,    50,    -1,   151,   145,    50,    55,   144,    56,
      -1,   146,   145,    50,    -1,   146,   145,    50,    55,   144,
      56,    -1,   151,    -1,   146,    -1,    50,    -1,    50,    53,
     144,    -1,   148,    50,    53,   144,    -1,   146,    -1,    58,
     147,   148,    59,    -1,    76,   136,    60,   176,    61,    -1,
      76,   136,    55,   142,    56,    60,   176,    61,    -1,    76,
      60,   176,    61,    -1,    76,    55,   142,    56,    60,   176,
      61,    -1,    50,    -1,    95,    -1,    96,    -1,    63,    55,
     161,    56,    -1,    63,   152,    -1,    63,    51,    -1,   149,
      -1,    50,    55,   144,    56,    -1,   119,    -1,   120,    -1,
     151,    -1,   121,    -1,    28,    55,    50,    56,    -1,    51,
      -1,   150,    -1,   152,    -1,    55,   136,    56,   153,    -1,
      97,    -1,    98,    -1,    80,    50,    -1,    74,    50,    -1,
      93,    -1,    81,    -1,    82,    -1,    83,    -1,    85,    -1,
      84,    -1,    86,    -1,    87,    -1,    94,    -1,    88,    -1,
      89,    -1,    78,    -1,    77,    -1,    80,    -1,    79,    -1,
      92,    -1,    90,    -1,    91,    -1,    74,    -1,    75,    -1,
      76,    -1,   160,    10,   157,   161,    53,   161,    -1,   160,
      10,    53,   161,    -1,   161,   156,   161,    -1,   161,   155,
      -1,   157,    -1,    65,    -1,    66,    -1,    68,    -1,    67,
      -1,    70,    -1,    69,    -1,    71,    -1,    72,    -1,    73,
     161,    -1,   161,   159,   161,    -1,   153,    -1,   160,    -1,
     158,    -1,    55,   161,    56,    -1,    11,    -1,    11,   161,
      -1,    12,    -1,    13,    -1,    14,    50,    53,    -1,   164,
      -1,   165,    -1,   134,    -1,   134,    93,   161,    -1,   153,
     154,   161,    -1,   161,    54,    -1,   163,    54,    -1,   162,
      54,    -1,     3,    55,   161,    56,    60,   176,    61,    -1,
     167,    15,     3,    55,   161,    56,    60,   176,    61,    -1,
     167,    15,    60,   176,    61,    -1,    17,    60,   176,    61,
      16,    55,   161,    56,    -1,    16,    55,   161,    56,    60,
     176,    61,    -1,    20,   153,    53,    -1,    22,    53,    -1,
     170,    60,   176,    61,    -1,    21,    55,   153,    56,    60,
      -1,   171,   170,    -1,   171,    61,    -1,   166,    -1,   172,
      54,   166,    -1,    19,    55,   172,    56,    60,   176,    61,
      -1,    19,    55,   134,    18,   153,    56,    60,   176,    61,
      -1,   167,    -1,   171,    -1,   169,    -1,   168,    -1,   173,
      -1,   174,    -1,    -1,   176,   166,    -1,   176,   175,    -1
};

/* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,    53,    53,    54,    56,    57,    60,    61,    62,    63,
      67,    72,    75,    76,    77,    78,    82,    89,    93,    97,
     103,   109,   121,   122,   125,   130,   134,   140,   148,   150,
     157,   167,   172,   178,   182,   183,   184,   185,   186,   187,
     188,   189,   190,   191,   195,   199,   204,   210,   219,   223,
     227,   229,   230,   236,   240,   245,   249,   253,   257,   261,
     265,   269,   273,   277,   281,   285,   289,   293,   297,   301,
     305,   309,   313,   317,   321,   328,   329,   330,   331,   332,
     333,   334,   335,   338,   339,   340,   343,   347,   350,   351,
     355,   356,   359,   362,   368,   377,   381,   385,   391,   401,
     402,   408,   416,   417,   420,   433,   447,   459,   474,   475,
     478,   484,   491,   505,   506,   518,   526,   534,   542,   551,
     555,   559,   565,   569,   574,   579,   581,   591,   592,   597,
     598,   602,   606,   610,   611,   615,   619,   623,   627,   631,
     640,   644,   648,   652,   656,   660,   664,   668,   672,   679,
     683,   690,   694,   698,   702,   706,   710,   714,   718,   722,
     726,   736,   744,   754,   761,   767,   774,   778,   782,   786,
     790,   794,   798,   802,   814,   820,   830,   831,   832,   833,
     840,   845,   851,   855,   859,   866,   867,   870,   875,   883,
     893,   894,   895,   899,   904,   911,   921,   928,   943,   947,
     951,   959,   964,   970,   978,   984,   991,   999,  1010,  1011,
    1012,  1013,  1014,  1015,  1020,  1023,  1029
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || YYTOKEN_TABLE
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "IF", "ENDIF", "IFDEF", "IFNDEF",
  "UNDEF", "IMPORT", "INCLUDE", "QUESTION", "_return", "_break",
  "_continue", "_goto", "_else", "_while", "_do", "_in", "_for", "_case",
  "_switch", "_default", "_enum", "_typeof", "_struct", "INTERFACE",
  "IMPLEMENTATION", "PROTOCOL", "END", "CLASS_DECLARE", "PROPERTY", "WEAK",
  "STRONG", "COPY", "ASSIGN_MEM", "NONATOMIC", "ATOMIC", "READONLY",
  "READWRITE", "NONNULL", "NULLABLE", "EXTERN", "STATIC", "CONST",
  "_NONNULL", "_NULLABLE", "_STRONG", "_WEAK", "_BLOCK", "IDENTIFIER",
  "STRING_LITERAL", "COMMA", "COLON", "SEMICOLON", "LP", "RP", "RIP", "LB",
  "RB", "LC", "RC", "DOT", "AT", "PS", "EQ", "NE", "LT", "LE", "GT", "GE",
  "LOGIC_AND", "LOGIC_OR", "LOGIC_NOT", "AND", "OR", "POWER", "SUB", "ADD",
  "DIV", "ASTERISK", "AND_ASSIGN", "OR_ASSIGN", "POWER_ASSIGN",
  "SUB_ASSIGN", "ADD_ASSIGN", "DIV_ASSIGN", "ASTERISK_ASSIGN", "INCREMENT",
  "DECREMENT", "SHIFTLEFT", "SHIFTRIGHT", "MOD", "ASSIGN", "MOD_ASSIGN",
  "_self", "_super", "_nil", "_NULL", "_YES", "_NO", "_Class", "_id",
  "_void", "_BOOL", "_SEL", "_CHAR", "_SHORT", "_INT", "_LONG", "_LLONG",
  "_UCHAR", "_USHORT", "_UINT", "_ULONG", "_ULLONG", "_DOUBLE", "_FLOAT",
  "_instancetype", "INTETER_LITERAL", "DOUBLE_LITERAL", "SELECTOR",
  "$accept", "compile_util", "definition_list", "definition", "PS_Define",
  "includeHeader", "class_declare", "class_implementation",
  "protocol_list", "class_private_varibale_declare", "class_property_type",
  "class_property_declare", "value_declare", "declare_type",
  "value_declare_type", "declare_left_attribute",
  "declare_right_attribute", "block_declare", "block_type",
  "block_parametere_type", "func_declare_parameters", "method_declare",
  "value_expression_list", "value_get_operator", "objc_method_get",
  "method_caller_type", "objc_method_call_pramameters", "objc_method_call",
  "block_implementation", "object_value_type", "numerical_value_type",
  "primary_expression", "assign_operator", "unary_operator",
  "binary_operator", "ternary_expression", "calculator_expression",
  "judgement_operator", "judgement_expression", "value_expression",
  "control_expression", "assign_expression", "declare_assign_expression",
  "var_assign_expression", "expression", "if_statement",
  "dowhile_statement", "while_statement", "case_statement",
  "switch_statement", "for_parameter_list", "for_statement",
  "forin_statement", "control_statement", "function_implementation", 0
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
     375,   376
};
# endif

/* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,   122,   123,   123,   124,   124,   125,   125,   125,   125,
     125,   126,   127,   127,   127,   127,   128,   128,   128,   128,
     128,   128,   128,   128,   129,   129,   129,   129,   129,   130,
     130,   131,   131,   131,   132,   132,   132,   132,   132,   132,
     132,   132,   132,   132,   133,   133,   133,   133,   134,   134,
     135,   135,   135,   135,   136,   136,   136,   136,   136,   136,
     136,   136,   136,   136,   136,   136,   136,   136,   136,   136,
     136,   136,   136,   136,   136,   137,   137,   137,   137,   137,
     137,   137,   137,   138,   138,   138,   139,   139,   140,   140,
     141,   141,   142,   142,   142,   143,   143,   143,   143,   144,
     144,   144,   145,   145,   146,   146,   146,   146,   147,   147,
     148,   148,   148,   149,   149,   150,   150,   150,   150,   151,
     151,   151,   151,   151,   151,   151,   151,   152,   152,   153,
     153,   153,   153,   153,   153,   153,   153,   153,   153,   153,
     154,   154,   154,   154,   154,   154,   154,   154,   154,   155,
     155,   156,   156,   156,   156,   156,   156,   156,   156,   156,
     156,   157,   157,   158,   158,   158,   159,   159,   159,   159,
     159,   159,   159,   159,   160,   160,   161,   161,   161,   161,
     162,   162,   162,   162,   162,   163,   163,   164,   164,   165,
     166,   166,   166,   167,   167,   167,   168,   169,   170,   170,
     170,   171,   171,   171,   172,   172,   173,   174,   175,   175,
     175,   175,   175,   175,   176,   176,   176
};

/* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     0,     1,     1,     2,     1,     1,     1,     1,
       1,     2,     1,     1,     8,     2,     4,     5,     4,     4,
       2,     5,     3,     2,     2,     5,     2,     5,     2,     1,
       3,     1,     3,     2,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     0,     1,     3,     3,     2,     1,
       0,     4,     1,     2,     2,     4,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     1,     2,     2,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     5,     4,     4,     4,
       1,     1,     0,     1,     3,     4,     4,     2,     7,     0,
       1,     3,     1,     2,     3,     6,     3,     6,     1,     1,
       1,     3,     4,     1,     4,     5,     8,     4,     7,     1,
       1,     1,     4,     2,     2,     1,     4,     1,     1,     1,
       1,     4,     1,     1,     1,     4,     1,     1,     2,     2,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     6,     4,     3,     2,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     2,     3,     1,     1,     1,     3,
       1,     2,     1,     1,     3,     1,     1,     1,     3,     3,
       2,     2,     2,     7,     9,     5,     8,     7,     3,     2,
       4,     5,     2,     2,     1,     3,     7,     9,     1,     1,
       1,     1,     1,     1,     0,     2,     2
};

/* YYDEFACT[STATE-NAME] -- Default rule to reduce with in state
   STATE-NUM when YYTABLE doesn't specify something else to do.  Zero
   means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       2,     0,   180,   182,   183,     0,     0,     0,     0,     0,
       0,     0,     0,     0,    78,    79,    75,    76,    77,    80,
      81,    82,   119,   132,     0,     0,     0,     0,     0,     0,
       0,     0,   120,   121,   136,   137,    50,    50,    50,    50,
      50,    50,    50,    50,    50,    50,    50,    50,    50,    50,
      50,    50,    71,   127,   128,   130,     0,     3,     4,     6,
       7,     8,   187,     0,     0,    49,    74,   113,   125,   133,
     129,   134,   176,   165,   178,   177,     0,     0,     0,   185,
     186,     9,   208,   211,   210,   209,   212,   213,    10,     0,
     119,   176,   181,     0,     0,   214,     0,     0,     0,     0,
      24,     0,    99,     0,    52,    72,     0,     0,   109,     0,
     108,   124,     0,   123,    12,    13,    11,   174,   139,    50,
      92,   214,     0,   138,    68,    73,    70,    69,    61,    62,
      63,    64,    65,    56,    57,    58,    59,    60,    66,    67,
       1,     5,    23,    44,    31,     0,     0,     0,    20,     0,
      28,    26,     0,     0,    48,     0,    54,    92,    92,   102,
       0,     0,     0,   141,   142,   143,   145,   144,   146,   147,
     140,   148,     0,     0,   190,   166,   167,   169,   168,   171,
     170,   172,   173,   158,   159,   160,   152,   151,   154,   153,
     149,   150,   156,   157,   155,   164,     0,     0,   192,   191,
       0,     0,     0,   203,   202,     0,   184,     0,     0,   187,
     204,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     100,     0,    85,    83,    84,    53,     0,     0,   179,   110,
       0,     0,    15,     0,    90,    91,    93,     0,     0,    92,
     214,    45,     0,    29,     0,     0,     0,    33,     0,    97,
      22,   214,   188,     0,     0,     0,   103,   106,   104,   189,
       0,   165,     0,   163,   175,     0,   214,     0,   199,   214,
       0,     0,     0,   215,   216,     0,     0,     0,     0,    55,
      16,     0,    18,     0,   131,     0,   126,    50,     0,   135,
      99,     0,   114,   122,     0,     0,     0,   117,     0,     0,
      35,    36,    37,    34,    38,    39,    40,    41,    78,    79,
       0,     0,     0,    19,     0,     0,    32,     0,     0,     0,
      88,    87,    89,    99,    99,   162,     0,     0,     0,   198,
       0,   214,   214,     0,     0,   205,   214,   201,    17,    25,
     101,    51,   111,    99,     0,    94,   214,     0,   115,    46,
      47,    21,    30,    95,    96,     0,    27,    86,     0,     0,
       0,     0,   195,   200,     0,     0,     0,     0,     0,   112,
       0,     0,   214,     0,   107,   105,   161,     0,   193,   197,
       0,   214,   206,     0,   118,     0,     0,   214,   196,     0,
       0,   116,    98,     0,   207,    14,   194
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,    56,    57,    58,    59,   116,    60,    61,   244,   148,
     310,   242,    62,   105,    63,    64,   225,    65,    66,   236,
     237,   149,   219,   161,    67,   109,   230,    68,    69,    70,
      71,    91,   172,   195,   196,    73,    74,   197,    75,    76,
      77,    78,    79,    80,   273,    82,    83,    84,   204,    85,
     211,    86,    87,   274,   208
};

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
#define YYPACT_NINF -282
static const yytype_int16 yypact[] =
{
     383,    15,   186,  -282,  -282,    43,    24,   -27,    39,    47,
      63,   122,   136,    78,  -282,  -282,  -282,  -282,  -282,  -282,
    -282,  -282,   123,  -282,  2139,   -19,   -45,    50,   186,   137,
    2258,   138,  -282,  -282,  -282,  -282,   -12,   -12,   -12,   -12,
     -12,   -12,   -12,   -12,   -12,   -12,   -12,   -12,   -12,   -12,
     -12,   -12,  -282,  -282,  -282,  -282,   145,   383,  -282,  -282,
      38,    11,   -43,    28,  2382,   110,   134,   -25,  -282,  -282,
     -25,  -282,   204,  -282,  -282,   151,  2514,   139,   140,  -282,
    -282,  -282,   176,  -282,  -282,    29,  -282,  -282,  -282,   186,
     141,  -282,  2738,   144,   186,  -282,  2041,  2452,   186,   111,
     147,   142,   186,  2382,  -282,    81,    95,  2542,   -25,   154,
     -25,  -282,   186,  -282,  -282,  -282,    -3,  2738,  -282,   -12,
    2382,  -282,    51,  -282,    81,    81,    81,    81,    81,    81,
      81,    81,    81,    81,    81,    81,    81,    81,    81,    81,
    -282,  -282,  -282,   150,  -282,   159,   158,   160,  2339,     6,
    -282,  2339,    32,   186,  -282,   143,   162,  2382,  2382,  -282,
     149,   170,   171,  -282,  -282,  -282,  -282,  -282,  -282,  -282,
    -282,  -282,   186,    79,  -282,  -282,  -282,  -282,  -282,  -282,
    -282,  -282,  -282,  -282,  -282,  -282,  -282,  -282,  -282,  -282,
    -282,  -282,  -282,  -282,  -282,  -282,   186,   186,  -282,  -282,
       5,  2452,   172,  -282,   163,  2570,  -282,  2598,   502,   -13,
    -282,    82,  2382,   168,  2626,   180,    35,   181,   177,    57,
    2738,   -23,  -282,  -282,  -282,  -282,   156,  2452,  -282,   182,
      -5,  2654,  -282,   184,  -282,    28,  -282,    58,   621,  2361,
    -282,  -282,  2237,  -282,   -16,  2382,  2382,  -282,   185,   187,
    -282,  -282,  2738,    45,    65,    67,  -282,   188,   190,  2738,
     186,   186,  2738,  2738,  2738,   191,  -282,   189,  -282,  -282,
     193,   194,   231,  -282,  -282,  2452,  2041,   195,   196,  -282,
    -282,   192,  -282,   201,  -282,   186,  -282,   -12,   202,  -282,
     186,   197,  -282,  -282,   198,  2382,   203,  -282,    72,   740,
    -282,  -282,  -282,  -282,  -282,  -282,  -282,  -282,    83,    91,
      92,   210,   218,  -282,   115,   125,  -282,   214,   859,   216,
    -282,  -282,  -282,   186,   186,  2738,  2486,   186,   978,  -282,
    1097,  -282,  -282,   219,   217,  -282,  -282,  -282,  -282,  -282,
    2738,    81,   199,   186,   229,  -282,  -282,   232,  -282,  -282,
    -282,  -282,  -282,  -282,  -282,  2382,  -282,  -282,   104,   106,
     186,  2682,  -282,  -282,  1216,  1335,   186,   233,  1454,   199,
     234,  1573,  -282,   129,  -282,  -282,  2738,   241,  -282,  -282,
    2710,  -282,  -282,   244,  -282,  1692,   252,  -282,  -282,  1811,
     235,  -282,  -282,  1930,  -282,  -282,  -282
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -282,  -282,  -282,   246,  -282,  -282,  -282,  -282,  -282,   247,
    -282,  -282,   -85,   -22,   -17,  -282,  -282,  -282,  -282,    14,
    -155,   249,  -281,   -29,   286,  -282,  -282,  -282,  -282,   287,
     288,     0,  -282,  -282,  -282,   146,  -282,  -282,  -282,    10,
    -282,  -282,  -282,  -282,     4,  -282,  -282,  -282,  -282,  -282,
    -282,  -282,  -282,    30,  -120
};

/* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule which
   number is the opposite.  If zero, do what YYDEFACT says.
   If YYTABLE_NINF, syntax error.  */
#define YYTABLE_NINF -51
static const yytype_int16 yytable[] =
{
      72,   238,   254,   255,    81,   275,   111,   106,   265,   342,
     112,   209,    92,   122,   124,   125,   126,   127,   128,   129,
     130,   131,   132,   133,   134,   135,   136,   137,   138,   139,
      88,    90,   226,    95,   107,   234,   312,   159,   117,    25,
     150,   162,   358,   359,    26,   291,   287,   156,   232,   201,
     153,   202,   160,   313,   292,   103,   249,    72,   114,   115,
     250,    81,   369,   248,   233,   266,   248,   142,   104,   143,
      89,   144,   234,   234,    53,    54,    32,    33,   154,    94,
     153,   162,   249,   155,   298,   281,   221,    88,   146,   147,
     203,   282,   251,    93,    96,   319,    72,   213,   144,   205,
     210,   320,    97,   235,   207,   145,   239,    13,   214,   285,
     295,   240,   220,   286,   296,   146,   147,   295,    98,   295,
     299,   321,   231,   322,   295,   222,   223,   224,   347,    90,
      23,   318,   260,   101,    24,   -42,   276,    25,   277,   -42,
     235,   235,    26,   -43,   349,   140,   328,   -43,   350,   330,
     226,   227,    28,    29,   234,    30,   285,   311,   285,    31,
     374,   173,   375,   252,   215,   157,   216,   -50,   -50,   -50,
     226,   353,    99,   -50,    32,    33,    34,    35,   102,   -50,
     226,   354,   259,   262,   226,   386,   100,   118,   123,   158,
     103,   200,   218,   198,   199,   106,   102,   206,    53,    54,
      55,   267,   217,   104,   229,   241,   263,   264,    72,   243,
     234,   364,   365,   245,    13,   246,   368,   226,   256,   253,
     257,   258,   235,   269,   278,   268,   371,   289,   314,   315,
     280,   283,   288,   284,   294,   290,    90,    23,    72,   316,
     317,    24,   329,   323,    25,   324,   327,   333,   338,    26,
     343,   285,   385,   331,   332,   336,   337,   339,   320,    28,
      29,   389,    30,   346,   351,   341,    31,   393,   352,   355,
     325,   326,   357,   367,   366,   334,    72,   344,   235,   370,
     335,    32,    33,    34,    35,   163,   164,   165,   166,   167,
     168,   169,   372,   381,   390,   340,   383,   170,   171,    72,
     220,   387,   392,   141,   395,    53,    54,    55,   151,   345,
     152,   108,   110,     0,   113,     0,     0,     0,    72,   261,
       0,     0,     0,     0,     0,     0,     0,     0,    72,     0,
      72,     0,     0,   220,   220,     0,     0,   361,   373,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,   220,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,    72,    72,     0,     0,    72,     0,
     376,    72,     0,     0,     0,     0,   380,     0,     0,     0,
       0,     0,     0,     0,     0,    72,     1,     0,     0,    72,
       0,     0,     0,    72,     2,     3,     4,     5,     0,     6,
       7,     0,     8,     0,     9,     0,     0,    10,     0,    11,
      12,    13,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,    14,    15,    16,    17,    18,     0,     0,
      19,    20,    21,    22,    23,     0,     0,     0,    24,     0,
       0,    25,     0,     0,     0,     0,    26,    27,     0,     0,
       0,     0,     0,     0,     0,     0,    28,    29,     0,    30,
       0,     0,     0,    31,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    32,    33,
      34,    35,     0,     0,    36,    37,    38,    39,     0,    40,
      41,    42,    43,    44,    45,    46,    47,    48,    49,    50,
      51,    52,    53,    54,    55,     1,     0,     0,     0,     0,
       0,     0,     0,     2,     3,     4,     5,     0,     6,     7,
       0,     8,     0,     9,     0,     0,    10,     0,     0,     0,
      13,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,    14,    15,    16,    17,    18,     0,     0,    19,
      20,    21,    22,    23,     0,     0,     0,    24,     0,     0,
      25,     0,     0,   272,     0,    26,     0,     0,     0,     0,
       0,     0,     0,     0,     0,    28,    29,     0,    30,     0,
       0,     0,    31,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,    32,    33,    34,
      35,     0,     0,    36,    37,    38,    39,     0,    40,    41,
      42,    43,    44,    45,    46,    47,    48,    49,    50,    51,
      52,    53,    54,    55,     1,     0,     0,     0,     0,     0,
       0,     0,     2,     3,     4,     5,     0,     6,     7,     0,
       8,     0,     9,     0,     0,    10,     0,     0,     0,    13,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,    14,    15,    16,    17,    18,     0,     0,    19,    20,
      21,    22,    23,     0,     0,     0,    24,     0,     0,    25,
       0,     0,   297,     0,    26,     0,     0,     0,     0,     0,
       0,     0,     0,     0,    28,    29,     0,    30,     0,     0,
       0,    31,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,    32,    33,    34,    35,
       0,     0,    36,    37,    38,    39,     0,    40,    41,    42,
      43,    44,    45,    46,    47,    48,    49,    50,    51,    52,
      53,    54,    55,     1,     0,     0,     0,     0,     0,     0,
       0,     2,     3,     4,     5,     0,     6,     7,     0,     8,
       0,     9,     0,     0,    10,     0,     0,     0,    13,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
      14,    15,    16,    17,    18,     0,     0,    19,    20,    21,
      22,    23,     0,     0,     0,    24,     0,     0,    25,     0,
       0,   348,     0,    26,     0,     0,     0,     0,     0,     0,
       0,     0,     0,    28,    29,     0,    30,     0,     0,     0,
      31,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,    32,    33,    34,    35,     0,
       0,    36,    37,    38,    39,     0,    40,    41,    42,    43,
      44,    45,    46,    47,    48,    49,    50,    51,    52,    53,
      54,    55,     1,     0,     0,     0,     0,     0,     0,     0,
       2,     3,     4,     5,     0,     6,     7,     0,     8,     0,
       9,     0,     0,    10,     0,     0,     0,    13,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    14,
      15,    16,    17,    18,     0,     0,    19,    20,    21,    22,
      23,     0,     0,     0,    24,     0,     0,    25,     0,     0,
     356,     0,    26,     0,     0,     0,     0,     0,     0,     0,
       0,     0,    28,    29,     0,    30,     0,     0,     0,    31,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,    32,    33,    34,    35,     0,     0,
      36,    37,    38,    39,     0,    40,    41,    42,    43,    44,
      45,    46,    47,    48,    49,    50,    51,    52,    53,    54,
      55,     1,     0,     0,     0,     0,     0,     0,     0,     2,
       3,     4,     5,     0,     6,     7,     0,     8,     0,     9,
       0,     0,    10,     0,     0,     0,    13,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    14,    15,
      16,    17,    18,     0,     0,    19,    20,    21,    22,    23,
       0,     0,     0,    24,     0,     0,    25,     0,     0,   362,
       0,    26,     0,     0,     0,     0,     0,     0,     0,     0,
       0,    28,    29,     0,    30,     0,     0,     0,    31,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,    32,    33,    34,    35,     0,     0,    36,
      37,    38,    39,     0,    40,    41,    42,    43,    44,    45,
      46,    47,    48,    49,    50,    51,    52,    53,    54,    55,
       1,     0,     0,     0,     0,     0,     0,     0,     2,     3,
       4,     5,     0,     6,     7,     0,     8,     0,     9,     0,
       0,    10,     0,     0,     0,    13,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,    14,    15,    16,
      17,    18,     0,     0,    19,    20,    21,    22,    23,     0,
       0,     0,    24,     0,     0,    25,     0,     0,   363,     0,
      26,     0,     0,     0,     0,     0,     0,     0,     0,     0,
      28,    29,     0,    30,     0,     0,     0,    31,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,    32,    33,    34,    35,     0,     0,    36,    37,
      38,    39,     0,    40,    41,    42,    43,    44,    45,    46,
      47,    48,    49,    50,    51,    52,    53,    54,    55,     1,
       0,     0,     0,     0,     0,     0,     0,     2,     3,     4,
       5,     0,     6,     7,     0,     8,     0,     9,     0,     0,
      10,     0,     0,     0,    13,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,    14,    15,    16,    17,
      18,     0,     0,    19,    20,    21,    22,    23,     0,     0,
       0,    24,     0,     0,    25,     0,     0,   378,     0,    26,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    28,
      29,     0,    30,     0,     0,     0,    31,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,    32,    33,    34,    35,     0,     0,    36,    37,    38,
      39,     0,    40,    41,    42,    43,    44,    45,    46,    47,
      48,    49,    50,    51,    52,    53,    54,    55,     1,     0,
       0,     0,     0,     0,     0,     0,     2,     3,     4,     5,
       0,     6,     7,     0,     8,     0,     9,     0,     0,    10,
       0,     0,     0,    13,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,    14,    15,    16,    17,    18,
       0,     0,    19,    20,    21,    22,    23,     0,     0,     0,
      24,     0,     0,    25,     0,     0,   379,     0,    26,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    28,    29,
       0,    30,     0,     0,     0,    31,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
      32,    33,    34,    35,     0,     0,    36,    37,    38,    39,
       0,    40,    41,    42,    43,    44,    45,    46,    47,    48,
      49,    50,    51,    52,    53,    54,    55,     1,     0,     0,
       0,     0,     0,     0,     0,     2,     3,     4,     5,     0,
       6,     7,     0,     8,     0,     9,     0,     0,    10,     0,
       0,     0,    13,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,    14,    15,    16,    17,    18,     0,
       0,    19,    20,    21,    22,    23,     0,     0,     0,    24,
       0,     0,    25,     0,     0,   382,     0,    26,     0,     0,
       0,     0,     0,     0,     0,     0,     0,    28,    29,     0,
      30,     0,     0,     0,    31,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    32,
      33,    34,    35,     0,     0,    36,    37,    38,    39,     0,
      40,    41,    42,    43,    44,    45,    46,    47,    48,    49,
      50,    51,    52,    53,    54,    55,     1,     0,     0,     0,
       0,     0,     0,     0,     2,     3,     4,     5,     0,     6,
       7,     0,     8,     0,     9,     0,     0,    10,     0,     0,
       0,    13,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,    14,    15,    16,    17,    18,     0,     0,
      19,    20,    21,    22,    23,     0,     0,     0,    24,     0,
       0,    25,     0,     0,   384,     0,    26,     0,     0,     0,
       0,     0,     0,     0,     0,     0,    28,    29,     0,    30,
       0,     0,     0,    31,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    32,    33,
      34,    35,     0,     0,    36,    37,    38,    39,     0,    40,
      41,    42,    43,    44,    45,    46,    47,    48,    49,    50,
      51,    52,    53,    54,    55,     1,     0,     0,     0,     0,
       0,     0,     0,     2,     3,     4,     5,     0,     6,     7,
       0,     8,     0,     9,     0,     0,    10,     0,     0,     0,
      13,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,    14,    15,    16,    17,    18,     0,     0,    19,
      20,    21,    22,    23,     0,     0,     0,    24,     0,     0,
      25,     0,     0,   391,     0,    26,     0,     0,     0,     0,
       0,     0,     0,     0,     0,    28,    29,     0,    30,     0,
       0,     0,    31,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,    32,    33,    34,
      35,     0,     0,    36,    37,    38,    39,     0,    40,    41,
      42,    43,    44,    45,    46,    47,    48,    49,    50,    51,
      52,    53,    54,    55,     1,     0,     0,     0,     0,     0,
       0,     0,     2,     3,     4,     5,     0,     6,     7,     0,
       8,     0,     9,     0,     0,    10,     0,     0,     0,    13,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,    14,    15,    16,    17,    18,     0,     0,    19,    20,
      21,    22,    23,     0,     0,     0,    24,     0,     0,    25,
       0,     0,   394,     0,    26,     0,     0,     0,     0,     0,
       0,     0,     0,     0,    28,    29,     0,    30,     0,     0,
       0,    31,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,    32,    33,    34,    35,
       0,     0,    36,    37,    38,    39,     0,    40,    41,    42,
      43,    44,    45,    46,    47,    48,    49,    50,    51,    52,
      53,    54,    55,     1,     0,     0,     0,     0,     0,     0,
       0,     2,     3,     4,     5,     0,     6,     7,     0,     8,
       0,     9,     0,     0,    10,     0,     0,     0,    13,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
      14,    15,    16,    17,    18,     0,     0,    19,    20,    21,
      22,    23,     0,     0,     0,    24,     0,     0,    25,     0,
       0,   396,     0,    26,     0,     0,     0,     0,     0,     0,
       0,     0,     0,    28,    29,     0,    30,     0,     0,     0,
      31,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,    32,    33,    34,    35,     0,
       0,    36,    37,    38,    39,     0,    40,    41,    42,    43,
      44,    45,    46,    47,    48,    49,    50,    51,    52,    53,
      54,    55,     2,     3,     4,     5,     0,     0,     0,     0,
       0,     0,     0,     0,     0,    10,     0,     0,     0,    13,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,    14,    15,    16,    17,    18,     0,     0,    19,    20,
      21,    22,    23,     0,     0,     0,    24,     0,     0,    25,
       0,     0,     0,     0,    26,     0,     0,     0,     0,     0,
       0,     0,     0,     0,    28,    29,     0,    30,     0,     0,
       0,    31,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,    32,    33,    34,    35,
       0,     0,    36,    37,    38,    39,     0,    40,    41,    42,
      43,    44,    45,    46,    47,    48,    49,    50,    51,    52,
      53,    54,    55,    10,     0,     0,     0,    13,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    14,
      15,    16,    17,    18,     0,     0,    19,    20,    21,    22,
      23,     0,     0,     0,    24,     0,     0,    25,     0,     0,
       0,     0,    26,     0,     0,     0,     0,     0,     0,     0,
       0,     0,    28,    29,     0,    30,     0,     0,     0,    31,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,    32,    33,    34,    35,     0,     0,
      36,    37,    38,    39,     0,    40,    41,    42,    43,    44,
      45,    46,    47,    48,    49,    50,    51,    52,    53,    54,
      55,    10,     0,     0,     0,     0,     0,     0,     0,   300,
     301,   302,   303,   304,   305,   306,   307,   308,   309,    16,
      17,    18,    10,     0,    19,    20,    21,   119,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    14,    15,
      16,    17,    18,     0,     0,    19,    20,    21,   119,     0,
       0,     0,     0,   120,     0,     0,     0,     0,   121,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    36,    37,
      38,    39,     0,    40,    41,    42,    43,    44,    45,    46,
      47,    48,    49,    50,    51,    52,     0,     0,     0,    36,
      37,    38,    39,    10,    40,    41,    42,    43,    44,    45,
      46,    47,    48,    49,    50,    51,    52,     0,     0,    14,
      15,    16,    17,    18,     0,    10,    19,    20,    21,   119,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     247,    14,    15,    16,    17,    18,    10,     0,    19,    20,
      21,   119,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,    14,    15,    16,    17,    18,     0,     0,    19,
      20,    21,   119,     0,     0,     0,     0,   288,     0,     0,
      36,    37,    38,    39,     0,    40,    41,    42,    43,    44,
      45,    46,    47,    48,    49,    50,    51,    52,     0,     0,
       0,     0,    36,    37,    38,    39,     0,    40,    41,    42,
      43,    44,    45,    46,    47,    48,    49,    50,    51,    52,
      13,     0,     0,    36,    37,    38,    39,     0,    40,    41,
      42,    43,    44,    45,    46,    47,    48,    49,    50,    51,
      52,     0,    90,    23,     0,     0,     0,   212,     0,     0,
      25,     0,     0,     0,     0,    26,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,    29,     0,    30,     0,
       0,     0,    31,     0,     0,     0,     0,     0,     0,   360,
       0,     0,     0,     0,     0,     0,     0,    32,    33,    34,
      35,   175,   176,   177,   178,   179,   180,   181,   182,     0,
     183,   184,   185,   186,   187,   188,   189,     0,   174,     0,
       0,    53,    54,    55,   190,   191,   192,   193,   194,   175,
     176,   177,   178,   179,   180,   181,   182,     0,   183,   184,
     185,   186,   187,   188,   189,     0,     0,     0,   228,     0,
       0,     0,   190,   191,   192,   193,   194,   175,   176,   177,
     178,   179,   180,   181,   182,     0,   183,   184,   185,   186,
     187,   188,   189,     0,     0,     0,   270,     0,     0,     0,
     190,   191,   192,   193,   194,   175,   176,   177,   178,   179,
     180,   181,   182,     0,   183,   184,   185,   186,   187,   188,
     189,     0,     0,     0,   271,     0,     0,     0,   190,   191,
     192,   193,   194,   175,   176,   177,   178,   179,   180,   181,
     182,     0,   183,   184,   185,   186,   187,   188,   189,     0,
       0,     0,   279,     0,     0,     0,   190,   191,   192,   193,
     194,   175,   176,   177,   178,   179,   180,   181,   182,     0,
     183,   184,   185,   186,   187,   188,   189,     0,     0,     0,
     293,     0,     0,     0,   190,   191,   192,   193,   194,   175,
     176,   177,   178,   179,   180,   181,   182,     0,   183,   184,
     185,   186,   187,   188,   189,     0,     0,     0,   377,     0,
       0,     0,   190,   191,   192,   193,   194,   175,   176,   177,
     178,   179,   180,   181,   182,     0,   183,   184,   185,   186,
     187,   188,   189,     0,     0,     0,   388,     0,     0,     0,
     190,   191,   192,   193,   194,   175,   176,   177,   178,   179,
     180,   181,   182,     0,   183,   184,   185,   186,   187,   188,
     189,     0,     0,     0,     0,     0,     0,     0,   190,   191,
     192,   193,   194,   175,   176,   177,   178,   179,   180,   181,
     182,     0,   183,   184,   185,   186,   187,   188,   189,     0,
       0,     0,     0,     0,     0,     0,   190,   191,   192,   193,
     194
};

static const yytype_int16 yycheck[] =
{
       0,   121,   157,   158,     0,    18,    51,    24,     3,   290,
      55,    96,     2,    30,    36,    37,    38,    39,    40,    41,
      42,    43,    44,    45,    46,    47,    48,    49,    50,    51,
       0,    50,    55,    60,    24,   120,    52,    62,    28,    58,
      29,    70,   323,   324,    63,    50,    69,    64,    51,    20,
      93,    22,    77,    69,    59,    67,    50,    57,     8,     9,
      54,    57,   343,   148,    67,    60,   151,    29,    80,    31,
      55,    60,   157,   158,   119,   120,    95,    96,    50,    55,
      93,   110,    50,    55,   239,    50,   103,    57,    77,    78,
      61,    56,    60,    50,    55,    50,    96,    97,    60,    89,
      96,    56,    55,   120,    94,    67,    55,    28,    98,    52,
      52,    60,   102,    56,    56,    77,    78,    52,    55,    52,
     240,    56,   112,    56,    52,    44,    45,    46,    56,    50,
      51,   251,    53,    55,    55,    52,    54,    58,    56,    56,
     157,   158,    63,    52,    52,     0,   266,    56,    56,   269,
      55,    56,    73,    74,   239,    76,    52,   242,    52,    80,
      56,    10,    56,   153,    53,    55,    55,    44,    45,    46,
      55,    56,    50,    50,    95,    96,    97,    98,    55,    56,
      55,    56,   172,   173,    55,    56,    50,    50,    50,    55,
      67,    15,    50,    54,    54,   212,    55,    53,   119,   120,
     121,   201,    55,    80,    50,    55,   196,   197,   208,    50,
     295,   331,   332,    55,    28,    55,   336,    55,    69,    76,
      50,    50,   239,    60,    56,    53,   346,   227,   245,   246,
      50,    50,    76,    56,    50,    53,    50,    51,   238,    54,
      53,    55,    53,    55,    58,    55,    55,    16,    56,    63,
      53,    52,   372,    60,    60,    60,    60,    56,    56,    73,
      74,   381,    76,    60,    54,   287,    80,   387,    50,    55,
     260,   261,    56,    56,    55,   275,   276,    79,   295,    50,
     276,    95,    96,    97,    98,    81,    82,    83,    84,    85,
      86,    87,    60,    60,    50,   285,    62,    93,    94,   299,
     290,    60,    50,    57,    69,   119,   120,   121,    61,   295,
      61,    25,    25,    -1,    26,    -1,    -1,    -1,   318,   173,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,   328,    -1,
     330,    -1,    -1,   323,   324,    -1,    -1,   327,   355,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,   343,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,   364,   365,    -1,    -1,   368,    -1,
     360,   371,    -1,    -1,    -1,    -1,   366,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,   385,     3,    -1,    -1,   389,
      -1,    -1,    -1,   393,    11,    12,    13,    14,    -1,    16,
      17,    -1,    19,    -1,    21,    -1,    -1,    24,    -1,    26,
      27,    28,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    40,    41,    42,    43,    44,    -1,    -1,
      47,    48,    49,    50,    51,    -1,    -1,    -1,    55,    -1,
      -1,    58,    -1,    -1,    -1,    -1,    63,    64,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    73,    74,    -1,    76,
      -1,    -1,    -1,    80,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    95,    96,
      97,    98,    -1,    -1,   101,   102,   103,   104,    -1,   106,
     107,   108,   109,   110,   111,   112,   113,   114,   115,   116,
     117,   118,   119,   120,   121,     3,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    11,    12,    13,    14,    -1,    16,    17,
      -1,    19,    -1,    21,    -1,    -1,    24,    -1,    -1,    -1,
      28,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    40,    41,    42,    43,    44,    -1,    -1,    47,
      48,    49,    50,    51,    -1,    -1,    -1,    55,    -1,    -1,
      58,    -1,    -1,    61,    -1,    63,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    73,    74,    -1,    76,    -1,
      -1,    -1,    80,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    95,    96,    97,
      98,    -1,    -1,   101,   102,   103,   104,    -1,   106,   107,
     108,   109,   110,   111,   112,   113,   114,   115,   116,   117,
     118,   119,   120,   121,     3,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    11,    12,    13,    14,    -1,    16,    17,    -1,
      19,    -1,    21,    -1,    -1,    24,    -1,    -1,    -1,    28,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    40,    41,    42,    43,    44,    -1,    -1,    47,    48,
      49,    50,    51,    -1,    -1,    -1,    55,    -1,    -1,    58,
      -1,    -1,    61,    -1,    63,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    73,    74,    -1,    76,    -1,    -1,
      -1,    80,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    95,    96,    97,    98,
      -1,    -1,   101,   102,   103,   104,    -1,   106,   107,   108,
     109,   110,   111,   112,   113,   114,   115,   116,   117,   118,
     119,   120,   121,     3,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    11,    12,    13,    14,    -1,    16,    17,    -1,    19,
      -1,    21,    -1,    -1,    24,    -1,    -1,    -1,    28,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      40,    41,    42,    43,    44,    -1,    -1,    47,    48,    49,
      50,    51,    -1,    -1,    -1,    55,    -1,    -1,    58,    -1,
      -1,    61,    -1,    63,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    73,    74,    -1,    76,    -1,    -1,    -1,
      80,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    95,    96,    97,    98,    -1,
      -1,   101,   102,   103,   104,    -1,   106,   107,   108,   109,
     110,   111,   112,   113,   114,   115,   116,   117,   118,   119,
     120,   121,     3,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      11,    12,    13,    14,    -1,    16,    17,    -1,    19,    -1,
      21,    -1,    -1,    24,    -1,    -1,    -1,    28,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    40,
      41,    42,    43,    44,    -1,    -1,    47,    48,    49,    50,
      51,    -1,    -1,    -1,    55,    -1,    -1,    58,    -1,    -1,
      61,    -1,    63,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    73,    74,    -1,    76,    -1,    -1,    -1,    80,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    95,    96,    97,    98,    -1,    -1,
     101,   102,   103,   104,    -1,   106,   107,   108,   109,   110,
     111,   112,   113,   114,   115,   116,   117,   118,   119,   120,
     121,     3,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    11,
      12,    13,    14,    -1,    16,    17,    -1,    19,    -1,    21,
      -1,    -1,    24,    -1,    -1,    -1,    28,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    40,    41,
      42,    43,    44,    -1,    -1,    47,    48,    49,    50,    51,
      -1,    -1,    -1,    55,    -1,    -1,    58,    -1,    -1,    61,
      -1,    63,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    73,    74,    -1,    76,    -1,    -1,    -1,    80,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    95,    96,    97,    98,    -1,    -1,   101,
     102,   103,   104,    -1,   106,   107,   108,   109,   110,   111,
     112,   113,   114,   115,   116,   117,   118,   119,   120,   121,
       3,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    11,    12,
      13,    14,    -1,    16,    17,    -1,    19,    -1,    21,    -1,
      -1,    24,    -1,    -1,    -1,    28,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    40,    41,    42,
      43,    44,    -1,    -1,    47,    48,    49,    50,    51,    -1,
      -1,    -1,    55,    -1,    -1,    58,    -1,    -1,    61,    -1,
      63,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      73,    74,    -1,    76,    -1,    -1,    -1,    80,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    95,    96,    97,    98,    -1,    -1,   101,   102,
     103,   104,    -1,   106,   107,   108,   109,   110,   111,   112,
     113,   114,   115,   116,   117,   118,   119,   120,   121,     3,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    11,    12,    13,
      14,    -1,    16,    17,    -1,    19,    -1,    21,    -1,    -1,
      24,    -1,    -1,    -1,    28,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    40,    41,    42,    43,
      44,    -1,    -1,    47,    48,    49,    50,    51,    -1,    -1,
      -1,    55,    -1,    -1,    58,    -1,    -1,    61,    -1,    63,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    73,
      74,    -1,    76,    -1,    -1,    -1,    80,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    95,    96,    97,    98,    -1,    -1,   101,   102,   103,
     104,    -1,   106,   107,   108,   109,   110,   111,   112,   113,
     114,   115,   116,   117,   118,   119,   120,   121,     3,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    11,    12,    13,    14,
      -1,    16,    17,    -1,    19,    -1,    21,    -1,    -1,    24,
      -1,    -1,    -1,    28,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    40,    41,    42,    43,    44,
      -1,    -1,    47,    48,    49,    50,    51,    -1,    -1,    -1,
      55,    -1,    -1,    58,    -1,    -1,    61,    -1,    63,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    73,    74,
      -1,    76,    -1,    -1,    -1,    80,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      95,    96,    97,    98,    -1,    -1,   101,   102,   103,   104,
      -1,   106,   107,   108,   109,   110,   111,   112,   113,   114,
     115,   116,   117,   118,   119,   120,   121,     3,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    11,    12,    13,    14,    -1,
      16,    17,    -1,    19,    -1,    21,    -1,    -1,    24,    -1,
      -1,    -1,    28,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    40,    41,    42,    43,    44,    -1,
      -1,    47,    48,    49,    50,    51,    -1,    -1,    -1,    55,
      -1,    -1,    58,    -1,    -1,    61,    -1,    63,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    73,    74,    -1,
      76,    -1,    -1,    -1,    80,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    95,
      96,    97,    98,    -1,    -1,   101,   102,   103,   104,    -1,
     106,   107,   108,   109,   110,   111,   112,   113,   114,   115,
     116,   117,   118,   119,   120,   121,     3,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    11,    12,    13,    14,    -1,    16,
      17,    -1,    19,    -1,    21,    -1,    -1,    24,    -1,    -1,
      -1,    28,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    40,    41,    42,    43,    44,    -1,    -1,
      47,    48,    49,    50,    51,    -1,    -1,    -1,    55,    -1,
      -1,    58,    -1,    -1,    61,    -1,    63,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    73,    74,    -1,    76,
      -1,    -1,    -1,    80,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    95,    96,
      97,    98,    -1,    -1,   101,   102,   103,   104,    -1,   106,
     107,   108,   109,   110,   111,   112,   113,   114,   115,   116,
     117,   118,   119,   120,   121,     3,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    11,    12,    13,    14,    -1,    16,    17,
      -1,    19,    -1,    21,    -1,    -1,    24,    -1,    -1,    -1,
      28,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    40,    41,    42,    43,    44,    -1,    -1,    47,
      48,    49,    50,    51,    -1,    -1,    -1,    55,    -1,    -1,
      58,    -1,    -1,    61,    -1,    63,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    73,    74,    -1,    76,    -1,
      -1,    -1,    80,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    95,    96,    97,
      98,    -1,    -1,   101,   102,   103,   104,    -1,   106,   107,
     108,   109,   110,   111,   112,   113,   114,   115,   116,   117,
     118,   119,   120,   121,     3,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    11,    12,    13,    14,    -1,    16,    17,    -1,
      19,    -1,    21,    -1,    -1,    24,    -1,    -1,    -1,    28,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    40,    41,    42,    43,    44,    -1,    -1,    47,    48,
      49,    50,    51,    -1,    -1,    -1,    55,    -1,    -1,    58,
      -1,    -1,    61,    -1,    63,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    73,    74,    -1,    76,    -1,    -1,
      -1,    80,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    95,    96,    97,    98,
      -1,    -1,   101,   102,   103,   104,    -1,   106,   107,   108,
     109,   110,   111,   112,   113,   114,   115,   116,   117,   118,
     119,   120,   121,     3,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    11,    12,    13,    14,    -1,    16,    17,    -1,    19,
      -1,    21,    -1,    -1,    24,    -1,    -1,    -1,    28,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      40,    41,    42,    43,    44,    -1,    -1,    47,    48,    49,
      50,    51,    -1,    -1,    -1,    55,    -1,    -1,    58,    -1,
      -1,    61,    -1,    63,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    73,    74,    -1,    76,    -1,    -1,    -1,
      80,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    95,    96,    97,    98,    -1,
      -1,   101,   102,   103,   104,    -1,   106,   107,   108,   109,
     110,   111,   112,   113,   114,   115,   116,   117,   118,   119,
     120,   121,    11,    12,    13,    14,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    24,    -1,    -1,    -1,    28,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    40,    41,    42,    43,    44,    -1,    -1,    47,    48,
      49,    50,    51,    -1,    -1,    -1,    55,    -1,    -1,    58,
      -1,    -1,    -1,    -1,    63,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    73,    74,    -1,    76,    -1,    -1,
      -1,    80,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    95,    96,    97,    98,
      -1,    -1,   101,   102,   103,   104,    -1,   106,   107,   108,
     109,   110,   111,   112,   113,   114,   115,   116,   117,   118,
     119,   120,   121,    24,    -1,    -1,    -1,    28,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    40,
      41,    42,    43,    44,    -1,    -1,    47,    48,    49,    50,
      51,    -1,    -1,    -1,    55,    -1,    -1,    58,    -1,    -1,
      -1,    -1,    63,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    73,    74,    -1,    76,    -1,    -1,    -1,    80,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    95,    96,    97,    98,    -1,    -1,
     101,   102,   103,   104,    -1,   106,   107,   108,   109,   110,
     111,   112,   113,   114,   115,   116,   117,   118,   119,   120,
     121,    24,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    32,
      33,    34,    35,    36,    37,    38,    39,    40,    41,    42,
      43,    44,    24,    -1,    47,    48,    49,    50,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    40,    41,
      42,    43,    44,    -1,    -1,    47,    48,    49,    50,    -1,
      -1,    -1,    -1,    55,    -1,    -1,    -1,    -1,    60,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,   101,   102,
     103,   104,    -1,   106,   107,   108,   109,   110,   111,   112,
     113,   114,   115,   116,   117,   118,    -1,    -1,    -1,   101,
     102,   103,   104,    24,   106,   107,   108,   109,   110,   111,
     112,   113,   114,   115,   116,   117,   118,    -1,    -1,    40,
      41,    42,    43,    44,    -1,    24,    47,    48,    49,    50,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      61,    40,    41,    42,    43,    44,    24,    -1,    47,    48,
      49,    50,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    40,    41,    42,    43,    44,    -1,    -1,    47,
      48,    49,    50,    -1,    -1,    -1,    -1,    76,    -1,    -1,
     101,   102,   103,   104,    -1,   106,   107,   108,   109,   110,
     111,   112,   113,   114,   115,   116,   117,   118,    -1,    -1,
      -1,    -1,   101,   102,   103,   104,    -1,   106,   107,   108,
     109,   110,   111,   112,   113,   114,   115,   116,   117,   118,
      28,    -1,    -1,   101,   102,   103,   104,    -1,   106,   107,
     108,   109,   110,   111,   112,   113,   114,   115,   116,   117,
     118,    -1,    50,    51,    -1,    -1,    -1,    55,    -1,    -1,
      58,    -1,    -1,    -1,    -1,    63,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    74,    -1,    76,    -1,
      -1,    -1,    80,    -1,    -1,    -1,    -1,    -1,    -1,    53,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    95,    96,    97,
      98,    65,    66,    67,    68,    69,    70,    71,    72,    -1,
      74,    75,    76,    77,    78,    79,    80,    -1,    54,    -1,
      -1,   119,   120,   121,    88,    89,    90,    91,    92,    65,
      66,    67,    68,    69,    70,    71,    72,    -1,    74,    75,
      76,    77,    78,    79,    80,    -1,    -1,    -1,    56,    -1,
      -1,    -1,    88,    89,    90,    91,    92,    65,    66,    67,
      68,    69,    70,    71,    72,    -1,    74,    75,    76,    77,
      78,    79,    80,    -1,    -1,    -1,    56,    -1,    -1,    -1,
      88,    89,    90,    91,    92,    65,    66,    67,    68,    69,
      70,    71,    72,    -1,    74,    75,    76,    77,    78,    79,
      80,    -1,    -1,    -1,    56,    -1,    -1,    -1,    88,    89,
      90,    91,    92,    65,    66,    67,    68,    69,    70,    71,
      72,    -1,    74,    75,    76,    77,    78,    79,    80,    -1,
      -1,    -1,    56,    -1,    -1,    -1,    88,    89,    90,    91,
      92,    65,    66,    67,    68,    69,    70,    71,    72,    -1,
      74,    75,    76,    77,    78,    79,    80,    -1,    -1,    -1,
      56,    -1,    -1,    -1,    88,    89,    90,    91,    92,    65,
      66,    67,    68,    69,    70,    71,    72,    -1,    74,    75,
      76,    77,    78,    79,    80,    -1,    -1,    -1,    56,    -1,
      -1,    -1,    88,    89,    90,    91,    92,    65,    66,    67,
      68,    69,    70,    71,    72,    -1,    74,    75,    76,    77,
      78,    79,    80,    -1,    -1,    -1,    56,    -1,    -1,    -1,
      88,    89,    90,    91,    92,    65,    66,    67,    68,    69,
      70,    71,    72,    -1,    74,    75,    76,    77,    78,    79,
      80,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    88,    89,
      90,    91,    92,    65,    66,    67,    68,    69,    70,    71,
      72,    -1,    74,    75,    76,    77,    78,    79,    80,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    88,    89,    90,    91,
      92
};

/* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
   symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,     3,    11,    12,    13,    14,    16,    17,    19,    21,
      24,    26,    27,    28,    40,    41,    42,    43,    44,    47,
      48,    49,    50,    51,    55,    58,    63,    64,    73,    74,
      76,    80,    95,    96,    97,    98,   101,   102,   103,   104,
     106,   107,   108,   109,   110,   111,   112,   113,   114,   115,
     116,   117,   118,   119,   120,   121,   123,   124,   125,   126,
     128,   129,   134,   136,   137,   139,   140,   146,   149,   150,
     151,   152,   153,   157,   158,   160,   161,   162,   163,   164,
     165,   166,   167,   168,   169,   171,   173,   174,   175,    55,
      50,   153,   161,    50,    55,    60,    55,    55,    55,    50,
      50,    55,    55,    67,    80,   135,   136,   161,   146,   147,
     151,    51,    55,   152,     8,     9,   127,   161,    50,    50,
      55,    60,   136,    50,   135,   135,   135,   135,   135,   135,
     135,   135,   135,   135,   135,   135,   135,   135,   135,   135,
       0,   125,    29,    31,    60,    67,    77,    78,   131,   143,
      29,   131,   143,    93,    50,    55,   136,    55,    55,    62,
      77,   145,   145,    81,    82,    83,    84,    85,    86,    87,
      93,    94,   154,    10,    54,    65,    66,    67,    68,    69,
      70,    71,    72,    74,    75,    76,    77,    78,    79,    80,
      88,    89,    90,    91,    92,   155,   156,   159,    54,    54,
      15,    20,    22,    61,   170,   161,    53,   161,   176,   134,
     166,   172,    55,   153,   161,    53,    55,    55,    50,   144,
     161,   136,    44,    45,    46,   138,    55,    56,    56,    50,
     148,   161,    51,    67,   134,   136,   141,   142,   176,    55,
      60,    55,   133,    50,   130,    55,    55,    61,   134,    50,
      54,    60,   161,    76,   142,   142,    69,    50,    50,   161,
      53,   157,   161,   161,   161,     3,    60,   153,    53,    60,
      56,    56,    61,   166,   175,    18,    54,    56,    56,    56,
      50,    50,    56,    50,    56,    52,    56,    69,    76,   153,
      53,    50,    59,    56,    50,    52,    56,    61,   142,   176,
      32,    33,    34,    35,    36,    37,    38,    39,    40,    41,
     132,   134,    52,    69,   136,   136,    54,    53,   176,    50,
      56,    56,    56,    55,    55,   161,   161,    55,   176,    53,
     176,    60,    60,    16,   153,   166,    60,    60,    56,    56,
     161,   135,   144,    53,    79,   141,    60,    56,    61,    52,
      56,    54,    50,    56,    56,    55,    61,    56,   144,   144,
      53,   161,    61,    61,   176,   176,    55,    56,   176,   144,
      50,   176,    60,   136,    56,    56,   161,    56,    61,    61,
     161,    60,    61,    62,    61,   176,    56,    60,    56,   176,
      50,    61,    50,   176,    61,    69,    61
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
        case 9:
#line 64 "cal.y"
    {
                [LibAst.globalStatements addObject:_transfer(id) (yyvsp[(1) - (1)].expression)];
            ;}
    break;

  case 10:
#line 68 "cal.y"
    {
                [LibAst.globalStatements addObject:_transfer(id) (yyvsp[(1) - (1)].statement)];
            ;}
    break;

  case 16:
#line 83 "cal.y"
    {
                OCClass *occlass = [LibAst classForName:_transfer(id)(yyvsp[(2) - (4)].identifier)];
                occlass.superClassName = _transfer(id)(yyvsp[(4) - (4)].identifier);
                (yyval.declare) = _vretained occlass;
            ;}
    break;

  case 17:
#line 90 "cal.y"
    {
                (yyval.declare) = _vretained [LibAst classForName:_transfer(id)(yyvsp[(2) - (5)].identifier)];
            ;}
    break;

  case 18:
#line 94 "cal.y"
    {
                (yyval.declare) = _vretained [LibAst classForName:_transfer(id)(yyvsp[(2) - (4)].identifier)];
            ;}
    break;

  case 19:
#line 98 "cal.y"
    {
                OCClass *occlass = _transfer(OCClass *) (yyvsp[(1) - (4)].declare);
                occlass.protocols = _transfer(id) (yyvsp[(3) - (4)].declare);
                (yyval.declare) = _vretained occlass;
            ;}
    break;

  case 20:
#line 104 "cal.y"
    {
                OCClass *occlass = _transfer(OCClass *) (yyvsp[(1) - (2)].declare);
                [occlass.privateVariables addObjectsFromArray:_transfer(id) (yyvsp[(2) - (2)].declare)];
                (yyval.declare) = _vretained occlass;
            ;}
    break;

  case 21:
#line 110 "cal.y"
    {
                OCClass *occlass = _transfer(OCClass *) (yyvsp[(1) - (5)].declare);

                PropertyDeclare *property = [PropertyDeclare new];
                property.keywords = _transfer(NSMutableArray *) (yyvsp[(3) - (5)].declare);
                property.var = _transfer(VariableDeclare *) (yyvsp[(4) - (5)].declare);
                
                [occlass.properties addObject:property];
                (yyval.declare) = _vretained occlass;
            ;}
    break;

  case 24:
#line 126 "cal.y"
    {
                (yyval.implementation) = _vretained [LibAst classForName:_transfer(id)(yyvsp[(2) - (2)].identifier)];
            ;}
    break;

  case 25:
#line 131 "cal.y"
    {
                (yyval.implementation) = _vretained [LibAst classForName:_transfer(id)(yyvsp[(2) - (5)].identifier)];
            ;}
    break;

  case 26:
#line 135 "cal.y"
    {
                OCClass *occlass = _transfer(OCClass *) (yyvsp[(1) - (2)].implementation);
                [occlass.privateVariables addObjectsFromArray:_transfer(id) (yyvsp[(2) - (2)].declare)];
                (yyval.implementation) = _vretained occlass;
            ;}
    break;

  case 27:
#line 141 "cal.y"
    {
                MethodImplementation *imp = makeMethodImplementation(_transfer(MethodDeclare *) (yyvsp[(2) - (5)].declare));
                imp.imp = _transfer(FunctionImp *) (yyvsp[(4) - (5)].expression);
                OCClass *occlass = _transfer(OCClass *) (yyvsp[(1) - (5)].implementation);
                [occlass.methods addObject:imp];
                (yyval.implementation) = _vretained occlass;
            ;}
    break;

  case 29:
#line 151 "cal.y"
    {
				NSMutableArray *list = [NSMutableArray array];
				NSString *identifier = (__bridge_transfer NSString *)(yyvsp[(1) - (1)].identifier);
				[list addObject:identifier];
				(yyval.declare) = (__bridge_retained void *)list;
			;}
    break;

  case 30:
#line 158 "cal.y"
    {
				NSMutableArray *list = (__bridge_transfer NSMutableArray *)(yyvsp[(1) - (3)].declare);
				NSString *identifier = (__bridge_transfer NSString *)(yyvsp[(3) - (3)].identifier);
				[list addObject:identifier];
				(yyval.declare) = (__bridge_retained void *)list;
			;}
    break;

  case 31:
#line 168 "cal.y"
    {
                NSMutableArray *list = [NSMutableArray array];
				(yyval.declare) = (__bridge_retained void *)list;
            ;}
    break;

  case 32:
#line 173 "cal.y"
    {
                NSMutableArray *list = _transfer(NSMutableArray *) (yyvsp[(1) - (3)].declare);
				[list addObject:_transfer(VariableDeclare *) (yyvsp[(2) - (3)].declare)];
				(yyval.declare) = (__bridge_retained void *)list;
            ;}
    break;

  case 44:
#line 195 "cal.y"
    {
                NSMutableArray *list = [NSMutableArray array];
				(yyval.declare) = (__bridge_retained void *)list;
            ;}
    break;

  case 45:
#line 200 "cal.y"
    {
                NSMutableArray *list = [NSMutableArray array];
				(yyval.declare) = (__bridge_retained void *)list;
            ;}
    break;

  case 46:
#line 205 "cal.y"
    {
                NSMutableArray *list = _transfer(NSMutableArray *) (yyvsp[(1) - (3)].declare);
				[list addObject:_transfer(NSString *) (yyvsp[(2) - (3)].identifier)];
				(yyval.declare) = (__bridge_retained void *)list;
            ;}
    break;

  case 47:
#line 211 "cal.y"
    {
                NSMutableArray *list = _transfer(NSMutableArray *) (yyvsp[(1) - (3)].declare);
				[list addObject:_transfer(NSString *) (yyvsp[(2) - (3)].identifier)];
				(yyval.declare) = (__bridge_retained void *)list;
            ;}
    break;

  case 48:
#line 220 "cal.y"
    {
                (yyval.declare) = _vretained makeVariableDeclare((__bridge TypeSpecial *)(yyvsp[(1) - (2)].type),(__bridge NSString *)(yyvsp[(2) - (2)].identifier));
            ;}
    break;

  case 52:
#line 231 "cal.y"
    {
                TypeSpecial *specail = makeTypeSpecial(SpecialTypeUChar);
                specail.isPointer = YES;
                (yyval.type) =  _vretained specail;
            ;}
    break;

  case 54:
#line 241 "cal.y"
    {
                (yyval.type) = (yyvsp[(2) - (2)].type);
            ;}
    break;

  case 55:
#line 246 "cal.y"
    {
                (yyval.type) = _vretained makeTypeSpecial(SpecialTypeObject,@"typeof");
            ;}
    break;

  case 56:
#line 250 "cal.y"
    {
                 (yyval.type) = _vretained makeTypeSpecial(SpecialTypeUChar);
            ;}
    break;

  case 57:
#line 254 "cal.y"
    {
                (yyval.type) = _vretained makeTypeSpecial(SpecialTypeUShort);
            ;}
    break;

  case 58:
#line 258 "cal.y"
    {
                (yyval.type) = _vretained makeTypeSpecial(SpecialTypeUInt);
            ;}
    break;

  case 59:
#line 262 "cal.y"
    {
                (yyval.type) = _vretained makeTypeSpecial(SpecialTypeULong);
            ;}
    break;

  case 60:
#line 266 "cal.y"
    {
                (yyval.type) = _vretained makeTypeSpecial(SpecialTypeULongLong);
            ;}
    break;

  case 61:
#line 270 "cal.y"
    {
                (yyval.type) = _vretained makeTypeSpecial(SpecialTypeChar);
            ;}
    break;

  case 62:
#line 274 "cal.y"
    {
                (yyval.type) = _vretained makeTypeSpecial(SpecialTypeShort);
            ;}
    break;

  case 63:
#line 278 "cal.y"
    {
                (yyval.type) = _vretained makeTypeSpecial(SpecialTypeInt);
            ;}
    break;

  case 64:
#line 282 "cal.y"
    {
                (yyval.type) = _vretained makeTypeSpecial(SpecialTypeLong);
            ;}
    break;

  case 65:
#line 286 "cal.y"
    {
                (yyval.type) = _vretained makeTypeSpecial(SpecialTypeLongLong);
            ;}
    break;

  case 66:
#line 290 "cal.y"
    {
                (yyval.type) = _vretained makeTypeSpecial(SpecialTypeDouble);
            ;}
    break;

  case 67:
#line 294 "cal.y"
    {
                (yyval.type) = _vretained makeTypeSpecial(SpecialTypeFloat);
            ;}
    break;

  case 68:
#line 298 "cal.y"
    {
                (yyval.type) = _vretained makeTypeSpecial(SpecialTypeClass);
            ;}
    break;

  case 69:
#line 302 "cal.y"
    {
                (yyval.type) = _vretained makeTypeSpecial(SpecialTypeBOOL);
            ;}
    break;

  case 70:
#line 306 "cal.y"
    {
                (yyval.type) = _vretained makeTypeSpecial(SpecialTypeVoid);
            ;}
    break;

  case 71:
#line 310 "cal.y"
    {
                (yyval.type) = _vretained makeTypeSpecial(SpecialTypeId);
            ;}
    break;

  case 72:
#line 314 "cal.y"
    {
                (yyval.type) = _vretained makeTypeSpecial(SpecialTypeObject,(__bridge NSString *)(yyvsp[(1) - (2)].identifier));
            ;}
    break;

  case 73:
#line 318 "cal.y"
    {
                (yyval.type) = _vretained makeTypeSpecial(SpecialTypeId);
            ;}
    break;

  case 74:
#line 322 "cal.y"
    {
                (yyval.type) = _vretained makeTypeSpecial(SpecialTypeBlock);
            ;}
    break;

  case 86:
#line 344 "cal.y"
    {
                (yyval.declare) = _vretained makeVariableDeclare(makeTypeSpecial(SpecialTypeBlock),(__bridge NSString *)(yyvsp[(4) - (5)].identifier));
            ;}
    break;

  case 92:
#line 359 "cal.y"
    {
                (yyval.declare) = _vretained [NSMutableArray array];
            ;}
    break;

  case 93:
#line 363 "cal.y"
    {
                NSMutableArray *array = [NSMutableArray array];
                [array addObject:_transfer(id)(yyvsp[(1) - (1)].type)];
                (yyval.declare) = _vretained array;
            ;}
    break;

  case 94:
#line 369 "cal.y"
    {
                NSMutableArray *array = _transfer(NSMutableArray *)(yyvsp[(1) - (3)].declare);
                [array addObject:_transfer(id) (yyvsp[(3) - (3)].type)];
                (yyval.declare) = _vretained array;
            ;}
    break;

  case 95:
#line 378 "cal.y"
    {   
                (yyval.declare) = _vretained makeMethodDeclare(NO,_transfer(TypeSpecial *) (yyvsp[(3) - (4)].type));
            ;}
    break;

  case 96:
#line 382 "cal.y"
    {
                (yyval.declare) = _vretained makeMethodDeclare(YES,_transfer(TypeSpecial *) (yyvsp[(3) - (4)].type));
            ;}
    break;

  case 97:
#line 386 "cal.y"
    {
                MethodDeclare *method = _transfer(MethodDeclare *)(yyval.declare);
                [method.methodNames addObject:_transfer(NSString *) (yyvsp[(2) - (2)].identifier)];
                (yyval.declare) = _vretained method;
            ;}
    break;

  case 98:
#line 392 "cal.y"
    {
                MethodDeclare *method = _transfer(MethodDeclare *)(yyval.declare);
                [method.methodNames addObject:_transfer(NSString *) (yyvsp[(2) - (7)].identifier)];
                [method.parameterTypes addObject:_transfer(TypeSpecial *) (yyvsp[(5) - (7)].type)];
                [method.parameterNames addObject:_transfer(NSString *) (yyvsp[(7) - (7)].identifier)];
                (yyval.declare) = _vretained method;
            ;}
    break;

  case 100:
#line 403 "cal.y"
    {
                NSMutableArray *list = [NSMutableArray array];
				[list addObject:_transfer(id)(yyvsp[(1) - (1)].expression)];
				(yyval.expression) = _vretained list;
            ;}
    break;

  case 101:
#line 409 "cal.y"
    {
                NSMutableArray *list = (__bridge_transfer NSMutableArray *)(yyvsp[(1) - (3)].expression);
				[list addObject:_transfer(id) (yyvsp[(3) - (3)].expression)];
				(yyval.expression) = (__bridge_retained void *)list;
            ;}
    break;

  case 104:
#line 421 "cal.y"
    {
             OCMethodCall *methodcall = (OCMethodCall *) makeValue(OCValueMethodCall);
             OCValue *caller = _transfer(OCValue *)(yyvsp[(1) - (3)].type);
             methodcall.caller =  caller;

             OCMethodCallGetElement *element = makeMethodCallElement(OCMethodCallDotGet);
             element.name = _transfer(NSString *)(yyvsp[(3) - (3)].identifier);
             methodcall.element = element;

             (yyval.expression) = _vretained methodcall;
         ;}
    break;

  case 105:
#line 434 "cal.y"
    {
             OCMethodCall *methodcall = (OCMethodCall *) makeValue(OCValueMethodCall);
             OCValue *caller = _transfer(OCValue *)(yyvsp[(1) - (6)].type);
             methodcall.caller = caller;

             OCMethodCallGetElement *element = makeMethodCallElement(OCMethodCallDotGet);
             element.name = _transfer(NSString *)(yyvsp[(3) - (6)].identifier);
             [element.values addObjectsFromArray:_transfer(id) (yyvsp[(5) - (6)].expression)];
             methodcall.element = element;

             (yyval.expression) = _vretained methodcall;
         ;}
    break;

  case 106:
#line 448 "cal.y"
    {
             OCMethodCall *methodcall = (OCMethodCall *) makeValue(OCValueMethodCall);
             methodcall.caller =  _transfer(OCValue *)(yyvsp[(1) - (3)].expression);

             OCMethodCallGetElement *element = makeMethodCallElement(OCMethodCallDotGet);
             element.name = _transfer(NSString *)(yyvsp[(3) - (3)].identifier);
             methodcall.element = element;

             (yyval.expression) = _vretained methodcall;
         ;}
    break;

  case 107:
#line 460 "cal.y"
    {
             OCMethodCall *methodcall = (OCMethodCall *) makeValue(OCValueMethodCall);
             methodcall.caller =  _transfer(OCValue *)(yyvsp[(1) - (6)].expression);

             OCMethodCallGetElement *element = makeMethodCallElement(OCMethodCallDotGet);
             element.name = _transfer(NSString *)(yyvsp[(3) - (6)].identifier);
             [element.values addObjectsFromArray:_transfer(id) (yyvsp[(5) - (6)].expression)];
             methodcall.element = element;

             (yyval.expression) = _vretained methodcall;
         ;}
    break;

  case 110:
#line 479 "cal.y"
    {
            OCMethodCallNormalElement *element = makeMethodCallElement(OCMethodCallNormalCall);
            [element.names addObject:_transfer(NSString *)(yyvsp[(1) - (1)].identifier)];
            (yyval.expression) = _vretained element;
        ;}
    break;

  case 111:
#line 485 "cal.y"
    {
            OCMethodCallNormalElement *element = makeMethodCallElement(OCMethodCallNormalCall);
            [element.names addObject:_transfer(NSString *)(yyvsp[(1) - (3)].identifier)];
            [element.values addObjectsFromArray:_transfer(id)(yyvsp[(3) - (3)].expression)];
            (yyval.expression) = _vretained element;
        ;}
    break;

  case 112:
#line 492 "cal.y"
    {
            OCMethodCallNormalElement *element = _transfer(OCMethodCallNormalElement *)(yyvsp[(1) - (4)].expression);
            [element.names addObject:_transfer(NSString *)(yyvsp[(2) - (4)].identifier)];
            [element.values addObjectsFromArray:_transfer(id)(yyvsp[(4) - (4)].expression)];
            (yyval.expression) = _vretained element;
        ;}
    break;

  case 114:
#line 507 "cal.y"
    {
             OCMethodCall *methodcall = (OCMethodCall *) makeValue(OCValueMethodCall);
             OCValue *caller = _transfer(OCValue *)(yyvsp[(2) - (4)].type);
             methodcall.caller =  caller;
             methodcall.element = _transfer(id <OCMethodElement>)(yyvsp[(3) - (4)].expression);
             (yyval.type) = _vretained methodcall;
        ;}
    break;

  case 115:
#line 519 "cal.y"
    {
            BlockImp *imp = (BlockImp *)makeValue(OCValueBlock);
            imp.funcImp = _transfer(id)(yyvsp[(4) - (5)].expression);
            imp.declare = makeFuncDeclare(_transfer(id)(yyvsp[(2) - (5)].type),nil);
            (yyval.expression) = _vretained imp; 
        ;}
    break;

  case 116:
#line 527 "cal.y"
    {
            BlockImp *imp = (BlockImp *)makeValue(OCValueBlock);
            imp.declare = makeFuncDeclare(_transfer(id)(yyvsp[(2) - (8)].type),_transfer(id)(yyvsp[(4) - (8)].declare));
            imp.funcImp = _transfer(id)(yyvsp[(7) - (8)].expression);
            (yyval.expression) = _vretained imp; 
        ;}
    break;

  case 117:
#line 535 "cal.y"
    {
            BlockImp *imp = (BlockImp *)makeValue(OCValueBlock);
            imp.declare = makeFuncDeclare(makeTypeSpecial(SpecialTypeVoid),nil);
            imp.funcImp = _transfer(id)(yyvsp[(3) - (4)].expression);
            (yyval.expression) = _vretained imp; 
        ;}
    break;

  case 118:
#line 543 "cal.y"
    {
            BlockImp *imp = (BlockImp *)makeValue(OCValueBlock);
            imp.declare = makeFuncDeclare(makeTypeSpecial(SpecialTypeVoid),_transfer(id) (yyvsp[(3) - (7)].declare));
            imp.funcImp = _transfer(id)(yyvsp[(6) - (7)].expression);
            (yyval.expression) = _vretained imp; 
        ;}
    break;

  case 119:
#line 552 "cal.y"
    {
            (yyval.type) = _vretained makeValue(OCValueObject,_transfer(id)(yyvsp[(1) - (1)].identifier));
        ;}
    break;

  case 120:
#line 556 "cal.y"
    {
            (yyval.type) = _vretained makeValue(OCValueSelf,_transfer(id)(yyvsp[(1) - (1)].identifier));
        ;}
    break;

  case 121:
#line 560 "cal.y"
    {
            (yyval.type) = _vretained makeValue(OCValueSuper,_transfer(id)(yyvsp[(1) - (1)].identifier));
        ;}
    break;

  case 122:
#line 566 "cal.y"
    {
            (yyval.type) = _vretained makeValue(OCValueNSNumber,_transfer(id)(yyvsp[(3) - (4)].expression));
        ;}
    break;

  case 123:
#line 570 "cal.y"
    {
            (yyval.type) = _vretained makeValue(OCValueNSNumber,_transfer(id)(yyvsp[(2) - (2)].expression));
        ;}
    break;

  case 124:
#line 575 "cal.y"
    {
//            $$ = _vretained makeValue(OCValueString,_transfer(id)$2);
            (yyval.type) = _vretained makeValue(OCValueString);
        ;}
    break;

  case 126:
#line 582 "cal.y"
    {
            CFuncCall *call = makeValue(OCValueFuncCall);
            call.name = _transfer(id) (yyvsp[(1) - (4)].identifier);
            call.expressions = _transfer(id) (yyvsp[(3) - (4)].expression);
            (yyval.type) = _vretained call;
        ;}
    break;

  case 130:
#line 599 "cal.y"
    {
            (yyval.expression) = _vretained makeValue(OCValueSelector,_transfer(id)(yyvsp[(1) - (1)].identifier));
        ;}
    break;

  case 131:
#line 603 "cal.y"
    {
            (yyval.expression) = _vretained makeValue(OCValueProtocol,_transfer(id)(yyvsp[(3) - (4)].identifier));
        ;}
    break;

  case 132:
#line 607 "cal.y"
    {
            (yyval.expression) = _vretained makeValue(OCValueCString,_transfer(id)(yyvsp[(1) - (1)].identifier));
        ;}
    break;

  case 134:
#line 612 "cal.y"
    {
            (yyval.expression) = _vretained makeValue(OCValueNumber,_transfer(id)(yyvsp[(1) - (1)].expression));
        ;}
    break;

  case 135:
#line 616 "cal.y"
    {
            (yyval.expression) = _vretained makeValue(OCValueConvert,_transfer(id)(yyvsp[(4) - (4)].expression));
        ;}
    break;

  case 136:
#line 620 "cal.y"
    {
            (yyval.expression) = _vretained makeValue(OCValueNil);
        ;}
    break;

  case 137:
#line 624 "cal.y"
    {
            (yyval.expression) = _vretained makeValue(OCValueNULL);
        ;}
    break;

  case 138:
#line 628 "cal.y"
    {
            (yyval.expression) = _vretained makeValue(OCValuePointValue,_transfer(id)(yyvsp[(2) - (2)].identifier));
        ;}
    break;

  case 139:
#line 632 "cal.y"
    {
            (yyval.expression) = _vretained makeValue(OCValueVarPoint,_transfer(id)(yyvsp[(2) - (2)].identifier));
        ;}
    break;

  case 140:
#line 641 "cal.y"
    {
            (yyval.Operator) = AssignOperatorAssign;
        ;}
    break;

  case 141:
#line 645 "cal.y"
    {
            (yyval.Operator) = AssignOperatorAssignAnd;
        ;}
    break;

  case 142:
#line 649 "cal.y"
    {
            (yyval.Operator) = AssignOperatorAssignOr;
        ;}
    break;

  case 143:
#line 653 "cal.y"
    {
            (yyval.Operator) = AssignOperatorAssignXor;
        ;}
    break;

  case 144:
#line 657 "cal.y"
    {
            (yyval.Operator) = AssignOperatorAssignAdd;
        ;}
    break;

  case 145:
#line 661 "cal.y"
    {
            (yyval.Operator) = AssignOperatorAssignSub;
        ;}
    break;

  case 146:
#line 665 "cal.y"
    {
            (yyval.Operator) = AssignOperatorAssignDiv;
        ;}
    break;

  case 147:
#line 669 "cal.y"
    {
            (yyval.Operator) = AssignOperatorAssignMuti;
        ;}
    break;

  case 148:
#line 673 "cal.y"
    {
            (yyval.Operator) = AssignOperatorAssignMod;
        ;}
    break;

  case 149:
#line 680 "cal.y"
    {
            (yyval.Operator) = UnaryOperatorIncrement;
        ;}
    break;

  case 150:
#line 684 "cal.y"
    {
            (yyval.Operator) = UnaryOperatorDecrement;
        ;}
    break;

  case 151:
#line 691 "cal.y"
    {
            (yyval.Operator) = BinaryOperatorAdd;
        ;}
    break;

  case 152:
#line 695 "cal.y"
    {
            (yyval.Operator) = BinaryOperatorSub;
        ;}
    break;

  case 153:
#line 699 "cal.y"
    {
            (yyval.Operator) = BinaryOperatorMulti;
        ;}
    break;

  case 154:
#line 703 "cal.y"
    {
            (yyval.Operator) = BinaryOperatorDiv;
        ;}
    break;

  case 155:
#line 707 "cal.y"
    {
            (yyval.Operator) = BinaryOperatorMod;
        ;}
    break;

  case 156:
#line 711 "cal.y"
    {
            (yyval.Operator) = BinaryOperatorShiftLeft;
        ;}
    break;

  case 157:
#line 715 "cal.y"
    {
            (yyval.Operator) = BinaryOperatorShiftRight;
        ;}
    break;

  case 158:
#line 719 "cal.y"
    {
            (yyval.Operator) = BinaryOperatorAnd;
        ;}
    break;

  case 159:
#line 723 "cal.y"
    {
            (yyval.Operator) = BinaryOperatorOr;
        ;}
    break;

  case 160:
#line 727 "cal.y"
    {
            (yyval.Operator) = BinaryOperatorXor;
        ;}
    break;

  case 161:
#line 737 "cal.y"
    {
            TernaryExpression *expression = makeTernaryExpression();
            expression.judgeExpression = _transfer(JudgementExpression *)(yyvsp[(1) - (6)].expression);
            [expression.values addObject:_transfer(id)(yyvsp[(3) - (6)].expression)];
            [expression.values addObject:_transfer(id)(yyvsp[(5) - (6)].identifier)];
            (yyval.expression) = _vretained expression;
        ;}
    break;

  case 162:
#line 745 "cal.y"
    {
            TernaryExpression *expression = makeTernaryExpression();
            expression.judgeExpression = _transfer(JudgementExpression *)(yyvsp[(1) - (4)].expression);
            [expression.values addObject:_transfer(id)(yyvsp[(4) - (4)].expression)];
            (yyval.expression) = _vretained expression;
        ;}
    break;

  case 163:
#line 755 "cal.y"
    {
             BinaryExpression *expression = makeBinaryExpression((yyvsp[(2) - (3)].Operator));
             expression.left = _transfer(id) (yyvsp[(1) - (3)].expression);
             expression.right = _transfer(id) (yyvsp[(3) - (3)].expression);
             (yyval.expression) = _vretained expression;
        ;}
    break;

  case 164:
#line 762 "cal.y"
    {
            UnaryExpression *expression = makeUnaryExpression((yyvsp[(2) - (2)].Operator));
            expression.value = _transfer(id) (yyvsp[(1) - (2)].expression);
            (yyval.expression) = _vretained expression;
        ;}
    break;

  case 165:
#line 768 "cal.y"
    {
            log(@"ternary");
        ;}
    break;

  case 166:
#line 775 "cal.y"
    {
            (yyval.Operator) = JudgementOperatorEQ;
        ;}
    break;

  case 167:
#line 779 "cal.y"
    {
            (yyval.Operator) = JudgementOperatorNE;
        ;}
    break;

  case 168:
#line 783 "cal.y"
    {
            (yyval.Operator) = JudgementOperatorLE;
        ;}
    break;

  case 169:
#line 787 "cal.y"
    {
            (yyval.Operator) = JudgementOperatorLT;
        ;}
    break;

  case 170:
#line 791 "cal.y"
    {
            (yyval.Operator) = JudgementOperatorGE;
        ;}
    break;

  case 171:
#line 795 "cal.y"
    {
            (yyval.Operator) = JudgementOperatorGT;
        ;}
    break;

  case 172:
#line 799 "cal.y"
    {
            (yyval.Operator) = JudgementOperatorAND;
        ;}
    break;

  case 173:
#line 803 "cal.y"
    {
            (yyval.Operator) = JudgementOperatorOR;
        ;}
    break;

  case 174:
#line 815 "cal.y"
    {
             JudgementExpression *expression = makeJudgementExpression(JudgementOperatorNOT);
             expression.left = _transfer(id) (yyvsp[(2) - (2)].expression);
             (yyval.expression) = _vretained expression;
         ;}
    break;

  case 175:
#line 821 "cal.y"
    {
             JudgementExpression *expression = makeJudgementExpression((yyvsp[(2) - (3)].Operator));
             expression.left = _transfer(id) (yyvsp[(1) - (3)].expression);
             expression.right = _transfer(id) (yyvsp[(3) - (3)].expression);
             (yyval.expression) = _vretained expression;
         ;}
    break;

  case 179:
#line 834 "cal.y"
    {
            (yyval.expression) = (yyvsp[(2) - (3)].expression);
        ;}
    break;

  case 180:
#line 841 "cal.y"
    {
            ControlExpression *expression = makeControlExpression(ControlExpressionReturn);
            (yyval.expression) = _vretained expression;
        ;}
    break;

  case 181:
#line 846 "cal.y"
    {
            ControlExpression *expression = makeControlExpression(ControlExpressionReturn);
            expression.expression = _transfer(id) (yyvsp[(2) - (2)].expression);
            (yyval.expression) = _vretained expression;
        ;}
    break;

  case 182:
#line 852 "cal.y"
    {
            (yyval.expression) = _vretained makeControlExpression(ControlExpressionBreak);
        ;}
    break;

  case 183:
#line 856 "cal.y"
    {
            (yyval.expression) = _vretained makeControlExpression(ControlExpressionContinue);
        ;}
    break;

  case 184:
#line 860 "cal.y"
    {
            (yyval.expression) = _vretained makeControlExpression(ControlExpressionGoto);
        ;}
    break;

  case 187:
#line 871 "cal.y"
    {
            DeclareAssignExpression *expression = makeDeaclareAssignExpression(_transfer(VariableDeclare *) (yyvsp[(1) - (1)].declare));
            (yyval.expression) = _vretained expression;
        ;}
    break;

  case 188:
#line 876 "cal.y"
    {
            DeclareAssignExpression *expression = makeDeaclareAssignExpression(_transfer(VariableDeclare *) (yyvsp[(1) - (3)].declare));
            expression.expression = _transfer(id) (yyvsp[(3) - (3)].expression);
            (yyval.expression) = _vretained expression;
        ;}
    break;

  case 189:
#line 884 "cal.y"
    {
            VariableAssignExpression *expression = makeVarAssignExpression((yyvsp[(2) - (3)].Operator));
            expression.expression = _transfer(id) (yyvsp[(3) - (3)].expression);
            expression.value = _transfer(OCValue *)(yyvsp[(1) - (3)].expression);
            (yyval.expression) = _vretained expression;
        ;}
    break;

  case 193:
#line 900 "cal.y"
    {
            IfStatement *statement = makeIfStatement(_transfer(id) (yyvsp[(3) - (7)].expression),_transfer(FunctionImp *)(yyvsp[(5) - (7)].identifier));
            (yyval.statement) = _vretained statement;
         ;}
    break;

  case 194:
#line 905 "cal.y"
    {
            IfStatement *statement = _transfer(IfStatement *)(yyvsp[(1) - (9)].statement);
            IfStatement *elseIfStatement = makeIfStatement(_transfer(id) (yyvsp[(5) - (9)].expression),_transfer(FunctionImp *)(yyvsp[(8) - (9)].expression));
            elseIfStatement.last = statement;
            (yyval.statement)  = _vretained elseIfStatement;
        ;}
    break;

  case 195:
#line 912 "cal.y"
    {
            IfStatement *statement = _transfer(IfStatement *)(yyvsp[(1) - (5)].statement);
            IfStatement *elseStatement = makeIfStatement(nil,_transfer(FunctionImp *)(yyvsp[(4) - (5)].expression));
            elseStatement.last = statement;
            (yyval.statement)  = _vretained elseStatement;
        ;}
    break;

  case 196:
#line 922 "cal.y"
    {
            DoWhileStatement *statement = makeDoWhileStatement(_transfer(id)(yyvsp[(5) - (8)].identifier),_transfer(FunctionImp *)(yyvsp[(3) - (8)].expression));
            (yyval.statement) = _vretained statement;
        ;}
    break;

  case 197:
#line 929 "cal.y"
    {
            WhileStatement *statement = makeWhileStatement(_transfer(id)(yyvsp[(3) - (7)].expression),_transfer(FunctionImp *)(yyvsp[(6) - (7)].expression));
            (yyval.statement) = _vretained statement;
        ;}
    break;

  case 198:
#line 944 "cal.y"
    {
             (yyval.statement) = _vretained makeCaseStatement(_transfer(OCValue *)(yyvsp[(2) - (3)].expression));
         ;}
    break;

  case 199:
#line 948 "cal.y"
    {
            (yyval.statement) = _vretained makeCaseStatement(nil);
        ;}
    break;

  case 200:
#line 952 "cal.y"
    {
            CaseStatement *statement =  _transfer(CaseStatement *)(yyvsp[(1) - (4)].statement);
            statement.funcImp = _transfer(FunctionImp *) (yyvsp[(3) - (4)].expression);
            (yyval.statement) = _vretained statement;
        ;}
    break;

  case 201:
#line 960 "cal.y"
    {
             SwitchStatement *statement = makeSwitchStatement(_transfer(id) (yyvsp[(3) - (5)].expression));
             (yyval.statement) = _vretained statement;
         ;}
    break;

  case 202:
#line 965 "cal.y"
    {
            SwitchStatement *statement = _transfer(SwitchStatement *)(yyvsp[(1) - (2)].statement);
            [statement.cases addObject:_transfer(id) (yyvsp[(2) - (2)].statement)];
            (yyval.statement) = _vretained statement;
        ;}
    break;

  case 204:
#line 979 "cal.y"
    {
            NSMutableArray *expressions = [NSMutableArray array];
            [expressions addObject:_transfer(id)(yyvsp[(1) - (1)].expression)];
            (yyval.expression) = _vretained expressions;
        ;}
    break;

  case 205:
#line 985 "cal.y"
    {
            NSMutableArray *expressions = _transfer(NSMutableArray *)(yyval.expression);
            [expressions addObject:_transfer(id) (yyvsp[(3) - (3)].expression)];
            (yyval.expression) = _vretained expressions;
        ;}
    break;

  case 206:
#line 992 "cal.y"
    {
            ForStatement* statement = makeForStatement(_transfer(FunctionImp *) (yyvsp[(6) - (7)].expression));
            statement.expressions = _transfer(NSMutableArray *) (yyvsp[(3) - (7)].expression);
            (yyval.statement) = _vretained statement;
        ;}
    break;

  case 207:
#line 1000 "cal.y"
    {
            ForInStatement * statement = makeForInStatement(_transfer(FunctionImp *)(yyvsp[(8) - (9)].expression));
            statement.declare = _transfer(id) (yyvsp[(3) - (9)].declare);
            statement.value = _transfer(id)(yyvsp[(5) - (9)].expression);
            (yyval.statement) = _vretained statement;
        ;}
    break;

  case 214:
#line 1020 "cal.y"
    {
            (yyval.expression) = _vretained makeFuncImp();
        ;}
    break;

  case 215:
#line 1024 "cal.y"
    {
            FunctionImp *imp = _transfer(FunctionImp *)(yyvsp[(1) - (2)].expression);
            [imp.statements addObject:_transfer(id) (yyvsp[(2) - (2)].expression)];
            (yyval.expression) = _vretained imp;
        ;}
    break;

  case 216:
#line 1030 "cal.y"
    {
            FunctionImp *imp = _transfer(FunctionImp *)(yyvsp[(1) - (2)].expression);
            [imp.statements addObject:_transfer(id) (yyvsp[(2) - (2)].statement)];
            (yyval.expression) = _vretained imp;
        ;}
    break;


/* Line 1267 of yacc.c.  */
#line 3621 "cal.tab.c"
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


#line 1038 "cal.y"

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

}


/* A Bison parser, made by GNU Bison 3.3.2.  */

/* Bison implementation for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2019 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

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

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Bison version.  */
#define YYBISON_VERSION "3.3.2"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1




/* First part of user prologue.  */
#line 1 "cal.y" /* yacc.c:337  */

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

#line 84 "cal.tab.c" /* yacc.c:337  */
# ifndef YY_NULLPTR
#  if defined __cplusplus
#   if 201103L <= __cplusplus
#    define YY_NULLPTR nullptr
#   else
#    define YY_NULLPTR 0
#   endif
#  else
#   define YY_NULLPTR ((void*)0)
#  endif
# endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 0
#endif


/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    level3 = 258,
    level2 = 259,
    level1 = 260,
    IF = 261,
    ENDIF = 262,
    IFDEF = 263,
    IFNDEF = 264,
    UNDEF = 265,
    IMPORT = 266,
    INCLUDE = 267,
    TILDE = 268,
    QUESTION = 269,
    _return = 270,
    _break = 271,
    _continue = 272,
    _goto = 273,
    _else = 274,
    _while = 275,
    _do = 276,
    _in = 277,
    _for = 278,
    _case = 279,
    _switch = 280,
    _default = 281,
    _enum = 282,
    _typeof = 283,
    _struct = 284,
    _sizeof = 285,
    INTERFACE = 286,
    IMPLEMENTATION = 287,
    PROTOCOL = 288,
    END = 289,
    CLASS_DECLARE = 290,
    PROPERTY = 291,
    WEAK = 292,
    STRONG = 293,
    COPY = 294,
    ASSIGN_MEM = 295,
    NONATOMIC = 296,
    ATOMIC = 297,
    READONLY = 298,
    READWRITE = 299,
    NONNULL = 300,
    NULLABLE = 301,
    EXTERN = 302,
    STATIC = 303,
    CONST = 304,
    _NONNULL = 305,
    _NULLABLE = 306,
    _STRONG = 307,
    _WEAK = 308,
    _BLOCK = 309,
    _BRIDGE = 310,
    IDENTIFIER = 311,
    STRING_LITERAL = 312,
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

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 14 "cal.y" /* yacc.c:352  */

    void *identifier;
    void *include;
    void *type;
    void *declare;
    void *implementation;
    void *statement;
    void *expression;
    int Operator;

#line 264 "cal.tab.c" /* yacc.c:352  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);





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
#else
typedef signed char yytype_int8;
#endif

#ifdef YYTYPE_UINT16
typedef YYTYPE_UINT16 yytype_uint16;
#else
typedef unsigned short yytype_uint16;
#endif

#ifdef YYTYPE_INT16
typedef YYTYPE_INT16 yytype_int16;
#else
typedef short yytype_int16;
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif ! defined YYSIZE_T
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned
# endif
#endif

#define YYSIZE_MAXIMUM ((YYSIZE_T) -1)

#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(Msgid) dgettext ("bison-runtime", Msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(Msgid) Msgid
# endif
#endif

#ifndef YY_ATTRIBUTE
# if (defined __GNUC__                                               \
      && (2 < __GNUC__ || (__GNUC__ == 2 && 96 <= __GNUC_MINOR__)))  \
     || defined __SUNPRO_C && 0x5110 <= __SUNPRO_C
#  define YY_ATTRIBUTE(Spec) __attribute__(Spec)
# else
#  define YY_ATTRIBUTE(Spec) /* empty */
# endif
#endif

#ifndef YY_ATTRIBUTE_PURE
# define YY_ATTRIBUTE_PURE   YY_ATTRIBUTE ((__pure__))
#endif

#ifndef YY_ATTRIBUTE_UNUSED
# define YY_ATTRIBUTE_UNUSED YY_ATTRIBUTE ((__unused__))
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(E) ((void) (E))
#else
# define YYUSE(E) /* empty */
#endif

#if defined __GNUC__ && ! defined __ICC && 407 <= __GNUC__ * 100 + __GNUC_MINOR__
/* Suppress an incorrect diagnostic about yylval being uninitialized.  */
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN \
    _Pragma ("GCC diagnostic push") \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")\
    _Pragma ("GCC diagnostic ignored \"-Wmaybe-uninitialized\"")
# define YY_IGNORE_MAYBE_UNINITIALIZED_END \
    _Pragma ("GCC diagnostic pop")
#else
# define YY_INITIAL_VALUE(Value) Value
#endif
#ifndef YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_END
#endif
#ifndef YY_INITIAL_VALUE
# define YY_INITIAL_VALUE(Value) /* Nothing. */
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
#    if ! defined _ALLOCA_H && ! defined EXIT_SUCCESS
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
      /* Use EXIT_SUCCESS as a witness for stdlib.h.  */
#     ifndef EXIT_SUCCESS
#      define EXIT_SUCCESS 0
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's 'empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (0)
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
#  if (defined __cplusplus && ! defined EXIT_SUCCESS \
       && ! ((defined YYMALLOC || defined malloc) \
             && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef EXIT_SUCCESS
#    define EXIT_SUCCESS 0
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined EXIT_SUCCESS
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined EXIT_SUCCESS
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
  yytype_int16 yyss_alloc;
  YYSTYPE yyvs_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (sizeof (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (sizeof (yytype_int16) + sizeof (YYSTYPE)) \
      + YYSTACK_GAP_MAXIMUM)

# define YYCOPY_NEEDED 1

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)                           \
    do                                                                  \
      {                                                                 \
        YYSIZE_T yynewbytes;                                            \
        YYCOPY (&yyptr->Stack_alloc, Stack, yysize);                    \
        Stack = &yyptr->Stack_alloc;                                    \
        yynewbytes = yystacksize * sizeof (*Stack) + YYSTACK_GAP_MAXIMUM; \
        yyptr += yynewbytes / sizeof (*yyptr);                          \
      }                                                                 \
    while (0)

#endif

#if defined YYCOPY_NEEDED && YYCOPY_NEEDED
/* Copy COUNT objects from SRC to DST.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(Dst, Src, Count) \
      __builtin_memcpy (Dst, Src, (Count) * sizeof (*(Src)))
#  else
#   define YYCOPY(Dst, Src, Count)              \
      do                                        \
        {                                       \
          YYSIZE_T yyi;                         \
          for (yyi = 0; yyi < (Count); yyi++)   \
            (Dst)[yyi] = (Src)[yyi];            \
        }                                       \
      while (0)
#  endif
# endif
#endif /* !YYCOPY_NEEDED */

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  137
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   2776

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  129
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  54
/* YYNRULES -- Number of rules.  */
#define YYNRULES  218
/* YYNSTATES -- Number of states.  */
#define YYNSTATES  418

#define YYUNDEFTOK  2
#define YYMAXUTOK   383

/* YYTRANSLATE(TOKEN-NUM) -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex, with out-of-bounds checking.  */
#define YYTRANSLATE(YYX)                                                \
  ((unsigned) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[TOKEN-NUM] -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex.  */
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
  /* YYRLINE[YYN] -- Source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,    54,    54,    55,    57,    58,    61,    62,    63,    64,
      68,    72,    73,    81,    84,    85,    86,    87,    91,    98,
     102,   106,   112,   118,   130,   131,   134,   139,   143,   149,
     157,   159,   166,   176,   180,   189,   190,   191,   192,   193,
     194,   195,   196,   197,   198,   202,   206,   211,   217,   226,
     230,   239,   243,   244,   246,   250,   254,   258,   262,   266,
     270,   274,   278,   282,   286,   290,   294,   298,   302,   306,
     310,   320,   324,   328,   332,   341,   342,   343,   344,   345,
     346,   347,   348,   349,   352,   353,   354,   357,   358,   362,
     363,   366,   369,   375,   384,   388,   392,   398,   409,   415,
     422,   431,   443,   451,   459,   467,   478,   482,   490,   493,
     494,   495,   499,   503,   507,   514,   519,   526,   536,   543,
     558,   562,   566,   574,   579,   585,   593,   599,   606,   614,
     625,   626,   627,   628,   629,   630,   635,   638,   644,   653,
     659,   668,   672,   676,   680,   684,   688,   692,   696,   700,
     707,   708,   718,   719,   727,   738,   739,   749,   750,   759,
     760,   769,   770,   780,   781,   791,   792,   799,   808,   809,
     816,   823,   830,   839,   840,   847,   856,   857,   864,   874,
     875,   882,   889,   899,   900,   906,   912,   918,   924,   930,
     936,   940,   946,   952,   958,   967,   971,   977,   983,   991,
     995,   999,  1003,  1004,  1014,  1023,  1038,  1042,  1046,  1050,
    1054,  1058,  1062,  1066,  1070,  1074,  1075,  1076,  1080
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || 0
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "level3", "level2", "level1", "IF",
  "ENDIF", "IFDEF", "IFNDEF", "UNDEF", "IMPORT", "INCLUDE", "TILDE",
  "QUESTION", "_return", "_break", "_continue", "_goto", "_else", "_while",
  "_do", "_in", "_for", "_case", "_switch", "_default", "_enum", "_typeof",
  "_struct", "_sizeof", "INTERFACE", "IMPLEMENTATION", "PROTOCOL", "END",
  "CLASS_DECLARE", "PROPERTY", "WEAK", "STRONG", "COPY", "ASSIGN_MEM",
  "NONATOMIC", "ATOMIC", "READONLY", "READWRITE", "NONNULL", "NULLABLE",
  "EXTERN", "STATIC", "CONST", "_NONNULL", "_NULLABLE", "_STRONG", "_WEAK",
  "_BLOCK", "_BRIDGE", "IDENTIFIER", "STRING_LITERAL", "COMMA", "COLON",
  "SEMICOLON", "LP", "RP", "RIP", "LB", "RB", "LC", "RC", "DOT", "AT",
  "PS", "POINT", "EQ", "NE", "LT", "LE", "GT", "GE", "LOGIC_AND",
  "LOGIC_OR", "NOT", "AND", "OR", "POWER", "SUB", "ADD", "DIV", "ASTERISK",
  "AND_ASSIGN", "OR_ASSIGN", "POWER_ASSIGN", "SUB_ASSIGN", "ADD_ASSIGN",
  "DIV_ASSIGN", "ASTERISK_ASSIGN", "INCREMENT", "DECREMENT", "SHIFTLEFT",
  "SHIFTRIGHT", "MOD", "ASSIGN", "MOD_ASSIGN", "_self", "_super", "_nil",
  "_NULL", "_YES", "_NO", "_Class", "_id", "_void", "_BOOL", "_SEL",
  "_CHAR", "_SHORT", "_INT", "_LONG", "_LLONG", "_UCHAR", "_USHORT",
  "_UINT", "_ULONG", "_ULLONG", "_DOUBLE", "_FLOAT", "_instancetype",
  "INTETER_LITERAL", "DOUBLE_LITERAL", "SELECTOR", "$accept",
  "compile_util", "definition_list", "definition", "PS_Define",
  "includeHeader", "class_declare", "class_implementation",
  "protocol_list", "class_private_varibale_declare", "class_property_type",
  "class_property_declare", "declare_variable", "type_specified",
  "declare_left_attribute", "declare_right_attribute", "block_type",
  "block_parametere_type", "func_declare_parameters", "method_declare",
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
  "dict_entry", "primary_expression", YY_NULLPTR
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[NUM] -- (External) token number corresponding to the
   (internal) symbol number NUM (which must be that of a token).  */
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

#define YYPACT_NINF -184

#define yypact_value_is_default(Yystate) \
  (!!((Yystate) == (-184)))

#define YYTABLE_NINF -72

#define yytable_value_is_error(Yytable_value) \
  0

  /* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
     STATE-NUM.  */
static const yytype_int16 yypact[] =
{
     390,   -44,  2408,  2327,   -46,   -20,   -13,   -10,    -1,    21,
      52,  2408,    13,    19,    74,  -184,  -184,  -184,  -184,  -184,
    -184,  -184,  -184,  -184,    -4,  -184,  2228,   149,   -48,   129,
    2408,  2408,  2499,  2408,  2408,  2408,  2408,  -184,  -184,  -184,
    -184,  -184,  -184,  -184,  -184,  -184,  -184,  -184,  -184,  -184,
    -184,  -184,  -184,  -184,  -184,  -184,  -184,  -184,  -184,  -184,
    -184,   146,   390,  -184,  -184,    15,   -11,    55,    37,  2651,
      99,  -184,  -184,   113,  -184,   168,  -184,  -184,    -2,  -184,
    -184,  -184,   143,  -184,    -7,    90,   107,   117,   135,    94,
     204,   123,   151,    17,   144,  -184,   230,  2408,  -184,   144,
      41,  -184,   165,  -184,  -184,  -184,  2408,  -184,  2228,  2408,
    2408,   144,    33,   167,   174,    46,   171,  2408,    88,  -184,
    2408,  2408,  2408,  -184,  -184,  -184,   -24,   144,   144,  -184,
    2651,  -184,   114,   144,   144,   144,   144,  -184,  -184,  -184,
     182,  -184,   191,   194,   197,    45,  -184,  -184,   -30,  2408,
    -184,  -184,  -184,   206,   187,  2651,  -184,  -184,   304,  2651,
    -184,    14,   149,   214,  -184,   226,  -184,  2356,  2408,  2408,
    2408,  2408,  2408,  2408,  2408,  2408,  2408,  2408,  2408,  2408,
    2408,  2408,  2408,  2408,  2408,  2408,  -184,  -184,  2408,   238,
     240,  -184,  -184,  -184,  -184,  -184,  -184,  -184,  -184,  -184,
    2408,   243,  -184,   245,   513,   278,   284,  -184,    92,   246,
     251,   259,    -3,   260,   255,   219,  2408,  -184,   269,   -35,
     274,  -184,   -33,   283,    18,  -184,   287,  -184,   284,  -184,
      65,   636,  2521,  -184,  -184,  2477,  2605,  -184,   -47,  2651,
    2651,   285,  -184,  2628,  -184,  -184,  2651,     5,   120,    89,
     288,  -184,   158,  -184,  -184,  2408,   289,   267,   107,   117,
     135,    94,   204,   204,   123,   123,   123,   123,   151,   151,
      17,    17,   144,   144,   144,   116,  -184,  -184,  -184,   290,
     291,   331,  -184,  -184,  2408,  -184,  2408,   293,   294,  -184,
    -184,   299,  -184,   300,  -184,   305,   144,  2408,   309,  -184,
    -184,  2408,  -184,  2408,  2408,  -184,   286,  2651,   303,  -184,
     121,   759,  -184,  -184,  -184,  -184,  -184,  -184,  -184,  -184,
     128,   137,   140,   310,  -184,   314,   319,  -184,   195,   210,
     315,  -184,   882,   150,   320,  -184,  -184,  -184,  2408,  1005,
    -184,  1128,  -184,  2408,  -184,  -184,  -184,   316,   322,  -184,
    -184,  -184,  -184,  -184,   323,  2408,  -184,  -184,   327,   332,
    -184,  -184,   326,  -184,  -184,  -184,  -184,  -184,  -184,  -184,
    -184,  2651,  -184,    24,   328,   333,  -184,  -184,  -184,  1251,
    1374,  2408,   334,  1497,   323,  2408,   325,  1620,  -184,   276,
    -184,  -184,  2651,   335,  -184,  -184,   336,  -184,  -184,  -184,
     341,  -184,  1743,   343,  1866,   153,  -184,  -184,  1989,   340,
    -184,  -184,  -184,  -184,  2112,  -184,  -184,  -184
};

  /* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
     Performed when YYTABLE does not specify something else to do.  Zero
     means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       2,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,    78,    79,    75,    76,    77,
      80,    81,    82,    83,   199,   214,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,   200,   201,   217,
     218,    67,    72,    69,    68,    60,    61,    62,    63,    64,
      55,    56,    57,    58,    59,    65,    66,    70,   195,   196,
     212,     0,     3,     4,     6,     7,     8,   106,     0,     0,
      73,   202,   215,     0,     9,   130,   133,   132,   131,   134,
     135,    10,     0,   150,   152,   155,   157,   159,   161,   163,
     165,   168,   173,   176,   179,   216,   183,     0,   199,   188,
     183,   111,     0,   108,   113,   114,     0,   136,     0,     0,
       0,   189,     0,    26,     0,     0,     0,     0,     0,   211,
       0,     0,     0,   210,    14,    15,    13,   184,   187,    71,
      91,   136,     0,   185,   186,   193,   194,     1,     5,    25,
      45,    33,     0,     0,     0,     0,    30,    33,     0,     0,
      86,    84,    85,    49,     0,     0,    74,    53,    51,    91,
     110,     0,     0,     0,   125,   124,   109,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,   191,   192,     0,     0,
       0,   142,   143,   144,   146,   145,   147,   148,   141,   149,
       0,     0,   112,     0,     0,     0,     0,   126,     0,     0,
       0,     0,     0,     0,     0,     0,     0,   206,    98,     0,
       0,   139,     0,     0,     0,    17,     0,    89,    90,    92,
       0,     0,    91,   136,    46,     0,     0,    31,     0,     0,
       0,    96,    24,     0,   136,   107,    91,     0,     0,     0,
       0,   136,     0,   121,   136,     0,     0,   156,   158,   160,
     162,   164,   166,   167,   169,   170,   171,   172,   174,   175,
     178,   177,   181,   180,   182,     0,   203,   204,   151,     0,
       0,     0,   137,   138,     0,    49,     0,     0,     0,    54,
      18,     0,    20,     0,   213,     0,   190,     0,     0,   101,
     209,     0,   208,     0,     0,   207,     0,     0,     0,   104,
       0,     0,    36,    37,    38,    35,    39,    40,    41,    42,
      78,    79,     0,     0,    22,     0,     0,    21,     0,     0,
       0,    28,     0,     0,     0,    87,    52,    88,     0,     0,
     120,     0,   154,     0,   205,   136,   136,     0,     0,   127,
     136,   123,    19,    27,    99,     0,   140,   197,     0,     0,
      93,   136,     0,   102,    47,    48,    23,    34,    32,    94,
      95,     0,    29,     0,     0,     0,   117,   122,   153,     0,
       0,     0,     0,     0,   100,     0,     0,     0,   136,     0,
      11,   136,    91,     0,   115,   119,     0,   136,   128,   198,
       0,   105,     0,     0,     0,     0,   136,   118,     0,     0,
     103,    97,    12,    50,     0,   129,    16,   116
};

  /* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -184,  -184,  -184,   350,  -184,  -184,  -184,  -184,  -184,   270,
    -184,  -184,   -93,     2,  -184,  -184,  -184,   112,  -155,   358,
    -184,  -184,  -184,  -184,    28,     1,  -184,  -184,  -184,  -184,
    -184,  -184,  -184,  -184,     6,  -123,  -183,  -184,  -119,     9,
     257,  -184,   258,   256,   261,   262,    76,   110,    83,   108,
       8,   400,  -184,     0
};

  /* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,    61,    62,    63,    64,   126,    65,    66,   238,   236,
     322,   235,    67,   206,    69,   157,    70,   229,   230,   145,
     219,    71,    72,    73,   221,   282,    75,    76,    77,   165,
      78,   208,    79,    80,   283,   204,   222,   200,    82,    83,
      84,    85,    86,    87,    88,    89,    90,    91,    92,    93,
      94,    95,   224,   100
};

  /* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
     positive, shift that token.  If negative, reduce the rule whose
     number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_int16 yytable[] =
{
      96,    74,    68,   223,   249,   275,    81,   167,   231,   119,
      99,   326,   103,   120,   104,   205,   121,    97,   122,   111,
     250,   298,   162,   146,   163,   301,   241,   118,   115,   327,
     299,   102,   302,   225,   132,   103,   244,   227,   127,   128,
     105,   133,   134,   135,   136,   -71,   -71,   -71,   106,   139,
     226,   140,   -71,   291,   116,   147,   107,   -71,   -71,   292,
     108,   334,    96,    74,    68,   164,   227,   335,    81,   112,
     -71,   158,   168,   143,   144,   113,   304,   310,    58,    59,
     251,   141,   109,   -71,   390,   305,   150,   151,   152,   142,
     391,   333,   211,   153,   212,   150,   151,   152,   154,   143,
     144,   241,   188,   183,   184,   242,   103,   215,   216,   189,
     311,   155,   190,   110,   354,   103,   185,   103,   103,   103,
     155,   332,    96,   307,   156,   201,   103,   308,   339,   103,
     103,   341,   228,   156,   203,   114,   207,   209,   210,   227,
     124,   125,   323,   325,   218,   116,   137,   307,   220,   188,
     325,   337,   286,   227,   287,   149,   189,   248,   103,   190,
     159,   228,   252,   150,   151,   152,   173,   174,   169,   150,
     151,   152,   384,   160,   301,   232,   256,   245,   344,   307,
     233,   215,    14,   362,   357,   358,   -43,   161,   155,   170,
     -43,   272,   273,   274,   155,   -44,   336,   103,   364,   -44,
     171,   156,   365,   166,    96,    98,    25,   156,   307,   278,
     117,   307,   373,    27,   227,   413,   172,   340,    28,   188,
     179,   180,   379,   380,   296,   202,   189,   383,   213,   190,
     214,    96,    32,   217,   228,   181,   182,   405,   387,   186,
     187,   328,   329,   234,   150,   151,   152,   237,   228,   262,
     263,    37,    38,    39,    40,   239,   215,   369,   240,   150,
     151,   152,   268,   269,   342,   402,   399,   246,   404,   155,
     247,   215,   370,   253,   408,    58,    59,    60,   175,   176,
     177,   178,   156,   414,   155,   264,   265,   266,   267,   270,
     271,   188,   254,   103,   276,   103,   277,   156,   189,   227,
     284,   190,   295,    96,    96,   279,   103,   280,   288,   228,
     103,    96,   348,   289,   349,   290,   293,   294,   191,   192,
     193,   194,   195,   196,   197,   150,   151,   152,   297,   356,
     198,   199,    96,   150,   151,   152,   300,   215,   403,    96,
     285,    96,   303,   306,   330,   154,   168,   103,   343,   338,
     155,   347,   378,   150,   151,   152,   345,   346,   155,   350,
     351,   352,   353,   156,   103,   215,   375,   335,   355,   361,
     366,   156,   359,   389,   367,   368,   371,   381,   155,    96,
      96,   301,   374,    96,   382,    96,   385,    96,   386,   392,
     103,   156,   388,   400,   228,   393,     1,   409,   407,   411,
     397,   406,    96,     2,    96,     3,     4,     5,    96,   396,
       6,     7,   138,     8,    96,     9,   416,   243,    10,   360,
      11,    12,    13,    14,   148,   257,   259,   258,   123,     0,
       0,     0,   260,     0,   261,    15,    16,    17,    18,    19,
       0,     0,    20,    21,    22,    23,    24,    25,     0,     0,
       0,    26,     0,     0,    27,     0,     0,     0,     0,    28,
      29,     0,     0,     0,     0,     0,     0,     0,     0,     0,
      30,    31,     0,    32,    33,     0,     0,    34,     0,     0,
       0,     0,     0,     0,     0,    35,    36,     0,     0,     0,
       0,     0,    37,    38,    39,    40,     0,     0,    41,    42,
      43,    44,     0,    45,    46,    47,    48,    49,    50,    51,
      52,    53,    54,    55,    56,    57,    58,    59,    60,     1,
       0,     0,     0,     0,     0,     0,     2,     0,     3,     4,
       5,     0,     0,     6,     7,     0,     8,     0,     9,     0,
       0,    10,     0,    11,     0,     0,    14,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    15,    16,
      17,    18,    19,     0,     0,    20,    21,    22,    23,    24,
      25,     0,     0,     0,    26,     0,     0,    27,     0,     0,
     281,     0,    28,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,    30,    31,     0,    32,    33,     0,     0,
      34,     0,     0,     0,     0,     0,     0,     0,    35,    36,
       0,     0,     0,     0,     0,    37,    38,    39,    40,     0,
       0,    41,    42,    43,    44,     0,    45,    46,    47,    48,
      49,    50,    51,    52,    53,    54,    55,    56,    57,    58,
      59,    60,     1,     0,     0,     0,     0,     0,     0,     2,
       0,     3,     4,     5,     0,     0,     6,     7,     0,     8,
       0,     9,     0,     0,    10,     0,    11,     0,     0,    14,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,    15,    16,    17,    18,    19,     0,     0,    20,    21,
      22,    23,    24,    25,     0,     0,     0,    26,     0,     0,
      27,     0,     0,   309,     0,    28,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,    30,    31,     0,    32,
      33,     0,     0,    34,     0,     0,     0,     0,     0,     0,
       0,    35,    36,     0,     0,     0,     0,     0,    37,    38,
      39,    40,     0,     0,    41,    42,    43,    44,     0,    45,
      46,    47,    48,    49,    50,    51,    52,    53,    54,    55,
      56,    57,    58,    59,    60,     1,     0,     0,     0,     0,
       0,     0,     2,     0,     3,     4,     5,     0,     0,     6,
       7,     0,     8,     0,     9,     0,     0,    10,     0,    11,
       0,     0,    14,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,    15,    16,    17,    18,    19,     0,
       0,    20,    21,    22,    23,    24,    25,     0,     0,     0,
      26,     0,     0,    27,     0,     0,   363,     0,    28,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    30,
      31,     0,    32,    33,     0,     0,    34,     0,     0,     0,
       0,     0,     0,     0,    35,    36,     0,     0,     0,     0,
       0,    37,    38,    39,    40,     0,     0,    41,    42,    43,
      44,     0,    45,    46,    47,    48,    49,    50,    51,    52,
      53,    54,    55,    56,    57,    58,    59,    60,     1,     0,
       0,     0,     0,     0,     0,     2,     0,     3,     4,     5,
       0,     0,     6,     7,     0,     8,     0,     9,     0,     0,
      10,     0,    11,     0,     0,    14,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,    15,    16,    17,
      18,    19,     0,     0,    20,    21,    22,    23,    24,    25,
       0,     0,     0,    26,     0,     0,    27,     0,     0,   372,
       0,    28,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,    30,    31,     0,    32,    33,     0,     0,    34,
       0,     0,     0,     0,     0,     0,     0,    35,    36,     0,
       0,     0,     0,     0,    37,    38,    39,    40,     0,     0,
      41,    42,    43,    44,     0,    45,    46,    47,    48,    49,
      50,    51,    52,    53,    54,    55,    56,    57,    58,    59,
      60,     1,     0,     0,     0,     0,     0,     0,     2,     0,
       3,     4,     5,     0,     0,     6,     7,     0,     8,     0,
       9,     0,     0,    10,     0,    11,     0,     0,    14,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
      15,    16,    17,    18,    19,     0,     0,    20,    21,    22,
      23,    24,    25,     0,     0,     0,    26,     0,     0,    27,
       0,     0,   376,     0,    28,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,    30,    31,     0,    32,    33,
       0,     0,    34,     0,     0,     0,     0,     0,     0,     0,
      35,    36,     0,     0,     0,     0,     0,    37,    38,    39,
      40,     0,     0,    41,    42,    43,    44,     0,    45,    46,
      47,    48,    49,    50,    51,    52,    53,    54,    55,    56,
      57,    58,    59,    60,     1,     0,     0,     0,     0,     0,
       0,     2,     0,     3,     4,     5,     0,     0,     6,     7,
       0,     8,     0,     9,     0,     0,    10,     0,    11,     0,
       0,    14,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,    15,    16,    17,    18,    19,     0,     0,
      20,    21,    22,    23,    24,    25,     0,     0,     0,    26,
       0,     0,    27,     0,     0,   377,     0,    28,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    30,    31,
       0,    32,    33,     0,     0,    34,     0,     0,     0,     0,
       0,     0,     0,    35,    36,     0,     0,     0,     0,     0,
      37,    38,    39,    40,     0,     0,    41,    42,    43,    44,
       0,    45,    46,    47,    48,    49,    50,    51,    52,    53,
      54,    55,    56,    57,    58,    59,    60,     1,     0,     0,
       0,     0,     0,     0,     2,     0,     3,     4,     5,     0,
       0,     6,     7,     0,     8,     0,     9,     0,     0,    10,
       0,    11,     0,     0,    14,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,    15,    16,    17,    18,
      19,     0,     0,    20,    21,    22,    23,    24,    25,     0,
       0,     0,    26,     0,     0,    27,     0,     0,   394,     0,
      28,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,    30,    31,     0,    32,    33,     0,     0,    34,     0,
       0,     0,     0,     0,     0,     0,    35,    36,     0,     0,
       0,     0,     0,    37,    38,    39,    40,     0,     0,    41,
      42,    43,    44,     0,    45,    46,    47,    48,    49,    50,
      51,    52,    53,    54,    55,    56,    57,    58,    59,    60,
       1,     0,     0,     0,     0,     0,     0,     2,     0,     3,
       4,     5,     0,     0,     6,     7,     0,     8,     0,     9,
       0,     0,    10,     0,    11,     0,     0,    14,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    15,
      16,    17,    18,    19,     0,     0,    20,    21,    22,    23,
      24,    25,     0,     0,     0,    26,     0,     0,    27,     0,
       0,   395,     0,    28,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,    30,    31,     0,    32,    33,     0,
       0,    34,     0,     0,     0,     0,     0,     0,     0,    35,
      36,     0,     0,     0,     0,     0,    37,    38,    39,    40,
       0,     0,    41,    42,    43,    44,     0,    45,    46,    47,
      48,    49,    50,    51,    52,    53,    54,    55,    56,    57,
      58,    59,    60,     1,     0,     0,     0,     0,     0,     0,
       2,     0,     3,     4,     5,     0,     0,     6,     7,     0,
       8,     0,     9,     0,     0,    10,     0,    11,     0,     0,
      14,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,    15,    16,    17,    18,    19,     0,     0,    20,
      21,    22,    23,    24,    25,     0,     0,     0,    26,     0,
       0,    27,     0,     0,   398,     0,    28,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,    30,    31,     0,
      32,    33,     0,     0,    34,     0,     0,     0,     0,     0,
       0,     0,    35,    36,     0,     0,     0,     0,     0,    37,
      38,    39,    40,     0,     0,    41,    42,    43,    44,     0,
      45,    46,    47,    48,    49,    50,    51,    52,    53,    54,
      55,    56,    57,    58,    59,    60,     1,     0,     0,     0,
       0,     0,     0,     2,     0,     3,     4,     5,     0,     0,
       6,     7,     0,     8,     0,     9,     0,     0,    10,     0,
      11,     0,     0,    14,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,    15,    16,    17,    18,    19,
       0,     0,    20,    21,    22,    23,    24,    25,     0,     0,
       0,    26,     0,     0,    27,     0,     0,   401,     0,    28,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
      30,    31,     0,    32,    33,     0,     0,    34,     0,     0,
       0,     0,     0,     0,     0,    35,    36,     0,     0,     0,
       0,     0,    37,    38,    39,    40,     0,     0,    41,    42,
      43,    44,     0,    45,    46,    47,    48,    49,    50,    51,
      52,    53,    54,    55,    56,    57,    58,    59,    60,     1,
       0,     0,     0,     0,     0,     0,     2,     0,     3,     4,
       5,     0,     0,     6,     7,     0,     8,     0,     9,     0,
       0,    10,     0,    11,     0,     0,    14,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    15,    16,
      17,    18,    19,     0,     0,    20,    21,    22,    23,    24,
      25,     0,     0,     0,    26,     0,     0,    27,     0,     0,
     410,     0,    28,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,    30,    31,     0,    32,    33,     0,     0,
      34,     0,     0,     0,     0,     0,     0,     0,    35,    36,
       0,     0,     0,     0,     0,    37,    38,    39,    40,     0,
       0,    41,    42,    43,    44,     0,    45,    46,    47,    48,
      49,    50,    51,    52,    53,    54,    55,    56,    57,    58,
      59,    60,     1,     0,     0,     0,     0,     0,     0,     2,
       0,     3,     4,     5,     0,     0,     6,     7,     0,     8,
       0,     9,     0,     0,    10,     0,    11,     0,     0,    14,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,    15,    16,    17,    18,    19,     0,     0,    20,    21,
      22,    23,    24,    25,     0,     0,     0,    26,     0,     0,
      27,     0,     0,   412,     0,    28,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,    30,    31,     0,    32,
      33,     0,     0,    34,     0,     0,     0,     0,     0,     0,
       0,    35,    36,     0,     0,     0,     0,     0,    37,    38,
      39,    40,     0,     0,    41,    42,    43,    44,     0,    45,
      46,    47,    48,    49,    50,    51,    52,    53,    54,    55,
      56,    57,    58,    59,    60,     1,     0,     0,     0,     0,
       0,     0,     2,     0,     3,     4,     5,     0,     0,     6,
       7,     0,     8,     0,     9,     0,     0,    10,     0,    11,
       0,     0,    14,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,    15,    16,    17,    18,    19,     0,
       0,    20,    21,    22,    23,    24,    25,     0,     0,     0,
      26,     0,     0,    27,     0,     0,   415,     0,    28,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    30,
      31,     0,    32,    33,     0,     0,    34,     0,     0,     0,
       0,     0,     0,     0,    35,    36,     0,     0,     0,     0,
       0,    37,    38,    39,    40,     0,     0,    41,    42,    43,
      44,     0,    45,    46,    47,    48,    49,    50,    51,    52,
      53,    54,    55,    56,    57,    58,    59,    60,     1,     0,
       0,     0,     0,     0,     0,     2,     0,     3,     4,     5,
       0,     0,     6,     7,     0,     8,     0,     9,     0,     0,
      10,     0,    11,     0,     0,    14,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,    15,    16,    17,
      18,    19,     0,     0,    20,    21,    22,    23,    24,    25,
       0,     0,     0,    26,     0,     0,    27,     0,     0,   417,
       0,    28,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,    30,    31,     0,    32,    33,     0,     0,    34,
       0,     0,     0,     0,     0,     0,     0,    35,    36,     0,
       0,     0,     0,     0,    37,    38,    39,    40,     0,     0,
      41,    42,    43,    44,     0,    45,    46,    47,    48,    49,
      50,    51,    52,    53,    54,    55,    56,    57,    58,    59,
      60,     2,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,    10,     0,    11,     0,
       0,    14,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,    15,    16,    17,    18,    19,     0,     0,
      20,    21,    22,    23,    24,    25,     0,     0,     0,    26,
       0,     0,    27,     0,     0,     0,     0,    28,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    30,    31,
       0,    32,    33,     0,     0,    34,     0,     0,     0,     0,
       0,     0,     0,    35,    36,     0,     0,     0,     0,     0,
      37,    38,    39,    40,     0,     0,    41,    42,    43,    44,
       2,    45,    46,    47,    48,    49,    50,    51,    52,    53,
      54,    55,    56,    57,    58,    59,    60,    11,     0,     0,
      14,     0,     0,     0,     0,     0,     0,     0,     0,     2,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,    98,    25,     0,    11,   101,    26,    14,
       0,    27,     0,     0,     0,     0,    28,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,    30,    31,     0,
      32,    33,    98,    25,    34,   255,     0,    26,     0,     0,
      27,     2,    35,    36,     0,    28,     0,     0,     0,    37,
      38,    39,    40,     0,     0,     0,    30,    31,    11,    32,
      33,    14,     0,    34,     0,     0,     0,     0,     0,     0,
       0,    35,    36,    58,    59,    60,     0,     0,    37,    38,
      39,    40,     0,     0,    98,    25,     0,     0,     0,    26,
       0,     0,    27,     0,     0,     0,     0,    28,     0,     0,
       0,     0,    58,    59,    60,     0,     0,     0,    30,    31,
       0,    32,    33,     0,     0,    34,     0,     0,     0,     0,
       0,     0,     0,    35,    36,    10,     0,     0,     0,     0,
      37,    38,    39,    40,   312,   313,   314,   315,   316,   317,
     318,   319,   320,   321,    17,    18,    19,    10,     0,    20,
      21,    22,    23,   129,    58,    59,    60,     0,     0,     0,
       0,     0,     0,     0,    15,    16,    17,    18,    19,    10,
       0,    20,    21,    22,    23,   129,     0,     0,     0,     0,
     130,     0,     0,     0,     0,   131,    15,    16,    17,    18,
      19,     0,     0,    20,    21,    22,    23,   129,     0,     0,
       0,     0,     0,     0,     0,    41,    42,    43,    44,     0,
      45,    46,    47,    48,    49,    50,    51,    52,    53,    54,
      55,    56,    57,     0,   295,     0,     0,    41,    42,    43,
      44,     0,    45,    46,    47,    48,    49,    50,    51,    52,
      53,    54,    55,    56,    57,     0,     0,     0,     0,    41,
      42,    43,    44,    10,    45,    46,    47,    48,    49,    50,
      51,    52,    53,    54,    55,    56,    57,     0,     0,     0,
      15,    16,    17,    18,    19,     0,    10,    20,    21,    22,
      23,   129,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,   324,    15,    16,    17,    18,    19,     0,    10,
      20,    21,    22,    23,   129,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,   331,    15,    16,    17,    18,
      19,     0,     0,    20,    21,    22,    23,   129,     0,     0,
       0,     0,     0,    41,    42,    43,    44,     0,    45,    46,
      47,    48,    49,    50,    51,    52,    53,    54,    55,    56,
      57,     0,     0,     0,     0,     0,    41,    42,    43,    44,
       0,    45,    46,    47,    48,    49,    50,    51,    52,    53,
      54,    55,    56,    57,     0,     0,     0,     0,     0,    41,
      42,    43,    44,     0,    45,    46,    47,    48,    49,    50,
      51,    52,    53,    54,    55,    56,    57
};

static const yytype_int16 yycheck[] =
{
       0,     0,     0,   122,   159,   188,     0,    14,   131,    57,
       2,    58,     3,    61,    60,   108,    64,    61,    66,    11,
       6,    56,    24,    34,    26,    58,    56,    27,    26,    76,
      65,     3,    65,    57,    32,    26,    66,   130,    30,    31,
      60,    33,    34,    35,    36,    49,    50,    51,    61,    34,
      74,    36,    56,    56,    26,    66,    66,    61,    62,    62,
      61,    56,    62,    62,    62,    67,   159,    62,    62,    56,
      74,    69,    79,    84,    85,    56,    58,   232,   126,   127,
      66,    66,    61,    87,    60,    67,    49,    50,    51,    74,
      66,   246,    59,    56,    61,    49,    50,    51,    61,    84,
      85,    56,    61,    86,    87,    60,    97,    61,    62,    68,
     233,    74,    71,    61,   297,   106,    99,   108,   109,   110,
      74,   244,   122,    58,    87,    97,   117,    62,   251,   120,
     121,   254,   130,    87,   106,    61,   108,   109,   110,   232,
      11,    12,   235,   236,    56,   117,     0,    58,   120,    61,
     243,    62,    60,   246,    62,   100,    68,   155,   149,    71,
      61,   159,   162,    49,    50,    51,    72,    73,    78,    49,
      50,    51,   355,    60,    58,    61,   167,   149,    62,    58,
      66,    61,    33,    62,   303,   304,    58,    19,    74,    82,
      62,   183,   184,   185,    74,    58,    76,   188,    58,    62,
      83,    87,    62,    60,   204,    56,    57,    87,    58,   200,
      61,    58,    62,    64,   307,    62,    81,    59,    69,    61,
      97,    98,   345,   346,   216,    60,    68,   350,    61,    71,
      56,   231,    83,    62,   232,    84,    85,   392,   361,    95,
      96,   239,   240,    61,    49,    50,    51,    56,   246,   173,
     174,   102,   103,   104,   105,    61,    61,    62,    61,    49,
      50,    51,   179,   180,   255,   388,   385,    61,   391,    74,
      83,    61,    62,    59,   397,   126,   127,   128,    74,    75,
      76,    77,    87,   406,    74,   175,   176,   177,   178,   181,
     182,    61,    66,   284,    56,   286,    56,    87,    68,   392,
      22,    71,    83,   303,   304,    62,   297,    62,    62,   307,
     301,   311,   284,    62,   286,    56,    56,    62,    88,    89,
      90,    91,    92,    93,    94,    49,    50,    51,    59,   301,
     100,   101,   332,    49,    50,    51,    62,    61,    62,   339,
      56,   341,    59,    56,    59,    61,    79,   338,    59,    61,
      74,    20,   343,    49,    50,    51,    66,    66,    74,    66,
      66,    62,    62,    87,   355,    61,   338,    62,    59,    66,
      60,    87,    86,   371,    60,    56,    61,    61,    74,   379,
     380,    58,    62,   383,    62,   385,    59,   387,    56,    61,
     381,    87,    66,    68,   392,    62,     6,    56,    62,    56,
      66,    66,   402,    13,   404,    15,    16,    17,   408,   381,
      20,    21,    62,    23,   414,    25,    76,   147,    28,   307,
      30,    31,    32,    33,    66,   168,   170,   169,    28,    -1,
      -1,    -1,   171,    -1,   172,    45,    46,    47,    48,    49,
      -1,    -1,    52,    53,    54,    55,    56,    57,    -1,    -1,
      -1,    61,    -1,    -1,    64,    -1,    -1,    -1,    -1,    69,
      70,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      80,    81,    -1,    83,    84,    -1,    -1,    87,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    95,    96,    -1,    -1,    -1,
      -1,    -1,   102,   103,   104,   105,    -1,    -1,   108,   109,
     110,   111,    -1,   113,   114,   115,   116,   117,   118,   119,
     120,   121,   122,   123,   124,   125,   126,   127,   128,     6,
      -1,    -1,    -1,    -1,    -1,    -1,    13,    -1,    15,    16,
      17,    -1,    -1,    20,    21,    -1,    23,    -1,    25,    -1,
      -1,    28,    -1,    30,    -1,    -1,    33,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    45,    46,
      47,    48,    49,    -1,    -1,    52,    53,    54,    55,    56,
      57,    -1,    -1,    -1,    61,    -1,    -1,    64,    -1,    -1,
      67,    -1,    69,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    80,    81,    -1,    83,    84,    -1,    -1,
      87,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    95,    96,
      -1,    -1,    -1,    -1,    -1,   102,   103,   104,   105,    -1,
      -1,   108,   109,   110,   111,    -1,   113,   114,   115,   116,
     117,   118,   119,   120,   121,   122,   123,   124,   125,   126,
     127,   128,     6,    -1,    -1,    -1,    -1,    -1,    -1,    13,
      -1,    15,    16,    17,    -1,    -1,    20,    21,    -1,    23,
      -1,    25,    -1,    -1,    28,    -1,    30,    -1,    -1,    33,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    45,    46,    47,    48,    49,    -1,    -1,    52,    53,
      54,    55,    56,    57,    -1,    -1,    -1,    61,    -1,    -1,
      64,    -1,    -1,    67,    -1,    69,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    80,    81,    -1,    83,
      84,    -1,    -1,    87,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    95,    96,    -1,    -1,    -1,    -1,    -1,   102,   103,
     104,   105,    -1,    -1,   108,   109,   110,   111,    -1,   113,
     114,   115,   116,   117,   118,   119,   120,   121,   122,   123,
     124,   125,   126,   127,   128,     6,    -1,    -1,    -1,    -1,
      -1,    -1,    13,    -1,    15,    16,    17,    -1,    -1,    20,
      21,    -1,    23,    -1,    25,    -1,    -1,    28,    -1,    30,
      -1,    -1,    33,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    45,    46,    47,    48,    49,    -1,
      -1,    52,    53,    54,    55,    56,    57,    -1,    -1,    -1,
      61,    -1,    -1,    64,    -1,    -1,    67,    -1,    69,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    80,
      81,    -1,    83,    84,    -1,    -1,    87,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    95,    96,    -1,    -1,    -1,    -1,
      -1,   102,   103,   104,   105,    -1,    -1,   108,   109,   110,
     111,    -1,   113,   114,   115,   116,   117,   118,   119,   120,
     121,   122,   123,   124,   125,   126,   127,   128,     6,    -1,
      -1,    -1,    -1,    -1,    -1,    13,    -1,    15,    16,    17,
      -1,    -1,    20,    21,    -1,    23,    -1,    25,    -1,    -1,
      28,    -1,    30,    -1,    -1,    33,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    45,    46,    47,
      48,    49,    -1,    -1,    52,    53,    54,    55,    56,    57,
      -1,    -1,    -1,    61,    -1,    -1,    64,    -1,    -1,    67,
      -1,    69,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    80,    81,    -1,    83,    84,    -1,    -1,    87,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    95,    96,    -1,
      -1,    -1,    -1,    -1,   102,   103,   104,   105,    -1,    -1,
     108,   109,   110,   111,    -1,   113,   114,   115,   116,   117,
     118,   119,   120,   121,   122,   123,   124,   125,   126,   127,
     128,     6,    -1,    -1,    -1,    -1,    -1,    -1,    13,    -1,
      15,    16,    17,    -1,    -1,    20,    21,    -1,    23,    -1,
      25,    -1,    -1,    28,    -1,    30,    -1,    -1,    33,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      45,    46,    47,    48,    49,    -1,    -1,    52,    53,    54,
      55,    56,    57,    -1,    -1,    -1,    61,    -1,    -1,    64,
      -1,    -1,    67,    -1,    69,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    80,    81,    -1,    83,    84,
      -1,    -1,    87,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      95,    96,    -1,    -1,    -1,    -1,    -1,   102,   103,   104,
     105,    -1,    -1,   108,   109,   110,   111,    -1,   113,   114,
     115,   116,   117,   118,   119,   120,   121,   122,   123,   124,
     125,   126,   127,   128,     6,    -1,    -1,    -1,    -1,    -1,
      -1,    13,    -1,    15,    16,    17,    -1,    -1,    20,    21,
      -1,    23,    -1,    25,    -1,    -1,    28,    -1,    30,    -1,
      -1,    33,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    45,    46,    47,    48,    49,    -1,    -1,
      52,    53,    54,    55,    56,    57,    -1,    -1,    -1,    61,
      -1,    -1,    64,    -1,    -1,    67,    -1,    69,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    80,    81,
      -1,    83,    84,    -1,    -1,    87,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    95,    96,    -1,    -1,    -1,    -1,    -1,
     102,   103,   104,   105,    -1,    -1,   108,   109,   110,   111,
      -1,   113,   114,   115,   116,   117,   118,   119,   120,   121,
     122,   123,   124,   125,   126,   127,   128,     6,    -1,    -1,
      -1,    -1,    -1,    -1,    13,    -1,    15,    16,    17,    -1,
      -1,    20,    21,    -1,    23,    -1,    25,    -1,    -1,    28,
      -1,    30,    -1,    -1,    33,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    45,    46,    47,    48,
      49,    -1,    -1,    52,    53,    54,    55,    56,    57,    -1,
      -1,    -1,    61,    -1,    -1,    64,    -1,    -1,    67,    -1,
      69,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    80,    81,    -1,    83,    84,    -1,    -1,    87,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    95,    96,    -1,    -1,
      -1,    -1,    -1,   102,   103,   104,   105,    -1,    -1,   108,
     109,   110,   111,    -1,   113,   114,   115,   116,   117,   118,
     119,   120,   121,   122,   123,   124,   125,   126,   127,   128,
       6,    -1,    -1,    -1,    -1,    -1,    -1,    13,    -1,    15,
      16,    17,    -1,    -1,    20,    21,    -1,    23,    -1,    25,
      -1,    -1,    28,    -1,    30,    -1,    -1,    33,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    45,
      46,    47,    48,    49,    -1,    -1,    52,    53,    54,    55,
      56,    57,    -1,    -1,    -1,    61,    -1,    -1,    64,    -1,
      -1,    67,    -1,    69,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    80,    81,    -1,    83,    84,    -1,
      -1,    87,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    95,
      96,    -1,    -1,    -1,    -1,    -1,   102,   103,   104,   105,
      -1,    -1,   108,   109,   110,   111,    -1,   113,   114,   115,
     116,   117,   118,   119,   120,   121,   122,   123,   124,   125,
     126,   127,   128,     6,    -1,    -1,    -1,    -1,    -1,    -1,
      13,    -1,    15,    16,    17,    -1,    -1,    20,    21,    -1,
      23,    -1,    25,    -1,    -1,    28,    -1,    30,    -1,    -1,
      33,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    45,    46,    47,    48,    49,    -1,    -1,    52,
      53,    54,    55,    56,    57,    -1,    -1,    -1,    61,    -1,
      -1,    64,    -1,    -1,    67,    -1,    69,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    80,    81,    -1,
      83,    84,    -1,    -1,    87,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    95,    96,    -1,    -1,    -1,    -1,    -1,   102,
     103,   104,   105,    -1,    -1,   108,   109,   110,   111,    -1,
     113,   114,   115,   116,   117,   118,   119,   120,   121,   122,
     123,   124,   125,   126,   127,   128,     6,    -1,    -1,    -1,
      -1,    -1,    -1,    13,    -1,    15,    16,    17,    -1,    -1,
      20,    21,    -1,    23,    -1,    25,    -1,    -1,    28,    -1,
      30,    -1,    -1,    33,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    45,    46,    47,    48,    49,
      -1,    -1,    52,    53,    54,    55,    56,    57,    -1,    -1,
      -1,    61,    -1,    -1,    64,    -1,    -1,    67,    -1,    69,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      80,    81,    -1,    83,    84,    -1,    -1,    87,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    95,    96,    -1,    -1,    -1,
      -1,    -1,   102,   103,   104,   105,    -1,    -1,   108,   109,
     110,   111,    -1,   113,   114,   115,   116,   117,   118,   119,
     120,   121,   122,   123,   124,   125,   126,   127,   128,     6,
      -1,    -1,    -1,    -1,    -1,    -1,    13,    -1,    15,    16,
      17,    -1,    -1,    20,    21,    -1,    23,    -1,    25,    -1,
      -1,    28,    -1,    30,    -1,    -1,    33,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    45,    46,
      47,    48,    49,    -1,    -1,    52,    53,    54,    55,    56,
      57,    -1,    -1,    -1,    61,    -1,    -1,    64,    -1,    -1,
      67,    -1,    69,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    80,    81,    -1,    83,    84,    -1,    -1,
      87,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    95,    96,
      -1,    -1,    -1,    -1,    -1,   102,   103,   104,   105,    -1,
      -1,   108,   109,   110,   111,    -1,   113,   114,   115,   116,
     117,   118,   119,   120,   121,   122,   123,   124,   125,   126,
     127,   128,     6,    -1,    -1,    -1,    -1,    -1,    -1,    13,
      -1,    15,    16,    17,    -1,    -1,    20,    21,    -1,    23,
      -1,    25,    -1,    -1,    28,    -1,    30,    -1,    -1,    33,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    45,    46,    47,    48,    49,    -1,    -1,    52,    53,
      54,    55,    56,    57,    -1,    -1,    -1,    61,    -1,    -1,
      64,    -1,    -1,    67,    -1,    69,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    80,    81,    -1,    83,
      84,    -1,    -1,    87,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    95,    96,    -1,    -1,    -1,    -1,    -1,   102,   103,
     104,   105,    -1,    -1,   108,   109,   110,   111,    -1,   113,
     114,   115,   116,   117,   118,   119,   120,   121,   122,   123,
     124,   125,   126,   127,   128,     6,    -1,    -1,    -1,    -1,
      -1,    -1,    13,    -1,    15,    16,    17,    -1,    -1,    20,
      21,    -1,    23,    -1,    25,    -1,    -1,    28,    -1,    30,
      -1,    -1,    33,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    45,    46,    47,    48,    49,    -1,
      -1,    52,    53,    54,    55,    56,    57,    -1,    -1,    -1,
      61,    -1,    -1,    64,    -1,    -1,    67,    -1,    69,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    80,
      81,    -1,    83,    84,    -1,    -1,    87,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    95,    96,    -1,    -1,    -1,    -1,
      -1,   102,   103,   104,   105,    -1,    -1,   108,   109,   110,
     111,    -1,   113,   114,   115,   116,   117,   118,   119,   120,
     121,   122,   123,   124,   125,   126,   127,   128,     6,    -1,
      -1,    -1,    -1,    -1,    -1,    13,    -1,    15,    16,    17,
      -1,    -1,    20,    21,    -1,    23,    -1,    25,    -1,    -1,
      28,    -1,    30,    -1,    -1,    33,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    45,    46,    47,
      48,    49,    -1,    -1,    52,    53,    54,    55,    56,    57,
      -1,    -1,    -1,    61,    -1,    -1,    64,    -1,    -1,    67,
      -1,    69,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    80,    81,    -1,    83,    84,    -1,    -1,    87,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    95,    96,    -1,
      -1,    -1,    -1,    -1,   102,   103,   104,   105,    -1,    -1,
     108,   109,   110,   111,    -1,   113,   114,   115,   116,   117,
     118,   119,   120,   121,   122,   123,   124,   125,   126,   127,
     128,    13,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    28,    -1,    30,    -1,
      -1,    33,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    45,    46,    47,    48,    49,    -1,    -1,
      52,    53,    54,    55,    56,    57,    -1,    -1,    -1,    61,
      -1,    -1,    64,    -1,    -1,    -1,    -1,    69,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    80,    81,
      -1,    83,    84,    -1,    -1,    87,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    95,    96,    -1,    -1,    -1,    -1,    -1,
     102,   103,   104,   105,    -1,    -1,   108,   109,   110,   111,
      13,   113,   114,   115,   116,   117,   118,   119,   120,   121,
     122,   123,   124,   125,   126,   127,   128,    30,    -1,    -1,
      33,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    13,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    56,    57,    -1,    30,    60,    61,    33,
      -1,    64,    -1,    -1,    -1,    -1,    69,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    80,    81,    -1,
      83,    84,    56,    57,    87,    59,    -1,    61,    -1,    -1,
      64,    13,    95,    96,    -1,    69,    -1,    -1,    -1,   102,
     103,   104,   105,    -1,    -1,    -1,    80,    81,    30,    83,
      84,    33,    -1,    87,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    95,    96,   126,   127,   128,    -1,    -1,   102,   103,
     104,   105,    -1,    -1,    56,    57,    -1,    -1,    -1,    61,
      -1,    -1,    64,    -1,    -1,    -1,    -1,    69,    -1,    -1,
      -1,    -1,   126,   127,   128,    -1,    -1,    -1,    80,    81,
      -1,    83,    84,    -1,    -1,    87,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    95,    96,    28,    -1,    -1,    -1,    -1,
     102,   103,   104,   105,    37,    38,    39,    40,    41,    42,
      43,    44,    45,    46,    47,    48,    49,    28,    -1,    52,
      53,    54,    55,    56,   126,   127,   128,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    45,    46,    47,    48,    49,    28,
      -1,    52,    53,    54,    55,    56,    -1,    -1,    -1,    -1,
      61,    -1,    -1,    -1,    -1,    66,    45,    46,    47,    48,
      49,    -1,    -1,    52,    53,    54,    55,    56,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,   108,   109,   110,   111,    -1,
     113,   114,   115,   116,   117,   118,   119,   120,   121,   122,
     123,   124,   125,    -1,    83,    -1,    -1,   108,   109,   110,
     111,    -1,   113,   114,   115,   116,   117,   118,   119,   120,
     121,   122,   123,   124,   125,    -1,    -1,    -1,    -1,   108,
     109,   110,   111,    28,   113,   114,   115,   116,   117,   118,
     119,   120,   121,   122,   123,   124,   125,    -1,    -1,    -1,
      45,    46,    47,    48,    49,    -1,    28,    52,    53,    54,
      55,    56,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    67,    45,    46,    47,    48,    49,    -1,    28,
      52,    53,    54,    55,    56,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    67,    45,    46,    47,    48,
      49,    -1,    -1,    52,    53,    54,    55,    56,    -1,    -1,
      -1,    -1,    -1,   108,   109,   110,   111,    -1,   113,   114,
     115,   116,   117,   118,   119,   120,   121,   122,   123,   124,
     125,    -1,    -1,    -1,    -1,    -1,   108,   109,   110,   111,
      -1,   113,   114,   115,   116,   117,   118,   119,   120,   121,
     122,   123,   124,   125,    -1,    -1,    -1,    -1,    -1,   108,
     109,   110,   111,    -1,   113,   114,   115,   116,   117,   118,
     119,   120,   121,   122,   123,   124,   125
};

  /* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
     symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,     6,    13,    15,    16,    17,    20,    21,    23,    25,
      28,    30,    31,    32,    33,    45,    46,    47,    48,    49,
      52,    53,    54,    55,    56,    57,    61,    64,    69,    70,
      80,    81,    83,    84,    87,    95,    96,   102,   103,   104,
     105,   108,   109,   110,   111,   113,   114,   115,   116,   117,
     118,   119,   120,   121,   122,   123,   124,   125,   126,   127,
     128,   130,   131,   132,   133,   135,   136,   141,   142,   143,
     145,   150,   151,   152,   154,   155,   156,   157,   159,   161,
     162,   163,   167,   168,   169,   170,   171,   172,   173,   174,
     175,   176,   177,   178,   179,   180,   182,    61,    56,   179,
     182,    60,   153,   168,    60,    60,    61,    66,    61,    61,
      61,   179,    56,    56,    61,   142,   153,    61,   182,    57,
      61,    64,    66,   180,    11,    12,   134,   179,   179,    56,
      61,    66,   142,   179,   179,   179,   179,     0,   132,    34,
      36,    66,    74,    84,    85,   148,    34,    66,   148,   100,
      49,    50,    51,    56,    61,    74,    87,   144,   142,    61,
      60,    19,    24,    26,    67,   158,    60,    14,    79,    78,
      82,    83,    81,    72,    73,    74,    75,    76,    77,    97,
      98,    84,    85,    86,    87,    99,    95,    96,    61,    68,
      71,    88,    89,    90,    91,    92,    93,    94,   100,   101,
     166,   153,    60,   153,   164,   141,   142,   153,   160,   153,
     153,    59,    61,    61,    56,    61,    62,    62,    56,   149,
     153,   153,   165,   167,   181,    57,    74,   141,   142,   146,
     147,   164,    61,    66,    61,   140,   138,    56,   137,    61,
      61,    56,    60,   138,    66,   153,    61,    83,   142,   147,
       6,    66,   182,    59,    66,    59,   168,   169,   171,   172,
     173,   174,   175,   175,   176,   176,   176,   176,   177,   177,
     178,   178,   179,   179,   179,   165,    56,    56,   168,    62,
      62,    67,   154,   163,    22,    56,    60,    62,    62,    62,
      56,    56,    62,    56,    62,    83,   179,    59,    56,    65,
      62,    58,    65,    59,    58,    67,    56,    58,    62,    67,
     147,   164,    37,    38,    39,    40,    41,    42,    43,    44,
      45,    46,   139,   141,    67,   141,    58,    76,   142,   142,
      59,    67,   164,   147,    56,    62,    76,    62,    61,   164,
      59,   164,   168,    59,    62,    66,    66,    20,   153,   153,
      66,    66,    62,    62,   165,    59,   153,   167,   167,    86,
     146,    66,    62,    67,    58,    62,    60,    60,    56,    62,
      62,    61,    67,    62,    62,   153,    67,    67,   168,   164,
     164,    61,    62,   164,   165,    59,    56,   164,    66,   142,
      60,    66,    61,    62,    67,    67,   153,    66,    67,   167,
      68,    67,   164,    62,   164,   147,    66,    62,   164,    56,
      67,    56,    67,    62,   164,    67,    76,    67
};

  /* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,   129,   130,   130,   131,   131,   132,   132,   132,   132,
     132,   132,   132,   133,   134,   134,   134,   134,   135,   135,
     135,   135,   135,   135,   135,   135,   136,   136,   136,   136,
     136,   137,   137,   138,   138,   139,   139,   139,   139,   139,
     139,   139,   139,   139,   139,   140,   140,   140,   140,   141,
     141,   142,   142,   142,   142,   142,   142,   142,   142,   142,
     142,   142,   142,   142,   142,   142,   142,   142,   142,   142,
     142,   142,   142,   142,   142,   143,   143,   143,   143,   143,
     143,   143,   143,   143,   144,   144,   144,   145,   145,   146,
     146,   147,   147,   147,   148,   148,   148,   148,   149,   149,
     149,   150,   151,   151,   151,   151,   152,   152,   153,   154,
     154,   154,   154,   154,   154,   155,   155,   155,   156,   157,
     158,   158,   158,   159,   159,   159,   160,   160,   161,   162,
     163,   163,   163,   163,   163,   163,   164,   164,   164,   165,
     165,   166,   166,   166,   166,   166,   166,   166,   166,   166,
     167,   167,   168,   168,   168,   169,   169,   170,   170,   171,
     171,   172,   172,   173,   173,   174,   174,   174,   175,   175,
     175,   175,   175,   176,   176,   176,   177,   177,   177,   178,
     178,   178,   178,   179,   179,   179,   179,   179,   179,   179,
     179,   179,   179,   179,   179,   180,   180,   181,   181,   182,
     182,   182,   182,   182,   182,   182,   182,   182,   182,   182,
     182,   182,   182,   182,   182,   182,   182,   182,   182
};

  /* YYR2[YYN] -- Number of symbols on the right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     0,     1,     1,     2,     1,     1,     1,     1,
       1,     6,     8,     2,     1,     1,     8,     2,     4,     5,
       4,     4,     4,     5,     3,     2,     2,     5,     4,     5,
       2,     1,     3,     0,     3,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     0,     1,     3,     3,     2,
       8,     2,     4,     2,     4,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     2,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     4,     4,     1,
       1,     0,     1,     3,     4,     4,     2,     7,     1,     3,
       4,     4,     5,     8,     4,     7,     1,     3,     1,     2,
       2,     2,     3,     2,     2,     7,     9,     5,     8,     7,
       3,     2,     4,     5,     2,     2,     1,     3,     7,     9,
       1,     1,     1,     1,     1,     1,     0,     2,     2,     1,
       3,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     3,     1,     5,     4,     1,     3,     1,     3,     1,
       3,     1,     3,     1,     3,     1,     3,     3,     1,     3,
       3,     3,     3,     1,     3,     3,     1,     3,     3,     1,
       3,     3,     3,     1,     2,     2,     2,     2,     2,     2,
       4,     2,     2,     2,     2,     1,     1,     3,     5,     1,
       1,     1,     1,     3,     3,     4,     3,     4,     4,     4,
       2,     2,     1,     4,     1,     1,     1,     1,     1
};


#define yyerrok         (yyerrstatus = 0)
#define yyclearin       (yychar = YYEMPTY)
#define YYEMPTY         (-2)
#define YYEOF           0

#define YYACCEPT        goto yyacceptlab
#define YYABORT         goto yyabortlab
#define YYERROR         goto yyerrorlab


#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)                                    \
  do                                                              \
    if (yychar == YYEMPTY)                                        \
      {                                                           \
        yychar = (Token);                                         \
        yylval = (Value);                                         \
        YYPOPSTACK (yylen);                                       \
        yystate = *yyssp;                                         \
        goto yybackup;                                            \
      }                                                           \
    else                                                          \
      {                                                           \
        yyerror (YY_("syntax error: cannot back up")); \
        YYERROR;                                                  \
      }                                                           \
  while (0)

/* Error token number */
#define YYTERROR        1
#define YYERRCODE       256



/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)                        \
do {                                            \
  if (yydebug)                                  \
    YYFPRINTF Args;                             \
} while (0)

/* This macro is provided for backward compatibility. */
#ifndef YY_LOCATION_PRINT
# define YY_LOCATION_PRINT(File, Loc) ((void) 0)
#endif


# define YY_SYMBOL_PRINT(Title, Type, Value, Location)                    \
do {                                                                      \
  if (yydebug)                                                            \
    {                                                                     \
      YYFPRINTF (stderr, "%s ", Title);                                   \
      yy_symbol_print (stderr,                                            \
                  Type, Value); \
      YYFPRINTF (stderr, "\n");                                           \
    }                                                                     \
} while (0)


/*-----------------------------------.
| Print this symbol's value on YYO.  |
`-----------------------------------*/

static void
yy_symbol_value_print (FILE *yyo, int yytype, YYSTYPE const * const yyvaluep)
{
  FILE *yyoutput = yyo;
  YYUSE (yyoutput);
  if (!yyvaluep)
    return;
# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyo, yytoknum[yytype], *yyvaluep);
# endif
  YYUSE (yytype);
}


/*---------------------------.
| Print this symbol on YYO.  |
`---------------------------*/

static void
yy_symbol_print (FILE *yyo, int yytype, YYSTYPE const * const yyvaluep)
{
  YYFPRINTF (yyo, "%s %s (",
             yytype < YYNTOKENS ? "token" : "nterm", yytname[yytype]);

  yy_symbol_value_print (yyo, yytype, yyvaluep);
  YYFPRINTF (yyo, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

static void
yy_stack_print (yytype_int16 *yybottom, yytype_int16 *yytop)
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)                            \
do {                                                            \
  if (yydebug)                                                  \
    yy_stack_print ((Bottom), (Top));                           \
} while (0)


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

static void
yy_reduce_print (yytype_int16 *yyssp, YYSTYPE *yyvsp, int yyrule)
{
  unsigned long yylno = yyrline[yyrule];
  int yynrhs = yyr2[yyrule];
  int yyi;
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %lu):\n",
             yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr,
                       yystos[yyssp[yyi + 1 - yynrhs]],
                       &yyvsp[(yyi + 1) - (yynrhs)]
                                              );
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)          \
do {                                    \
  if (yydebug)                          \
    yy_reduce_print (yyssp, yyvsp, Rule); \
} while (0)

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
#ifndef YYINITDEPTH
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
static YYSIZE_T
yystrlen (const char *yystr)
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
static char *
yystpcpy (char *yydest, const char *yysrc)
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
            else
              goto append;

          append:
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

  return (YYSIZE_T) (yystpcpy (yyres, yystr) - yyres);
}
# endif

/* Copy into *YYMSG, which is of size *YYMSG_ALLOC, an error message
   about the unexpected token YYTOKEN for the state stack whose top is
   YYSSP.

   Return 0 if *YYMSG was successfully written.  Return 1 if *YYMSG is
   not large enough to hold the message.  In that case, also set
   *YYMSG_ALLOC to the required number of bytes.  Return 2 if the
   required number of bytes is too large to store.  */
static int
yysyntax_error (YYSIZE_T *yymsg_alloc, char **yymsg,
                yytype_int16 *yyssp, int yytoken)
{
  YYSIZE_T yysize0 = yytnamerr (YY_NULLPTR, yytname[yytoken]);
  YYSIZE_T yysize = yysize0;
  enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
  /* Internationalized format string. */
  const char *yyformat = YY_NULLPTR;
  /* Arguments of yyformat. */
  char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
  /* Number of reported tokens (one for the "unexpected", one per
     "expected"). */
  int yycount = 0;

  /* There are many possibilities here to consider:
     - If this state is a consistent state with a default action, then
       the only way this function was invoked is if the default action
       is an error action.  In that case, don't check for expected
       tokens because there are none.
     - The only way there can be no lookahead present (in yychar) is if
       this state is a consistent state with a default action.  Thus,
       detecting the absence of a lookahead is sufficient to determine
       that there is no unexpected or expected token to report.  In that
       case, just report a simple "syntax error".
     - Don't assume there isn't a lookahead just because this state is a
       consistent state with a default action.  There might have been a
       previous inconsistent state, consistent state with a non-default
       action, or user semantic action that manipulated yychar.
     - Of course, the expected token list depends on states to have
       correct lookahead information, and it depends on the parser not
       to perform extra reductions after fetching a lookahead from the
       scanner and before detecting a syntax error.  Thus, state merging
       (from LALR or IELR) and default reductions corrupt the expected
       token list.  However, the list is correct for canonical LR with
       one exception: it will still contain any token that will not be
       accepted due to an error action in a later state.
  */
  if (yytoken != YYEMPTY)
    {
      int yyn = yypact[*yyssp];
      yyarg[yycount++] = yytname[yytoken];
      if (!yypact_value_is_default (yyn))
        {
          /* Start YYX at -YYN if negative to avoid negative indexes in
             YYCHECK.  In other words, skip the first -YYN actions for
             this state because they are default actions.  */
          int yyxbegin = yyn < 0 ? -yyn : 0;
          /* Stay within bounds of both yycheck and yytname.  */
          int yychecklim = YYLAST - yyn + 1;
          int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
          int yyx;

          for (yyx = yyxbegin; yyx < yyxend; ++yyx)
            if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR
                && !yytable_value_is_error (yytable[yyx + yyn]))
              {
                if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
                  {
                    yycount = 1;
                    yysize = yysize0;
                    break;
                  }
                yyarg[yycount++] = yytname[yyx];
                {
                  YYSIZE_T yysize1 = yysize + yytnamerr (YY_NULLPTR, yytname[yyx]);
                  if (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM)
                    yysize = yysize1;
                  else
                    return 2;
                }
              }
        }
    }

  switch (yycount)
    {
# define YYCASE_(N, S)                      \
      case N:                               \
        yyformat = S;                       \
      break
    default: /* Avoid compiler warnings. */
      YYCASE_(0, YY_("syntax error"));
      YYCASE_(1, YY_("syntax error, unexpected %s"));
      YYCASE_(2, YY_("syntax error, unexpected %s, expecting %s"));
      YYCASE_(3, YY_("syntax error, unexpected %s, expecting %s or %s"));
      YYCASE_(4, YY_("syntax error, unexpected %s, expecting %s or %s or %s"));
      YYCASE_(5, YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s"));
# undef YYCASE_
    }

  {
    YYSIZE_T yysize1 = yysize + yystrlen (yyformat);
    if (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM)
      yysize = yysize1;
    else
      return 2;
  }

  if (*yymsg_alloc < yysize)
    {
      *yymsg_alloc = 2 * yysize;
      if (! (yysize <= *yymsg_alloc
             && *yymsg_alloc <= YYSTACK_ALLOC_MAXIMUM))
        *yymsg_alloc = YYSTACK_ALLOC_MAXIMUM;
      return 1;
    }

  /* Avoid sprintf, as that infringes on the user's name space.
     Don't have undefined behavior even if the translation
     produced a string with the wrong number of "%s"s.  */
  {
    char *yyp = *yymsg;
    int yyi = 0;
    while ((*yyp = *yyformat) != '\0')
      if (*yyp == '%' && yyformat[1] == 's' && yyi < yycount)
        {
          yyp += yytnamerr (yyp, yyarg[yyi++]);
          yyformat += 2;
        }
      else
        {
          yyp++;
          yyformat++;
        }
  }
  return 0;
}
#endif /* YYERROR_VERBOSE */

/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep)
{
  YYUSE (yyvaluep);
  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YYUSE (yytype);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}




/* The lookahead symbol.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;
/* Number of syntax errors so far.  */
int yynerrs;


/*----------.
| yyparse.  |
`----------*/

int
yyparse (void)
{
    int yystate;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus;

    /* The stacks and their tools:
       'yyss': related to states.
       'yyvs': related to semantic values.

       Refer to the stacks through separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* The state stack.  */
    yytype_int16 yyssa[YYINITDEPTH];
    yytype_int16 *yyss;
    yytype_int16 *yyssp;

    /* The semantic value stack.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs;
    YYSTYPE *yyvsp;

    YYSIZE_T yystacksize;

  int yyn;
  int yyresult;
  /* Lookahead token as an internal (translated) token number.  */
  int yytoken = 0;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;

#if YYERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYSIZE_T yymsg_alloc = sizeof yymsgbuf;
#endif

#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  yyssp = yyss = yyssa;
  yyvsp = yyvs = yyvsa;
  yystacksize = YYINITDEPTH;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY; /* Cause a token to be read.  */
  goto yysetstate;


/*------------------------------------------------------------.
| yynewstate -- push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;


/*--------------------------------------------------------------------.
| yynewstate -- set current state (the top of the stack) to yystate.  |
`--------------------------------------------------------------------*/
yysetstate:
  *yyssp = (yytype_int16) yystate;

  if (yyss + yystacksize - 1 <= yyssp)
#if !defined yyoverflow && !defined YYSTACK_RELOCATE
    goto yyexhaustedlab;
#else
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYSIZE_T yysize = (YYSIZE_T) (yyssp - yyss + 1);

# if defined yyoverflow
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
# else /* defined YYSTACK_RELOCATE */
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
        YYSTACK_RELOCATE (yyss_alloc, yyss);
        YYSTACK_RELOCATE (yyvs_alloc, yyvs);
# undef YYSTACK_RELOCATE
        if (yyss1 != yyssa)
          YYSTACK_FREE (yyss1);
      }
# endif

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;

      YYDPRINTF ((stderr, "Stack size increased to %lu\n",
                  (unsigned long) yystacksize));

      if (yyss + yystacksize - 1 <= yyssp)
        YYABORT;
    }
#endif /* !defined yyoverflow && !defined YYSTACK_RELOCATE */

  YYDPRINTF ((stderr, "Entering state %d\n", yystate));

  if (yystate == YYFINAL)
    YYACCEPT;

  goto yybackup;


/*-----------.
| yybackup.  |
`-----------*/
yybackup:
  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yyn = yypact[yystate];
  if (yypact_value_is_default (yyn))
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = yylex ();
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
      if (yytable_value_is_error (yyn))
        goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);

  /* Discard the shifted token.  */
  yychar = YYEMPTY;

  yystate = yyn;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END

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
| yyreduce -- do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     '$$ = $1'.

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
#line 65 "cal.y" /* yacc.c:1667  */
    {
                [LibAst.globalStatements addObject:_transfer(id) (yyvsp[0].statement)];
            }
#line 2156 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 10:
#line 69 "cal.y" /* yacc.c:1667  */
    {
                [LibAst.globalStatements addObject:_transfer(id) (yyvsp[0].statement)];
            }
#line 2164 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 12:
#line 74 "cal.y" /* yacc.c:1667  */
    {
                BlockImp *imp = (BlockImp *)makeValue(OCValueBlock);
                imp.declare = makeFuncDeclare(_transfer(id)(yyvsp[-6].identifier),_transfer(id)(yyvsp[-4].declare));
                imp.funcImp = _transfer(id)(yyvsp[-1].expression);
                [LibAst.globalStatements addObject:_transfer(id) (yyvsp[-7].expression)];
            }
#line 2175 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 18:
#line 92 "cal.y" /* yacc.c:1667  */
    {
                OCClass *occlass = [LibAst classForName:_transfer(id)(yyvsp[-2].identifier)];
                occlass.superClassName = _transfer(id)(yyvsp[0].identifier);
                (yyval.declare) = _vretained occlass;
            }
#line 2185 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 19:
#line 99 "cal.y" /* yacc.c:1667  */
    {
                (yyval.declare) = _vretained [LibAst classForName:_transfer(id)(yyvsp[-3].identifier)];
            }
#line 2193 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 20:
#line 103 "cal.y" /* yacc.c:1667  */
    {
                (yyval.declare) = _vretained [LibAst classForName:_transfer(id)(yyvsp[-2].identifier)];
            }
#line 2201 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 21:
#line 107 "cal.y" /* yacc.c:1667  */
    {
                OCClass *occlass = _transfer(OCClass *) (yyvsp[-3].declare);
                occlass.protocols = _transfer(id) (yyvsp[-1].declare);
                (yyval.declare) = _vretained occlass;
            }
#line 2211 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 22:
#line 113 "cal.y" /* yacc.c:1667  */
    {
                OCClass *occlass = _transfer(OCClass *) (yyvsp[-3].declare);
                [occlass.privateVariables addObjectsFromArray:_transfer(id) (yyvsp[-1].declare)];
                (yyval.declare) = _vretained occlass;
            }
#line 2221 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 23:
#line 119 "cal.y" /* yacc.c:1667  */
    {
                OCClass *occlass = _transfer(OCClass *) (yyvsp[-4].declare);

                PropertyDeclare *property = [PropertyDeclare new];
                property.keywords = _transfer(NSMutableArray *) (yyvsp[-2].declare);
                property.var = _transfer(VariableDeclare *) (yyvsp[-1].declare);
                
                [occlass.properties addObject:property];
                (yyval.declare) = _vretained occlass;
            }
#line 2236 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 26:
#line 135 "cal.y" /* yacc.c:1667  */
    {
                (yyval.implementation) = _vretained [LibAst classForName:_transfer(id)(yyvsp[0].identifier)];
            }
#line 2244 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 27:
#line 140 "cal.y" /* yacc.c:1667  */
    {
                (yyval.implementation) = _vretained [LibAst classForName:_transfer(id)(yyvsp[-3].identifier)];
            }
#line 2252 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 28:
#line 144 "cal.y" /* yacc.c:1667  */
    {
                OCClass *occlass = _transfer(OCClass *) (yyvsp[-3].implementation);
                [occlass.privateVariables addObjectsFromArray:_transfer(id) (yyvsp[-1].declare)];
                (yyval.implementation) = _vretained occlass;
            }
#line 2262 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 29:
#line 150 "cal.y" /* yacc.c:1667  */
    {
                MethodImplementation *imp = makeMethodImplementation(_transfer(MethodDeclare *) (yyvsp[-3].declare));
                imp.imp = _transfer(FunctionImp *) (yyvsp[-1].expression);
                OCClass *occlass = _transfer(OCClass *) (yyvsp[-4].implementation);
                [occlass.methods addObject:imp];
                (yyval.implementation) = _vretained occlass;
            }
#line 2274 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 31:
#line 160 "cal.y" /* yacc.c:1667  */
    {
				NSMutableArray *list = [NSMutableArray array];
				NSString *identifier = (__bridge_transfer NSString *)(yyvsp[0].identifier);
				[list addObject:identifier];
				(yyval.declare) = (__bridge_retained void *)list;
			}
#line 2285 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 32:
#line 167 "cal.y" /* yacc.c:1667  */
    {
				NSMutableArray *list = (__bridge_transfer NSMutableArray *)(yyvsp[-2].declare);
				NSString *identifier = (__bridge_transfer NSString *)(yyvsp[0].identifier);
				[list addObject:identifier];
				(yyval.declare) = (__bridge_retained void *)list;
			}
#line 2296 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 33:
#line 176 "cal.y" /* yacc.c:1667  */
    {
                NSMutableArray *list = [NSMutableArray array];
				(yyval.declare) = (__bridge_retained void *)list;
            }
#line 2305 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 34:
#line 181 "cal.y" /* yacc.c:1667  */
    {
                NSMutableArray *list = _transfer(NSMutableArray *) (yyvsp[-2].declare);
				[list addObject:_transfer(VariableDeclare *) (yyvsp[-1].declare)];
				(yyval.declare) = (__bridge_retained void *)list;
            }
#line 2315 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 45:
#line 202 "cal.y" /* yacc.c:1667  */
    {
                NSMutableArray *list = [NSMutableArray array];
				(yyval.declare) = (__bridge_retained void *)list;
            }
#line 2324 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 46:
#line 207 "cal.y" /* yacc.c:1667  */
    {
                NSMutableArray *list = [NSMutableArray array];
				(yyval.declare) = (__bridge_retained void *)list;
            }
#line 2333 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 47:
#line 212 "cal.y" /* yacc.c:1667  */
    {
                NSMutableArray *list = _transfer(NSMutableArray *) (yyvsp[-2].declare);
				[list addObject:_transfer(NSString *) (yyvsp[-1].identifier)];
				(yyval.declare) = (__bridge_retained void *)list;
            }
#line 2343 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 48:
#line 218 "cal.y" /* yacc.c:1667  */
    {
                NSMutableArray *list = _transfer(NSMutableArray *) (yyvsp[-2].declare);
				[list addObject:_transfer(NSString *) (yyvsp[-1].identifier)];
				(yyval.declare) = (__bridge_retained void *)list;
            }
#line 2353 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 49:
#line 227 "cal.y" /* yacc.c:1667  */
    {
                (yyval.declare) = _vretained makeVariableDeclare((__bridge TypeSpecial *)(yyvsp[-1].expression),(__bridge NSString *)(yyvsp[0].identifier));
            }
#line 2361 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 50:
#line 231 "cal.y" /* yacc.c:1667  */
    {
                (yyval.declare) = _vretained makeVariableDeclare(makeTypeSpecial(SpecialTypeBlock),(__bridge NSString *)(yyvsp[-4].identifier));
            }
#line 2369 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 51:
#line 240 "cal.y" /* yacc.c:1667  */
    {
                (yyval.expression) = (yyvsp[0].expression);
            }
#line 2377 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 54:
#line 247 "cal.y" /* yacc.c:1667  */
    {
                (yyval.expression) = _vretained makeTypeSpecial(SpecialTypeObject,@"typeof");
            }
#line 2385 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 55:
#line 251 "cal.y" /* yacc.c:1667  */
    {
                 (yyval.expression) = _vretained makeTypeSpecial(SpecialTypeUChar);
            }
#line 2393 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 56:
#line 255 "cal.y" /* yacc.c:1667  */
    {
                (yyval.expression) = _vretained makeTypeSpecial(SpecialTypeUShort);
            }
#line 2401 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 57:
#line 259 "cal.y" /* yacc.c:1667  */
    {
                (yyval.expression) = _vretained makeTypeSpecial(SpecialTypeUInt);
            }
#line 2409 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 58:
#line 263 "cal.y" /* yacc.c:1667  */
    {
                (yyval.expression) = _vretained makeTypeSpecial(SpecialTypeULong);
            }
#line 2417 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 59:
#line 267 "cal.y" /* yacc.c:1667  */
    {
                (yyval.expression) = _vretained makeTypeSpecial(SpecialTypeULongLong);
            }
#line 2425 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 60:
#line 271 "cal.y" /* yacc.c:1667  */
    {
                (yyval.expression) = _vretained makeTypeSpecial(SpecialTypeChar);
            }
#line 2433 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 61:
#line 275 "cal.y" /* yacc.c:1667  */
    {
                (yyval.expression) = _vretained makeTypeSpecial(SpecialTypeShort);
            }
#line 2441 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 62:
#line 279 "cal.y" /* yacc.c:1667  */
    {
                (yyval.expression) = _vretained makeTypeSpecial(SpecialTypeInt);
            }
#line 2449 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 63:
#line 283 "cal.y" /* yacc.c:1667  */
    {
                (yyval.expression) = _vretained makeTypeSpecial(SpecialTypeLong);
            }
#line 2457 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 64:
#line 287 "cal.y" /* yacc.c:1667  */
    {
                (yyval.expression) = _vretained makeTypeSpecial(SpecialTypeLongLong);
            }
#line 2465 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 65:
#line 291 "cal.y" /* yacc.c:1667  */
    {
                (yyval.expression) = _vretained makeTypeSpecial(SpecialTypeDouble);
            }
#line 2473 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 66:
#line 295 "cal.y" /* yacc.c:1667  */
    {
                (yyval.expression) = _vretained makeTypeSpecial(SpecialTypeFloat);
            }
#line 2481 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 67:
#line 299 "cal.y" /* yacc.c:1667  */
    {
                (yyval.expression) = _vretained makeTypeSpecial(SpecialTypeClass);
            }
#line 2489 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 68:
#line 303 "cal.y" /* yacc.c:1667  */
    {
                (yyval.expression) = _vretained makeTypeSpecial(SpecialTypeBOOL);
            }
#line 2497 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 69:
#line 307 "cal.y" /* yacc.c:1667  */
    {
                (yyval.expression) = _vretained makeTypeSpecial(SpecialTypeVoid);
            }
#line 2505 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 70:
#line 311 "cal.y" /* yacc.c:1667  */
    {
                (yyval.expression) = _vretained makeTypeSpecial(SpecialTypeId);
            }
#line 2513 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 71:
#line 321 "cal.y" /* yacc.c:1667  */
    {
                (yyval.expression) = _vretained makeTypeSpecial(SpecialTypeObject,(__bridge NSString *)(yyvsp[0].identifier));
            }
#line 2521 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 72:
#line 325 "cal.y" /* yacc.c:1667  */
    {
                (yyval.expression) = _vretained makeTypeSpecial(SpecialTypeId);
            }
#line 2529 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 73:
#line 329 "cal.y" /* yacc.c:1667  */
    {
                (yyval.expression) = _vretained makeTypeSpecial(SpecialTypeBlock);
            }
#line 2537 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 74:
#line 333 "cal.y" /* yacc.c:1667  */
    {
                TypeSpecial *type = _transfer(id) (yyvsp[-1].expression);
                type.isPointer = YES;
                (yyval.expression) = _vretained type;
            }
#line 2547 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 91:
#line 366 "cal.y" /* yacc.c:1667  */
    {
                (yyval.declare) = _vretained [NSMutableArray array];
            }
#line 2555 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 92:
#line 370 "cal.y" /* yacc.c:1667  */
    {
                NSMutableArray *array = [NSMutableArray array];
                [array addObject:_transfer(id)(yyvsp[0].expression)];
                (yyval.declare) = _vretained array;
            }
#line 2565 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 93:
#line 376 "cal.y" /* yacc.c:1667  */
    {
                NSMutableArray *array = _transfer(NSMutableArray *)(yyvsp[-2].declare);
                [array addObject:_transfer(id) (yyvsp[0].expression)];
                (yyval.declare) = _vretained array;
            }
#line 2575 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 94:
#line 385 "cal.y" /* yacc.c:1667  */
    {   
                (yyval.declare) = _vretained makeMethodDeclare(NO,_transfer(TypeSpecial *) (yyvsp[-1].expression));
            }
#line 2583 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 95:
#line 389 "cal.y" /* yacc.c:1667  */
    {
                (yyval.declare) = _vretained makeMethodDeclare(YES,_transfer(TypeSpecial *) (yyvsp[-1].expression));
            }
#line 2591 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 96:
#line 393 "cal.y" /* yacc.c:1667  */
    {
                MethodDeclare *method = _transfer(MethodDeclare *)(yyval.declare);
                [method.methodNames addObject:_transfer(NSString *) (yyvsp[0].identifier)];
                (yyval.declare) = _vretained method;
            }
#line 2601 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 97:
#line 399 "cal.y" /* yacc.c:1667  */
    {
                MethodDeclare *method = _transfer(MethodDeclare *)(yyval.declare);
                [method.methodNames addObject:_transfer(NSString *) (yyvsp[-5].identifier)];
                [method.parameterTypes addObject:_transfer(TypeSpecial *) (yyvsp[-2].expression)];
                [method.parameterNames addObject:_transfer(NSString *) (yyvsp[0].identifier)];
                (yyval.declare) = _vretained method;
            }
#line 2613 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 98:
#line 410 "cal.y" /* yacc.c:1667  */
    {
            OCMethodCallNormalElement *element = makeMethodCallElement(OCMethodCallNormalCall);
            [element.names addObject:_transfer(NSString *)(yyvsp[0].identifier)];
            (yyval.expression) = _vretained element;
        }
#line 2623 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 99:
#line 416 "cal.y" /* yacc.c:1667  */
    {
            OCMethodCallNormalElement *element = makeMethodCallElement(OCMethodCallNormalCall);
            [element.names addObject:_transfer(NSString *)(yyvsp[-2].identifier)];
            [element.values addObjectsFromArray:_transfer(id)(yyvsp[0].expression)];
            (yyval.expression) = _vretained element;
        }
#line 2634 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 100:
#line 423 "cal.y" /* yacc.c:1667  */
    {
            OCMethodCallNormalElement *element = _transfer(OCMethodCallNormalElement *)(yyvsp[-3].expression);
            [element.names addObject:_transfer(NSString *)(yyvsp[-2].identifier)];
            [element.values addObjectsFromArray:_transfer(id)(yyvsp[0].expression)];
            (yyval.expression) = _vretained element;
        }
#line 2645 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 101:
#line 432 "cal.y" /* yacc.c:1667  */
    {
             OCMethodCall *methodcall = (OCMethodCall *) makeValue(OCValueMethodCall);
             OCValue *caller = _transfer(OCValue *)(yyvsp[-2].expression);
             methodcall.caller =  caller;
             methodcall.element = _transfer(id <OCMethodElement>)(yyvsp[-1].expression);
             (yyval.expression) = _vretained methodcall;
        }
#line 2657 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 102:
#line 444 "cal.y" /* yacc.c:1667  */
    {
            BlockImp *imp = (BlockImp *)makeValue(OCValueBlock);
            imp.funcImp = _transfer(id)(yyvsp[-1].expression);
            imp.declare = makeFuncDeclare(_transfer(id)(yyvsp[-3].expression),nil);
            (yyval.expression) = _vretained imp; 
        }
#line 2668 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 103:
#line 452 "cal.y" /* yacc.c:1667  */
    {
            BlockImp *imp = (BlockImp *)makeValue(OCValueBlock);
            imp.declare = makeFuncDeclare(_transfer(id)(yyvsp[-6].expression),_transfer(id)(yyvsp[-4].declare));
            imp.funcImp = _transfer(id)(yyvsp[-1].expression);
            (yyval.expression) = _vretained imp; 
        }
#line 2679 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 104:
#line 460 "cal.y" /* yacc.c:1667  */
    {
            BlockImp *imp = (BlockImp *)makeValue(OCValueBlock);
            imp.declare = makeFuncDeclare(makeTypeSpecial(SpecialTypeVoid),nil);
            imp.funcImp = _transfer(id)(yyvsp[-1].expression);
            (yyval.expression) = _vretained imp; 
        }
#line 2690 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 105:
#line 468 "cal.y" /* yacc.c:1667  */
    {
            BlockImp *imp = (BlockImp *)makeValue(OCValueBlock);
            imp.declare = makeFuncDeclare(makeTypeSpecial(SpecialTypeVoid),_transfer(id) (yyvsp[-4].declare));
            imp.funcImp = _transfer(id)(yyvsp[-1].expression);
            (yyval.expression) = _vretained imp; 
        }
#line 2701 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 106:
#line 479 "cal.y" /* yacc.c:1667  */
    {
             (yyval.expression) = _vretained makeDeclareExpression(_transfer(id) (yyvsp[0].declare));
         }
#line 2709 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 107:
#line 483 "cal.y" /* yacc.c:1667  */
    {
             DeclareExpression *exp = makeDeclareExpression(_transfer(id) (yyvsp[-2].declare));
             exp.expression = _transfer(id) (yyvsp[0].expression);
             (yyval.expression) = _vretained exp;
         }
#line 2719 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 111:
#line 496 "cal.y" /* yacc.c:1667  */
    {
            (yyval.statement) = _vretained makeReturnStatement(nil);
        }
#line 2727 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 112:
#line 500 "cal.y" /* yacc.c:1667  */
    {
            (yyval.statement) = _vretained makeReturnStatement(_transfer(id)(yyvsp[-1].expression));
        }
#line 2735 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 113:
#line 504 "cal.y" /* yacc.c:1667  */
    {
            (yyval.statement) = _vretained makeBreakStatement();
        }
#line 2743 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 114:
#line 508 "cal.y" /* yacc.c:1667  */
    {
            (yyval.statement) = _vretained makeContinueStatement();
        }
#line 2751 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 115:
#line 515 "cal.y" /* yacc.c:1667  */
    {
            IfStatement *statement = makeIfStatement(_transfer(id) (yyvsp[-4].expression),_transfer(FunctionImp *)(yyvsp[-2].identifier));
            (yyval.statement) = _vretained statement;
         }
#line 2760 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 116:
#line 520 "cal.y" /* yacc.c:1667  */
    {
            IfStatement *statement = _transfer(IfStatement *)(yyvsp[-8].statement);
            IfStatement *elseIfStatement = makeIfStatement(_transfer(id) (yyvsp[-4].expression),_transfer(FunctionImp *)(yyvsp[-1].expression));
            elseIfStatement.last = statement;
            (yyval.statement)  = _vretained elseIfStatement;
        }
#line 2771 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 117:
#line 527 "cal.y" /* yacc.c:1667  */
    {
            IfStatement *statement = _transfer(IfStatement *)(yyvsp[-4].statement);
            IfStatement *elseStatement = makeIfStatement(nil,_transfer(FunctionImp *)(yyvsp[-1].expression));
            elseStatement.last = statement;
            (yyval.statement)  = _vretained elseStatement;
        }
#line 2782 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 118:
#line 537 "cal.y" /* yacc.c:1667  */
    {
            DoWhileStatement *statement = makeDoWhileStatement(_transfer(id)(yyvsp[-3].identifier),_transfer(FunctionImp *)(yyvsp[-5].expression));
            (yyval.statement) = _vretained statement;
        }
#line 2791 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 119:
#line 544 "cal.y" /* yacc.c:1667  */
    {
            WhileStatement *statement = makeWhileStatement(_transfer(id)(yyvsp[-4].expression),_transfer(FunctionImp *)(yyvsp[-1].expression));
            (yyval.statement) = _vretained statement;
        }
#line 2800 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 120:
#line 559 "cal.y" /* yacc.c:1667  */
    {
             (yyval.statement) = _vretained makeCaseStatement(_transfer(OCValue *)(yyvsp[-1].expression));
         }
#line 2808 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 121:
#line 563 "cal.y" /* yacc.c:1667  */
    {
            (yyval.statement) = _vretained makeCaseStatement(nil);
        }
#line 2816 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 122:
#line 567 "cal.y" /* yacc.c:1667  */
    {
            CaseStatement *statement =  _transfer(CaseStatement *)(yyvsp[-3].statement);
            statement.funcImp = _transfer(FunctionImp *) (yyvsp[-1].expression);
            (yyval.statement) = _vretained statement;
        }
#line 2826 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 123:
#line 575 "cal.y" /* yacc.c:1667  */
    {
             SwitchStatement *statement = makeSwitchStatement(_transfer(id) (yyvsp[-2].expression));
             (yyval.statement) = _vretained statement;
         }
#line 2835 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 124:
#line 580 "cal.y" /* yacc.c:1667  */
    {
            SwitchStatement *statement = _transfer(SwitchStatement *)(yyvsp[-1].statement);
            [statement.cases addObject:_transfer(id) (yyvsp[0].statement)];
            (yyval.statement) = _vretained statement;
        }
#line 2845 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 126:
#line 594 "cal.y" /* yacc.c:1667  */
    {
            NSMutableArray *expressions = [NSMutableArray array];
            [expressions addObject:_transfer(id)(yyvsp[0].expression)];
            (yyval.expression) = _vretained expressions;
        }
#line 2855 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 127:
#line 600 "cal.y" /* yacc.c:1667  */
    {
            NSMutableArray *expressions = _transfer(NSMutableArray *)(yyval.expression);
            [expressions addObject:_transfer(id) (yyvsp[0].expression)];
            (yyval.expression) = _vretained expressions;
        }
#line 2865 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 128:
#line 607 "cal.y" /* yacc.c:1667  */
    {
            ForStatement* statement = makeForStatement(_transfer(FunctionImp *) (yyvsp[-1].expression));
            statement.expressions = _transfer(NSMutableArray *) (yyvsp[-4].expression);
            (yyval.statement) = _vretained statement;
        }
#line 2875 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 129:
#line 615 "cal.y" /* yacc.c:1667  */
    {
            ForInStatement * statement = makeForInStatement(_transfer(FunctionImp *)(yyvsp[-1].expression));
            statement.declare = _transfer(id) (yyvsp[-6].declare);
            statement.value = _transfer(id)(yyvsp[-4].expression);
            (yyval.statement) = _vretained statement;
        }
#line 2886 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 136:
#line 635 "cal.y" /* yacc.c:1667  */
    {
            (yyval.expression) = _vretained makeFuncImp();
        }
#line 2894 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 137:
#line 639 "cal.y" /* yacc.c:1667  */
    {
            FunctionImp *imp = _transfer(FunctionImp *)(yyvsp[-1].expression);
            [imp.statements addObject:_transfer(id) (yyvsp[0].statement)];
            (yyval.expression) = _vretained imp;
        }
#line 2904 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 138:
#line 645 "cal.y" /* yacc.c:1667  */
    {
            FunctionImp *imp = _transfer(FunctionImp *)(yyvsp[-1].expression);
            [imp.statements addObject:_transfer(id) (yyvsp[0].statement)];
            (yyval.expression) = _vretained imp;
        }
#line 2914 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 139:
#line 654 "cal.y" /* yacc.c:1667  */
    {
            NSMutableArray *list = [NSMutableArray array];
            [list addObject:_transfer(id)(yyvsp[0].expression)];
            (yyval.expression) = _vretained list;
        }
#line 2924 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 140:
#line 660 "cal.y" /* yacc.c:1667  */
    {
            NSMutableArray *list = (__bridge_transfer NSMutableArray *)(yyvsp[-2].expression);
            [list addObject:_transfer(id) (yyvsp[0].expression)];
            (yyval.expression) = (__bridge_retained void *)list;
        }
#line 2934 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 141:
#line 669 "cal.y" /* yacc.c:1667  */
    {
            (yyval.Operator) = AssignOperatorAssign;
        }
#line 2942 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 142:
#line 673 "cal.y" /* yacc.c:1667  */
    {
            (yyval.Operator) = AssignOperatorAssignAnd;
        }
#line 2950 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 143:
#line 677 "cal.y" /* yacc.c:1667  */
    {
            (yyval.Operator) = AssignOperatorAssignOr;
        }
#line 2958 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 144:
#line 681 "cal.y" /* yacc.c:1667  */
    {
            (yyval.Operator) = AssignOperatorAssignXor;
        }
#line 2966 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 145:
#line 685 "cal.y" /* yacc.c:1667  */
    {
            (yyval.Operator) = AssignOperatorAssignAdd;
        }
#line 2974 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 146:
#line 689 "cal.y" /* yacc.c:1667  */
    {
            (yyval.Operator) = AssignOperatorAssignSub;
        }
#line 2982 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 147:
#line 693 "cal.y" /* yacc.c:1667  */
    {
            (yyval.Operator) = AssignOperatorAssignDiv;
        }
#line 2990 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 148:
#line 697 "cal.y" /* yacc.c:1667  */
    {
            (yyval.Operator) = AssignOperatorAssignMuti;
        }
#line 2998 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 149:
#line 701 "cal.y" /* yacc.c:1667  */
    {
            (yyval.Operator) = AssignOperatorAssignMod;
        }
#line 3006 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 151:
#line 709 "cal.y" /* yacc.c:1667  */
    {
        AssignExpression *expression = makeAssignExpression((yyvsp[-1].Operator));
        expression.expression = _transfer(id) (yyvsp[-2].expression);
        expression.value = _transfer(OCValue *)(yyvsp[0].expression);
        (yyval.expression) = _vretained expression;
    }
#line 3017 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 153:
#line 720 "cal.y" /* yacc.c:1667  */
    {
        TernaryExpression *expression = makeTernaryExpression();
        expression.expression = _transfer(id)(yyvsp[-4].expression);
        [expression.values addObject:_transfer(id)(yyvsp[-2].expression)];
        [expression.values addObject:_transfer(id)(yyvsp[0].expression)];
        (yyval.expression) = _vretained expression;
    }
#line 3029 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 154:
#line 728 "cal.y" /* yacc.c:1667  */
    {
        TernaryExpression *expression = makeTernaryExpression();
        expression.expression = _transfer(id)(yyvsp[-3].expression);
        [expression.values addObject:_transfer(id)(yyvsp[0].expression)];
        (yyval.expression) = _vretained expression;
    }
#line 3040 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 156:
#line 740 "cal.y" /* yacc.c:1667  */
    {
        BinaryExpression *exp = makeBinaryExpression(BinaryOperatorLOGIC_OR);
        exp.left = _transfer(id) (yyvsp[-2].expression);
        exp.right = _transfer(id) (yyvsp[0].expression);
        (yyval.expression) = _vretained exp;
    }
#line 3051 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 158:
#line 751 "cal.y" /* yacc.c:1667  */
    {
        BinaryExpression *exp = makeBinaryExpression(BinaryOperatorLOGIC_AND);
        exp.left = _transfer(id) (yyvsp[-2].expression);
        exp.right = _transfer(id) (yyvsp[0].expression);
        (yyval.expression) = _vretained exp;
    }
#line 3062 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 160:
#line 761 "cal.y" /* yacc.c:1667  */
    {
        BinaryExpression *exp = makeBinaryExpression(BinaryOperatorOr);
        exp.left = _transfer(id) (yyvsp[-2].expression);
        exp.right = _transfer(id) (yyvsp[0].expression);
        (yyval.expression) = _vretained exp;
    }
#line 3073 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 162:
#line 771 "cal.y" /* yacc.c:1667  */
    {
        BinaryExpression *exp = makeBinaryExpression(BinaryOperatorXor);
        exp.left = _transfer(id) (yyvsp[-2].expression);
        exp.right = _transfer(id) (yyvsp[0].expression);
        (yyval.expression) = _vretained exp;
    }
#line 3084 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 164:
#line 782 "cal.y" /* yacc.c:1667  */
    {
        BinaryExpression *exp = makeBinaryExpression(BinaryOperatorAnd);
        exp.left = _transfer(id) (yyvsp[-2].expression);
        exp.right = _transfer(id) (yyvsp[0].expression);
        (yyval.expression) = _vretained exp;
    }
#line 3095 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 166:
#line 793 "cal.y" /* yacc.c:1667  */
    {
        BinaryExpression *exp = makeBinaryExpression(BinaryOperatorEqual);
        exp.left = _transfer(id) (yyvsp[-2].expression);
        exp.right = _transfer(id) (yyvsp[0].expression);
        (yyval.expression) = _vretained exp;
    }
#line 3106 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 167:
#line 800 "cal.y" /* yacc.c:1667  */
    {
        BinaryExpression *exp = makeBinaryExpression(BinaryOperatorNotEqual);
        exp.left = _transfer(id) (yyvsp[-2].expression);
        exp.right = _transfer(id) (yyvsp[0].expression);
        (yyval.expression) = _vretained exp;
    }
#line 3117 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 169:
#line 810 "cal.y" /* yacc.c:1667  */
    {
        BinaryExpression *exp = makeBinaryExpression(BinaryOperatorLT);
        exp.left = _transfer(id) (yyvsp[-2].expression);
        exp.right = _transfer(id) (yyvsp[0].expression);
        (yyval.expression) = _vretained exp;
    }
#line 3128 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 170:
#line 817 "cal.y" /* yacc.c:1667  */
    {
        BinaryExpression *exp = makeBinaryExpression(BinaryOperatorLE);
        exp.left = _transfer(id) (yyvsp[-2].expression);
        exp.right = _transfer(id) (yyvsp[0].expression);
        (yyval.expression) = _vretained exp;
    }
#line 3139 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 171:
#line 824 "cal.y" /* yacc.c:1667  */
    {
        BinaryExpression *exp = makeBinaryExpression(BinaryOperatorGT);
        exp.left = _transfer(id) (yyvsp[-2].expression);
        exp.right = _transfer(id) (yyvsp[0].expression);
        (yyval.expression) = _vretained exp;
    }
#line 3150 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 172:
#line 831 "cal.y" /* yacc.c:1667  */
    {
        BinaryExpression *exp = makeBinaryExpression(BinaryOperatorGE);
        exp.left = _transfer(id) (yyvsp[-2].expression);
        exp.right = _transfer(id) (yyvsp[0].expression);
        (yyval.expression) = _vretained exp;
    }
#line 3161 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 174:
#line 841 "cal.y" /* yacc.c:1667  */
    {
        BinaryExpression *exp = makeBinaryExpression(BinaryOperatorShiftLeft);
        exp.left = _transfer(id) (yyvsp[-2].expression);
        exp.right = _transfer(id) (yyvsp[0].expression);
        (yyval.expression) = _vretained exp;
    }
#line 3172 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 175:
#line 848 "cal.y" /* yacc.c:1667  */
    {
        BinaryExpression *exp = makeBinaryExpression(BinaryOperatorShiftRight);
        exp.left = _transfer(id) (yyvsp[-2].expression);
        exp.right = _transfer(id) (yyvsp[0].expression);
        (yyval.expression) = _vretained exp;
    }
#line 3183 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 177:
#line 858 "cal.y" /* yacc.c:1667  */
    {
        BinaryExpression *exp = makeBinaryExpression(BinaryOperatorAdd);
        exp.left = _transfer(id) (yyvsp[-2].expression);
        exp.right = _transfer(id) (yyvsp[0].expression);
        (yyval.expression) = _vretained exp;
    }
#line 3194 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 178:
#line 865 "cal.y" /* yacc.c:1667  */
    {
        BinaryExpression *exp = makeBinaryExpression(BinaryOperatorSub);
        exp.left = _transfer(id) (yyvsp[-2].expression);
        exp.right = _transfer(id) (yyvsp[0].expression);
        (yyval.expression) = _vretained exp;
    }
#line 3205 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 180:
#line 876 "cal.y" /* yacc.c:1667  */
    {
        BinaryExpression *exp = makeBinaryExpression(BinaryOperatorMulti);
        exp.left = _transfer(id) (yyvsp[-2].expression);
        exp.right = _transfer(id) (yyvsp[0].expression);
        (yyval.expression) = _vretained exp;
    }
#line 3216 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 181:
#line 883 "cal.y" /* yacc.c:1667  */
    {
        BinaryExpression *exp = makeBinaryExpression(BinaryOperatorDiv);
        exp.left = _transfer(id) (yyvsp[-2].expression);
        exp.right = _transfer(id) (yyvsp[0].expression);
        (yyval.expression) = _vretained exp;
    }
#line 3227 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 182:
#line 890 "cal.y" /* yacc.c:1667  */
    {
        BinaryExpression *exp = makeBinaryExpression(BinaryOperatorMod);
        exp.left = _transfer(id) (yyvsp[-2].expression);
        exp.right = _transfer(id) (yyvsp[0].expression);
        (yyval.expression) = _vretained exp;
    }
#line 3238 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 184:
#line 901 "cal.y" /* yacc.c:1667  */
    {
        UnaryExpression *exp = makeUnaryExpression(UnaryOperatorNot);
        exp.value = _transfer(id)(yyvsp[0].expression);
        (yyval.expression) = _vretained exp;
    }
#line 3248 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 185:
#line 907 "cal.y" /* yacc.c:1667  */
    {
        UnaryExpression *exp = makeUnaryExpression(UnaryOperatorNegative);
        exp.value = _transfer(id)(yyvsp[0].expression);
        (yyval.expression) = _vretained exp;
    }
#line 3258 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 186:
#line 913 "cal.y" /* yacc.c:1667  */
    {
        UnaryExpression *exp = makeUnaryExpression(UnaryOperatorPointValue);
        exp.value = _transfer(id)(yyvsp[0].expression);
        (yyval.expression) = _vretained exp;
    }
#line 3268 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 187:
#line 919 "cal.y" /* yacc.c:1667  */
    {
        UnaryExpression *exp = makeUnaryExpression(UnaryOperatorAdressPoint);
        exp.value = _transfer(id)(yyvsp[0].expression);
        (yyval.expression) = _vretained exp;
    }
#line 3278 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 188:
#line 925 "cal.y" /* yacc.c:1667  */
    {
        UnaryExpression *exp = makeUnaryExpression(UnaryOperatorBiteNot);
        exp.value = _transfer(id)(yyvsp[0].expression);
        (yyval.expression) = _vretained exp;
    }
#line 3288 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 189:
#line 931 "cal.y" /* yacc.c:1667  */
    {
        UnaryExpression *exp = makeUnaryExpression(UnaryOperatorSizeOf);
        exp.value = _transfer(id)(yyvsp[0].expression);
        (yyval.expression) = _vretained exp;
    }
#line 3298 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 190:
#line 937 "cal.y" /* yacc.c:1667  */
    {
        (yyval.expression) = (yyvsp[0].expression);
    }
#line 3306 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 191:
#line 941 "cal.y" /* yacc.c:1667  */
    {
        UnaryExpression *exp = makeUnaryExpression(UnaryOperatorIncrementSuffix);
        exp.value = _transfer(id)(yyvsp[-1].expression);
        (yyval.expression) = _vretained exp;
    }
#line 3316 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 192:
#line 947 "cal.y" /* yacc.c:1667  */
    {
        UnaryExpression *exp = makeUnaryExpression(UnaryOperatorDecrementSuffix);
        exp.value = _transfer(id)(yyvsp[-1].expression);
        (yyval.expression) = _vretained exp;
    }
#line 3326 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 193:
#line 953 "cal.y" /* yacc.c:1667  */
    {
        UnaryExpression *exp = makeUnaryExpression(UnaryOperatorIncrementPrefix);
        exp.value = _transfer(id)(yyvsp[0].expression);
        (yyval.expression) = _vretained exp;
    }
#line 3336 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 194:
#line 959 "cal.y" /* yacc.c:1667  */
    {
        UnaryExpression *exp = makeUnaryExpression(UnaryOperatorDecrementPrefix);
        exp.value = _transfer(id)(yyvsp[0].expression);
        (yyval.expression) = _vretained exp;
    }
#line 3346 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 195:
#line 968 "cal.y" /* yacc.c:1667  */
    {
            (yyval.expression) = _vretained makeValue(OCValueInt,_transfer(id)(yyvsp[0].identifier));
        }
#line 3354 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 196:
#line 972 "cal.y" /* yacc.c:1667  */
    {
            (yyval.expression) = _vretained makeValue(OCValueInt,_transfer(id)(yyvsp[0].identifier));
        }
#line 3362 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 197:
#line 978 "cal.y" /* yacc.c:1667  */
    {
            NSMutableArray *array = [NSMutableArray array];
            [array addObject:@[_transfer(id)(yyvsp[-2].expression),_transfer(id)(yyvsp[0].expression)]];
            (yyval.expression) = _vretained array;
        }
#line 3372 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 198:
#line 984 "cal.y" /* yacc.c:1667  */
    {
            NSMutableArray *array = _transfer(id)(yyvsp[-4].expression);
            [array addObject:@[_transfer(id)(yyvsp[-2].expression),_transfer(id)(yyvsp[0].expression)]];
            (yyval.expression) = _vretained array;
        }
#line 3382 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 199:
#line 992 "cal.y" /* yacc.c:1667  */
    {
            (yyval.expression) = _vretained makeValue(OCValueIdentifier,_transfer(id) (yyvsp[0].identifier));
        }
#line 3390 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 200:
#line 996 "cal.y" /* yacc.c:1667  */
    {
            (yyval.expression) = _vretained makeValue(OCValueSelf);
        }
#line 3398 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 201:
#line 1000 "cal.y" /* yacc.c:1667  */
    {
            (yyval.expression) = _vretained makeValue(OCValueSuper);
        }
#line 3406 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 203:
#line 1005 "cal.y" /* yacc.c:1667  */
    {
            OCMethodCall *methodcall = (OCMethodCall *) makeValue(OCValueMethodCall);
            methodcall.caller =  _transfer(OCValue *)(yyvsp[-2].expression);
            OCMethodCallGetElement *element = makeMethodCallElement(OCMethodCallDotGet);
            element.name = _transfer(NSString *)(yyvsp[0].identifier);
            methodcall.element = element;
            (yyval.expression) = _vretained methodcall;

        }
#line 3420 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 204:
#line 1015 "cal.y" /* yacc.c:1667  */
    {
            OCMethodCall *methodcall = (OCMethodCall *) makeValue(OCValueMethodCall);
            methodcall.caller =  _transfer(OCValue *)(yyvsp[-2].expression);
            OCMethodCallGetElement *element = makeMethodCallElement(OCMethodCallDotGet);
            element.name = _transfer(NSString *)(yyvsp[0].identifier);
            methodcall.element = element;
            (yyval.expression) = _vretained methodcall;
        }
#line 3433 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 205:
#line 1024 "cal.y" /* yacc.c:1667  */
    {
            id object = _transfer(id) (yyvsp[-3].expression);
            if([object isKindOfClass:[NSString class]]){
                CFuncCall *call = (CFuncCall *)makeValue(OCValueFuncCall);
                call.name = _transfer(id) (yyvsp[-3].expression);
                call.expressions = _transfer(id) (yyvsp[-1].expression);
                (yyval.expression) = _vretained call;
            }else if([object isKindOfClass:[OCMethodCall class]]){
                OCMethodCall *methodcall = _transfer(OCMethodCall *) (yyvsp[-3].expression);
                OCMethodCallGetElement *element = methodcall.element;
                [element.values addObjectsFromArray:_transfer(id) (yyvsp[-1].expression)];
                (yyval.expression) = _vretained methodcall;
            }
        }
#line 3452 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 206:
#line 1039 "cal.y" /* yacc.c:1667  */
    {
            (yyval.expression) = (yyvsp[-1].expression);
        }
#line 3460 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 207:
#line 1043 "cal.y" /* yacc.c:1667  */
    {
            (yyval.expression) = _vretained makeValue(OCValueDictionary,_transfer(id)(yyvsp[-1].expression));
        }
#line 3468 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 208:
#line 1047 "cal.y" /* yacc.c:1667  */
    {
            (yyval.expression) = _vretained makeValue(OCValueArray,_transfer(id)(yyvsp[-1].expression));
        }
#line 3476 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 209:
#line 1051 "cal.y" /* yacc.c:1667  */
    {
            (yyval.expression) = _vretained makeValue(OCValueNSNumber,_transfer(id)(yyvsp[-1].expression));
        }
#line 3484 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 210:
#line 1055 "cal.y" /* yacc.c:1667  */
    {
            (yyval.expression) = _vretained makeValue(OCValueNSNumber,_transfer(id)(yyvsp[0].expression));
        }
#line 3492 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 211:
#line 1059 "cal.y" /* yacc.c:1667  */
    {
            (yyval.expression) = _vretained makeValue(OCValueString);
        }
#line 3500 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 212:
#line 1063 "cal.y" /* yacc.c:1667  */
    {
            (yyval.expression) = _vretained makeValue(OCValueSelector,_transfer(id)(yyvsp[0].identifier));
        }
#line 3508 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 213:
#line 1067 "cal.y" /* yacc.c:1667  */
    {
            (yyval.expression) = _vretained makeValue(OCValueProtocol,_transfer(id)(yyvsp[-1].identifier));
        }
#line 3516 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 214:
#line 1071 "cal.y" /* yacc.c:1667  */
    {
            (yyval.expression) = _vretained makeValue(OCValueCString,_transfer(id)(yyvsp[0].identifier));
        }
#line 3524 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 217:
#line 1077 "cal.y" /* yacc.c:1667  */
    {
            (yyval.expression) = _vretained makeValue(OCValueNil);
        }
#line 3532 "cal.tab.c" /* yacc.c:1667  */
    break;

  case 218:
#line 1081 "cal.y" /* yacc.c:1667  */
    {
            (yyval.expression) = _vretained makeValue(OCValueNULL);
        }
#line 3540 "cal.tab.c" /* yacc.c:1667  */
    break;


#line 3544 "cal.tab.c" /* yacc.c:1667  */
      default: break;
    }
  /* User semantic actions sometimes alter yychar, and that requires
     that yytoken be updated with the new translation.  We take the
     approach of translating immediately before every use of yytoken.
     One alternative is translating here after every semantic action,
     but that translation would be missed if the semantic action invokes
     YYABORT, YYACCEPT, or YYERROR immediately after altering yychar or
     if it invokes YYBACKUP.  In the case of YYABORT or YYACCEPT, an
     incorrect destructor might then be invoked immediately.  In the
     case of YYERROR or YYBACKUP, subsequent parser actions might lead
     to an incorrect destructor call or verbose syntax error message
     before the lookahead is translated.  */
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;

  /* Now 'shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */
  {
    const int yylhs = yyr1[yyn] - YYNTOKENS;
    const int yyi = yypgoto[yylhs] + *yyssp;
    yystate = (0 <= yyi && yyi <= YYLAST && yycheck[yyi] == *yyssp
               ? yytable[yyi]
               : yydefgoto[yylhs]);
  }

  goto yynewstate;


/*--------------------------------------.
| yyerrlab -- here on detecting error.  |
`--------------------------------------*/
yyerrlab:
  /* Make sure we have latest lookahead translation.  See comments at
     user semantic actions for why this is necessary.  */
  yytoken = yychar == YYEMPTY ? YYEMPTY : YYTRANSLATE (yychar);

  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if ! YYERROR_VERBOSE
      yyerror (YY_("syntax error"));
#else
# define YYSYNTAX_ERROR yysyntax_error (&yymsg_alloc, &yymsg, \
                                        yyssp, yytoken)
      {
        char const *yymsgp = YY_("syntax error");
        int yysyntax_error_status;
        yysyntax_error_status = YYSYNTAX_ERROR;
        if (yysyntax_error_status == 0)
          yymsgp = yymsg;
        else if (yysyntax_error_status == 1)
          {
            if (yymsg != yymsgbuf)
              YYSTACK_FREE (yymsg);
            yymsg = (char *) YYSTACK_ALLOC (yymsg_alloc);
            if (!yymsg)
              {
                yymsg = yymsgbuf;
                yymsg_alloc = sizeof yymsgbuf;
                yysyntax_error_status = 2;
              }
            else
              {
                yysyntax_error_status = YYSYNTAX_ERROR;
                yymsgp = yymsg;
              }
          }
        yyerror (yymsgp);
        if (yysyntax_error_status == 2)
          goto yyexhaustedlab;
      }
# undef YYSYNTAX_ERROR
#endif
    }



  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
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

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:
  /* Pacify compilers when the user code never invokes YYERROR and the
     label yyerrorlab therefore never appears in user code.  */
  if (0)
    YYERROR;

  /* Do not reclaim the symbols of the rule whose action triggered
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
  yyerrstatus = 3;      /* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (!yypact_value_is_default (yyn))
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

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END


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


#if !defined yyoverflow || YYERROR_VERBOSE
/*-------------------------------------------------.
| yyexhaustedlab -- memory exhaustion comes here.  |
`-------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  /* Fall through.  */
#endif


/*-----------------------------------------------------.
| yyreturn -- parsing is finished, return the result.  |
`-----------------------------------------------------*/
yyreturn:
  if (yychar != YYEMPTY)
    {
      /* Make sure we have latest lookahead translation.  See comments at
         user semantic actions for why this is necessary.  */
      yytoken = YYTRANSLATE (yychar);
      yydestruct ("Cleanup: discarding lookahead",
                  yytoken, &yylval);
    }
  /* Do not reclaim the symbols of the rule whose action triggered
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
  return yyresult;
}
#line 1086 "cal.y" /* yacc.c:1918  */

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

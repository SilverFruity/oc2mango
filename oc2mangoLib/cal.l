/* 不需要yywrap */
%option noyywrap yylineno
%{
    #include <Foundation/Foundation.h>
    #include "y.tab.h"
    #import "MakeDeclare.h"
    #import "Log.h"
    unsigned long yycolumn = 1;
    unsigned long yylen = 0;
    char linebuf[500];
    #define YY_USER_ACTION yycolumn += yyleng; yylen = yyleng;

    // 自定义输入源
    // 替换宏定义 YY_INPUT DriveData->项目名/*/*.yy.c 修改文件输入流
    #undef YY_INPUT
    #define YY_INPUT(buf, result, max_size) (result = string_input(buf, result,max_size))
    #define TypeReturn(OMType) yylval.identifier =(__bridge_retained void *)[NSString stringWithFormat:@"%@",@#OMType]; return _##OMType;
    #define smaller(a, b) ((a) < (b) ? (a) : (b))
    #define larger(a, b) ((a) > (b) ? (a) : (b))
    char const *st_source_string;
    static unsigned long st_current_char_index;
    static unsigned long st_source_len;
    void yy_set_source_string(char const *source)
    {
        st_source_string = source;
        st_current_char_index = 0;
        st_source_len = strlen(source);
    }
    static int string_input(char *buf, int need_len,int max_size)
    {
        unsigned long len = st_source_len - st_current_char_index;
        if(len <= 0){
            return 0;
        }
        len = smaller(len, max_size);
        strncpy(buf, &st_source_string[st_current_char_index], len);
        st_current_char_index += len;
        return (int)len;
    }

%}

%start C_COMMENT CC_COMMENT STRING_LITERAL_STATE POUNDKEY
%%
<INITIAL>"#" { BEGIN POUNDKEY; }
<POUNDKEY>.* ;
<POUNDKEY>\n { BEGIN INITIAL; }

<INITIAL>"," { return COMMA ;}
<INITIAL>";" { return SEMICOLON; }
<INITIAL>"(" { return LP; }
<INITIAL>")" { return RP; }
<INITIAL>"[" { return LB; }
<INITIAL>"]" { return RB; }
<INITIAL>"{" { pushFuncSymbolTable(); return LC; }
<INITIAL>"}" { popFuncSymbolTable(); return RC; }
<INITIAL>"." { return DOT; }
<INITIAL>"->" { return POINT; }
<INITIAL>"@" { return AT; }
<INITIAL>"?" {return QUESTION; }
<INITIAL>":" { return COLON; }

<INITIAL>"==" {return EQ; }
<INITIAL>"!=" {return NE; }
<INITIAL>"<" {return LT; }
<INITIAL>"<=" {return LE; }
<INITIAL>">" {return GT; }
<INITIAL>">=" {return GE; }   
<INITIAL>"&&" {return LOGIC_AND; }
<INITIAL>"||" {return LOGIC_OR; }
<INITIAL>"!" {return  NOT; }
<INITIAL>"~" {return TILDE; }

<INITIAL>"<<" {return SHIFTLEFT; }
<INITIAL>">>" {return SHIFTRIGHT; }
<INITIAL>"&" {return AND; }
<INITIAL>"|" {return OR; }
<INITIAL>"^" {return POWER; }
<INITIAL>"-" {return SUB; }
<INITIAL>"+" {return ADD; }
<INITIAL>"/" {return DIV; }
<INITIAL>"*" {return ASTERISK; }
<INITIAL>"%" {return MOD; }

<INITIAL>"=" {return ASSIGN; }
<INITIAL>"&=" {return AND_ASSIGN; }
<INITIAL>"|=" {return OR_ASSIGN; }
<INITIAL>"^=" {return POWER_ASSIGN; }
<INITIAL>"-=" {return SUB_ASSIGN; }
<INITIAL>"+=" {return ADD_ASSIGN; }
<INITIAL>"/=" {return DIV_ASSIGN; }
<INITIAL>"*=" {return ASTERISK_ASSIGN; }
<INITIAL>"%=" {return MOD_ASSIGN; }

<INITIAL>"++" { return INCREMENT; }
<INITIAL>"--" { return DECREMENT; }

<INITIAL>"@interface" { return INTERFACE; }
<INITIAL>"@implementation" { return IMPLEMENTATION; }
<INITIAL>"@protocol" { return PROTOCOL; }
<INITIAL>"@end" { return END; }
<INITIAL>"@class" { return CLASS_DECLARE; }

<INITIAL>"@property" {  return PROPERTY; }
<INITIAL>"@dynamic" {  return DYNAMIC; }
<INITIAL>"weak" { yylval.identifier =(__bridge_retained void *)@"weak"; return WEAK; }
<INITIAL>"strong" { yylval.identifier =(__bridge_retained void *)@"strong"; return STRONG; }
<INITIAL>"copy" { yylval.identifier =(__bridge_retained void *)@"copy"; return COPY; }
<INITIAL>"assign" { yylval.identifier =(__bridge_retained void *)@"assign"; return ASSIGN_MEM; }
<INITIAL>"nonatomic" { yylval.identifier =(__bridge_retained void *)@"nonatomic"; return NONATOMIC; }
<INITIAL>"atomic" { yylval.identifier =(__bridge_retained void *)@"atomic"; return ATOMIC; }
<INITIAL>"readonly" { yylval.identifier =(__bridge_retained void *)@"readonly"; return READONLY; }
<INITIAL>"readwrite" { yylval.identifier =(__bridge_retained void *)@"readwrite"; return READWRITE; }
<INITIAL>"nonnull" { yylval.identifier =(__bridge_retained void *)@"nonnull"; return NONNULL; }
<INITIAL>"nullable" { yylval.identifier =(__bridge_retained void *)@"nullable"; return NULLABLE; }

<INITIAL>"extern" { yylval.identifier =(__bridge_retained void *)@"extern"; return EXTERN; }
<INITIAL>"static" { yylval.identifier =(__bridge_retained void *)@"static"; return STATIC; }
<INITIAL>"const" { yylval.identifier =(__bridge_retained void *)@"const"; return CONST; }
<INITIAL>"_Nonnull" { yylval.identifier =(__bridge_retained void *)@"_Nonnull"; return _NONNULL; }
<INITIAL>"_Nullable" { yylval.identifier =(__bridge_retained void *)@"_Nullable"; return _NULLABLE; }
<INITIAL>"__autoreleasing" { yylval.identifier =(__bridge_retained void *)@"__autoreleasing"; return _AUTORELEASE; }

<INITIAL>"__strong" { yylval.identifier =(__bridge_retained void *)@"__strong"; return _STRONG; }
<INITIAL>"__weak"  { yylval.identifier =(__bridge_retained void *)@"__weak"; return _WEAK; }
<INITIAL>"__block" { yylval.identifier =(__bridge_retained void *)@"__block"; return _BLOCK; }
<INITIAL>"__bridge" { yylval.identifier =(__bridge_retained void *)@"__bridge"; return _BRIDGE; }
<INITIAL>"__bridge_transfer" { yylval.identifier =(__bridge_retained void *)@"__bridge"; return _BRIDGE_TRANSFER; }
<INITIAL>"__bridge_retained" { yylval.identifier =(__bridge_retained void *)@"__bridge"; return _BRIDGE_RETAINED; }
<INITIAL>"__unused" { yylval.identifier =(__bridge_retained void *)@"__unused"; return _UNUSED; }

<INITIAL>"@required" ;
<INITIAL>"@optional" ;
<INITIAL>"@public" ;
<INITIAL>"@private" ;
<INITIAL>"@protected" ;

<INITIAL>"@selector\("[^()]*"\)" {yylval.identifier =(__bridge_retained void *)[NSString stringWithUTF8String:yytext];  return SELECTOR; }
<INITIAL>"SEL" { TypeReturn(SEL); }
<INITIAL>"Class" { TypeReturn(Class);}
<INITIAL>"BOOL" { TypeReturn(BOOL); }
<INITIAL>"void" { TypeReturn(void); }
<INITIAL>"id" { TypeReturn(id); }
<INITIAL>"instancetype" { TypeReturn(instancetype); }


<INITIAL>"return" { TypeReturn(return); }
<INITIAL>"for" { TypeReturn(for); }
<INITIAL>"in" { TypeReturn(in); }
<INITIAL>"break" { TypeReturn(break); }
<INITIAL>"continue" { TypeReturn(continue); }
<INITIAL>"goto" { TypeReturn(goto); }
<INITIAL>"if" { return IF; }
<INITIAL>"else" { TypeReturn(else); }
<INITIAL>"do" { TypeReturn(do); }
<INITIAL>"while" { TypeReturn(while); }
<INITIAL>"switch" { TypeReturn(switch); }
<INITIAL>"case" { TypeReturn(case); }
<INITIAL>"default" { TypeReturn(default); }
<INITIAL>"typedef" { return TYPEDEF;}

<INITIAL>"self" { TypeReturn(self); }
<INITIAL>"super" { TypeReturn(super); }
<INITIAL>"nil" { TypeReturn(nil); }
<INITIAL>"NULL" { TypeReturn(NULL); }
<INITIAL>"YES" { TypeReturn(YES); }
<INITIAL>"NO" { TypeReturn(NO); }

<INITIAL>"unsigned char" { TypeReturn(UCHAR); }
<INITIAL>"unsigned short" { TypeReturn(USHORT); }
<INITIAL>"unsigned int" { TypeReturn(UINT); }
<INITIAL>"unsigned long" { TypeReturn(ULONG); }
<INITIAL>"unsigned long long" { TypeReturn(ULLONG); }
<INITIAL>"NSUInteger" { TypeReturn(ULONG); }

<INITIAL>"sizeof" { TypeReturn(sizeof); }
<INITIAL>"typeof" { return TYPEOF; }
<INITIAL>"__typeof__" { return __TYPEOF; }
<INITIAL>"enum" { TypeReturn(enum); }
<INITIAL>"struct" { TypeReturn(struct); }
<INITIAL>"char" { TypeReturn(CHAR); }
<INITIAL>"short" { TypeReturn(SHORT); }
<INITIAL>"int" { TypeReturn(INT); }
<INITIAL>"long" { TypeReturn(LONG); }
<INITIAL>"long long" { TypeReturn(LLONG); }
<INITIAL>"NSInteger" { TypeReturn(LONG); }

<INITIAL>"int8_t" { TypeReturn(CHAR); }
<INITIAL>"int16_t" { TypeReturn(SHORT); }
<INITIAL>"int32_t" { TypeReturn(INT); }
<INITIAL>"int64_t" { TypeReturn(LLONG); }

<INITIAL>"uint8" { TypeReturn(UCHAR); }
<INITIAL>"uint16" { TypeReturn(USHORT); }
<INITIAL>"uint32" { TypeReturn(UINT); }
<INITIAL>"uint64" { TypeReturn(ULLONG); }
<INITIAL>"uint8_t" { TypeReturn(UCHAR); }
<INITIAL>"uint16_t" { TypeReturn(USHORT); }
<INITIAL>"uint32_t" { TypeReturn(UINT); }
<INITIAL>"uint64_t" { TypeReturn(ULLONG); }

<INITIAL>"size_t" { TypeReturn(UINT); }

<INITIAL>"NSTimeInterval" {return _DOUBLE; }
<INITIAL>"double" { TypeReturn(DOUBLE); }
<INITIAL>"float" { TypeReturn(FLOAT); }
<INITIAL>"CGFloat" { return _DOUBLE; }

<INITIAL>__attribute__[ ]*\(.*?\){2,} ;
<INITIAL>__attribute__[ ]*\(.*?\){2,} ;


<INITIAL>[A-Za-z_$][A-Za-z_$0-9]* {
    NSString *name = [NSString stringWithUTF8String:yytext];
    yylval.identifier =(__bridge_retained void *)name;

    Symbol *symbol = lookupSymbol(name);
    if (symbol){
        if (symbol.kind == SymbolKindTypeDeclare || symbol.kind == SymbolKindTypeDef){
            return TYPE;
        }else if(symbol.kind == SymbolKindVariable){
            return VARIABLE;
        }
    }
    if([name hasPrefix:@"NS"]
    || [name hasPrefix:@"UI"]
    || [name hasPrefix:@"CG"]
    || [name hasPrefix:@"CA"]
    || [name hasSuffix:@"Ref"]
    || [name hasPrefix:@"dispatch"]
    )
    {
        return TYPE;
    }

    return IDENTIFIER;
}

<INITIAL>[1-9][0-9]* { 
    yylval.identifier =(__bridge_retained void *)[NSString stringWithUTF8String:yytext];    
    return INTETER_LITERAL; 
}



<INITIAL>"0"[xX][0-9a-fA-F]+ { 
    yylval.identifier =(__bridge_retained void *)[NSString stringWithUTF8String:yytext];
    return INTETER_LITERAL; 
}


<INITIAL>"0" { 
    yylval.identifier =(__bridge_retained void *)[NSString stringWithUTF8String:yytext];
    return INTETER_LITERAL; 
}


<INITIAL>[0-9]+\.[0-9]+ { 
    yylval.identifier =(__bridge_retained void *)[NSString stringWithUTF8String:yytext];
    return DOUBLE_LITERAL; 
}


<INITIAL>\" {
BEGIN STRING_LITERAL_STATE;
}

<INITIAL>[\t] ;
<INITIAL>[\n] { yycolumn = 1; };

<INITIAL>"/*" {  BEGIN C_COMMENT; }
<INITIAL>"//" {  BEGIN CC_COMMENT; }
<INITIAL>. ;

<C_COMMENT>\n { yycolumn = 1; };
<C_COMMENT>. ;
<C_COMMENT>"*/"    { BEGIN INITIAL; }
<C_COMMENT><<EOF>>   ;

<CC_COMMENT>.    ;
<CC_COMMENT>\n    {
    yycolumn = 1;
    BEGIN INITIAL;
}
<CC_COMMENT><<EOF>> { BEGIN INITIAL; }


<STRING_LITERAL_STATE>\" {
    BEGIN  INITIAL;
    yylval.identifier = (__bridge_retained void *)getString();
    return STRING_LITERAL;
}

<STRING_LITERAL_STATE>. { appendCharacter(yytext[0]); };


<STRING_LITERAL_STATE>\\\"  { appendCharacter('\"'); }
<STRING_LITERAL_STATE>\\n	{ appendCharacter('\n'); }
<STRING_LITERAL_STATE>\\t	{ appendCharacter('\t'); }
<STRING_LITERAL_STATE>\\\\	{ appendCharacter('\\'); }
<STRING_LITERAL_STATE>[\x81-\x9f\xe0-\xef][\x40-\x7e\x80-\xfc] {
	appendCharacter(yytext[0]);
	appendCharacter(yytext[1]);
}

<INITIAL>\n.* {
    strncpy(linebuf,yytext + 1,sizeof(linebuf));
    yyless(1);
}
%%

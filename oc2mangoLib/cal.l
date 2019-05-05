%{
    #include <Foundation/Foundation.h>
    #include "y.tab.h"
    
    int yywrap(){
        return 1;
    }
    
    // 自定义输入源
    // 替换宏定义 YY_INPUT DriveData->项目名/*/*.yy.c 修改文件输入流
    #undef YY_INPUT
    #define YY_INPUT(buf, result, max_size) (result = string_input(buf, max_size))
    #define TypeReturn(Type) yylval.identifier =(__bridge_retained void *)[NSString stringWithFormat:@"%@",@#Type]; return _##Type;
    #define smaller(a, b) ((a) < (b) ? (a) : (b))
    #define larger(a, b) ((a) > (b) ? (a) : (b))
    static char const *st_source_string;
    static unsigned long st_current_char_index;
    static unsigned long st_source_len;
    void yy_set_source_string(char const *source)
    {
        st_source_string = source;
        st_current_char_index = 0;
        st_source_len = strlen(source);
    }
    static int string_input(char *buf, int max_size)
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
%start C_COMMENT CC_COMMENT STRING_LITERAL_STATE
%%


<INITIAL>"," { return COMMA ;}
<INITIAL>";" { return SEMICOLON; }
<INITIAL>"(" { return LP; }
<INITIAL>")" { return RP; }
<INITIAL>"[" { return LB; }
<INITIAL>"]" { return RB; }
<INITIAL>"{" { return LC; }
<INITIAL>"}" { return RC; }
<INITIAL>"." { return DOT; }
<INITIAL>"@" { return AT; }
<INITIAL>"#" {return PS; }

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
<INITIAL>"!" {return  LOGIC_NOT; }

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


<INITIAL>"if" { return IF; }
<INITIAL>"endif" { return ENDIF; }
<INITIAL>"ifdef" { return IFDEF; }
<INITIAL>"ifndef" { return IFNDEF; }
<INITIAL>"undef" { return UNDEF; }
<INITIAL>"include" { return INCLUDE; }
<INITIAL>"import" { return IMPORT; }

<INITIAL>"@interface" { return INTERFACE; }
<INITIAL>"@implementation" { return IMPLEMENTATION; }
<INITIAL>"@protocol" { return PROTOCOL; }
<INITIAL>"@end" { return END; }
<INITIAL>"@class" { return CLASS_DECLARE; }

<INITIAL>"@property" {  return PROPERTY; }
<INITIAL>"weak" { yylval.identifier =(__bridge_retained void *)@"weak"; return WEAK; }
<INITIAL>"strong" { yylval.identifier =(__bridge_retained void *)@"strong"; return STRONG; }
<INITIAL>"copy" { yylval.identifier =(__bridge_retained void *)@"copy"; return COPY; }
<INITIAL>"assign" { yylval.identifier =(__bridge_retained void *)@"assign"; return ASSIGN_MEM; }
<INITIAL>"nonatomic" { yylval.identifier =(__bridge_retained void *)@"nonatomic"; return NONATOMIC; }
<INITIAL>"atomic" { yylval.identifier =(__bridge_retained void *)@"atomic"; return ATOMIC; }
<INITIAL>"readonly" { yylval.identifier =(__bridge_retained void *)@"readonly"; return READONLY; }
<INITIAL>"readwrite" { yylval.identifier =(__bridge_retained void *)@"readwrite"; return READWRITE; }

<INITIAL>"@selector" {return SELECTOR; }

<INITIAL>"SEL" { TypeReturn(SEL); }
<INITIAL>"Class" { TypeReturn(Class);}
<INITIAL>"BOOL" { TypeReturn(BOOL); }
<INITIAL>"void" { TypeReturn(void); }
<INITIAL>"id" { TypeReturn(id); }

<INITIAL>"return" { TypeReturn(return); }
<INITIAL>"for" { TypeReturn(for); }
<INITIAL>"in" { TypeReturn(in); }
<INITIAL>"break" { TypeReturn(break); }
<INITIAL>"continue" { TypeReturn(continue); }
<INITIAL>"goto" { TypeReturn(goto); }
<INITIAL>"else" { TypeReturn(else); }
<INITIAL>"do" { TypeReturn(do); }
<INITIAL>"while" { TypeReturn(while); }
<INITIAL>"switch" { TypeReturn(switch); }
<INITIAL>"case" { TypeReturn(case); }
<INITIAL>"default" { TypeReturn(default); }


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

<INITIAL>[A-Za-z_$][A-Za-z_$0-9]* {
    yylval.identifier =(__bridge_retained void *)[NSString stringWithUTF8String:yytext];
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
<INITIAL>[\n] ;

<INITIAL>"/*" {    BEGIN C_COMMENT; }
<INITIAL>"//" { BEGIN CC_COMMENT; }
<INITIAL>. ;

<C_COMMENT>\n;
<C_COMMENT>. ;
<C_COMMENT>"*/"    { BEGIN INITIAL; }
<C_COMMENT><<EOF>>   ;

<CC_COMMENT>.    ;
<CC_COMMENT>\n    {
    BEGIN INITIAL;
}
<CC_COMMENT><<EOF>> { BEGIN INITIAL; }


<STRING_LITERAL_STATE>\" {
    yylval.identifier = (void *)yytext;
    BEGIN  INITIAL;
    return STRING_LITERAL;
}

<STRING_LITERAL_STATE>. ;


<STRING_LITERAL_STATE>\\\";
<STRING_LITERAL_STATE>\\n;
<STRING_LITERAL_STATE>\\t;
<STRING_LITERAL_STATE>\\\\;
<STRING_LITERAL_STATE>[\x81-\x9f\xe0-\xef][\x40-\x7e\x80-\xfc];
%%

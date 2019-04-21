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
<INITIAL>"-" {return SUB; }
<INITIAL>"+" {return ADD; }
<INITIAL>":" { return COLON; }
<INITIAL>"^" { return POWER; }
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
<INITIAL>"=" { return ASSIGN; }
<INITIAL>"<" {return LT; }
<INITIAL>">" {return GT; }
<INITIAL>"/" {return DIV; }
<INITIAL>"#" {return PS; }

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

<INITIAL>"@property" {return PROPERTY; }
<INITIAL>"weak" {return WEAK; }
<INITIAL>"strong" {return STRONG; }
<INITIAL>"copy" {return COPY; }
<INITIAL>"assign" {return ASSIGN_MEM; }
<INITIAL>"nonatomic" {return NONATOMIC; }
<INITIAL>"atomic" {return ATOMIC; }

<INITIAL>"@selector" {return SELECTOR; }

<INITIAL>"SEL" { TypeReturn(SEL); }
<INITIAL>"Class" { TypeReturn(Class);}
<INITIAL>"BOOL" { TypeReturn(BOOL); }
<INITIAL>"void" { TypeReturn(void); }
<INITIAL>"id" { TypeReturn(id); }

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

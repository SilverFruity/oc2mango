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

<INITIAL>"#if" { return _IF; }
<INITIAL>"#endif" { return _ENDIF; }
<INITIAL>"#ifdef" { return _IFDEF; }
<INITIAL>"#ifndef" { return _IFNDEF; }
<INITIAL>"#undef" { return _UNDEF; }
<INITIAL>"#include" { return _INCLUDE; }

<INITIAL>"#import" { return _IMPORT; }

<INITIAL>"@interface" { return INTERFACE; }
<INITIAL>"@implementation" { return IMPLEMENTATION; }
<INITIAL>"@protocol" { return PROTOCOL; }
<INITIAL>"@end" { return END; }
<INITIAL>"@class" { return CLASS_DECLARE; }

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

<INITIAL>"unsigned char" { return UINT; }
<INITIAL>"unsigned short" { return UINT; }
<INITIAL>"unsigned int" { return UINT; }
<INITIAL>"unsigned long" { return UINT; }
<INITIAL>"unsigned long long" { return UINT; }
<INITIAL>"NSUInteger" { return UINT; }

<INITIAL>"char" { return INT; }
<INITIAL>"short" { return INT; }
<INITIAL>"int" { return INT; }
<INITIAL>"long" { return INT; }
<INITIAL>"long long" { return INT; }
<INITIAL>"NSInteger" { return INT; }

<INITIAL>"double" { return DOUBLE; }
<INITIAL>"float" { return DOUBLE; }
<INITIAL>"CGFloat" { return DOUBLE; }

<INITIAL>[A-Za-z_$][A-Za-z_$0-9]* {
    yylval.identifier = (void *)yytext;
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

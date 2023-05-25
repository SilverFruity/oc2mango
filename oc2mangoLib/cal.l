/* 不需要yywrap */
%option noyywrap yylineno
%{
    #include <Foundation/Foundation.h>
    #include "y.tab.h"
    #import "MakeDeclare.h"
    #import "Log.h"
    unsigned long yycolumn = 0;
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
    static unsigned long protocol_left;
    static unsigned long protocol_right;
    bool is_variable = false;
    void yy_set_source_string(char const *source)
    {
        yylineno = 0;
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

%start C_COMMENT CC_COMMENT STRING_LITERAL_STATE POUNDKEY CHILD_COLLECTION_STATE POINT_STATE PROTOCOL_CHECK POINT_CHECK ASSING_POINT_CHECK
%%
<INITIAL>"#" { BEGIN POUNDKEY; }
<POUNDKEY>.* ;
<POUNDKEY>\n { BEGIN INITIAL; }
<INITIAL>"NS_ASSUME_NONNULL_BEGIN" ;
<INITIAL>"NS_ASSUME_NONNULL_END" ;
<INITIAL>"," { is_variable = false; return COMMA ;}
<INITIAL>";" { is_variable = false; return SEMICOLON; }
<INITIAL>"(" { is_variable = false; return LP; }
<INITIAL>")" { is_variable = false; return RP; }
<INITIAL>"[" { is_variable = false; return LB; }
<INITIAL>"]" { is_variable = false; return RB; }
<INITIAL>"{" { is_variable = false; return LC; }
<INITIAL>"}" { is_variable = false; return RC; }
<INITIAL>"." { return DOT; }
<INITIAL>"->" { return ARROW; }
<INITIAL>"@" { return AT; }
<INITIAL>"?" {return QUESTION; }
<INITIAL>":" { return COLON; }

<INITIAL>"==" {return EQ; }
<INITIAL>"!=" {return NE; }

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
<INITIAL>"^" {is_variable = false; return POWER; }
<INITIAL>"-" {return SUB; }
<INITIAL>"+" {return ADD; }
<INITIAL>"/" {return DIV; }
<INITIAL>"%" {return MOD; }

<INITIAL>"=" { return ASSIGN; }
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
<INITIAL>"nonnull" { yylval.identifier =(__bridge_retained void *)@"nonnull"; return NONNULL; }
<INITIAL>"nullable" { yylval.identifier =(__bridge_retained void *)@"nullable"; return NULLABLE; }


<INITIAL>"UI_APPEARANCE_SELECTOR" ;
<INITIAL>"IBInspectable" ;
<INITIAL>"extern" ;
<INITIAL>"static" return STATIC;
<INITIAL>"const" ;
<INITIAL>"_Nonnull" ;
<INITIAL>"_Nullable" ;
<INITIAL>"__autoreleasing" ;

<INITIAL>"__strong" return _STRONG;
<INITIAL>"__weak"  return _WEAK;
<INITIAL>"__block" ;
<INITIAL>"__bridge" ;
<INITIAL>"__bridge_transfer" ;
<INITIAL>"__bridge_retained" ;
<INITIAL>"__unused" ;
<INITIAL>"__kindof" ;

<INITIAL>"@required" ;
<INITIAL>"@optional" ;
<INITIAL>"@public" ;
<INITIAL>"@private" ;
<INITIAL>"@protected" ;

<INITIAL>"@selector\("[^()]*"\)" {yylval.identifier =(__bridge_retained void *)[NSString stringWithUTF8String:yytext];  return SELECTOR; }
<INITIAL>"SEL" { TypeReturn(SEL); }
<INITIAL>"Class" { TypeReturn(Class);}
<INITIAL>"BOOL" { TypeReturn(BOOL); }
<INITIAL>"bool" { TypeReturn(BOOL); }
<INITIAL>"void" { TypeReturn(void); }
<INITIAL>"instancetype" { TypeReturn(instancetype); }
<INITIAL>"IBOutlet" ;
<INITIAL>"IBAction" { TypeReturn(void); }

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
<INITIAL>"struct" { TypeReturn(struct); }
<INITIAL>"union" { TypeReturn(union); }
<INITIAL>"enum" { TypeReturn(enum); }
<INITIAL>"NS_ENUM" { return NS_ENUM; }
<INITIAL>"NS_OPTIONS" { return NS_OPTIONS; }


<INITIAL>"self" { is_variable = true; TypeReturn(self); }
<INITIAL>"super" {is_variable = true; TypeReturn(super); }
<INITIAL>"nil" { is_variable = true; TypeReturn(nil); }
<INITIAL>"NULL" { is_variable = true; TypeReturn(NULL); }
<INITIAL>"YES" { is_variable = true; TypeReturn(YES); }
<INITIAL>"NO" { is_variable = true; TypeReturn(NO); }

<INITIAL>"unsigned char" { TypeReturn(UCHAR); }
<INITIAL>"unsigned short" { TypeReturn(USHORT); }
<INITIAL>"unsigned int" { TypeReturn(UINT); }
<INITIAL>"unsigned long" { TypeReturn(ULONG); }
<INITIAL>"unsigned long long" { TypeReturn(ULLONG); }
<INITIAL>"NSUInteger" { TypeReturn(ULLONG); }

<INITIAL>"sizeof" { is_variable = true; TypeReturn(sizeof); }
<INITIAL>"typeof" { return TYPEOF; }
<INITIAL>"__typeof__" { return TYPEOF; }
<INITIAL>"__typeof" { return TYPEOF; }

<INITIAL>"char" { TypeReturn(CHAR); }
<INITIAL>"id" { TypeReturn(id); }
<INITIAL>"..."  {return ELLIPSIS;}
<INITIAL>"short" { TypeReturn(SHORT); }
<INITIAL>"int" { TypeReturn(INT); }
<INITIAL>"long" { TypeReturn(LONG); }
<INITIAL>"long long" { TypeReturn(LLONG); }
<INITIAL>"NSInteger" { TypeReturn(LLONG); }

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
    return IDENTIFIER;
}

<INITIAL>[1-9][0-9]* {
    is_variable = true;
    yylval.identifier =(__bridge_retained void *)[NSString stringWithUTF8String:yytext];    
    return INTETER_LITERAL; 
}
<INITIAL>'.' {
    is_variable = true;
    char value = *(char *)(yytext + 1);
    yylval.identifier =(__bridge_retained void *)@(value).stringValue;
    return INTETER_LITERAL;
}
<INITIAL>"0"[xX][0-9a-fA-F]+ {
    is_variable = true;
    yylval.identifier =(__bridge_retained void *)[NSString stringWithUTF8String:yytext];
    return INTETER_LITERAL; 
}


<INITIAL>"0" {
    is_variable = true;
    yylval.identifier =(__bridge_retained void *)[NSString stringWithUTF8String:yytext];
    return INTETER_LITERAL; 
}


<INITIAL>[0-9]+\.[0-9]+ {
    is_variable = true;
    yylval.identifier =(__bridge_retained void *)[NSString stringWithUTF8String:yytext];
    return DOUBLE_LITERAL; 
}
<INITIAL>[0-9]+\.[0-9]+f {
    is_variable = true;
    NSString *string = [NSString stringWithUTF8String:yytext];
    string = [string substringWithRange:NSMakeRange(0, [string length] - 1)];
    yylval.identifier =(__bridge_retained void *)string;
    return DOUBLE_LITERAL;
}

<INITIAL>"<" {
    return LT;
}
<INITIAL><[A-Za-z_$][A-Za-z_$0-9]*[ ]*\**[ ]*[,<>] {
    yyless(0);
    BEGIN PROTOCOL_CHECK;
}
<PROTOCOL_CHECK>[A-Za-z_$][A-Za-z_$0-9]* {
    stringBufferAppendString(yytext);
};
<PROTOCOL_CHECK>"*" ;
<PROTOCOL_CHECK>"," {
    stringBufferAppendCharacter(yytext[0]);
};
<PROTOCOL_CHECK>" " ;
<PROTOCOL_CHECK>"<" {
    protocol_left += 1;
    startStringBuffer();
}
<PROTOCOL_CHECK>">" {
    protocol_right += 1;
    if (protocol_left == protocol_right){
        protocol_left = 0;
        protocol_right = 0;
        NSString *string = [NSString stringWithUTF8String:endStringBuffer()];
        yylval.identifier = (__bridge_retained void *)string;
        BEGIN INITIAL;
        return CHILD_COLLECTION;
    }
}
<INITIAL>"*" {
    if (is_variable == true) {
        is_variable = false;
        return ASTERISK;
    }
    is_variable = false;
    return POINT;
}

<INITIAL>\" {
startStringBuffer();
BEGIN STRING_LITERAL_STATE;
}

<INITIAL>[\t] ;
<INITIAL>[\n] ;

<INITIAL>"/*" {  BEGIN C_COMMENT; }
<INITIAL>"//" {  BEGIN CC_COMMENT; }
<INITIAL>. ;

<C_COMMENT>\n;
<C_COMMENT>. ;
<C_COMMENT>"*/"    { yycolumn = 0; BEGIN INITIAL; }
<C_COMMENT><<EOF>>   ;

<CC_COMMENT>.    ;
<CC_COMMENT>\n     { yycolumn = 0; BEGIN INITIAL; }
<CC_COMMENT><<EOF>> { BEGIN INITIAL; }


<STRING_LITERAL_STATE>\" {
    BEGIN  INITIAL;
    is_variable = true;
    NSString *string = [NSString stringWithUTF8String:endStringBuffer()];
    yylval.identifier = (__bridge_retained void *)string;
    return STRING_LITERAL;
}

<STRING_LITERAL_STATE>. { stringBufferAppendCharacter(yytext[0]); };


<STRING_LITERAL_STATE>\\\"  { stringBufferAppendCharacter('\"'); }
<STRING_LITERAL_STATE>\\n	{ stringBufferAppendCharacter('\n'); }
<STRING_LITERAL_STATE>\\t	{ stringBufferAppendCharacter('\t'); }
<STRING_LITERAL_STATE>\\\\	{ stringBufferAppendCharacter('\\'); }

<INITIAL>\n.* {
    strncpy(linebuf,yytext + 1,sizeof(linebuf));
    if(strlen(linebuf) > 0) yycolumn = 0;
    yyless(1);
}
%%

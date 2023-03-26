#ifndef _yy_defines_h_
#define _yy_defines_h_

#define INTEGER 257
#define UMINUS 258
#ifdef YYSTYPE
#undef  YYSTYPE_IS_DECLARED
#define YYSTYPE_IS_DECLARED 1
#endif
#ifndef YYSTYPE_IS_DECLARED
#define YYSTYPE_IS_DECLARED 1
typedef union YYSTYPE {
    int ival;
} YYSTYPE;
#endif /* !YYSTYPE_IS_DECLARED */
extern YYSTYPE yylval;

#endif /* _yy_defines_h_ */

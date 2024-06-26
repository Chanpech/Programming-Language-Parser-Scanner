/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

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

#ifndef YY_CMINUS_CMINUSPARSER_H_INCLUDED
# define YY_CMINUS_CMINUSPARSER_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int Cminus_debug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    AND = 258,
    ELSE = 259,
    EXIT = 260,
    FLOAT = 261,
    FOR = 262,
    IF = 263,
    INTEGER = 264,
    NOT = 265,
    OR = 266,
    READ = 267,
    WHILE = 268,
    WRITE = 269,
    LBRACE = 270,
    RBRACE = 271,
    LE = 272,
    LT = 273,
    GE = 274,
    GT = 275,
    EQ = 276,
    NE = 277,
    ASSIGN = 278,
    COMMA = 279,
    SEMICOLON = 280,
    LBRACKET = 281,
    RBRACKET = 282,
    LPAREN = 283,
    RPAREN = 284,
    PLUS = 285,
    TIMES = 286,
    IDENTIFIER = 287,
    DIVIDE = 288,
    RETURN = 289,
    STRING = 290,
    INTCON = 291,
    FLOATCON = 292,
    MINUS = 293,
    DIVDE = 294
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 96 "CminusParser.y" /* yacc.c:1909  */

	char*	name;
	int     symIndex;
	DList	idList;
	int 	offset;
	//Added 
	int 	label;

#line 103 "CminusParser.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE Cminus_lval;

int Cminus_parse (void);

#endif /* !YY_CMINUS_CMINUSPARSER_H_INCLUDED  */

/*
* Parser para uma calculadora avancada
*/

%{
#include <stdio.h>
#include <stdlib.h>
#include "bison-calc.h"
%}

%union {
    struct ast *a;
    double d;
    struct symbol *s; /* qual simbolo? */
    struct symlist *sl;
    int fn; /* qual funcao? */
}

/* declaracao de tokens */
%token <d> NUMBER
%token <s> NAME
%token <fn> FUNC

%token EOL
%token IF THEN ELSE WHILE DO LET FOR
%token AND OR 

%right '='
%left AND OR
%nonassoc <fn> CMP
%left '+' '-'
%left '*' '/'

%type <a> exp stmt list explist command
%type <sl> symlist

%start calclist
%%

stmt:       LET NAME '=' exp { $$ = newasgn($2, $4); } /* Atribuição 'let' retorna um valor */
        |   LET NAME '(' symlist ')' '=' list { dodef($2, $4, $7); $$ = NULL; } /* Definição de função não retorna valor */
        |   IF exp THEN list { $$ = newflow('I', $2, $4, NULL); }
        |   IF exp THEN list ELSE list { $$ = newflow('I', $2, $4, $6); }
        |   WHILE exp DO list { $$ = newflow('W', $2, $4, NULL); }
        |   FOR '(' exp ';' exp ';' exp ')' list {
                struct ast *body = newast('L', $9, $7);
                struct ast *while_loop = newflow('W', $5, body, NULL);
                $$ = newast('L', $3, while_loop);
            }
        |   exp  /* Um comando pode ser uma expressão como '5+5;' ou 'variavel;' */
        ;

list:       /* vazio! */ {$$ = NULL; }
        |   stmt ';' list { if ($3==NULL) 
                        $$=$1; 
                else 
                        $$ = newast('L', $1, $3); }
        ;

exp:        exp CMP exp { $$ = newcmp($2, $1, $3); }
        |   exp '+' exp { $$ = newast('+', $1, $3); }
        |   exp '-' exp { $$ = newast('-', $1, $3); }
        |   exp '*' exp { $$ = newast('*', $1, $3); }
        |   exp '/' exp { $$ = newast('/', $1, $3); }
        |   exp AND exp { $$ = newast('&', $1, $3); }
        |   exp OR exp  { $$ = newast('|', $1, $3); }
        |   '(' exp ')' { $$ = $2; }
        |   NUMBER { $$ = newnum($1); }
        |   NAME { $$ = newref($1); }
        |   FUNC '(' explist ')' { $$ = newfunc($1, $3); }
        |   NAME '(' explist ')' { $$ = newcall($1, $3); }
        ;

explist:    exp
        |   exp ',' explist { $$ = newast('L', $1, $3); }
        ;

symlist:    NAME { $$ = newsymlist($1, NULL); }
        |   NAME ',' symlist { $$ = newsymlist($1, $3); }
        ;

calclist:   /* vazio! */
        |   calclist command EOL   { if($2) { printf(">= %.4g\n", eval($2)); treefree($2); } }
        |   calclist error EOL  { yyerrok; printf(">"); }
        ;

command:    stmt          { $$ = $1; } /* Um comando pode ser um stmt simples */
        |   stmt ';'      { $$ = $1; } /* Ou um stmt seguido por ';' */
        ;
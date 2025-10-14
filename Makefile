bison-calc: bison-calc.l bison-calc.y bison-calc.h
			bison -d -t -v bison-calc.y
			flex -o bison-calc.lex.c bison-calc.l
			gcc -o $@ bison-calc.tab.c bison-calc.lex.c bison-calc-func.c -lm
			@echo Parser da Calculadora com Cmds, funcoes, ... estah pronto!

clean:
			rm -f bison-calc.tab.c bison-calc.tab.h bison-calc.lex.c bison-calc bison-calc.output
			@echo Limpeza concluida!

clean-outputs:
			rm -f saidas/*.txt
			@echo Limpeza dos outputs concluida!


clean-all: clean clean-outputs
			@echo Limpeza total concluida!


t01:
		./bison-calc ./entradas/t01.txt ./saidas/t01.txt
		@echo Teste 1: Aritmética Básica

t02:
		./bison-calc ./entradas/t02.txt ./saidas/t02.txt
		@echo Teste 2: Atribuição e uso de variáveis

t03:
		./bison-calc ./entradas/t03.txt ./saidas/t03.txt
		@echo Teste 3 — Estruturas condicionais

t04:
		./bison-calc ./entradas/t04.txt ./saidas/t04.txt
		@echo Teste 4 — Laços de repetição

t05:
		./bison-calc ./entradas/t05.txt ./saidas/t05.txt
		@echo Teste 5 — Definição e chamada de funções

t06:
		./bison-calc ./entradas/t06.txt ./saidas/t06.txt
		@echo Teste 6 — Funções matemáticas internas e lógicas

e01:
		./bison-calc ./entradas/e01.txt ./saidas/e01.txt
		@echo Erro 1 — Símbolo desconhecido

e02:
		./bison-calc ./entradas/e02.txt ./saidas/e02.txt
		@echo Erro 2 — Parênteses desbalanceados

e03:
		./bison-calc ./entradas/e03.txt ./saidas/e03.txt
		@echo Erro 3 — Variável não declarada

e04:
		./bison-calc ./entradas/e04.txt ./saidas/e04.txt
		@echo Erro 4 — Chamada incorreta de função definida pelo usuário
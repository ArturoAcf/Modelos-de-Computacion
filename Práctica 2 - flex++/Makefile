COMP = g++
FLEX = flex++

Inventario: lex.yy.cc
	$(COMP) lex.yy.cc -o Inventario

lex.yy.cc: Inventario.l
	$(FLEX) Inventario.l

clean:
	rm -f Inventario lex.yy.cc

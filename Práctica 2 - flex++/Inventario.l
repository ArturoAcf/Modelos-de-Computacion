%option noyywrap

	/*----Sección de declaraciones----*/

%{
#include <iostream>
#include <fstream>
#include <cstring>

using namespace std;

ifstream  f;

const float poderSupport=0.0;

bool 				esArma=false,
		 				esSupport=false,
						noUtil=false;

int 				contArmasPosibles=0,
						contSupport=0,
						contLeyendas=0,
						contTotal,
						contObjetos=0,
						contNoUtiles=0,
						contFuertes=0,
						umbralPoder;

float				poder;

string   	 	nom,
					 	tip;

%}

nombre					[a-zA-Z]*
tipo						" "[a-zA-Z]*
leyenda					[a-zA-Z]*"(L)"
power       		" "[0-9]+"."[0-9]*
umbral					[0-9]*

%%

	/*----Sección de reglas----*/

{umbral}	{
	umbralPoder=atof(yytext);
	cout<<"Umbral de poder de la misión: "<<umbralPoder<<endl;
	cout<<"\nInventario:"<<endl<<endl;
}

{nombre}	{
	nom+=yytext;
	cout<<nom;
	nom="";
}

{tipo}	{
	tip+=yytext;
}

{leyenda}	{
	nom+=yytext;
	cout<<nom;
	nom="";
	cout<<"\nSe trata de un arma de categoría legendaria, solo podrás llevar una a la vez"<<endl<<endl;
	contLeyendas++;
}

{power} {
	poder=atof(yytext);
	cout<<" - Poder-> "<<poder;

	esSupport=false;
	esArma=false;

	if(poder>=umbralPoder){
		esArma=true;
		contFuertes++;
	}else if(poder==poderSupport){
		esSupport=true;
		contSupport++;
	}else{
		noUtil=true;
		contNoUtiles++;
	}

	if(esArma){
		cout<<"\nEste objeto es de tipo"<<tip<<" y supera el umbral de poder para ser utilizada"<<endl<<endl;
	}else if(esSupport){
		cout<<"\nEste objeto es de apoyo, de tipo"<<tip<<", siempre puede utilizarse"<<endl<<endl;
	}else if(noUtil){
		cout<<"\nEste objeto es un arma de tipo"<<tip<<", pero no supera el umbral de poder de la misión"<<endl<<endl;
	}

	tip="";
	poder=0.0;
}

\n	{
	contObjetos++;
}

%%

	/*----Sección de procedimientos----*/

int main(int argc, char *argv[]){
	if(argc==2){
		f.open(argv[1]);
	}else{
		cout<<"Fromato -> ./Inventario 'nombreFichero'"<<endl;
		exit(1);
	}

	yyFlexLexer flujo(&f, 0);
	flujo.yylex();

	contTotal=contFuertes+contSupport;

	if(contLeyendas!=0){
		contTotal=contTotal+1;
	}

	contObjetos=contObjetos-1; // Ya que la primera línea corresponde al umbral.

	cout<<"\nNúmero total de objetos en el inventario: "<<contObjetos<<endl;
	cout<<"Objetos no permitidos para la misión final: "<<contNoUtiles<<endl;
	cout<<"Total de armas que superan el umbral: "<<contFuertes<<endl;
	cout<<"Total de objetos de ayuda o support: "<<contSupport<<endl;
	cout<<"Total de Armas legendarias (solo se puede portar una): "<<contLeyendas<<endl;
	cout<<"Total de objetos aptos para la misión final: "<<contTotal<<endl;

	return 0;
}

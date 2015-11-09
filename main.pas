{ @author: Lara Carrión }

program Sudoku;

        USES crt;

        TYPE

          TIndice = 1..9;
          TValorJuego = 0..9;
          TValorSolucion = 1..9;
          TDim = 1..3;
          tIndiceRegion = 1..3;
          {-----------------------}
          TTableroJuego = array [TIndice,TIndice] of TValorJuego;
          TTableroSolucion= array [TIndice,Tindice] of TValorSolucion;
          TTableroInicial = array [Tindice,TIndice] of boolean;
          {-----------------------}
          TConjunto = SET of tValorJuego;
          TEscaneo = array [TIndice] of TConjunto;
          TEscaneoReg = array [TDim, TDim] of TConjunto;
          {------------------------}

        VAR

         opcion: integer;
         tabJuego: ttablerojuego;
         tabIni:TTableroInicial;
         tabSol:ttablerosolucion;
         f,c: tindice;
         a,b: tIndiceRegion;
         cFilas, cCols: tEscaneo;
         cRegs:tEscaneoReg;


{//////////////////// DECLARACIÓN DE SUBPROGRAMAS /////////////////////}
 procedure pintarSudoku;

 begin
  gotoxy(22,7);
  textcolor(lightred);
  writeln('************************************');
  writeln;
  gotoxy(22,8);
  textcolor(lightblue);
  writeln(' ****  *  *  ***   ****  *  *  *  *');
  gotoxy(22,9);
  writeln(' *     *  *  *  *  *  *  *  *  *  *');
  gotoxy(22,10);
  writeln(' ****  *  *  *  *  *  *  * *   *  *');
  gotoxy(22,11);
  writeln('    *  *  *  *  *  *  *  *  *  *  *');
  gotoxy(22,12);
  writeln(' ****  ****  ***   ****  *  *  ****');
  writeln;
  gotoxy(22,13);
  textcolor(lightred);
  writeln('************************************');
 end;

{=======================================================================}
 { Esta función comprueba si una casilla está ocupada o no }
 
 function verSiOcupada(f,c:TValorJuego; t: ttablerojuego): boolean;

          begin
           if t[f,c] <> 0
           then verSiOcupada:=true
           else versiocupada:=false
 end;
{=======================================================================}
{ Este procedimiento pide las coordenadas de una casilla al usuario }

procedure pedirCoordenadas (var x, y: TIndice);

          begin
           repeat
           textcolor(lightgray);
           writeln('Introduce las coordenadas de la casilla:');
           readln(x,y);
           until (((x>0) and (x<10)) and ((y>0) and (y<10)))
          end;
{=======================================================================}
{ Esta función devuelve true si el usuario pulsa 0, false en caso contrario }

function salir(opcion:integer):boolean;
        begin

         if opcion=0 then salir:=true
         else salir:=false

         end;
{=======================================================================}
{ Esta función devuelve true si todas las casillas est n rellenas, false en cc }

 function tableroLLeno(t:ttablerojuego):boolean;
        var
         f, c: tindice;
         cont:integer;
        begin
         cont:=0;
                for f:=1 to 9 do
                        for c:=1 to 9 do
                                if t[f,c]<>0 then cont:=cont+1;

                                if cont=81 then tablerolleno:= true

                                else tablerolleno:=false
        end;
 {========================================================================}
 { Este procedimiento calcula los índices del array cRegs a partir de f y c }
 
 procedure calcularIndices (f, c: tIndice; var a, b: tIndiceRegion);
       var
          m, n: tIndice;
       begin
        m:=f-1;
        n:= c-1;
        case (m div 3) of
            0: case (n div 3) of
               0: begin
                  a:=1; b:=1;
                  end;
               1: begin
                  a:=1; b:=2;
                  end;
               2: begin
                  a:=1; b:=3;
                  end;
               end;
            1: case (n div 3) of
                  0: begin
                     a:=2; b:=1;
                     end;
                  1: begin
                     a:=2; b:=2;
                     end;
                  2: begin
                     a:=2; b:=3;
                  end;
               end;
            2: case (n div 3) of
                  0: begin
                     a:=3; b:=1;
                     end;
                     1: begin
                        a:=3; b:=2;
                        end;
                     2: begin
                        a:=3; b:=3;
                        end;
                     end;
       end;
 end;
 {========================================================================}
 { Este procedimiento elimina valores de los conjuntos }
 
 procedure quitarValorConjunto(f, c: tindice;t: ttableroJuego;
                                     var cfilas, ccols:tescaneo;
                                     var cregs: tescaneoreg);
    var
     a, b: tindiceregion;

    begin
         cFilas[f]:=cFilas[f]- [t[f,c]];
         cCols[c]:= cCols[c] - [t[f,c]];
         calcularIndices(f, c, a,b);
         cRegs[a, b]:= cRegs[a,b] - [t[f,c]];
    end;
 {========================================================================}
 { Este procedimiento a¤ade valores a los conjuntos }
 
 procedure ponerValorConjunto (f, c: tIndice; t: ttableroJuego;
                               var cfilas, ccols:tescaneo;
                               var cregs: tescaneoreg);
  var
   a, b: tIndiceRegion;

  begin
      cFilas[f]:=cFilas[f] + [t[f, c]];
      cCols[c]:= cCols[c] + [t[f, c]];
      calcularIndices(f,c,a,b);
      cRegs[a, b]:= cRegs[a,b] + [t[f,c]];
 end;

{==========================================================================}
{ Este procedimiento calcula los candidatos de una casilla }

 procedure calcularCandidatos (f,c: tIndice; a, b: tindiceregion;var candidatos: tConjunto);

     begin
      candidatos:= (cFilas[f] * cCols[c] * cRegs [a,b]);
     end;
{=======================================================================}
{ Este procedimiento detecta los fallos cometidos por el usuario }

procedure detectarValoresIncorrectos(var t: tTableroJuego; s: tTableroSolucion; i:tTableroInicial);

          var
           f, c: tIndice;
           valor:tvalorjuego;

          begin
           clrscr;

           for f:=1 to 9 do begin
              for c:= 1 to 9 do begin

              if verSiOcupada(f,c,t)= true then begin
                if i[f,c] = true then begin
                        textcolor(lightcyan);
                        write(t[f,c]);
                        write('  ');
                end
                else
                        if ((t[f,c]<>s[f,c]) and (t[f,c]<>0)) then begin
                                textcolor(red);
                                valor:=(t[f,c]);
                                write(valor);
                                write('  ');
                                normvideo;
                        end
                        else begin
                                textcolor(lightgreen);
                                write(t[f,c]);
                                write('  ');
                        end
                end
                else begin
                        textcolor(yellow);
                        write('_');
                        write('  ');
                        end;
                        end;
                  writeln; writeln;
              end;
              textcolor(lightgray);

              readln

end;


{=========================================================================}
{ Esta funci¢n verifica si los valores introducidos por el usuario coinciden
con la solución del tablero}

 function comprobarSolucion(t: ttablerojuego; s: ttablerosolucion; i:ttableroinicial): boolean;

        var
         f, c: tindice;
         solucion: boolean;
         cuentaFallos: integer;

        begin
                cuentaFallos:=0;

                for f:=1 to 9 do begin
                        for c:=1 to 9 do begin
                                if (t[f,c] <> s[f,c]) and (i[f,c]<>false) then
                                cuentaFallos:=cuentaFallos+1;
                        end;
                end;

                detectarValoresIncorrectos(t, s, i);
                if cuentaFallos<>0 then begin
                solucion:=false;
                textcolor(lightgray);
                writeln('Has cometido ', cuentafallos, ' fallos.');
                readln
                end
                else begin
                solucion:=true;
                textcolor(lightgreen);
                writeln('No has cometido ning£n fallo. Enhorabuena.');
                readln;
                end;


        comprobarSolucion:=solucion
end;


{=======================================================================}
{ Este procedimiento muestra el tablero de juego }

procedure mostrarTablero(var t:ttableroJuego; i: ttableroInicial);

         var
         f, c: tIndice;

         begin
           clrscr;
          for f:=1 to 9 do begin
              for c:= 1 to 9 do begin

              { Si la casilla está ocupada }
                  if verSiOcupada(f,c,t)=true then
                     { Si es un valor inicial }
                     if i[f,c]=true then begin
                         textcolor(lightcyan);
                         write(t[f,c]);
                         write('  ');
                         end
                     { Si no es un valor inicial }
                     else begin

                          textcolor(lightgreen);
                          write(t[f,c]);
                          write('  ');
                          end




                  else begin
                       textcolor(yellow);
                       write('_', '  ');
                       end;

                  end;
                  writeln; writeln;
              end;
         end;


 {========================================================================}
{ Este procedimiento elimina todos los valores introducidos y deja el tablero
como estaba al principio }

procedure reiniciarTablero (var t: ttableroJuego;var i: ttableroinicial);

          var
          candidatos: tConjunto;

          begin
           for f:=1 to 9 do begin
              for c:=1 to 9 do begin
                  if i[f,c]=false then begin
                  ponerValorConjunto(f,c,t, cfilas, ccols, cregs);
                  t[f,c]:=0;
                  end
              end
           end
          end;


{=======================================================================}
{ Este procedimiento borra el valor correspondiente a la casilla indicada
por el usuario. Si la casilla pertenece al tablero inicial o en la casilla
no hay ningún valor, el programa lanza un mensaje de error }

procedure borrarValor(var t: ttablerojuego;var i: TTableroInicial);

          var
           f, c: tIndice;
           v: tvalorjuego;

          begin
           pedirCoordenadas(f,c);
           if i[f,c] then begin
             textcolor(red);
             writeln('¡Ese valor no se puede borrar!!');
             readln;
             end

           else begin

                if t[f,c] = 0 then begin
                   textcolor(red);
                   writeln('En esa casilla no hay ningún valor para borrar.')
                end
                else begin
                     ponerValorConjunto (f, c, t, cfilas, ccols, cregs);
                     t[f,c] := 0;
                     clrscr;
                end
          end
end;

{========================================================================}
{ Este procedimiento se encarga de mostrar los posibles valores de una
casilla introducida por el usuario }

procedure mostrarCandidatos (t:ttablerojuego);

          var
           f, c: tIndice;
           a,b: tIndiceRegion;
           v: tValorJuego;
           candidatos: tConjunto;
           cont:integer;

          begin

           pedirCoordenadas(f,c);

           if verSiOcupada(f,c,t)=true then begin
            textcolor(lightblue);
            writeln ('¡La casilla ya está ocupada!');
           end

           else begin
               calcularIndices(f,c,a,b);
               calcularCandidatos(f, c, a, b, candidatos);
               cont:=0;
               writeln('Los candidatos son: ');
               for v:= 1 to 9 do begin
               textcolor(lightgreen);
                   if (v in candidatos) then begin
                   cont:=cont+1;
                   write(v, ' ')
                   end
                end;
           end;
          textcolor(lightred);
          if cont=0 then writeln('No hay candidatos. Revisa tus errores.');
          readln;
          end;




{========================================================================}
{ Este procedimiento pide unas coordenadas al usuario y si no está ocupada,
le pide que introduzca un valor. Después se lo asigna a la casilla
correspondiente y elimina el valor de los conjuntos }

procedure colocarValor (var t:ttablerojuego);

          var
           f,c: tIndice;
           a, b: tindiceregion;
           valor :tvalorjuego;
           candidatos: tConjunto;

          begin
               pedirCoordenadas(f,c);
               verSiOcupada(f,c,t);
               textcolor(white);
               if verSiOcupada(f,c,t)=true then begin
                  write('La casilla ya est  ocupada ');
                  writeln('por el valor ', t[f,c]);
                  readln;
               end
               else begin
                    calcularIndices(f,c,a,b);
                    calcularCandidatos(f, c, a, b, candidatos);
                    writeln('La casilla elegida es correcta.');
                    writeln('Introduce el valor que deseas colocar en ella: ');
                    repeat
                    readln(valor);
                    if (valor in candidatos) then
                       t[f,c]:=valor
                    else begin
                    write('El valor no corresponde a los candidatos.');
                    writeln('Por favor, elige otro:');
                    end;
                    until (valor in candidatos) ;
                    clrscr;
                    quitarValorConjunto(f, c, t,cfilas,ccols,cregs);


          end;
end;

{==========================================================================}
{ Este procedimiento coloca los valores obvios del tablero, es decir, los valores
de aquellas casillas que sólo tienen 1 candidato }

procedure autocompletar(var t:ttablerojuego; i:ttableroinicial; s:ttablerosolucion;
                        var cfilas, ccols: tEscaneo; var cregs:tEscaneoReg);

          var
           f,c: tindice;
           v, aux: tvalorjuego;
           cont: integer;
           candidatos: tconjunto;
           a,b: tindiceregion;

          begin

           for f:=1 to 9 do begin
              for c:=1 to 9 do begin

                  if ((i[f,c] =false) and (versiocupada(f,c,t)=false)) then begin
                     calcularIndices(f,c,a,b);
                     calcularCandidatos(f,c,a,b,candidatos);
                     cont:=0;
                     for v:= 1 to 9 do begin
                         if (v in candidatos) then begin
                            cont:=cont+1;
                            aux:=v;
                         end
                     end;

                     if (cont = 1) then begin
                         t[f,c]:=aux;
                         quitarvalorconjunto(f,c,t,cfilas,ccols,cregs);
                     end

                         end;
                     end;
                  end;
end;

{==============================================================================}
{ Este procedimiento pide una opción del menú al usuario }

procedure mostrarMenu(var opcion: integer);

     {=============================================================}
      { Este procedimiento lee la opción del usuario }
	  
        procedure pedirOpcion;

          var
          f,c: tvalorjuego;

          begin

                  readln(opcion);
                  if ((opcion<0) OR (opcion>6)) then begin
                     textcolor(yellow);
                     writeln('Esa opci¢n no es v lida'); writeln;
                  end;

              end;
     {============================================================}

            begin
                  textcolor(lightgray);
                  writeln('Elige una opción: '); writeln;
                  writeln('1. Ver los posibles valores de una casilla.');
                  writeln('2. Colocar valor en una casilla.');
                  writeln('3. Borrar valor de una casilla.');
                  writeln('4. Detectar valores incorrectos.');
                  writeln('5. Reiniciar tablero.');
                  writeln('6. Autocompletar tablero.');
                  writeln('0. Salir.');
                  pediropcion;
                  textcolor(red)
          end;
 {========================================================================}
{ Este procedimiento inicializa los arrays del tablero inicial y tablero de juego
y después carga desde fichero los tableros de juego }

procedure cargarTableros(var t:tTableroJuego; var i:tTableroInicial; var s: tTableroSolucion);

          {===================================================}
          { Este procedimiento inicializa el tablero de juego y el inicial }

          (*/*) procedure inicializarTableros(var t:tTableroJuego; var i:tTableroInicial);

                 var
                  f, c: tIndice;

                 begin
                      for f:= 1 to 9 do begin
                       for c:=1 to 9 do begin
                           t[f,c]:=0;
                           i[f,c]:=false
                       end
                 end;
           end;(* inicializarTableros *)
           
		   {===================================================}
           { Este procedimiento carga el archivo del tablero inicial desde fichero }

           (*/*) procedure cargarTableroInicial (var t:tTableroJuego; var i:tTableroInicial);

                     var
                      f,c: tindice;
                      v: tvalorjuego;
                      fichero1: text;
                      rutaInicial: string;

                     begin
                      repeat
                       gotoxy(22,15);
                       pintarsudoku;
                       textcolor(lightcyan);
                       gotoxy(22,16);
                       writeln('Introduce la ruta del tablero inicial:');
                       gotoxy(22,17);
                       textcolor(lightred);
                       readln(rutaInicial);
                       clrscr;
                       assign (fichero1, rutaInicial);
                       {$I-}
                       reset (fichero1);
                       {$I+}

                      until ioresult =0;

                      while not eof (fichero1) do  begin
                            read(fichero1, f, c, v);
                            i[f,c]:=true;
                            t[f, c]:= v;
                      end;
                     close (fichero1);
                     end;
           {===================================================}
           { Este procedimiento carga desde fichero el tablero con la solución }

           (*/*) procedure cargarTableroSolucion (var s:tTableroSolucion);

                     var
                      f,c: tindice;
                      v: tvalorSolucion;
                      fichero: text;
                      rutaSol: string;


                     begin
                      repeat
                       gotoxy(22,15);
                       pintarsudoku;
                       textcolor(lightcyan);
                       gotoxy(22,16);
                       writeln('Introduce la ruta del tablero solución:');
                       gotoxy(22,17);
                       textcolor(lightred);
                       readln(rutaSol);
                       clrscr;
                       assign (fichero, rutaSol);
                       {$I-}
                       reset (fichero);
                       {$I+}

                      until ioresult =0;

                      while not eof (fichero) do  begin
                            read(fichero, f, c, v);
                            s[f, c]:= v;
                      end;

                      close (fichero);


                     end;

   begin
    inicializarTableros(t,i);
    cargarTableroInicial(t,i);
    cargarTableroSolucion(s);
   end;

{========================================================================}
{ Este procedimiento prepara los candidatos inicializando los conjuntos con
todos los valores posibles. Despu‚s elimina los valores iniciales de los
conjuntos de candidatos }

procedure prepararCandidatos(t:tTableroJuego; i:tTableroInicial; var cFilas, cCols: tEscaneo; var cRegs:tEscaneoReg);
              var
               f,c: tIndice;
               a,b: tIndiceRegion;
               c1, c2, c3: tconjunto;
   {=======================================================================}
   { Este procedimiento inicializa los conjuntos de filas, columnas, y regiones }

   (*/*) procedure inicializarConjuntos(var cFilas,cCols: tEscaneo;
                                        var cRegs:tEscaneoReg;
                                        var c1, c2, c3: tConjunto);

                var
                 f, c: tIndice;
                 a,b: tIndiceRegion;

                begin

                 c1:=[1..9];
                 c2:=[1..9];
                 c3:=[1..9];

                for f:=1 to 9 do
                 cFilas[f]:=c1;
                for c:=1 to 9 do
                 cCols[c]:=c2;
                for f:=1 to 3 do begin
                 for c:=1 to 3 do
                  cRegs[f, c] := c3;
                end;
       end;
   {=======================================================================}

      begin
       inicializarConjuntos (cFilas, cCols, cRegs, c1, c2, c3);
       for f:=1 to 9 do begin
          for c:=1 to 9 do begin
              if i[f,c] then
              quitarValorConjunto (f, c, t, cfilas, ccols, cregs);
          end;
      end;
end;

{=================    PROGRAMA PRINCIPAL    ===============}

BEGIN
 clrscr;
 cargarTableros(tabJuego, tabIni, tabSol);
 prepararCandidatos(tabJuego,tabIni,cFilas, cCols, cRegs);

     REPEAT
           window(25,10,80,50);
           mostrarTablero(tabJuego, tabIni);
           mostrarMenu(opcion);
            case (opcion) of
                  1: mostrarCandidatos(tabJuego);
                  2: colocarValor(tabJuego);
                  3: borrarValor(tabJuego, tabIni);
                  4: detectarValoresIncorrectos(tabJuego, tabSol, tabIni);
                  5: reiniciarTablero(tabJuego, tabIni);
                  6: autocompletar(tabJuego, tabIni, tabSol, cfilas, ccols, cregs);
                  end;

     UNTIL salir(opcion) or tableroLleno (tabJuego);
     IF not salir(opcion) then begin

        comprobarSolucion(tabJuego,tabSol,tabIni);
        textcolor(yellow);
        writeln(' * FIN DEL PROGRAMA * ');
        readln;
     end

END.

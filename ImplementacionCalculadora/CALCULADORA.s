
.data
      @ Datos Entrada
num1: .word 5 @ 0xF o 017  15
num2: .word 1000  @ 0x5 o 05  5

ResultadoSuma: .space 4 
ResultadoResta: .space 4 
ResultadoMulti: .space 4 
ResultadoPotencia: .space 4 
Cociente: .space 4 
RDecimal: .space 4
Buffer: .space 100
SumaR: .asciz "%d + %d = %d"
RestaR: .asciz "%d - %d = %d"
MultR: .asciz "%d * %d = %d"
PotenR: .asciz "%d ^ %d = %d"
PotenR1: .asciz "%d ^ %d = %d,"
PotenR2: .asciz "%d ^ %d = -%d,"
DivR: .asciz "%d / %d = %d,"
DivR1: .asciz "%d / %d = -%d,"
Formato: .asciz "%d"
ErrorD: .asciz "Math Error,No se puede realizar la Operacion"
ErrorDesbordamiento: .asciz "Math Error,Desbordamiento"
      @ Operacion a realizar
           .balign 4
Operacion: .asciz "/"   @ Operacion a realizar
.text

@Programa Invocador
main:  

   ldr r0, =Operacion    
   ldr r1, [r0]   
   
   cmp r1,#'+'
    @ Invocacion Suma
    beq Suma

   cmp r1,#'-'
    @ Invocacion Suma
    beq Resta

   cmp r1,#'*'
    @ Invocacion Suma
    beq Multiplicacion

   cmp r1,#'^'
    @ Invocacion Suma
    beq Potencia

   cmp r1,#'/'
    @ Invocacion Suma
    beq Division

Terminar:

stop: wfi @ End of program

@Subrutina para suma

Suma: 

   ldr r0, =num1    @ Cargamos la dirección de num1 en r0
   ldr r3, [r0]     @ Cargamos el valor almacenado en la dirección apuntada por r0 (num1) en r3
   ldr r2, =num2    @ Cargamos la dirección de num2 en r2
   ldr r4, [r2]     @ Cargamos el valor almacenado en la dirección apuntada por r2 (num2) en r4
   mov r5, #0       @Acumulador
   add r5, r3, r4

   mov r0, #0 
   add r0,r0,r5
   cmp r0,r5
   bvs Desbordamiento

   ldr r7, = ResultadoResta
   str r5,[r7]
 

   @Parametros para Imprimir
   ldr r2, =SumaR
   b Imprimir
   
@Subrutina para Resta

Resta: 

   ldr r0, =num1    @ Cargamos la dirección de num1 en r0
   ldr r3, [r0]     @ Cargamos el valor almacenado en la dirección apuntada por r0 (num1) en r3
   ldr r2, =num2    @ Cargamos la dirección de num2 en r2
   ldr r4, [r2]     @ Cargamos el valor almacenado en la dirección apuntada por r2 (num2) en r4
   mov r5, #0       @Acumulador
   sub r5, r3, r4

   mov r0, #0 
   add r0,r0,r5
   cmp r0,r5
   bvs Desbordamiento

   ldr r7, = ResultadoResta
   str r5,[r7]

   @Parametros para Imprimir
   ldr r2, =RestaR
   b Imprimir

@Subrutina para Multiplicar
Multiplicacion: 
   
   ldr r0, =num1    @ Cargamos la dirección de num1 en r0
   ldr r3, [r0]     @ Cargamos el valor almacenado en la dirección apuntada por r0 (num1) en r3
   ldr r2, =num2    @ Cargamos la dirección de num2 en r2
   ldr r4, [r2]     @ Cargamos el valor almacenado en la dirección apuntada por r2 (num2) en r4
   mov r5, r3       @Acumulador
   mul r5, r4

   mov r0, #0 
   add r0,r0,r5
   cmp r0,r5
   bvs Desbordamiento

   ldr r7, = ResultadoMulti
   str r5,[r7]

   @Parametros para Imprimir
   ldr r2, =MultR
   b Imprimir

@Subrutina para Potencias
Potencia: 

   ldr r0, =num1    @ Cargamos la dirección de num1 en r0
   ldr r3, [r0]     @ Cargamos el valor almacenado en la dirección apuntada por r0 (num1) en r3
   ldr r2, =num2    @ Cargamos la dirección de num2 en r2
   ldr r4, [r2]     @ Cargamos el valor almacenado en la dirección apuntada por r2 (num2) en r4
   mov r5, #0       @Acumulador
   mov r6,r3        @Auxiliar
   mov r0,#0

   orr r6, r6, r4
   cmp r6, #0 
   beq ImprimirErrorD 

   cmp r4, #0 
   beq potenciaCero 
   blt R4PotN

 
Reanudar:
   mov r5, r3
   mov r6, #1

   cmp r4,#1
   beq especial

for:
   mul r5, r3          
   add r0,r0,r5
   cmp r0,r5
   bvs Desbordamiento
   add r6, r6, #1
   cmp r6, r4
   bne for 
   
especial: 
   mov r7,r8
   cmp r7,#1
   beq PotNegativo 

   ldr r7, = ResultadoPotencia
   str r5,[r7]

   @Parametros para Imprimir
   ldr r2, =PotenR
   b Imprimir


potenciaCero:
   mov r5,#1
   ldr r7, = ResultadoPotencia
   str r5,[r7]

   @Parametros para Imprimir
   ldr r2, =PotenR
   b Imprimir

R4PotN:
   mov r5,r3
   mov r7,#1
   neg r4, r4
   mov r8,r7

   cmp r5, #0       
   blt NegR3

   b Reanudar

NegR3:
   neg r3, r3
   mov r7,#1
   mov r9,r7
   b Reanudar

PotNegativo:
   
   mov r3,#1
   mov r4,r5
   bl CocienteResiduo

   ldr r7, = ResultadoPotencia
   str r5,[r7]

   bl Decimal
   mov r6,r5

   ldr r7, = ResultadoPotencia
   ldr r5,[r7]
 
   ldr r0, =num1    @ Cargamos la dirección de num1 en r0
   ldr r3, [r0]     @ Cargamos el valor almacenado en la dirección apuntada por r0 (num1) en r3
   ldr r2, =num2    @ Cargamos la dirección de num2 en r2
   ldr r4, [r2]     @ Cargamos el valor almacenado en la dirección apuntada por r2 (num2) en r4
   mov r0,r9
   cmp r0,#1
   beq ResultNeg 

   @Parametros para Imprimir
   ldr r2, =PotenR1
   b ImprimirD

 ResultNeg:
   ldr r2, =PotenR2
   b ImprimirD

Desbordamiento:
    mov r0, #0 
    mov r1,#3
    ldr r2, = ErrorDesbordamiento
    bl printString 

    b Terminar

ImprimirErrorD:

    mov r0, #6
    mov r1, #3
    ldr r2, = ErrorD
    bl printString 

    b Terminar

@Subrutina para Dividir
Division: 

   ldr r0, =num1    @ Cargamos la dirección de num1 en r0
   ldr r3, [r0]     @ Cargamos el valor almacenado en la dirección apuntada por r0 (num1) en r3
   ldr r2, =num2    @ Cargamos la dirección de num2 en r2
   ldr r4, [r2]     @ Cargamos el valor almacenado en la dirección apuntada por r2 (num2) en r4
   
   mov r5, #0 @ Inicializa el residuo a cero
   mov r6, r3 @ dividendo temporal

   cmp r4, #0 
   beq ImprimirErrorD 
   blt R4Negativo

   cmp r3, #0       
   blt R3Negativo

   mov r5, #0 @ Inicializa el residuo a cero
   mov r6, r3 @ dividendo temporal

   cmp r3, r4 
   blt Menor 
   bge Mayor

  
Continuar:

   bl Decimal

   ldr r7, = Cociente
   ldr r5,[r7]
   
     
   mov r0,#1
   cmp r11,r0
   beq negativo1
   
   mov r0,#2
   cmp r11,r0
   beq negativo2

   mov r0,#3
   cmp r11,r0
   beq negativo3

@Parametros para Imprimir
  ldr r2, =DivR 

   b ImprimirD

Menor:
 bl CocienteResiduo

 ldr r7, = Cociente
 str r5,[r7]

 b Continuar

Mayor:
 bl divideLoop

 ldr r7, = Cociente
 str r5,[r7]

 b Continuar


@Subritina Division
divideLoop:
   cmp r6, r4 @ Compara el dividendo con el divisor
   blt endLoop @ Si el dividendo es menor que el divisor, termina

   sub r6, r6, r4 @ Resta el divisor del dividendo
   add r5, r5, #1  @ Incrementa el cociente
   add r0,r0,r5
   cmp r0,r5
   bvs Desbordamiento
   b divideLoop @ Repite el bucle de división

endLoop:
    mov pc,lr 

CocienteResiduo:
   mov r5,#0 @cociente cero 
   mov r6,r3 @residuo es el dividendo si es menor al divisor
   mov pc,lr


Decimal:
   push {lr}
   mov r5,#0
   mov r7,#0
   cmp r4,#1
   beq CeroDecimal
ciclo:
   mov r0,#10
   mul r6, r0
   bl divideLoop
   
   @ Guardar el valor de r5 en el vector
   ldr r1, =Buffer   @ Dirección base del vector
   ldr r2, =4         @ Tamaño de cada elemento del vector (en bytes)
   mul r2,r7
   add r1,r1,r2          @ Calcular la dirección de memoria para almacenar el valor
   str r5, [r1]       @ Almacenar el valor de r5 en la posición correspondiente del vector
   add r7, r7, #1

   cmp r5,#0
   beq ciclo
   
   mov r12,r1
   mov r10,r7 
   pop {pc}

CeroDecimal:
   mov r5,#0
   ldr r1, =Buffer   @ Dirección base del vector
   str r5, [r1]       @ Almacenar el valor de r5 en la posición correspondiente del vector

   mov r6,#1
   mov r12,r1
   mov r10,r6 
   
   pop {pc}
@Manejo de Negativos
R3Negativo:
   neg r3, r3
   mov r0,#1
   mov r11,r0
  
   cmp r3, r4 
   blt Menor 
   bge Mayor


R4Negativo:
   cmp r3, #0       
   blt AmbosNegativo
   neg r4, r4
   mov r0,#2
   mov r11,r0

   cmp r3, r4 
   blt Menor 
   bge Mayor

AmbosNegativo:
   neg r3, r3
   neg r4, r4
   mov r0,#3
   mov r11,r0

   cmp r3, r4 
   blt Menor 
   bge Mayor

negativo1:
   neg r3,r3
   
   ldr r2, =DivR1
   b ImprimirD

negativo2:
   neg r4,r4
 
   ldr r2, =DivR1
   b ImprimirD

negativo3:
   neg r3,r3
   neg r4,r4

   ldr r2, =DivR
   b ImprimirD
 
@Imprimir Resultados
Imprimir: 
    mov r0, #12       @Numero Columna
    mov r1, #2         @Numero Fila 
    sub sp, sp, #4 
    str r5, [sp, #4] 
    str r4, [sp] 
    ldr r5, [sp, #4] 
    ldr r4, [sp] 
    bl printf 
    add sp, sp, #4 
    
    b Terminar

ImprimirD: 

      
    mov r0, #8       @Numero Columna
    mov r1, #2         @Numero Fila   
    sub sp, sp, #4 
    str r5, [sp, #4] 
    str r4, [sp] 
    ldr r5, [sp, #4] 
    ldr r4, [sp] 
    bl printf 
    add sp, sp, #8

    add r5, r0, #7 

    ldr r6,=Buffer
    mov r4,#0

imprimir_vector:

    ldr r7, [r6]     
    add r6, r6, #4        
    mov r3, r7
   
    add r5,r5,#1

    mov r0,r5
    mov r1,#2        
    ldr r2, =Formato  
    bl printf         

    add r4,r4,#1

    cmp r4,r10       @ Comprobar si hemos llegado al final del vector
    beq seguir 

    b imprimir_vector 
   
seguir:
    

    b Terminar

  


.end

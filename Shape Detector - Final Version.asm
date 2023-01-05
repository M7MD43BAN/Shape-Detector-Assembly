;***************************************************************************************;
;                       Program Description: Shape Detector                             ;
;***************************************************************************************;     
org 100h
include 'emu8086.inc' 
        
.data   

;Test Square 1 
point1 dw 10, 10 
point2 dw 20, 10  
point3 dw 20, 20
point4 dw 10, 20

;Test Square 2
;point1 dw 1, 1 
;point2 dw 3, 1  
;point3 dw 3, 3
;point4 dw 1, 3

;Test Rectangle 1
;point1 dw 0, 0 
;point2 dw 6, 0  
;point3 dw 6, 5
;point4 dw 0, 5

;Test Rectangle 2
;point1 dw 12, 0 
;point2 dw 12, 5  
;point3 dw 0, 5
;point4 dw 0, 0

;Test Triangle 
;point1 dw 1, 4 
;point2 dw 2, 7  
;point3 dw 1, 12

;Test Rhombic 
;point1 dw 2, 2 
;point2 dw 12, 2  
;point3 dw 18, 10
;point4 dw 8, 10


;Flags
isSquareFlag db ?
isRectangleFlag db ?
option dw ?
 
Distance dw ?

space db ' '
outs dw 7
ins dw -1
row db  7

;Dimensions of rectangle
distanceWidth1 dw ?
distanceWidth2 dw ?
distanceHeight1 dw ?
distanceHeight2 dw ?
distanceDiagonal1 dw ?
distanceDiagonal2 dw ?

;Dimensions of square
distance2 dw ?
distance3 dw ?
distance4 dw ?

;Dimensions of triangle
x1 dw ?
x2 dw ?
x3 dw ? 
area dw ?

size = ($ - point1) / 2
;size refer to length of Rectangle will be calculated by get sqr root 
size1 db ?
size2 db ? 

;size refers to length of Square will be calculated by get sqr root 
sizeOfSquare db ?

;Menu strings
newline db 0ah,0dh,'$'
Welcome db "------------------------WELCOME TO SHAPE DETECTOR GAME------------------------", 0ah, 0dh, "$"
OptionString db "Do you want enter 4 points (option 1) or 3 points (option 2)?", 0ah, 0dh, "$"
Choose db "Choose your option: ", "$"
Error db "Please enter the right option! ", 0ah, 0dh, "$"

;Get points strings
point1String db "Enter first point:", 0ah, 0dh, "$"
point2String db "Enter second point:", 0ah, 0dh, "$"
point3String db "Enter third point:", 0ah, 0dh, "$"
point4String db "Enter forth point:", 0ah, 0dh, "$"

;Print points strings
displayPoints db "------------------------YOUR POINTS------------------------", 0ah, 0dh, "$"
firstPoint db "First point = ($"
secondPoint db "Second point = ($"
thirdPoint db "Third point = ($"
forthPoint db "Forth point = ($"
comma db ", $"
bracket db ")", 0ah, 0dh, "$"

;Shapes strings
squareShape db "------------------------SQUARE------------------------", 0ah, 0dh, "$"
rectangleShape db "------------------------RECTANGLE------------------------", 0ah, 0dh, "$"
triangleShape db "It is aTriangle!", 0ah, 0dh, "$"
unknownString db "UnKnown!", 0ah, 0dh, "$"

 
.code  
 
;***************************************************************************************;
;                                   main Procdure                                       ;
;***************************************************************************************; 

main PROC  
    
    CALL menu            
    
    JMP Exit
     
main ENDP 

;***************************************************************************************;  
;                               menu Procedure                                          ;
;Description: Menu to show to the user to choose 4 points or 3 points                   ;
;Inputs(receives): option: data word entered by the user                                ;
;Output(returns): Specific function will be called by based on option                   ;
;                                                                                       ;
;***************************************************************************************;

menu PROC
    
    lea dx, Welcome
    call Print
    
    ;To make new line and return cursor to the start
    lea dx, newline
    call Print 
    
    lea dx, OptionString
    call Print
    
    ;To take the option again from user
    again:
	lea dx, Choose
    call Print
	CALL scan_num
	mov option, cx
	
	;To make new line and return cursor to the start
    lea dx, newline
    call Print
	
	;If the user choose option1, then isFour label is jumped
    CMP option, 1
    JZ isFour
    
    ;If the user choose option2, then isThree label is jumped
    CMP option, 2
    JZ isThree
    
    ;Else, noRightOption label is jumped
    JMP noRightOption 
        
    JMP Exit	            
    
menu ENDP    
 
;***************************************************************************************;  
;                               isRectangle Procedure                                   ;
;Description: Check if the four points is a rectangle or not                            ;
;Inputs(receives): Point1(x, y): unsigned array with size 2 (data Word)                 ;
;                  Point2(x, y): unsigned array with size 2 (data Word)                 ;
;                  Point3(x, y): unsigned array with size 2 (data Word)                 ;
;                  Point4(x, y): unsigned array with size 2 (data Word)                 ;
;Output(returns): Print string contains 'Rectangle!' or 'Not Rectangle!'                ;
;                                                                                       ;
;***************************************************************************************;

isRectangle PROC   
     
     mov si, 0
     mov di, 0
     mov ax, 0
     mov bx, 0
     
    ;Distance between point1 & point2
    lea si, point1
    lea di, point2    
    CALL calculatedistance
    mov ax, Distance
    mov distanceWidth1, ax
    
    ;Distance between point3 & point4
    lea si, point3
    lea di, point4
    CALL calculatedistance
    mov ax, Distance
    mov distanceWidth2, ax
    
    ;Distance between point1 & point4
    lea si, point1
    lea di, point4
    CALL calculatedistance
    mov ax, Distance
    mov distanceHeight1, ax
    
    ;Distance between point2 & point3
    lea si, point2
    lea di, point3
    CALL calculatedistance
    mov ax, Distance
    mov distanceHeight2, ax
    
    ;Distance between point1 & point3
    lea si, point1
    lea di, point3
    CALL calculatedistance
    mov ax, Distance
    mov distanceDiagonal1, ax
    
    ;Distance between point2 & point4
    lea si, point2
    lea di, point4
    CALL calculatedistance
    mov ax, Distance
    mov distanceDiagonal2, ax
    
    ;if (distanceHeight1 == distanceHeight2)
    mov ax, distanceHeight1
    mov bx, distanceHeight2
    
    CMP ax, bx
    JE Equal
    
    ;if is the condition is false (ZF = 0)
    JMP Stop
     
    ;if (distanceWidth1 == distanceWidth2) 
    Equal:
        mov ax, distanceWidth1
        mov bx, distanceWidth2
    
        CMP ax, bx
        JE Equal2
        JMP Stop
    
    ;if (distanceDiagonal1 == distanceDiagonal2)
    Equal2:
        mov ax, distanceDiagonal1 
        mov bx, distanceDiagonal2
    
        CMP ax, bx
        JE Equal3
        JMP Stop
        
    ;if (distanceHeight1 != distanceWidth1)
    Equal3:        
        mov ax, distanceHeight1 
        mov bx, distanceWidth1 
        
        CMP ax, bx
        JNZ Equal4
        JMP Stop 
    
    ;if (distanceHeight2 != distanceWidth2)
    Equal4:
        mov ax, distanceHeight1 
        mov bx, distanceWidth1 
        
        CMP ax, bx
        JNZ printRectangle
        JMP Stop        
    
    ;if all conditions is true, then this label is will excute      
    printRectangle: 
        mov isRectangleFlag, 1
        ;To make new line and return cursor to the start
        lea dx, newline
        call Print                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
    
    JMP Exit
isRectangle ENDP
                                                     
;***************************************************************************************;
;                           calculatedistance Procdure                                  ;
;Description: Procedure to calculate distance between two points                        ; 
;Receives:                                                                              ;
;si the offset of first point (si reference to first point)                             ;
;di the offset of second point (di reference to second point)                           ;
;Returns:                                                                               ;   
;return Distance between two points                                                     ;
;***************************************************************************************;

calculatedistance PROC 
    push si
    push di
    
    mov ax, [si]
    sub ax, [di]
    imul ax
    mov dx, ax
    
    push dx
    mov bx, [si + 2]
    sub bx, [di + 2] 
    mov ax, bx
    imul ax
    pop dx
     
    add dx, ax  
    mov Distance, dx
    
    pop si
    pop di
      
    JMP Exit
calculatedistance ENDP                    
                      
;***************************************************************************************;  
;                               get_four_points Procdure                                ;
;Description: procedure takes four points from the user                                 ;
;input paramaters:                                                                      ;
;(1) point1(x,y), (2) point2(x,y), (3) point3(x,y), (4)point4(x,y)                      ;
;use macros 'putc 0ah and putc 0dh' to return cursor and make new line                  ;
;use procedure 'scan_num' to take number from user and stores the result in CX register.;
;To use scan_num declare DEFINE_SCAN_NUM before END directive.                          ;
;use si as index of points                                                              ;
;use macros 'print' to print string                                                     ;
;use loop                                                                               ;
;(puch cx to save value of cx)                                                          ;
;***************************************************************************************;  

get_four_points PROC
    
    ;To make new line and return cursor to the start
    lea dx, newline
    call Print     
    
    lea dx, point1String
    call Print      
    
    mov si,0 
    mov cx,2
     
    lo1: 
        push cx
        call scan_num   
        mov point1[si], cx
        ;To make new line and return cursor to the start
        lea dx, newline
        call Print   
        add si,2
        pop cx
    loop lo1
    
    lea dx, point2String
    call Print
    
    mov si,0 
    mov cx,2
      
    lo2: 
        push cx
        call scan_num   
        mov point2[si], cx 
        ;To make new line and return cursor to the start
        lea dx, newline
        call Print   
        add si,2
        pop cx
    loop lo2

    lea dx, point3String
    call Print
        
    mov si,0 
    mov cx,2
      
    lo3: 
        push cx
        call scan_num   
        mov point3[si], cx 
        ;To make new line and return cursor to the start
        lea dx, newline
        call Print   
        add si,2
        pop cx
    loop lo3 

    lea dx, point4String
    call Print
        
    mov si,0 
    mov cx,2
      
    lo4: 
        push cx
        call scan_num   
        mov point4[si], cx 
        ;To make new line and return cursor to the start
        lea dx, newline
        call Print   
        add si,2
        pop cx
    loop lo4
    
    ;To make new line and return cursor to the start
    lea dx, newline
    call Print 
     
    JMP Exit
     
get_four_points ENDP

;******************************************************************************************************************;  
;                               print_four_points procedure                                                        ;
;Description: procedure prints four points                                                                         ;
;input paramaters:                                                                                                 ;
;(1) point1(x,y), (2) point2(x,y), (3) point3(x,y), (4)point4(x,y)                                                 ;
;use macros 'putc 0ah and putc 0dh' to return cursor and make new line                                             ;
;use procedure 'print_num_uns' to print number  ,is a procedure that prints out an unsigned number in AX register. ;
;To use print_num_uns declare DEFINE_PRINT_NUM_UNS before END directive.                                           ;
;use si as index of points                                                                                         ;
;use macros print to print string                                                                                  ;
;******************************************************************************************************************; 

print_four_points PROC 
    
    lea dx, displayPoints
    call Print
    
    ;To make new line and return cursor to the start
    lea dx, newline
    call Print 
    
    ;First Point   
    lea dx, firstPoint
    call Print     
    
    mov si, 0    
    mov ax, point1[si]
    call print_num_uns
          
    lea dx, comma
    call Print
    
    mov ax, point1[si+2] 
    call print_num_uns
      
    lea dx, bracket
    call Print         
    mov si, 0
    
    ;Second Point
    lea dx, secondPoint
    call Print
     
    mov ax, point2[si] 
    call print_num_uns  
    
    lea dx, comma
    call Print
            
    mov ax, point2[si+2] 
    call print_num_uns  
    lea dx, bracket
    call Print        
    mov si,0           
    
    ;Third Point
    lea dx, thirdPoint
    call Print
     
    mov ax, point3[si] 
    call print_num_uns 
    
    lea dx, comma
    call Print
     
    mov ax, point3[si+2] 
    call print_num_uns  
    lea dx, bracket
    call Print   
    mov si,0 
    
    ;Forth Point 
    lea dx, forthPoint
    call Print
     
    mov ax, point4[si] 
    call print_num_uns 
    
    lea dx, comma
    call Print
     
    mov ax, point4[si+2] 
    call print_num_uns  
    lea dx, bracket
    call Print 
      
    JMP Exit
     
print_four_points ENDP 

;****************************************************************************************;  
;                                       get_three_points proc                            ;
;Description:procedure take three points from user                                       ;
;input paramaters:                                                                       ;
;(1) point1(x,y), (2) point2(x,y), (3) point3(x,y)                                       ;
;use macros 'putc 0ah and putc 0dh' to return cursor and make new line                   ;
;use procedure 'scan_num' to take number from user and stores the result in CX register. ;
;To use scan_num declare DEFINE_SCAN_NUM before END directive.                           ;
;use si as index of points                                                               ;
;use macros print                                                                        ;
;use loop                                                                                ;
;(puch cx to save value of cx)                                                           ;
;****************************************************************************************; 
 
get_three_points PROC 
 
    ;To make new line and return cursor to the start
    lea dx, newline
    call Print     
    
    lea dx, point1String
    call Print
     
    mov si,0 
    mov cx,2
      
    loo1: 
        push cx
        call scan_num   
        mov point1[si], cx 
        ;To make new line and return cursor to the start
        lea dx, newline
        call Print   
        add si,2
        pop cx
    loop loo1 
          
    lea dx, point2String
    call Print
     
    mov si,0 
    mov cx,2
      
    loo2: 
        push cx
        call scan_num   
        mov point2[si], cx 
        ;To make new line and return cursor to the start
        lea dx, newline
        call Print   
        add si,2
        pop cx
    loop loo2
      
    lea dx, point3String
    call Print
        
    mov si,0 
    mov cx,2
      
    loo3: 
        push cx
        call scan_num   
        mov point3[si], cx 
        ;To make new line and return cursor to the start
        lea dx, newline
        call Print  
        add si,2
        pop cx
    loop loo3    
    
    ;To make new line and return cursor to the start
    lea dx, newline
    call Print  
         
    JMP Exit
     
get_three_points ENDP  

;*******************************************************************************************************************; 
;                                           print_three_points procedure                                            ;
;Description: procedure print three points                                                                          ;
;input paramaters:                                                                                                  ;
;(1) point1(x,y), (2) point2(x,y), (3) point3(x,y)                                                                  ;
;use macros 'putc 0ah and putc 0dh' to return cursor and make new line                                              ;
;use procedure 'print_num_uns' to print number  ,is a procedure that prints out an unsigned number in AX register.  ;
;To use it declare DEFINE_PRINT_NUM_UNS before END directive.                                                       ;
;use si as index of points                                                                                          ;
;use macros print to print string                                                                                   ;
;*******************************************************************************************************************; 
  
print_three_points PROC 
    mov si,0
           
    lea dx, displayPoints
    call Print
    
    ;To make new line and return cursor to the start
    lea dx, newline
    call Print 
    
    ;First Point   
    lea dx, firstPoint
    call Print     
    
    mov si, 0    
    mov ax, point1[si]
    call print_num_uns
          
    lea dx, comma
    call Print
    
    mov ax, point1[si+2] 
    call print_num_uns
      
    lea dx, bracket
    call Print         
    mov si, 0
    
    ;Second Point
    lea dx, secondPoint
    call Print
     
    mov ax, point2[si] 
    call print_num_uns  
    
    lea dx, comma
    call Print
            
    mov ax, point2[si+2] 
    call print_num_uns  
    lea dx, bracket
    call Print        
    mov si,0           
    
    ;Third Point
    lea dx, thirdPoint
    call Print
     
    mov ax, point3[si] 
    call print_num_uns 
    
    lea dx, comma
    call Print
     
    mov ax, point3[si+2] 
    call print_num_uns  
    lea dx, bracket
    call Print   
    mov si,0    
      
    JMP Exit
    
print_three_points ENDP

;********************************************************************************; 
;                              drawSquare procedure                              ;
;Description: Procedure to print square by *                                     ;                               
;input paramaters: dictance from CalculateDictance PROCEDURE                     ;
;  THEN                                                                          ;
;      SIZE = Square root of dictance                                            ;
;             mov size , cx                                                      ;
;  mov cl , size                                                                 ;
;      mov al,size -1                                                            ;
;   outter:                                                                      ;
;        inner:                                                                  ;
;           if (indx==0 ||index==size-1 ||inner_Counter==0 ||inner_Counter==0)   ;
;           putstar:                                                             ;
;           print "*"                                                            ;
;           else print ' '                                                       ;
;                                                                                ;
;   countter++                                                                   ;
;   cl--                                                                         ;
;********************************************************************************; 

drawSquare PROC
    mov cx, 0
    mov bx, Distance4 
    
    ;this lines to calculate sqr root of any distance
    
    ;-----------------------------------------------------------------------------
    loo:
    mov ax, cx
    mul cx
    cmp ax, bx
    jz store
    inc cx
    jnz loo
    
    store:
    mov [3002], cx   
    
    ;move value of squared element to size
    mov sizeOfSquare, cl  
       
    ;------------------------------------------------------------------------------  
         
    lea dx, squareShape
    call Print
     
    ;To make new line and return cursor to the start
    printn   
           
    ;Outter LOOP to draw square
    ;first move size ->> indicate to number of * of the raw
    
    mov cl, sizeOfSquare   
    
    ;this two lines to have the value to compare with un case of star * 
    mov al, sizeOfSquare    
    dec al         
    
    ;be used as the counter starts from 0 in conditions
    mov ch, 0  
    
    ;Main loop to 
    outter:    
          
         ; to reset inner counter each time of inner loop starts
         mov bh, sizeOfSquare
           
         ; to reset the counter used in comaparsion
         mov bl, 0
         
         inner: 
         ; compare if outer conter =0 to put *     
         cmp ch, 0
         je putstar
         
         ; compare if outer conter = size -1  to put *
         cmp ch, al
         je putstar
           
         ; compare if inner conter =0 to put *  
         cmp bl, 0
         je putstar
         
         ; compare if inner conter = size -1  to put *
         cmp bl, al
         je putstar
         
         ; else will make uncoditional jump to putstar:
         jmp putSpace 
         
         endif:
         ;decrement inner counter
         dec bh
         
         ;check counter > 0
         jnz inner
         
         ; increment counter used to check position to determin * or  ' '       
         inc ch 
         
         ;To make new line and return cursor to the start
         printn
                   
         ;decrement counter  of outter loop
         dec cl
                                      
         ; check counter not equal zero
         jnz outter
         
         JMP Exit
    
    ;used to print * when conditions is true    
         
    putstar:    
    print '* '
    
    ; increment inner loop counter 
    inc bl
     
    ; unconditional jump to continue 
    jmp endif 
    
    ;used to print * when all conditions is false
    putSpace:
    ;increment inner loop counter 
    inc bl 
    
    ;unconditional jump to continue 
    print '  ' 
    
    jmp endIF
    
    JMP Exit

drawSquare ENDP

;***************************************************************************************;  
;                               isSquare Procedure                                      ;
;Description: Check if the four points is a Square or not                               ;
;Inputs(receives): Point1(x, y): unsigned array with size 2 (data Word)                 ;
;                  Point2(x, y): unsigned array with size 2 (data Word)                 ;
;                  Point3(x, y): unsigned array with size 2 (data Word)                 ;
;                  Point4(x, y): unsigned array with size 2 (data Word)                 ;
;Output(returns): Print string contains 'Square!' or 'Not Square!'                      ;
;                                                                                       ;
;***************************************************************************************;

isSquare PROC
    
   ;unsigned int distance2 = calculateDistance(point1, point2)
   lea si , point1   
   lea di , point2
   CALL calculatedistance
   mov ax , Distance
   mov distance2 , ax  
    
   ;unsigned int distance3 = calculateDistance(point1, point3) 
   lea si , point1   
   lea di , point3
   CALL calculatedistance
   mov ax , Distance
   mov distance3 , ax  
   
   ;unsigned int distance4 = calculateDistance(point1, point4)
   lea si , point1   
   lea di , point4
   CALL calculatedistance
   mov ax , Distance
   mov distance4 , ax 
   
   ;if (distance2 == 0 || distance3 == 0 || distance4 == 0)
   cmp distance2, 0      ;distance2 == 0
   je  L1
   cmp distance3, 0      ;distance3 == 0
   je  L1
   cmp distance4, 0      ;distance4 == 0
   je  L1
    
   ;distance2 == distance3
   mov ax , distance2
   cmp ax , distance3
   je Equal11
   
   ;distance3 == distance4
   L2:
   mov ax, distance3
   cmp ax, distance4      
   je Equal33
   
   ;distance2 == distance4
   L3:
   mov ax , distance2
   cmp ax , distance4      
   je Equal55
   
   
   mov isSquareFlag, 0
   ;To make new line and return cursor to the start
   lea dx, newline
   call Print
   JMP Exit
   
isSquare ENDP

;*****************************************************************************************************;  
;                               DrawRectangle Procedure                                               ;
;Description: Draw Rectangle by stars (*)                                                             ;
;Inputs(receives): First Calculate distance then                                                      ;
;size 1 (distanceHeight1) =  Square root of dictance                                                  ;
;size 2 (distanceWidth1) =  Square root of dictance                                                   ;
;if (outter_counter == 0 ||outter_counter = size1 -1 ||inner_counter ==0 || inner_Counter==size2 -1)  ;
;   print "*"                                                                                         ;
;else                                                                                                 ;
;   print "  "                                                                                        ;
;Output(returns): Print Rectangle                                                                     ;                                                                                                        ;
;*****************************************************************************************************;

DrawRectangle PROC
    mov ax, 0      
    mov bx, 0
    mov cx, 0
    mov dx, 0
    mov si, 0
    mov di, 0
    mov bx, distanceHeight1 
    
    ;this lines to calculate sqr root of any distance
    ;-----------------------------------------------------------------------------
    sqr:
        mov ax,cx
        mul cx
        cmp ax, bx
        jz load
        inc cx
    jnz sqr
    
    load:
    mov [5002], cx   
    
    ;move value of squared element to size
    mov size1, cl
          
    ;----------------------------------------------------------------------------   
    mov cx ,0
    mov bx ,distanceWidth1   
    ;-----------------------------------------------------------------------------
    
    sqr2:
        mov ax, cx
        mul cx
        cmp ax, bx
        jz load2
        inc cx
    jnz sqr2
    
    load2:
    mov [5002], cx   
    
    ;move value of squared element to size
    mov size2, cl                                                                        
    
    ;----------------------------------------------------------------------------  
    lea dx, rectangleShape
    call Print 
    
    ;To make new line and return cursor to the start
    lea dx, newline
    call Print        
    
    ;Outter LOOP to draw rectangle
    ;first move size ->> indicate to number of * of the row
    mov cx, 0
    mov cl, size2  
    
    ;this two lines to have the value to compare with un case of star * 
    mov ax, 0
    mov al, size2   
    dec al
    
    mov dx, 0
    mov dl, size1   
    dec dl         
    
    ;be used as the counter starts from 0 in conditions
    mov ch, 0  
    
    ;Main loop to 
    outterLoop:    
          
        ;to reset inner counter each time of inner loop starts
        mov bh, size1
        
        ; to reset the counter used in comaparsion
        mov bl, 0
        
        innerLoop:      
        
        ; compare if outer conter = 0 to put *
        cmp ch, 0
        je putAsterisk
        
        ;compare if outer conter = size1 -1  to put *
        cmp ch, al
        je putAsterisk
        
        ;compare if inner conter =0 to put *  
        cmp bl, 0
        je putAsterisk
        
        ;compare if inner conter = size2 -1  to put *
        cmp bl, dl
        je putAsterisk
        
        ;else will make uncoditional jump to putstar:
        jmp putOneSpace 
        
        endCondition:
        ;decriment inner counter
        dec bh 
        
        ;check counter > 0
        jnz innerLoop
        
        ;increment counter used to check position to determin * or  ' '       
        inc ch
        
        ;print new line
        putc 0ah 
        putc 0dh
                  
        ;decrement counter  of outter loop
        dec cl
                                     
        ;check counter not equal zero
        jnz outterLoop
        
        JMP Exit

DrawRectangle ENDP

;*********************************************************************************************;
;                                           doFourPoints Procedure                            ;
;Description: First this function test points user add it                                     ;
;recivers:isRectangleFlag                                                                     ;
;         :isSquareFlag                                                                       ;
;returns:                                                                                     ;
;  if isSqureFlag==1                                                                          ;
;      then print"square" >> call drawSqaure                                                  ;
; else if isRectangleFlag == 1                                                                ;
;   then print"Rectangle" >> call drawRectangle                                               ;
; else Print "Unknown"                                                                        ;
;*********************************************************************************************;

doFourPoints PROC    
                
    call print_four_points
    printn
      
    call isSquare 
         
    cmp isSquareFlag, 0        
    jne Square  
    je NotSquare_Rec
    
    JMP Exit 
 
doFourPoints ENDP

;********************************************************************************************************;
;                                             isTriangle Procedure                                       ;
;Description: procedure that determine if the four points make a square by check                         ;
;if the diagonals have the same distance and all ribs are equal.                                         ;
;inputs: distance between each two point from three points.                                              ;
;outputs: srting that comes out if the shape is square or not.                                           ;
;pre: having three points and calculating the distances between each point with the first point.         ;
;********************************************************************************************************;

isTriangle PROC    
    ;Calculate first operation 
    mov ax, point2[2]  
    sub ax, point3[2]    
    mov dx, point1[0] 
    imul dx          
    mov x1, ax       

    ;Calculate second operation
    mov ax, point3[2]  
    sub ax, point1[2]   
    mov dx, point2[0]     
    imul dx            
    mov x2, ax 

    ;Calculate second operation
    mov ax, point1[2] 
    sub ax, point2[2] 
    mov dx, point3[0] 
    imul dx        
    mov x3, ax

    ;Calculate area  
    mov ax, x1
    mov bx, x2
    add ax, bx
    add ax, x3
    mov area, ax 

    JMP Exit 
isTriangle ENDP 


;***************************************************************************************************************;
;                                             drawTriangle Procedure                                            ;
;Description: procedure that draw a triangle with stars after the program comes out that the shape is triangle. ;  
;inputs: if the shape is triangle.                                                                              ;
;outputs: triangle shaped with stars.                                                                           ;
;pre: IsTriangle procedure comes out that the shape is triangle.                                                ;
;***************************************************************************************************************;

drawTriangle PROC
    full_counter:
    mov cx, outs      ;put num of external spaces
    
    outer_tri:
    mov ah, 2
    mov dl, space
    int 21h 
    
    loop outer_tri
    
    mov ah, 2         ;print star 
    mov dl, '*'
    int 21h
    
    cmp row, 7
    je break_line
    mov cx, ins       ;put num of internal spaces
    
    inner_tri:
    mov ah, 2
    mov dl, space
    int 21h
    
    loop inner_tri   ;will not run at the first& second row >> cause cx= -1 || 0
    
    mov ah, 2         ;print star in the other side
    mov dl, '*'
    int 21h
    
    break_line:      ;new line if this the first row
    mov ah, 9          
    lea dx, newline
    int 21h
    
    cmp row, 1
    je full          ;if this the last row full the counter of stars
    jne plus         ;if it isn't the last row increase the internal spaces 
    
    full:
    mov cx, 15        ;put num of stars in the last line
    
    stars:           ;to print the last line **********
    mov ah, 2
    mov dl, '*'
    int 21h
    
    loop stars
    jmp finish
    
    plus:
    inc ins
    inc ins
    dec outs
    dec row
    jmp full_counter
    
    finish:
        ret
        
drawTriangle endp  

;********************************************************************************************************;
;                                             doThreePoints Procedure                                    ;
;Desciption: first call isTriangle procedure to check if three points is triangle or not                 ;
;then if is a triangle call drawTriangle procedure to draw triangle                                      ;   
;********************************************************************************************************;

doThreePoints PROC 
    
    call print_three_points     ;call print_three_points procedure to print points
    
    call isTriangle
    lea dx, newline
    call Print                   
    
    cmp area, 0                 ;compare area with zero to check if the three points are triangle or not
    jne triangle                ;if area not equal to 0 jmp to triangle label to print massage of it is a triangle
    je not_triangle             ;if area equal to 0 jmp to not_triangle label to print massage of it is a triangle
    
    triangle:
    lea dx, triangleShape
    call Print
    
    lea dx, newline
    call Print
    lea dx, newline
    call Print
    
    call drawTriangle 
    jmp exit
    
    not_triangle:
    lea dx, unKnownString
    call Print
    
    lea dx, newline
    call Print
    
    JMP Exit      
    
doThreePoints ENDP

;********************************************************************************************************;

isFour:
    CALL get_four_points
    CALL doFourPoints

    JMP Exit  

;********************************************************************************************************;

isThree:
    CALL get_three_points
    CALL doThreePoints

    JMP Exit

;********************************************************************************************************;
    
noRightOption:
    ;To make new line and return cursor to the start
    lea dx, newline
    call Print
    
    lea dx, Error
    call Print
    
    ;To make new line and return cursor to the start
    lea dx, newline
    call Print
    
    JMP again
    JMP Exit

;********************************************************************************************************;

;used to print * when conditions is true         
putAsterisk:
print '* '

;increment inner loop counter 
inc bl  

;unconditional jump to continue 
jmp endCondition 

;used to print * when all conditions is false
putOneSpace:

;increment inner loop counter 
inc bl

;unconditional jump to continue 
print '  '
 
jmp endCondition             

;********************************************************************************************************;

L1:
   mov ax , 0 
   JMP Exit
               
;********************************************************************************************************;   

Equal11:                  ;(2 * distance2 == distance4)

   mov ax , distance2
   add ax , ax            ;2 * distance2
   cmp distance4 , ax     ;2 * distance2 == distance4
   je  Equal2
   
;********************************************************************************************************;

Equal22:                  ;(2 * calculateDistance(point2, point4) == calculateDistance(point2, point3))

   mov si , point4
   mov di , point2
   CALL calculatedistance
   add ax , ax
   lea bx , ax            ;2 * calculateDistance(point2, point4)   
   mov dx ,point3
   mov ax ,point2
   call calculatedistance
   cmp bx,ax              ;2 * calculateDistance(point3, point2) == calculateDistance(point3, point4))
   mov ax , 1 
       
   je printYes
     
;********************************************************************************************************;   

Equal33:                 ;(2 * distance3 == distance2)

   mov ax , distance3
   add ax , ax          ; 2 * distance3
   cmp distance2,ax
   je Equal44
   
;********************************************************************************************************;   

Equal44:                ;(2 * calculateDistance(point3, point2) == calculateDistance(point3, point4))

   mov si , point2
   mov di , point3
   CALL calculatedistance
   add ax , ax         ;2 * calculateDistance(point3, point2)
   mov dx , point4
   mov ax , point3
   CALL calculatedistance
   cmp bx , ax
   mov ax ,1
   
   je printYes  
   
;********************************************************************************************************;   

Equal55:    

   mov ax, distance2   ;(2 * distance2 == distance3)
   add ax, ax          ;2 * distance2
   cmp distance3 , ax
   je Equal66
   
;********************************************************************************************************;   

Equal66:                ;(2 * calculateDistance(point2, point3) == calculateDistance(point2, point4))
   mov si , point2
   mov di , point3
   CALL calculatedistance
   add ax , ax         ;2 * calculateDistance(point2, point3)
   mov dx , point2
   mov ax , point4
   CALL calculatedistance
   cmp bx , ax
   
   mov ax ,1
   je printYes
   
;********************************************************************************************************;

printYes:              
   mov isSquareFlag, 1 
   ;To make new line and return cursor to the start
   lea dx, newline
   call Print
   
   JMP Exit 
   
;********************************************************************************************************;                    

;if any condition is false, then this label will excute
Stop:
    mov isRectangleFlag, 0
    
    JMP Exit 
    
;********************************************************************************************************;           

Square:
    lea dx, newline
    call Print
    
    call DrawSquare
     
    JMP Exit

;********************************************************************************************************;
      
NotSquare_Rec: 
    call isRectangle
    cmp isRectangleFlag, 0
    jne Rectangle
    je unknown
     
    JMP Exit 
;********************************************************************************************************;

Rectangle:  
    lea dx, newline
    call Print
    call DrawRectangle  
    
    JMP Exit

;********************************************************************************************************;
 
unknown:
    lea dx, newline
    call Print
    
    lea dx, unKnownString
    call Print

    JMP EXIT

;********************************************************************************************************;

;output of a string at DS:DX. String must be terminated by '$'
Print:  
    mov ah, 9
    int 21h   
    JMP Exit

;********************************************************************************************************;    

define_print_num_uns 
define_scan_num
    
;********************************************************************************************************;                   

Exit: RET

;********************************************************************************************************;

END
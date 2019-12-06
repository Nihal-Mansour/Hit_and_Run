.Model COMPACT
.386
.Stack 64
.Data
include inout.inc

y_old DW ?
gridWidth EQU 320
gridHeight EQU 144

gridFilename DB 'grid.img', 0
gridFilehandle DW ?
gridData DB gridWidth*gridHeight dup(2)

bomerWidth EQU 16
bomerHeight EQU 16


bomerFilename DB 'bomer.img', 0
bomerFilehandle DW ?
bomerData DB bomerWidth*bomerHeight dup(2)

bomberx DW 16
bomberY DW 32

bombFilename DB 'bomb.img', 0
bombFilehandle DW ?
bombData DB bomerWidth*bomerHeight dup(2)



		y_old DW ?
		gridWidth EQU 320
		gridHeight EQU 144
		
		gridFilename DB 'grid.img', 0
		gridFilehandle DW ?
		gridData DB gridWidth*gridHeight dup(2)
		
		imagewidth EQU 16
		imageheight EQU 16
		
		
		bomerFilename DB 'bomer.img', 0
		bomerFilehandle DW ?
		bomerData DB imagewidth*imageheight dup(2)
		
		bomberx DW 16
		bomberY DW 32
		
		bombFilename DB 'bomb.img', 0
		bombFilehandle DW ?
		bombData DB imagewidth*imageheight dup(2)
		
		
		bombrightFilename DB 'bombrit.img', 0
		bombrightFilehandle DW ?
		bombrightData DB imagewidth*imageheight dup(2)
		
		bombleftFilename DB 'bombleft.img', 0
		bombleftFilehandle DW ?
		bombleftData DB imagewidth*imageheight dup(2)
		
		bombupFilename DB 'bombup.img', 0
		bombupFilehandle DW ?
		bombupData DB imagewidth*imageheight dup(2)
		
		bombdownFilename DB 'bombdown.img', 0
		bombdownFilehandle DW ?
		bombdownData DB imagewidth*imageheight dup(2)
		
		coinFilename DB 'coin.img', 0
		coinFilehandle DW ?
		coinData DB imagewidth*imageheight dup(2)
		
		;heartFilename DB 'bombdown.img', 0
		;heartFilehandle DW ?
		;heartData DB imagewidth*imageheight dup(2)
		
		
		; set bit in Most signeficant bit refers to block (forbidden movement)
		X EQU 10000000b ;128
		B EQU 10000001b ;129
		G EQU 0
		P EQU 'P'
		Q EQU 'Q'
		B1 EQU 5
		B2 EQU 6
		C EQU 7
		H EQU 8
		
		C_B EQU C or B
		H_B EQU C or B
		
		;  	    0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18  19
		grid DB X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X
		 DB X , G , G , B , B , B , B , B , B , B , B , B , B , B , B , B , B , B , B , X                                                                  
		 DB X , G , X , B , X , G , X , B , X , G , G , X , B , X , G , X , B , X , G , X           
		 DB X , B , B , B , B , B , B , B , B , B , B , B , B , B , B , B , B , B , B , X                                                                                       
		 DB X , G , X , B , X , G , X , B , X , G , G , X , B , X , G , X , B , X , G , X                                                                                     
		 DB X , B , B , B , B , B , B , B , B , B , B , B , B , B , B , B , B , B , B , X                                                               
		 DB X , G , X , B , X , G , X , B , X , G , G , X , B , X , G , X , B , X , G , X                                                                                    
		 DB X , B , B , B , B , B , B , B , B , B , B , B , B , B , B , B , B , G , G , X                                                                    
		 DB X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X


	PUBLIC bombrightData
	PUBLIC bombleftData
	PUBLIC bombUpData
	PUBLIC bombDownData



.Code



MAIN PROC FAR
		MOV AX , @DATA
		MOV DS , AX
		
		MOV AH, 0
		MOV AL, 13h
		INT 10h
	
		bomb struc
			bombx dw 0
			bomby dw 0
			to_be_drawn db 0
			counter db 0
		bomb ends
		
		bomb1 bomb<>
	 
clearBlock MACRO x , y
		local sketch

		MOV CX,x
		MOV DX,y
		MOV DI,x
		MOV SI, y
		ADD DI , 16
		ADD SI , 16
		MOV AH,0ch
	
	
; Drawing loop
sketch:
		MOV AL,02h
		INT 10h 
		INC CX
		CMP CX,DI
JNE sketch 
	
		MOV CX , x
		INC DX
		CMP DX , SI
JNE sketch

ENDM clearBlock

updategrid macro objectx,objecty,object
			
			
		pusha 
		mov ax , objecty
		mov bx , objectx
		call find1Darray 
		mov al,object
		mov  DS:[BP][di],al
		popa
			
			

endm updategrid	



drawpic macro x,y,imageData

LEA BX , imageData ; BL contains index at the current drawn pixel
	
		pusha
		mov si ,x
		mov bp ,x
		mov di,y
		MOV CX,x ; x1
		MOV DX,y ; y1
		call drawpixel 
		popa
		
endm drawpic 




		call loadimages
		;;;;;;;;;;;;;;;;;draw grid;;;;;;;;;;;;;;;;;;;;
		
		MOV AH,0ch
		MOV CX , 0
		MOV DX , 0
	
		
		LEA BX , gridData ; BL contains index at the current drawn pixel
	
		MOV CX,0 ; x1
		MOV DX,16 ; y1
		MOV AH,0ch
	
	
; Drawing loop
drawLoop:

		MOV AL,[BX]
		INT 10h 
		INC CX
		INC BX
		CMP CX,320 
JNE drawLoop 
	
		MOV CX , 0
		INC DX
		CMP DX , 160
JNE drawLoop


;;;;;;;;;;;;;;;;;;;;;;draw pomerman;;;;;;;;;;;;;;;;;;;;;;;;

	drawpic bomberx,bomberY,bomerData
    writescore1 0000
	writescore2 0000
	writeheart1 3
	writeheart2 3

		drawpic bomberx,bomberY,bomerData
	
		
		LEA bp , grid	
		___label:
		
		call checkkeypressed
		
		
		jmp ___label

;Press any key to exit
		MOV AH , 0
		INT 16h
  

;Change to Text MODE
		MOV AH,0     
		MOV AL,03h
		INT 10h 

; return control to operating system
		MOV AH , 4ch
		INT 21H
  
MAIN ENDP


drawpixel proc

		MOV AH,0ch
		add si,16
		add di,16
; Drawing loop
drawLoop1:

		MOV AL,[BX]
		INT 10h 
		INC CX
		INC BX
		CMP CX,si 
JNE drawLoop1 
	
		MOV CX , bp
		INC DX
		CMP DX , di
JNE drawLoop1

		RET
		
drawpixel endp



checkkeypressed PROC 
            mov ah , 0
            int 16h
            cmp ah , 72
            jz isup
            cmp ah , 80
            jz isdown
            cmp ah , 77
            jz tempright
            cmp ah , 75
            jz temp2
            cmp ah , 57
			jz space
            jmp tempfinish1
                
isup:
			mov ax , bomberY
			mov y_old , ax
			
			mov ax , bomberY
			mov bx , bomberX
			sub ax , 16
			call find1Darray 
			mov dl , DS:[BP][di]
			shl dl ,1      ;shift to check if it's a block or brick
			jc temp3    ;don't draw
			
			sub bomberY , 16
			
			
			
			cmp bomb1.to_be_drawn,1
			jne nodraw
			drawpic bomb1.bombx , bomb1.bomby , bombData
			mov bomb1.to_be_drawn ,0
	
			drawpic bomberx,bomberY,bomerData
			jmp finish
			
nodraw:
			clearblock bomberX , y_old
			drawpic bomberx,bomberY,bomerData
			
temp3:
			jmp finish
temp2: 		jmp temp
tempright:  jmp isright
isdown:
			mov ax , bomberY
			mov y_old , ax
			
			mov ax , bomberY
			mov bx , bomberX
			add ax , 16
			call find1Darray
			mov dl , DS:[BP][di]
			shl dl,1
			jc temp4
			
			add bomberY , 16
			
			
			cmp bomb1.to_be_drawn,1
			jne nodraw1
			drawpic bomb1.bombx , bomb1.bomby , bombData
			mov bomb1.to_be_drawn ,0
			
			drawpic bomberx,bomberY,bomerData
			jmp finish
nodraw1:
			
			clearblock bomberX , y_old
			drawpic bomberx,bomberY,bomerData
temp4:
			jmp finish
tempfinish1:jmp tempfinish2
temp: 		jmp isleft
isright:
			mov ax , bomberX
			mov y_old , ax
			
			mov ax , bomberY
			mov bx , bomberX
			add bx , 16
			call find1Darray
			mov dl , DS:[BP][di]
			shl dl,1
			jc temp5
			add bomberX , 16
			
			
			cmp bomb1.to_be_drawn,1
			jne nodraw3
			drawpic bomb1.bombx , bomb1.bomby , bombData
			mov bomb1.to_be_drawn ,0
			
			drawpic bomberx,bomberY,bomerData
			jmp finish
nodraw3:
			
		
			clearblock y_old , bomberY
			drawpic bomberx,bomberY,bomerData
temp5:			
			jmp finish
tempfinish2:jmp finish
isleft: 
			mov ax , bomberX
			mov y_old , ax
			
			mov ax , bomberY
			mov bx , bomberX
			sub bx , 16
			call find1Darray
			mov dl , DS:[BP][di]
			shl dl,1
			jc finish
			sub bomberX , 16
			
			
			cmp bomb1.to_be_drawn,1
			jne nodraw4
			drawpic bomb1.bombx , bomb1.bomby , bombData
			mov bomb1.to_be_drawn ,0
			
			drawpic bomberx,bomberY,bomerData
			jmp finish
nodraw4:
			
			
			clearblock y_old , bomberY
			drawpic bomberx,bomberY,bomerData
			jmp finish
space:			
			
            mov ax, bomberx
			mov bomb1.bombx , ax
			mov ax, bombery
			mov bomb1.bomby , ax
			;GetCurrentTime bomb1.to_be_drawn
			mov bomb1.to_be_drawn , 1
		
			updategrid bomberX , bomberY , B1
			;don't forget to ubdate the grid to ground
			
			
			
			
finish:            
			RET
checkkeypressed ENDP

find1Darray PROC
            ;sub al , 16  ;Y
         INC AX
         INC BX
		 
		 shr ax , 1
		 shr ax , 1
		 shr ax , 1
		 shr ax , 1
		 
		 shr  bx , 1
		 shr  bx , 1
		 shr  bx , 1
		 shr  bx , 1
		 	             
		 DEC AX
			   
			             
         mov cx , 20 ; 320/16
         mul cx
         add ax , bx;bx = y

         mov di , ax
			
            RET
find1Darray ENDP

loadimages proc
        ;;;;;;;;;;;;;;load grid;;;;;;;;;;;;;;;;
		callOpenFile gridFilename,gridFilehandle
		callLoadData gridFilehandle,gridData,gridWidth,gridHeight
		callCloseFile gridFilehandle
        ;;;;;;;;;;;;;;load bomb;;;;;;;;;;;;;;;;		
		callOpenFile bombFilename,bombFilehandle
		callLoadData bombFilehandle,bombData,imagewidth,imageheight
		callCloseFile bombFilehandle
        ;;;;;;;;;;;;;;load bomberman;;;;;;;;;;;;;;;;;;;;;;;;
		callOpenFile bomerFilename,bomerFilehandle
		callLoadData bomerFilehandle,bomerData,imagewidth,imageheight
		callCloseFile bomerFilehandle
		
		;;;;;;;;;;;;;;;load bomb right;;;;;;;;;;;;;;;;;;;;;;;;
		callOpenFile bombrightFilename,bombrightFilehandle
		callLoadData bombrightFilehandle,bombrightData,imagewidth,imageheight
		callCloseFile bombrightFilehandle
		;;;;;;;;;;;;;;;load bomb left;;;;;;;;;;;;;;;;;;;;;;;;
		callOpenFile bombleftFilename,bombleftFilehandle
		callLoadData bombleftFilehandle,bombleftData,imagewidth,imageheight
		callCloseFile bombleftFilehandle
		;;;;;;;;;;;;;;load bomb up;;;;;;;;;;;;;;;;;;;;;;;;
		callOpenFile bombupFilename,bombupFilehandle
		callLoadData bombupFilehandle,bombupData,imagewidth,imageheight
		callCloseFile bombupFilehandle
		;;;;;;;;;;;;;;;load bomb down;;;;;;;;;;;;;;;;;;;;;;;;
		callOpenFile bombdownFilename,bombdownFilehandle
		callLoadData bombdownFilehandle,bombdownData,imagewidth,imageheight
		callCloseFile bombdownFilehandle
		
		;;;;;;;;;;;;;;;load coin ;;;;;;;;;;;;;;;;;;;;;;;;
		callOpenFile coinFilename,coinFilehandle
		callLoadData coinFilehandle,coinData,imagewidth,imageheight
		callCloseFile coinFilehandle
		
		;;;;;;;;;;;;;;;;load heart ;;;;;;;;;;;;;;;;;;;;;;;;
		;callOpenFile bombdownFilename,bombdownFilehandle
		;callLoadData bombdownFilehandle,bombdownData,imagewidth,imageheight
		;callCloseFile bombdownFilehandle
		
		ret

loadimages endp

END MAIN



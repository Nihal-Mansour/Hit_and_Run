; This file displays the welcome screen
; i.e. WELCOME TO HIT AND RUN

.MODEL SMALL
.STACK 2048
.386 ; sets the instruction set of 80386 processor

; These procedures are public
; i.e. can be called from another assembly file
PUBLIC displayWelcomeScreen

; These are External Procedures in draw.asm
; The linker will join them
EXTRN drawColumnUp:NEAR
EXTRN drawColumnDown:NEAR
EXTRN drawRowLeft:NEAR
EXTRN drawRowRight:NEAR

; shows the effect of drawing letters on the screen
EXTRN letterDrawingSpeed:BYTE ; MIN value is 1

INCLUDE colors.inc
INCLUDE alphabet.inc
INCLUDE inout.inc

.DATA

	message DB "Press any key to Continue",'$'
	
	; Sizes for letters :
	; extra large , large , medium , small , extra small
	LINE_WIDTH_XL EQU 8
	LINE_WIDTH_L EQU 6
	LINE_WIDTH_M EQU 4
	LINE_WIDTH_S EQU 2
	LINE_WIDTH_XS EQU 1

	; for WELCOME word
	START_X1 EQU 80
	START_Y1 EQU 10

	; for TO word
	START_X2 EQU 140
	START_Y2 EQU 60

	; for HIT , RUN words
	START_X3 EQU 20
	START_Y3 EQU 100

	; for AND word
	START_X4 EQU 140
	START_Y4 EQU 110

	; for Press any key to Continue
	START_X5 EQU 7
	START_Y5 EQU 150

.CODE

displayWelcomeScreen PROC

	callSwitchToGraphicsMode

	MOV letterDrawingSpeed , 60

	; WARNING: DO NOT PUT SPACES BETWEEN ANY OPERAND IN THE SAME PARAMETER
	; IT WILL TREAT IT AS TWO PARAMETERS AND GIVE ERRORS
	; EX: START_X1+6*LINE_WIDTH_M -> START_X1 + 6 * LINE_WIDTH_M
	
	draw_W COLOR_LIGHT_GREEN , START_X1                 , START_Y1 , LINE_WIDTH_M
	draw_E COLOR_LIGHT_GREEN , START_X1+6*LINE_WIDTH_M  , START_Y1 , LINE_WIDTH_M
	draw_L COLOR_LIGHT_GREEN , START_X1+12*LINE_WIDTH_M , START_Y1 , LINE_WIDTH_M
	draw_C COLOR_LIGHT_GREEN , START_X1+18*LINE_WIDTH_M , START_Y1 , LINE_WIDTH_M
	draw_O COLOR_LIGHT_GREEN , START_X1+24*LINE_WIDTH_M , START_Y1 , LINE_WIDTH_M
	draw_M COLOR_LIGHT_GREEN , START_X1+30*LINE_WIDTH_M , START_Y1 , LINE_WIDTH_M
	draw_E COLOR_LIGHT_GREEN , START_X1+36*LINE_WIDTH_M , START_Y1 , LINE_WIDTH_M
	
	draw_T COLOR_LIGHT_ORANGE , START_X2                 , START_Y2 , LINE_WIDTH_S
	draw_O COLOR_LIGHT_ORANGE , START_X2+12*LINE_WIDTH_S , START_Y2 , LINE_WIDTH_S
	
	draw_H COLOR_DARK_RED , START_X3                 , START_Y3 , LINE_WIDTH_L
	draw_I COLOR_DARK_RED , START_X3+6*LINE_WIDTH_L  , START_Y3 , LINE_WIDTH_L
	draw_T COLOR_DARK_RED , START_X3+12*LINE_WIDTH_L , START_Y3 , LINE_WIDTH_L
	
	draw_A COLOR_LIGHT_ORANGE , START_X4                 , START_Y4 , LINE_WIDTH_S
	draw_N COLOR_LIGHT_ORANGE , START_X4+6*LINE_WIDTH_S  , START_Y4 , LINE_WIDTH_S
	draw_D COLOR_LIGHT_ORANGE , START_X4+12*LINE_WIDTH_S , START_Y4 , LINE_WIDTH_S
	
	draw_R COLOR_LIGHT_BLUE , START_X3+30*LINE_WIDTH_L , START_Y3 , LINE_WIDTH_L
	draw_U COLOR_LIGHT_BLUE , START_X3+36*LINE_WIDTH_L , START_Y3 , LINE_WIDTH_L
	draw_N COLOR_LIGHT_BLUE , START_X3+42*LINE_WIDTH_L , START_Y3 , LINE_WIDTH_L
	
	callSetCursorPosition START_X5 , START_Y5
	callPrintString message
	callWaitForAnyKey

	RET
displayWelcomeScreen ENDP

END
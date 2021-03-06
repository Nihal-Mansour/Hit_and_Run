

backupGridData MACRO
	MOV BX , 0
	
	_label_backupGridData_loop:

		MOVZX AX , DS:[grid][BX]
		PUSH AX
		INC BX
	
	CMP BX , GRID_WIDTH * GRID_HEIGHT
	JNE _label_backupGridData_loop

ENDM backupGridData


restoreGridData MACRO

	MOV BX , GRID_WIDTH * GRID_HEIGHT -1
	_label_restoreGridData_loop:

		POP AX
		MOV DS:[grid][BX] , AL
		DEC BX
	
	CMP BX , -1
	JNE _label_restoreGridData_loop

ENDM restoreGridData


callUpdateGrid MACRO x1 , y1 , newData
	PUSHA

	MOV BX , x1
	MOV AX , y1
	MOV CL , newData

	CALL updateGrid

	POPA
ENDM callUpdateGrid



; Parameters:
; BX -> X
; AX -> Y
callExplodeBlock MACRO whoseBomb
	PUSHA

	MOV DL , whoseBomb

	CALL explodeBlock

	POPA
ENDM callExplodeBlock



callExplodeBomb MACRO bomb , whoseBomb
	PUSHA
	MOV bomb.to_be_drawn , false
	
	MOV BX , bomb.bomb_x
	MOV AX , bomb.bomb_y

	MOV CL , bomb.level
	MOV DL , whoseBomb

	CALL explodeBomb

	POPA
ENDM callExplodeBomb


callTakePowerupIfAny_Player1 MACRO PowerupType
	PUSH CX

		MOV CL , PowerupType
		CALL takePowerupIfAny_Player1

	POP CX
ENDM callTakePowerupIfAny_Player1


callMoveIfAvailable_Player1 MACRO direction
	PUSHA

		LEA BP , direction
		CALL moveIfAvailable_Player1

	POPA
ENDM callMoveIfAvailable_Player1


callTakePowerupIfAny_Player2 MACRO PowerupType
	PUSH CX

		MOV CL , PowerupType
		CALL takePowerupIfAny_Player2

	POP CX
ENDM callTakePowerupIfAny_Player2


callMoveIfAvailable_Player2 MACRO direction
	PUSHA

		LEA BP , direction
		CALL moveIfAvailable_Player2

	POPA
ENDM callMoveIfAvailable_Player2

.data
newline: .asciiz "\n"
msgError: .asciiz "Arquivo Invalido, favor colocar um nome de ate 20 caracteres incluindo um .txt de extensao no final ou digite \"getout\" para sair."
#dependendo do arquivo, o caminho absoluto precisa de barras duplas ou simples.
filePath: .asciiz "C:\Users\DarlanReisdaSilva\Desktop" #altere o caminho para onde estarão os arquivos de entrada XXX.txt
.align 2
fileAddress: .space 4 #Variavel para salvar a posicao da concatenacao de string com o path.
.align 0
fileBarraDupla: .byte 0 #Coloque byte 0 se o seu sistema de arquivos abre com barra simples.
fileNameBuffer: .space 100
fileNameOut: .space 100
fileIn: .space 2600
fileOut: .space 2600
bufferName: .space 25
getoutConst: .asciiz "getout"
.align 4 #deixar bonitinho pra ler no SPIM
bucketA: .space 2604
bucketB: .space 2604
bucketC: .space 2604
bucketD: .space 2604
bucketE: .space 2604
bucketF: .space 2604
bucketG: .space 2604
bucketH: .space 2604
bucketI: .space 2604
bucketJ: .space 2604
bucketK: .space 2604
bucketL: .space 2604
bucketM: .space 2604
bucketN: .space 2604
bucketO: .space 2604
bucketP: .space 2604
bucketQ: .space 2604
bucketR: .space 2604
bucketS: .space 2604
bucketT: .space 2604
bucketU: .space 2604
bucketV: .space 2604
bucketW: .space 2604
bucketX: .space 2604
bucketY: .space 2604
bucketZ: .space 2604
lenght: .word 2604
lenghtEach: .word 26
.text
.align 0
.globl main

main:

jal readFile
jal bucketInit
jal divideBuckets

la $a0, bucketA
jal bubbleSort
la $a0, bucketB
jal bubbleSort
la $a0, bucketC
jal bubbleSort
la $a0, bucketD
jal bubbleSort
la $a0, bucketE
jal bubbleSort
la $a0, bucketF
jal bubbleSort
la $a0, bucketG
jal bubbleSort
la $a0, bucketH
jal bubbleSort
la $a0, bucketI
jal bubbleSort
la $a0, bucketJ
jal bubbleSort
la $a0, bucketK
jal bubbleSort
la $a0, bucketL
jal bubbleSort
la $a0, bucketM
jal bubbleSort
la $a0, bucketN
jal bubbleSort
la $a0, bucketO
jal bubbleSort
la $a0, bucketP
jal bubbleSort
la $a0, bucketQ
jal bubbleSort
la $a0, bucketR
jal bubbleSort
la $a0, bucketS
jal bubbleSort
la $a0, bucketT
jal bubbleSort
la $a0, bucketU
jal bubbleSort
la $a0, bucketV
jal bubbleSort
la $a0, bucketW
jal bubbleSort
la $a0, bucketX
jal bubbleSort
la $a0, bucketY
jal bubbleSort
la $a0, bucketZ
jal bubbleSort
jal concatenateOnFileOut
jal openWriteFile
jal writeFile

jal cleanFileOut
jal cleanFileIn
jal cleanFileNameBuffer

j main

readFile:
	addi $sp, $sp, -4 #salvar return address na pilha
	sw $ra, 0($sp)

	#carregando constante de barra dupla
	lb $t4, fileBarraDupla

	#loop copiando o caminho do arquivo absoluto
	la $t0, filePath
	la $t2, fileNameOut
	la $t5, fileNameBuffer

	#loop de copia do path para arquivos de entrada e saída
	pathLoop:
		lb $t3, 0($t0)
		sb $t3, 0($t2) #"XXX.txt" de saída
		sb $t3, 0($t5) #"XXX.txt" de entrada
		addi $t0, $t0, 1
		addi $t2, $t2, 1
		addi $t5, $t5, 1
		bne $t3, $zero, pathLoop
		
	addi $t3, $zero, 92 # t3 = '\'
	sb $t3, -1($t5) #trocando \0 pelo \
	beqz $t4, semBarraDuplaIn # "bool" de checagem se precisa de 1 ou 2 barras, (MAC e Linux precisam de 2 barras, Windows de 1 barra)
	sb $t3, 0($t5) #adicionando barra dupla
	addi $t5, $t5, 1
	semBarraDuplaIn:
	
	#salvar o endereco do path de input para escrever de la depois
	sw $t5, fileAddress
	
	#adicionando o 'saida.txt' no final do output
	addi $t2, $t2, -1 #para tirar o \0
	addi $t3, $zero, 92 #\
	sb $t3,0($t2)

	beqz $t4, semBarraDuplaOut
	addi $t2, $t2, 1 #para barra dupla
	sb $t3, 0($t2)
	semBarraDuplaOut:

	addi $t3, $zero, 115 #s
	sb $t3, 1($t2)
	addi $t3, $zero, 97 #a
	sb $t3, 2($t2)
	addi $t3, $zero, 105 #i
	sb $t3, 3($t2)
	addi $t3, $zero, 100 #d
	sb $t3, 4($t2)
	addi $t3, $zero, 97 #a
	sb $t3, 5($t2)
	addi $t3, $zero, 46 #.
	sb $t3, 6($t2)
	addi $t3, $zero, 116 #t
	sb $t3, 7($t2)
	addi $t3, $zero, 120 #x
	sb $t3, 8($t2)
	addi $t3, $zero, 116 #t
	sb $t3, 9($t2)
	add $t3, $zero, $zero #\0
	sb $t3, 10($t2)

	#Comentado para nao printar o que nao for necessario
	#li $v0, 4
	#la $a0, msgIn
	#syscall
	
	li $v0, 8
	lw $a0, fileAddress #Carregar o endereco do arquivo de entrada
	li $a1, 20
	syscall

	addi $t1, $zero, 10

	newlineKiller: #read string coloca um \n no final no nome do arquivo. nos realmente nao queremos esse \n. ele devera ser erradicado da memoria imediatamente.
	lb $t0, 0($a0)
	addi $a0, $a0, 1
	bne $t0, $t1, newlineKiller
	add $t0, $zero, $zero
	sb $t0, -1($a0)
	
	#checando se o usuario entrou com getout

	#'getout' check
	lw $a0, fileAddress #Pegar o endereco do arquivo de entrada
	la $a1, getoutConst
	jal strcmp
	beqz $v0, getoutInput

	#ler arquivo

	li $v0, 13 #file_open
	#como o \0 do Path fora removido, esse endereco e um vetor de chars ate a ponta do input do usuario
	la $a0, fileNameBuffer
	li $a1, 0 #read flag
	li $a2, 0 #ignored
	syscall

	bltz $v0, openError
	#a0 already has bufferName
	move $s0, $v0 #pelo resto do código, exceto dentro do bubblesort, s0 irá carregar o file descriptor de abertura
	move $a0, $s0 #a0 = file descriptor (para syscall 14)
	
	li $v0, 14
	la $a1, fileIn
	lw $a2, lenght
	syscall
	
	li $v0, 16 #fecha arquivo de leitura
	syscall

	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

getoutInput:
	
	addi $sp, $sp, 4
	j exit
	
openWriteFile: # abertura do arquivo de saída (saida.txt)

	li $v0, 13 #file_open
	la $a0, fileNameOut
	li $a1, 9 #write and append flag
	li $a2, 0 #ignored
	#a0 already has bufferName
	syscall
	bltz $v0, openWriteFileError
	move $s1, $v0 # $s1 = file descriptor do arquivo de escrita (análogo ao s0, s1 carrega o descriptor de entrada pelo resto do codigo, exceto durante o bubble sort)
	jr $ra
	
closeWriteFile:

	#a0 ja possui o file descriptor
	li $v0, 16
	syscall
	jr $ra
	
writeFile:

	move $a0, $s1 #a0 = file descriptor (para syscall 15)
	li $t1, 0
	la $s0, fileOut
	#li $t2, 220
	writeFileLoop: #conta quantos caracteres deverão ser escritos no arquivo de saída
		lb $t0, 0($s0)
		beqz $t0, outWriteFileLoop
		addiu $s0, $s0, 1
		addi $t1, $t1, 1
		j writeFileLoop
	outWriteFileLoop:
	
	li $v0, 15
	la $a1, fileOut
	move $a2, $t1
	syscall

	jr $ra

openError:
	addi $sp, $sp, 4
	li $v0, 4
	la $a0, msgError
	la $a0, msgError
	syscall
	j main
	
openWriteFileError:
	li $v0, 4
	la $a0, msgError
	la $a0, msgError
	syscall
	j main

bucketInit: # todos os buckets tem um "0" nos primeiros 4 bytes para contar o numero de palavras

	li $t0, 0
	la $t1, bucketA 
	sw $t0, 0($t1)
	la $t1, bucketB
	sw $t0, 0($t1)
	la $t1, bucketC
	sw $t0, 0($t1)
	la $t1, bucketD
	sw $t0, 0($t1)
	la $t1, bucketE
	sw $t0, 0($t1)
	la $t1, bucketF
	sw $t0, 0($t1)
	la $t1, bucketG
	sw $t0, 0($t1)
	la $t1, bucketH
	sw $t0, 0($t1)
	la $t1, bucketI
	sw $t0, 0($t1)
	la $t1, bucketJ
	sw $t0, 0($t1)
	la $t1, bucketK
	sw $t0, 0($t1)
	la $t1, bucketL
	sw $t0, 0($t1)
	la $t1, bucketM
	sw $t0, 0($t1)
	la $t1, bucketN
	sw $t0, 0($t1)
	la $t1, bucketO
	sw $t0, 0($t1)
	la $t1, bucketP
	sw $t0, 0($t1)
	la $t1, bucketQ
	sw $t0, 0($t1)
	la $t1, bucketR
	sw $t0, 0($t1)
	la $t1, bucketS
	sw $t0, 0($t1)
	la $t1, bucketT
	sw $t0, 0($t1)
	la $t1, bucketU
	sw $t0, 0($t1)
	la $t1, bucketV
	sw $t0, 0($t1)
	la $t1, bucketW
	sw $t0, 0($t1)
	la $t1, bucketX
	sw $t0, 0($t1)
	la $t1, bucketY
	sw $t0, 0($t1)
	la $t1, bucketZ
	sw $t0, 0($t1)
	
	jr $ra
	
bubbleSort:

	addi $sp, $sp, -24
	sw $a0, 0($sp)
	sw $ra, 4($sp)
	sw $s0, 8($sp)
	sw $s1, 12($sp)
	sw $s2, 16($sp)
	sw $s3, 20($sp)
	
	lw $s1, 0($a0)
	li $t5, 1
	beq $s1, $t5, exitBubble #nao realiza bubblesort se so tem 1 nome no bucket
	li $s0, 0 		# j do loop interno do bubblesort for(j=0; j<i; j++)
	mul $s1, $s1, 26
	#lw $s1, 0($s1) 		# constante do tamanho do balde total
	move $s2, $a0 		# salvando endereco $a0
	addiu $s2, $s2, 4
	la $a2, lenghtEach
	lw $a2, 0($a2) 		#constante do tamanho de cada string
	sub $s3, $s1, $a2 	# i do loop externo do bubblesort for(i=tamanho-1; i>0; i--)

firstBubbleLoop:
	
	move $a0, $s2		#voltar o ponteiro do vetor
	li $s0, 0		#iniciar o for

secondBubbleLoop:
	
	add $a1, $a0, $a2	#pegar a proxima string
	jal strcmp		#strcmp com as duas
	blez $v0, skipSwap	#se strcmp deu 0 ou negativo, nao trocar
	jal stringSwap
skipSwap:
	add $a0, $a0, $a2	#Vetor++
	add $s0, $s0, $a2	#j++
	blt $s0, $s3, secondBubbleLoop

exitSecondBubble:
	sub $s3, $s3, $a2	#i--
	bgtz $s3, firstBubbleLoop

exitBubble:
	
	lw $a0, 0($sp)
	lw $ra, 4($sp)
	lw $s0, 8($sp)
	lw $s1, 12($sp)
	lw $s2, 16($sp)
	lw $s3, 20($sp)
	addi $sp, $sp, 24
	jr $ra #retorna

	#String Compare, t1 e t2 serao os bytes lidos. a0 e a1 sao as strings por argumento.
	#Return Address: negativo se a0 < a1, 0 se iguais, positivo se a0 > a1

strcmp:
	addi $sp, $sp, -8
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	li $t3, 65
	li $t4, 90
	
strcmpLoop:
	lb $t1, 0($a0) #le o byte string[i]
	lb $t2, 0($a1)
	#Tratamento de caracter maiusculo.
	bgt $t1, $t4, primeiraNaoMaiuscula
	blt $t1, $t3, primeiraNaoMaiuscula
	addi $t1, $t1, 32
	primeiraNaoMaiuscula:
	bgt $t2, $t4, segundaNaoMaiuscula
	blt $t2, $t3, segundaNaoMaiuscula
	addi $t2, $t2, 32
	segundaNaoMaiuscula:
	bne $t1, $t2, exitStrcmp #se for diferente, branch
	beqz $t1, exitStrcmp #se o primeiro acabou, iguais, pois se nao fosse, a checagem acima iria detectar finais diferentes
	addi $a0, $a0, 1 #string1++
	addi $a1, $a1, 1 #string2++
	j strcmpLoop

exitStrcmp:
	sub $v0, $t1, $t2
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	addi $sp, $sp, 8
	jr $ra #retorna


	#Pega duas strings $a0 e $a1 e troca todos os bytes de lugar, strings com tamanho fixo.
	#$a0 = str1, $a1 = str2, $a2 = strlen	
stringSwap:

	addi $sp, $sp, -12
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)

stringSwapLoop:

	lb $t0, 0($a0)
	lb $t1, 0($a1)
	sb $t0, 0($a1)
	sb $t1, 0($a0)
	addi $a2, -1
	beqz $a2, endSwap
	addi $a0, $a0, 1
	addi $a1, $a1, 1
	j stringSwapLoop

endSwap:

	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	addi $sp, $sp, 12
	jr $ra


divideBuckets: #divide o vetor de entrada em 26 buckets de acordo com as iniciais
	
	la $a0, fileIn
	while:
	lb $a1, 0($a0)
	li $a2, 65
	beq $a2, $a1, letterA  # vai para letterA if byte($a1)==byte(65), usando tabela ascii
	li $a2, 66
	beq $a2, $a1, letterB
	li $a2, 67
	beq $a2, $a1, letterC
	li $a2, 68
	beq $a2, $a1, letterD
	li $a2, 69
	beq $a2, $a1, letterE
	li $a2, 70
	beq $a2, $a1, letterF
	li $a2, 71
	beq $a2, $a1, letterG
	li $a2, 72
	beq $a2, $a1, letterH
	li $a2, 73
	beq $a2, $a1, letterI
	li $a2, 74
	beq $a2, $a1, letterJ
	li $a2, 75
	beq $a2, $a1, letterK
	li $a2, 76
	beq $a2, $a1, letterL
	li $a2, 77
	beq $a2, $a1, letterM
	li $a2, 78
	beq $a2, $a1, letterN
	li $a2, 79
	beq $a2, $a1, letterO
	li $a2, 80
	beq $a2, $a1, letterP
	li $a2, 81
	beq $a2, $a1, letterQ
	li $a2, 82
	beq $a2, $a1, letterR
	li $a2, 83
	beq $a2, $a1, letterS
	li $a2, 84
	beq $a2, $a1, letterT
	li $a2, 85
	beq $a2, $a1, letterU
	li $a2, 86
	beq $a2, $a1, letterV
	li $a2, 87
	beq $a2, $a1, letterW
	li $a2, 88
	beq $a2, $a1, letterX
	li $a2, 89
	beq $a2, $a1, letterY
	li $a2, 90
	beq $a2, $a1, letterZ
	li $a2, -1
	beq $a2, $a1, endBucketDivide
	jr $ra
	
letterA:
	
	la $a3, bucketA # carrega o endereco e vai para o loop de guardar nos buckets
	j bucketWord
		
letterB:
	
	la $a3, bucketB
	j bucketWord
	
letterC:
	
	la $a3, bucketC
	j bucketWord
	
letterD:
	
	la $a3, bucketD
	j bucketWord
	
letterE:
	
	la $a3, bucketE
	j bucketWord
	
letterF:
	
	la $a3, bucketF
	j bucketWord
	
letterG:

	la $a3, bucketG
	j bucketWord
	
letterH:
	
	la $a3, bucketH
	j bucketWord
	
letterI:
	
	la $a3, bucketI
	j bucketWord
	
letterJ:
	
	la $a3, bucketJ
	j bucketWord
	
letterK:
	
	la $a3, bucketK
	j bucketWord
	
letterL:
	
	la $a3, bucketL
	j bucketWord
	
letterM:
	
	la $a3, bucketM
	j bucketWord
	
letterN:
	
	la $a3, bucketN
	j bucketWord
	
letterO:
	
	la $a3, bucketO
	j bucketWord
	
letterP:
	
	la $a3, bucketP
	j bucketWord
	
letterQ:
	
	la $a3, bucketQ
	j bucketWord

letterR:
	
	la $a3, bucketR
	j bucketWord
	
letterS:
	
	la $a3, bucketS
	j bucketWord
	
letterT:
	
	la $a3, bucketT
	j bucketWord
	
letterU:
	
	la $a3, bucketU
	j bucketWord
	
letterV:
	
	la $a3, bucketV
	j bucketWord
	
letterW:
	
	la $a3, bucketW
	j bucketWord
	
letterX:
	
	la $a3, bucketX
	j bucketWord
	
letterY:

	la $a3, bucketY
	j bucketWord
	
letterZ:

	la $a3, bucketZ
	j bucketWord
	
bucketWord: # funcao com a utilidade de salvar o numero de palavras atual no balde em questao

	lw $a2, 0($a3) #le o numero
	addi $a2, $a2, 1
	sw $a2, 0($a3) #guarda o numero de nomes dentro do bucket no registrador de parametro
	addi $a2, $a2, -1
	addiu $a3, $a3, 4 #pula o numero para comecar a escrever no bucket
	j bucketWrite
	
bucketWrite: #escreve no bucket o nome
	
	lb $t0, 0($a0) # a0 = vetor origem
	li $t6, 10 #\n = condicao de parada
	addiu $a0, $a0, 1
	beq $t6, $t0, endBucketWrite
	lb $t1, 0($a3)
	beqz $t1, outBucketWriteLoop
	bucketWriteLoop:
		beqz $a2, outBucketWriteLoop #a2 = numero de palavras no bucket, logo esse loop pula ate uma posicao livre no balde
		addiu $a3, $a3, 26 #pula o espaco de 1 palavra (25 caracteres + \0)
		addi $a2, $a2, -1
		j bucketWriteLoop
	outBucketWriteLoop:
	sb $t0, 0($a3)
	addiu $a3, $a3, 1
	j bucketWrite
	
endBucketWrite:
	#addiu $s1, $s1, 1
	sb $zero, 0($a3)
	j while

endBucketDivide:
	#addiu $s1, $s1, 1
	jr $ra	
	
concatenateOnFileOut: #concatena todos os nomes de todos os buckets em um vetor de saída para ser escrito no arquivo de saída
	addi $sp, $sp, -8
	sw $ra, 0($sp)
	la $a1, lenghtEach
	lw $a1, 0($a1)
	la $a2, newline
	lw $a2, 0($a2)
	la $s0, fileOut #s0 = vetor a ser escrito no arquivo de saida
	la $a0, bucketA
	jal saveBucket
	la $a0, bucketB
	jal saveBucket
	la $a0, bucketC
	jal saveBucket
	la $a0, bucketD
	jal saveBucket
	la $a0, bucketE
	jal saveBucket
	la $a0, bucketF
	jal saveBucket
	la $a0, bucketG
	jal saveBucket
	la $a0, bucketH
	jal saveBucket
	la $a0, bucketI
	jal saveBucket
	la $a0, bucketJ
	jal saveBucket
	la $a0, bucketK
	jal saveBucket
	la $a0, bucketL
	jal saveBucket
	la $a0, bucketM
	jal saveBucket
	la $a0, bucketN
	jal saveBucket
	la $a0, bucketO
	jal saveBucket
	la $a0, bucketP
	jal saveBucket
	la $a0, bucketQ
	jal saveBucket
	la $a0, bucketR
	jal saveBucket
	la $a0, bucketS
	jal saveBucket
	la $a0, bucketT
	jal saveBucket
	la $a0, bucketU
	jal saveBucket
	la $a0, bucketV
	jal saveBucket
	la $a0, bucketW
	jal saveBucket
	la $a0, bucketX
	jal saveBucket
	la $a0, bucketY
	jal saveBucket
	la $a0, bucketZ
	jal saveBucket
	li $t0, 0
	#addiu $s0, $s0, 1 #fazer colocar um \0 no final
	sb $t0, 0($s0)
	lw $ra, 0($sp)
	addi $sp, $sp, 8
	jr $ra
	
saveBucket:
	lw $t0, 0($a0) #t0 = quantas palavras tem no bucket
	addiu $a0, $a0, 4 #pula no vetor a0 a parte do numero
	sw $ra, 4($sp)
	saveBucketLoop:
		beqz $t0, outSaveBucketLoop #bucket terminado
		addi $t0, $t0, -1
		li $a3, 0 #numero de bytes ja lidos
		jal strcpy
		j saveBucketLoop
	outSaveBucketLoop:
	lw $ra, 4($sp)
	jr $ra
	
strcpy:
	addi $a3, $a3, 1 # byte counter
	lb $t1, 0($a0)
	beq $t1, $zero, endStrcpy #palavra acabou (no balde)
	sb $t1, 0($s0) # guarda no vetor de saida o byte
	addiu $a0, $a0, 1 #vetor[i++]
	addiu $s0, $s0, 1
	j strcpy
	
endStrcpy:
	sb $a2, 0($s0)
	addiu $s0, $s0, 1
	sub $t4, $a1, $a3
	add $a0, $a0, $t4
	addiu $a0, $a0, 1
	jr $ra

cleanFileOut: #limpa o vetor de saida
	la $t0, fileOut
	li $t1, 2600
	li $t2, 0
	cleanFileOutLoop:
		beqz $t1, outCleanFileOutLoop
		addi $t1, $t1, -1
		sb $t2, 0($t0)
		addiu $t0, $t0, 1
		j cleanFileOutLoop
	outCleanFileOutLoop:
	jr $ra
	
cleanFileIn: #limpa o vetor de entrada
	la $t0, fileIn
	li $t1, 2600
	li $t2, 0
	cleanFileInLoop:
		beqz $t1, outCleanFileInLoop
		addi $t1, $t1, -1
		sb $t2, 0($t0)
		addiu $t0, $t0, 1
		j cleanFileInLoop
	outCleanFileInLoop:
	jr $ra

cleanFileNameBuffer: #limpa o vetor do nome do arquivo de entrada
	la $t0, fileNameBuffer
	li $t1, 21
	li $t2, 0
	cleanFileNameBufferLoop:
	 beqz $t1, outCleanFileNameBufferLoop
	 addi $t1, $t1, -1
	 sb $t2, 0($t0)
	 addiu $t0, $t0, 1
	 j cleanFileNameBufferLoop
	outCleanFileNameBufferLoop:
	jr $ra

exit:
	move $a0, $s1 # a0 = fileDescriptor
	jal closeWriteFile
	li $v0, 10
	syscall
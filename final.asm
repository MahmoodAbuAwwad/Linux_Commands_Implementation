.data  
path: .asciiz "/Users/laptopcenter/Documents/BZU/BZU1192/Architecture\ /Project1/%"      # filename for input
filePath: .space 100
File_name: .space 100
fileContent: .space 2048 #the content of the file we want to open

String_name: .space 100

#**********************************
#**********************************
#	$s7 reserved for opcode
#	$s6 reserved for we have to write the output on buffer or on console
#**********************************
#**********************************


Command: .space 150
auxCommand:.space 150	
firstWord: .space 100 #the first word of the command


command1: .asciiz "File_name%"
command1.1: .asciiz "$File_name%"
command2: .asciiz "String_name%"
command2.1: .asciiz "$String_name%"
command3: .asciiz "echo%"
command4: .asciiz "wc%"
command5: .asciiz "grep%"
command6: .asciiz "grep $String_name $File_name%"

msg0 : .asciiz "\nPlese enter the command:\n"
msg1 : .asciiz "\nProject I Main$ : "
msg2: .asciiz "file name is : "
msg3: .asciiz "the string is : "
msg4: .asciiz "wcf\n"
msg5: .asciiz "wcs\n"
msg6: .asciiz "it's echo\n"
msg7: .asciiz "it's grep\n"

test1: .asciiz "File_name\n"
test2: .asciiz "String_name\n"

Error: .asciiz "Error \n"
Error2: .asciiz "Error!! => Incorrect command \n"
Error3: .asciiz	"Error!! => the name of the file is incorrect or the file does'n in the correct path\n"
Error4: .asciiz	"Error!! => there is no '=' \n"
Error5: .asciiz	"Error!! => String name must follow the command "
Error6: .asciiz "Error!! => Incorrect sub command \n"

newLine: .asciiz "\n"
Found: .space 100

StirngToSearchIn: .space	2048
StringToSearchFor: .space	50

##################
pipe: .asciiz  "pipe\n"
justVar: .asciiz  "variable to print here\n"
justStr: .space 30
noPipe: .asciiz  "no Pipe\n"
#################
toPrint: .space 100
numberToPrint: .space 6


.text
#sw $ra, ($sp)
#	jal File_name_Pro
#	lw $ra, ($sp)
mainLoop:


la $a0, msg1 #load address Ask_Input from memory and store it into arguement register 0
jal printMsg

la $a0, Command 
la $a1, Command #length
jal read

li $s6,0

##if the command starts with 0 then we have to finish
lb $t7,Command($zero)
li $t6,48
beq $t6,$t7,THEEND

#la $a0, msg2 #load address Tell_Output from memory and store it into arguement register 0
#jal printMsg

#la $a0, Command #load address insert_into from memory and store it into arguement register 0
#jal printMsg
m2:
####
#this block is just to know the first word of the command

jal checkPro	#to check what is the first word of the command 

c1:bne $s7,1,c2
jal File_name_Pro
j cEnd
c2:bne $s7,2,c3
jal String_name_Pro
j cEnd
c3:bne $s7,3,c4
jal echo_Pro
j cEnd
c4:bne $s7,4,c5
jal wc_Pro
j cEnd
c5:bne $s7,5,c6
jal grep_Pro
j cEnd
c6:bne $s7,6,c7
jal File_name_Pro.1
j cEnd
c7:bne $s7,7,c8
jal String_name_Pro.2
j cEnd
c8:
la $a0,Error2		#the code for error is 6
li $v0,4
syscall

cEnd:
j mainLoop

THEEND:
li $v0, 10      # Finish the Program
syscall


###############################################################################################
#*********************************************************************************************

#%%%%%%%%%%%%%%%%%%%
checkPro:

li $t0,0
li $t1,0
loop0:
	lb $t2,Command($t1)
	beq $t2,' ',exit0
	beq $t2,'=',exit0
	beq $t2,'\n',exit0
	beq $t2,'\0',exit0	########	
	sb $t2,firstWord($t0)
	addiu $t0,$t0,1
	addiu $t1,$t1,1
	j loop0
exit0:
li $t2,'%'
sb $t2,firstWord($t1)

####        this block will be to know the type of the command
li $t0,0
li $t1,0
loop1:	#to know if the command starts with File_name
	lb $t2,firstWord($t0)	#the code is 1 stores in $s7	
	lb $t3,command1($t1)
	bne $t2,$t3,exit1
	beq $t2,'%',b1
	addiu $t0,$t0,1
	addiu $t1,$t1,1
	j loop1

b1:	li $s7,1	
	j ENDMAIN
	
exit1:
li $t0,0
li $t1,0
loop1.1:	#to know if the command starts with File_name
	lb $t2,firstWord($t0)
	lb $t3,command1.1($t1)
	bne $t2,$t3,exit1.1
	beq $t2,'%',b1.1
	beq $t2,'\0',b1.1
	addiu $t0,$t0,1
	addiu $t1,$t1,1
	j loop1.1
b1.1:	li $s7,6
	j ENDMAIN
exit1.1:
li $t0,0
li $t1,0
loop2:	# to know if the command starts with String_name
	lb $t2,firstWord($t0)
	
	lb $t3,command2($t1)
	bne $t2,$t3,exit2
	beq $t2,'%',b2
	addiu $t0,$t0,1
	addiu $t1,$t1,1
	j loop2

b2:	li $s7,2
	j ENDMAIN
	
exit2:
li $t0,0
li $t1,0
loop2.2:	# to know if the command starts with String_name
	lb $t2,firstWord($t0)
	
	lb $t3,command2.1($t1)
	bne $t2,$t3,exit2.2
	beq $t3,'%',b2.2
	addiu $t0,$t0,1
	addiu $t1,$t1,1
	j loop2.2

b2.2:	li $s7,7
	j ENDMAIN
	
exit2.2:
li $t0,0
li $t1,0
loop3:	# to know if the command starts with echo
	lb $t2,firstWord($t0)
	lb $t3,command3($t1)
	bne $t2,$t3,exit3
	beq $t2,'%',b3
	addiu $t0,$t0,1
	addiu $t1,$t1,1
	j loop3

b3:	li $s7,3
	j ENDMAIN
	
exit3:
li $t0,0
li $t1,0
loop4:	# to know if the command starts with wc
	lb $t2,firstWord($t0)
	lb $t3,command4($t1)
	bne $t2,$t3,exit4
	beq $t2,'%',b4
	addiu $t0,$t0,1
	addiu $t1,$t1,1
	j loop4

b4:	li $s7,4
	j ENDMAIN
	
exit4:
li $t0,0
li $t1,0
loop5:	# to know if the command starts with grep
	lb $t2,firstWord($t0)	#the opcode is 5
	lb $t3,command5($t1)
	bne $t2,$t3,exit5
	beq $t2,'%',b5
	addiu $t0,$t0,1
	addiu $t1,$t1,1
	j loop5

b5:	li $s7,5	
	j ENDMAIN
	
exit5:
####

#la $a0,Error2		#the code for error is 6
#li $v0,4
#syscall
li $s7,8
j ENDMAIN

ENDMAIN:

jr $ra
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#load address of the file name variable in $a0
openFile:# Open file for reading
li   $v0, 13
li   $a1, 0
li   $a2, 0  # mode is ignored
syscall 
move $s0, $v0
jr $ra

#load the addrees where to save the content in $a1
readFile:# reading from file
li   $v0, 14       
move $a0, $s0      
li   $a2,  2048 #buffer length
syscall
jr $ra

#load the address of the message to $a0
printMsg:#print msg
li  $v0, 4          # system Call for PRINT STRING
syscall             # print int
jr $ra

#load add to $a0 && $a1
read:#read the input
li $v0, 8 
syscall 
jr $ra

#..................................................................................................................

#procedure of the File_name that will save the file name in the variable
File_name_Pro:
li $t0,0
li $t1,0
lp1:
	lb $t2,Command($t0)
	addiu $t0,$t0,1
	beq $t0,20,ErrorP1
	beq $t2,'=',afterEqual
	j lp1
afterEqual:
	lb $t2,Command($t0)
	sb $t2,File_name($t1)
	beq $t2,'\n',exitp1
	addiu $t0,$t0,1
	addiu $t1,$t1,1
	j afterEqual

ErrorP1:
	la $a0,Error4
	li $v0,4
	syscall
exitp1:

jr $ra
#.....................................
File_name_Pro.1:
li $t0,0
beq $s6,1,writeOnBuffer.2
la $a0,File_name
li $v0,4
syscall	
j EndPro.1
writeOnBuffer.2:
	lb $k0,File_name($t0)
	beq $k0,'\n',EndPro.1
	sb $k0,toPrint($t8)
	addiu $t0,$t0,1
	addiu $t8,$t8,1
	j writeOnBuffer.2	
EndPro.1:
subiu $t8,$t8,1
jr $ra
#.......................................

#procedure of the String_name that will save the string name in it's variable
String_name_Pro:
li $t0,0
li $t1,0
lp2:
	lb $t2,Command($t0)
	addiu $t0,$t0,1
	beq $t2,'=',afterEqual2
	j lp2
afterEqual2:
	lb $t2,Command($t0)
	sb $t2,String_name($t1)
	beq $t2,'\n',exitp2
	addiu $t0,$t0,1
	addiu $t1,$t1,1
	j afterEqual2
exitp2:
jr $ra

#............................................
String_name_Pro.2:
li $t0,-1
beq $s6,1,writeOnBuffer.3
la $a0,String_name
li $v0,4
syscall
j EndPro.3
writeOnBuffer.3:
	addiu $t0,$t0,1
	lb $k0,String_name($t0)
	beq $k0,'\n',EndPro.3
	sb $k0,toPrint($t8)
	
	addiu $t8,$t8,1
	j writeOnBuffer.3	
EndPro.3:
subiu $t8,$t8,1
jr $ra

#.................................
#procedure of the echo command
#####################################################################################################
#***********************************************************************************************
#####################################################################################################

#procedure of the echo command

li $t1,4 #starting from the space
li $t2,0 
li $t5,0
li $t6,0
echo_Pro:
	lb $t0,Command($t1)
	addiu $t2,$t1,1		#Saving index >of next char
	beq $t0,'"',checkEchoCommandType
	beq $t0,'$',PrintVariable # if follow the echo var name , print it
	beq $t0,'\0',PrintError
	addiu $t1,$t1,1
	j echo_Pro

PrintError:
	la $a0,Error2
	li $v0,4		 
	syscall 
	j exitEcho

PrintVariable:		#not in peoject file  ---  #$t1 = index of $
	addiu $t1,$t1,1
	li $t6,0
	lb $t0,Command($t1)
	lb $t7,command1($zero)  #compare first char to check if File Name
	lb $t8,command2($zero)  #compare first char to check if String Name 
	beq $t0,$t8,checksStringName 
	beq $t0,$t7,checksFileName 
	j PrintVariable

checksStringName:
	addiu $t1,$t1,1
	addiu $t6,$t6,1
	lb $t0,Command($t1)
	lb $t5,command2($t6)
	beq $t0,0x0a,printStringName
	bne $t0,$t5,PrintError
	j checksStringName

printStringName:
	la $a0,String_name
	li $v0,4		 
	syscall 
	j exitEcho

checksFileName:
	addiu $t1,$t1,1
	addiu $t6,$t6,1
	lb $t0,Command($t1)
	lb $t5,command1($t6)
	beq $t0,0x0a,printFileName #0a is line feed
	bne $t0,$t5,PrintError
	j checksFileName

printFileName:
	la $a0,File_name
	li $v0,4		 
	syscall 
	j exitEcho

checkEchoCommandType:
	addiu $t2,$t2,1 
	move $t4,$t2		#get the char after "
	lb $t3,Command($t4)
	move $t5,$t4
	beq $t3,'\'',commandInString
	beq $t3,'"',justString	
	addiu $t4,$t4,1				
	j checkEchoCommandType

justString:
li $k0,0
li $k1,0
cleanS:
	beq $k0,32,cleanSEnd
	sb $k1,justStr($k0)
	addiu $k0,$k0,1
	j cleanS
cleanSEnd:
li $k0,0
li $t2,5
lb $k1,Command($t2)
bne $k1,'"',PrintError
li $t2,6
lb $k1,Command($t2)
beq $k1,' ',PrintError
justStringL1:
	
	lb $k1,Command($t2)
	beq $k1,'"',justStringL1End
	sb $k1,justStr($k0)
	addiu $k0,$k0,1
	addiu $t2,$t2,1
	j justStringL1
justStringL1End:
	la $a0,justStr
	li $v0,4		
	syscall 
	j exitEcho

commandInString:
	addiu $t5,$t5,1
	lb $t6,Command($t5)  #$t4 have the index of ' also $t5 have the index of char AFTER '
	beq $t6,'|',pipelined
	beq $t6,'\'',noPipeline	
	j commandInString

pipelined: #$t5 = index of |      and        $t4 = index of first '
	#la $a0,pipe
	#li $v0,4		
	#syscall 
	#j exitEcho

#8888888888888888888888888888888888888
noPipeline:	#$t4 = index of first '
li $s3,0	#the flag if there is anothoer subCommand
li $t0,0
li $t1,0
cleanToPrint:
	beq $t0,100,cleanToEnd
	sb $t1,toPrint($t0)
	addiu $t0,$t0,1
	j cleanToPrint
cleanToEnd:
li $t0,0
cloneCommand:
	lb $t1,Command($t0)
	sb $t1,auxCommand($t0)
	beq $t1,'\n',cloneCommandEnd
	beq $t1,'\0',cloneCommandEnd
	addiu $t0,$t0,1
	j cloneCommand
cloneCommandEnd:
li $t0,0
li $t1,0
cleanCommand:
	beq $t0,150,cleanCommandEnd
	sb $t1,Command($t0)
	addiu $t0,$t0,1
	j cleanCommand
cleanCommandEnd:
li $t2,0
beq $s3,1,RL1E
li $s2,4	#to check if the command written in right way
lb $t1,auxCommand($s2)
bne $t1,' ',PrintError
li $s2,5
lb $t1,auxCommand($s2)
bne $t1,'"',PrintError

#li $t2,0
resetCommand:
	RL1:	lb $t1,auxCommand($s2)
		addiu $s2,$s2,1		#$t0 will have the index of next to the first " ' "
		beq $t1,'\'',RL1E
		j RL1
	RL1E:
	lb $t1,auxCommand($s2)
	beq $t1,'\'',resetCommandEnd
	beq $t1,'|',Pipe
	sb $t1,Command($t2)
	addiu $s2,$s2,1		#$t0 will have the index of next to the second " ' "
	addiu $t2,$t2,1
	j RL1E
resetCommandEnd:
j PipeEnd
Pipe:
	li $t1,0
	sb $t1,Command($t2)
	addiu $s2,$s2,1
	lb $t1,auxCommand($s2)
	bne $t1,' ',cc8
	addiu $s2,$s2,1
	lb $t1,auxCommand($s2)
	bne $t1,'w',cc8
	addiu $s2,$s2,1
	lb $t1,auxCommand($s2)
	bne $t1,'c',cc8
	addiu $s2,$s2,1
	lb $t1,auxCommand($s2)
	bne $t1,' ',cc8
	addiu $s2,$s2,1
	lb $t1,auxCommand($s2)
	bne $t1,'-',cc8
	addiu $s2,$s2,1
	lb $t1,auxCommand($s2)
	beq $t1,'l',pipeLine
	beq $t1,'w',pipeWord
	j cc8
	
	pipeLine:	addiu $s2,$s2,1
			lb $t1,auxCommand($s2)
			bne $t1,'\'',cc8
			li $a3,1
			j PipeEnd
	pipeWord:	addiu $s2,$s2,1
			lb $t1,auxCommand($s2)
			bne $t1,'\'',cc8
			li $a3,2
			j PipeEnd
	
PipeEnd:

beq $s3,1,copyBeforSingleEnd
li $s6,1	 #flag to store the result of subCommand in toPrint buffer
li $t1,6 #the first char after the first "
li $t8,0 #index to print
copyBeforSingle:
	lb $k0,auxCommand($t1)
	
	beq $k0,'\'',copyBeforSingleEnd
	sb $k0,toPrint($t8)
	addiu $t1,$t1,1
	addiu $t8,$t8,1
	j copyBeforSingle
copyBeforSingleEnd:	 
sw $ra, ($gp)	
jal checkPro	#to check what is the first word of the command 
lw $ra, ($gp)

cc1:bne $s7,1,cc2
sw $ra, ($gp)
jal File_name_Pro
lw $ra, ($gp)
j ccEnd
cc2:bne $s7,2,cc3
sw $ra, ($gp)
jal String_name_Pro
lw $ra, ($gp)
j ccEnd
cc3:bne $s7,3,cc4
sw $ra, ($gp)
jal echo_Pro
lw $ra, ($gp)
j ccEnd
cc4:bne $s7,4,cc5
sw $ra, ($gp)
jal wc_Pro
lw $ra, ($gp)
j ccEnd
cc5:bne $s7,5,cc6
sw $ra, ($gp)
jal grep_Pro
lw $ra, ($gp)
j ccEnd
cc6:bne $s7,6,cc7
sw $ra, ($gp)
jal File_name_Pro.1
lw $ra, ($gp)
j ccEnd
cc7:bne $s7,7,cc8
sw $ra, ($gp)
jal String_name_Pro.2
lw $ra, ($gp)
j ccEnd
cc8:	
la $a0,Error6		#the code for error is 6
li $v0,4
syscall
j exitEcho
ccEnd:

#j exitEcho
beq $s3,1,copyAfterSingle

li $s2,6
findSingle:	#this scope is to find the index of char after the subCommand
	lb $k0,auxCommand($s2)
	addiu $s2,$s2,1
	beq $k0,'\'',findSingle2
	j findSingle
findSingle2:
	lb $k0,auxCommand($s2)
	addiu $s2,$s2,1
	beq $k0,'\'',findSingleEnd
	j findSingle2
findSingleEnd:
subiu $s2,$s2,1
copyAfterSingle:
	addiu $t8,$t8,1
	addiu $s2,$s2,1
	lb $k0,auxCommand($s2)
	beq $k0,'"',EndEcho
	beq $k0,'\'',copyAfterSingleEnd
	sb $k0,toPrint($t8)
	
	j copyAfterSingle
copyAfterSingleEnd:
li $s3,1
addiu $s2,$s2,1
j cloneCommandEnd
###### it can be loop
#j EndEcho
								
EndEcho:
la $a0,toPrint
li $v0,4
syscall
exitEcho:
jr $ra


#####################################################################################################
#**************************************************************************************************
#####################################################################################################

#................................................
#procedure of wc in general
wc_Pro:
li $t0,0
li $t1,0
li $t4,0
lp4:
	lb $t2,Command($t0)
	addiu $t0,$t0,1
	beq $t2,'$',after$
	beq $t0,20,ErrorP4
	j lp4
after$:
	add $t4,$zero,$t0 #$t4 and $t0 will have the first char after $
	
#this to check if there is (File_name) after $
checkF:	lb $t2,Command($t0)#$t2 & $t3 will have the chars of the command after $ and from the test1
	lb $t3,test1($t1)
	beq $t3,'\n',FileImplementation
	bne $t2,$t3,checkS
	addiu $t0,$t0,1
	addiu $t1,$t1,1
	j checkF
	
 li $t1,0
 #this is to check if there is (String_name) after $
checkS:	lb $t2,Command($t4)#$t2 & $t3 will have the chars of the command after $ and from the test1
	lb $t3,test2($t1)
	bne $t2,$t3,ErrorP4
	beq $t2,'e',StringImplementation
	addiu $t4,$t4,1
	addiu $t1,$t1,1
	j checkS
	
FileImplementation:
	li $t5,0
	li $t4,0
FIML:	lb $t2,path($t4)
	beq $t2,'%',FIE
	sb $t2,filePath($t4)
	addiu $t4,$t4,1
	j FIML
FIE:	lb $t2,File_name($t5)
	beq $t2,'\n',EFIE
	sb $t2,filePath($t4)
	addiu $t4,$t4,1
	addiu $t5,$t5,1
	j FIE
EFIE:	la   $a0, filePath      # input file name
	li   $v0, 13 #open file
	li   $a1, 0
	li   $a2, 0  # mode is ignored
	syscall 
	move $s0, $v0
	blt $v0,$zero,ErrorP4.2

	la   $a1, fileContent 
	li   $v0, 14   #read file    
	move $a0, $s0      
	li   $a2,  2048 #buffer length
	syscall 

	li   $v0, 16       # system call for close file
	move $a0, $s0      # file descriptor to close
	syscall            # close file

	j checkwl
StringImplementation:
	li $t0,0
SES:	lb $t1,String_name($t0)
	sb $t1,fileContent($t0)
	beq $t1,'\n',ESI
	addiu $t0,$t0,1
	j SES
	
ESI:	li $t1,37 #to store % at the end of the string
	sb $t1,fileContent($t0)
	la $a0,fileContent
	li $v0,4
	#syscall
	j checkwl	
ErrorP4:la $a0,Error2
	li $v0,4
	syscall
	j exitp4
ErrorP4.2:la $a0,Error3
	li $v0,4
	syscall
	j exitp4
	
checkwl:
	lb $t1,Command+3
	bne $t1,'-',ErrorP4
	lb $t1,Command+4
	beq $t1,'w',word
	beq $t1,'l',line
	j ErrorP4

word:	li $t0,0 #the index
	li $t9,1 #the counter of the spaces (words) initialized by 1
wordS:	lb $t1,fileContent($t0)
	addiu $t0,$t0,1
	beq $t1,' ',countW
	beq $t1,'\n',countW
	beq $t1,'%',exitCount
	beq $t1,'\0',exitCount
	j wordS
countW:	addiu $t9,$t9,1
	j wordS

line:	li $t0,0 #the index
	li $t9,1 #the counter of the spaces (words) initialized by 1
lineS:	lb $t1,fileContent($t0)
	addiu $t0,$t0,1
	beq $t1,'\n',countL
	beq $t1,'%',exitCount
	beq $t1,'\0',exitCount
	j lineS
countL:	addiu $t9,$t9,1
	j lineS
exitCount:
	beq $s6,1,writeOnBuffer
	move $a0,$t9
	li $v0,1
	syscall	
	j exitp4
writeOnBuffer:
#addiu $t9,$t9,48 #the asci of the number
#addiu $t8,$t8
#sb $t9,toPrint($t8)
move $t2,$t9
sw $ra, ($sp)
jal printNumber
lw $ra, ($sp)	
exitp4:
jr $ra

#........................................................
#########################################################
#########################################################
#........................................................
#grep procedure
grep_Pro:
li $t0,0
li $t1,0
li $t2,0
li $t4,0

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
li $s1,0#Line Count		   	
li $s2,0#WordsCount                
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

grep_CheckCommand:
	lb $t1,Command($t0)   #get first char of Command 
	lb $t2,command6($t4)  #get first char to check if command written right
	beq $t2,'%',SearchInFile	#if true
	bne $t1,$t2,grep_ErrorP4	#if false - print wrong command
	addiu $t0,$t0,1
	addiu $t4,$t4,1
	j grep_CheckCommand

	
grep_ErrorP4:
	la $a0,Error2
	li $v0,4   #Printing Error -> Wrong Command 
	syscall
	j exitp5

	###############################	Search For Content in File and Veiwit ########################
SearchInFile:
########open ,read, close file
	li $t5,0
	li $t4,0
FIML2:	lb $t2,path($t4)
	beq $t2,'%',FIE2
	sb $t2,filePath($t4)
	addiu $t4,$t4,1
	j FIML2
FIE2:	lb $t2,File_name($t5)
	beq $t2,'\n',EFIE2
	sb $t2,filePath($t4)
	addiu $t4,$t4,1
	addiu $t5,$t5,1
	j FIE2
EFIE2:	la   $a0, filePath      # input file name
	li   $v0, 13 #open file
	li   $a1, 0
	li   $a2, 0  # mode is ignored
	syscall 
	move $s0, $v0
	blt $v0,$zero,ErrorP55

	la   $a1, StirngToSearchIn 
	li   $v0, 14   #read file    
	move $a0, $s0      
	li   $a2,  2048 #buffer length
	syscall 

	 li   $v0, 16       # system call for close file
	move $a0, $s0      # file descriptor to close
	syscall            # close file
	
	li $t0,0
loadString:
	lb $t1,String_name($t0)
	beq $t1,'\n',exitLoad
	sb $t1,StringToSearchFor($t0)
	addiu $t0,$t0,1
	j loadString
exitLoad:
##############
	li $t0,0
	li $t1,0
	li $t2,0
	li $t6,0
	li $t4,0  
	li $t5,0  
	li $t8,0

	li $t3,0
firstChar:# Finding the First char == to First String_name Char
		
	lb $t0,StirngToSearchIn($t2)   #get the first char of File Contents
	lb $t1,StringToSearchFor($zero)  #here get the first char of Stirng_name

	sb $t0,Found($t3)
	beq $t0,'\n',Lines1
	beq $t0,' ',Words1
	j cont1
	Lines1:		#if the char is newLine then RESET counters and Clear the Line Stored (if the Searched for doesnt found)

		li $s4,0  #reset line and words NUM
		li $s5,0
		li $t9,0
		li $k1,0
		clean1.11:	
			sb $k1,Found($t9)  
			addiu $t9,$t9,1
			ble $t9,50,clean1.11	
		li $t3,0	
		j cont2
	Words1:			#increment the words counter
		addiu $s5,$s5,1 
		j cont1
	cont1:

	addiu $t3,$t3,1
	cont2:

	addu $t8,$t2,$zero # store the index of current char  --Search In
	li $t7,1 # t7 t8 used in next labe  --Search For
	beq $t1,$t0,RestOfStringName
	beq $t0,'%',exitp5    # % must be changed to end of file Contents --- Here if there is no string match , Just exit
	beq $t0,'\0',exitp5
	addiu $t2,$t2,1 #moving over file contents until get the first char 
	j firstChar
	
RestOfStringName:
	addiu $t2,$t2,1  #to avoid infinite Loop  -------$s2 contains the address after String_name found
RestOfStringName1:
	move $t8,$t2  
	lb $t5,StirngToSearchIn($t8)   #check the rest of StringName
	lb $t6,StringToSearchFor($t7) 
	beq $t5,' ',Words2.1
	j cont2.1

	Words2.1:
		addiu $s5,$s5,1
		j cont2.1
	cont2.1:
	beq $t5,32,SaveLine	#check  if space ####################need to be FIXED ################################
	
	###################################
	#Save $t5 in Variable here
	sb $t5,Found($t3)
	addiu $t3,$t3,1

	###################################
	addiu $t2,$t2,1
	addiu $t7,$t7,1
	bne $t5,$t6,firstChar	#if false - print wrong command

	j RestOfStringName1
	
SaveLine: #save the rest of line tell \n   newLine
	
	addiu $t2,$t2,1 #in order to skip the line when search for other String_Name in File
	addiu $t8,$t8,1
	
	sb $t5,Found($t3)	#store the char
	addiu $t3,$t3,1

	lb $t5,StirngToSearchIn($t8)   #check the rest of StringName
	beq $t5,' ',Words3		#check if char is SPCAce inrement words counter
	j cont3

	Words3:				#count Words
		addiu $s5,$s5,1
		j cont3
	cont3:
	beq $t5,'\n',printLine
	beq $t5,'\0',printLineAndExit    #check if the end of file 
	j SaveLine

printLine: #print the stored Line Here
	addiu $s1,$s1,1		#increment Line number
	addiu $s2,$s2,1		#count the last word too
	addu $s2,$s2,$s5	#save number of words in s2
	
	beq $a3,1,PEL
	beq $a3,2,PEL
	la $a0,Found
	li $v0,4		#check 
	syscall 
	la $a0,newLine
	li $v0,4		#check 
PEL:	syscall 

	li $t9,0
	li $k1,0	#set values to NULL
	clean1.2:
		li $s4,0
		li $s5,0	#Reset words counter
		sb $k1,Found($t9)
		addiu $t9,$t9,1 	#make found Var NULL
		li $t3,0
		ble $t9,100,clean1.2

	j firstChar
	
printLineAndExit: #print the stored Line Here and Exit
	
	addiu $s1,$s1,1		#S1 contains the Line Count
	addiu $s2,$s2,1		#count the last word too
	addu $s2,$s2,$s5	#save number of words in s2

	beq $a3,1,printLinesOnBuffer
	beq $a3,2,printLinesOnBuffer
	la $a0,Found
	li $v0,4		#check 
	syscall 
	la $a0,newLine
	li $v0,4		#check 
	syscall 
printLineAndExitEnd:	j exitp5

ErrorP55:
	la $a0,Error3
	li $v0,4
	syscall	
	j exitp5

printLinesOnBuffer:
li $t8,0
	reset8:lb $t1,toPrint($t8)
		beq $t1,'\0',reset8E
		addiu $t8,$t8,1
		j reset8
	reset8E:
beq $a3,1,PLOB	#pritn number of lines on buffer
beq $a3,2,PWOB
PLOB: move $t2,$s1
j printIt
PWOB: move $t2,$s2
printIt:

sw $ra, ($sp)
jal printNumber
lw $ra, ($sp)

exitp5:
jr $ra
	
#..........................................................................................

printNumber:	#the number to be printed must be in $t2
	#li $t2,5	#number in $t2
	li $t3,10	#t3 has the Radix  =   10
	li $t4,0	#counter - Number of Digits
	move $t5,$t2   #temp to save the Number 
	
	li $t9,0
	li $k1,0
	cleanNumToPrint:			#cleaning the Variable
		sb $k1,numberToPrint($t9)
		addiu $t9,$t9,1
		ble $t9,6,cleanNumToPrint
	
	findNumDigits:
		div $t2,$t3
		beq $t2,0,endLoop
		addiu $t4,$t4,1		#increament counter
		mflo $t2                #edit number   #answer is Low  #Reminder in HIGH
		j findNumDigits
	endLoop:

	subiu $t4,$t4,1		#String Start from index 0
	getNumberAsString:
		div $t5,$t3	# hi = reminder  # low = quotient
		mfhi $t2	#save reminer in $t2
		addiu $t2,$t2,48 		#convert to ASCII
		sb $t2,numberToPrint($t4)		#save in last Index of String
		mflo $t5 	#edit number 
		beq $t4,0,endLoop1
		beq $t5,0,endLoop1
		subiu $t4,$t4,1		#String Start from index 0
		j getNumberAsString
	endLoop1:
	li $t0,0
	printOnTheBuffer:
		lb $t1,numberToPrint($t0)
		beq $t1,'\0',printOnTheBufferEnd
		sb $t1,toPrint($t8)
		addiu $t0,$t0,1
		addiu $t8,$t8,1
		j printOnTheBuffer
	printOnTheBufferEnd:
	subiu $t8,$t8,1
jr $ra
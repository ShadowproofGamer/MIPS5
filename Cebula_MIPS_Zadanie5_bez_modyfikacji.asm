.data
 theresultsare: .asciiz "\n\nThe results are the following:\n\n"
 errorNumber: .asciiz "\nWrong input. Try again:"
 roundsNumberPrompt: .asciiz "\nWrite how much rounds do you want to play (1 - 5): "
 xOrO: .asciiz "\nWrite your sign (X or O): "
 newline: .asciiz "\n"
 makeNewCheck: .asciiz "\nWrite the number where you want to put your sign: "
 currentState: .asciiz "\nCurrent game state:\n"
 computerWin: .asciiz "\nComputer won this round!\n"
 playerWin: .asciiz "\n\nYou won this round!\n"
 creatingNewArray: .asciiz "\n Loading new array...........\n"
 array: .space 36
 resultArray: .space 20
 resultsPlayer: .asciiz "\nGames won by Player: "
 resultsComputer: .asciiz "\nGames won by Computer: "
 endOfRound: .asciiz "\nThe round has ended! If no one won then this game is a tie.\n"
 
 .text
 # $s0 - number of rounds to play
 # $s1 - users sign
 # $s2 - bot sign
 # $s3 - sign '-' 
 # $s4 - players checksum
 # $s5 - computer checksum
 # $s6 - won by player
 # $s7 - won by computer

  li $s3, 45
  li $s6, 0
  li $s7, 0

  
 
 # $t0 - current checkboard number
 # $t1 - current player
 # $t2 - if someone won or unable to move ( $t2 = 9  --> end of round )
 # $t3 - number 1 in a row/column/diagonal
 # $t4 - number 2 in a row/column/diagonal
 # $t5 - number 3 in a row/column/diagonal
 # $t6 - current checksum to check if someone won
 # $t7 - array temp value



 
 
 main:
 #loading the amount of numbers
 loadRounds:
 #prompt asking about number of rounds
 la $a0, roundsNumberPrompt
 li $v0, 4
 syscall
 li $v0, 12
 syscall
 # saving number of rounds to $s0 and checking if it's number from 1 to 5
 la $s0, ($v0)
 ble $s0, 48, wrongNumber
 bge $s0, 54, wrongNumber
 addi $s0, $s0, -48
 
 
 
 
 # loading users sign
 loadUserSign:
 la $a0, xOrO
 li $v0, 4
 syscall
 li $v0, 12
 syscall
 la $s1, ($v0)
 #checking if the sign is either X or O
 beq $s1, 79, initO
 beq $s1, 88, initX
 j wrongSign
 
 
 
 
 
 
 
 
 
 

 ##init brick starts here
 initX:
 li $s2, 79
 li $s4, 264
 li $s5, 237
 j init

 initO:
 li $s2, 88
 li $s4, 237
 li $s5, 264
 
  #initializing new array and wiping out temporary results
 init:
 li $t2, 0
 la $a0, creatingNewArray
 li $v0, 4
 syscall
 addi $t0, $zero, 0
 
 #filling array with '-' signs
 initLoop:
 sb $s3, array($t0)
 addi $t0, $t0, 4
 bne $t0, 36, initLoop
 addi $t0, $t0, -36
 #loading 
 
 
 
 
 
 
 
 loop:
 usersInput:
 # showing that player is making the move
  la $t1, ($s1)
 #prompt to make move
  la $a0, makeNewCheck
  li $v0, 4
  syscall
  #reading the number
  li $v0, 12
  syscall
  #checking what is the field we want to enter our sign into
  blt $v0, 49, wrongField
  bgt $v0, 57, wrongField
  beq $v0, 49, playerInput49
  beq $v0, 50, playerInput50
  beq $v0, 51, playerInput51
  beq $v0, 52, playerInput52
  beq $v0, 53, playerInput53
  beq $v0, 54, playerInput54
  beq $v0, 55, playerInput55
  beq $v0, 56, playerInput56
  beq $v0, 57, playerInput57
  
  #when checkin succeeded
  userCheckEnd:


 #ending the move (putting the sign in place and checking for the win)
 jal loopExec
 
 #computers turn:
 computerInput:
 #if $t2 = 9 then jump to the end
 beq $t2, 9, end
 # showing that computer is making the move
 la  $t1, ($s2)
 #jumping to computer strategy
 j computerInputCheck
 #TODO

 
 
 
 computerCheckEnd:
 jal loopExec
 
 



  end:
 #beqz $s0, init
 bne $t2, 9, loop
 addi $s0, $s0, -1
 #printing end of round prompt
 la $a0, endOfRound
 li $v0, 4
 syscall
 bnez $s0, init
 #printing Player results
  la $a0, resultsPlayer
 li $v0, 4
 syscall
 la $a0, ($s6)
 li $v0, 1
 syscall
 #printing Computer results
 la $a0, resultsComputer
 li $v0, 4
 syscall
 la $a0, ($s7)
 li $v0, 1
 syscall
 #program ends
 li $v0, 10
 syscall
 
 
 
 
 
 
 #funkcje sprawdzaj¹ce czy mo¿na wpisac znak (funkcje gracza)
 playerInput49:
 addi $t0, $zero, 0
 lb $t7, array($t0)
 bne $t7, 45, wrongField
 j userCheckEnd
 
 playerInput50:
  addi $t0, $zero, 4
  lb $t7, array($t0)
 bne $t7, 45, wrongField
 j userCheckEnd
 
 playerInput51:
  addi $t0, $zero, 8
  lb $t7, array($t0)
 bne $t7, 45, wrongField
 j userCheckEnd
 
 playerInput52:
  addi $t0, $zero, 12
  lb $t7, array($t0)
 bne $t7, 45, wrongField
 j userCheckEnd
 
 playerInput53:
  addi $t0, $zero, 16
  lb $t7, array($t0)
 bne $t7, 45, wrongField
 j userCheckEnd
 
 playerInput54:
  addi $t0, $zero, 20
  lb $t7, array($t0)
 bne $t7, 45, wrongField
 j userCheckEnd
 
 playerInput55:
  addi $t0, $zero, 24
  lb $t7, array($t0)
 bne $t7, 45, wrongField
 j userCheckEnd
 
 playerInput56:
  addi $t0, $zero, 28
  lb $t7, array($t0)
 bne $t7, 45, wrongField
 j userCheckEnd
 
 playerInput57:
  addi $t0, $zero, 32
  lb $t7, array($t0)
 bne $t7, 45, wrongField
 j userCheckEnd
 
 
 
 #computer functions
 computerInputCheck:
 
  computerInput53:
 addi $t0, $zero, 16
 lb $t7, array($t0)
 beq $t7, 45, computerCheckEnd
 
 computerInput49:
 addi $t0, $zero, 0
 lb $t7, array($t0)
 beq $t7, 45, computerCheckEnd
 
   computerInput57:
 addi $t0, $zero, 32
 lb $t7, array($t0)
 beq $t7, 45, computerCheckEnd

  computerInput50:
 addi $t0, $zero, 4
 lb $t7, array($t0)
 beq $t7, 45, computerCheckEnd
 
   computerInput51:
 addi $t0, $zero, 8
 lb $t7, array($t0)
 beq $t7, 45, computerCheckEnd
 
    computerInput55:
 addi $t0, $zero, 24
 lb $t7, array($t0)
 beq $t7, 45, computerCheckEnd
 
    computerInput56:
 addi $t0, $zero, 28
 lb $t7, array($t0)
 beq $t7, 45, computerCheckEnd
 
     computerInput52:
 addi $t0, $zero, 12
 lb $t7, array($t0)
 beq $t7, 45, computerCheckEnd
 
     computerInput54:
 addi $t0, $zero, 20
 lb $t7, array($t0)
 beq $t7, 45, computerCheckEnd
 j end
 
 
 loopExec:
 signing:
 #putting corrent players sign on the board
 sb $t1, array($t0)
  #adding 1 to all space used
 addi $t2, $t2, 1
 
 winChecking:
 #started checking with middle box
 #checking fields 1, 5, 9 (diagonal 1)
 addi $t0, $zero, 0
 lb $t3, array($t0)
  addi $t0, $t0, 16
 lb $t4, array($t0)
   addi $t0, $t0, 16
 lb $t5, array($t0)
   #standard check
 add $t6, $t3, $t4
 add $t6, $t6, $t5
 beq $t6, $s4, playerWon
 beq $t6, $s5, computerWon


  #checking fields 3, 5, 7 (diagonal 2)
  addi $t0, $zero, 8
 lb $t3, array($t0)
  #addi $t0, $zero, 16
 #lb $t4, array($t0)
   addi $t0, $zero, 24
 lb $t5, array($t0)
   #standard check
 add $t6, $t3, $t4
 add $t6, $t6, $t5
 beq $t6, $s4, playerWon
 beq $t6, $s5, computerWon
 
  #checking fields 4, 5, 6 (row 2)
 addi $t0, $zero, 12
 lb $t3, array($t0)
  #addi $t0, $zero, 16
 #lb $t4, array($t0)
   addi $t0, $zero, 20
 lb $t5, array($t0)
   #standard check
 add $t6, $t3, $t4
 add $t6, $t6, $t5
 beq $t6, $s4, playerWon
 beq $t6, $s5, computerWon
 
 
   #checking fields 2, 5, 8 (column 2)
  addi $t0, $zero, 4
 lb $t3, array($t0)
  #addi $t0, $zero, 16
 #lb $t4, array($t0)
   addi $t0, $zero, 28
 lb $t5, array($t0)
   #standard check
 add $t6, $t3, $t4
 add $t6, $t6, $t5
 beq $t6, $s4, playerWon
 beq $t6, $s5, computerWon
 
 
 #started checking with the 1st box
   #checking fields 1,2,3 (column 1)
  addi $t0, $zero, 0
 lb $t3, array($t0)
  addi $t0, $zero, 12
 lb $t4, array($t0)
   addi $t0, $zero, 24
 lb $t5, array($t0)
   #standard check
 add $t6, $t3, $t4
 add $t6, $t6, $t5
 beq $t6, $s4, playerWon
 beq $t6, $s5, computerWon
 
 
    #checking fields 1,2,3 (row 1)
  #addi $t0, $zero, 0
 #lb $t3, array($t0)
  addi $t0, $zero, 4
 lb $t4, array($t0)
   addi $t0, $zero, 8
 lb $t5, array($t0)
   #standard check
 add $t6, $t3, $t4
 add $t6, $t6, $t5
 beq $t6, $s4, playerWon
 beq $t6, $s5, computerWon
 
 
 
 
 
 
  #started checking with the last box
   #checking fields 1,2,3 (column 3)
  addi $t0, $zero, 8
 lb $t3, array($t0)
  addi $t0, $zero, 20
 lb $t4, array($t0)
   addi $t0, $zero, 32
 lb $t5, array($t0)
   #standard check
 add $t6, $t3, $t4
 add $t6, $t6, $t5
 beq $t6, $s4, playerWon
 beq $t6, $s5, computerWon
 
 
 
    #checking fields 1,2,3 (row 3)
  addi $t0, $zero, 24
 lb $t3, array($t0)
  addi $t0, $zero, 28
 lb $t4, array($t0)
   #addi $t0, $zero, 32
 #lb $t5, array($t0)
   #standard check
 add $t6, $t3, $t4
 add $t6, $t6, $t5
 beq $t6, $s4, playerWon
 beq $t6, $s5, computerWon
 
 
 
 
 
 statePrinting:
 #current state text
 la $a0, currentState
 li $v0, 4
 syscall
 
 # $t0 - array counter reset
 addi $t0, $zero, 0
 
 #printing first row
 la $a0, array($t0)
 li $v0, 4
 syscall
 
 addi $t0, $t0, 4
 la $a0, array($t0)
 li $v0, 4
 syscall
 
 addi $t0, $t0, 4
 la $a0, array($t0)
 li $v0, 4
 syscall
 
 #going to new line
 la $a0, newline
 li $v0, 4
 syscall
 
  #printing second row
 addi $t0, $t0, 4
 la $a0, array($t0)
 li $v0, 4
 syscall
 
 addi $t0, $t0, 4
 la $a0, array($t0)
 li $v0, 4
 syscall
 
 addi $t0, $t0, 4
 la $a0, array($t0)
 li $v0, 4
 syscall
 
  #going to new line
  la $a0, newline
 li $v0, 4
 syscall
 
  #printing third row
 addi $t0, $t0, 4
 la $a0, array($t0)
 li $v0, 4
 syscall
 
 addi $t0, $t0, 4
 la $a0, array($t0)
 li $v0, 4
 syscall
 
 addi $t0, $t0, 4
 la $a0, array($t0)
 li $v0, 4
 syscall
 
  #going to new line
  la $a0, newline
 li $v0, 4
 syscall
 
 #setting array pointer to the first element
 addi $t0, $t0, -32
 
 
 jr $ra
 

 
 
 
 
 
 
 #possible endings
 
 playerWon:
 la $a0, playerWin
 li $v0, 4
 syscall
 # adds 1 to players wins
 addi $s6, $s6, 1
 # prevents current round from continuing
 li $t2, 9
 jal statePrinting
 j end
 
 computerWon:
  la $a0, computerWin
 li $v0, 4
 syscall
  # adds 1 to computer wins
 addi $s7, $s7, 1
 # prevents current round from continuing
 li $t2, 9
 jal statePrinting
 j end
 
 
 
 
 
 
 
 
 
 #possible errors
 
 wrongNumber:
 la $a0, errorNumber
 li $v0, 4
 syscall
 j loadRounds
 
 
 wrongSign:
 la $a0, errorNumber
 li $v0, 4
 syscall
 j loadUserSign
 
 
  wrongField:
 la $a0, errorNumber
 li $v0, 4
 syscall
 j usersInput
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 	#œmietniczek:
  #printing number of lines
 la $a0, newline
 li $v0, 4
 syscall
 la $a0, ($s0)
 li $v0, 1
 syscall
 
 #zapelnianie tablicy:
 addi $t0, $t0, 4
   li $s3, 49
  sb $s3, array($t0)
  addi $t0, $t0, 4
  li $s3, 50
  sb $s3, array($t0)
  addi $t0, $t0, 4
  li $s3, 51
  sb $s3, array($t0)
  addi $t0, $t0, 4
  li $s3, 52
  sb $s3, array($t0)
  addi $t0, $t0, 4
  li $s3, 53
  sb $s3, array($t0)
  addi $t0, $t0, 4
  li $s3, 54
  sb $s3, array($t0)
  addi $t0, $t0, 4
  li $s3, 55
  sb $s3, array($t0)
 
 
 
  #TEST zapelnianie pierwszych dwóch miejsc
  sb $s1, array($t0)
  addi $t0, $t0, 4
  sb $s2, array($t0)
  
  #test2
   addi $t0, $t0, 4
   li $s3, 45
    sb $s3, array($t0)
   #
   
  addi $t0, $t0, -8
 #


 #TEST array i variable
  addi $t0, $zero, 0
  sb $s2, array($t0)
   addi $t0, $t0, 12
   sb $s2, array($t0)
   addi $t0, $zero, 0
   sb $s1, array($t0)
 #
 
 
 
 
 
    #TEST zapelnianie by wywolac wygranom
  addi $t0, $zero, 0
  sb $s1, array($t0)
  addi $t0, $t0, 4
  sb $s1, array($t0)
  
  #test2
   addi $t0, $t0, 4
 
    sb $s2, array($t0)
   #
   
  addi $t0, $t0, -8
 #
 #TEST
  addi $t0, $zero, 16
  sb $s1, array($t0)
  addi $t0, $zero, 32
  sb $s1, array($t0)
  addi $t0, $zero, 0
 #

 #TEST used to NOT loop !!
 li $t2, 9
 #
 
 
 
  
 
 
 
 standardCheck:
  #standard check
 add $t6, $t3, $t4
 add $t6, $t6, $t5
 beq $t6, $s4, playerWon
 beq $t6, $s5, computerWon
 jr $ra
 
 
 
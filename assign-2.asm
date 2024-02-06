; Keona Abad
; CS 271 Computer Architecture and Assembly Language
; Program 1 Intro to MASM Assembly January 24, 2024
; Description: This program calculates the factors of each number within a range of numbers from
; the lower bound to the upper bound and indicates which numbers are prime.

INCLUDE Irvine32.inc
.386
.model flat, stdcall
.stack 4096

.data
startMessage BYTE "CS 271 HW2 - Factors", 0dh, 0ah, 0
infoMessage BYTE "This program calculates and displays the factors of numbers from lowerbound to upperbound.", 0dh, 0ah, 0
infoMessage2 BYTE "It also indicates when a number is prime.", 0dh, 0ah, 0
promptName BYTE "Enter your name: ", 0
promptUpper BYTE "Enter a number between 1 and 1000 for the upperbound of the range: ", 0
promptLower BYTE "Enter a number between 1 and 1000 for the lowerbound of the range: ", 0
errorMsg BYTE "Invalid input. Please enter a number between 1 and 1000.", 0dh, 0ah, 0
repeatPrompt BYTE "Would you like to do another calculation (0=NO 1=YES)?: ", 0
userName BYTE 50 dup(0)
primeMessage BYTE " ** Prime Number **", 0dh, 0ah, 0
partingMessage BYTE "Goodbye", 0dh, 0ah, 0
factorPrompt BYTE ":", 0
actualNameLen DWORD ?
upperNumber DWORD ? 
lowerNumber DWORD ?
repeatFlag DWORD ?
MAX_VALUE EQU 1000 ; This defines the constant for the maximum value


.code
main PROC
; Displays Program Name and Instructions
call clrscr
mov edx, OFFSET startMessage
call WriteString
mov edx, OFFSET infoMessage 
call WriteString
mov edx, OFFSET infoMessage2
call WriteString

; Prompts and Reads the User's Name
mov edx, OFFSET promptName
call WriteString
mov ecx, SIZEOF userName
lea edx, userName
call ReadString
mov [actualNameLen], eax




; Main loop to allow the user to repeat the calculations
main_loop:
; Reads and validates the lower bound
read_lower:
mov edx, OFFSET promptLower
call WriteString
call ReadInt
cmp eax, 1
jl invalid_input ; Less than 1
cmp eax, MAX_VALUE
jg invalid_input ; Greater than MAX_VALUE
mov lowerNumber, eax ; Valid input, store in lowerNumber

; Reads and validates the upper bound
read_upper:
mov edx, OFFSET promptUpper
call WriteString
call ReadInt
cmp eax, lowerNumber
jle invalid_input ; Less than or equal to lowerNumber
cmp eax, MAX_VALUE
jg invalid_input ; Greater than MAX_VALUE
mov upperNumber, eax ; Valid input, store in upperNumber

; Loops through numbers and check for primes
mov ecx, lowerNumber
check_range_loop:
cmp ecx, upperNumber
jg check_range_end ; End of range
mov eax, ecx
call printFactors ; Check if current number is prime
inc ecx
jmp check_range_loop
check_range_end:

; Ask if the user wants to repeat the calculation
mov edx, OFFSET repeatPrompt
call WriteString
call ReadInt
mov repeatFlag, eax
cmp eax, 1
je main_loop

; Exit the program
exit_program:
mov edx, OFFSET partingMessage
call WriteString
mov edx, OFFSET userName
call WriteString
invoke ExitProcess, 0


; Handle invalid input
invalid_input:
mov edx, OFFSET errorMsg
call WriteString
jmp read_lower

main ENDP




; Procedure to print factors and check if a number is prime
printFactors PROC
pushad                     ; Save all registers
mov     ebx, eax           ; Move the number into ebx for factor checking
mov     ecx, 1             ; Start divisor from 1
mov     esi, 0             ; Reset factor count

; Print the number before listing its factors
call    WriteDec
mov     edx, OFFSET factorPrompt
call    WriteString

; Print 1 as a factor for all numbers
mov     eax, 1
call    WriteDec
mov     al, ' '
call    WriteChar
inc     esi                 ; Increments factor count as 1 is a factor of all numbers

; Find and print factors
find_factors_loop:
inc     ecx                 ; Increases the divisor
cmp     ecx, ebx
jge     check_prime         ; If divisor is greater or equal to the number, check if it's a prime

mov     eax, ebx
xor     edx, edx            ; Clears the remainder for div
div     ecx                 ; Divides ebx by ecx
cmp     edx, 0              ; Checks if remainder is zero (which means ecx is a factor)
jne     find_factors_loop   ; If not, continues loop without printing

; Print the factor
mov     eax, ecx
call    WriteDec            ; Prints the divisor (factor)
mov     al, ' '
call    WriteChar
inc     esi                 ; Increments factor count

jmp     find_factors_loop   ; Continues the loop

check_prime:
cmp     esi, 1              ; Prime numbers have exactly two factors: 1 and themselves
je      is_prime            ; If only one factor was printed, it's prime

print_factors:
; Prints the current number as a factor for non-prime numbers
mov     eax, ebx
call    WriteDec            ; Print the number itself as the last factor
mov     al, ' '
call    WriteChar

is_prime:
; If the number is prime, prints its own value again as it's a factor of itself
cmp     esi, 1              ; Checks if we printed only one factor
je      print_prime_message ; If so, it's a prime number

print_prime_message:
; Prints prime message if the number is prime
cmp     esi, 1
je      print_prime_number  ; Only prints prime message if prime

print_end_line:
call    Crlf               ; New line for the next number
popad                      ; Restores all registers
ret

print_prime_number:
mov     edx, OFFSET primeMessage
call    WriteString
jmp     print_end_line

printFactors ENDP
END main
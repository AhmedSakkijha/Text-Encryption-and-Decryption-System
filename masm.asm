INCLUDE Irvine32.inc


; **  Assembly Code **  
; yaman alrifai = 202310624 
; Ahmed Rafiq Sakkijha = 202211509



BUFMAX = 128 ; maximum buffer size

.data
sPrompt BYTE  "Enter the plain text: ", 0
sKeyPrompt BYTE  "Enter the key: ", 0
sEncrypt BYTE  "Cipher text:          ", 0
sDecrypt BYTE  "Decrypted:            ", 0

buffer BYTE   BUFMAX+1 DUP(0)
key BYTE     BUFMAX+1 DUP(0)

bufSize DWORD  ?
keySize DWORD  ?



.code
main PROC
    ; Input Plain Text
    mov edx, OFFSET sPrompt
    call WriteString
    call InputTheString

    ; Input Key
    mov edx, OFFSET sKeyPrompt
    call WriteString
    call InputTheKey

    ; Translate (Encrypt) the Buffer
    call TranslateBuffer

    ; Display Encrypted Message
    mov edx, OFFSET sEncrypt
    call DisplayMessage

    ; Translate (Decrypt) the Buffer
    call TranslateBuffer

    ; Display Decrypted Message
    mov edx, OFFSET sDecrypt
    call DisplayMessage

    exit
main ENDP

;----------------------------------------------------------------
InputTheString PROC
; Prompts user for a plaintext string. Saves the string 
; and its length.
; Receives: nothing
; Returns: nothing
;----------------------------------------------------------------
    mov ecx, BUFMAX      ; maximum character count
    mov edx, OFFSET buffer   ; point to the buffer
    call ReadString        ; input the string
    mov bufSize, eax       ; save the length
    call Crlf
    ret
InputTheString ENDP

;----------------------------------------------------------------
; ******
InputTheKey PROC
; Prompts user for a key string. Saves the string 
; and its length.
; Receives: nothing
; Returns: nothing
;----------------------------------------------------------------
    mov ecx, BUFMAX         ; maximum character count
    mov edx, OFFSET key     ; point to the key buffer
    call ReadString         ; input the string
    mov keySize, eax        ; save the length
    call Crlf
    ret
InputTheKey ENDP

;----------------------------------------------------------------
DisplayMessage PROC
; Displays the encrypted or decrypted message.
; Receives: EDX points to the message
; Returns:  nothing
;----------------------------------------------------------------
    call WriteString
    mov edx, OFFSET buffer   ; display the buffer
    call WriteString
    call Crlf
    call Crlf
    ret
DisplayMessage ENDP

;----------------------------------------------------------------
; *****
TranslateBuffer PROC

;(Addressing Modes - Direct & Register)
; Translates the string by exclusive-ORing each byte with the 
; corresponding byte in the key. Repeats the key if necessary.
; Receives: nothing
; Returns: nothing
;----------------------------------------------------------------

    mov ecx, bufSize     ; loop counter (Register)
    mov esi, 0           ; index 0 in buffer (Direct)

L1:
    ; Key Repetition Logic (Modulo for remainder)
    mov ebx, esi        ; copy esi to ebx (Register)
    mov eax, ebx        ; copy ebx to eax for division (Register)
    xor edx, edx        ; clear edx before division (Register)
    div keySize         ; divide edx:eax by keySize, quotient in eax, remainder in edx
    mov ebx, edx        ; remainder in edx, move to ebx (Register)
        ; ----------------------------------------------------------------

    mov edi, OFFSET key ; base address of key
    add edi, ebx        ; add remainder to base address (Base + Offset)
        ; ----------------------------------------------------------------

    mov al, buffer[esi] ; load byte from buffer (Register)
    xor al, [edi]       ; XOR with corresponding key byte (Indirect)
    mov buffer[esi], al ; store result back in buffer (Register)
        ; ----------------------------------------------------------------

    inc esi             ; point to next byte (Register)
    loop L1

    ret
TranslateBuffer ENDP
END main


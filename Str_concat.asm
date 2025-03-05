include Irvine32.inc
Str_concat PROTO, pTarget:PTR BYTE, pSource:PTR BYTE

.data
targetStr BYTE "ABCDE", 10 DUP(0), 0 ; note if you want to remove this extra 0 at the end you can, however it is not recommended since it will break concatenation w spaces and you will have to DELETE line 75 if u do choose to remove the extra 0
sourceStr BYTE "FGH", 0
successMSG Byte "Success!", 0 ; this is optional however the question does ask for checking to see if there is a valid amount of space in targetStr
failedMSG Byte "Your target string failed to have enough space!", 0 ; this is optional however the question does ask for checking to see if there is a valid amount of space in targetStr
; to remove optional successMSG and failedMSG delete everything from lines 14-25 .

.code
main PROC
    INVOKE Str_concat, ADDR targetStr, ADDR sourceStr
    cmp eax, 0
    je failed
    mov edx, offset successMSG
    call WriteString
    call crlf
    mov edx, offset targetStr
    call WriteString
    jmp skip
    failed:
    mov edx, offset failedMSG
    call WriteString
    skip:
    exit
main ENDP


Str_concat PROC,
    pTarget:PTR BYTE, pSource:PTR BYTE
    push esi
    push edi
    push ecx
    push edx

    mov esi, pSource
    mov ecx, 0

    findSourceStringLength:
        push esi
        cmp BYTE PTR [esi], 0
        je finishedCounting
        inc ecx
        inc esi
        jmp findSourceStringLength
        finishedCounting:
        pop esi

    mov edx, ecx ; edx has the length of source string
    ; so basically the TargetString must have enough 0's, it must have 3 0's
    mov ecx, 0
    mov edi, pTarget
    findTargetStringLength:
        cmp BYTE PTR [edi], 0
        je countDone
        inc ecx
        inc edi
        jmp findTargetStringLength
        countDone:

    mov eax, ecx ; EAX HAS THE VALUE OF TARGETSTRINGLENGTH
    mov edi, pTarget
    add edi, eax ; WE WILL BE MOVING EDI TO AFTER THE STRING IS DONE, TO COUNT THE ZEROES
    mov ecx, 0

    findIfEnoughSpace:
        cmp BYTE PTR [edi], 20h ; this accounts for spaces (we dont want to treat them as a 0)
        je doneCountingSpace
        cmp BYTE PTR [edi], 0
        jne doneCountingSpace
        inc ecx
        inc edi
        jmp findIfEnoughSpace
        doneCountingSpace:
        dec ecx ; this accounts for the zero ending we put for fun to make it work w concatenation for spaces

    mov ebx, ecx ; this is the amount of zeroes so yea


    CheckSpaceValidity:
        cmp ebx, edx
        jb SizeErr
        mov ecx, edx
        mov esi, pSource
        mov edi, pTarget
        add edi, eax
        L1: 
            mov al, [esi]
            mov [edi], al
            inc esi
            inc edi
            loop L1
            jmp success

    SizeErr:
    mov eax, 0
    jmp skipSuccess

    success:
    mov eax, 1
    skipSuccess:
    ret

Str_concat ENDP

end main ; end of program

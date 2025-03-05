include Irvine32.inc
FindLargest PROTO, arrayPassed: PTR DWORD, count:DWORD

.data
array DWORD 21h, 34h, 52h, 12h, 13h, 5h
arrayLength = lengthof array

.code
main PROC
INVOKE FindLargest, addr array, arrayLength
    exit
main ENDP


FindLargest PROC uses esi ecx,
    arrayPassed: PTR DWORD, count: DWORD
    mov esi, arrayPassed
    mov ecx, count
    mov eax, [esi]
    add esi, type arrayPassed

    L1:
        mov ebx, [esi]
        cmp ebx, eax
        ja NumberChangedBecauseGreater
        jmp NumberDoesNotChange
        NumberChangedBecauseGreater:
        mov eax, ebx
        NumberDoesNotChange:
        add esi, type arrayPassed
        loop L1

    ret
FindLargest ENDP

end main ; end of program
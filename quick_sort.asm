data segment
    a dw 9999h,8888h,7777h,666h,4444h,333h,222h,111h,100h,99h,88h,77h,66h,55h,44h,43h,42h,41h,40h,39h,38h,37h,36h,35h,34h,33h,32h,31h,30h,29h,28h,27h,26h,25h,24h,23h,22h,21h,20h,19h,18h,17h,16h,14h,13h,12h,11h,10h,2h,0h
    low dw 0h
    high dw 49 ;N-1
    mid dw 0h
    k dw 0h
data ends


stack_seg segment stack
    st db 320 dup(0)
    top equ 320  
stack_seg ends
    
    
code segment
    assume cs:code, ds:data, ss:stack_seg
start:     
    mov ax, data
    mov ds, ax
    mov ax, stack_seg
    mov ss, ax
    mov sp, top
    
    call qsort
    
    mov ax, 4c00h
    int 21h
    
    qsort proc near
        push bp
        mov bp, sp 
        push high
        push low
        
        mov ax, low
        sub ax, high
        jns jumpto 
        
        call par
        push mid
        
        sub mid, 1
        jns negerr
        add mid, 1
        negerr:
        mov ax, mid
        mov high, ax
        pop mid
        pop low
        push mid
        call qsort 
        
        pop mid
        add mid, 1
        mov ax, mid 
        mov low, ax
        pop high
        call qsort
        jmp jumpt
        
        jumpto: pop low
        pop high
        jumpt: pop bp  
        ret
    qsort endp
    
    par proc near 
        push bp
        mov bp, sp 

        mov cx, ss:[bp+4] ;low
        mov dx, ss:[bp+6] ;high
        
        mov bx, cx
        add bx, cx
        mov ax, [bx]
        mov k, ax
        
        jpto: 
        
        jmp loop1
        cloop1: sub dx, 1
        loop1: mov ax, cx
        sub ax, dx
        jns skip1
        mov bx, dx
        add bx, dx
        mov ax, [bx]
        sub ax, k
        jnc cloop1
        
        skip1: 
        
        mov ax, cx
        sub ax, dx
        jnc jump1
        mov bx, dx
        add bx, dx
        mov ax, [bx]
        mov bx, cx
        add bx, cx
        mov [bx], ax
        add cx, 1
        
        jump1:
        
        jmp loop2 
        cloop2: add cx, 1
        loop2: mov ax, cx
        sub ax, dx
        jnc skip2
        mov ax, k
        mov bx, cx
        add bx, cx
        sub ax, [bx]
        jnc cloop2
         
        skip2:
         
        mov ax, cx
        sub ax, dx
        jnc jump2
        mov bx, cx
        add bx, cx
        mov ax, [bx]
        mov bx, dx
        add bx, dx
        mov [bx], ax
        sub dx, 1
        
        jump2:  
        
        mov ax, cx
        sub ax, dx
        jnz jpto
        
        mov ax, k 
        mov bx, cx
        add bx, cx
        mov [bx], ax
        
        mov mid, cx
        
        pop bp    
        ret 
    par endp
       
code ends

end start

data segment
    meau db 'Please input the function number(1~5):$' 
    str1 db 'function 1:change small letters into capital letters of string.', 0DH, 0AH, '$'
    str2 db 'function 2:of finding the maximum of string.', 0DH, 0AH, '$'
    str3 db 'function 3:sort datas.', 0DH, 0AH, '$'
    str4 db 'function 4:show time.', 0DH, 0AH, '$'
    str5 db 'Exit.$'
    str2ed db 'The maximum is:$'
    strnxt db 'Do you want to do next?[Esc/any other key]:$'
    input db 'Please input a string:$'
    inputnum db 'Please input some numbers:$'
    clrf db  0DH, 0AH, '$'
    
    opt db 10
        db 0
        db 10 dup(0)
    
    str db 100
        db 0
        db 100 dup(0)
        
    shuzi_b db 0
    shuzi_s db 0
    key dw 100 dup(0) ;��������ŵ�λ��
    
    buffer dw 0    ;�ݴ�λ��
    space db 0dh, 0ah, 24h
    n db 0 ;���ָ���
    n1 db 0 ;���ָ���
    
data ends

stack segment stack
    dw 100H dup(0)
stack ends


code segment
assume cs:code, ds:data ss, stack

xianshidangeshuzi proc
    push dx
    push ax
    mov dx, 0
    mov dl, al
    xor ax, ax
    mov ah, 02h
    int 21h
    pop ax
    pop dx
    ret
xianshidangeshuzi endp

shujuxianshi proc
    push ax
    push bx
    push cx
    push dx
    mov cx, 100
    div cx
    xor bx, bx
    mov bl, dl ;��������
    mov shuzi_b, al
    cmp shuzi_b, 0
    je j1
    add al, 30h
    call xianshidangeshuzi

j1:
    mov ax, bx
    mov dx, 0
    mov cx, 10
    div cx
    xor bx, bx
    mov bl, dl ;��������
    mov shuzi_s, al
    cmp shuzi_s, 0
    je j2
    add al, 30h
    call xianshidangeshuzi
j2:
    mov al, bl
    add al, 30h
    call xianshidangeshuzi
    
    pop dx
    pop cx
    pop bx
    pop ax
    
    ret
shujuxianshi endp
    
shiliu proc
    push ax
    push bx
    push cx
    push dx
    
    mov cl, 16   
    div cl
    
    cmp al, 0Ah ;С��10,
    jc s1
    
    add al, 55
    call xianshidangeshuzi
    jmp dew
    
s1:
    add al, 48
    call xianshidangeshuzi

dew:
    mov al, ah
    
    cmp al, 0Ah ;С��10,
    jc s2 
    
    add al, 55
    call xianshidangeshuzi
    jmp shuchuh
    
s2:
    add al, 48
    call xianshidangeshuzi    
    
shuchuh:    
    mov ah, 2
    mov dl, 'H'
    int 21h
    
    pop dx
    pop cx
    pop bx
    pop ax        
shiliu endp


show_space proc
    push ax
    push dx
    mov ah, 2
    mov dl, 32
    int 21h
    pop dx
    pop ax
    ret
show_space endp

decimal proc ;��al�е�����ʮ�������
    ;�������al
    ;���������
    cbw
    push cx
    push dx
    mov cl, 10
    div cl  ; ax16λ�����Ƴ��԰�λ�����ƣ��̱�����al�У�����������ah��
    add ah, '0' ;int to char
    mov bh, ah ;������bh
    add al, '0'
    
    mov ah, 2
    mov dl, al
    int 21h
    mov dl, bh
    int 21h
    pop dx
    pop cx
    ret
decimal endp

enter proc
    push ax
    push dx
    lea dx, clrf  ;��ȡһ��
    mov ah, 9
    int 21h
    pop dx
    pop ax
    ret
enter endp

start:
    mov ax, data  ;��ʼ��
    mov ds, ax
    mov es, ax
    mov ax, stack
    mov ss, ax
;-------------------------------------------------
    call enter ;����   
    lea dx, meau  ;��ʾ�˵�
    mov ah, 9
    int 21h
    
    lea dx, opt ; ���빦��1-5
    mov ah, 0ah
    int 21h
    
    call enter  ;��ȡһ��
;-------------------------------------------------    
    
    mov al, opt+2  ;�жϺ�������
    cmp al, 49 ;��ת����1
    je f1
    cmp al, 50 ;��ת����2
    je f2
    cmp al, 51 ;��ת����3
    je f3
    cmp al, 52 ;��ת����4
    je f4
    jmp fin
    
    
    
;-------------------------------------------------
;��ӡ��������    
f1: lea dx, str1  ;��ʾ����1����
    mov ah, 9
    int 21h
    jmp ip
    
f2: lea dx, str2  ;��ʾ����2����
    mov ah, 9
    int 21h
    jmp ip
    
f3: lea dx, str3  ;��ʾ����3����
    mov ah, 9
    int 21h
    jmp fun3
    
f4: lea dx, str4  ;��ʾ����4����
    mov ah, 9
    int 21h
;-----------------------------------
;����4 ʱ��    
    mov ah, 2ch ; ȡϵͳʱ��, CH,CL,DH�ֱ���ʱ����
    int 21h
    
    mov al, ch
    call decimal ;ʱ
    
    mov ah, 2
    mov dl, ':'  ;ð��
    int 21h
    
    mov al, cl
    call decimal ;��
    
    mov ah, 2
    mov dl, ':'  ;ð��
    int 21h
    
    mov al, dh
    call decimal ;��
    
    jmp nxt
    
;------------------------------------------------
;�����ַ���    
ip: lea dx, input  ;��ʾ�������ַ���
    mov ah, 9
    int 21h
    
    lea dx, str ; �����ַ���
    mov ah, 0ah
    int 21h
    
    call enter ; ����
    
    mov al, str+1 ;���ַ������д���ӽ�����
    add al, 2
    mov ah, 0
    mov si, ax
    mov str[si], '$'
;----------------------------------------------------    
;�ٴν������������ж�
    mov al, opt+2  ;�жϺ�������
    cmp al, 49 ;��ת����1
    je fun1
    cmp al, 50 ;��ת����2
    je fun2   
;----------------------------------------------------
;����1 Сдת��д
fun1:
    xor cx, cx ;����
    mov cl, str+1 ;cl���ַ���ʵ�ʳ���
    lea si, str+2 ;lea���ַ����׵�ַ
    
l1: mov al, [si]  ;Сдת��дѭ��
    cmp al,40H
    jc nn1
    and al, 11011111b
    mov [si], al
nn1:inc si
    loop l1    
    lea dx, str+2 ;������
    mov ah, 9
    int 21h
    jmp nxt
;----------------------------------------------------
;����2 �����
fun2:
    xor cx, cx
    mov cl, str+1 ;cl���ַ���ʵ�ʳ���
    lea si, str+2 ;lea���ַ����׵�ַ
    
    mov bx, 0
    
l2: mov al, [si]
    cmp al, bl
    jc n2   
    mov bl, al
n2: inc si
    loop l2    
    
    
    lea dx, str2ed  ;����2���ֵ
    mov ah, 9
    int 21h
    
    mov ah, 2  ;������
    mov dl, bl 
    int 21h

    jmp nxt
;---------------------------------------------------
;����3 ����
fun3:

    lea dx, inputnum  ;��ʾ����������
    mov ah, 9
    int 21h
    call enter
    
    lea di, key
getint:
    mov ah, 08h ;����һ���ַ�
    int 21h
    
    cmp al, 0dh ;�س�
    je read_end
    
    cmp al, '0' ;������
    jb konge
    cmp al, '9'
    ja konge
    
    ;������
    mov ah, 2
    mov dl, al 
    int 21h  ;��ʾ����
    
    sub al, 30h
    mov ah, 0
    push ax  ;�������������
    
    mov bx, buffer
    mov ax, 10
    mul bx ;ax = 10  �� buffer
    
    pop bx ;�������ax��ֵ��bx
    add ax, bx
    
    mov buffer, ax ;������
    mov [di], ax   ;�����������
    
    jmp getint
    
konge:
    call show_space ;��ʾ�ո�
    add di, 2      ;��ַת��
    inc n          ;���ָ���+1
    mov ax, 0
    mov buffer, ax ; buffer��ʼ��
    
    jmp getint ;������һ������
    
read_end:
    inc n          ;���ָ���+1
    call enter ;

;-------------ʮ������ʾ    
    xor cx, cx
    mov cl, n
    lea di, key
    
l31: 
    mov ax, [di]
    call shujuxianshi
    call show_space
    add di, 2
    loop l31
    call enter
;-------------ʮ��������ʾ
    call enter
    xor cx, cx
    mov cl, n
    lea di, key
    
l32: 
    mov ax, [di]
    call shiliu
    add di, 2
    loop l32
    call enter

;---------------����
sort:
    mov al, n
    mov n1, al; ��ѭ��
    
    cmp n, 1
    je paiwan
    
loop1:
    mov cl, n
    mov ch, 0; ��ѭ��
    dec cx
    lea bx, key
    loop2:
        mov ax, [bx]
        cmp ax, [bx+2]
        jna loop3 ; [ax]������[bx+2] ������
        push ax
        mov ax,[bx+2]
        mov [bx], ax
        pop ax
        mov [bx+2], ax
    loop3:
        add bx, 2
        loop loop2
    dec n1
    jz paiwan
    jmp loop1
    
paiwan:        
  ;-------------ʮ��������ʾ
    call enter
    xor cx, cx
    mov cl, n
    lea di, key
    
l33: 
    mov ax, [di]
    call shiliu
    add di, 2
    loop l33
    call enter
    
    jmp nxt

;----------------------------
;��ת    
nxt:call enter

    lea dx, strnxt  ;�Ƿ�����
    mov ah, 9
    int 21h
    
    lea dx, opt  ;�����ַ���
    mov ah, 0ah
    int 21h
    
    call enter  ;����
    
    mov al, opt+2
    cmp al, 27 ;27��ese, ֹͣ
    je fin
    
    jmp start
    
    
    
fin:lea dx, str5  ;��ʾ�˳�
    mov ah, 9
    int 21h
    
    mov ah, 4ch  ;����
    int 21h
    
code ends
end start
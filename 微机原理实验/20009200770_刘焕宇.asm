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
    key dw 100 dup(0) ;输入数存放的位置
    
    buffer dw 0    ;暂存位置
    space db 0dh, 0ah, 24h
    n db 0 ;数字个数
    n1 db 0 ;数字个数
    
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
    mov bl, dl ;保存余数
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
    mov bl, dl ;保存余数
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
    
    cmp al, 0Ah ;小于10,
    jc s1
    
    add al, 55
    call xianshidangeshuzi
    jmp dew
    
s1:
    add al, 48
    call xianshidangeshuzi

dew:
    mov al, ah
    
    cmp al, 0Ah ;小于10,
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

decimal proc ;把al中的数以十进制输出
    ;输入参数al
    ;输出参数无
    cbw
    push cx
    push dx
    mov cl, 10
    div cl  ; ax16位二进制除以八位二进制，商保留在al中，余数保留在ah中
    add ah, '0' ;int to char
    mov bh, ah ;余数给bh
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
    lea dx, clrf  ;另取一行
    mov ah, 9
    int 21h
    pop dx
    pop ax
    ret
enter endp

start:
    mov ax, data  ;初始化
    mov ds, ax
    mov es, ax
    mov ax, stack
    mov ss, ax
;-------------------------------------------------
    call enter ;换行   
    lea dx, meau  ;显示菜单
    mov ah, 9
    int 21h
    
    lea dx, opt ; 输入功能1-5
    mov ah, 0ah
    int 21h
    
    call enter  ;另取一行
;-------------------------------------------------    
    
    mov al, opt+2  ;判断函数类型
    cmp al, 49 ;跳转功能1
    je f1
    cmp al, 50 ;跳转功能2
    je f2
    cmp al, 51 ;跳转功能3
    je f3
    cmp al, 52 ;跳转功能4
    je f4
    jmp fin
    
    
    
;-------------------------------------------------
;打印函数功能    
f1: lea dx, str1  ;显示函数1功能
    mov ah, 9
    int 21h
    jmp ip
    
f2: lea dx, str2  ;显示函数2功能
    mov ah, 9
    int 21h
    jmp ip
    
f3: lea dx, str3  ;显示函数3功能
    mov ah, 9
    int 21h
    jmp fun3
    
f4: lea dx, str4  ;显示函数4功能
    mov ah, 9
    int 21h
;-----------------------------------
;功能4 时间    
    mov ah, 2ch ; 取系统时间, CH,CL,DH分别存放时分秒
    int 21h
    
    mov al, ch
    call decimal ;时
    
    mov ah, 2
    mov dl, ':'  ;冒号
    int 21h
    
    mov al, cl
    call decimal ;分
    
    mov ah, 2
    mov dl, ':'  ;冒号
    int 21h
    
    mov al, dh
    call decimal ;秒
    
    jmp nxt
    
;------------------------------------------------
;输入字符串    
ip: lea dx, input  ;显示请输入字符串
    mov ah, 9
    int 21h
    
    lea dx, str ; 输入字符串
    mov ah, 0ah
    int 21h
    
    call enter ; 换行
    
    mov al, str+1 ;对字符串进行处理加结束符
    add al, 2
    mov ah, 0
    mov si, ax
    mov str[si], '$'
;----------------------------------------------------    
;再次进行三个条件判断
    mov al, opt+2  ;判断函数类型
    cmp al, 49 ;跳转功能1
    je fun1
    cmp al, 50 ;跳转功能2
    je fun2   
;----------------------------------------------------
;功能1 小写转大写
fun1:
    xor cx, cx ;清零
    mov cl, str+1 ;cl放字符串实际长度
    lea si, str+2 ;lea放字符串首地址
    
l1: mov al, [si]  ;小写转大写循环
    cmp al,40H
    jc nn1
    and al, 11011111b
    mov [si], al
nn1:inc si
    loop l1    
    lea dx, str+2 ;输出结果
    mov ah, 9
    int 21h
    jmp nxt
;----------------------------------------------------
;功能2 找最大
fun2:
    xor cx, cx
    mov cl, str+1 ;cl放字符串实际长度
    lea si, str+2 ;lea放字符串首地址
    
    mov bx, 0
    
l2: mov al, [si]
    cmp al, bl
    jc n2   
    mov bl, al
n2: inc si
    loop l2    
    
    
    lea dx, str2ed  ;函数2最大值
    mov ah, 9
    int 21h
    
    mov ah, 2  ;输出结果
    mov dl, bl 
    int 21h

    jmp nxt
;---------------------------------------------------
;功能3 排序
fun3:

    lea dx, inputnum  ;显示请输入数字
    mov ah, 9
    int 21h
    call enter
    
    lea di, key
getint:
    mov ah, 08h ;读入一个字符
    int 21h
    
    cmp al, 0dh ;回车
    je read_end
    
    cmp al, '0' ;非数字
    jb konge
    cmp al, '9'
    ja konge
    
    ;是数字
    mov ah, 2
    mov dl, al 
    int 21h  ;显示该数
    
    sub al, 30h
    mov ah, 0
    push ax  ;保存输入的数字
    
    mov bx, buffer
    mov ax, 10
    mul bx ;ax = 10  乘 buffer
    
    pop bx ;将保存给ax的值给bx
    add ax, bx
    
    mov buffer, ax ;给缓存
    mov [di], ax   ;给留存的数组
    
    jmp getint
    
konge:
    call show_space ;显示空格
    add di, 2      ;地址转移
    inc n          ;数字个数+1
    mov ax, 0
    mov buffer, ax ; buffer初始化
    
    jmp getint ;输入下一个数字
    
read_end:
    inc n          ;数字个数+1
    call enter ;

;-------------十进制显示    
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
;-------------十六进制显示
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

;---------------排序
sort:
    mov al, n
    mov n1, al; 外循环
    
    cmp n, 1
    je paiwan
    
loop1:
    mov cl, n
    mov ch, 0; 内循环
    dec cx
    lea bx, key
    loop2:
        mov ax, [bx]
        cmp ax, [bx+2]
        jna loop3 ; [ax]不大于[bx+2] 不交换
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
  ;-------------十六进制显示
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
;跳转    
nxt:call enter

    lea dx, strnxt  ;是否重做
    mov ah, 9
    int 21h
    
    lea dx, opt  ;输入字符串
    mov ah, 0ah
    int 21h
    
    call enter  ;换行
    
    mov al, opt+2
    cmp al, 27 ;27是ese, 停止
    je fin
    
    jmp start
    
    
    
fin:lea dx, str5  ;显示退出
    mov ah, 9
    int 21h
    
    mov ah, 4ch  ;结束
    int 21h
    
code ends
end start
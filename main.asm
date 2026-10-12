section .text
%include "define.asm"                   
[org 7C00h]                             
    xor ax,ax                           
    mov ss,ax                           
    mov sp,7C00h                        
    mov ds,ax                           
    mov es, ax
    mov [bootdisk],dl
    mov bx,7e00h        ; ES:BX = 0:7e00h
    mov ah,02h          ; 读扇区功能
    mov al,03h          ; 读3个扇区
    mov ch,00h          ; 柱面0
    mov cl,02h          ; 扇区2
    mov dh,00h          ; 磁头0
    int 13h     
    ;在下面写您的代码                 
    cli
    mov al,00010000b    ;ICW1,边沿触发，级联
    out 20h,al          ;送入主8259A的控制字寄存器
    nop
    out 0a0h,al         ;送入从8259A的控制字寄存器
    mov al,20h          ;主8259A的ICW2，主8259A初始中断向量号为20h（低三位为0，同时指IRQ0）
    out 21h,al          ;送入主8259A的数据端口
    mov al,28h          ;从8259A的ICW2，从8259A初始中断向量号为28h（低三位为0，同时指IRQ8）
    out 0a1h,al         ;送入从8259A的数据端口
    mov al,00000100b    ;主8259A的ICW3，表明从8259A在它的IRQ2
    out 21h,al          ;送入主8259A的数据端口
    mov al,2h           ;从8259A的ICW3，表明是IRQ2
    out 0a1h,al         ;送入从8259A的数据端口       
    ; 加载第二扇区
    mov ah,01h      ; 功能号：设置光标形状
    mov cx,2607h    ; CH = 起始行(26h=第38行，超出范围=隐藏)，CL = 结束行(07h)
    int 10h          ; 调用 BIOS 视频服务
    mov cx,10d
    call delay
    mov ax,0b800h
    mov es,ax
    mov dx,lanhuacao
    song:
        mov si,dx
    song_loop:
        mov ax,[si]
        mov cx,[si+2]
        mov bx,[si+4]
        add si,6
        call sound
        cmp [si],word 0
    jne song_loop
    jmp song
jmp $                                   ;通过循环停在这里，防止出现错误
%include "sub.asm"
;所有含db的内容请一定放到这一行下面！！！


db 510-($-$$) dup (0)                   ;计算离510字节(还有2字节55AA)还差多少字节,$-$$为当前地址($)减去开头的地址($$),即目前程序的长度
db 55h,0AAh        
bootdisk:   db 0
car_pos:    db 30                        ;车尾离屏幕右侧的位置
lanhuacao:  
    pitch #d2,8,0
    pitch #a2,5,1
    pitch #a2,5,1
    pitch #a2,5,1
    pitch #a2,14,0
    pitch #g2,6,0
    pitch #f2,8,0
    pitch #g2,3,0
    pitch #f2,6,0
    pitch f2,6,0
    pitch #d2,17,1
    pitch #d3,4,1
    pitch #d3,5,1
    pitch #d3,5,1
    pitch #d3,5,1
    pitch #d3,17,1
    pitch #c3,6,0
    pitch #a2,6,0
    pitch #c3,4,1
    pitch #c3,6,0
    pitch b2,6,0
    pitch #a2,17,8
    pitch #a2,8,0
    pitch #d3,5,1
    pitch #d3,5,0
    pitch #c3,7,1
    pitch #a2,17,0
    pitch #g2,7,0
    pitch #f2,8,0
    pitch #g2,2,0
    pitch #f2,7,0
    pitch f2,5,0
    pitch #d2,17,0
    pitch #a1,5,1
    pitch #a1,5,1
    pitch #a1,5,0
    pitch #f2,5,1
    pitch #f2,6,0
    pitch f2,6,0
    pitch #d2,17,0
    pitch #a2,5,0
    pitch #g2,9,0
    pitch #f2,4,0
    pitch f2,5,0
    pitch #c2,6,0
    pitch #d2,17,5
    dw 0
car:
dw 00000h,00000h,00020h,00020h,00020h,00020h,00020h,00020h,00020h,00020h,00000h,00020h,00020h,00020h,00020h,00020h,00020h,00020h,00020h,00020h,00020h,00020h,00020h,00020h,00020h,00020h,00020h,00020h,00020h,00020h,00020h,00000h,00000h
dw 00000h,00020h,01020h,00020h,00020h,00020h,00fdbh,00fdbh,00020h,00020h,00020h,00fdbh,00fdbh,00fdbh,00fdbh,00fdbh,00fdbh,00fdbh,00fdbh,00fdbh,00fdbh,00fdbh,00fdbh,00fdbh,00fdbh,00fdbh,00fdbh,00fdbh,00fdbh,00020h,00fdbh,00020h,00000h
dw 00000h,00020h,01020h,00020h,01020h,00020h,01020h,01020h,00020h,00020h,00fdbh,00fdbh,00fdbh,00fdbh,00fdbh,00fdbh,00fdbh,00fdbh,00fdbh,00fdbh,00fdbh,00fdbh,00fdbh,00fdbh,00fdbh,00fdbh,00fdbh,00fdbh,00020h,00fdbh,00fdbh,00fdbh,00020h
dw 00020h,01020h,01020h,00020h,01020h,00020h,01020h,01020h,00020h,00020h,02820h,02820h,02820h,02820h,02820h,02820h,02820h,02820h,02820h,02820h,02820h,02820h,02820h,02820h,02820h,02820h,02820h,02820h,00020h,00fdbh,00fdbh,00fdbh,00020h
dw 00020h,00020h,00020h,00020h,00fdbh,00020h,00fdbh,00fdbh,00020h,00020h,02820h,02820h,02820h,02820h,02820h,02820h,02820h,02820h,02820h,02820h,02820h,02820h,02820h,02820h,02820h,02820h,02820h,02820h,00020h,00fdbh,00fdbh,00fdbh,00020h
dw 00020h,00fdbh,00fdbh,00020h,00fdbh,00020h,00fdbh,00fdbh,00020h,00020h,02820h,02820h,02820h,02820h,02820h,02820h,02820h,02820h,02820h,02820h,02820h,02820h,02820h,02820h,02820h,02820h,02820h,02820h,00020h,00fdbh,00fdbh,00fdbh,00020h
dw 00020h,00fdbh,00fdbh,00020h,00fdbh,00020h,00fdbh,00fdbh,00020h,00020h,00fdbh,00fdbh,00fdbh,00fdbh,00fdbh,00fdbh,00fdbh,00fdbh,00fdbh,00fdbh,00fdbh,00fdbh,00fdbh,00fdbh,00fdbh,00fdbh,00fdbh,00fdbh,00020h,00fdbh,00fdbh,00fdbh,00020h
dw 00020h,00fdbh,00020h,00020h,00020h,00020h,00fdbh,00fdbh,00020h,00020h,00020h,00fdbh,00fdbh,00fdbh,00fdbh,00fdbh,00fdbh,00fdbh,00fdbh,00fdbh,00fdbh,00fdbh,00fdbh,00fdbh,00020h,00020h,00020h,00fdbh,00fdbh,00020h,00fdbh,00020h,00000h
dw 00020h,00020h,00000h,00000h,008b0h,00020h,00020h,00020h,00020h,00020h,00020h,00020h,00020h,00020h,00020h,00020h,00020h,00020h,00020h,00020h,00020h,00020h,00020h,00020h,00000h,00000h,008b0h,00020h,00020h,00020h,00020h,00000h,00000h
dw 00000h,00000h,00020h,00020h,00020h,00fdbh,008b0h,00000h,00000h,00000h,00000h,00000h,00020h,00000h,00020h,00000h,00000h,00000h,00020h,00000h,00020h,00000h,00000h,00000h,00020h,00020h,00020h,00fdbh,008b0h,00000h,00000h,00000h,00000h
dw 00000h,00000h,00020h,00fdbh,00020h,008b0h,008b0h,00000h,00000h,00000h,00000h,00fdbh,00fdbh,04820h,04820h,00fdbh,00fdbh,04820h,04820h,00fdbh,00fdbh,04820h,04820h,00000h,00020h,00fdbh,00020h,008b0h,008b0h,00000h,00000h,00000h,00000h
dw 00000h,00000h,00020h,00020h,00020h,00000h,00000h,00000h,00000h,00000h,00000h,00000h,00000h,00000h,00000h,00000h,00000h,00000h,00000h,00000h,00000h,00000h,00000h,00000h,00020h,00020h,00020h,00000h,00000h,00000h,00000h,00000h,00000h

db 2048-($-$$) dup (0)
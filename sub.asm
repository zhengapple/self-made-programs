
set_pitch:
	out 42h,al
	mov al,ah
	out 42h,al
ret
draw_road:
    pusha
        mov ax,2020h
        mov cx,370h
        mov di,0
        rep stosw
        mov ax,08dbh
        mov cx,410h
        rep stosw
        mov ax,2020h
        mov cx,050h
        rep stosw
        mov di,0AA4h
        mov ax,0Fdbh
        mov cx,8
        drline:
            stosw
            stosw
            stosw
            stosw
            stosw
            stosw
            add di,8
        loop drline
        
    popa
ret

draw_car:
    mov bp,[car_pos]
    pusha
        xor ax,ax
        xor bx,bx
        mov al,[car_pos]
        mov di,640d
        mov si,car
        mov dx,33d
        cmp al,0        ;车已离开
        jne car_not_leave
            mov al,72d     ;起始位置=屏幕长度+车长
            mov [car_pos],al
            popa
            ret             ;跳过此帧
        car_not_leave:           
        cmp al,33d          ;车左隐
        jnb car_not_hide_left
            mov dx,ax               ;需要画的长度=车相对于屏幕距离
            ;计算每次换行需要跳过的显存数(不需要被显示的像素)
            mov bx,33d              ;不需要显示的像素数=车长-车位置
            sub bx,ax
            shl bx,1
            add si,bx               ;左隐显示前就要跳过
        jmp car_not_hide_right
        car_not_hide_left:
        cmp al,40d          ;车右隐
        jna car_not_hide_right
            mov dx,73d              ;需要画的长度=车的长度-车的右上角位置+屏幕长度
            sub dx,ax
            ;计算每次换行需要跳过的显存数(不需要被显示的像素)
            mov bx,ax               ;不需要显示的像素数=车位置-屏幕宽度
            sub bx,40    
            shl bx,1
        car_not_hide_right:
        ;计算车所在的显存位置
        sub al,33           ; 转为左边缘（左隐时会下溢）
        jnc not_zero         ; <0 则用0
            mov ax,0
        not_zero:
        shl ax,2                    ;ax*4(一个像素需要2个字符位置,4Byte)
        add di,ax           
        mov cx,12d                  ;车的高度
        dc_loop:
            push cx
            mov cx,dx               ;需要画的长度
            dc_loop_n:
                mov ax,[si]
                cmp ax,0
                je dc_skip
                stosw
                stosw
                add si,2 
                jmp dc_not_skip
                dc_skip:
                    add di,4
                    add si,2
            dc_not_skip:
            loop dc_loop_n
            add si,bx           ;需要被跳过的像素数
            add di,160          ;换行需要加的像素=160-输出的像素*4
            sub di,dx
            sub di,dx
            sub di,dx
            sub di,dx
            pop cx
        loop dc_loop
        dec byte [car_pos]
    popa
ret         
sound: ;ax=音调 bx=间隔时长（相隔拍数） cx=持续时长
    out 42h,al
    mov al,ah
    out 42h,al
    call play
    call delay    
    call stop_play
    mov cx,bx
    call delay
ret
play:                    ;启动蜂鸣器
    push ax             ;保存现场
    in al,61h           ;从61号端口拿来数据
    or al,0011b         ;PB0和PB1置1，启动蜂鸣器和定时器
    out 61h,al
    pop ax              ;还原现场
ret                     ;返回
stop_play:                    ;关闭蜂鸣器
    push ax             ;保存现场
    in al,61h           ;从61号端口拿来数据
    and al,0fch         ;调整蜂鸣器计时器控制位
    out 61h,al          ;丢回去
    pop ax              ;还原现场
ret
delay:                  ;延迟,cx传入(单位50ms)
    pusha
    delay_loop:
        cmp cx,0
        je delay_fin
            call draw_road
            call draw_car
            mov al,00110000b    ;方式0
            out 43h,al
            nop
            mov ax,59255d        ;50ms
            out 40h,al
            mov al,ah
            nop
            out 40h,al
            delay_ms:
                mov al,0e2h
                out 43h,al
                nop
                in al,40h
                test al,10000000b       ;测试OUT引脚
            jz delay_ms
                dec cx
    jmp delay_loop
    delay_fin:
    popa
ret

printstr:                               ;输出字符串的子程序,调用时si指向要输出的字符串
    pusha                               ;保存现场
        mov ah,0eh                      ;BIOS中断功能号0E:输出al储存的字符于光标处,并移动光标到下一个字符的位置
        pstr_loop:                      ;用于循环的标签
            mov al,[si]                 ;将si目前指向的字符移入al
            int 10h                     ;调用中断输出
            inc si                      ;si指向下一个字节
            cmp byte [si],0             ;判断下一个字节是0(结束标志)还是需要输出的字符
        jne pstr_loop                   ;如果不是0(也就是是需要输出的字符)就跳转到前面定义的用于循环的标签处(往上数五行)
    popa                                ;否则(是0的话)证明字符串已经输出完毕才会执行这句,恢复现场(即还原代码里对各寄存器的修改)
ret                                     ;返回到调用代码的位置
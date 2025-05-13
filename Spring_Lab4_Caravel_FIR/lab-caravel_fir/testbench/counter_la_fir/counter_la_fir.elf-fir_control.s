	.file	"fir_control.c"
	.option nopic
	.attribute arch, "rv32i2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
.Ltext0:
	.cfi_sections	.debug_frame
	.file 0 "/home/ubuntu/Spring_Lab4_Caravel_FIR-master/lab-caravel_fir/testbench/counter_la_fir" "fir_control.c"
	.align	2
	.type	flush_cpu_icache, @function
flush_cpu_icache:
.LFB21:
	.file 1 "../../firmware/system.h"
	.loc 1 15 1
	.cfi_startproc
	addi	sp,sp,-16
	.cfi_def_cfa_offset 16
	sw	s0,12(sp)
	.cfi_offset 8, -4
	addi	s0,sp,16
	.cfi_def_cfa 8, 0
	.loc 1 26 1
	nop
	lw	s0,12(sp)
	.cfi_restore 8
	.cfi_def_cfa 2, 16
	addi	sp,sp,16
	.cfi_def_cfa_offset 0
	jr	ra
	.cfi_endproc
.LFE21:
	.size	flush_cpu_icache, .-flush_cpu_icache
	.align	2
	.type	flush_cpu_dcache, @function
flush_cpu_dcache:
.LFB22:
	.loc 1 29 1
	.cfi_startproc
	addi	sp,sp,-16
	.cfi_def_cfa_offset 16
	sw	s0,12(sp)
	.cfi_offset 8, -4
	addi	s0,sp,16
	.cfi_def_cfa 8, 0
	.loc 1 33 1
	nop
	lw	s0,12(sp)
	.cfi_restore 8
	.cfi_def_cfa 2, 16
	addi	sp,sp,16
	.cfi_def_cfa_offset 0
	jr	ra
	.cfi_endproc
.LFE22:
	.size	flush_cpu_dcache, .-flush_cpu_dcache
	.section	.rodata
	.align	2
	.type	init_taps, @object
	.size	init_taps, 44
init_taps:
	.word	0
	.word	-10
	.word	-9
	.word	23
	.word	56
	.word	63
	.word	56
	.word	23
	.word	-9
	.word	-10
	.word	0
	.globl	outputsignal
	.bss
	.align	2
	.type	outputsignal, @object
	.size	outputsignal, 256
outputsignal:
	.zero	256
	.section	.mprjram,"ax",@progbits
	.align	2
	.globl	initfir
	.type	initfir, @function
initfir:
.LFB316:
	.file 2 "fir_control.c"
	.loc 2 34 61
	.cfi_startproc
	addi	sp,sp,-32
	.cfi_def_cfa_offset 32
	sw	s0,28(sp)
	.cfi_offset 8, -4
	addi	s0,sp,32
	.cfi_def_cfa 8, 0
	.loc 2 36 3
	li	a5,805306368
	addi	a5,a5,16
	.loc 2 36 37
	li	a4,64
	sw	a4,0(a5)
	.loc 2 37 7
	li	a5,805306368
	addi	a5,a5,20
	.loc 2 37 41
	li	a4,11
	sw	a4,0(a5)
.LBB2:
	.loc 2 38 11
	sw	zero,-20(s0)
	.loc 2 38 2
	j	.L4
.L5:
	.loc 2 39 61 discriminator 3
	lui	a5,%hi(init_taps)
	addi	a4,a5,%lo(init_taps)
	lw	a5,-20(s0)
	slli	a5,a5,2
	add	a5,a4,a5
	lw	a3,0(a5)
	.loc 2 39 46 discriminator 3
	lw	a5,-20(s0)
	slli	a4,a5,2
	li	a5,805306368
	addi	a5,a5,128
	add	a5,a4,a5
	.loc 2 39 61 discriminator 3
	mv	a4,a3
	.loc 2 39 50 discriminator 3
	sw	a4,0(a5)
	.loc 2 38 27 discriminator 3
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
.L4:
	.loc 2 38 20 discriminator 1
	lw	a4,-20(s0)
	li	a5,10
	ble	a4,a5,.L5
.LBE2:
	.loc 2 42 2
	nop
	.loc 2 43 1
	lw	s0,28(sp)
	.cfi_restore 8
	.cfi_def_cfa 2, 32
	addi	sp,sp,32
	.cfi_def_cfa_offset 0
	jr	ra
	.cfi_endproc
.LFE316:
	.size	initfir, .-initfir
	.align	2
	.globl	fir
	.type	fir, @function
fir:
.LFB317:
	.loc 2 45 56
	.cfi_startproc
	addi	sp,sp,-16
	.cfi_def_cfa_offset 16
	sw	ra,12(sp)
	sw	s0,8(sp)
	.cfi_offset 1, -4
	.cfi_offset 8, -8
	addi	s0,sp,16
	.cfi_def_cfa 8, 0
	.loc 2 46 2
	call	initfir
	.loc 2 47 3
	li	a5,805306368
	.loc 2 47 37
	li	a4,1
	sw	a4,0(a5)
	.loc 2 49 3
	li	a5,637534208
	addi	a5,a5,12
	.loc 2 49 36
	li	a4,10813440
	sw	a4,0(a5)
	.loc 2 55 3
	li	a5,805306368
	addi	a5,a5,64
	.loc 2 55 37
	sw	zero,0(a5)
	.loc 2 57 21
	li	a5,805306368
	addi	a5,a5,68
	lw	a5,0(a5)
	mv	a4,a5
	.loc 2 57 18
	lui	a5,%hi(outputsignal)
	addi	a5,a5,%lo(outputsignal)
	sw	a4,0(a5)
	.loc 2 61 3
	li	a5,805306368
	addi	a5,a5,64
	.loc 2 61 37
	li	a4,1
	sw	a4,0(a5)
	.loc 2 63 21
	li	a5,805306368
	addi	a5,a5,68
	lw	a5,0(a5)
	mv	a4,a5
	.loc 2 63 18
	lui	a5,%hi(outputsignal)
	addi	a5,a5,%lo(outputsignal)
	sw	a4,4(a5)
	.loc 2 67 3
	li	a5,805306368
	addi	a5,a5,64
	.loc 2 67 37
	li	a4,2
	sw	a4,0(a5)
	.loc 2 69 21
	li	a5,805306368
	addi	a5,a5,68
	lw	a5,0(a5)
	mv	a4,a5
	.loc 2 69 18
	lui	a5,%hi(outputsignal)
	addi	a5,a5,%lo(outputsignal)
	sw	a4,8(a5)
	.loc 2 73 3
	li	a5,805306368
	addi	a5,a5,64
	.loc 2 73 37
	li	a4,3
	sw	a4,0(a5)
	.loc 2 75 21
	li	a5,805306368
	addi	a5,a5,68
	lw	a5,0(a5)
	mv	a4,a5
	.loc 2 75 18
	lui	a5,%hi(outputsignal)
	addi	a5,a5,%lo(outputsignal)
	sw	a4,12(a5)
	.loc 2 79 3
	li	a5,805306368
	addi	a5,a5,64
	.loc 2 79 37
	li	a4,4
	sw	a4,0(a5)
	.loc 2 81 21
	li	a5,805306368
	addi	a5,a5,68
	lw	a5,0(a5)
	mv	a4,a5
	.loc 2 81 18
	lui	a5,%hi(outputsignal)
	addi	a5,a5,%lo(outputsignal)
	sw	a4,16(a5)
	.loc 2 85 3
	li	a5,805306368
	addi	a5,a5,64
	.loc 2 85 37
	li	a4,5
	sw	a4,0(a5)
	.loc 2 87 21
	li	a5,805306368
	addi	a5,a5,68
	lw	a5,0(a5)
	mv	a4,a5
	.loc 2 87 18
	lui	a5,%hi(outputsignal)
	addi	a5,a5,%lo(outputsignal)
	sw	a4,20(a5)
	.loc 2 91 3
	li	a5,805306368
	addi	a5,a5,64
	.loc 2 91 37
	li	a4,6
	sw	a4,0(a5)
	.loc 2 93 21
	li	a5,805306368
	addi	a5,a5,68
	lw	a5,0(a5)
	mv	a4,a5
	.loc 2 93 18
	lui	a5,%hi(outputsignal)
	addi	a5,a5,%lo(outputsignal)
	sw	a4,24(a5)
	.loc 2 97 3
	li	a5,805306368
	addi	a5,a5,64
	.loc 2 97 37
	li	a4,7
	sw	a4,0(a5)
	.loc 2 99 21
	li	a5,805306368
	addi	a5,a5,68
	lw	a5,0(a5)
	mv	a4,a5
	.loc 2 99 18
	lui	a5,%hi(outputsignal)
	addi	a5,a5,%lo(outputsignal)
	sw	a4,28(a5)
	.loc 2 103 3
	li	a5,805306368
	addi	a5,a5,64
	.loc 2 103 37
	li	a4,8
	sw	a4,0(a5)
	.loc 2 105 21
	li	a5,805306368
	addi	a5,a5,68
	lw	a5,0(a5)
	mv	a4,a5
	.loc 2 105 18
	lui	a5,%hi(outputsignal)
	addi	a5,a5,%lo(outputsignal)
	sw	a4,32(a5)
	.loc 2 109 3
	li	a5,805306368
	addi	a5,a5,64
	.loc 2 109 37
	li	a4,9
	sw	a4,0(a5)
	.loc 2 111 21
	li	a5,805306368
	addi	a5,a5,68
	lw	a5,0(a5)
	mv	a4,a5
	.loc 2 111 18
	lui	a5,%hi(outputsignal)
	addi	a5,a5,%lo(outputsignal)
	sw	a4,36(a5)
	.loc 2 115 3
	li	a5,805306368
	addi	a5,a5,64
	.loc 2 115 37
	li	a4,10
	sw	a4,0(a5)
	.loc 2 117 22
	li	a5,805306368
	addi	a5,a5,68
	lw	a5,0(a5)
	mv	a4,a5
	.loc 2 117 19
	lui	a5,%hi(outputsignal)
	addi	a5,a5,%lo(outputsignal)
	sw	a4,40(a5)
	.loc 2 121 3
	li	a5,805306368
	addi	a5,a5,64
	.loc 2 121 37
	li	a4,11
	sw	a4,0(a5)
	.loc 2 123 22
	li	a5,805306368
	addi	a5,a5,68
	lw	a5,0(a5)
	mv	a4,a5
	.loc 2 123 19
	lui	a5,%hi(outputsignal)
	addi	a5,a5,%lo(outputsignal)
	sw	a4,44(a5)
	.loc 2 127 3
	li	a5,805306368
	addi	a5,a5,64
	.loc 2 127 37
	li	a4,12
	sw	a4,0(a5)
	.loc 2 129 22
	li	a5,805306368
	addi	a5,a5,68
	lw	a5,0(a5)
	mv	a4,a5
	.loc 2 129 19
	lui	a5,%hi(outputsignal)
	addi	a5,a5,%lo(outputsignal)
	sw	a4,48(a5)
	.loc 2 133 3
	li	a5,805306368
	addi	a5,a5,64
	.loc 2 133 37
	li	a4,13
	sw	a4,0(a5)
	.loc 2 135 22
	li	a5,805306368
	addi	a5,a5,68
	lw	a5,0(a5)
	mv	a4,a5
	.loc 2 135 19
	lui	a5,%hi(outputsignal)
	addi	a5,a5,%lo(outputsignal)
	sw	a4,52(a5)
	.loc 2 139 3
	li	a5,805306368
	addi	a5,a5,64
	.loc 2 139 37
	li	a4,14
	sw	a4,0(a5)
	.loc 2 141 22
	li	a5,805306368
	addi	a5,a5,68
	lw	a5,0(a5)
	mv	a4,a5
	.loc 2 141 19
	lui	a5,%hi(outputsignal)
	addi	a5,a5,%lo(outputsignal)
	sw	a4,56(a5)
	.loc 2 145 3
	li	a5,805306368
	addi	a5,a5,64
	.loc 2 145 37
	li	a4,15
	sw	a4,0(a5)
	.loc 2 147 22
	li	a5,805306368
	addi	a5,a5,68
	lw	a5,0(a5)
	mv	a4,a5
	.loc 2 147 19
	lui	a5,%hi(outputsignal)
	addi	a5,a5,%lo(outputsignal)
	sw	a4,60(a5)
	.loc 2 151 3
	li	a5,805306368
	addi	a5,a5,64
	.loc 2 151 37
	li	a4,16
	sw	a4,0(a5)
	.loc 2 153 22
	li	a5,805306368
	addi	a5,a5,68
	lw	a5,0(a5)
	mv	a4,a5
	.loc 2 153 19
	lui	a5,%hi(outputsignal)
	addi	a5,a5,%lo(outputsignal)
	sw	a4,64(a5)
	.loc 2 157 3
	li	a5,805306368
	addi	a5,a5,64
	.loc 2 157 37
	li	a4,17
	sw	a4,0(a5)
	.loc 2 159 22
	li	a5,805306368
	addi	a5,a5,68
	lw	a5,0(a5)
	mv	a4,a5
	.loc 2 159 19
	lui	a5,%hi(outputsignal)
	addi	a5,a5,%lo(outputsignal)
	sw	a4,68(a5)
	.loc 2 163 3
	li	a5,805306368
	addi	a5,a5,64
	.loc 2 163 37
	li	a4,18
	sw	a4,0(a5)
	.loc 2 165 22
	li	a5,805306368
	addi	a5,a5,68
	lw	a5,0(a5)
	mv	a4,a5
	.loc 2 165 19
	lui	a5,%hi(outputsignal)
	addi	a5,a5,%lo(outputsignal)
	sw	a4,72(a5)
	.loc 2 169 3
	li	a5,805306368
	addi	a5,a5,64
	.loc 2 169 37
	li	a4,19
	sw	a4,0(a5)
	.loc 2 171 22
	li	a5,805306368
	addi	a5,a5,68
	lw	a5,0(a5)
	mv	a4,a5
	.loc 2 171 19
	lui	a5,%hi(outputsignal)
	addi	a5,a5,%lo(outputsignal)
	sw	a4,76(a5)
	.loc 2 175 3
	li	a5,805306368
	addi	a5,a5,64
	.loc 2 175 37
	li	a4,20
	sw	a4,0(a5)
	.loc 2 177 22
	li	a5,805306368
	addi	a5,a5,68
	lw	a5,0(a5)
	mv	a4,a5
	.loc 2 177 19
	lui	a5,%hi(outputsignal)
	addi	a5,a5,%lo(outputsignal)
	sw	a4,80(a5)
	.loc 2 181 3
	li	a5,805306368
	addi	a5,a5,64
	.loc 2 181 37
	li	a4,21
	sw	a4,0(a5)
	.loc 2 183 22
	li	a5,805306368
	addi	a5,a5,68
	lw	a5,0(a5)
	mv	a4,a5
	.loc 2 183 19
	lui	a5,%hi(outputsignal)
	addi	a5,a5,%lo(outputsignal)
	sw	a4,84(a5)
	.loc 2 187 3
	li	a5,805306368
	addi	a5,a5,64
	.loc 2 187 37
	li	a4,22
	sw	a4,0(a5)
	.loc 2 189 22
	li	a5,805306368
	addi	a5,a5,68
	lw	a5,0(a5)
	mv	a4,a5
	.loc 2 189 19
	lui	a5,%hi(outputsignal)
	addi	a5,a5,%lo(outputsignal)
	sw	a4,88(a5)
	.loc 2 193 3
	li	a5,805306368
	addi	a5,a5,64
	.loc 2 193 37
	li	a4,23
	sw	a4,0(a5)
	.loc 2 195 22
	li	a5,805306368
	addi	a5,a5,68
	lw	a5,0(a5)
	mv	a4,a5
	.loc 2 195 19
	lui	a5,%hi(outputsignal)
	addi	a5,a5,%lo(outputsignal)
	sw	a4,92(a5)
	.loc 2 199 3
	li	a5,805306368
	addi	a5,a5,64
	.loc 2 199 37
	li	a4,24
	sw	a4,0(a5)
	.loc 2 201 22
	li	a5,805306368
	addi	a5,a5,68
	lw	a5,0(a5)
	mv	a4,a5
	.loc 2 201 19
	lui	a5,%hi(outputsignal)
	addi	a5,a5,%lo(outputsignal)
	sw	a4,96(a5)
	.loc 2 205 3
	li	a5,805306368
	addi	a5,a5,64
	.loc 2 205 37
	li	a4,25
	sw	a4,0(a5)
	.loc 2 207 22
	li	a5,805306368
	addi	a5,a5,68
	lw	a5,0(a5)
	mv	a4,a5
	.loc 2 207 19
	lui	a5,%hi(outputsignal)
	addi	a5,a5,%lo(outputsignal)
	sw	a4,100(a5)
	.loc 2 211 3
	li	a5,805306368
	addi	a5,a5,64
	.loc 2 211 37
	li	a4,26
	sw	a4,0(a5)
	.loc 2 213 22
	li	a5,805306368
	addi	a5,a5,68
	lw	a5,0(a5)
	mv	a4,a5
	.loc 2 213 19
	lui	a5,%hi(outputsignal)
	addi	a5,a5,%lo(outputsignal)
	sw	a4,104(a5)
	.loc 2 217 3
	li	a5,805306368
	addi	a5,a5,64
	.loc 2 217 37
	li	a4,27
	sw	a4,0(a5)
	.loc 2 219 22
	li	a5,805306368
	addi	a5,a5,68
	lw	a5,0(a5)
	mv	a4,a5
	.loc 2 219 19
	lui	a5,%hi(outputsignal)
	addi	a5,a5,%lo(outputsignal)
	sw	a4,108(a5)
	.loc 2 223 3
	li	a5,805306368
	addi	a5,a5,64
	.loc 2 223 37
	li	a4,28
	sw	a4,0(a5)
	.loc 2 225 22
	li	a5,805306368
	addi	a5,a5,68
	lw	a5,0(a5)
	mv	a4,a5
	.loc 2 225 19
	lui	a5,%hi(outputsignal)
	addi	a5,a5,%lo(outputsignal)
	sw	a4,112(a5)
	.loc 2 229 3
	li	a5,805306368
	addi	a5,a5,64
	.loc 2 229 37
	li	a4,29
	sw	a4,0(a5)
	.loc 2 231 22
	li	a5,805306368
	addi	a5,a5,68
	lw	a5,0(a5)
	mv	a4,a5
	.loc 2 231 19
	lui	a5,%hi(outputsignal)
	addi	a5,a5,%lo(outputsignal)
	sw	a4,116(a5)
	.loc 2 235 3
	li	a5,805306368
	addi	a5,a5,64
	.loc 2 235 37
	li	a4,30
	sw	a4,0(a5)
	.loc 2 237 22
	li	a5,805306368
	addi	a5,a5,68
	lw	a5,0(a5)
	mv	a4,a5
	.loc 2 237 19
	lui	a5,%hi(outputsignal)
	addi	a5,a5,%lo(outputsignal)
	sw	a4,120(a5)
	.loc 2 241 3
	li	a5,805306368
	addi	a5,a5,64
	.loc 2 241 37
	li	a4,31
	sw	a4,0(a5)
	.loc 2 243 22
	li	a5,805306368
	addi	a5,a5,68
	lw	a5,0(a5)
	mv	a4,a5
	.loc 2 243 19
	lui	a5,%hi(outputsignal)
	addi	a5,a5,%lo(outputsignal)
	sw	a4,124(a5)
	.loc 2 247 3
	li	a5,805306368
	addi	a5,a5,64
	.loc 2 247 37
	li	a4,32
	sw	a4,0(a5)
	.loc 2 249 22
	li	a5,805306368
	addi	a5,a5,68
	lw	a5,0(a5)
	mv	a4,a5
	.loc 2 249 19
	lui	a5,%hi(outputsignal)
	addi	a5,a5,%lo(outputsignal)
	sw	a4,128(a5)
	.loc 2 253 3
	li	a5,805306368
	addi	a5,a5,64
	.loc 2 253 37
	li	a4,33
	sw	a4,0(a5)
	.loc 2 255 22
	li	a5,805306368
	addi	a5,a5,68
	lw	a5,0(a5)
	mv	a4,a5
	.loc 2 255 19
	lui	a5,%hi(outputsignal)
	addi	a5,a5,%lo(outputsignal)
	sw	a4,132(a5)
	.loc 2 259 3
	li	a5,805306368
	addi	a5,a5,64
	.loc 2 259 37
	li	a4,34
	sw	a4,0(a5)
	.loc 2 261 22
	li	a5,805306368
	addi	a5,a5,68
	lw	a5,0(a5)
	mv	a4,a5
	.loc 2 261 19
	lui	a5,%hi(outputsignal)
	addi	a5,a5,%lo(outputsignal)
	sw	a4,136(a5)
	.loc 2 265 3
	li	a5,805306368
	addi	a5,a5,64
	.loc 2 265 37
	li	a4,35
	sw	a4,0(a5)
	.loc 2 267 22
	li	a5,805306368
	addi	a5,a5,68
	lw	a5,0(a5)
	mv	a4,a5
	.loc 2 267 19
	lui	a5,%hi(outputsignal)
	addi	a5,a5,%lo(outputsignal)
	sw	a4,140(a5)
	.loc 2 271 3
	li	a5,805306368
	addi	a5,a5,64
	.loc 2 271 37
	li	a4,36
	sw	a4,0(a5)
	.loc 2 273 22
	li	a5,805306368
	addi	a5,a5,68
	lw	a5,0(a5)
	mv	a4,a5
	.loc 2 273 19
	lui	a5,%hi(outputsignal)
	addi	a5,a5,%lo(outputsignal)
	sw	a4,144(a5)
	.loc 2 277 3
	li	a5,805306368
	addi	a5,a5,64
	.loc 2 277 37
	li	a4,37
	sw	a4,0(a5)
	.loc 2 279 22
	li	a5,805306368
	addi	a5,a5,68
	lw	a5,0(a5)
	mv	a4,a5
	.loc 2 279 19
	lui	a5,%hi(outputsignal)
	addi	a5,a5,%lo(outputsignal)
	sw	a4,148(a5)
	.loc 2 283 3
	li	a5,805306368
	addi	a5,a5,64
	.loc 2 283 37
	li	a4,38
	sw	a4,0(a5)
	.loc 2 285 22
	li	a5,805306368
	addi	a5,a5,68
	lw	a5,0(a5)
	mv	a4,a5
	.loc 2 285 19
	lui	a5,%hi(outputsignal)
	addi	a5,a5,%lo(outputsignal)
	sw	a4,152(a5)
	.loc 2 289 3
	li	a5,805306368
	addi	a5,a5,64
	.loc 2 289 37
	li	a4,39
	sw	a4,0(a5)
	.loc 2 291 22
	li	a5,805306368
	addi	a5,a5,68
	lw	a5,0(a5)
	mv	a4,a5
	.loc 2 291 19
	lui	a5,%hi(outputsignal)
	addi	a5,a5,%lo(outputsignal)
	sw	a4,156(a5)
	.loc 2 295 3
	li	a5,805306368
	addi	a5,a5,64
	.loc 2 295 37
	li	a4,40
	sw	a4,0(a5)
	.loc 2 297 22
	li	a5,805306368
	addi	a5,a5,68
	lw	a5,0(a5)
	mv	a4,a5
	.loc 2 297 19
	lui	a5,%hi(outputsignal)
	addi	a5,a5,%lo(outputsignal)
	sw	a4,160(a5)
	.loc 2 301 3
	li	a5,805306368
	addi	a5,a5,64
	.loc 2 301 37
	li	a4,41
	sw	a4,0(a5)
	.loc 2 303 22
	li	a5,805306368
	addi	a5,a5,68
	lw	a5,0(a5)
	mv	a4,a5
	.loc 2 303 19
	lui	a5,%hi(outputsignal)
	addi	a5,a5,%lo(outputsignal)
	sw	a4,164(a5)
	.loc 2 307 3
	li	a5,805306368
	addi	a5,a5,64
	.loc 2 307 37
	li	a4,42
	sw	a4,0(a5)
	.loc 2 309 22
	li	a5,805306368
	addi	a5,a5,68
	lw	a5,0(a5)
	mv	a4,a5
	.loc 2 309 19
	lui	a5,%hi(outputsignal)
	addi	a5,a5,%lo(outputsignal)
	sw	a4,168(a5)
	.loc 2 313 3
	li	a5,805306368
	addi	a5,a5,64
	.loc 2 313 37
	li	a4,43
	sw	a4,0(a5)
	.loc 2 315 22
	li	a5,805306368
	addi	a5,a5,68
	lw	a5,0(a5)
	mv	a4,a5
	.loc 2 315 19
	lui	a5,%hi(outputsignal)
	addi	a5,a5,%lo(outputsignal)
	sw	a4,172(a5)
	.loc 2 319 3
	li	a5,805306368
	addi	a5,a5,64
	.loc 2 319 37
	li	a4,44
	sw	a4,0(a5)
	.loc 2 321 22
	li	a5,805306368
	addi	a5,a5,68
	lw	a5,0(a5)
	mv	a4,a5
	.loc 2 321 19
	lui	a5,%hi(outputsignal)
	addi	a5,a5,%lo(outputsignal)
	sw	a4,176(a5)
	.loc 2 325 3
	li	a5,805306368
	addi	a5,a5,64
	.loc 2 325 37
	li	a4,45
	sw	a4,0(a5)
	.loc 2 327 22
	li	a5,805306368
	addi	a5,a5,68
	lw	a5,0(a5)
	mv	a4,a5
	.loc 2 327 19
	lui	a5,%hi(outputsignal)
	addi	a5,a5,%lo(outputsignal)
	sw	a4,180(a5)
	.loc 2 331 3
	li	a5,805306368
	addi	a5,a5,64
	.loc 2 331 37
	li	a4,46
	sw	a4,0(a5)
	.loc 2 333 22
	li	a5,805306368
	addi	a5,a5,68
	lw	a5,0(a5)
	mv	a4,a5
	.loc 2 333 19
	lui	a5,%hi(outputsignal)
	addi	a5,a5,%lo(outputsignal)
	sw	a4,184(a5)
	.loc 2 337 3
	li	a5,805306368
	addi	a5,a5,64
	.loc 2 337 37
	li	a4,47
	sw	a4,0(a5)
	.loc 2 339 22
	li	a5,805306368
	addi	a5,a5,68
	lw	a5,0(a5)
	mv	a4,a5
	.loc 2 339 19
	lui	a5,%hi(outputsignal)
	addi	a5,a5,%lo(outputsignal)
	sw	a4,188(a5)
	.loc 2 343 3
	li	a5,805306368
	addi	a5,a5,64
	.loc 2 343 37
	li	a4,48
	sw	a4,0(a5)
	.loc 2 345 22
	li	a5,805306368
	addi	a5,a5,68
	lw	a5,0(a5)
	mv	a4,a5
	.loc 2 345 19
	lui	a5,%hi(outputsignal)
	addi	a5,a5,%lo(outputsignal)
	sw	a4,192(a5)
	.loc 2 349 3
	li	a5,805306368
	addi	a5,a5,64
	.loc 2 349 37
	li	a4,49
	sw	a4,0(a5)
	.loc 2 351 22
	li	a5,805306368
	addi	a5,a5,68
	lw	a5,0(a5)
	mv	a4,a5
	.loc 2 351 19
	lui	a5,%hi(outputsignal)
	addi	a5,a5,%lo(outputsignal)
	sw	a4,196(a5)
	.loc 2 355 3
	li	a5,805306368
	addi	a5,a5,64
	.loc 2 355 37
	li	a4,50
	sw	a4,0(a5)
	.loc 2 357 22
	li	a5,805306368
	addi	a5,a5,68
	lw	a5,0(a5)
	mv	a4,a5
	.loc 2 357 19
	lui	a5,%hi(outputsignal)
	addi	a5,a5,%lo(outputsignal)
	sw	a4,200(a5)
	.loc 2 361 3
	li	a5,805306368
	addi	a5,a5,64
	.loc 2 361 37
	li	a4,51
	sw	a4,0(a5)
	.loc 2 363 22
	li	a5,805306368
	addi	a5,a5,68
	lw	a5,0(a5)
	mv	a4,a5
	.loc 2 363 19
	lui	a5,%hi(outputsignal)
	addi	a5,a5,%lo(outputsignal)
	sw	a4,204(a5)
	.loc 2 367 3
	li	a5,805306368
	addi	a5,a5,64
	.loc 2 367 37
	li	a4,52
	sw	a4,0(a5)
	.loc 2 369 22
	li	a5,805306368
	addi	a5,a5,68
	lw	a5,0(a5)
	mv	a4,a5
	.loc 2 369 19
	lui	a5,%hi(outputsignal)
	addi	a5,a5,%lo(outputsignal)
	sw	a4,208(a5)
	.loc 2 373 3
	li	a5,805306368
	addi	a5,a5,64
	.loc 2 373 37
	li	a4,53
	sw	a4,0(a5)
	.loc 2 375 22
	li	a5,805306368
	addi	a5,a5,68
	lw	a5,0(a5)
	mv	a4,a5
	.loc 2 375 19
	lui	a5,%hi(outputsignal)
	addi	a5,a5,%lo(outputsignal)
	sw	a4,212(a5)
	.loc 2 379 3
	li	a5,805306368
	addi	a5,a5,64
	.loc 2 379 37
	li	a4,54
	sw	a4,0(a5)
	.loc 2 381 22
	li	a5,805306368
	addi	a5,a5,68
	lw	a5,0(a5)
	mv	a4,a5
	.loc 2 381 19
	lui	a5,%hi(outputsignal)
	addi	a5,a5,%lo(outputsignal)
	sw	a4,216(a5)
	.loc 2 385 3
	li	a5,805306368
	addi	a5,a5,64
	.loc 2 385 37
	li	a4,55
	sw	a4,0(a5)
	.loc 2 387 22
	li	a5,805306368
	addi	a5,a5,68
	lw	a5,0(a5)
	mv	a4,a5
	.loc 2 387 19
	lui	a5,%hi(outputsignal)
	addi	a5,a5,%lo(outputsignal)
	sw	a4,220(a5)
	.loc 2 391 3
	li	a5,805306368
	addi	a5,a5,64
	.loc 2 391 37
	li	a4,56
	sw	a4,0(a5)
	.loc 2 393 22
	li	a5,805306368
	addi	a5,a5,68
	lw	a5,0(a5)
	mv	a4,a5
	.loc 2 393 19
	lui	a5,%hi(outputsignal)
	addi	a5,a5,%lo(outputsignal)
	sw	a4,224(a5)
	.loc 2 397 3
	li	a5,805306368
	addi	a5,a5,64
	.loc 2 397 37
	li	a4,57
	sw	a4,0(a5)
	.loc 2 399 22
	li	a5,805306368
	addi	a5,a5,68
	lw	a5,0(a5)
	mv	a4,a5
	.loc 2 399 19
	lui	a5,%hi(outputsignal)
	addi	a5,a5,%lo(outputsignal)
	sw	a4,228(a5)
	.loc 2 403 3
	li	a5,805306368
	addi	a5,a5,64
	.loc 2 403 37
	li	a4,58
	sw	a4,0(a5)
	.loc 2 405 22
	li	a5,805306368
	addi	a5,a5,68
	lw	a5,0(a5)
	mv	a4,a5
	.loc 2 405 19
	lui	a5,%hi(outputsignal)
	addi	a5,a5,%lo(outputsignal)
	sw	a4,232(a5)
	.loc 2 409 3
	li	a5,805306368
	addi	a5,a5,64
	.loc 2 409 37
	li	a4,59
	sw	a4,0(a5)
	.loc 2 411 22
	li	a5,805306368
	addi	a5,a5,68
	lw	a5,0(a5)
	mv	a4,a5
	.loc 2 411 19
	lui	a5,%hi(outputsignal)
	addi	a5,a5,%lo(outputsignal)
	sw	a4,236(a5)
	.loc 2 415 3
	li	a5,805306368
	addi	a5,a5,64
	.loc 2 415 37
	li	a4,60
	sw	a4,0(a5)
	.loc 2 417 22
	li	a5,805306368
	addi	a5,a5,68
	lw	a5,0(a5)
	mv	a4,a5
	.loc 2 417 19
	lui	a5,%hi(outputsignal)
	addi	a5,a5,%lo(outputsignal)
	sw	a4,240(a5)
	.loc 2 421 3
	li	a5,805306368
	addi	a5,a5,64
	.loc 2 421 37
	li	a4,61
	sw	a4,0(a5)
	.loc 2 423 22
	li	a5,805306368
	addi	a5,a5,68
	lw	a5,0(a5)
	mv	a4,a5
	.loc 2 423 19
	lui	a5,%hi(outputsignal)
	addi	a5,a5,%lo(outputsignal)
	sw	a4,244(a5)
	.loc 2 427 3
	li	a5,805306368
	addi	a5,a5,64
	.loc 2 427 37
	li	a4,62
	sw	a4,0(a5)
	.loc 2 429 22
	li	a5,805306368
	addi	a5,a5,68
	lw	a5,0(a5)
	mv	a4,a5
	.loc 2 429 19
	lui	a5,%hi(outputsignal)
	addi	a5,a5,%lo(outputsignal)
	sw	a4,248(a5)
	.loc 2 433 3
	li	a5,805306368
	addi	a5,a5,64
	.loc 2 433 37
	li	a4,63
	sw	a4,0(a5)
	.loc 2 435 22
	li	a5,805306368
	addi	a5,a5,68
	lw	a5,0(a5)
	mv	a4,a5
	.loc 2 435 19
	lui	a5,%hi(outputsignal)
	addi	a5,a5,%lo(outputsignal)
	sw	a4,252(a5)
	.loc 2 439 52
	lui	a5,%hi(outputsignal)
	addi	a5,a5,%lo(outputsignal)
	lw	a5,252(a5)
	.loc 2 439 69
	slli	a4,a5,24
	.loc 2 439 76
	li	a5,5898240
	or	a4,a4,a5
	.loc 2 439 3
	li	a5,637534208
	addi	a5,a5,12
	.loc 2 439 36
	sw	a4,0(a5)
	.loc 2 442 5
	nop
	mv	a0,a5
	lw	ra,12(sp)
	.cfi_restore 1
	lw	s0,8(sp)
	.cfi_restore 8
	.cfi_def_cfa 2, 16
	addi	sp,sp,16
	.cfi_def_cfa_offset 0
	jr	ra
	.cfi_endproc
.LFE317:
	.size	fir, .-fir
	.text
.Letext0:
	.file 3 "/opt/riscv/lib/gcc/riscv32-unknown-elf/12.1.0/include/stdint-gcc.h"
	.section	.debug_info,"",@progbits
.Ldebug_info0:
	.4byte	0x137
	.2byte	0x5
	.byte	0x1
	.byte	0x4
	.4byte	.Ldebug_abbrev0
	.byte	0x7
	.4byte	.LASF16
	.byte	0x1d
	.4byte	.LASF0
	.4byte	.LASF1
	.4byte	.LLRL0
	.4byte	0
	.4byte	.Ldebug_line0
	.byte	0x1
	.byte	0x1
	.byte	0x6
	.4byte	.LASF2
	.byte	0x1
	.byte	0x2
	.byte	0x5
	.4byte	.LASF3
	.byte	0x2
	.4byte	.LASF8
	.byte	0x28
	.byte	0x12
	.4byte	0x44
	.byte	0x3
	.4byte	0x34
	.byte	0x1
	.byte	0x4
	.byte	0x5
	.4byte	.LASF4
	.byte	0x1
	.byte	0x8
	.byte	0x5
	.4byte	.LASF5
	.byte	0x1
	.byte	0x1
	.byte	0x8
	.4byte	.LASF6
	.byte	0x1
	.byte	0x2
	.byte	0x7
	.4byte	.LASF7
	.byte	0x2
	.4byte	.LASF9
	.byte	0x34
	.byte	0x1b
	.4byte	0x6b
	.byte	0x1
	.byte	0x4
	.byte	0x7
	.4byte	.LASF10
	.byte	0x1
	.byte	0x8
	.byte	0x7
	.4byte	.LASF11
	.byte	0x8
	.byte	0x4
	.byte	0x5
	.string	"int"
	.byte	0x1
	.byte	0x4
	.byte	0x7
	.4byte	.LASF12
	.byte	0x4
	.4byte	0x3f
	.4byte	0x97
	.byte	0x5
	.4byte	0x80
	.byte	0xa
	.byte	0
	.byte	0x3
	.4byte	0x87
	.byte	0x9
	.4byte	.LASF13
	.byte	0x2
	.byte	0x1c
	.byte	0x16
	.4byte	0x97
	.byte	0x5
	.byte	0x3
	.4byte	init_taps
	.byte	0x4
	.4byte	0x79
	.4byte	0xbe
	.byte	0x5
	.4byte	0x80
	.byte	0x3f
	.byte	0
	.byte	0xa
	.4byte	.LASF17
	.byte	0x2
	.byte	0x1f
	.byte	0x5
	.4byte	0xae
	.byte	0x5
	.byte	0x3
	.4byte	outputsignal
	.byte	0xb
	.string	"fir"
	.byte	0x2
	.byte	0x2d
	.byte	0x33
	.4byte	0xe6
	.4byte	.LFB317
	.4byte	.LFE317-.LFB317
	.byte	0x1
	.byte	0x9c
	.byte	0xc
	.byte	0x4
	.4byte	0x79
	.byte	0xd
	.4byte	.LASF18
	.byte	0x2
	.byte	0x22
	.byte	0x33
	.4byte	.LFB316
	.4byte	.LFE316-.LFB316
	.byte	0x1
	.byte	0x9c
	.4byte	0x11a
	.byte	0xe
	.4byte	.LBB2
	.4byte	.LBE2-.LBB2
	.byte	0xf
	.string	"i"
	.byte	0x2
	.byte	0x26
	.byte	0xb
	.4byte	0x79
	.byte	0x2
	.byte	0x91
	.byte	0x6c
	.byte	0
	.byte	0
	.byte	0x6
	.4byte	.LASF14
	.byte	0x1c
	.4byte	.LFB22
	.4byte	.LFE22-.LFB22
	.byte	0x1
	.byte	0x9c
	.byte	0x6
	.4byte	.LASF15
	.byte	0xe
	.4byte	.LFB21
	.4byte	.LFE21-.LFB21
	.byte	0x1
	.byte	0x9c
	.byte	0
	.section	.debug_abbrev,"",@progbits
.Ldebug_abbrev0:
	.byte	0x1
	.byte	0x24
	.byte	0
	.byte	0xb
	.byte	0xb
	.byte	0x3e
	.byte	0xb
	.byte	0x3
	.byte	0xe
	.byte	0
	.byte	0
	.byte	0x2
	.byte	0x16
	.byte	0
	.byte	0x3
	.byte	0xe
	.byte	0x3a
	.byte	0x21
	.byte	0x3
	.byte	0x3b
	.byte	0xb
	.byte	0x39
	.byte	0xb
	.byte	0x49
	.byte	0x13
	.byte	0
	.byte	0
	.byte	0x3
	.byte	0x26
	.byte	0
	.byte	0x49
	.byte	0x13
	.byte	0
	.byte	0
	.byte	0x4
	.byte	0x1
	.byte	0x1
	.byte	0x49
	.byte	0x13
	.byte	0x1
	.byte	0x13
	.byte	0
	.byte	0
	.byte	0x5
	.byte	0x21
	.byte	0
	.byte	0x49
	.byte	0x13
	.byte	0x2f
	.byte	0xb
	.byte	0
	.byte	0
	.byte	0x6
	.byte	0x2e
	.byte	0
	.byte	0x3
	.byte	0xe
	.byte	0x3a
	.byte	0x21
	.byte	0x1
	.byte	0x3b
	.byte	0xb
	.byte	0x39
	.byte	0x21
	.byte	0x25
	.byte	0x27
	.byte	0x19
	.byte	0x11
	.byte	0x1
	.byte	0x12
	.byte	0x6
	.byte	0x40
	.byte	0x18
	.byte	0x7a
	.byte	0x19
	.byte	0
	.byte	0
	.byte	0x7
	.byte	0x11
	.byte	0x1
	.byte	0x25
	.byte	0xe
	.byte	0x13
	.byte	0xb
	.byte	0x3
	.byte	0x1f
	.byte	0x1b
	.byte	0x1f
	.byte	0x55
	.byte	0x17
	.byte	0x11
	.byte	0x1
	.byte	0x10
	.byte	0x17
	.byte	0
	.byte	0
	.byte	0x8
	.byte	0x24
	.byte	0
	.byte	0xb
	.byte	0xb
	.byte	0x3e
	.byte	0xb
	.byte	0x3
	.byte	0x8
	.byte	0
	.byte	0
	.byte	0x9
	.byte	0x34
	.byte	0
	.byte	0x3
	.byte	0xe
	.byte	0x3a
	.byte	0xb
	.byte	0x3b
	.byte	0xb
	.byte	0x39
	.byte	0xb
	.byte	0x49
	.byte	0x13
	.byte	0x2
	.byte	0x18
	.byte	0
	.byte	0
	.byte	0xa
	.byte	0x34
	.byte	0
	.byte	0x3
	.byte	0xe
	.byte	0x3a
	.byte	0xb
	.byte	0x3b
	.byte	0xb
	.byte	0x39
	.byte	0xb
	.byte	0x49
	.byte	0x13
	.byte	0x3f
	.byte	0x19
	.byte	0x2
	.byte	0x18
	.byte	0
	.byte	0
	.byte	0xb
	.byte	0x2e
	.byte	0
	.byte	0x3f
	.byte	0x19
	.byte	0x3
	.byte	0x8
	.byte	0x3a
	.byte	0xb
	.byte	0x3b
	.byte	0xb
	.byte	0x39
	.byte	0xb
	.byte	0x49
	.byte	0x13
	.byte	0x11
	.byte	0x1
	.byte	0x12
	.byte	0x6
	.byte	0x40
	.byte	0x18
	.byte	0x7c
	.byte	0x19
	.byte	0
	.byte	0
	.byte	0xc
	.byte	0xf
	.byte	0
	.byte	0xb
	.byte	0xb
	.byte	0x49
	.byte	0x13
	.byte	0
	.byte	0
	.byte	0xd
	.byte	0x2e
	.byte	0x1
	.byte	0x3f
	.byte	0x19
	.byte	0x3
	.byte	0xe
	.byte	0x3a
	.byte	0xb
	.byte	0x3b
	.byte	0xb
	.byte	0x39
	.byte	0xb
	.byte	0x11
	.byte	0x1
	.byte	0x12
	.byte	0x6
	.byte	0x40
	.byte	0x18
	.byte	0x7a
	.byte	0x19
	.byte	0x1
	.byte	0x13
	.byte	0
	.byte	0
	.byte	0xe
	.byte	0xb
	.byte	0x1
	.byte	0x11
	.byte	0x1
	.byte	0x12
	.byte	0x6
	.byte	0
	.byte	0
	.byte	0xf
	.byte	0x34
	.byte	0
	.byte	0x3
	.byte	0x8
	.byte	0x3a
	.byte	0xb
	.byte	0x3b
	.byte	0xb
	.byte	0x39
	.byte	0xb
	.byte	0x49
	.byte	0x13
	.byte	0x2
	.byte	0x18
	.byte	0
	.byte	0
	.byte	0
	.section	.debug_aranges,"",@progbits
	.4byte	0x2c
	.2byte	0x2
	.4byte	.Ldebug_info0
	.byte	0x4
	.byte	0
	.2byte	0
	.2byte	0
	.4byte	.Ltext0
	.4byte	.Letext0-.Ltext0
	.4byte	.LFB316
	.4byte	.LFE316-.LFB316
	.4byte	.LFB317
	.4byte	.LFE317-.LFB317
	.4byte	0
	.4byte	0
	.section	.debug_rnglists,"",@progbits
.Ldebug_ranges0:
	.4byte	.Ldebug_ranges3-.Ldebug_ranges2
.Ldebug_ranges2:
	.2byte	0x5
	.byte	0x4
	.byte	0
	.4byte	0
.LLRL0:
	.byte	0x6
	.4byte	.Ltext0
	.4byte	.Letext0
	.byte	0x6
	.4byte	.LFB316
	.4byte	.LFE316
	.byte	0x6
	.4byte	.LFB317
	.4byte	.LFE317
	.byte	0
.Ldebug_ranges3:
	.section	.debug_line,"",@progbits
.Ldebug_line0:
	.section	.debug_str,"MS",@progbits,1
.LASF18:
	.string	"initfir"
.LASF14:
	.string	"flush_cpu_dcache"
.LASF6:
	.string	"unsigned char"
.LASF10:
	.string	"long unsigned int"
.LASF7:
	.string	"short unsigned int"
.LASF16:
	.string	"GNU C17 12.1.0 -mabi=ilp32 -mtune=rocket -misa-spec=2.2 -march=rv32i -g -ffreestanding"
.LASF12:
	.string	"unsigned int"
.LASF11:
	.string	"long long unsigned int"
.LASF15:
	.string	"flush_cpu_icache"
.LASF8:
	.string	"int32_t"
.LASF17:
	.string	"outputsignal"
.LASF5:
	.string	"long long int"
.LASF3:
	.string	"short int"
.LASF9:
	.string	"uint32_t"
.LASF4:
	.string	"long int"
.LASF2:
	.string	"signed char"
.LASF13:
	.string	"init_taps"
	.section	.debug_line_str,"MS",@progbits,1
.LASF1:
	.string	"/home/ubuntu/Spring_Lab4_Caravel_FIR-master/lab-caravel_fir/testbench/counter_la_fir"
.LASF0:
	.string	"fir_control.c"
	.ident	"GCC: (g1ea978e3066) 12.1.0"

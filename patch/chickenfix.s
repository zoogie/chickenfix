	.arm
	.text
	.cpu mpcore
	.arch armv6k

@ this patch code is located in a "safe spot" near the end of Atooi Collection .text (0x34a600)

.global _start
start:
	add r0, r5, #8		@ this is atooi code that was overwritten be our redirect jump at 0x17698c, so we do it here as a make-up
	
	cmp r4, #0x2e
	blt skip		@ skip the memcpy after return (bx lr) if r4 is one of the affected last two levels index (2e or 2f)
	add lr, lr, #4		@ this will avoid wrong level bugs in Create mode and avoid the level 8.5+ memcpy permissions crash in Play (story) mode.
/*
	@ we will now skip all of this commented mem allocation code because it's just easier to avoid the offending memcpy instance altogether (see above)
	mov r0, #4 		@ operation - map, aka malloc
	ldr r1, =0x005ea000	@ addr0 - unallocated in the game, causes a crash from the read side of a leveldata transfer memcpy
	mov r2, #0 		@ addr1 - dontcare
	ldr r3, =0x4000 	@ size - enough to finish 0x2208 x 2 levels
	mov r4, #3 		@ permissions - RW, what BSS area usually is

	svc 1			@ svcControlMemory (malloc in our case)
*/
skip:
	bx lr			@ return to atooi's code

.pool			



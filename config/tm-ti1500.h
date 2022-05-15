/* Definitions of target machine for GNU compiler.  ISI 68000/68020 version.
   Intended only for use with GAS, and not ISI's assembler, which is buggy
   Copyright (C) 1988 Free Software Foundation, Inc.

This file is part of GNU CC.

GNU CC is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 1, or (at your option)
any later version.

GNU CC is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with GNU CC; see the file COPYING.  If not, write to
the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.  */

#include "tm-m68k.h"

#define USE_GAS

/* See tm-m68k.h.  7 means 68020 with 68881. */

/* #define TARGET_DEFAULT 7 */

/* make a 68010 version that has option of 68020 and 68881 */

#define TARGET_DEFAULT 0

/* Define __HAVE_68881__ in preprocessor, unless -msoft-float is specified.
   This will control the use of inline 68881 insns in certain macros.  */

#define CPP_SPEC "%{!msoft-float:-D__HAVE_68881__}"

/* If the 68881 is used, link must load libmc.a instead of libc.a */

/*
#define LIB_SPEC "%{msoft-float:%{!p:%{!pg:-lc}}%{p:-lc_p}%{pg:-lc_p}}%{!msoft-float:%{!p:%{!pg:-lmc}}%{p:-lmc_p}%{pg:-lmc_p}}"
*/

#define LIB_SPEC "%{!coff:%{msoft-float:%{!p:%{!pg:-L/usr/local/lib -lc}}%{p:-lc_p}%{pg:-lc_p}}%{!msoft-float:%{!p:%{!pg:-L/usr/local/lib -lc}}%{p:-lmc_p}%{pg:-lc_p}}}%{coff:-L/lib -lc -L/usr/lib} "

/* Names to predefine in the preprocessor for this target machine.  */

#define CPP_PREDEFINES "-Dunix -Dmc68000 -Dti1500 -Dm68k -DNU"

/* This is DBX, so it wants DBX format.  */
/*  #define DBX_DEBUGGING_INFO   */

/* This is SDB, so it wants SDB format.  */
#define SDB_DEBUGGING_INFO

/* Boundary (in *bits*) on which stack pointer should be aligned.  */
#undef STACK_BOUNDARY /* 16 */ 
#define STACK_BOUNDARY 16

/* Allocation boundary (in *bits*) for storing pointers in memory.  */
#undef POINTER_BOUNDARY /* 16 */
#define POINTER_BOUNDARY 32

/* The ti1500 likes ints, pointers, structs and unions that are not 
	in records to be on a 32 bit boundarys
	Look in stor-layout.c for how these macros are used.  */

#undef BIGGEST_ALIGNMENT_IN_RECORD
#define BIGGEST_ALIGNMENT_IN_RECORD 16

/* There is no point aligning anything to a rounder boundary than this.  */

#undef BIGGEST_ALIGNMENT /* 16 */
#define BIGGEST_ALIGNMENT 32 

/* A bitfield declared as `int' forces `int' alignment for the struct.  */
#define PCC_BITFIELD_TYPE_MATTERS 

#undef STRUCTURE_SIZE_BOUNDARY  /* 16 */
#define STRUCTURE_SIZE_BOUNDARY 16

/* SVS and PCC round to 16 bit boundarys 
	when putting parameters on the stack */ 
#undef PARM_BOUNDARY
#define PARM_BOUNDARY 16

#undef ASM_OUTPUT_ALIGN
#define ASM_OUTPUT_ALIGN(FILE,LOG)	\
 	if (LOG > 2 || LOG < 0 ) \
		printf("LOG of ASM_OUTPUT_LOG = %d\n", LOG); \
	if (LOG) { \
		if (LOG == 1) \
   		fprintf (FILE, "\t.even\n");	\
		else fprintf(FILE, "\t.align 2\n"); \
	}

/* Generate calls to memcpy, memcmp and memset.  */ 
#define TARGET_MEM_FUNCTIONS

/* ti1500 and NEWS return floats and doubles in fp0, not d0/d1.  */

#undef FUNCTION_VALUE
#define FUNCTION_VALUE(VALTYPE,FUNC) LIBCALL_VALUE (TYPE_MODE (VALTYPE))

#undef LIBCALL_VALUE
#define LIBCALL_VALUE(MODE) \
 gen_rtx (REG, (MODE), ((TARGET_68881 && ((MODE) == SFmode || (MODE) == DFmode)) ? 16 : 0))

/* Override parts of tm-m68000.h to fit the TI 1500 machine.  */

#undef  CALL_USED_REGISTERS

/* 1 for registers that have pervasive standard uses
   and are not available for the register allocator.
   On the 68000, only the stack pointer is such.  */
/* fpa0 is also reserved so that it can be used to move shit back and
   forth between high fpa regs and everything else. */

/* SVS makes d2, fp2 and fp3 unsaved registers, unlike the Sun system.  */
  
#define CALL_USED_REGISTERS \
 {1, 1, 1, 0, 0, 0, 0, 0, \
  1, 1, 0, 0, 0, 0, 0, 1, \
  1, 1, 1, 1, 0, 0, 0, 0}


/* Output #ident as a .ident.  */
/* ADDED for TI S1500  */

#define ASM_OUTPUT_IDENT(FILE, NAME) fprintf (FILE, "\t.ident \"%s\"\n", NAME);

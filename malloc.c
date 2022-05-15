/* dynamic memory allocation for GNU.
   Copyright (C) 1985 Free Software Foundation, Inc.

		       NO WARRANTY

  BECAUSE THIS PROGRAM IS LICENSED FREE OF CHARGE, WE PROVIDE ABSOLUTELY
NO WARRANTY, TO THE EXTENT PERMITTED BY APPLICABLE STATE LAW.  EXCEPT
WHEN OTHERWISE STATED IN WRITING, FREE SOFTWARE FOUNDATION, INC,
RICHARD M. STALLMAN AND/OR OTHER PARTIES PROVIDE THIS PROGRAM "AS IS"
WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING,
BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
FITNESS FOR A PARTICULAR PURPOSE.  THE ENTIRE RISK AS TO THE QUALITY
AND PERFORMANCE OF THE PROGRAM IS WITH YOU.  SHOULD THE PROGRAM PROVE
DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY SERVICING, REPAIR OR
CORRECTION.

 IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW WILL RICHARD M.
STALLMAN, THE FREE SOFTWARE FOUNDATION, INC., AND/OR ANY OTHER PARTY
WHO MAY MODIFY AND REDISTRIBUTE THIS PROGRAM AS PERMITTED BELOW, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY LOST PROFITS, LOST MONIES, OR
OTHER SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE
USE OR INABILITY TO USE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR
DATA BEING RENDERED INACCURATE OR LOSSES SUSTAINED BY THIRD PARTIES OR
A FAILURE OF THE PROGRAM TO OPERATE WITH ANY OTHER PROGRAMS) THIS
PROGRAM, EVEN IF YOU HAVE BEEN ADVISED OF THE POSSIBILITY OF SUCH
DAMAGES, OR FOR ANY CLAIM BY ANY OTHER PARTY.

		GENERAL PUBLIC LICENSE TO COPY

  1. You may copy and distribute verbatim copies of this source file
as you receive it, in any medium, provided that you conspicuously and
appropriately publish on each copy a valid copyright notice "Copyright
(C) 1985 Free Software Foundation, Inc."; and include following the
copyright notice a verbatim copy of the above disclaimer of warranty
and of this License.

  2. You may modify your copy or copies of this source file or
any portion of it, and copy and distribute such modifications under
the terms of Paragraph 1 above, provided that you also do the following:

    a) cause the modified files to carry prominent notices stating
    that you changed the files and the date of any change; and

    b) cause the whole of any work that you distribute or publish,
    that in whole or in part contains or is a derivative of this
    program or any part thereof, to be freely distributed
    and licensed to all third parties on terms identical to those
    contained in this License Agreement (except that you may choose
    to grant more extensive warranty protection to third parties,
    at your option).

  3. You may copy and distribute this program or any portion of it in
compiled, executable or object code form under the terms of Paragraphs
1 and 2 above provided that you do the following:

    a) cause each such copy to be accompanied by the
    corresponding machine-readable source code, which must
    be distributed under the terms of Paragraphs 1 and 2 above; or,

    b) cause each such copy to be accompanied by a
    written offer, with no time limit, to give any third party
    free (except for a nominal shipping charge) a machine readable
    copy of the corresponding source code, to be distributed
    under the terms of Paragraphs 1 and 2 above; or,

    c) in the case of a recipient of this program in compiled, executable
    or object code form (without the corresponding source code) you
    shall cause copies you distribute to be accompanied by a copy
    of the written offer of source code which you received along
    with the copy you received.

  4. You may not copy, sublicense, distribute or transfer this program
except as expressly provided under this License Agreement.  Any attempt
otherwise to copy, sublicense, distribute or transfer this program is void and
your rights to use the program under this License agreement shall be
automatically terminated.  However, parties who have received computer
software programs from you with this License Agreement will not have
their licenses terminated so long as such parties remain in full compliance.


In other words, you are welcome to use, share and improve this program.
You are forbidden to forbid anyone else to use, share and improve
what you give them.   Help stamp out software-hoarding!  */


/*
 * @(#)nmalloc.c 1 (Caltech) 2/21/82
 *
 *	U of M Modified: 20 Jun 1983 ACT: strange hacks for Emacs
 *
 *	Nov 1983, Mike@BRL, Added support for 4.1C/4.2 BSD.
 *
 * This is a very fast storage allocator.  It allocates blocks of a small
 * number of different sizes, and keeps free lists of each size.  Blocks
 * that don't exactly fit are passed up to the next larger size.  In this
 * implementation, the available sizes are (2^n)-4 (or -16) bytes long.
 * This is designed for use in a program that uses vast quantities of
 * memory, but bombs when it runs out.	To make it a little better, it
 * warns the user when he starts to get near the end.
 *
 * June 84, ACT: modified rcheck code to check the range given to malloc,
 * rather than the range determined by the 2-power used.
 *
 * Jan 85, RMS: calls malloc_warning to issue warning on nearly full.
 * No longer Emacs-specific; can serve as all-purpose malloc for GNU.
 * You should call malloc_init to reinitialize after loading dumped Emacs.
 * Call malloc_stats to get info on memory stats if MSTATS turned on.
 * realloc knows how to return same block given, just changing its size,
 * if the power of 2 is correct.
 */

/*
 * nextf[i] is the pointer to the next free block of size 2^(i+3).  The
 * smallest allocatable block is 8 bytes.  The overhead information will
 * go in the first int of the block, and the returned pointer will point
 * to the second.
 *
#ifdef MSTATS
 * nmalloc[i] is the difference between the number of mallocs and frees
 * for a given block size.
#endif /* MSTATS */

#ifdef emacs
#include "config.h"
#endif /* emacs */

#define bcopy(src,dest,n) memcpy(dest,src,n)

/* Determine which kind of system this is.  */
#include <signal.h>
#ifndef SIGTSTP
#ifndef VMS
#ifndef USG
#define USG
#endif
#endif /* not VMS */
#else /* SIGTSTP */
#ifdef SIGIO
#define BSD42
#endif /* SIGIO */
#endif /* SIGTSTP */

/* Define getpagesize () if the system does not.  */
#include "getpagesize.h"

#ifndef BSD42
#ifndef USG
#include <sys/vlimit.h>		/* warn the user when near the end */
#endif /* not USG */
#else /* if BSD42 */
#include <sys/time.h>
#include <sys/resource.h>
#endif /* BSD42 */

extern char *start_of_data ();

#ifdef BSD
#ifndef DATA_SEG_BITS
#define start_of_data() &etext
#endif
#endif

#ifndef emacs
#define start_of_data() &etext
#endif

#define ISALLOC ((char) 0xf7)	/* magic byte that implies allocation */
#define ISFREE ((char) 0x54)	/* magic byte that implies free block */
				/* this is for error checking only */
#define ISMEMALIGN ((char) 0xd6)  /* Stored before the value returned by
				     memalign, with the rest of the word
				     being the distance to the true
				     beginning of the block.  */

extern char etext;

/* These two are for user programs to look at, when they are interested.  */

int malloc_sbrk_used;	    /* amount of data space used now */
int malloc_sbrk_unused;     /* amount more we can have */

/* start of data space; can be changed by calling init_malloc */
static char *data_space_start;

#ifdef MSTATS
static int nmalloc[30];
static int nmal, nfre;
#endif /* MSTATS */

/* If range checking is not turned on, all we have is a flag indicating
   whether memory is allocated, an index in nextf[], and a size field; to
   realloc() memory we copy either size bytes or 1<<(index+3) bytes depending
   on whether the former can hold the exact size (given the value of
   'index').  If range checking is on, we always need to know how much space
   is allocated, so the 'size' field is never used. */

struct mhead {
	char     mh_alloc;	/* ISALLOC or ISFREE */
	char     mh_index;	/* index in nextf[] */
/* Remainder are valid only when block is allocated */
	unsigned short mh_size;	/* size, if < 0x10000 */
#ifdef rcheck
	unsigned mh_nbytes;	/* number of bytes allocated */
	int      mh_magic4;	/* should be == MAGIC4 */
#endif /* rcheck */
};

/* Access free-list pointer of a block.
  It is stored at block + 4.
  This is not a field in the mhead structure
  because we want sizeof (struct mhead)
  to describe the overhead for when the block is in use,
  and we do not want the free-list pointer to count in that.  */

#define CHAIN(a) \
  (*(struct mhead **) (sizeof (char *) + (char *) (a)))

#ifdef rcheck

/* To implement range checking, we write magic values in at the beginning and
   end of each allocated block, and make sure they are undisturbed whenever a
   free or a realloc occurs. */
/* Written in each of the 4 bytes following the block's real space */
#define MAGIC1 0x55
/* Written in the 4 bytes before the block's real space */
#define MAGIC4 0x55555555
#define ASSERT(p) if (!(p)) botch("p"); else
#define EXTRA  4		/* 4 bytes extra for MAGIC1s */
#else
#define ASSERT(p)
#define EXTRA  0
#endif /* rcheck */


/* nextf[i] is free list of blocks of size 2**(i + 3)  */

static struct mhead *nextf[30];

/* Number of bytes of writable memory we can expect to be able to get */
static int lim_data;
/* Level number of warnings already issued.
  0 -- no warnings issued.
  1 -- 75% warning already issued.
  2 -- 85% warning already issued.
*/
static int warnlevel;

/* Function to call to issue a warning;
   0 means don't issue them.  */
static void (*warnfunction) ();

/* nonzero once initial bunch of free blocks made */
static int gotpool;

char *_malloc_base;

/* Cause reinitialization based on job parameters;
  also declare where the end of pure storage is. */
malloc_init (start, warnfun)
     char *start;
     void (*warnfun) ();
{
  if (start)
    data_space_start = start;
  lim_data = 0;
  warnlevel = 0;
  warnfunction = warnfun;
}

static
getpool ()
{
  register int nu;
  char * sbrk ();
  register char *cp = sbrk (0);

  if ((int) cp & 0x3ff)	/* land on 1K boundaries */
    sbrk (1024 - ((int) cp & 0x3ff));

  /* Record address of start of space allocated by malloc.  */
  if (_malloc_base == 0)
    _malloc_base = cp;

  /* Get 2k of storage */

  cp = sbrk (04000);
  if (cp == (char *) -1)
    return;

  /* Divide it into an initial 8-word block
     plus one block of size 2**nu for nu = 3 ... 10.  */

  CHAIN (cp) = nextf[0];
  nextf[0] = (struct mhead *) cp;
  ((struct mhead *) cp) -> mh_alloc = ISFREE;
  ((struct mhead *) cp) -> mh_index = 0;
  cp += 8;

  for (nu = 0; nu < 7; nu++)
    {
      CHAIN (cp) = nextf[nu];
      nextf[nu] = (struct mhead *) cp;
      ((struct mhead *) cp) -> mh_alloc = ISFREE;
      ((struct mhead *) cp) -> mh_index = nu;
      cp += 8 << nu;
    }
}

static
morecore (nu)			/* ask system for more memory */
     register int nu;		/* size index to get more of  */
{
  char *sbrk ();
  register char *cp;
  register int nblks;
  register int siz;

  if (!data_space_start)
    {
      data_space_start = start_of_data ();
    }

  if (lim_data == 0)
    get_lim_data ();

 /* On initial startup, get two blocks of each size up to 1k bytes */
  if (!gotpool)
    { getpool (); getpool (); gotpool = 1; }

 /* Find current end of memory and issue warning if getting near max */

  cp = sbrk (0);
  siz = cp - data_space_start;
  malloc_sbrk_used = siz;
  malloc_sbrk_unused = lim_data - siz;

  if (warnfunction)
    switch (warnlevel)
      {
      case 0:
	if (siz > (lim_data / 4) * 3)
	  {
	    warnlevel++;
	    (*warnfunction) ("Warning: past 75% of memory limit");
	  }
	break;
      case 1:
	if (siz > (lim_data / 20) * 17)
	  {
	    warnlevel++;
	    (*warnfunction) ("Warning: past 85% of memory limit");
	  }
	break;
      case 2:
	if (siz > (lim_data / 20) * 19)
	  {
	    warnlevel++;
	    (*warnfunction) ("Warning: past 95% of memory limit");
	  }
	break;
      }

  if ((int) cp & 0x3ff)	/* land on 1K boundaries */
    sbrk (1024 - ((int) cp & 0x3ff));

 /* Take at least 2k, and figure out how many blocks of the desired size
    we're about to get */
  nblks = 1;
  if ((siz = nu) < 8)
    nblks = 1 << ((siz = 8) - nu);

  if ((cp = sbrk (1 << (siz + 3))) == (char *) -1)
    return;			/* no more room! */
  if ((int) cp & 7)
    {		/* shouldn't happen, but just in case */
      cp = (char *) (((int) cp + 8) & ~7);
      nblks--;
    }

 /* save new header and link the nblks blocks together */
  nextf[nu] = (struct mhead *) cp;
  siz = 1 << (nu + 3);
  while (1)
    {
      ((struct mhead *) cp) -> mh_alloc = ISFREE;
      ((struct mhead *) cp) -> mh_index = nu;
      if (--nblks <= 0) break;
      CHAIN ((struct mhead *) cp) = (struct mhead *) (cp + siz);
      cp += siz;
    }
 /* CHAIN ((struct mhead *) cp) = 0; */
 /* since sbrk() returns cleared core, this is already set */
}

char *
malloc (n)		/* get a block */
     unsigned n;
{
  register struct mhead *p;
  register unsigned int nbytes;
  register int nunits = 0;

  /* Figure out how many bytes are required, rounding up to the nearest
     multiple of 4, then figure out which nextf[] area to use */
  nbytes = (n + sizeof *p + EXTRA + 3) & ~3;
  {
    register unsigned int   shiftr = (nbytes - 1) >> 2;

    while (shiftr >>= 1)
      nunits++;
  }

  /* If there are no blocks of the appropriate size, go get some */
  /* COULD SPLIT UP A LARGER BLOCK HERE ... ACT */
  if (nextf[nunits] == 0)
    morecore (nunits);

  /* Get one block off the list, and set the new list head */
  if ((p = nextf[nunits]) == 0)
    return 0;
  nextf[nunits] = CHAIN (p);

  /* Check for free block clobbered */
  /* If not for this check, we would gobble a clobbered free chain ptr */
  /* and bomb out on the NEXT allocate of this size block */
  if (p -> mh_alloc != ISFREE || p -> mh_index != nunits)
#ifdef rcheck
    botch ("block on free list clobbered");
#else /* not rcheck */
    abort ();
#endif /* not rcheck */

  /* Fill in the info, and if range checking, set up the magic numbers */
  p -> mh_alloc = ISALLOC;
#ifdef rcheck
  p -> mh_nbytes = n;
  p -> mh_magic4 = MAGIC4;
  {
    register char  *m = (char *) (p + 1) + n;

    *m++ = MAGIC1, *m++ = MAGIC1, *m++ = MAGIC1, *m = MAGIC1;
  }
#else /* not rcheck */
  p -> mh_size = n;
#endif /* not rcheck */
#ifdef MSTATS
  nmalloc[nunits]++;
  nmal++;
#endif /* MSTATS */
  return (char *) (p + 1);
}

free (mem)
     char *mem;
{
  register struct mhead *p;
  {
    register char *ap = mem;

    if (ap == 0)
      return;

    p = (struct mhead *) ap - 1;
    if (p -> mh_alloc == ISMEMALIGN)
      {
	ap -= p->mh_size;
	p = (struct mhead *) ap - 1;
      }

/* This cause a problem for cpp  */
    if (p -> mh_alloc != ISALLOC)
      abort ();

#ifdef rcheck
    ASSERT (p -> mh_magic4 == MAGIC4);
    ap += p -> mh_nbytes;
    ASSERT (*ap++ == MAGIC1); ASSERT (*ap++ == MAGIC1);
    ASSERT (*ap++ == MAGIC1); ASSERT (*ap   == MAGIC1);
#endif /* rcheck */
  }
  {
    register int nunits = p -> mh_index;

    ASSERT (nunits <= 29);
    p -> mh_alloc = ISFREE;
    CHAIN (p) = nextf[nunits];
    nextf[nunits] = p;
#ifdef MSTATS
    nmalloc[nunits]--;
    nfre++;
#endif /* MSTATS */
  }
}

char *
realloc (mem, n)
     char *mem;
     register unsigned n;
{
  register struct mhead *p;
  register unsigned int tocopy;
  register int nbytes;
  register int nunits;

  if ((p = (struct mhead *) mem) == 0)
    return malloc (n);
  p--;
  nunits = p -> mh_index;
  ASSERT (p -> mh_alloc == ISALLOC);
#ifdef rcheck
  ASSERT (p -> mh_magic4 == MAGIC4);
  {
    register char *m = mem + (tocopy = p -> mh_nbytes);
    ASSERT (*m++ == MAGIC1); ASSERT (*m++ == MAGIC1);
    ASSERT (*m++ == MAGIC1); ASSERT (*m   == MAGIC1);
  }
#else /* not rcheck */
  if (p -> mh_index >= 13)
    tocopy = (1 << (p -> mh_index + 3)) - sizeof *p;
  else
    tocopy = p -> mh_size;
#endif /* not rcheck */

  /* See if desired size rounds to same power of 2 as actual size. */
  nbytes = (n + sizeof *p + EXTRA + 7) & ~7;

  /* If ok, use the same block, just marking its size as changed.  */
  if (nbytes > (4 << nunits) && nbytes <= (8 << nunits))
    {
#ifdef rcheck
      register char *m = mem + tocopy;
      *m++ = 0;  *m++ = 0;  *m++ = 0;  *m++ = 0;
      p-> mh_nbytes = n;
      m = mem + n;
      *m++ = MAGIC1;  *m++ = MAGIC1;  *m++ = MAGIC1;  *m++ = MAGIC1;
#else /* not rcheck */
      p -> mh_size = n;
#endif /* not rcheck */
      return mem;
    }

  if (n < tocopy)
    tocopy = n;
  {
    register char *new;

    if ((new = malloc (n)) == 0)
      return 0;
    bcopy (mem, new, tocopy);
    free (mem);
    return new;
  }
}

char *
memalign (alignment, size)
     unsigned alignment, size;
{
  register char *ptr = malloc (size + alignment);
  register char *aligned;
  register struct mhead *p;

  if (ptr == 0)
    return 0;
  /* If entire block has the desired alignment, just accept it.  */
  if (((int) ptr & (alignment - 1)) == 0)
    return ptr;
  /* Otherwise, get address of byte in the block that has that alignment.  */
  aligned = (char *) (((int) ptr + alignment - 1) & -alignment);

  /* Store a suitable indication of how to free the block,
     so that free can find the true beginning of it.  */
  p = (struct mhead *) aligned - 1;
  p -> mh_size = aligned - ptr;
  p -> mh_alloc = ISMEMALIGN;
  return aligned;
}

#ifndef HPUX
/* This runs into trouble with getpagesize on HPUX.
   Patching out seems cleaner than the ugly fix needed.  */
char *
valloc (size)
{
  return memalign (getpagesize (), size);
}
#endif /* not HPUX */

#ifdef MSTATS
/* Return statistics describing allocation of blocks of size 2**n. */

struct mstats_value
  {
    int blocksize;
    int nfree;
    int nused;
  };

struct mstats_value
malloc_stats (size)
     int size;
{
  struct mstats_value v;
  register int i;
  register struct mhead *p;

  v.nfree = 0;

  if (size < 0 || size >= 30)
    {
      v.blocksize = 0;
      v.nused = 0;
      return v;
    }

  v.blocksize = 1 << (size + 3);
  v.nused = nmalloc[size];

  for (p = nextf[size]; p; p = CHAIN (p))
    v.nfree++;

  return v;
}
#endif /* MSTATS */

/*
 *	This function returns the total number of bytes that the process
 *	will be allowed to allocate via the sbrk(2) system call.  On
 *	BSD systems this is the total space allocatable to stack and
 *	data.  On USG systems this is the data space only.
 */

#ifdef USG

get_lim_data ()
{
  extern long ulimit ();

  lim_data = ulimit (3, 0);
  lim_data -= (long) data_space_start;
}

#else /* not USG */
#ifndef BSD42

get_lim_data ()
{
  lim_data = vlimit (LIM_DATA, -1);
}

#else /* BSD42 */

get_lim_data ()
{
  struct rlimit XXrlimit;

  getrlimit (RLIMIT_DATA, &XXrlimit);
  lim_data = XXrlimit.rlim_cur;		/* soft limit */
}

#endif /* BSD42 */
#endif /* not USG */

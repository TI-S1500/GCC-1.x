


GCC(1)                   USER COMMANDS                     GCC(1)



NAME
     gcc - GNU project C Compiler (Texas Instruments Version)

SYNOPSIS
     gcc [ options ] files

WARNING
     This man page is an extract of the documentation of the  _G_N_U
     _C _c_o_m_p_i_l_e_r and is limited to the meaning of the options.  
     For complete, current documentation, refer to the GNU C
     manual shipped with this software.
     

DESCRIPTION
     The _G_N_U _C _c_o_m_p_i_l_e_r uses a command syntax much like the  Unix
     C  compiler.  The _g_c_c program accepts options and file names
     as operands.  Multiple  single-letter  options  may  _n_o_t  be
     grouped:  -dr is very different from -d -r.  When you invoke
     GNU CC, it normally does preprocessing, compilation,  assem-
     bly  and linking.  File names which end in .c are taken as C
     source to be preprocessed and compiled; file names ending in
     .i are taken as preprocessor output to be compiled; compiler
     output files plus any input files with names  ending  in  .s
     are  assembled;  then  the  resulting object files, plus any
     other input files, are linked together to produce an execut-
     able.   Command options allow you to stop this process at an
     intermediate stage.  For example, the -c option says not  to
     run  the  linker.   Then the output consists of object files
     output by the assembler.  Other command options  are  passed
     on  to  one  stage  of processing.  Some options control the
     preprocessor and others  the  compiler  itself.   Yet  other
     options  control  the  assembler  and  linker; these are not
     documented here, but you rarely need to use any of them.

OPTIONS
     Here are the options to control the overall compilation pro-
     cess,  including  those that say whether to link, whether to
     assemble, and so on.

     -o _f_i_l_e
          Place output in file _f_i_l_e.  This applies regardless  to
          whatever  sort  of output is being produced, whether it
          be an executable file, an  object  file,  an  assembler
          file or preprocessed C code.

          If -o is not specified, the default is to put  an  exe-
          cutable  file  in  a.out,  the  object file _s_o_u_r_c_e.c in
          _s_o_u_r_c_e.o, an assembler file in  _s_o_u_r_c_e.s,  and  prepro-
          cessed C on standard output.

     -c   Compile or assemble the source files, but do not  link.



Version 1.37.1        Last change: 17 Dec 1990                   1






GCC(1)                   USER COMMANDS                     GCC(1)



          Produce object files with names made by replacing .c or
          .s with .o at the end of  the  input  file  names.   Do
          nothing at all for object files specified as input.

     -S   Compile into assembler code but do not  assemble.   The
          assembler output file name is made by replacing .c with
          .s at the end of the input file name.   Do  nothing  at
          all  for  assembler source files or object files speci-
          fied as input.

     -E   Run only the C  preprocessor.   Preprocess  all  the  C
          source  files specified and output the results to stan-
          dard output.

     -v   Compiler driver program prints the commands it executes
          as it runs the preprocessor, compiler proper, assembler
          and linker.  Some of these are directed to print  their
          own version numbers.

     -pipe
          Use pipes rather than temporary files for communication
          between  the various stages of compilation.  This fails
          to work on some systems where the assembler  is  unable
          to read from a pipe; but the GNU assembler has no trou-
          ble.

     -B_p_r_e_f_i_x
          Compiler driver program tries _p_r_e_f_i_x as  a  prefix  for
          each  program it tries to run.  These programs are _c_p_p,
          _c_c_1, _a_s and _l_d.

          For each subprogram to  be  run,  the  compiler  driver
          first tries the -B prefix, if any.  If that name is not
          found, or if -B was not specified, the driver tries two
          standard   prefixes,   which   are   /usr/lib/gcc-  and
          /usr/local/lib/gcc-.  If neither of those results in  a
          file name that is found, the unmodified program name is
          searched for using the directories  specified  in  your
          PATH environment variable.

          The run-time support file gnulib is also  searched  for
          using  the  -B  prefix,  if needed.  If it is not found
          there, the two standard prefixes above are  tried,  and
          that is all.  The file is left out of the link if it is
          not found by those means.  Most of the  time,  on  most
          machines, you can do without it.

          You can get a similar result from the environment vari-
          able  GCC_EXEC_PREFIX;  if  it is defined, its value is
          used as a prefix in the  same  way.   If  both  the  -B
          option  and  the  GCC_EXEC_PREFIX variable are present,
          the  -B  option  is  used  first  and  the  environment



Version 1.37.1        Last change: 17 Dec 1990                   2






GCC(1)                   USER COMMANDS                     GCC(1)



          variable value second.

     -b_p_r_e_f_i_x
          The argument _p_r_e_f_i_x is used as a second prefix for  the
          compiler  executables  and  libraries.   This prefix is
          optional: the compiler tries each file first  with  it,
          then without it.  This prefix follows the prefix speci-
          fied with -B or the default prefixes.

          Thus, -bvax- -Bcc/ in the presence of environment vari-
          able GCC_EXEC_PREFIX with definition /u/foo/ causes GNU
          CC to try the following file names for the preprocessor
          executable:

               cc/vax-cpp
               cc/cpp
               /u/foo/vax-cpp
               /u/foo/cpp
               /usr/local/lib/gcc-vax-cpp
               /usr/local/lib/gcc-cpp
               /usr/lib/gcc-vax-cpp
               /usr/lib/gcc-cpp These options control the details
          of C compilation itself.

     -ansi
          Support all ANSI standard C programs.

          This turns off certain  features  of  GNU  C  that  are
          incompatible  with  ANSI C, such as the asm, inline and
          typeof keywords, and predefined macros such as unix and
          vax that identify the type of system you are using.  It
          also enables the undesirable and rarely used ANSI  tri-
          graph feature.

          The  alternate   keywords   __asm__,   __inline__   and
          __typeof__  continue  to work despite -ansi.  You would
          not want to use them in an ANSI C program,  of  course,
          but it useful to put them in header files that might be
          included in compilations done  with  -ansi.   Alternate
          predefined macros such as __unix__ and __vax__ are also
          available, with or without -ansi.

          The -ansi option does not cause non-ANSI programs to be
          rejected gratuitously.  For that, -pedantic is required
          in addition to -ansi.

          The macro __STRICT_ANSI__ is predefined when the  -ansi
          option  is  used.   Some  header  files may notice this
          macro and refrain from declaring certain  functions  or
          defining  certain macros that the ANSI standard doesn't
          call for; this is to avoid interfering  with  any  pro-
          grams that might use these names for other things.



Version 1.37.1        Last change: 17 Dec 1990                   3






GCC(1)                   USER COMMANDS                     GCC(1)



     -traditional
          Attempt to support some aspects of traditional  C  com-
          pilers.  Specifically:

        * All extern declarations take effect  globally  even  if
          they are written inside of a function definition.  This
          includes implicit declarations of functions.

        * The keywords typeof, inline, signed, const and volatile
          are not recognized.

        * Comparisons between pointers and  integers  are  always
          allowed.

        * Integer types unsigned short and unsigned char  promote
          to unsigned int.

        * Out-of-range floating point literals are not an error.

        * All  automatic  variables  not  declared  register  are
          preserved  by  _l_o_n_g_j_m_p(3C).   Ordinarily, GNU C follows
          ANSI C: automatic variables not declared  volatile  may
          be clobbered.

        * In the preprocessor, comments  convert  to  nothing  at
          all,  rather  than to a space.  This allows traditional
          token concatenation.

        * In the preprocessor,  macro  arguments  are  recognized
          within  string  constants  in  a  macro definition (and
          their values are stringified, though without additional
          quote  marks, when they appear in such a context).  The
          preprocessor always considers a string constant to  end
          at a newline.

        * The predefined macro __STDC__ is not defined  when  you
          use -traditional, but __GNUC__ is (since the GNU exten-
          sions which __GNUC__  indicates  are  not  affected  by
          -traditional).   If you need to write header files that
          work differently depending on whether  -traditional  is
          in  use, by testing both of these predefined macros you
          can distinguish four situations: GNU C, traditional GNU
          C, other ANSI C compilers, and other old C compilers.

     -O   Optimize.  Optimizing compilation takes  somewhat  more
          time, and a lot more memory for a large function.

          Without -O, the compiler's goal is to reduce  the  cost
          of  compilation  and  to  make  debugging  produce  the
          expected results.  Statements are independent:  if  you
          stop  the program with a breakpoint between statements,
          you can then assign a new  value  to  any  variable  or



Version 1.37.1        Last change: 17 Dec 1990                   4






GCC(1)                   USER COMMANDS                     GCC(1)



          change  the  program  counter to any other statement in
          the function and get  exactly  the  results  you  would
          expect from the source code.

          Without -O, only variables declared register are  allo-
          cated  in  registers.  The resulting compiled code is a
          little worse than produced by PCC without -O.

          With -O, the compiler tries to  reduce  code  size  and
          execution time.

          Some of the -f options described  below  turn  specific
          kinds of optimization on or off.

     -g   Produce debugging information in the operating system's
          native format (for DBX or SDB).  GDB also can work with
          this debugging information.

          Unlike most other C compilers, GNU CC allows you to use
          -g  with -O.  The shortcuts taken by optimized code may
          occasionally produce surprising results: some variables
          you  declared may not exist at all; flow of control may
          briefly move where you did not expect it;  some  state-
          ments may not be executed because they compute constant
          results or their values  were  already  at  hand;  some
          statements may execute in different places because they
          were moved out of loops.  Nevertheless it proves possi-
          ble  to  debug optimized output.  This makes it reason-
          able to use the optimizer for programs that might  have
          bugs.

     -gg  Produce debugging  information  in  GDB's  own  format.
          This  requires the GNU assembler and linker in order to
          work. (NOT SUPPORTED ON Texas Instruments Version)

          This feature  will  probably  be  eliminated.   It  was
          intended to enable GDB to read the symbol table faster,
          but it doesn't result in enough  of  a  speedup  to  be
          worth  the larger object files and executables.  We are
          working on other ways of making GDB start even  faster,
          which  work  with  DBX format debugging information and
          could be made to work with SDB format.

     -w   Inhibit all warning messages.

     -W   Print extra warning messages for these events:

        * An automatic variable is used without first being  ini-
          tialized.

          These warnings are possible only in optimizing compila-
          tion,  because  they require data flow information that



Version 1.37.1        Last change: 17 Dec 1990                   5






GCC(1)                   USER COMMANDS                     GCC(1)



          is computed only when optimizing.  If you don't specify
          -O, you simply won't get these warnings.

          These warnings occur only for variables that are candi-
          dates  for register allocation.  Therefore, they do not
          occur for a variable  that  is  declared  volatile,  or
          whose  address is taken, or whose size is other than 1,
          2, 4 or 8 bytes.  Also, they do not  occur  for  struc-
          tures,  unions  or arrays, even when they are in regis-
          ters.

          Note that there may be no warning about a variable that
          is  used  only  to compute a value that itself is never
          used, because such computations may be deleted by  data
          flow analysis before the warnings are printed.

          These warnings are made optional because GNU CC is  not
          smart  enough to see all the reasons why the code might
          be correct despite appearing to have an error.  Here is
          one example of how this can happen:

               {
                 int x;
                 switch (y)
                   {
                   case 1: x = 1;
                     break;
                   case 2: x = 4;
                     break;
                   case 3: x = 5;
                   }
                 foo (x);
               }

          If the value of _y is always 1, 2 or 3, then _x is always
          initialized,  but  GNU  CC  doesn't know this.  Here is
          another common case:

               {
                 int save_y;
                 if (change_y) save_y = y, y = new_y;
                 ...
                 if (change_y) y = save_y;
               }

          This has no bug because _s_a_v_e__y is used only  if  it  is
          set.

          Some spurious warnings can be avoided if you declare as
          volatile all the functions you use that never return.

        * A nonvolatile automatic variable might be changed by  a



Version 1.37.1        Last change: 17 Dec 1990                   6






GCC(1)                   USER COMMANDS                     GCC(1)



          call to _l_o_n_g_j_m_p(3C).  These warnings as well are possi-
          ble only in optimizing compilation.

          The compiler sees only the  calls  to  _s_e_t_j_m_p(3C).   It
          cannot  know where _l_o_n_g_j_m_p(3C) will be called; in fact,
          a signal handler could call it  at  any  point  in  the
          code.   As  a  result,  you may get a warning even when
          there is in fact no problem because _l_o_n_g_j_m_p(3C)  cannot
          in  fact  be  called  at  the place which would cause a
          problem.

        * A function can return either with or without  a  value.
          (Falling off the end of the function body is considered
          returning without a value.) For example, this  function
          would evoke such a warning:

               foo (a)
               {
                 if (a > 0)
                   return a;
               }

          Spurious warnings can occur because  GNU  CC  does  not
          realize that certain functions (including _a_b_o_r_t(3C) and
          _l_o_n_g_j_m_p(3C)) will never return.

        * An expression-statement contains no side effects.

          In the  future,  other  useful  warnings  may  also  be
          enabled by this option.

     -Wimplicit
          Warn whenever a function is implicitly declared.

     -Wreturn-type
          Warn whenever a function is defined with a  return-type
          that  defaults  to  int.   Also  warn  about any return
          statement with no  return-value  in  a  function  whose
          return-type is not void.

     -Wunused
          Warn whenever a local variable is unused aside from its
          declaration, and whenever a function is declared static
          but never defined.

     -Wswitch
          Warn whenever  a  switch  statement  has  an  index  of
          enumeral  type  and lacks a case for one or more of the
          named codes of that enumeration.  (The  presence  of  a
          default  label prevents this warning.) case labels out-
          side the enumeration range also provoke  warnings  when
          this option is used.



Version 1.37.1        Last change: 17 Dec 1990                   7






GCC(1)                   USER COMMANDS                     GCC(1)



     -Wcomment
          Warn whenever a comment-start sequence /* appears in  a
          comment.

     -Wtrigraphs
          Warn if any trigraphs are  encountered  (assuming  they
          are enabled).

     -Wall
          All of the above -W options combined.   These  are  all
          the  options  which  pertain  to  usage  that we do not
          recommend and that we believe is always easy to  avoid,
          even in conjunction with macros.

          The other -W...  options below are not implied by -Wall
          because  certain  kinds  of  useful  macros  are almost
          impossible to write without causing those warnings.

     -Wshadow
          Warn whenever a local variable  shadows  another  local
          variable.

     -Wid-clash-_l_e_n
          Warn whenever two distinct  identifiers  match  in  the
          first _l_e_n characters.  This may help you prepare a pro-
          gram that will compile with  certain  obsolete,  brain-
          damaged compilers.

     -Wpointer-arith
          Warn about anything that depends on the size of a func-
          tion type or of void.  GNU C assigns these types a size
          of 1, for  convenience  in  calculations  with  void  *
          pointers and pointers to functions.

     -Wcast-qual
          Warn whenever a pointer is cast so as to remove a  type
          qualifier from the target type.  For example, warn if a
          const char * is cast to an ordinary char *.

     -Wwrite-strings
          Give string constants the type  const  char[_l_e_n_g_t_h]  so
          that copying the address of one into a non-const char *
          pointer will get a warning.  These warnings  will  help
          you  find  at  compile  time code that can try to write
          into a string constant, but only if you have been  very
          careful  about  using  const in declarations and proto-
          types.  Otherwise, it will just be a nuisance; this  is
          why we did not make -Wall request these warnings.

     -p   Generate extra code to write profile information  suit-
          able for the analysis program _p_r_o_f(1).




Version 1.37.1        Last change: 17 Dec 1990                   8






GCC(1)                   USER COMMANDS                     GCC(1)



     -pg  Generate extra code to write profile information  suit-
          able for the analysis program _g_p_r_o_f(1).

     -a   Generate extra code to write  profile  information  for
          basic   blocks,   suitable  for  the  analysis  program
          _t_c_o_v(1).  Eventually GNU _g_p_r_o_f(1) should be extended to
          process this data.

     -l_l_i_b_r_a_r_y
          Search a standard list of  directories  for  a  library
          named   _l_i_b_r_a_r_y,   which   is  actually  a  file  named
          lib_l_i_b_r_a_r_y.a.  The linker uses this file as if  it  had
          been specified precisely by name.

          The directories searched include several standard  sys-
          tem directories plus any that you specify with -L.

          Normally the files found this way are  library  files--
          archive  files  whose  members  are  object files.  The
          linker handles an archive file by scanning  through  it
          for  members which define symbols that have so far been
          referenced but not defined.  But if the  file  that  is
          found  is  an ordinary object file, it is linked in the
          usual fashion.  The only difference between using an -l
          option  and  specifying a file name is that -l searches
          several directories.

     -L_d_i_r
          Add directory _d_i_r to the  list  of  directories  to  be
          searched for -l.

     -nostdlib
          Don't use the standard  system  libraries  and  startup
          files  when  linking.  Only the files you specify (plus
          gnulib) will be passed to the linker.

     -m_m_a_c_h_i_n_e_s_p_e_c
          Machine-dependent option specifying something about the
          type  of  target machine.  These options are defined by
          the macro TARGET_SWITCHES in the  machine  description.
          The  default  for  the  options is also defined by that
          macro, which enables you to change the defaults.

          These are the -m options defined in the  68000  machine
          description:

          -m68020
          -mc68020
               Generate output for a 68020 (rather than a 68000).
               This  is  the  default  if  you use the unmodified
               sources.




Version 1.37.1        Last change: 17 Dec 1990                   9






GCC(1)                   USER COMMANDS                     GCC(1)



          -m68000
          -mc68000
               Generate output for a 68000 (rather than a 68020).

          -m68881
               Generate output containing 68881 instructions  for
               floating  point.   This  is the default if you use
               the unmodified sources.

          -mfpa
               Generate output containing  Sun  FPA  instructions
               for floating point.

          -msoft-float
               Generate  output  containing  library  calls   for
               floating point.

          -mshort
               Consider type int to be 16 bits wide,  like  short
               int.

          -mnobitfield
               Do not use the  bit-field  instructions.   -m68000
               implies -mnobitfield.

          -mbitfield
               Do  use  the  bit-field   instructions.    -m68020
               implies  -mbitfield.   This  is the default if you
               use the unmodified sources.

          -mrtd
               Use a different  function-calling  convention,  in
               which  functions that take a fixed number of argu-
               ments return with the rtd instruction, which  pops
               their  arguments  while returning.  This saves one
               instruction in the caller since there is  no  need
               to pop the arguments there.

               This calling convention is incompatible  with  the
               one normally used on Unix, so you cannot use it if
               you need to call libraries compiled with the  Unix
               compiler.

               Also, you must provide function prototypes for all
               functions  that take variable numbers of arguments
               (including printf(3S)); otherwise  incorrect  code
               will be generated for calls to those functions.

               In addition, seriously incorrect code will  result
               if  you  call  a function with too many arguments.
               (Normally,   extra   arguments   are    harmlessly
               ignored.)



Version 1.37.1        Last change: 17 Dec 1990                  10






GCC(1)                   USER COMMANDS                     GCC(1)



               The rtd instruction is supported by the 68010  and
               68020 processors, but not by the 68000.

          These  -m  options  are  defined  in  the  Vax  machine
          description:

          -munix
               Do not output certain  jump  instructions  (aobleq
               and  so  on)  that  the Unix assembler for the Vax
               cannot handle across long ranges.

          -mgnu
               Do output those jump instructions, on the  assump-
               tion  that  you  will assemble with the GNU assem-
               bler.

          -mg
               Output code for g-format  floating  point  numbers
               instead of d-format.

          These -m switches are supported on the Sparc:

          -mfpu
               Generate output containing floating point instruc-
               tions.  This is the default if you use the unmodi-
               fied sources.

          -msoft-float
               Generate  output  containing  library  calls   for
               floating point.

          -mno-epilogue
               Generate separate return instructions  for  return
               statements.   This  has both advantages and disad-
               vantages; I don't recall what they are.

          These -m options are  defined  in  the  Convex  machine
          description:

          -mc1
               Generate output for a C1.   This  is  the  default
               when the compiler is configured for a C1.

          -mc2
               Generate output for a C2.   This  is  the  default
               when the compiler is configured for a C2.

          -margcount
               Generate code which puts an argument count in  the
               word  preceding each argument list.  Some nonport-
               able Convex  and  Vax  programs  need  this  word.
               (Debuggers  don't;  this  info  is  in  the symbol



Version 1.37.1        Last change: 17 Dec 1990                  11






GCC(1)                   USER COMMANDS                     GCC(1)



               table.)

          -mnoargcount
               Omit the argument count word.  This is the default
               if you use the unmodified sources.

     -f_f_l_a_g
          Specify machine-independent  flags.   Most  flags  have
          both  positive and negative forms; the negative form of
          -ffoo would be -fno-foo.  In the table below, only  one
          of  the  forms  is  listed--the  one  which  is not the
          default.  You can figure out the other form  by  either
          removing no- or adding it.

     -fpcc-struct-return
          Use the same convention for returning struct and  union
          values  that  is  used  by the usual C compiler on your
          system.  This convention is less  efficient  for  small
          structures,  and  on many machines it fails to be reen-
          trant; but it has the advantage of allowing intercalla-
          bility between GCC-compiled code and PCC-compiled code.

     -ffloat-store
          Do not store  floating-point  variables  in  registers.
          This  prevents undesirable excess precision on machines
          such as the 68000 where the floating registers (of  the
          68881) keep more precision than a double is supposed to
          have.

          For most programs, the excess precision does only good,
          but  a  few  programs rely on the precise definition of
          IEEE floating point.  Use -ffloat-store for  such  pro-
          grams.

     -fno-asm
          Do not recognize asm, inline or typeof  as  a  keyword.
          These  words  may then be used as identifiers.  You can
          use __asm__, __inline__ and __typeof__ instead.

     -fno-defer-pop
          Always pop the arguments to each function call as  soon
          as  that function returns.  Normally the compiler (when
          optimizing) lets arguments accumulate on the stack  for
          several function calls and pops them all at once.

     -fstrength-reduce
          Perform the optimizations of  loop  strength  reduction
          and elimination of iteration variables.

     -fcombine-regs
          Allow the combine pass to combine an  instruction  that
          copies  one register into another.  This might or might



Version 1.37.1        Last change: 17 Dec 1990                  12






GCC(1)                   USER COMMANDS                     GCC(1)



          not produce better code when used in addition to -O.  I
          am  interested  in  hearing  about  the difference this
          makes.

     -fforce-mem
          Force memory  operands  to  be  copied  into  registers
          before  doing  arithmetic  on  them.   This may produce
          better code by making all memory  references  potential
          common subexpressions.  When they are not common subex-
          pressions, instruction combination should eliminate the
          separate  register-load.   I  am  interested in hearing
          about the difference this makes.

     -fforce-addr
          Force memory address constants to be copied into regis-
          ters before doing arithmetic on them.  This may produce
          better code just as -fforce-mem may.  I  am  interested
          in hearing about the difference this makes.

     -fomit-frame-pointer
          Don't keep the frame pointer in a  register  for  func-
          tions  that  don't  need one.  This avoids the instruc-
          tions to save, set up and restore  frame  pointers;  it
          also  makes  an  extra register available in many func-
          tions.  It also makes debugging impossible.

          On some machines, such as the Vax,  this  flag  has  no
          effect, because the standard calling sequence automati-
          cally handles the frame pointer and nothing is saved by
          pretending  it  doesn't exist.  The machine-description
          macro FRAME_POINTER_REQUIRED controls whether a  target
          machine supports this flag.

     -finline-functions
          Integrate all simple functions into their callers.  The
          compiler heuristically decides which functions are sim-
          ple enough to be worth integrating in this way.

          If all calls to a given function  are  integrated,  and
          the  function  is declared static, then the function is
          normally not output as assembler code in its own right.

     -fcaller-saves
          Enable values to be allocated in registers that will be
          clobbered by function calls, by emitting extra instruc-
          tions to save and restore  the  registers  around  such
          calls.   Such  allocation is done only when it seems to
          result in better code than would otherwise be produced.

          This option is enabled by default on certain  machines,
          usually those which have no call-preserved registers to
          use instead.



Version 1.37.1        Last change: 17 Dec 1990                  13






GCC(1)                   USER COMMANDS                     GCC(1)



     -fkeep-inline-functions
          Even if all calls to a given function  are  integrated,
          and  the function is declared static, nevertheless out-
          put a separate run-time callable version of  the  func-
          tion.

     -fwritable-strings
          Store string constants in the writable data segment and
          don't  uniquize  them.   This is for compatibility with
          old programs which assume they can  write  into  string
          constants.  Writing into string constants is a very bad
          idea; constants should be constant.

     -fcond-mismatch
          Allow conditional expressions with mismatched types  in
          the  second  and third arguments.  The value of such an
          expression is void.

     -fno-function-cse
          Do not put function addresses in registers;  make  each
          instruction  that calls a constant function contain the
          function's address explicitly.

          This option results in less efficient  code,  but  some
          strange  hacks  that  alter the assembler output may be
          confused  by  the  optimizations  performed  when  this
          option is not used.

     -fvolatile
          Consider all memory references through pointers  to  be
          volatile.

     -fshared-data
          Requests that the data and non-const variables of  this
          compilation  be  shared  data rather than private data.
          The distinction makes sense only on  certain  operating
          systems,  where shared data is shared between processes
          running the same program, while private data exists  in
          one copy per process.

     -funsigned-char
          Let the type char be the unsigned, like unsigned char.

          Each kind of machine has a default for what char should
          be.  It is either like unsigned char by default or like
          signed char by default.   (Actually,  at  present,  the
          default is always signed.)

          The type char is always a  distinct  type  from  either
          signed  char or unsigned char, even though its behavior
          is always just like one of those two.




Version 1.37.1        Last change: 17 Dec 1990                  14






GCC(1)                   USER COMMANDS                     GCC(1)



          Note that this is equivalent to -fno-signed-char, which
          is the negative form of -fsigned-char.

     -fsigned-char
          Let the type char be signed, like signed char.

          Note that this  is  equivalent  to  -fno-unsigned-char,
          which is the negative form of -funsigned-char.

     -fdelayed-branch
          If supported for the target machine, attempt to reorder
          instructions  to  exploit  instruction  slots available
          after delayed branch instructions.

     -ffixed-_r_e_g
          Treat the register named _r_e_g as a fixed register;  gen-
          erated code should never refer to it (except perhaps as
          a stack pointer, frame pointer or in some  other  fixed
          role).

          _r_e_g must be the name of a register.  The register names
          accepted  are  machine-specific  and are defined in the
          REGISTER_NAMES macro in the machine  description  macro
          file.

          This flag does not have a  negative  form,  because  it
          specifies a three-way choice.

     -fcall-used-_r_e_g
          Treat the register named _r_e_g as an allocatable register
          that  is  clobbered by function calls.  It may be allo-
          cated for temporaries or variables  that  do  not  live
          across  a  call.   Functions compiled this way will not
          save and restore the register REG.

          Use of this flag for a register that has a  fixed  per-
          vasive  role  in the machine's execution model, such as
          the stack pointer or frame pointer, will produce disas-
          trous results.

          This flag does not have a  negative  form,  because  it
          specifies a three-way choice.

     -fcall-saved-_r_e_g
          Treat the register named _r_e_g as an allocatable register
          saved  by functions.  It may be allocated even for tem-
          poraries or variables that live across a  call.   Func-
          tions  compiled  this  way  will  save  and restore the
          register _r_e_g if they use it.

          Use of this flag for a register that has a  fixed  per-
          vasive  role  in the machine's execution model, such as



Version 1.37.1        Last change: 17 Dec 1990                  15






GCC(1)                   USER COMMANDS                     GCC(1)



          the stack pointer or frame pointer, will produce disas-
          trous results.

          A different sort of disaster will result from  the  use
          of  this  flag  for a register in which function values
          may be returned.

          This flag does not have a  negative  form,  because  it
          specifies a three-way choice.

     -d_l_e_t_t_e_r_s
          Says to make debugging  dumps  at  times  specified  by
          _l_e_t_t_e_r_s.  Here are the possible letters:

          r
               Dump after RTL generation.
          j
               Dump after first jump optimization.
          J
               Dump after last jump optimization.
          s
               Dump after CSE (including  the  jump  optimization
               that sometimes follows CSE).
          L
               Dump after loop optimization.
          f
               Dump after flow analysis.
          c
               Dump after instruction combination.
          l
               Dump after local register allocation.
          g
               Dump after global register allocation.
          d
               Dump after delayed branch scheduling.
          m
               Print statistics on memory usage, at  the  end  of
               the run.

     -pedantic
          Issue all the warnings demanded by strict ANSI standard
          C; reject all programs that use forbidden extensions.

          Valid ANSI standard C programs should compile  properly
          with  or  without  this  option (though a rare few will
          require -ansi).  However, without this option,  certain
          GNU extensions and traditional C features are supported
          as well.  With this option, they are  rejected.   There
          is  no  reason  to  use  this option; it exists only to
          satisfy pedants.

          -pedantic does not cause warning messages  for  use  of



Version 1.37.1        Last change: 17 Dec 1990                  16






GCC(1)                   USER COMMANDS                     GCC(1)



          the  alternate  keywords whose names begin and end with
          __.

     -static
          On Suns running version 4, this prevents  linking  with
          the  shared libraries.  (-g has the same effect.) These
          options control the C preprocessor,  which  is  run  on
          each  C  source file before actual compilation.  If you
          use the `-E' option, nothing is done except  C  prepro-
          cessing.    Some  of  these  options  make  sense  only
          together with `-E' because  they  request  preprocessor
          output that is not suitable for actual compilation.

     -C   Tell the preprocessor not to  discard  comments.   Used
          with the -E option.

     -I_d_i_r
          Search directory _d_i_r for include files.

     -I-  Any directories specified with -I  options  before  the
          -I-  option  are searched only for the case of #include
          "_f_i_l_e"; they are not searched for #include <_f_i_l_e>.

          If additional directories are specified with -I options
          after  the  -I-, these directories are searched for all
          #include directives.  (Ordinarily  _a_l_l  -I  directories
          are used this way.)

          In addition, the -I- option inhibits  the  use  of  the
          current  directory  as  the  first search directory for
          #include "_f_i_l_e".  Therefore, the current  directory  is
          searched  only  if it is requested explicitly with -I..
          Specifying both -I- and -I. allows you to control  pre-
          cisely   which  directories  are  searched  before  the
          current one and which are searched after.

     -nostdinc
          Do not  search  the  standard  system  directories  for
          header  files.  Only the directories you have specified
          with  -I  options  (and  the  current   directory,   if
          appropriate) are searched.

          Between -nostdinc and -I-, you can eliminate all direc-
          tories from the search path except those you specify.

     -M   Tell the preprocessor to output  a  rule  suitable  for
          make(_1)  describing  the  dependencies  of  each source
          file.  For each source file, the  preprocessor  outputs
          one  make-rule whose target is the object file name for
          that source file and whose  dependencies  are  all  the
          files  #included in it.  This rule may be a single line
          or may be continued with \-newline if it is long.



Version 1.37.1        Last change: 17 Dec 1990                  17






GCC(1)                   USER COMMANDS                     GCC(1)



          -M implies -E.

     -MM  Like -M but the output mentions  only  the  user-header
          files  included  with  #include  "_f_i_l_e".  System header
          files included with #include <_f_i_l_e> are omitted.

          -MM implies -E.

     -D_m_a_c_r_o
          Define macro _m_a_c_r_o with the empty string as its defini-
          tion.

     -D_m_a_c_r_o=_d_e_f_n
          Define macro _m_a_c_r_o as _d_e_f_n.

     -U_m_a_c_r_o
          Undefine macro _m_a_c_r_o.

     -trigraphs
          Support ANSI C trigraphs.  You don't want to know about
          this  brain-damage.   The  -ansi  option  also has this
          effect.

FILES
     file.c             C source file
     file.s             assembly language file
     file.o             object file
     a.out              link edited output
     /tmp/cc*           temporary files
     _L_I_B_D_I_R/gcc-cpp     preprocessor
     _L_I_B_D_I_R/gcc-cc1     compiler
     _L_I_B_D_I_R/gcc-gnulib  library needed by GCC on some machines
     /lib/crt[01n].o    start-up routine
     /lib/libc.a        standard C library, see _i_n_t_r_o(3)
     /usr/include       standard directory for #include files
     _L_I_B_D_I_R/gcc-include standard gcc directory for #include files

     _L_I_B_D_I_R is usually /usr/local/lib.

SEE ALSO
     as(1), ld(1), adb(1), dbx(1), sdb(1).

BUGS
     Bugs should be reported  to  bug-gcc@prep.ai.mit.edu.   Bugs
     tend  actually to be fixed if they can be isolated, so it is
     in your interest to report them in such a way that they  can
     be easily reproduced.

COPYING
     Copyright (c) 1988 Free Software Foundation,  Inc.   Permis-
     sion  is  granted  to make and distribute verbatim copies of
     this  manual  provided  the  copyright   notice   and   this



Version 1.37.1        Last change: 17 Dec 1990                  18






GCC(1)                   USER COMMANDS                     GCC(1)



     permission  notice  are preserved on all copies.  Permission
     is granted to copy and distribute modified versions of  this
     manual  under  the conditions for verbatim copying, provided
     that the entire resulting derived work is distributed  under
     the  terms  of  a  permission  notice identical to this one.
     Permission is granted to copy and distribute translations of
     this  manual  into  another language, under the above condi-
     tions for modified versions,  except  that  this  permission
     notice  may be included in translations approved by the Free
     Software Foundation instead of in the original English.

AUTHORS
     See the GNU CC Manual for the contributors to GNU CC.










































Version 1.37.1        Last change: 17 Dec 1990                  19




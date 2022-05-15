shoop()
{
  printf("this is a test\n"); 
}

struct my {
  int jj;
  int kk;
}; 

struct myst2 {
  int ll;
  int mm;
};

static struct my * myp; 

long * myl; 

static int yoop; 

foop(int x)
{
  printf("this is foop: %d\n", x);
  printf("this is long foo - value %d\n", x);
}

myprint(int x, int y)
{
  printf("this is kk: %d\n", x);
  foop(x);
  printf("this is mm: %d\n", y);
}


struct myst3 {
  int aa;
  int bb;
} myst3S;
/*  myst3S; */ 
/* hold off on this for a second */


main()
{ 
  struct my    myst; 
  struct myst2 myst2S;
/*  struct myst3 myst3S;  */

  int ii = 3;

  myst3S.aa = 2001;
  myst3S.bb = 2002;

  myst.jj = 3;
  myst.kk = 4;
  myst2S.ll = 5;
  myst2S.mm = 6;

  printf("this is jj: %d\n", myst.jj);
  printf("this is mm: %d\n", myst2S.ll);
  printf("hello, world \n ");
  myprint(myst.kk, myst2S.mm);
  printf("the value is %d\n", ii);
  foop(ii);
  printf("goodbye, world \n"); 
}




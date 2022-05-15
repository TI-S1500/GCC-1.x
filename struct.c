union u1 {
	struct {
		short s1;
		int i1; } s1;
	struct {
		short s1;
		int i1; } s2;
} u1;

struct {
	short  i1;
	union u1 u1;
	int  i3;
} s4; 

main(argc,argv)
int argc;
char **argv;
{
	printf("loc u1 = 0x%x\n",&u1);
	s4.i1 = 7;
	s4.i3 = 5;
	s4.u1.s1.s1 = 5;
	u1.s1.s1 =1;
	u1.s2.s1 =1;
}

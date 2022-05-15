struct {
	unsigned char f1:8;
	unsigned char f2:8;
	unsigned short f3:16 ;
	char c3;
} mystruct2 = { 1,2,3,'b'};

struct {
	char c1;
	unsigned char f1:8;
	unsigned char f2:8;
	unsigned short f3:16 ;
	char c3;
} mystruct3 = { 'a',1,2,3,'b'};

struct {
	char c1;
	unsigned char f2:8;
	unsigned short f3:16 ;
	char c3;
} mystruct4 = { 'a',2,3,'b'};

struct {
	short c1;
	unsigned int f2:8;
	unsigned int f3:16 ;
	char c3;
} mystruct5 = { 4,2,3,'b'};

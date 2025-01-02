C/C++ type	      Size 	                FreeBASIC type
------------------------------------------------------
char	            1	                    Byte
short [int]	      2	                    Short
int	              4	                    Long
enum (int)	      4	                    Long
long long [int]	  8	                    LongInt
float	            4	                    Single
double	          8	                    Double
long double	      12-32bit, 16-64bit	  CLongDouble from crt/longdouble.bi
_Bool/bool	      1	                    Byte / Boolean
* (pointer)	      4-32bit, 8-64bit	    Ptr/Pointer
ssize_t, intptr_t	4-32bit, 8-64bit	    Integer
size_t, uintptr_t	4-32bit, 8-64bit	    UInteger
long [int]	      4-32bit /Win64, 
                  8-64bit Linux/BSD	    CLong from crt/long.bi


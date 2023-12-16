/* 
   This C code implements a 32-bit adder.
   Author: Gijeong Lee
*/

#include "sim1.h"

void execute_add(Sim1Data *obj)
{
	// TODO: implement me!

	int a = obj -> a; // set a to a object
	int b = obj -> b; // set b to b object

	int aBit = 0;
	int bBit = 0;

	int xorA = 0;
	int xorB = 0;

	int i =1;
	int sum = 0;
	int carry =0;

	int andA = 0;
	int andB = 0;

	int or = 0;

	int xoroverflowA = 0;
	int xoroverflowB = 0;
	int notOverflow = 0;
	
	if(b&(1 << 31))
	{ // finding and getting the last bit
		obj -> bNonNeg = 0; // if it is false i will be 0
	
	}
	
	else
	{
		obj -> bNonNeg = 1; // set bNonNeg to true 
	}

	if(obj -> isSubtraction)
	{
		b = b *-1;
	}
	
	aBit = 1 & a;
	bBit = 1 & b;

	if(aBit !=bBit)
	{
		sum = 1;
	}

	if (aBit && bBit)
	{
		carry = 1;
	}

	while(i<32)
	{
		aBit = (1 << i) & a;
		bBit = (1 << i) & b;

		xorA = aBit != bBit; 
		andA = aBit && bBit;

		if(carry != (xorA>0))
		{
			xorB = 1;
		}

		else
		{
			xorB = 0;
		}

		if(xorB)
		{
			sum |= (1<<i);
		}


		andB = carry && xorA;

		if(andA || andB)
		{
			carry = 1;
		}
		else
		{
			carry = 0;
		}

		i++;
	}

	if(carry)
	{
		obj->carryOut = 1;
	
	}

	else
	{
		obj->carryOut = 0;

	}

	obj->sum = sum;

	aBit = (1<<31)&a;
	bBit = (1<<31)&b;
	

	if(aBit)
	{
		obj->aNonNeg = 0;
	
	}

	else{
		obj->aNonNeg = 1;

	}
	
	if((1<<31)&sum)
	{
		obj->sumNonNeg =0;
	}

	else
	{

		obj->sumNonNeg =1;

	}

	xoroverflowA = aBit != bBit;
	notOverflow = !xoroverflowA;

	if(notOverflow)
	{
		xoroverflowB = aBit != (1 << 31) &sum;
		obj->overflow = xoroverflowB;
	}

	else
	{
		obj->overflow = 0;

	}
}

/*
 * Author: GijeongLee
 * 
 */



//include "sim1.h"


public class Sim1_ADD
{
	public void execute()
	{
		
		xorA[0].a.set(a[0].get());
		xorA[0].b.set(b[0].get());
		xorA[0].execute();
		sum[0].set(xorA[0].out.get());
		and1[0].a.set(a[0].get());
		and1[0].b.set(b[0].get());
		and1[0].execute();
		carryIn[0].set(and1[0].out.get());

		int i=1;
		
		while(i < 32){
			xorA[i].a.set(a[i].get());
			xorA[i].b.set(b[i].get());
			xorA[i].execute();

			and1[i].a.set(a[i].get());
			and1[i].b.set(b[i].get());
			and1[i].execute();

			xorB[i].a.set(carryIn[i-1].get());
			xorB[i].b.set(xorA[i].out.get());
			xorB[i].execute();

			sum[i].set(xorB[i].out.get());

			and2[i].a.set(carryIn[i-1].get());
			and2[i].b.set(xorA[i].out.get());
			and2[i].execute();

			or[i].a.set(and2[i].out.get());
			or[i].b.set(and1[i].out.get());
			or[i].execute();

			carryIn[i].set(or[i].out.get());

			i++;
		}
		
		carryOut.set(carryIn[31].get());

		
		overflowxorA.a.set(a[31].get());
		overflowxorA.b.set(b[31].get());
		overflowxorA.execute();
		overflowNot.in.set(overflowxorA.out.get());
		overflowNot.execute();
		

		if(overflowNot.out.get()){
			overflowxorB.a.set(a[31].get());
			overflowxorB.b.set(sum[31].get());
			overflowxorB.execute();
			overflow.set(overflowxorB.out.get());
		}
		else{
			overflow.set(false);
		}

	}



	// ------ 
	// It should not be necessary to change anything below this line,
	// although I'm not making a formal requirement that you cannot.
	// ------ 

	// inputs
	public RussWire[] a,b;

	// outputs
	public RussWire[] sum;
	
	public RussWire[]  carryIn;  
	public RussWire overflow, carryOut;
	public Sim1_XOR [] xorA, xorB; 
	public Sim1_AND [] and1,and2; 
	public Sim1_OR [] or; 
	public Sim1_XOR overflowxorA, overflowxorB; 
	public Sim1_NOT overflowNot; 



	public Sim1_ADD() 
	{
		/* Instructor's Note:
		 *
		 * In Java, to allocate an array of objects, you need two
		 * steps: you first allocate the array (which is full of null
		 * references), and then a loop which allocates a whole bunch
		 * of individual objects (one at a time), and stores those
		 * objects into the slots of the array.
		 */

		a   = new RussWire[32];
		b   = new RussWire[32];
		sum = new RussWire[32];
		carryIn = new RussWire[32];
		xorA = new Sim1_XOR[32];
		xorB = new Sim1_XOR[32];
		and1 = new Sim1_AND[32];
		and2 = new Sim1_AND[32];
		or = new Sim1_OR[32];

		for (int i=0; i < 32; i++)
		{
			a[i] = new RussWire();
			b[i] = new RussWire();

			sum[i] = new RussWire();
			carryIn[i] = new RussWire();

			xorA[i] = new Sim1_XOR();
			xorB[i] = new Sim1_XOR();

			and1[i] = new Sim1_AND();
			and2[i] = new Sim1_AND();

			or[i] = new Sim1_OR();
		}
		overflow = new RussWire();
		carryOut = new RussWire();
		overflowxorA = new Sim1_XOR();
		overflowxorB = new Sim1_XOR();
		overflowNot = new Sim1_NOT();
	}
}


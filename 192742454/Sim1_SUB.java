/* 
   Simulates a physical device that performs (signed) subtraction on
   a 32-bit input.
	
   Author: Gijeong Lee
*/

public class Sim1_SUB
{
	public void execute()
	{
		// TODO: fill this in!
		//
		// REMEMBER: You may call execute() on sub-objects here, and
		//           copy values around - but you MUST NOT create
		//           objects while inside this function.

		int i = 0;

		while(i < 32){
			Sim_2complement.in[i].set(b[i].get()); 
			adder.a[i].set(a[i].get()); 
			i++;
		}

		Sim_2complement.execute();
		int j =0;
		while(j < 32){
			adder.b[j].set(Sim_2complement.out[j].get());
			j++;
		}
		adder.execute(); 

		int k= 0;

		while(k<32){
			sum[k].set(adder.sum[k].get()); 
			k++;
		}


	}

	// --------------------
	// Don't change the following standard variables...
	// --------------------

	// inputs
	public RussWire[] russA,russW;

	// output
	public RussWire[] sum;
	public Sim1_2sComplement Sim_2complement; // my 2scomplement object
	public Sim1_ADD adder; // my adder object.

	// --------------------
	// But you should add some *MORE* variables here.
	// --------------------
	// TODO: fill this in

	public Sim1_SUB()
	{
		russA = new RussWire [32];
		russW = new RussWire [32];

		sum = new RussWire [32];
		adder = new Sim1_ADD();
		Sim_2complement = new Sim1_2sComplement();
		
		for (int i=0; i<32; i++)
		{
			russA[i] = new RussWire();
			russW[i] = new RussWire();
			sum[i] = new RussWire();
		}
	}
}


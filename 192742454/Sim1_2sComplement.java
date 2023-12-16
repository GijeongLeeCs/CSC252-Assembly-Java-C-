/* Simulates a physical device that performs 2's complement on a 32-bit input.
 *
 * Author: Gijeong Lee
 */


/*
* This Java class simply calculates the 2’s complement of a 32-bit input.
*/

public class Sim1_2sComplement
{
	public void execute()
	{
		// TODO: fill this in!
		//
		// REMEMBER: You may call execute() on sub-objects here, and
		//           copy values around - but you MUST NOT create
		//         objects while inside this function.

		int i = 0;
		int j =1;

		add.b[0].set(true); //

		while(j < 32){
			add.b[j].set(false);
			j++;
		}
		while(i < 32){
			negate[i].in.set(in[i].get()); 
			negate[i].execute(); 
			add.a[i].set(negate[i].out.get()); 
			i++;
		}
		add.execute(); 
		int k = 0;
		while(k < 32){
			out[k].set(add.sum[k].get()); 
			k++;
		}
	}

	
	public RussWire[] in;
	public RussWire[] out;
	public Sim1_NOT [] negate; 
	public Sim1_ADD add; 

	// TODO: add some more variables here.  You must create them
	//       during the constructor below.  REMEMBER: You're not
	//       allowed to create any object inside the execute()
	//       method above!


	public Sim1_2sComplement()
	{
		// TODO: this is where you create the objects that
		//       you declared up above.

		in = new RussWire [32];
		out = new RussWire [32];
		negate = new Sim1_NOT [32];
		add = new Sim1_ADD();


		for (int l = 0; l < 32; l++)
		{
			in[l] = new RussWire();
			out[l] = new RussWire();
			negate[l] = new Sim1_NOT();

		}
	}
}


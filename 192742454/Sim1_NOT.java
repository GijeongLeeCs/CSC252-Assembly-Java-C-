/* Simulates a physical NOT gate.
 *
 * Author: Gijeong Lee
 */

public class Sim1_NOT
{
	public void execute()
	{
		out.set(in.get() != true); 
	}

	public RussWire in;    
	public RussWire out;   

	public Sim1_NOT()
	{
		// TODO: fill this in!
		in = new RussWire();
		out = new RussWire();
	}
}



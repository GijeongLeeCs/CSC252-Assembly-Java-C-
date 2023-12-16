/* Simulates a physical AND gate.
 *
 * Author: Gijeong Lee
 */

public class Sim1_AND
{
	public void execute()
	{
		// TODO: fill this in!\
		out.set(a.get() && b.get()); 
	}

	public RussWire a,b;   
	public RussWire out;   

	public Sim1_AND()
	{
		// TODO: fill this in!
		a = new RussWire();
		b = new RussWire();
		out = new RussWire();
	}
}


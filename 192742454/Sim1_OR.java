/* Simulates a physical OR gate.
 *
 * Author: Gijeong Lee
 */

public class Sim1_OR
{
	public void execute()
	{
		out.set(a.get() || b.get()); 
	}

	public RussWire a,b;  
	public RussWire out;   

	public Sim1_OR()
	{
		a = new RussWire();
		b = new RussWire();
		out = new RussWire();
		
	}
}


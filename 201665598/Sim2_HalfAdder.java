

/*
 * 
 * Gijeong Lee
 * This is a Half Adder
 * It has two outputs, RussWire objects named sum and carry.
 */
public class Sim2_HalfAdder {
	public RussWire a,b; // inputs
	public RussWire sum, carry; // outputs
	public XOR xor; //xor Gate
    public AND and; // and Gate

    /*
     * This is a constructor for this class
     * It assigns all the instance variables
     */
	public Sim2_HalfAdder()
	{
		a = new RussWire();
		b = new RussWire();
		sum = new RussWire();
		carry = new RussWire();
		xor = new XOR();
        and = new AND();
	}
	
	/*
	 * It actually executes based on instance variables and their methods.
	 */
	public void execute()
	{
        xor.a.set(a.get()); //getting inputs for xor Gate.
        xor.b.set(b.get()); //getting inputs for xor Gate.
        xor.execute(); // //getting output of xor Gate.
        sum.set(xor.out.get()); // setting the output sum 
        and.a.set(a.get());// getting the input for and Gate
        and.b.set(b.get());// getting the input for and Gate
        and.execute(); // getting the output of and Gate
        carry.set(and.out.get()); // setting carryOut
	}
	
	
	
	
}
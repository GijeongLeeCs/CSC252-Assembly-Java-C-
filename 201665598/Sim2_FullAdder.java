

/*
 * 
 * Author : Gijeong Lee
 * This class is for fullAdder. 
 * It implements the full adder by linking two half adders
 */

public class Sim2_FullAdder{
    Sim2_HalfAdder firstHalf; 
    Sim2_HalfAdder secondHalf; 
    RussWire a,b; // inputs
    RussWire carryIn; 
    RussWire sum; // output
    RussWire carryOut; 
    OR or; // orGate


    /*
     * 
     * This is a constructor.
     * It assigns all the instance variables.
     */
    public Sim2_FullAdder(){
        firstHalf = new Sim2_HalfAdder();
        secondHalf = new Sim2_HalfAdder();
        a = new RussWire();
        b = new RussWire();
        sum = new RussWire();
        carryIn = new RussWire();
        carryOut = new RussWire();
        or = new OR();
    }

    /*
     * It executes for full adder based on instance variables and their methods
     */
    public void execute()
	{
        firstHalf.a.set(a.get()); //setting for first half adder
        firstHalf.b.set(b.get());//setting for first half adder
        firstHalf.execute(); // getting the outuput from half adder
        secondHalf.a.set(carryIn.get()); // setting the inouts for another half adder
        secondHalf.b.set(firstHalf.sum.get());
        secondHalf.execute(); // getting the output from the another half adder
        sum.set(secondHalf.sum.get()); // setting the output sum
        or.a.set(firstHalf.carry.get()); // setting the inouts for the orGate
        or.b.set(secondHalf.carry.get()); // setting the inouts for the orGate
        or.execute(); // getting the output for the orGate
        carryOut.set(or.out.get()); // setting the carryOut
    }
}


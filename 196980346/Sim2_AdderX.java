	
/*
 * Author : Gijeong Lee 
 * This class implements a multi-bit adder by linking together many full adders
 * This class contains pretty much all objects of and,not,or,russwire,
 * fulladder,halfadderm and xor.
 */

public class  Sim2_AdderX{
    int num;
    RussWire[] a,b; //inputs
    RussWire[] sum; // output sum
    RussWire carryOut; 
    RussWire overflow;
    XOR xorA; //xorGate
    XOR xorB; //xorGate
    NOT not; //notGate
    AND and; //andGate
    Sim2_FullAdder[] fullAdder; //Array containing Sim2_FullAdder objects.
    
    /*
     * This is a constructor of this class.
     * @param i which is an integer and number of bits in the adder.
     * It assigns all the instance variables based on i.
     */
    public Sim2_AdderX(int i)
    {
        a = new RussWire[i];
        b= new RussWire[i];
        sum = new RussWire[i];
        fullAdder = new Sim2_FullAdder[i];

        carryOut = new RussWire();
        overflow = new RussWire();
        xorA = new XOR();
        xorB = new XOR();
        not = new NOT();
        and = new AND();

        num = i;
        int k = 0;
        
        while(k<i)
        {
            fullAdder[k] = new Sim2_FullAdder();
            a[k] = new RussWire();
            b[k] = new RussWire();
            sum[k] = new RussWire();
            k++;

        }


    }
    /*
     * This function actually does everything for the actual
     * multi-bit adder by using all instance variables and their methods
     * based on a number of bits in the adder.
     */
    public void execute(){
        fullAdder[0].a.set(a[0].get());
        fullAdder[0].b.set(b[0].get());
        fullAdder[0].carryIn.set(false);
        fullAdder[0].execute();
        sum[0].set(fullAdder[0].sum.get());

        int i = 1;
        while(i<num){
            fullAdder[i].a.set(a[i].get()); // This is for the full adder.
            fullAdder[i].b.set(b[i].get());
            fullAdder[i].carryIn.set(fullAdder[i-1].carryOut.get()); //carryin 
            fullAdder[i].execute(); //its output
            sum[i].set(fullAdder[i].sum.get()); // setting the sum
            i++;
        }

        carryOut.set(fullAdder[num-1].carryOut.get()); //getting carryOut
        xorA.a.set(a[num-1].get()); // from here calculating overflow
        xorA.b.set(b[num-1].get());
        xorA.execute();
        not.in.set(xorA.out.get());
        not.execute();

        xorB.a.set(a[num-1].get());
        xorB.b.set(b[num-1].get());
        xorB.execute();

        and.a.set(not.out.get());
        and.b.set(xorB.out.get());
        and.execute();

        overflow.set(and.out.get());
    }
    

}   

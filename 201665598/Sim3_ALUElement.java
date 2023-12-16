/*
 * Gijeong Lee
 * This class has two methods execute_pass1 and execute_pass 2
 */

public class Sim3_ALUElement {
		RussWire [] aluOp;
	    RussWire bInvert;
	    RussWire a,b;
	    RussWire carryIn;
	    RussWire less;
	    RussWire result;
	    RussWire addResult;
	    RussWire carryOut;
	    AND andGate;
	    OR orGate;
	    NOT notGate;
	    XOR xorGate;
	    XOR xorGate1;
	    Sim2_FullAdder adder;
	    Sim3_MUX_8by1 MUX;
	    
	    /*
	     * Constructor
	     */
	    public Sim3_ALUElement(){
	    	
	    	a = new RussWire();
		    b = new RussWire();
	        aluOp = new RussWire[3];
	        aluOp[0] = new RussWire();
	        aluOp[1] = new RussWire();
	        aluOp[2] = new RussWire();
	        bInvert = new RussWire();
	       
	        carryIn = new RussWire();
	        less = new RussWire();
	        result = new RussWire();
	        addResult = new RussWire();
	        carryOut = new RussWire();
	        adder = new Sim2_FullAdder();
	        
	        andGate = new AND();
	        orGate = new OR();
	        notGate = new NOT();
	        xorGate = new XOR();
	        xorGate1 = new XOR();
	        
	        MUX = new Sim3_MUX_8by1();
	    }
	/*
	 * the first pass through the ALU Element. When this is called, 
	 * all of the inputs to the element will be set except
	 * for less.
	 */
    public void execute_pass1(){
        MUX.control[0].set(aluOp[0].get()); // setting the control bits in the MUX
        MUX.control[1].set(aluOp[1].get()); 
        MUX.control[2].set(aluOp[2].get());

        // if alu0p == 0
        andGate.a.set(a.get()); // getting the result of andGate
        xorGate.a.set(b.get());
        xorGate.b.set(bInvert.get());
        xorGate.execute();
        andGate.b.set(xorGate.out.get());
        andGate.execute();
        MUX.in[0].set(andGate.out.get());

        // if alu0up == 1
        orGate.a.set(a.get()); // getting the result of orGate
        orGate.b.set(xorGate.out.get());
        orGate.execute();
        MUX.in[1].set(orGate.out.get());

        // if alu0up == 2
        adder.a.set(a.get()); // getting the result of adder
        adder.b.set(xorGate.out.get());
        adder.carryIn.set(carryIn.get());
        adder.execute();
        carryOut.set(adder.carryOut.get()); // setting the carryOut
        MUX.in[2].set(adder.sum.get()); // 
        addResult.set(adder.sum.get());

    }   
    /*
     * represents the second pass through each ALU Element.
	 * When this function is called, all of the inputs will be valid (including less),
	 * and you must generate the result output.
     */
    public void execute_pass2(){
        // if alu0up == 3 
        MUX.in[3].set(less.get());
        //if alu0up == 4
        xorGate1.a.set(a.get());
        xorGate1.b.set(b.get());
        xorGate1.execute();
        MUX.in[4].set(xorGate1.out.get());
        for (int i = 5; i < 8; i++) { // filling rest with false
            MUX.in[i].set(false);
        }
        MUX.execute();
        result.set(MUX.out.get()); //setting result to the out value of bigger sum 
    }

   
}

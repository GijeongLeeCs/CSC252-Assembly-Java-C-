/*
 * Gijeong Lee
 * 
 * 
 */

public class Sim3_ALU {
    int val;
    RussWire[] aluOp;
    RussWire [] a,b;
    RussWire bNegate;
    Sim3_ALUElement[] Alu1Bit;
    RussWire [] result;

    public Sim3_ALU(int X){
        val = X;
        bNegate = new RussWire();
        aluOp = new RussWire[3];
        a = new RussWire[val];
        b = new RussWire[val];
        result = new RussWire[val];
        Alu1Bit = new Sim3_ALUElement[val];
        
        for (int i = 0; i < X; i++) {
            a[i] = new RussWire(); // set a into russ wire
            b[i] = new RussWire(); // set a into russ wire
            result[i] = new RussWire(); // set a into russ wire
            Alu1Bit[i] = new Sim3_ALUElement(); // set a into russ wire
        }

        for (int i = 0; i < 3; i++) {
            aluOp[i] = new RussWire(); // set a into russ wire
        }
    }
    /*
     * call execute pass1() on them, set up the less
	 * inputs for each element, and then call execute pass2() on each.
     */
	public void execute(){
        Alu1Bit[0].a.set(a[0].get()); // set the index of a
        Alu1Bit[0].b.set(b[0].get()); // set the index of b
        Alu1Bit[0].bInvert.set(bNegate.get()); // set the index of bengate
        Alu1Bit[0].carryIn.set(bNegate.get()); // set the carryin for bNegate
        Alu1Bit[0].aluOp[0].set(aluOp[0].get()); // set the first opreation
        Alu1Bit[0].aluOp[1].set(aluOp[1].get()); // set the second opreation 
        Alu1Bit[0].aluOp[2].set(aluOp[2].get()); // set the third opreation
        Alu1Bit[0].execute_pass1(); // execute_pass1

        for (int i = 1; i < val; i++) {
            Alu1Bit[i].a.set(a[i].get()); // set the rest of the index of a
            Alu1Bit[i].b.set(b[i].get()); // set the rest of the index of b
            Alu1Bit[i].bInvert.set(bNegate.get()); // setting the binvert 
            Alu1Bit[i].carryIn.set(Alu1Bit[i-1].carryOut.get()); // set the carryin
            Alu1Bit[i].aluOp[0].set(aluOp[0].get()); // set the first opreation
            Alu1Bit[i].aluOp[1].set(aluOp[1].get()); // set the second opreation
            Alu1Bit[i].aluOp[2].set(aluOp[2].get()); // set the third opreation
            Alu1Bit[i].execute_pass1(); // execute pass1
    }
        Alu1Bit[0].less.set(Alu1Bit[val - 1].addResult.get());  // less 
        Alu1Bit[0].execute_pass2();  // execute_pass2                              
        result[0].set(Alu1Bit[0].result.get()); // set the element in the result                        

        for (int i = 1; i < val; i++) {
            Alu1Bit[i].less.set(false); // set less false
            Alu1Bit[i].execute_pass2();  // execute_pass2 
            result[i].set(Alu1Bit[i].result.get()); // set rest of the element in the result 
        }
	}

}

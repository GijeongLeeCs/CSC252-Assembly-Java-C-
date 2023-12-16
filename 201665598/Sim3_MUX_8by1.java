/*
 * Gijeong Lee
 * It must have a 3-bit control[] input, and
 * a 8-bit in[] input; both are arrays of RussWire objects. It must have a single
 * RussWire output, which is named out (not an array).
 * This class must have a single execute() method.
 * This class models a 8-input MUX, where each input is a single bit wide. Since
 * it has 8 inputs, there are 3 control bits.
 */

public class Sim3_MUX_8by1 {
	
    RussWire [] control; 
    RussWire [] in; 
    RussWire out;
    public Sim3_MUX_8by1(){

        control = new RussWire[3];
        for(int i = 0; i<3;i++){
            control[i] = new RussWire(); 
        }
        in = new RussWire[8];
        for(int i = 0;i < 8; i++){
            in [i] = new RussWire(); 
        }
        out = new RussWire();
    }
    
	public void execute(){
        boolean bit1 = (!(control[2].get())&&!(control[1].get())&&!(control[0].get())&&(in[0].get())); 
        boolean bit2 = (!(control[2].get())&&!(control[1].get())&&control[0].get()&&in[1].get()); 
        boolean bit3 = (!(control[2].get())&&control[1].get()&&!(control[0].get())&&in[2].get());
        boolean bit4 = (!(control[2].get())&&control[1].get()&&control[0].get()&&in[3].get());
        boolean bit5 = (control[2].get()&&!(control[1].get())&&!(control[0].get())&&(in[4].get())); 
        boolean bit6 = (control[2].get()&&!(control[1].get())&&control[0].get()&&in[5].get()); 
        boolean bit7 = (control[2].get()&&control[1].get()&&!(control[0].get())&&in[6].get()); 
        boolean bit8 = (control[2].get()&&control[1].get()&&control[0].get()&&in[7].get());
        out.set(bit1 || bit2 || bit3 || bit4 || bit5 || bit6 || bit7 || bit8); 
    }
	

}

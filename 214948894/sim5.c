/*
 * Gijeong Lee
 * This is for sim5
 */

#include "sim5.h"
#include <stdio.h>
// Extracting opcode from  last 6 bits of  32-bit instruction
void extract_instructionFields(WORD instruction, InstructionFields *fieldsOut)
{
    // Extracting rs, rt, rd, shamt, funct, imm16, imm32, and address fields from  instruction
    fieldsOut->opcode = 0x3f & (instruction >> 26);
    fieldsOut->rs = 0x1f & (instruction >> 21);                // set rs in  instruction
    fieldsOut->rt = 0x1f & (instruction >> 16);                // set  rt that is 5 bits in  instruction
    fieldsOut->rd = 0x1f & (instruction >> 11);                // set  rd that is 5 bits in  instruction
    fieldsOut->shamt = 0x1f & (instruction >> 6);              // set  shamt that is 5 bits in  instruction
    fieldsOut->imm16 = 0xffff & instruction;                   // set  imm16 that is 16 bits in  instruction
    fieldsOut->funct = 0x3f & instruction;                     // set  func that is 5 bits in  instruction
    fieldsOut->address = 0x3ffffff & instruction;              // set  rt that is 26 bits in  instruction
    fieldsOut->imm32 = signExtend16to32(instruction & 0xffff); // set  rt that is 32 bits in  instruction
}
int IDtoIF_get_stall(InstructionFields *fields, ID_EX *old_idex, EX_MEM *old_exmem)
{
    // Determine the register to be checked based on the regDst value in the previous instruction
    int temp;
    if (old_idex->regDst == 0)
    {
        temp = old_idex->rt;
    }
    else
    {
        temp = old_idex->rd;
    }
    // Check for hazards and stall conditions
    if (old_idex->regWrite && old_idex->memToReg)
    { // if i need to do save to register
        if (fields->rs == temp)
        { // checks if equal
            return 1;
        }
        if (fields->opcode == 0 && (temp == fields->rt))
        { // checks for  rt
            return 1;
        }
    }

    if (old_exmem->regWrite && old_exmem->memToReg)
    { // cehcks for if re is a lw
        if (fields->rs == old_exmem->writeReg)
        { // make sure if my current rs is equal to  old register
            return 1;
        }
        if (fields->opcode == 0 && (old_exmem->writeReg == fields->rt))
        { // this is for  i format  that checks for rt register
            return 1;
        }
    }

    if (fields->opcode == 43 && old_exmem->regWrite)
    { // checks for  opcode for sw
        if (fields->rt == old_exmem->writeReg)
        { // make sure that my current rt is equal to old register
            if (temp != fields->rt || !old_idex->regWrite)
            { // if temp not equal
                return 1;
            }
        }
    }
    return 0;
}
// Function to determine branch control based on opcode
int IDtoIF_get_branchControl(InstructionFields *fields, WORD rsVal, WORD rtVal)
{

    if (fields->opcode == 5)
    { // check for bne opcode
        if (rsVal != rtVal)
        {
            return 1;
        }
    }

    if (fields->opcode == 4)
    { // check for  beq opcode
        if (rsVal == rtVal)
        {
            return 1;
        }
    }

    if (fields->opcode == 2)
    { // check for  opcode jump instruction
        return 2;
    }
    return 0;
}

// Function to calculate branch address
WORD calc_branchAddr(WORD pcPlus4, InstructionFields *fields)
{
    return pcPlus4 + (fields->imm32 << 2); // return  branchadder  current value
}

// Function to calculate jump address
WORD calc_jumpAddr(WORD pcPlus4, InstructionFields *fields)
{
    return (fields->address << 2) | ((pcPlus4 >> 28) << 28); // return  jumpadder current value
}

// Function to execute the ID stage and handle stalls
int execute_ID(int IDstall, InstructionFields *fieldsIn, WORD pcPlus4, WORD rsVal, WORD rtVal, ID_EX *new_idex)
{
    if (IDstall == 1)
    { // if stall happend we set all  fields to zero
        new_idex->memRead = 0;
        new_idex->memToReg = 0;
        new_idex->memWrite = 0;
        new_idex->regWrite = 0;
        new_idex->regDst = 0;
        new_idex->rs = 0;
        new_idex->rd = 0;
        new_idex->rt = 0;
        new_idex->rsVal = 0;
        new_idex->rtVal = 0;
        new_idex->ALU.op = 0;
        new_idex->ALU.bNegate = 0;
        new_idex->ALUsrc = 0;
        return 1;
    }
    // Set the fields based on the opcode and funct values
    new_idex->ALU.op = 0;
    new_idex->ALU.bNegate = 0;
    new_idex->ALUsrc = 0;
    new_idex->imm16 = fieldsIn->imm16;
    new_idex->imm32 = fieldsIn->imm32;
    new_idex->memRead = 0;
    new_idex->memToReg = 0;
    new_idex->memWrite = 0;
    new_idex->rd = fieldsIn->rd;
    new_idex->regDst = 0;
    new_idex->regWrite = 0;
    new_idex->rs = fieldsIn->rs;
    new_idex->rsVal = rsVal;
    new_idex->rt = fieldsIn->rt;
    new_idex->rtVal = rtVal;

    // Handle different instructions and set control signals accordingly
    if (fieldsIn->opcode == 0)
    {

        if (fieldsIn->funct == 0)
        { // set all fields for  nop instruction
            new_idex->ALU.op = 5;
            new_idex->regDst = 1;
            new_idex->regWrite = 1;
            new_idex->rs = 0;
            new_idex->rt = 0;
            new_idex->rd = 0;
            new_idex->rsVal = 0;
            new_idex->imm16 = 0;
            new_idex->imm32 = 0;
            return 1;
        }

        // addu instruction
        if (fieldsIn->funct == 33)
        {
            new_idex->ALU.op = 2; // set  Alu.op to 2 to do  add instruction
            new_idex->regDst = 1;
            new_idex->regWrite = 1;
            new_idex->memRead = 0;
            new_idex->ALU.bNegate = 0;
            new_idex->memWrite = 0;
            new_idex->memToReg = 0;
            return 1;
        }

        // add instruction

        if (fieldsIn->funct == 32)
        {
            new_idex->ALU.op = 2;
            new_idex->regDst = 1;
            new_idex->regWrite = 1;
            return 1;
        }

        // sub instruction
        if (fieldsIn->funct == 34)
        {
            new_idex->ALU.op = 2;
            new_idex->ALU.bNegate = 1;
            new_idex->regDst = 1;
            new_idex->regWrite = 1;
            return 1;
        }

        if (fieldsIn->funct == 39)
        { // set nor instruction fields
            new_idex->ALU.op = 1;
            new_idex->regDst = 1;
            new_idex->regWrite = 1;
            new_idex->extra1 = 1;
            return 1;
        }

        // or instruction
        if (fieldsIn->funct == 37)
        {
            new_idex->ALU.op = 1;   // set  Alu.op to 1 to do  or instruction
            new_idex->regDst = 1;   // set  regdest to 1 to in  controlCpu struct
            new_idex->regWrite = 1; // set  regdest to 1 to in  controlCpu struct
            return 1;
        }

        // and instruction
        if (fieldsIn->funct == 36)
        {
            new_idex->regDst = 1;   // set  regdest to 1 to in  controlCpu struct
            new_idex->regWrite = 1; // set  regwire to 1 to in  controlCpu struct
            return 1;
        }

        // subu instruction
        if (fieldsIn->funct == 35)
        {
            new_idex->ALU.op = 2;      // set  Alu.op to 4 to do  xor instruction
            new_idex->ALU.bNegate = 1; // set  bnegate to 1 in  controlCpu struct
            new_idex->regDst = 1;      // set  regdest to 1 to in  controlCpu struct
            new_idex->regWrite = 1;    // set  regdest to 1 to in  controlCpu struct
            return 1;
        }

        // xor instruction
        if (fieldsIn->funct == 38)
        {
            new_idex->ALU.op = 4;   // set Alu.op to 4 to do  xor instruction
            new_idex->regDst = 1;   // set regdest to 1 to in  controlCpu struct
            new_idex->regWrite = 1; // set regdest to 1 to in  controlCpu struct
            return 1;
        }

        // slt instruction
        if (fieldsIn->funct == 42)
        {
            new_idex->ALU.op = 3;      // set Alu.op to 3 to do  slt instruction
            new_idex->ALU.bNegate = 1; // set bnegate to 1 in  controlCpu struct
            new_idex->regDst = 1;      // set regdest to 1 to in  controlCpu struct
            new_idex->regWrite = 1;    // set regdest to 1 to in  controlCpu struct
            return 1;
        }
        return 0;
    }

    // addiu instruction
    if (fieldsIn->opcode == 9)
    {
        new_idex->ALUsrc = 1;   // set Alu.op to 1 to do  and instruction
        new_idex->ALU.op = 2;   // set Alu.op to 2 to do  add instruction
        new_idex->regWrite = 1; // set regdest to 1 to in  controlCpu struct
        return 1;
    }

    if (fieldsIn->opcode == 13)
    {                           // set ori field instruction
        new_idex->ALUsrc = 2;   //  Alusrc to 2
        new_idex->ALU.op = 1;   //  alu op to 1
        new_idex->regWrite = 1; // we wtiting to register so it's 1
        return 1;
    }

    // slti instruction
    if (fieldsIn->opcode == 10)
    {
        new_idex->ALUsrc = 1;      // set Alu.op to 1 to do  and instruction
        new_idex->ALU.op = 3;      // set Alu.op to 3 to do  or instruction
        new_idex->ALU.bNegate = 1; // set bnegate to 1 in  controlCpu struct
        new_idex->regWrite = 1;    // set regdest to 1 to in  controlCpu struct
        return 1;
    }
    if (fieldsIn->opcode == 15)
    {                           // set fileds for instruction lui
        new_idex->ALUsrc = 2;   // Alusrc to 2
        new_idex->ALU.op = 4;   // alu op to 4
        new_idex->regWrite = 1; // reg write to 1
        new_idex->extra2 = 1;   // extra2 to 1 since i will use it
        return 1;
    }
    // addi instruction
    if (fieldsIn->opcode == 8)
    {
        new_idex->ALUsrc = 1;   // set  ALUsrc to 1 in  controlCpu struct
        new_idex->ALU.op = 2;   // set  Alu.op to 2 to do  add instruction
        new_idex->regWrite = 1; // set  regdest to 1 to in  controlCpu struct
        return 1;
    }

    // andi
    if (fieldsIn->opcode == 12)
    {                           // set  fields for  andi instruction
        new_idex->ALUsrc = 2;   //   Alusrc to 2
        new_idex->ALU.op = 0;   //   alu opcode to 0
        new_idex->memWrite = 0; //  mem write to 0
        new_idex->regWrite = 1; // reg write to 1
        return 1;
    }

    // lw instruction
    if (fieldsIn->opcode == 35)
    {
        new_idex->ALUsrc = 1;   // set ALUsrc to 1 in  controlCpu struct
        new_idex->ALU.op = 2;   // set Alu.op to 2 to do  add instruction
        new_idex->memRead = 1;  // set memRead to 1 to do  add instruction
        new_idex->memToReg = 1; // set memtoReg to 1 to do  add instruction
        new_idex->regWrite = 1; // set regdest to 1 to in  controlCpu struct
        return 1;
    }

    // beq instruction
    if (fieldsIn->opcode == 4)
    {
        new_idex->ALU.op = 0;      // set Alu.op to 2 to do  add instruction
        new_idex->ALU.bNegate = 0; // set bnegate to 1 in  controlCpu struct
        new_idex->rs = 0;          // set rs value to zero
        new_idex->rt = 0;          // set rt value to zero
        new_idex->rd = 0;          // set rd value to zero
        new_idex->rsVal = 0;       // set rs value to zero
        new_idex->rtVal = 0;       // set rt value to zero
        return 1;
    }

    // sw instruction
    if (fieldsIn->opcode == 43)
    {
        new_idex->ALUsrc = 1;   // set ALUsrc to 1 in  controlCpu struct
        new_idex->ALU.op = 2;   // set Alu.op to 2 to do  add instruction
        new_idex->memWrite = 1; // set regdest to 1 to in  controlCpu struct
        return 1;
    }

    // bne
    if (fieldsIn->opcode == 5)
    {
        new_idex->ALU.op = 0;      // set Alu.op to 2 to do  add instruction
        new_idex->ALU.bNegate = 0; // set branch to 1 in  controlCpu struct
        new_idex->extra1 = 1;      // set extra to 1 in struct
        new_idex->rs = 0;          // rs register set it to zero
        new_idex->rt = 0;          // rt register set it to zero
        new_idex->rd = 0;          // rd reigster sets it to zero
        new_idex->rsVal = 0;       // rs value sets it to zero
        new_idex->rtVal = 0;       // rt value sets it to zero
        return 1;
    }

    // j instruction
    if (fieldsIn->opcode == 2)
    {                        // checks if  opcode is 2
        new_idex->rs = 0;    // set rs fields to zero
        new_idex->rt = 0;    // set rt register to zero
        new_idex->rd = 0;    // set rd register to zero
        new_idex->rsVal = 0; // set rs value to zero
        new_idex->rtVal = 0; // set rt value to zero
        return 1;
    }

    return 0;
}

WORD EX_getALUinput1(ID_EX *in, EX_MEM *old_exMem, MEM_WB *old_memWb)
{
    if (old_exMem->writeReg == in->rs) // checks if my current rs register is used in  previous instruction
        if (old_exMem->regWrite == 1)
        { // sw
            return old_exMem->aluResult;
        }
    if (old_memWb->writeReg == in->rs) // checks if  rs register is equal to rs old instruction
        if (old_memWb->regWrite == 1)
        { // all or s
            return old_memWb->aluResult;
        }
    return in->rsVal; // returning rs vaule for  defult
}

WORD EX_getALUinput2(ID_EX *in, EX_MEM *old_exMem, MEM_WB *old_memWb)
{
    if (in->ALUsrc == 0)
    { // if alusrc is equal to 0
        if (old_exMem->regWrite == 1)
        { // checks if we are writing to register
            if (old_exMem->writeReg == in->rt)
            { // checks is old rt register equal to my current one
                return old_exMem->aluResult;
            }
        }
        if (old_memWb->regWrite == 1)
        { // checks we writing to register
            if (old_memWb->writeReg == in->rt)
            { // checks is old rt register equal to my current one
                return old_memWb->aluResult;
            }
        }
    }
    if (in->ALUsrc == 2)
    {
        if (in->extra2 == 1)
        {                             // for my extra
            return (in->imm16 << 16); // shifting to left  value to 16 bits
        }
        return in->imm16;
    }
    if (in->ALUsrc == 1)
    {
        return in->imm32;
    }
    return in->rtVal; //  default
}

void execute_EX(ID_EX *in, WORD input1, WORD input2, EX_MEM *new_exMem)
{
    // all s
    new_exMem->aluResult = 0;
    new_exMem->memRead = in->memRead;
    new_exMem->memToReg = in->memToReg;
    new_exMem->memWrite = in->memWrite;
    new_exMem->regWrite = in->regWrite;
    new_exMem->extra1 = in->extra1;
    new_exMem->extra2 = in->extra2;
    new_exMem->extra3 = in->extra3;
    new_exMem->rt = in->rt;
    new_exMem->rtVal = in->rtVal;
    new_exMem->writeReg = 0;

    if (in->ALUsrc == 1)
    {
        new_exMem->writeReg = in->rt;
    }
    else
    {
        if (in->ALUsrc == 2)
        {
            new_exMem->writeReg = in->rt;
        }
        else
        {
            new_exMem->writeReg = in->rd;
        }
    }
    if (in->extra2)
    { // lui
        new_exMem->aluResult = in->imm16 << 16;
    }
    if (in->ALU.op == 3)
    { // checks for less
        if (input1 < input2)
        {
            new_exMem->aluResult = 1;
        }
        else
        {
            new_exMem->aluResult = 0;
        }
    }
    if (in->ALU.bNegate == 1)
    { // checks if  second input is negative
        input2 = -input2;
    }
    // and
    if (in->ALU.op == 0)
    {                                           // and command
        new_exMem->aluResult = input1 & input2; // doing  and logic
    }
    // or
    if (in->ALU.op == 1)
    {
        if (in->extra1 == 1)
        { // nor
            new_exMem->aluResult = ~(input1 | input2);
        }
        else
        {
            new_exMem->aluResult = input1 | input2; // or  two inputs
        }
    }
    // add
    if (in->ALU.op == 2)
    {
        if (in->ALU.bNegate == 0)
        {                                           // if  bnegate is zero
            new_exMem->aluResult = input1 + input2; // add  2 inputs
        }
        new_exMem->aluResult = input1 + input2; // adds  two value toger
    }

    if (in->ALU.op == 4)
    {

        new_exMem->aluResult = input1 ^ input2; // doing  xor logic
    }
}

void execute_MEM(EX_MEM *in, MEM_WB *old_memWb, WORD *mem, MEM_WB *new_memwb)
{

    // all s
    new_memwb->aluResult = in->aluResult;
    new_memwb->memToReg = in->memToReg;
    new_memwb->regWrite = in->regWrite;
    new_memwb->writeReg = in->writeReg;
    new_memwb->extra1 = in->extra1;
    new_memwb->extra2 = in->extra1;
    new_memwb->extra3 = in->extra3;
    // if(!in->memToReg)
    if (in->memWrite == 1)
    { // sw

        if (old_memWb->regWrite == 1 && old_memWb->writeReg == in->rt)
        { // data fowarding
            mem[in->aluResult / 4] = old_memWb->aluResult;
            if (old_memWb->memToReg == 1)
            {
                mem[in->aluResult / 4] = old_memWb->memResult;
            }
        }
        else
        {
            mem[in->aluResult / 4] = in->rtVal;
        }
    }
    if (in->memRead == 1)
    { // lw
        new_memwb->memResult = mem[in->aluResult / 4];
    }
    else
    {
        new_memwb->memResult = 0;
    }
}

void execute_WB(MEM_WB *in, WORD *regs)
{
    if (in->regWrite == 1)
    {
        if (in->memToReg == 1)
        {
            regs[in->writeReg] = in->memResult;
        }
        else
        {
            regs[in->writeReg] = in->aluResult; // or than that it will be from  aluResult
        }
    }
}
/* Author: Gijeong Lee
 * Date: October 25, 2023
 * This file is for sim 4.c Milestone1.
 */

#include "sim4.h"
#include <stdio.h>

/*
 * Extracts various fields from a 32-bit instruction and stores them in the given structure.
 */
void extract_instructionFields(WORD instruction, InstructionFields *fieldsOut)
{
    fieldsOut->opcode = 0x3f & (instruction >> 26); // Extracts the opcode from the last 6 bits of the instruction.
    fieldsOut->rs = 0x1f & (instruction >> 21);     // Extracts the rs field (5 bits) from the instruction.
    fieldsOut->rt = 0x1f & (instruction >> 16);     // Extracts the rt field (5 bits) from the instruction.
    fieldsOut->rd = 0x1f & (instruction >> 11);     // Extracts the rd field (5 bits) from the instruction.

    fieldsOut->shamt = 0x1f & (instruction >> 6); // Extracts the shamt field (5 bits) from the instruction.
    fieldsOut->funct = 0x3f & instruction;        // Extracts the funct field (6 bits) from the instruction.

    fieldsOut->imm16 = 0xffff & instruction;                   // Extracts the imm16 field (16 bits) from the instruction.
    fieldsOut->imm32 = signExtend16to32(instruction & 0xffff); // Sign-extends imm16 to 32 bits.
    fieldsOut->address = 0x3ffffff & instruction;              // Extracts the address field (26 bits) from the instruction.

    if (fieldsOut->opcode == 12)
    {
        // For "andi" instruction (opcode 12), imm32 is set to imm16.
        fieldsOut->imm32 = fieldsOut->imm16;
    }
}

/*
 * Configures the CPU control based on the instruction fields.
 * Sets appropriate control parameters in the CPU control structure based on the instruction fields.
 * Returns 1 if the instruction is valid, and 0 if the opcode or funct is invalid.
 */
int fill_CPUControl(InstructionFields *fields, CPUControl *controlOut)
{
    if (fields->opcode == 0)
    {
        // R-type instructions
        if (fields->funct == 32 || fields->funct == 33)
        {
            controlOut->ALU.op = 2;   // Sets ALU operation for addition.
            controlOut->regWrite = 1; // Enables register writing.
            controlOut->regDst = 1;   // Sets the destination register.

            return 1;
        }

        if (fields->funct == 34 || fields->funct == 35)
        {                                // For the "sub" and "subu" instructions.
            controlOut->ALU.op = 2;      // Sets ALU operation for subtraction.
            controlOut->ALU.bNegate = 1; // Sets the bNegate control parameter.
            controlOut->regDst = 1;      // Sets the destination register.
            controlOut->regWrite = 1;    // Enables register writing.
            return 1;
        }

        // "and" instruction
        if (fields->funct == 36)
        {                             // For the "and" instruction.
            controlOut->regWrite = 1; // Enables register writing.
            controlOut->regDst = 1;   // Sets the destination register.
            controlOut->regWrite = 1; // Enables register writing.
            return 1;
        }

        // "or" instruction
        if (fields->funct == 37)
        {                             // For the "or" instruction.
            controlOut->ALU.op = 1;   // Sets ALU operation for logical OR.
            controlOut->regDst = 1;   // Sets the destination register.
            controlOut->regWrite = 1; // Enables register writing.
            return 1;
        }

        // "xor" instruction
        if (fields->funct == 38)
        {                             // For the "xor" instruction.
            controlOut->ALU.op = 4;   // Sets ALU operation for exclusive OR.
            controlOut->regDst = 1;   // Sets the destination register.
            controlOut->regWrite = 1; // Enables register writing.
            return 1;
        }

        // "slt" instruction
        if (fields->funct == 42)
        {                                // For the "slt" instruction.
            controlOut->ALU.op = 3;      // Sets ALU operation for set less than.
            controlOut->ALU.bNegate = 1; // Sets the bNegate control parameter.
            controlOut->regDst = 1;      // Sets the destination register.
            controlOut->regWrite = 1;    // Enables register writing.
            return 1;
        }
        return 0;
    }

    // "j" instruction
    if (fields->opcode == 2)
    {                         // For the "j" instruction.
        controlOut->jump = 1; // Sets the jump control parameter.
        return 1;
    }

    // "beq" instruction
    if (fields->opcode == 4)
    {                                // For the "beq" instruction.
        controlOut->ALU.op = 2;      // Sets ALU operation for addition.
        controlOut->ALU.bNegate = 1; // Sets the bNegate control parameter.
        controlOut->branch = 1;      // Sets the branch control parameter.
        return 1;
    }

    // "bne" instruction
    if (fields->opcode == 5)
    {                                // For the "bne" instruction.
        controlOut->ALU.op = 2;      // Sets ALU operation for addition.
        controlOut->branch = 1;      // Sets the branch control parameter.
        controlOut->ALU.bNegate = 1; // Sets the bNegate control parameter.
        controlOut->extra1 = 1;      // Sets the extra1 control parameter.
        return 1;
    }

    // "addi" instruction
    if (fields->opcode == 8)
    {                             // For the "addi" instruction.
        controlOut->ALU.op = 2;   // Sets ALU operation for addition.
        controlOut->ALUsrc = 1;   // Enables ALU source control.
        controlOut->regWrite = 1; // Enables register writing.
        return 1;
    }

    // "addiu" instruction
    if (fields->opcode == 9)
    {                             // For the "addiu" instruction.
        controlOut->ALU.op = 2;   // Sets ALU operation for addition.
        controlOut->ALUsrc = 1;   // Enables ALU source control.
        controlOut->regWrite = 1; // Enables register writing.
        return 1;
    }

    // "slti" instruction
    if (fields->opcode == 10)
    {                                // For the "slti" instruction.
        controlOut->ALU.op = 3;      // Sets ALU operation for set less than.
        controlOut->ALUsrc = 1;      // Enables ALU source control.
        controlOut->ALU.bNegate = 1; // Sets the bNegate control parameter.
        controlOut->regWrite = 1;    // Enables register writing.
        return 1;
    }

    // "andi" instruction
    if (fields->opcode == 12)
    {                             // For the "andi" instruction.
        controlOut->ALUsrc = 1;   // Enables ALU source control.
        controlOut->ALU.op = 0;   // Sets ALU operation for logical AND.
        controlOut->memWrite = 1; // Enables memory write.
        controlOut->regWrite = 1; // Enables register writing.
        return 1;
    }

    // "mul" instruction
    if (fields->opcode == 28)
    {
        if (fields->funct == 2)
        {                             // For the "mul" instruction (funct 2).
            controlOut->ALU.op = 5;   // Sets ALU operation for multiplication.
            controlOut->regDst = 1;   // Sets the destination register.
            controlOut->regWrite = 1; // Enables register writing.
            return 1;
        }
    }

    // "lw" instruction
    if (fields->opcode == 35)
    {                             // For the "lw" instruction.
        controlOut->ALU.op = 2;   // Sets ALU operation for addition.
        controlOut->ALUsrc = 1;   // Enables ALU source control.
        controlOut->memRead = 1;  // Enables memory read.
        controlOut->memToReg = 1; // Sets memory to register control.
        controlOut->regWrite = 1; // Enables register writing.
        return 1;
    }

    // "sw" instruction
    if (fields->opcode == 43)
    {                             // For the "sw" instruction.
        controlOut->ALU.op = 2;   // Sets ALU operation for addition.
        controlOut->ALUsrc = 1;   // Enables ALU source control.
        controlOut->memWrite = 1; // Enables memory write.
        return 1;
    }

    return 0;
}

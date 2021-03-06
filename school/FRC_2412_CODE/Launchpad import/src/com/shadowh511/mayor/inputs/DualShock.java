/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.shadowh511.mayor.inputs;

import edu.wpi.first.wpilibj.Joystick;

/**
 *
 * @author sam
 */
public class DualShock {
    private Joystick input;

    public DualShock(int slot) {
        input = new Joystick(slot);
    }

    public boolean getTriangle() {
        return this.input.getRawButton(1);
    }

    public boolean getCircle() {
        return this.input.getRawButton(2);
    }

    public boolean getCross() {
        return this.input.getRawButton(3);
    }

    public boolean getSquare() {
        return this.input.getRawButton(4);
    }

    public boolean getL1() {
        return this.input.getRawButton(7);
    }

    public boolean getL2() {
        return this.input.getRawButton(5);
    }

    public boolean getR1() {
        return this.input.getRawButton(8);
    }

    public boolean getR2() {
        return this.input.getRawButton(6);
    }

    public boolean getStart() {
        return this.input.getRawButton(10);
    }

    public boolean getSelect() {
        return this.input.getRawButton(9);
    }

    public double getLeftStickX() {
        return this.input.getX();
    }

    public double getLeftStickY() {
        return this.input.getY();
    }

    public double getRightStickX() {
        return this.input.getTwist();
    }

    public double getRightStickY() {
        return this.input.getThrottle();
    }
}

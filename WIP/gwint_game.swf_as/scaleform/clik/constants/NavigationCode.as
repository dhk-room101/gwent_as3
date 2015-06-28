/**
 * An enumeration of common navigation equivalents.
 */

/**************************************************************************

Filename    :   NavigationCode.as

Copyright   :   Copyright 2011 Autodesk, Inc. All Rights reserved.

Use of this software is subject to the terms of the Autodesk license
agreement provided at the time of installation or download, or which
otherwise accompanies this software in either electronic or hard copy form.

**************************************************************************/

package scaleform.clik.constants {
    
    public class NavigationCode {
    
    // Constants
        public static var UP:String = "up";
        public static var DOWN:String = "down";
        public static var LEFT:String = "left";
        public static var RIGHT:String = "right";
    
        public static var START:String = "start";
        public static var BACK:String = "back";
    
        /** Constants representing the typical gamepad keys. */
        public static var GAMEPAD_A:String  = "enter-gamepad_A";
        public static var GAMEPAD_B:String  = "escape-gamepad_B";
        public static var GAMEPAD_X:String  = "gamepad_X";
        public static var GAMEPAD_Y:String  = "gamepad_Y";
        public static var GAMEPAD_L1:String = "gamepad_L1";
        public static var GAMEPAD_L2:String = "gamepad_L2";
        public static var GAMEPAD_L3:String = "gamepad_L3";
        public static var GAMEPAD_R1:String = "gamepad_R1";
        public static var GAMEPAD_R2:String = "gamepad_R2";
        public static var GAMEPAD_R3:String = "gamepad_R3";
        public static var GAMEPAD_START:String = "start";
        public static var GAMEPAD_BACK:String = "back";
        
		public static var DPAD_UP:String="dpad_up";
		public static var DPAD_DOWN:String="dpad_down";
		public static var DPAD_LEFT:String="dpad_left";
		public static var DPAD_RIGHT:String="dpad_right";

		public static var RIGHT_STICK_UP:String="rightStickUp";
		public static var RIGHT_STICK_DOWN:String="rightStickDown";
		public static var RIGHT_STICK_LEFT:String="rightStickLeft";
		public static var RIGHT_STICK_RIGHT:String="rightStickRight";

        public static var ENTER:String = "enter-gamepad_A";
        public static var ESCAPE:String = "escape-gamepad_B";
        public static var END:String = "end";
        public static var HOME:String = "home";
        
        public static var PAGE_DOWN:String = "pageDown";
        public static var PAGE_UP:String = "pageUp";
        
        public static var TAB:String = "tab";
        public static var SHIFT_TAB:String = "shifttab"; // lowercase to match GFx
 
		public static var INVALID:String="INVALID"; 
    }
    
}
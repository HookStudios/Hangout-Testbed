/*
Hook Logger Copyright 2010 Hook L.L.C.
For licensing questions contact hook: http://www.byhook.com

 This file is part of Hook Logger.

Hook Logger is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
at your option) any later version.

Hook Logger is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Hook Logger.  If not, see <http://www.gnu.org/licenses/>.
*/

package com.jac.log 
{
	/**
	 * A collection of Static Constants that are used to build the Debug Level Filters.
	 * These are intended to be used as bit mask components.  To combine them, please OR (|) them together.
	 * <code>var filter:uint = (INFO|WARNING|ERROR);</code>
	 * 
	 * <p>The available options are:</p>
	 * <ul>
	 * <li>INFO</li>
	 * <li>WARNING</li>
	 * <li>ERROR</li>
	 * <li>STACKTRACE</li>
	 * <li>ALL</li>
	 * </ul>
	 */
	public class DebugLevel
	{//DebugLevel Class
		
		static public const INFO:uint = 2;
		static public const WARNING:uint = 4;
		static public const ERROR:uint = 8;
		static public const TRACKING:uint = 16;
		static public const STACKTRACE:uint = 32;
		
		
		static public const ALL:uint = (INFO | WARNING | ERROR | STACKTRACE | TRACKING);
		
		/**
		 * Converts the passed in bit mask filter, and converts it to a human readable string.
		 * @param	filter the bit mask filter
		 * @return	a comma separated string with each of the contained bits.
		 */
		static public function toString(filter:uint):String
		{//toString
		
			var result:String = "";
			
			if (filter & INFO)
			{//info
				result += "INFO";
			}//info
			
			if (filter & WARNING)
			{//warning
				if (result != "") { result += ",";}
				result += "WARNING";
			}//warning
			
			if (filter & ERROR)
			{//error
				if (result != "") { result += ",";}
				result += "ERROR";
			}//error
		
			if (filter & TRACKING)
			{//tracking
				if (result != "") { result += ",";}
				result += "TRACKING";
			}//tracking
			
			if (filter & STACKTRACE)
			{//stacktrace
				if (result != "") { result += ",";}
				result += "STACKTRACE";
			}//stacktrace
			
			
			
			return result;
		}//toString
	}//DebugLevel Class

}
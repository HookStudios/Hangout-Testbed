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
	public class VerboseLevel
	{//VerboseLevel Class
		
		static public const NORMAL:uint = 0;
		static public const CLASS:uint = 2;
		static public const FUNCTION:uint = 4;
		static public const LINE:uint = 8;
		static public const TIME:uint = 16;
		static public const LEVEL:uint = 32;
		static public const CLASSPATH:uint = 64;
		
		static public const ALL:uint = (NORMAL | CLASSPATH | CLASS | FUNCTION | LINE | TIME | LEVEL);
	}//VerboseLevel Class

}
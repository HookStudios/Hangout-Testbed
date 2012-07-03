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

package com.jac.log.events 
{
	import flash.events.Event;
	
	public class LogEvent extends Event 
	{//LogEvent Class
	
		static public const TARGET_UPDATED:String = "logEventTargetUpdated";
	
		public function LogEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{//LogEvent
			super(type, bubbles, cancelable);
			
		}//LogEvent
		
		public override function clone():Event 
		{ 
			return new LogEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("LogEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}//LogEvent Class
	
}
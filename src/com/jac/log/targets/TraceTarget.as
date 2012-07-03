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

package com.jac.log.targets
{
	import com.jac.log.events.LogEvent;
	import com.jac.log.ILogTarget;
	import flash.events.EventDispatcher;
	
	/**
	* Dispatched when the log target has completed updating its output.
	* 
	* @eventType com.jac.log.events.LogEvent
	*/
	[Event("TARGET_UPDATED", type="com.jac.log.events.LogEvent")]
	
	/**
	 * A Log Target that does a flash <code>trace</code> call.
	 */
	public class TraceTarget extends EventDispatcher implements ILogTarget
	{//TraceTarget Class
	
		private var _enabled:Boolean;
	
		/**
		 * Constructor for TraceTarget
		 */
		public function TraceTarget() 
		{//TraceTarget
			_enabled = true;
		}//TraceTarget
		
		/**
		 * @inheritDoc
		 */
		public function output(...args):void
		{//output
			trace(args);
			
			dispatchEvent(new LogEvent(LogEvent.TARGET_UPDATED));
			
		}//output
		
		/**
		 * @inheritDoc
		 */
		public function get enabled():Boolean { return _enabled; }
		
		/**
		 * @private
		 */
		public function set enabled(value:Boolean):void 
		{
			_enabled = value;
		}
		
		
		
	}//TraceTarget Class

}
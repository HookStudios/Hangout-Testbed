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
	import flash.events.IEventDispatcher;
	
	/**
	 * Interface definition for the required functions that must be contained in a Log Target.
	 * 
	 * @see com.jac.log.Log#addTarget()
	 */
	public interface ILogTarget extends IEventDispatcher
	{//ILogTarget
		/**
		 * Called by the Logger and is passed the formatted output from the Logger.
		 * @param	...args the formatted output to be logged through the target.
		 */
		function output(...args):void;
		
		/**
		 * Sets and returns the enabled state of the Log Target.  If <code>enabled</code> is set to false, it is expected that this Log Target will not log anything.
		 */
		function get enabled():Boolean;
		/**
		 * @private
		 */ 
		function set enabled(value:Boolean):void;
	}//ILogTarget
	
}
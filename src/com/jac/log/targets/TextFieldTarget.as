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
	import flash.text.TextField;
	
	/**
	* Dispatched when the log target has completed updating its output.
	* 
	* @eventType com.jac.log.events.LogEvent
	*/
	[Event("TARGET_UPDATED", type="com.jac.log.events.LogEvent")]
	
	/**
	 * A Log Target that will display its output to a TextField.
	 */
	public class TextFieldTarget extends EventDispatcher implements ILogTarget
	{//TextFieldTarget Class
	
		protected var _enabled:Boolean;
		protected var _field:TextField;
		
		/**
		 * Constructor for TextFieldTarget.
		 * @param	textField the TextField to receive the output.
		 */
		public function TextFieldTarget(textField:TextField) 
		{//TextFieldTarget
			_field = textField;
			_enabled = true;
		}//TextFieldTarget
		
		/**
		 * @inheritDoc
		 */
		public function output(...args):void
		{//output
			
			for each(var arg:String in args)
			{//each arg
				_field.appendText(arg);
			}//each arg
			
			_field.appendText("\n");
			
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
		
		
	}//TextFieldTarget Class

}
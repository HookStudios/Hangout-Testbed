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
	import flash.external.ExternalInterface;
	
	/**
	* Dispatched when the log target has completed updating its output.
	* 
	* @eventType com.jac.log.events.LogEvent
	*/
	[Event("TARGET_UPDATED", type="com.jac.log.events.LogEvent")]
	
	/**
	 * A Log Target that will output to the console of the browser if the console is available.
	 */
	public class BrowserConsoleTarget extends EventDispatcher implements ILogTarget
	{//BrowserConsoleTarget Class
		
		private var _enabled:Boolean;
		private var _jsID:String;
		private var _isRegistered:Boolean;
		
		/**
		 * Constructor for BrwoserConsoleTarget.  During this constructor the JavaScript that is required to do the output, is also registered and injected.
		 */
		public function BrowserConsoleTarget() 
		{//BrowserConsoleTarget
			_enabled = ExternalInterface.available;
			_isRegistered = false;
			
			//setup js
			registerJS();
		}//BrowserConsoleTarget
		
		/**
		 * Actually does the output of the log to the browser console.
		 * 
		 * @param	...args formatted output from the Logger.
		 */
		public function output(...args):void
		{//output
			var combinedString:String = args.join();
			
			if (_isRegistered)
			{//call
				ExternalInterface.call("ctrace.log", combinedString);
				dispatchEvent(new LogEvent(LogEvent.TARGET_UPDATED));
			}//call
			
		}//output
		
		/**
		 * Handles the JavaScript injection to register the new functions that perform the console logging.
		 */
		private function registerJS():void
		{//registerJS
			if (ExternalInterface.available)
			{//inject
				var id:String = "ctrace_" + Math.floor(Math.random() * 10000000);
				_jsID = id;
				ExternalInterface.addCallback(id, function():void { } );
				ExternalInterface.call(ConsoleTrace_JavaScript.CODE);
				_isRegistered = true;
			}//inject
		}//registerJS
		
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
		
	}//BrowserConsoleTarget Class

}

/**
 * This is the JavaScript code that gets injected.
 */
class ConsoleTrace_JavaScript
{//ConsoleTrace_JavaScript

	public static const CODE:XML = 
	<script>
		<![CDATA[
		function()
		{//function
			
		//Create unique namespace
			if (typeof ctrace == "undefined" || !ctrace)
			{//make new
				ctrace = {};
			}//make new
			
			//Add log function
			ctrace.log = function(message)
			{//log
				if (typeof console != "undefined")
				{//we have a console, log
					console.log(message);
				}//we have a console, log
				else
				{//no console
					//alert("No Console: " + message);
				}//no console
			}//log
			
			
		}//function
		]]>
	</script>;

}//ConsoleTrace_JavaScript
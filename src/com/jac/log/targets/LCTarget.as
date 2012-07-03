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
{//Package
	import com.jac.log.events.LogEvent;
	import flash.events.IEventDispatcher;
	import com.jac.log.ILogTarget;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.events.TimerEvent;
	import flash.net.LocalConnection;
	import flash.utils.Timer;
	
	/**
	* Dispatched when the log target has completed updating its output.
	* 
	* @eventType com.jac.log.events.LogEvent
	*/
	[Event("TARGET_UPDATED", type="com.jac.log.events.LogEvent")]
	
	/**
	 * LCTarget is designed to be used in conjunction with the Flash Diagnostics system developed by Hook.
	 * On Creation, this will look for a local connection specified in the constructor, and make an attempt to connect.
	 * If that connection isn't there, or fails, it will keep trying (every second) until a connection is found.
	 * In the meantime, any logs output through this class will be buffered for later use.
	 * Once a connection is made, the buffer is emptied one item at a time every 100ms.
	 */
	public class LCTarget extends EventDispatcher implements ILogTarget
	{//LCTarget Class
	
		private var _enabled:Boolean;
		private var _lcName:String;
		private var _lc:LocalConnection;
		private var _isConnected:Boolean = false;
		private var _retryTimer:Timer;
		private var _logBuffer:Vector.<String>;
		private var _flushTimer:Timer;
		private var _retryCount:int = 0;;
		
		/**
		 * Constructor for LCTarget.  This is a log target that can be used with the Logger system in conjunction with 
		 * Hook's Flash Diagnostics System.
		 * 
		 * @param	connectionName name of the local connection where the logs will be collected.
		 */
		public function LCTarget(connectionName:String="_HOOKLOGCOLLECTORCONNECTION") 
		{//LCTarget
			_enabled = true;
			_logBuffer = new Vector.<String>();
			
			_lcName = connectionName;
			
			_lc = new LocalConnection();
			_lc.addEventListener(StatusEvent.STATUS, handleStatus, false, 0, true);
			
			_retryTimer = new Timer(1000, 0);
			_retryTimer.addEventListener(TimerEvent.TIMER, handleRetryTimer, false, 0, true);
			
			_flushTimer = new Timer(100, 0);
			_flushTimer.addEventListener(TimerEvent.TIMER, handleFlush, false, 0, true);
			
			_retryTimer.start();
		}//LCTarget
		
		/**
		 * Sends the log entry to the Local Connection collector.
		 * @param	string log to send to the Local Connection collector.
		 */
		private function write(string:String):void
		{//write
			//Write to LC here.
			if (_isConnected)
			{//write
				_lc.send(_lcName, "handleLogEntry", string);
			}//write
		}//write
		
		/**
		 * Writes out the next log entry to output.
		 * @param	e timer event that triggered the flush.
		 */
		private function handleFlush(e:TimerEvent):void 
		{//handleFlush
			if (_logBuffer.length > 0)
			{//write out
				write(_logBuffer.shift());
			}//write out
		}//handleFlush
		
		/**
		 * Timer that manages the connection retries.
		 * @param	e timer event that triggered the retry.
		 */
		private function handleRetryTimer(e:TimerEvent):void 
		{//handleRetryTimer
			//trace("Retry Timer");
			_retryCount++;
			tryConnection();
		}//handleRetryTimer
		
		/**
		 * Attempts to connect to the local connection.
		 */
		private function tryConnection():void
		{//tryConnection
			trace("Try Connection");
			if (!_isConnected)
			{//try again
				_lc.send(_lcName, "ping", _retryCount);
			}//try again
			else
			{//connected
				_retryTimer.reset();
			}//connected
		}//tryConnection
		
		/**
		 * Determines if a connection was successful to the local connection.  If successfull, flush the logs, else try to connect again.
		 * @param	e status event that triggered the handler.
		 */
		private function handleStatus(e:StatusEvent):void 
		{//handleStatus
			switch(e.level)
			{//switch
				case "status":
					trace("Status: status");
					_isConnected = true;
					if (!_flushTimer.running)
					{//flush
						_retryTimer.reset();
						_flushTimer.start();
					}//flush
				break;
				case "error":
					trace("Status: error");
					_isConnected = false;
					if (!_retryTimer.running)
					{//try again
						_retryTimer.start();
						_flushTimer.reset();
					}//try again
				break;
			}//switch
		}//handleStatus
		
		/* INTERFACE com.jac.log.ILogTarget */
		/**
		 * Adds a log entry to the log buffer and dispatches the LogEvent.TARGET_UPDATED event.
		 * @param	...args
		 */
		public function output(...args):void
		{//output
			trace("output: " + args[0]);
			
			for each(var arg:String in args)
			{//each arg
				_logBuffer.push(String(arg));
			}//each arg
			
			dispatchEvent(new LogEvent(LogEvent.TARGET_UPDATED));
		}//output

		/**
		 * @private
		 */
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set enabled(value:Boolean):void
		{
			_enabled = value;
		}
		
		
	}//LCTarget Class

}//Package
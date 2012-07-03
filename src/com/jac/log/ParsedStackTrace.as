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
	import flash.utils.getTimer;

	/**
	 * An object used to parse and store a Stack Trace for easy manipulation.
	 */
	public class ParsedStackTrace
	{//ParsedStackTrace Class
	
		private var _className:String;
		private var _functionName:String;
		private var _lineNumber:String;
		private var _fullTrace:String;
		private var _isGood:Boolean;
		private var _hasLineNumber:Boolean;
		private var _logTime:uint;
		private var _classPath:String;
		private var _isDebug:Boolean;
		
		/**
		 * Constructor for object.  Takes the passed in stack trace, parses it, and stores the results into properties.
		 * @param	stackTrace the Stack Trace to parse.
		 */
		public function ParsedStackTrace(stackTrace:String, $relevantLineIndex:int=4) 
		{//ParsedStackTrace
			
			//Set defaults
			_isGood = false;
			_hasLineNumber = false;
			_logTime = getTimer();
			
			_fullTrace = stackTrace;
			//Parse it
			if (stackTrace == null)
			{//no good
				return;
			}//no good
			else
			{//good
				var lines:Array = _fullTrace.split("\n");
				var relevantLine:String = lines[$relevantLineIndex];
				var startIndex:int;
				var endIndex:int;
				var culledLine:String;
				
				//set flag
				_isGood = true;
				
				//check for debug
				if (relevantLine.charAt(relevantLine.length - 1) == "]")
				{//debug
					_isDebug = true;
				}//debug
				
				var startChunk:String; 
				
				if (_isDebug)
				{//
					startChunk = relevantLine.substring(0, relevantLine.indexOf("["));
				}//
				else
				{//
					startChunk = relevantLine;
				}//
				
				if (startChunk.indexOf("::") == -1)
				{//doc/main class
					//Find start of line
					startIndex = relevantLine.indexOf("at");
					
					//Move past "at"
					startIndex += 3;
					
					//Find end of chunk
					if (_isDebug)
					{//
						endIndex = relevantLine.indexOf("[");
					}//
					else
					{//
						endIndex = relevantLine.length;
					}//
					
					var part1:String = relevantLine.substring(startIndex, endIndex);
					
					//check if we have a method name
					if (part1.indexOf("/") != -1)
					{//we have a method
						var tokens:Array = part1.split("/");
						_className = tokens[0].split("()")[0];
						_functionName = tokens[1];
					}//we have a method
					else
					{//no method
						_className = part1.split("()")[0];
						_functionName = "";
					}//no method
					
					_classPath = "";
				}//doc/main class
				else
				{//normal class
					//Grab class path
					startIndex = relevantLine.indexOf("at");
					endIndex = relevantLine.indexOf("::");
					
					_classPath = relevantLine.substring(startIndex + 3, endIndex);
					
					//Grab class name
					var chunk1End:int;
					
					if (_isDebug)
					{//
						chunk1End = relevantLine.indexOf("[");
					}//
					else
					{//
						chunk1End = relevantLine.length;
					}//
					
					var chunk1:String = relevantLine.substring(startIndex, chunk1End);
					startIndex = relevantLine.indexOf("::");
					if (chunk1.indexOf("/") == -1)
					{//no method
						chunk1 = relevantLine.substring(startIndex+2, chunk1End);
						_functionName = "";
						_className = chunk1.split("()")[0];
					}//no method
					else
					{//method
						endIndex = relevantLine.indexOf("/");
						_className = relevantLine.substring(startIndex + 2, endIndex).split("()")[0];
					
						//Grab function name
						culledLine = relevantLine.substring(endIndex + 1, relevantLine.length);
						if (culledLine.length > 0)
						{//function name
							startIndex = 0;
							
							if (_isDebug)
							{//debug
								endIndex = culledLine.indexOf("[");
							}//debug
							else
							{//release
								endIndex = culledLine.length;
							}//release
							
							_functionName = culledLine.substring(startIndex , endIndex);
							
							//startIndex = culledLine.indexOf("::");
							//endIndex = culledLine.lastIndexOf(")");
							//_functionName = culledLine.substring(startIndex + 1 , endIndex + 1);
						}//function name
					}//method
				}//normal class
				
				//Try to get line number
				startIndex = relevantLine.lastIndexOf(":");
				if (startIndex != -1)
				{//
					_lineNumber = relevantLine.substring(startIndex + 1, relevantLine.length - 1);
					
					if(!isNaN(parseInt(lineNumber)))
					{//good line numnber
						_hasLineNumber = true;
					}//good line number
					else
					{//no line number
						_lineNumber = "No Line Number";
						_hasLineNumber = false;
					}//no line number
					
				}//
				else
				{//set -1
					_lineNumber = "No Line Number";
					_hasLineNumber = false;
				}//set -1
			}//good
			
		
		}//ParsedStackTrace
		
		/**
		 * Converts the properties of the ParsedStackTrace object into a formatted string for easy reading.
		 * 
		 * @param	showFullStackTrace if <code>true</code> the raw stack trace will be returned in addition to the properties.  This is <code>false</code> by default.
		 * @return a formatted string version of the ParsedStackTrace and its properties.
		 */
		public function toString(showFullStackTrace:Boolean = false):String 
		{//toString
			var result:String = "";
			
			result += ("isGood: " + _isGood + "\n");
			result += ("isDebug: " + _isDebug + "\n");
			result += ("hasLineNumber: " + _hasLineNumber + "\n");
			result += ("Time: " + _logTime + "\n");
			result += ("Class: " + _classPath + "." + _className + "\n");
			result += ("Function: " + _functionName + "\n");
			result += ("Line: " + _lineNumber + "\n");
			
			if (showFullStackTrace)
			{//add full trace
				result += ("\n" + _fullTrace);
			}//add full trace
			
			return result;
			
		}//toString
		
		/**
		 * Returns the parsed class name from the Stack Trace.
		 * 
		 * @return the class name
		 */
		public function get className():String 
		{ return _className; }
		
		/**
		 * Returns the function name parsed from the Stack Trace.
		 * @return the function name.
		 */
		public function get functionName():String { return _functionName; }
		
		/**
		 * Returns the line number from the parsed Stack Trace.
		 * @return the line number.
		 */
		public function get lineNumber():String { return _lineNumber; }
		
		/**
		 * Returns the raw passed in Stack Trace.
		 * 
		 * @return the raw passed in Stack Trace.
		 */
		public function get fullTrace():String { return _fullTrace; }
		
		/**
		 * Flag that indicates if the parsing was successful.
		 * 
		 * @return <code>true</code> if the parse was a success, and <code>false</code> otherwise.
		 */
		public function get isGood():Boolean { return _isGood; }
		
		/**
		 * Flag that indicates whether or not a line number was provided in the Stack Trace.
		 * @return <code>true</code> if a line number was provided, and <code>false</code> otherwise.
		 */
		public function get hasLineNumber():Boolean { return _hasLineNumber; }
		
		/**
		 * Returns the time the ParsedStackTrace object was created.
		 * 
		 * @return the time the ParsedStackTrace object was created.
		 */
		public function get logTime():uint { return _logTime; }
		
		/**
		 * Returns the class path provided in the Stack Trace.
		 * 
		 * @return the class path provided in the stack trace.
		 */
		public function get classPath():String { return _classPath; }
		
		public function get isDebug():Boolean { return _isDebug; }
		
		
	}//ParsedStackTrace Class

}
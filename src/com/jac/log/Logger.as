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
{//Package
	import flash.events.EventDispatcher;
	import flash.text.TextField;
	import flash.utils.getTimer;
	
	/**
	 * This class is a Singleton and should only be accessed through the com.jac.log.Log class.
	 * 
	 * @see com.jac.log.Log
	 */
	public class Logger extends EventDispatcher
	{//Logger Class
	
		/**
		 * The single Singleton instance.
		 */
		static private var _instance:Logger = null;
	
		/**
		 * Flag used to determine if logging is turned on or off.
		 */
		public var logEnabled:Boolean = true;
		
		/**
		 * A list of the current ILogTargets.
		 */
		public var targetList:Array;
		
		/**
		 * The default and then current Level Filter set.
		 */
		private var _levelFilter:uint = (DebugLevel.INFO | DebugLevel.WARNING | DebugLevel.ERROR);
		
		/**
		 * The default and then current Verbose Filter set.
		 */
		private var _verboseFilter:uint = (VerboseLevel.NORMAL);
		
		/**
		 * List of tags to show.  Is is an Array of Strings.  Each string must start with an @ sign.
		 */
		private var _tagFilterList:Array = new Array();
		
		private var _isTagFilterEnabled:Boolean = true;
		
		/**
		 * Shows/Hides logs that do not have tags.
		 */
		private var _showUntagged:Boolean;
		
		private var _stringFilterList:Array = new Array();
		
		private var _isStringFilterCaseSensitive:Boolean = false;
		
		private var _isStringFilterEnabled:Boolean = false;
		
		private var _classFilterList:Array = new Array();
		
		private var _isClassFilterEnabled:Boolean = false;
		
		/**
		 * Logger Constructor.
		 * @param	singletonEnforcer
		 */
		public function Logger(singletonEnforcer:SingletonEnforcer = null) 
		{//Logger
			if (!singletonEnforcer)
			{//only one
				throw Error("Logger is a singleton, and there can be only one,  please use getInstance() instead");
			}//only one
		}//Logger
		
		/**
		 * Called from the com.log.Log class to actually produce output.
		 * 
		 * @param	debugLevel the desired DebugLevel for the passed in output.
		 * @param	...args a comma separated list of items to output.
		 */
		public function log(debugLevel:uint, ... args):void
		{//log
			var tag:String = "";
	
			if (logEnabled)
			{//log
				var tokens:Array = String(args[args.length-1]).split(",");
				if (tokens[tokens.length - 1].substring(0, 1) == "@")
				{//tag
					tag = tokens[tokens.length - 1];
					tokens.pop();
					args[args.length - 1] = tokens.join(",");
				}//tag
			
				for each(var target:ILogTarget in targetList)
				{//call output
					if (target.enabled && (debugLevel & _levelFilter))
					{//log
						//filter on tags
						if ((_showUntagged && tag == "") || (_tagFilterList.indexOf(tag) != -1) || (_tagFilterList.length == 0) || (debugLevel & DebugLevel.WARNING) || !_isTagFilterEnabled)
						{//show
							var output:String = "";
							var pst:ParsedStackTrace = new ParsedStackTrace(new Error().getStackTrace(), 3);
							
							//Class filter
							if (_isClassFilterEnabled && _classFilterList.length > 0)
							{//enabled, see if in list
								var found:Boolean = false;
								for (var i:int = 0; i < _classFilterList.length; i++) 
								{//check
									if (pst.className == _classFilterList[i])
									{//found
										found = true;
										break;
									}//found
								}//check
								
								if (!found)
								{//skip
									continue;
								}//skip
							}//enabled, see if in list
							
							if (_verboseFilter & VerboseLevel.LEVEL)
							{//add level
								output += ("[" + DebugLevel.toString(debugLevel))
								
								if (tag != "")
								{//add tag
									output += (":" + tag);
								}//add tag
								
								output += ("] ");
							}//add level
							
							if (_verboseFilter == 0)
							{//normal output
								output += args.join();
							}//normal output
							else
							{//parse stack trace
								output += (buildOutput() + args);
							}//parse stack trace
							
							if (_isStringFilterEnabled && _stringFilterList.length > 0 && !(debugLevel & DebugLevel.WARNING))
							{//filter on string pattern
								var str:String = output;
								var pattern:String;
								
								if (!_isStringFilterCaseSensitive)
								{//to lower
									str = str.toLocaleLowerCase();
								}//to lower
								
								for (var s:int = 0; s < _stringFilterList.length; s++)
								{//check each string filter
									pattern = _stringFilterList[s];
									if (!_isStringFilterCaseSensitive)
									{//lower
										pattern = pattern.toLocaleLowerCase();
									}//lower
									
									if (str.indexOf(pattern) != -1)
									{//found it
										target.output(output);
										break;
									}//found it
									
								}//check each string filter
								
							}//filter on string pattern
							else
							{//output
								target.output(output);
							}//output
						}//show
					}//log
				}//call output
			}//log
		}//log
		
		/**
		 * Formats and constructs the output.
		 * @private
		 * 
		 * @return the formatted output.
		 */
		private function buildOutput($pst:ParsedStackTrace=null):String
		{//buildOutput
			var result:String = "";
			var pst:ParsedStackTrace = $pst;
			
			if (!$pst)
			{//make new
				pst = new ParsedStackTrace(new Error().getStackTrace());
			}//make new
			
			if (pst.isGood)
			{//good
			
				if (_verboseFilter & VerboseLevel.TIME)
				{//time
					result += ("[" + formatTime(pst.logTime) + "] ");
				}//time
				
				result += "[";
				
				if ((_verboseFilter & VerboseLevel.CLASSPATH) && pst.classPath != "")
				{//full class
					result += (pst.classPath);
				}//full class
				
				if (_verboseFilter & VerboseLevel.CLASS)
				{//class
					if ((_verboseFilter & VerboseLevel.CLASSPATH) && pst.classPath != "")
					{//add .
						result += ".";
					}//add .
					
					result += (pst.className);
					
					if ((_verboseFilter & VerboseLevel.FUNCTION) && pst.functionName != "")
					{//add ::
						result += "::";
					}//add ::
				}//class
				
				if ((_verboseFilter & VerboseLevel.FUNCTION) && pst.functionName != "")
				{//function
					result += (pst.functionName);
				}//function
				
				if (_verboseFilter & VerboseLevel.LINE)
				{//line number
					if (pst.hasLineNumber)
					{//add line number
						result += (":"+pst.lineNumber);
					}//add line number
				}//line number
				
				result += "] ";
			}//good
			else
			{//bad stack trace
				//result += "DEBUG PLAYER NOT INSTALLED";
				if (_verboseFilter & VerboseLevel.TIME)
				{//time
					result += ("[" + formatTime(getTimer()) + "] ");
				}//time
			}//bad stack trace
			
			return result;
		}//buildOutput
		
		/**
		 * Called from the com.jac.log.Log class to format a passed in Stack Trace.
		 * @param	...args the stack trace to format.
		 */
		public function stackTrace(...args):void
		{//stackTrace
			var e:Error = new Error(args);
			
			var oldFilter:uint = _instance._verboseFilter;
			
			_instance._verboseFilter = (VerboseLevel.NORMAL)
			log(DebugLevel.INFO, "\n[===== Start Stack Trace =====]");
			
			var st:String = e.getStackTrace();
			var tokens:Array;
			
			tokens = e.getStackTrace().split("\n");
			tokens.shift();
			st = tokens.join("\n");
			log(DebugLevel.STACKTRACE, (args + ":\n" + st));
			log(DebugLevel.INFO,  "[=====  End Stack Trace  =====]\n");
			_instance._verboseFilter = oldFilter;
		}//stackTrace
		
		/**
		 * Aquires the instance of the Logger singleton.  This is the only proper method for retrieving the reference.
		 * 
		 * @return the Logger instance.
		 */
		public static function getInstance():Logger 
		{//getInstance
			
			if (Logger._instance == null) 
			{//build first instance
				Logger._instance = new Logger(new SingletonEnforcer());
				Logger._instance.targetList = new Array();
				Logger._instance.tagFilterList = new Array();
				Logger._instance.showUntagged = true;
			}//build first instance
			
			return Logger._instance;
		}//getInstance
		
		/**
		 * Formats the passed in time in Milliseonds to Minutes:Seconds:Milliseconds.
		 * @private
		 * @param	time time in milliseconds
		 * @return	a string of the formatted time
		 */
		internal static function formatTime(time:uint):String
		{//formatTime
			var minutes:String;
			var seconds:String;
			var ms:String;
			
			ms = (time % 1000).toString();
			seconds = Math.floor(time / 1000).toString();
			minutes = Math.floor(time / 60000).toString();
			
			if (seconds.length < 2) { seconds = ("0" + seconds); }
			
			return (minutes + ":" + seconds + ":" + ms);
			
		}//formatTime
		
		////////////// GETTERS / SETTERS \\\\\\\\\\\\\\
		/**
		 * Sets and returns the current DebugLevel filter.
		 */
		public function get levelFilter():uint { return _levelFilter; }
		/**
		 * @private
		 */
		public function set levelFilter(value:uint):void 
		{
			_levelFilter = value;
		}
		
		/**
		 * Sets and returns the current VerboseLevel filter.
		 */
		public function get verboseFilter():uint { return _verboseFilter; }
		/**
		 * @private
		 */
		public function set verboseFilter(value:uint):void 
		{
			_verboseFilter = value;
		}
		
		public function get tagFilterList():Array { return _tagFilterList; }
		public function set tagFilterList(value:Array):void 
		{
			_tagFilterList = value;
		}
		
		public function get showUntagged():Boolean { return _showUntagged; }
		public function set showUntagged(value:Boolean):void 
		{
			_showUntagged = value;
		}
		
		public function get stringFilterList():Array { return _stringFilterList; }
		public function set stringFilterList(value:Array):void 
		{
			_stringFilterList = value;
		}
		
		public function get isStringFilterCaseSensitive():Boolean { return _isStringFilterCaseSensitive; }
		public function set isStringFilterCaseSensitive(value:Boolean):void 
		{
			_isStringFilterCaseSensitive = value;
		}
		
		public function get isStringFilterEnabled():Boolean { return _isStringFilterEnabled; }
		public function set isStringFilterEnabled(value:Boolean):void 
		{
			_isStringFilterEnabled = value;
		}
		
		public function get isTagFilterEnabled():Boolean 
		{
			return _isTagFilterEnabled;
		}
		
		public function set isTagFilterEnabled(value:Boolean):void 
		{
			_isTagFilterEnabled = value;
		}
		
		public function get classFilterList():Array 
		{
			return _classFilterList;
		}
		
		public function set classFilterList(value:Array):void 
		{
			_classFilterList = value;
		}
		
		public function get isClassFilterEnabled():Boolean 
		{
			return _isClassFilterEnabled;
		}
		
		public function set isClassFilterEnabled(value:Boolean):void 
		{
			_isClassFilterEnabled = value;
		}
		
		
		
	}//Logger Class

}//Package

class SingletonEnforcer{}
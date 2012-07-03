package com.jac.jsBridge 
{
	import com.jac.log.Log;
	import com.jac.utils.ObjUtils;
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;
	import flash.system.Capabilities;
	
	/**
	 * ...
	 * @author Jake Callery
	 */
	public class JSCall extends EventDispatcher implements IJSCall
	{//JSCall Class
		
		protected var _functionName:String;
		protected var _args:Array;
		protected var _forcedResult:Object;
		protected var _params:Array;
		
		public function JSCall($functionName:String, $args:Array=null):void
		{//JSCall
			_functionName = $functionName;
			_args = $args;
			if(_args == null){_args = [];}
			
		}//JSCall
		
		public function straightJSCall():Object
		{//arrayParamCall
			if (isInBrowser())
			{//real call
				Log.log("Calling To JS (straightJS): " + _functionName + "(" + _args + ")", "@jscall");
				//Log.log("Passed args: " + ObjUtils.getDynamicProps(_args), "@jscall");
				return ExternalInterface.call(_functionName, _args);
			}//real call
			else
			{//forced result
				return forcedResult;
			}//forced result
		}//arrayParamCall
		
		public function applyJSCall():Object
		{//call
			if (isInBrowser())
			{//real call
				var params:Array = [_functionName];
				params = params.concat(_args);
				Log.log("Calling To JS (apply): " + _functionName + "(" + _args + ")", "@jscall");
				//Log.log("Passed args: " + ObjUtils.getDynamicProps(_args), "@jscall");
				//Log.log("Passed Params: " + ObjUtils.getDynamicProps(params), "@jscall");
				return ExternalInterface.call.apply(null, params);
			}//real call
			else
			{//forced result
				return forcedResult;
			}//forced result
		}//call
		
		protected function isInBrowser():Boolean
		{//isInBrowser
			if (ExternalInterface.available && Capabilities.playerType != "External" && Capabilities.playerType != "StandAlone")
			{//we are in a browser
				return true;
			}//we are in a browser
			else
			{//not in browser
				return false;
			}//not in browser
		}//isInBrowser
		
		public function get forcedResult():Object 
		{//get forcedResult
			return _forcedResult;
		}//get forcedResult
		
		public function set forcedResult(value:Object):void 
		{//set forcedResult
			_forcedResult = value;
		}//set forcedResult
		
		public function get functionName():String 
		{
			return _functionName;
		}
		
		public function get args():Array 
		{
			return _args;
		}
		
	}//JSCall Class

}
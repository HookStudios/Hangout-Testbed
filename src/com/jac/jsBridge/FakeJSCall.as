package com.jac.jsBridge 
{
	import flash.events.EventDispatcher;
	
	/**
	 * ...
	 * @author Jake Callery
	 */
	public class FakeJSCall extends EventDispatcher implements IJSCall
	{//FakeJSCall Class
		
		private var _functionName:String="";
		private var _result:Object;
		private var _forcedResult:Object;
		
		public function FakeJSCall($functionName:String, $returnResult:Object) 
		{//FakeJSCall
			_functionName = $functionName;
			_result = $returnResult;
		}//FakeJSCall
		
		/* INTERFACE com.jac.jsBridge.IJSCall */
		public function straightJSCall():Object
		{//straightJSCall
			return _result;
		}//straightJSCall
		
		public function applyJSCall():Object 
		{//call
			return _result;
		}//call
		
		public function set forcedResult(value:Object):void 
		{
			_forcedResult = value;
		}
		
		public function get functionName():String 
		{
			return _functionName;
		}
		
		public function get result():Object 
		{
			return _result;
		}
		
		public function get forcedResult():Object 
		{
			return _forcedResult;
		}
		
	}//FakeJSCall Class

}
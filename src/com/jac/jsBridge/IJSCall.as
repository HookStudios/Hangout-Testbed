package com.jac.jsBridge 
{
	
	/**
	 * ...
	 * @author Jake Callery
	 */
	public interface IJSCall 
	{//IJSCall
		function applyJSCall():Object;
		function straightJSCall():Object;
		function get forcedResult():Object;
		function set forcedResult($result:Object):void;
	}//IJSCall
	
}
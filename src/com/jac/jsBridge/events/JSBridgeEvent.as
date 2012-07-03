package com.jac.jsBridge.events 
{//Packge
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Jake Callery
	 */
	public class JSBridgeEvent extends Event 
	{//JSBridgeEvent Class

		static public const BRIDGE_READY:String = "jsBridgeReadyEvent";
		
		private var _data:Object;
		
		public function JSBridgeEvent(type:String, $data:Object=null, bubbles:Boolean=false, cancelable:Boolean=false) 
		{//JSBridgeEvent 
			super(type, bubbles, cancelable);
			_data = $data;
			
		}//JSBridgeEvent
		
		public override function clone():Event 
		{ 
			return new JSBridgeEvent(type, data, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("JSBridgeEvent", "type", "data", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get data():Object {return _data;}
	}//JSBridgeEvent Class
	
}//Packge
package com.jac.google.hangout.events 
{//Packge
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Jake Callery
	 */
	public class HangoutBridgeEvent extends Event 
	{//HangoutBridgeEvent Class
		
		static public const READY:String = "hangoutBridgeReadyEvent";
		//static public const PARTICIPANTS_CHANGED:String = "hangoutBridgeParticipantsChangedEvent";
		
		private var _data:Object;
		
		public function HangoutBridgeEvent(type:String, $data:Object=null, bubbles:Boolean=false, cancelable:Boolean=false) 
		{//HangoutBridgeEvent 
			super(type, bubbles, cancelable);
			_data = $data;
			
		}//HangoutBridgeEvent
		
		public override function clone():Event 
		{ 
			return new HangoutBridgeEvent(type, data, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("HangoutBridgeEvent", "type", "data", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get data():Object {return _data;}
	}//HangoutBridgeEvent Class
	
}//Packge
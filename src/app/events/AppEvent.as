package app.events 
{//Packge
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Jake Callery
	 */
	public class AppEvent extends Event 
	{//AppEvent Class
		
		static public const APP_READY:String = "appReadyEvent";
		static public const HIDE_PAGE:String = "appHidePageEvent";
		static public const NEXT_PAGE:String = "appNextPageEvent";
		static public const CLEAR_LOG:String = "appClearLogEvent";
		
		private var _data:Object;
		
		public function AppEvent(type:String, $data:Object=null, bubbles:Boolean=false, cancelable:Boolean=false) 
		{//AppEvent 
			super(type, bubbles, cancelable);
			_data = $data;
			
		}//AppEvent
		
		public override function clone():Event 
		{ 
			return new AppEvent(type, data, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("AppEvent", "type", "data", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get data():Object {return _data;}
	}//AppEvent Class
	
}//Packge
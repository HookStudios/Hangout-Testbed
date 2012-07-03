package app.data 
{//Package
	import flash.events.EventDispatcher;
	/**
	 * ...
	 * @author Jake Callery
	 */
	public class EventCenter extends EventDispatcher
	{//EventCenter Class
	
		static private var _instance:EventCenter;
	
		public function EventCenter(singletonEnforcer:SingletonEnforcer=null) 
		{//EventCenter
			
			if(singletonEnforcer == null)
			{//error
				//Use getInstance()
				throw new Error("This is a Singleton, please use getInstance() instead of new");
			}//error
			
		}//EventCenter
		
		public static function getInstance():EventCenter
		{//getInstance
			if (EventCenter._instance == null)
			{//create first one
				EventCenter._instance = new EventCenter(new SingletonEnforcer());
			}//create first one
			
			return EventCenter._instance;
		}//getInstance
		
	}//EventCenter Class

}//Package

class SingletonEnforcer{}
package app.data 
{//Package
	import com.jac.google.hangout.HangoutBridge;
	import com.jac.google.hangout.HangoutManager;
	import com.jac.jsBridge.JSBridge;
	/**
	 * ...
	 * @author Jake Callery
	 */
	public class DataHolder 
	{//DataHolder Class
		
		static private var _instance:DataHolder;
		
		public var jsBridge:JSBridge;
		public var hangoutBridge:HangoutBridge;
		
		public var hangoutManager:HangoutManager;
		
		public var baseProto:String;
		public var baseDomain:String;
		public var basePath:String;
		public var appID:String;
		public var baseAvatarsPath:String;
		public var baseOverlaysPath:String;
		public var baseSoundsPath:String;
	
		public function DataHolder(singletonEnforcer:SingletonEnforcer=null) 
		{//DataHolder
			
			if(singletonEnforcer == null)
			{//error
				//Use getInstance()
				throw new Error("This is a Singleton, please use getInstance() instead of new");
			}//error
			
		}//DataHolder
		
		public static function getInstance():DataHolder
		{//getInstance
			if (DataHolder._instance == null)
			{//create first one
				DataHolder._instance = new DataHolder(new SingletonEnforcer());
			}//create first one
			
			return DataHolder._instance;
		}//getInstance
		
	}//DataHolder Class

}//Package

class SingletonEnforcer{}
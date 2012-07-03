package app.data 
{
	/**
	 * ...
	 * @author Jake Callery
	 */
	public class Message 
	{//Message Class
		
		public var rawObj:Object;
		public var senderID:String;
		public var message:String;
		
		public function Message($rawObj:Object=null) 
		{//Message
			if ($rawObj != null)
			{//
				rawObj = $rawObj;
				if ($rawObj.hasOwnProperty("senderId")) { senderID = $rawObj.senderId; }
				if ($rawObj.hasOwnProperty("message")) { message = $rawObj.message; }
			}//
		}//Message
		
	}//Message Class

}
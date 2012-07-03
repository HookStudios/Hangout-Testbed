package com.jac.google.hangout.data 
{
	import com.jac.log.Log;
	import com.jac.utils.ObjUtils;
	/**
	 * ...
	 * @author Jake Callery
	 */
	public class Person 
	{//Person Class
		
		public var raw:Object;
		public var id:String;
		public var displayName:String;
		public var image:Object;
		public var imageURL:String;
		
		public function Person($raw:Object) 
		{//Person
			raw = $raw;
			
			if ($raw != null)
			{//
				ObjUtils.getDynamicProps($raw);
				
				if($raw.hasOwnProperty("id")) {id = String($raw.id);}
				if($raw.hasOwnProperty("displayName")){displayName = String($raw.displayName);}
				if($raw.hasOwnProperty("image")){image = $raw.image;}
				if (image && image.hasOwnProperty("url"))
				{//
					imageURL = image.url;
				}//
				
				Log.log("New Person Created: " + displayName, "@person");
				
			}//
		}//Person
		
	}//Person Class

}
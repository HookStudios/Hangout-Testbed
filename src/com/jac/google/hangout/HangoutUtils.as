package com.jac.google.hangout 
{
	import com.jac.log.Log;
	/**
	 * ...
	 * @author Jake Callery
	 */
	public class HangoutUtils 
	{//HangoutUtils Class
		
		static public function getValueByPrefixAndID($state:Object, $prefix:String, $participantID:String):Object
		{//getValueByPrefixAndID
			for (var prop:String in $state)
			{//process each prop
				var propTokens:Array = prop.split($prefix);
				if (propTokens.length > 1)
				{//we have the prefix
					propTokens.shift();
					var id:String = propTokens.join("");
					Log.log("Checking ID: " + id + " / " + $participantID, "@tmp");
					if (id == $participantID)
					{//found it
						Log.log("Found matching id: " + $state[prop], "@tmp")
						return $state[prop];
						break;
					}//found it
				}//we have the prefix
			}//process each prop
			
			Log.logWarning("Prefix/id not found in state", "@tmp");
			return null;
		}//getValueByPrefixAndID
		
		static public function cleanIDForProp($id:String):String
		{//cleanIDForProp
			var id:String = $id.split(".").join("_");
			id = id.split("^").join("_");
			return id;
		}//cleanIDForProp
	}//HangoutUtils Class

}
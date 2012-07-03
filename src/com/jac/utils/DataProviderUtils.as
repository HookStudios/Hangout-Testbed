package com.jac.utils 
{
	import fl.data.DataProvider;
	/**
	 * ...
	 * @author Jake Callery
	 */
	public class DataProviderUtils 
	{//DataProviderUtils Class
		
		static public function findItem($dp:DataProvider, $propName:String, $valueToMatch:Object):Object
		{//findItem
			var obj:Object;
			
			for (var i:int = 0; i < $dp.length; i++) 
			{//check each
				obj = $dp.getItemAt(i);
				if (obj.hasOwnProperty($propName) && obj[$propName] == $valueToMatch)
				{//found
					return obj;
				}//found
			}//check each
			
			return null;
		}//findItem
		
	}//DataProviderUtils Class

}
package com.jac.utils
{//Package
	import com.jac.log.Log;
	import flash.display.LoaderInfo;
	import flash.display.Stage;
	/**
	 * ...
	 * @author Jake Callery
	 */
	public class WebUtils
	{//WebUtils Class
		
		static public function getVars($loaderInfo:LoaderInfo, $propNameToCheckFor:String, $defaultObj:Object):Object
		{//getVars
			var params:Object = {};
			
			if ($loaderInfo != null)
			{//
				params = $loaderInfo.parameters;
			}//
		
			if (params.hasOwnProperty($propNameToCheckFor))
			{//good
				Log.log("Using REAL Params", "@params");
				return params;
			}//good
			else
			{//default
				Log.logWarning("Using Default Params");
				return $defaultObj;
			}//default
			
		}//getVars
		
		static public function isStandAlone($loaderInfo:LoaderInfo):Boolean
		{//isStandAlone
			return $loaderInfo.loaderURL == $loaderInfo.url;
		}//isStandAlone
		
	}//WebUtils Class

}//Package
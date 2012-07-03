package com.jac.jsBridge 
{
	import com.jac.jsBridge.events.JSBridgeEvent;
	import com.jac.log.Log;
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;
	import flash.system.Capabilities;
	
	/**
	 * ...
	 * @author Jake Callery
	 */
	public class JSBridge extends EventDispatcher 
	{//JSBridge Class
		
		private var _isReady:Boolean;
		private var _bridgeName:String;
		private var _swfProp:String;
		
		public function JSBridge() 
		{//JSBridge
			_isReady = false;
		}//JSBridge
		
		public function initJS($localInit:Boolean=true, $marshallExceptions:Boolean=true):void
		{//initJS
			if (isInBrowser())
			{//call
				Log.log("Registering init callback", "@bridge");
				ExternalInterface.marshallExceptions = $marshallExceptions;
				registerJSCallback("notifyJSReady", onJSReady);
				ExternalInterface.call("initFromSwf");
			}//call
			else
			if ($localInit)
			{//manual init
				onJSReady(false);
			}//manual init
		}//initJS
		
		public function call($jsCall:IJSCall, $forceStraightCall:Boolean=false):Object
		{//
			if ($jsCall is FakeJSCall)
			{//just return
				return FakeJSCall($jsCall).result;
			}//just return
			else
			{//make call
				if (isInBrowser())
				{//real call
					var result:Object;
					
					try
					{//try
						Log.log("Trying Call: " + JSCall($jsCall).functionName, "@jsbridge");
						if ($forceStraightCall)
						{//normal call
							result = $jsCall.applyJSCall();
						}//normal call
						else
						{//array param call
							result = $jsCall.straightJSCall();
						}//arary param call
					}//try
					catch (err:Error)
					{//catch
						Log.logWarning("Caught Error From JS: " + err.errorID + " / " + err.message);
						trace("Stack: " + err.getStackTrace());
						return null;
					}//catch
					
					return result;
				}//real call
				else
				{//forced result
					return $jsCall.forcedResult;
				}//forced result
			}//make call
			
			return null;
		}//
		
		public function registerJSCallback($jsCallbackName:String, $mappedCallback:Function):void
		{//registerJSCallback
			if (ExternalInterface.available)
			{//register
				Log.log("JSBridge Registering: " + $jsCallbackName, "@bridge");
				ExternalInterface.addCallback($jsCallbackName, $mappedCallback);
			}//register
		}//registerJSCallback
		
		public function unregisterJSCallback($jsCallbackName:String, $callback:Function):void 
		{//unregisterJSCallback
			if (ExternalInterface.available)
			{//register
				Log.log("JSBridge UNRegistering: " + $jsCallbackName, "@bridge");
				ExternalInterface.addCallback($jsCallbackName, null);
			}//register
		}//unregisterJSCallback
		
		protected function onJSReady($data:Object=null):void
		{//onJSReady
			Log.log("onJSReady: " + $data.bridgeName + " / " + $data.swfProp, "@bridge");
			
			_isReady = true;
			_bridgeName = $data.bridgeName;
			_swfProp = $data.swfProp;
			
			dispatchEvent(new JSBridgeEvent(JSBridgeEvent.BRIDGE_READY, $data));
		}//onJSReady
		
		protected function isInBrowser():Boolean
		{//isInBrowser
			if (ExternalInterface.available && Capabilities.playerType != "External" && Capabilities.playerType != "StandAlone")
			{//we are in a browser
				return true;
			}//we are in a browser
			else
			{//not in browser
				return false;
			}//not in browser
		}//isInBrowser
		
		public function get bridgeName():String 
		{
			return _bridgeName;
		}
		
		public function get swfProp():String 
		{
			return _swfProp;
		}
		
		public function get isReady():Boolean 
		{
			return _isReady;
		}
		
	}//JSBridge Class

}
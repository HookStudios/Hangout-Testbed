package com.jac.google.hangout 
{
	import com.adobe.serialization.json.JSONToken;
	import com.jac.google.hangout.events.HangoutBridgeEvent;
	import com.jac.jsBridge.events.JSBridgeEvent;
	import com.jac.jsBridge.JSBridge;
	import com.jac.jsBridge.JSCall;
	import com.jac.log.Log;
	import com.jac.utils.ObjUtils;
	import flash.events.EventDispatcher;
	
	/**
	 * ...
	 * @author Jake Callery
	 */
	public class HangoutBridge extends EventDispatcher 
	{//HangoutBridge Class
		
		protected var _jsBridge:JSBridge;
		protected var _hangoutBridgeName:String;
		protected var _isReady:Boolean;
		protected var _jsName:String;
		
		public function HangoutBridge($jsName:String="hangoutBridge") 
		{//HangoutBridge
			_hangoutBridgeName = $jsName;
			_isReady = false;
		}//HangoutBridge
		
		public function getParticipants():Object
		{//getParticipants
			return callToHangout("gapi.hangout", "getParticipants");
		}//getParticipants
		
		public function enableLogging($isEnabled:Boolean):Object
		{//enableLogging
			var callStr:String = _jsBridge.bridgeName + "." + _hangoutBridgeName + "." + "enableLogging";
			var call:JSCall = new JSCall(callStr, [$isEnabled]);
			return _jsBridge.call(call, true);
		}//enableLogging
		
		public function createSound($url:String, $settingsObj:Object):Number
		{//createSound
			Log.log("Creating Sound: " + $url + " / " + ObjUtils.getDynamicProps($settingsObj), "@hb");
			var callStr:String = _jsBridge.bridgeName + "." + _hangoutBridgeName + "." + "createSound";
			var call:JSCall = new JSCall(callStr, [$url, $settingsObj]);
			return Number(_jsBridge.call(call, true));
		}//createSound
		
		public function playSound($soundID:Number):Object
		{//playSound
			var callStr:String = _jsBridge.bridgeName + "." + _hangoutBridgeName + "." + "playSound";
			var call:JSCall = new JSCall(callStr, [$soundID]);
			return _jsBridge.call(call, true);
		}//playSound
		
		public function stopSound($soundID:Number):Object
		{//playSound
			var callStr:String = _jsBridge.bridgeName + "." + _hangoutBridgeName + "." + "stopSound";
			var call:JSCall = new JSCall(callStr, [$soundID]);
			return _jsBridge.call(call, true);
		}//playSound
		
		public function getSoundVolume($soundID:Number):Object
		{//getSoundVolume
			var callStr:String = _jsBridge.bridgeName + "." + _hangoutBridgeName + "." + "getSoundVolume";
			var call:JSCall = new JSCall(callStr, [$soundID]);
			return _jsBridge.call(call, true);
		}//getSoundVolume
		
		public function setSoundVolume($soundID:Number, $volume:Number):Object
		{//setSoundVolume
			var callStr:String = _jsBridge.bridgeName + "." + _hangoutBridgeName + "." + "setSoundVolume";
			var call:JSCall = new JSCall(callStr, [$soundID, $volume]);
			return _jsBridge.call(call, true);
		}//setSoundVolume
		
		public function getIsLooped($soundID:Number):Object
		{//getIsLooped
			var callStr:String = _jsBridge.bridgeName + "." + _hangoutBridgeName + "." + "getIsLooped";
			var call:JSCall = new JSCall(callStr, [$soundID]);
			return _jsBridge.call(call, true);
		}//getIsLooped
		
		public function setSoundLoop($soundID:Number, $isLooped:Boolean):Object
		{//setSoundLoop
			var callStr:String = _jsBridge.bridgeName + "." + _hangoutBridgeName + "." + "setSoundLoop";
			var call:JSCall = new JSCall(callStr, [$soundID, $isLooped]);
			return _jsBridge.call(call, true);
		}//setSoundLoop
		
		public function createOverlay($url:String, $settingsObj:Object):Object
		{//createOverlay
			var callStr:String = _jsBridge.bridgeName + "." + _hangoutBridgeName + "." + "createOverlay";
			var call:JSCall = new JSCall(callStr, [$url, $settingsObj]);
			return _jsBridge.call(call, true);
		}//createOverlay
		
		public function showOverlay($url:String, $settingsObj:Object):Object
		{//showOverlay
			var callStr:String = _jsBridge.bridgeName + "." + _hangoutBridgeName + "." + "showOverlay";
			var call:JSCall = new JSCall(callStr, [$url, $settingsObj]);
			return _jsBridge.call(call, true);
		}//showOverlay
		
		public function hideOverlay($url:String):Object
		{//hideOverlay
			var callStr:String = _jsBridge.bridgeName + "." + _hangoutBridgeName + "." + "hideOverlay";
			var call:JSCall = new JSCall(callStr, [$url]);
			return _jsBridge.call(call, true);
		}//hideOverlay
		
		public function setOverlayPosition($url:String, $x:Number, $y:Number):Object
		{//setOverlayPosition
			var callStr:String = _jsBridge.bridgeName + "." + _hangoutBridgeName + "." + "setOverlayPosition";
			var call:JSCall = new JSCall(callStr, [$url, $x, $y]);
			return _jsBridge.call(call, true);
		}//setOverlayPosition
		
		public function setOverlayRotation($url:String, $rads:Number):Object
		{//setOverlayRotation
			var callStr:String = _jsBridge.bridgeName + "." + _hangoutBridgeName + "." + "setOverlayRotation";
			var call:JSCall = new JSCall(callStr, [$url, $rads]);
			return _jsBridge.call(call, true);
		}//setOverlayRotation
		
		public function setOverlayScale($url:String, $numberOrMagRefObject:Object):Object
		{//setOverlayScale
			var callStr:String = _jsBridge.bridgeName + "." + _hangoutBridgeName + "." + "setOverlayScale";
			var call:JSCall = new JSCall(callStr, [$url, $numberOrMagRefObject]);
			return _jsBridge.call(call, true);
		}//setOverlayScale
		
		public function getOverlayPosition($url:String):Object
		{//getOverlayPosition
			var callStr:String = _jsBridge.bridgeName + "." + _hangoutBridgeName + "." + "getOverlayPosition";
			var call:JSCall = new JSCall(callStr, [$url]);
			return _jsBridge.call(call, true);
		}//getOverlayPosition
		
		public function getOverlayRotation($url:String):Number
		{//getOverlayRotation
			var callStr:String = _jsBridge.bridgeName + "." + _hangoutBridgeName + "." + "getOverlayRotation";
			var call:JSCall = new JSCall(callStr, [$url]);
			return Number(_jsBridge.call(call, true));
		}//getOverlayRotation
		
		public function getOverlayScale($url:String):Object
		{//getOverlayScale
			var callStr:String = _jsBridge.bridgeName + "." + _hangoutBridgeName + "." + "getOverlayScale";
			var call:JSCall = new JSCall(callStr, [$url]);
			return _jsBridge.call(call, true);
		}//getOverlayScale
		
		public function getOverlayIsVisible($url:String):Boolean
		{//getOverlayIsVisible
			var callStr:String = _jsBridge.bridgeName + "." + _hangoutBridgeName + "." + "getOverlayIsVisible";
			var call:JSCall = new JSCall(callStr, [$url]);
			return Boolean(_jsBridge.call(call, true));
		}//getOverlayIsVisible
		
		public function createFaceTrackingOverlay($url:String, $settingsObj:Object):Object
		{//createFaceTrackingOverlay
			var callStr:String = _jsBridge.bridgeName + "." + _hangoutBridgeName + "." + "createFaceTrackingOverlay";
			var call:JSCall = new JSCall(callStr, [$url, $settingsObj]);
			return _jsBridge.call(call, true);
		}//createFaceTrackingOverlay
		
		public function showFaceTrackingOverlay($url:String, $settingsObj:Object):Object
		{//showFaceTrackingOverlay
			var callStr:String = _jsBridge.bridgeName + "." + _hangoutBridgeName + "." + "showFaceTrackingOverlay";
			var call:JSCall = new JSCall(callStr, [$url, $settingsObj]);
			return _jsBridge.call(call, true);
		}//showFaceTrackingOverlay
		
		public function hideFaceTrackingOverlay($url:String):Object
		{//showFaceTrackingOverlay
			var callStr:String = _jsBridge.bridgeName + "." + _hangoutBridgeName + "." + "hideFaceTrackingOverlay";
			var call:JSCall = new JSCall(callStr, [$url]);
			return _jsBridge.call(call, true);
		}//showFaceTrackingOverlay
		
		public function getFaceTrackingOverlayOffset($url:String):Object
		{//getFaceTrackingOverlayOffset
			var callStr:String = _jsBridge.bridgeName + "." + _hangoutBridgeName + "." + "getFaceTrackingOverlayOffset";
			var call:JSCall = new JSCall(callStr, [$url]);
			return _jsBridge.call(call, true);
		}//getFaceTrackingOverlayOffset
		
		public function getFaceTrackingOverlayRotateWithFace($url:String):Boolean
		{//getFaceTrackingOverlayRotateWithFace
			var callStr:String = _jsBridge.bridgeName + "." + _hangoutBridgeName + "." + "getFaceTrackingOverlayRotateWithFace";
			var call:JSCall = new JSCall(callStr, [$url]);
			return Boolean(_jsBridge.call(call, true));
		}//getFaceTrackingOverlayRotateWithFace
		
		public function getFaceTrackingOverlayRotation($url:String):Number
		{//getFaceTrackingOverlayRotation
			var callStr:String = _jsBridge.bridgeName + "." + _hangoutBridgeName + "." + "getFaceTrackingOverlayRotation";
			var call:JSCall = new JSCall(callStr, [$url]);
			return Number(_jsBridge.call(call, true));
		}//getFaceTrackingOverlayRotation
		
		public function getFaceTrackingOverlayScale($url:String):Number
		{//getFaceTrackingOverlayScale
			var callStr:String = _jsBridge.bridgeName + "." + _hangoutBridgeName + "." + "getFaceTrackingOverlayScale";
			var call:JSCall = new JSCall(callStr, [$url]);
			return Number(_jsBridge.call(call, true));
		}//getFaceTrackingOverlayScale
		
		public function getFaceTrackingOverlayScaleWithFace($url:String):Boolean
		{//getFaceTrackingOverlayScaleWithFace
			var callStr:String = _jsBridge.bridgeName + "." + _hangoutBridgeName + "." + "getFaceTrackingOverlayScaleWithFace";
			var call:JSCall = new JSCall(callStr, [$url]);
			return Boolean(_jsBridge.call(call, true));
		}//getFaceTrackingOverlayScaleWithFace
		
		public function getFaceTrackingOverlayTrackingFeature($url:String):Object
		{//getFaceTrackingOverlayTrackingFeature
			var callStr:String = _jsBridge.bridgeName + "." + _hangoutBridgeName + "." + "getFaceTrackingOverlayTrackingFeature";
			var call:JSCall = new JSCall(callStr, [$url]);
			return _jsBridge.call(call, true);
		}//getFaceTrackingOverlayTrackingFeature
		
		public function getFaceTrackingOverlayIsVisible($url:String):Boolean
		{//getFaceTrackingOverlayIsVisible
			var callStr:String = _jsBridge.bridgeName + "." + _hangoutBridgeName + "." + "getFaceTrackingOverlayIsVisible";
			var call:JSCall = new JSCall(callStr, [$url]);
			return Boolean(_jsBridge.call(call, true));
		}//getFaceTrackingOverlayIsVisible
		
		public function setFaceTrackingOverlayOffset($url:String, $x:Number, $y:Number):Object
		{//setFaceTrackingOverlayOffset
			var callStr:String = _jsBridge.bridgeName + "." + _hangoutBridgeName + "." + "setFaceTrackingOverlayOffset";
			var call:JSCall = new JSCall(callStr, [$url, $x, $y]);
			return _jsBridge.call(call, true);
		}//setFaceTrackingOverlayOffset
		
		public function setFaceTrackingOverlayRotateWithFace($url:String, $shouldRotate:Boolean):Object
		{//setFaceTrackingOverlayRotateWithFace
			var callStr:String = _jsBridge.bridgeName + "." + _hangoutBridgeName + "." + "setFaceTrackingOverlayRotateWithFace";
			var call:JSCall = new JSCall(callStr, [$url, $shouldRotate]);
			return _jsBridge.call(call, true);
		}//setFaceTrackingOverlayRotateWithFace
		
		public function setFaceTrackingOverlayRotation($url:String, $radians:Number):Object
		{//setFaceTrackingOverlayRotation
			var callStr:String = _jsBridge.bridgeName + "." + _hangoutBridgeName + "." + "setFaceTrackingOverlayRotation";
			var call:JSCall = new JSCall(callStr, [$url, $radians]);
			return _jsBridge.call(call, true);
		}//setFaceTrackingOverlayRotation
		
		public function setFaceTrackingOverlayScale($url:String, $scale:Number):Object
		{//setFaceTrackingOverlayScale
			var callStr:String = _jsBridge.bridgeName + "." + _hangoutBridgeName + "." + "setFaceTrackingOverlayScale";
			var call:JSCall = new JSCall(callStr, [$url, $scale]);
			return _jsBridge.call(call, true);
		}//setFaceTrackingOverlayScale
		
		public function setFaceTrackingOverlayScaleWithFace($url:String, $shouldScale:Boolean):Object
		{//setFaceTrackingOverlayScaleWithFace
			var callStr:String = _jsBridge.bridgeName + "." + _hangoutBridgeName + "." + "setFaceTrackingOverlayScaleWithFace";
			var call:JSCall = new JSCall(callStr, [$url, $shouldScale]);
			return _jsBridge.call(call, true);
		}//setFaceTrackingOverlayScaleWithFace
		
		public function setFaceTrackingOverlayFeature($url:String, $feature:String):Object
		{//setFaceTrackingOverlayFeature
			var callStr:String = _jsBridge.bridgeName + "." + _hangoutBridgeName + "." + "setFaceTrackingOverlaySetFeature";
			var call:JSCall = new JSCall(callStr, [$url, $feature]);
			return _jsBridge.call(call, true);
		}//setFaceTrackingOverlayFeature
		
		public function setFaceTrackingOverlayVisible($url:String, $isVisible:Boolean):Object
		{//setFaceTrackingOverlayVisible
			var callStr:String = _jsBridge.bridgeName + "." + _hangoutBridgeName + "." + "setFaceTrackingOverlayVisible";
			var call:JSCall = new JSCall(callStr, [$url, $isVisible]);
			return _jsBridge.call(call, true);
		}//setFaceTrackingOverlayVisible
		
		public function createAudioResource($url:String):Object
		{//createAudioResource
			Log.log("Createing Audio REsource: " + $url, "@hb");
			var callStr:String = _jsBridge.bridgeName + "." + _hangoutBridgeName + "." + "createAudioResource";
			var call:JSCall = new JSCall(callStr, [$url]);
			return _jsBridge.call(call, true);
		}//createAudioResource
		
		public function createImageResource($url:String):Object
		{//createImageResource
			var callStr:String = _jsBridge.bridgeName + "." + _hangoutBridgeName + "." + "createImageResource";
			var call:JSCall = new JSCall(callStr, [$url]);
			return _jsBridge.call(call, true);
		}//createImageResource
		
		public function callOnBridge($functionName:String, ...$params):Object
		{//callOnBridge
			var callStr:String = _jsBridge.bridgeName + "." + _hangoutBridgeName + "." + $functionName;
			var call:JSCall = new JSCall(callStr, [$functionName].concat($params));
			return _jsBridge.call(call, true);
		}//callOnBridge
		
		public function callToHangout($package:String, $functionName:String, ...$params):Object
		{//callToHangout
			var callStr:String = _jsBridge.bridgeName + "." + _hangoutBridgeName + "." + "callOnHangout";
			var call:JSCall = new JSCall(callStr, [$package, [$functionName].concat($params as Array)]);
			return _jsBridge.call(call, true);
		}//callToHangout
		
		public function addListenerToHangout($packageName:String, $eventName:String, $callbackName:String, $callback:Function, $passBackPropertyName:String=""):void
		{//addHangoutListener
			Log.log("Adding Hangout Listener: " + $packageName + "." + $eventName + " / " + $callbackName, "@hangout");
			
			//Register new callback
			_jsBridge.registerJSCallback($callbackName, $callback);
			
			var callStr:String = _jsBridge.bridgeName + "." + _hangoutBridgeName + "." + "addHangoutListener";
			var params:String = $packageName + "," + $eventName + "," + $callbackName + "," + $passBackPropertyName;
			var call:JSCall = new JSCall(callStr, params.split(","));
			_jsBridge.call(call, true);
			
		}//addHangoutListener
		
		public function removeListenerFromHangout($packageName:String, $eventName:String, $callbackName:String, $callback:Function, $passBackPropertyName:String = "", $unregisterCallback:Boolean=true):void
		{//removeListenerFromHangout
			Log.log("Removing Hangout Listener: " + $packageName + "." + $eventName + " / " + $callbackName, "@hangout");
			
			//Unregister JS callback
			if ($unregisterCallback)
			{//
				_jsBridge.unregisterJSCallback($callbackName, $callback);
			}//
			
			var callStr:String = _jsBridge.bridgeName + "." + _hangoutBridgeName + "." + "removeHangoutListener";
			var params:String = $packageName + "," + $eventName + "," + $callbackName + "," + $passBackPropertyName;
			var call:JSCall = new JSCall(callStr, params.split(","));
			_jsBridge.call(call, true);
		}//removeListenerFromHangout
		
		public function init($jsBridge:JSBridge):void
		{//init
			_jsBridge = $jsBridge;
			
			if (_jsBridge.isReady)
			{//ready now
				handleJSBridgeReady();
			}//ready now
			else
			{//wait
				_jsBridge.addEventListener(JSBridgeEvent.BRIDGE_READY, handleJSBridgeReady);
			}//wait
			
		}//init
		
		protected function handleJSBridgeReady(e:JSBridgeEvent=null):void 
		{//handleJSBridgeReady
			Log.log("Hangout Bridge, caught JSBridgeReady", "@hangout");
			
			_isReady = true;
			dispatchEvent(new HangoutBridgeEvent(HangoutBridgeEvent.READY));
			
		}//handleJSBridgeReady
		
		protected function onTestHangoutBridge():void 
		{//onTestHangoutBridge
			Log.log("Caught on test HangoutBridge", "@hangout");
		}//onTestHangoutBridge
		
		public function get isReady():Boolean 
		{
			return _isReady;
		}
		
		public function get jsName():String 
		{
			return _jsName;
		}
		
		public function get isLoggingEnabled():Boolean 
		{
			var callStr:String = _jsBridge.bridgeName + "." + _hangoutBridgeName + "." + "isLoggingEnabled";
			var call:JSCall = new JSCall(callStr);
			return _jsBridge.call(call, true);
		}
		
	}//HangoutBridge Class

}
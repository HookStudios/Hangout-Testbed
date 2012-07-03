package com.jac.google.hangout 
{
	import com.jac.google.hangout.data.Participant;
	import com.jac.google.hangout.events.HangoutBridgeEvent;
	import com.jac.google.hangout.events.HangoutManagerEvent;
	import com.jac.log.Log;
	import com.jac.utils.ObjUtils;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * ...
	 * @author Jake Callery
	 */
	public class HangoutManager extends EventDispatcher 
	{//HangoutManager Class
		
		private var _hb:HangoutBridge;
		private var _enabledParticipants:Vector.<Participant>;
		private var _participants:Vector.<Participant>;
		private var _isReady:Boolean;
		private var _myParticipantID:String;
		
		public function HangoutManager($hangoutBridge:HangoutBridge) 
		{//HangoutManager
			_hb = $hangoutBridge;
			_participants = new Vector.<Participant>();
			_enabledParticipants = new Vector.<Participant>();
			_isReady = false;
			_myParticipantID = "";
			
			if (_hb.isReady)
			{//init
				handleBridgeReady();
			}//init
			else
			{//wait
				_hb.addEventListener(HangoutBridgeEvent.READY, handleBridgeReady);
			}//wait
		}//HangoutManager
		
		private function init():void
		{//init
			Log.log("Hangout Manager Ready", "@hm");
			
			//Get initial participants
			var result:Object = callOnHangout("getParticipants")
			Log.log("Result: \n" + result, "@hm");
			
			var parts:Array = (result as Array);
			
			if (parts)
			{//we have participants
				Log.log("We have Participants: " + parts.length, "@hm");
				for (var i:int = 0; i < parts.length; i++) 
				{//populate
					var p:Participant = new Participant(parts[i]);
					_participants.push(p);
					
					if (p.hasAppEnabled)
					{//enabled
						_enabledParticipants.push(p);
					}//enabled
				}//populate
			}//we have participants
			
			
			//Add listeners
			_hb.addListenerToHangout("gapi.hangout", "onEnabledParticipantsChanged", "handleEnabledParticipantsChanged", handleEnabledParticipantsChanged);
			_hb.addListenerToHangout("gapi.hangout","onParticipantsEnabled", "handleParticipantsEnabled", handleParticipantsEnabled);
			_hb.addListenerToHangout("gapi.hangout","onParticipantsDisabled", "handleParticipantsDisabled", handleParticipantsDisabled);
			_hb.addListenerToHangout("gapi.hangout","onParticipantsChanged", "handleParticipantsChanged", handleParticipantsChanged);
			_hb.addListenerToHangout("gapi.hangout","onParticipantsAdded", "handleParticipantsAdded", handleParticipantsAdded);
			_hb.addListenerToHangout("gapi.hangout","onParticipantsRemoved", "handleParticipantsRemoved", handleParticipantsRemoved);
			_hb.addListenerToHangout("gapi.hangout","onAppVisible", "handleAppVisible", handleAppVisible);
			_hb.addListenerToHangout("gapi.hangout","onPublicChanged", "handlePublicChanged", handlePublicChanged);
			
			_hb.addListenerToHangout("gapi.hangout.av","onVolumesChanged", "handleVolumesChanged", handleVolumesChanged);
			_hb.addListenerToHangout("gapi.hangout.av","onCameraMute", "handleCameraMuteChanged", handleCameraMuteChanged);
			_hb.addListenerToHangout("gapi.hangout.av","onHasCamera", "handleHasCameraChanged", handleHasCameraChanged);
			_hb.addListenerToHangout("gapi.hangout.av","onHasMicrophone", "handleHasMicChanged", handleHasMicChanged);
			_hb.addListenerToHangout("gapi.hangout.av","onHasSpeakers", "handleHasSpeakersChanged", handleHasSpeakersChanged);
			_hb.addListenerToHangout("gapi.hangout.av","onMicrophoneMute", "handleMicMuteChanged", handleMicMuteChanged);
			
			_hb.addListenerToHangout("gapi.hangout.av.effects", "onFaceTrackingDataChanged", "handleFaceTrackingDataChanged", handleFaceTrackingDataChanged);
			
			_hb.addListenerToHangout("gapi.hangout.data", "onStateChanged", "handleStateChange", handleStateChanged);
			_hb.addListenerToHangout("gapi.hangout.data", "onMessageReceived", "handleMessageReceived", handleMessageReceived);
			
			_hb.addListenerToHangout("gapi.hangout.layout", "onChatPaneVisible", "handleChatPaneVisible", handleChatPaneVisible);
			_hb.addListenerToHangout("gapi.hangout.layout", "onHasNotice", "handleHasNotice", handleHasNotice);
			
			_hb.addListenerToHangout("gapi.hangout.onair", "onBroadcastingChanged", "handleBroadcastingChanged", handleBroadcastingChanged);
			
			
			_myParticipantID = String(callOnHangout("getParticipantId"));
			
			
			_isReady = true;
			dispatchEvent(new HangoutManagerEvent(HangoutManagerEvent.READY, this));
		}//init
		
		public function addListenerToHangout($packageName:String, $eventName:String, $callbackName:String, $callback:Function, $passBackPropertyName:String = ""):void
		{//addListenerToHangout
			_hb.addListenerToHangout($packageName, $eventName, $callbackName, $callback, $passBackPropertyName);
		}//addListenerToHangout
		
		public function removeListenerFromHangout($packageName:String, $eventName:String, $callbackName:String, $callback:Function, $passBackPropertyName:String = "", $unregisterCallback:Boolean=true):void
		{//removeListenerFromHangout
			_hb.removeListenerFromHangout($packageName, $eventName, $callbackName, $callback, $passBackPropertyName, $unregisterCallback);
		}//removeListenerFromHangout
		
		public function callOnHangoutEffects($functionName:String, ...$params):Object
		{//callOnHangoutEffects
			if (_hb.isReady)
			{//call
				return _hb.callToHangout.apply(null, ["gapi.hangout.av.effects", $functionName].concat($params));
			}//call
			else
			{//not ready
				Log.logWarning("Call on HangoutEffects failed, HanoutBridge is not ready", "@hm");
				return null;
			}//not ready
		}//callOnHangoutEffects
		
		public function callOnHangoutAV($functionName:String, ...$params):Object
		{//callOnHangoutAV
			if (_hb.isReady)
			{//call
				return _hb.callToHangout.apply(null, ["gapi.hangout.av", $functionName].concat($params));
			}//call
			else
			{//not ready
				Log.logWarning("Call on HangoutAV failed, HanoutBridge is not ready", "@hm");
				return null;
			}//not ready
		}//callOnHangoutAV
		
		public function callOnHangoutData($functionName:String, ...$params):Object
		{//callOnHangoutData
			if (_hb.isReady)
			{//call
				return _hb.callToHangout.apply(null, ["gapi.hangout.data", $functionName].concat($params));
			}//call
			else
			{//not ready
				Log.logWarning("Call on HangoutData failed, HanoutBridge is not ready", "@hm");
				return null;
			}//not ready
		}//callOnHangoutData
		
		public function callOnHangoutLayout($functionName:String, ...$params):Object
		{//callOnHangoutLayout
			if (_hb.isReady)
			{//call
				return _hb.callToHangout.apply(null, ["gapi.hangout.layout", $functionName].concat($params));
			}//call
			else
			{//not ready
				Log.logWarning("Call on HangoutLayout failed, HanoutBridge is not ready", "@hm");
				return null;
			}//not ready
		}//callOnHangoutLayout
		
		public function callOnHangoutOnAir($functionName:String, ...$params):Object
		{//callOnHangoutOnAir
			if (_hb.isReady)
			{//call
				return _hb.callToHangout.apply(null, ["gapi.hangout.onair", $functionName].concat($params));
			}//call
			else
			{//not ready
				Log.logWarning("Call on Hangout On Air failed, HanoutBridge is not ready", "@hm");
				return null;
			}//not ready
		}//callOnHangoutOnAir
		
		public function callOnHangout($functionName:String, ...$params):Object
		{//callOnHangout
			if (_hb.isReady)
			{//call
				return _hb.callToHangout.apply(null, ["gapi.hangout", $functionName].concat($params));
			}//call
			else
			{//not ready
				Log.logWarning("Call on Hangout failed, HanoutBridge is not ready", "@hm");
				return null;
			}//not ready
		}//callOnHangout
		
		public function createSound($url:String, $settingsObj:Object = null):Number
		{//createSound
			if ($settingsObj == null) { $settingsObj = { }; }
			return Number(_hb.createSound($url, $settingsObj));
		}//createSound
		
		public function playSound($soundID:Number):Object
		{//playSound
			return _hb.playSound($soundID);
		}//playSound
		
		public function stopSound($soundID:Number):Object
		{//stopSound
			return _hb.stopSound($soundID);
		}//stopSound
		
		public function getSoundVolume($soundID:Number):Object
		{//getSoundVolume
			return _hb.getSoundVolume($soundID);
		}//getSoundVolume
		
		public function getIsLooped($soundID:Number):Object
		{//getIsLooped
			return _hb.getIsLooped($soundID);
		}//getIsLooped
		
		public function setSoundLoop($soundID:Number, $isLooped:Boolean):Object
		{//setSoundLoop
			return _hb.setSoundLoop($soundID, $isLooped);
		}//setSoundLoop
		
		public function setSoundVolume($soundID:Number, $volume:Number):Object
		{//setSoundVolume
			return _hb.setSoundVolume($soundID, $volume);
		}//setSoundVolume
		
		public function createOverlay($url:String, $settingsObj:Object=null):Object
		{//createOverlay
			if ($settingsObj == null) { $settingsObj = { }; }
			return _hb.createOverlay($url, $settingsObj);
		}//createOverlay
		
		public function showOverlay($url:String, $settingsObj:Object=null):Object
		{//showOverlay
			if ($settingsObj == null) { $settingsObj = { }; }
			return _hb.showOverlay($url, $settingsObj);
		}//showOverlay
		
		public function hideOverlay($url:String):Object
		{//hideOverlay
			return _hb.hideOverlay($url);
		}//hideOverlay
		
		public function getOverlayPosition($url:String):Object
		{//getOverlayPosition
			return _hb.getOverlayPosition($url);
		}//getOverlayPosition
		
		public function getOverlayRotation($url:String):Number
		{//getOverlayRotation
			return _hb.getOverlayRotation($url);
		}//getOverlayRotation
		
		public function getOverlayScale($url:String):Object
		{//getOverlayScale
			return _hb.getOverlayScale($url);
		}//getOverlayScale
		
		public function getOverlayIsVisible($url:String):Boolean
		{//getOverlayIsVisible
			return _hb.getOverlayIsVisible($url);
		}//getOverlayIsVisible
		
		public function setOverlayPosition($url:String, $x:Number, $y:Number):Object
		{//setOverlayPosition
			return _hb.setOverlayPosition($url, $x, $y);
		}//estOverlayPosition
		
		public function setOverlayRotation($url:String, $rads:Number):Object
		{//setOverlayRotation
			return _hb.setOverlayRotation($url, $rads);
		}//estOverlayRotation
		
		public function setOverlayScale($url:String, $numOrMagRefObject:Object):Object
		{//setOverlayScale
			return _hb.setOverlayScale($url, $numOrMagRefObject);
		}//setOverlayScale
		
		public function createFaceTrackingOverlay($url:String, $settingsObj:Object=null):Object
		{//createFaceTrackingOverlay
			if ($settingsObj == null) { $settingsObj = { }; }
			return _hb.createFaceTrackingOverlay($url, $settingsObj);
		}//createFaceTrackingOverlay
		
		public function showFaceTrackingOverlay($url:String, $settingsObj:Object=null):Object
		{//showFaceTrackingOverlay
			if ($settingsObj == null) { $settingsObj = { }; }
			return _hb.showFaceTrackingOverlay($url, $settingsObj);
		}//showFaceTrackingOverlay
		
		public function hideFaceTrackingOverlay($url:String):Object
		{//hideFaceTrackingOverlay
			return _hb.hideFaceTrackingOverlay($url);
		}//hideFaceTrackingOverlay
		
		public function getFaceTrackingOverlayOffset($url:String):Object
		{//getFaceTrackingOverlayOffset
			return _hb.getFaceTrackingOverlayOffset($url);
		}//getFaceTrackingOverlayOffset
		
		public function getFaceTrackingOverlayRotateWithFace($url:String):Boolean
		{//getFaceTrackingOverlayRotateWithFace
			return _hb.getFaceTrackingOverlayRotateWithFace($url);
		}//getFaceTrackingOverlayRotateWithFace
		
		public function getFaceTrackingOverlayRotation($url:String):Number
		{//getFaceTrackingOverlayRotation
			return _hb.getFaceTrackingOverlayRotation($url);
		}//getFaceTrackingOverlayRotation
		
		public function getFaceTrackingOverlayScale($url:String):Number
		{//getFaceTrackingOverlayScale
			return _hb.getFaceTrackingOverlayScale($url);
		}//getFaceTrackingOverlayScale
		
		public function getFaceTrackingOverlayScaleWithFace($url:String):Boolean
		{//getFaceTrackingOverlayScaleWithFace
			return _hb.getFaceTrackingOverlayScaleWithFace($url);
		}//getFaceTrackingOverlayScaleWithFace
		
		public function getFaceTrackingOverlayTrackingFeature($url:String):Object
		{//getFaceTrackingOverlayTrackingFeature
			return _hb.getFaceTrackingOverlayTrackingFeature($url);
		}//getFaceTrackingOverlayTrackingFeature
		
		public function getFaceTrackingOverlayIsVisible($url:String):Boolean
		{//getFaceTrackingOverlayIsVisible
			return _hb.getFaceTrackingOverlayIsVisible($url);
		}//getFaceTrackingOverlayIsVisible
		
		public function setFaceTrackingOverlayOffset($url:String, $x:Number, $y:Number):Object
		{//setFaceTrackingOverlayOffset
			return _hb.setFaceTrackingOverlayOffset($url, $x, $y);
		}//setFaceTrackingOverlayOffset
		
		public function setFaceTrackingOverlayRotateWithFace($url:String, $shouldRotate:Boolean):Object
		{//setFaceTrackingOverlayRotateWithFace
			return _hb.setFaceTrackingOverlayRotateWithFace($url, $shouldRotate);
		}//setFaceTrackingOverlayRotateWithFace
		
		public function setFaceTrackingOverlayRotation($url:String, $radians:Number):Object
		{//setFaceTrackingOverlayRotation
			return _hb.setFaceTrackingOverlayRotation($url, $radians);
		}//setFaceTrackingOverlayRotation
		
		public function setFaceTrackingOverlayScale($url:String, $scale:Number):Object
		{//setFaceTrackingOverlayScale
			return _hb.setFaceTrackingOverlayScale($url, $scale);
		}//setFaceTrackingOverlayScale
		
		public function setFaceTrackingOverlayScaleWithFace($url:String, $shouldScale:Boolean):Object
		{//setFaceTrackingOverlayScaleWithFace
			return _hb.setFaceTrackingOverlayScaleWithFace($url, $shouldScale);
		}//setFaceTrackingOverlayScaleWithFace
		
		public function setFaceTrackingOverlayFeature($url:String, $feature:String):Object
		{//setFaceTrackingOverlayFeature
			return _hb.setFaceTrackingOverlayFeature($url, $feature);
		}//setFaceTrackingOverlayFeature
		
		public function setFaceTrackingOverlayVisible($url:String, $isVisible:Boolean):Object
		{//setFaceTrackingOverlayVisible
			return _hb.setFaceTrackingOverlayVisible($url, $isVisible);
		}//setFaceTrackingOverlayVisible
		
		public function createAudioResource($url:String):Object
		{//createSoundResource
			return _hb.createAudioResource($url);
		}//createSoundResource
		
		public function createImageResource($url:String):Object
		{//createImageResource
			return _hb.createImageResource($url);
		}//createImageResource
		
		public function forceLocalMic($isTrue:Boolean):void
		{//forceLocalMic
			callOnHangoutAV("setMicrophoneMute", $isTrue);
		}//forceLocalMic
		
		public function muteLocalMic():void
		{//muteLocalMic
			callOnHangoutAV("setMicrophoneMute", true);
		}//muteLocalMic
		
		public function unmuteLocalMic():void
		{//unmuteLocalMic
			callOnHangoutAV("setMicrophoneMute", false);
		}//unmuteLocalMic
		
		public function getMicMute():Boolean
		{//getLocalMicMute
			return Boolean(callOnHangoutAV("getMicrophoneMute"));
		}//getLocalMicMute
		
		public function clearMicMute():Object
		{//clearMicMute
			return callOnHangoutAV("clearMicrophoneMute");
		}//clearMicMute
		
		public function getVolumes():Object
		{//getVolumes
			return callOnHangoutAV("getVolumes");
		}//getVolumes
		
		public function getState():Object
		{//getState
			return callOnHangoutData("getState");
		}//getState
		
		public function getStateMetadata():Object
		{//getSatateMetadata
			return callOnHangoutData("getStateMetadata");
		}//getStateMetadata
		
		public function clearValue($key:String):void
		{//clearValue
			callOnHangoutData("clearValue", $key);
		}//clearValue
		
		public function getKeys():Object
		{//getKeys
			return callOnHangoutData("getKeys");
		}//getKeys
		
		public function getValue($key:String):Object
		{//getvalue
			return callOnHangoutData("getValue", $key);
		}//getValue
		
		public function setValue($key:String, $value:String):void
		{//setValue
			callOnHangoutData("setValue", $key, $value);
		}//setValue
		
		public function submitDelta($updates:Object, $removals:Array=null):void
		{//submitDelta
			if ($removals == null) { $removals = []; }
			Log.log("UPDATE BUNDLE: " + ObjUtils.getDynamicProps($updates), "@hm");
			callOnHangoutData("submitDelta", $updates, $removals);
		}//submitDelta
		
		public function sendMessage($message:String):void
		{//sendMessage
			callOnHangoutData("sendMessage", $message);
		}//sendMessage
		
		public function getStartData():String
		{//getStartData
			return callOnHangout("getStartData").toString();
		}//getStartData
		
		public function getLocale():String
		{//getLocale
			return callOnHangout("getLocale").toString();
		}//getLocale
		
		public function getHangoutId():String
		{//getHangoutId
			return callOnHangout("getHangoutId").toString();
		}//getHangoutID
		
		public function clearAvatar($participantID:String):Object
		{//clearAvatar
			return callOnHangoutAV("clearAvatar", $participantID);
		}//clearAvatar
		
		public function getParticipantAudioLevel($participantID:String):Object
		{//getParticipantAudioLevel
			return callOnHangoutAV("getParticipantAudioLevel", $participantID);
		}//getParticipantAudioLevel
		
		public function getAvatar($participantID:String):String
		{//getAvatar
			return String(callOnHangoutAV("getAvatar", $participantID));
		}//getAvatar
		
		public function getParticipantVolume($participantID:String):Number
		{//getParticipantVolume
			return Number(callOnHangoutAV("getParticipantVolume", $participantID));
		}//getParticipantVolume
		
		public function getCameraMute():Boolean
		{//getCameraMute
			return callOnHangoutAV("getCameraMute");
		}//getCameraMute
		
		public function isParticipantAudible($participantID:String):Boolean
		{//isParticipantAudible
			return Boolean(callOnHangoutAV("isParticipantAudible"));
		}//isParticipantAudible
		
		public function isParticipantVisible($participantID:String):Boolean
		{//isParticipantVisible
			return Boolean(callOnHangoutAV("isParticipantVisible"));
		}//isParticipantVisible
		
		public function setParticipantAudioLevel($participantID:String, $audioLevel:Number):Object
		{//setParticipantAudioLevel
			return callOnHangoutAV("setParticipantAudioLevel", $participantID, $audioLevel);
		}//setParticipantAudioLevel
		
		public function setAvatar($participantID:String, $imageUrl:String):Object
		{//setAvatar
			return callOnHangoutAV("setAvatar", $participantID, $imageUrl);
		}//setAvatar
		
		public function setMicMute($isMuted:Boolean):Object 
		{//setMicMute
			return callOnHangoutAV("setMicrophoneMute", $isMuted);
		}//setMicMute
		
		public function setCameraMute($isMuted:Boolean):Object
		{//setCameraMute
			return callOnHangoutAV("setCameraMute", $isMuted);
		}//setCameraMute
		
		public function clearCameraMute():Object
		{//clearCameraMute
			return callOnHangoutAV("clearCameraMute");
		}//clearCameraMute
		
		public function setParticipantAudible($participantID:String, $isAudible:Boolean):Object
		{//setParticipantAudible
			return callOnHangoutAV("setParticipantAudible", $participantID, $isAudible);
		}//setParticipantAudible
		
		public function setParticipantVisible($participantID:String, $isVisible:Boolean):Object
		{//setParticipantVisible
			return callOnHangoutAV("setParticipantVisible", $participantID, $isVisible);
		}//setParticipantVisible
		
		public function requestParticipantMicMute($participantID:String):Object
		{//requestParticipantMicMute
			return callOnHangoutAV("requestParticipantMicrophoneMute", $participantID);
		}//requestParticipantMicMute
		
		private function handleMicMuteChanged($data:Object):void 
		{//handleMicMuteChanged
			dispatchEvent(new HangoutManagerEvent(HangoutManagerEvent.MIC_MUTE_CHANGED, $data));
		}//handleMicMuteChanged
		
		private function handleHasSpeakersChanged($data:Object):void 
		{//handleHasSpeakersChanged
			dispatchEvent(new HangoutManagerEvent(HangoutManagerEvent.HAS_SPEAKERS_CHANGED, $data));
		}//handleHasSpeakersChanged
		
		private function handleHasMicChanged($data:Object):void 
		{//handleHasMicChanged
			dispatchEvent(new HangoutManagerEvent(HangoutManagerEvent.HAS_MIC_CHANGED, $data));
		}//handleHasMicChanged
		
		private function handleHasCameraChanged($data:Object):void 
		{//handleHasCameraChanged
			dispatchEvent(new HangoutManagerEvent(HangoutManagerEvent.HAS_CAMERA_CHANGED, $data));
		}//handleHasCameraChanged
		
		private function handleCameraMuteChanged($data:Object):void 
		{//handleCameraMuteChanged
			dispatchEvent(new HangoutManagerEvent(HangoutManagerEvent.CAMERA_MUTE_CHANGED, $data));
		}//handleCameraMuteChanged
		
		private function handleAppVisible($data:Object):void 
		{//handleAppVisible
			dispatchEvent(new HangoutManagerEvent(HangoutManagerEvent.APP_VISIBLE_CHANGED, $data));
		}//handleAppVisible
		
		private function handlePublicChanged($data:Object):void 
		{//handlePublicChanged
			dispatchEvent(new HangoutManagerEvent(HangoutManagerEvent.PUBLIC_CHANGED, $data));
		}//handlePublicChanged
		
		private function handleVolumesChanged($data:Object):void 
		{//handleVolumesChanged
			dispatchEvent(new HangoutManagerEvent(HangoutManagerEvent.VOLUMES_CHANGED, $data));
		}//handleVolumesChanged

		private function handleFaceTrackingDataChanged($data:Object):void 
		{//handleFaceTrackingDataChanged
			//Log.log("Face Tracking Data Changed", "@hm");
			dispatchEvent(new HangoutManagerEvent(HangoutManagerEvent.FACE_TRACKING_DATA_CHANGED, $data));
		}//handleFaceTrackingDataChanged
		
		private function handleParticipantsChanged($data:Object):void
		{//handleParticipantsChanged
			Log.log("Caught Participants Changed: " + $data, "@hm");
			dispatchEvent(new HangoutManagerEvent(HangoutManagerEvent.PARTICIPANTS_CHANGED, _participants));
		}//handleParticipantsChanged
		
		private function handleParticipantsAdded($data:Object):void
		{//handleParticipantsAdded
			Log.log("Caught Participants Added: " + $data, "@hm");
			Log.log(ObjUtils.getDynamicProps($data));
			
			var parts:Array = ($data.addedParticipants as Array);
			Log.log("PARTICIPANTS: " + parts + " / " + parts.length, "@hm");
			if (parts)
			{//good
				for (var i:int = 0; i < parts.length; i++) 
				{//add
					addParticipantIfNotDup(_participants, new Participant(parts[i]));
				}//add
			}//good
			
			dispatchEvent(new HangoutManagerEvent(HangoutManagerEvent.PARTICIPANTS_ADDED, _participants));
			
		}//handleParticiapantsAdded
		
		private function handleParticipantsRemoved($data:Object):void
		{//handleParticipantsRemoved
			Log.log("Caught Participants Removed: " + $data + " / " + _participants.length, "@hm");
			
			var parts:Array = ($data.removedParticipants  as Array);
			if (parts)
			{//
				for (var i:int = 0; i < parts.length; i++) 
				{//
					removeParticipantByID(_participants, parts[i].id);
				}//
			}//
			
			dispatchEvent(new HangoutManagerEvent(HangoutManagerEvent.PARTICIPANTS_REMOVED, _participants));
			
		}//handleParticpantsRemoved
		
		private function handleEnabledParticipantsChanged($data:Object):void
		{//handleEnabledParticipantsChanged
			Log.log("Caught Enabled Participants Changed: " + $data, "@hm");
			dispatchEvent(new HangoutManagerEvent(HangoutManagerEvent.ENABLED_PARTICIPANTS_CHANGED, _enabledParticipants));
		}//handleEnabledParticipantsChanged
		
		private function handleParticipantsEnabled($data:Object):void
		{//handleParticipantsEnabled
			Log.log("Caught Participants Enabled" + $data, "@hm");
			
			var parts:Array = ($data.enabledParticipants as Array);
			if (parts)
			{//good
				for (var i:int = 0; i < parts.length; i++) 
				{//add
					addParticipantIfNotDup(_enabledParticipants, new Participant(parts[i]));
				}//add
			}//good
			
			dispatchEvent(new HangoutManagerEvent(HangoutManagerEvent.PARTICIPANTS_ENABLED, _enabledParticipants));
			
		}//handleParticipantsEnabled
		
		private function handleParticipantsDisabled($data:Object):void
		{//handleParticipantsDisabled
			Log.log("Caught Participants Disabled: " + $data, "@hm");
			
			var disabledParticipants:Vector.<Participant> = new Vector.<Participant>();
			
			var parts:Array = ($data.disabledParticipants as Array);
			if (parts)
			{//
				for (var i:int = 0; i < parts.length; i++) 
				{//
					var partToRemove:Participant = new Participant(parts[i]);
					Log.log("Caught Participant To Remove: " + partToRemove, "@hm");
					if (partToRemove) { Log.log(partToRemove.id, "@hm");}
					disabledParticipants.push(partToRemove);
					removeParticipantByID(_enabledParticipants, parts[i].id);
				}//
			}//
			
			dispatchEvent(new HangoutManagerEvent(HangoutManagerEvent.PARTICIPANTS_DISABLED, disabledParticipants));
			
		}//handleParticipantsDisabled
		
		private function handleHasNotice($data:Object):void 
		{//handleHasNotice
			Log.log("Caught Has Notice: " + ObjUtils.getDynamicProps($data), "@hm");
			dispatchEvent(new HangoutManagerEvent(HangoutManagerEvent.HAS_NOTICE, $data));
		}//handleHasNotice
		
		private function handleChatPaneVisible($data:Object):void 
		{//handleChatPaneVisible
			Log.log("Caught Chat Pane Visible: " + ObjUtils.getDynamicProps($data), "@hm");
			dispatchEvent(new HangoutManagerEvent(HangoutManagerEvent.CHAT_PANE_VISIBLE, $data));
		}//handleChatPaneVisible
		
		private function handleStateChanged($data:Object):void 
		{//handleStateChanged
			Log.log("---------------- Caught State Changed", "@hm");
			Log.log(ObjUtils.getDynamicProps($data), "@hm");
			dispatchEvent(new HangoutManagerEvent(HangoutManagerEvent.STATE_CHANGED, $data));
		}//handleStateChanged
		
		private function handleMessageReceived($data:Object):void 
		{//handleMessageReceived
			Log.log("--------------- Caught Message Received", "@hm");
			Log.log(ObjUtils.getDynamicProps($data), "@hm");
			dispatchEvent(new HangoutManagerEvent(HangoutManagerEvent.MESSAGE_RECEIVED, $data));
		}//handleMessageRecieved
		
		private function handleBroadcastingChanged($data:Object):void 
		{//handleBroadcastingChanged
			Log.log("Caught isBroadcasting Change: " + $data.isBroadcasting, "@hm");
			dispatchEvent(new HangoutManagerEvent(HangoutManagerEvent.BROADCASTING_CHANGED, $data));
		}//handleBroadcastingChanged
		
		private function removeParticipantByID($list:Vector.<Participant>, $id:String):void
		{//removeParticipant
			Log.log("Starting Participant Remove: " + $list.length, "@hm");
			
			var index:int = getParticipantIndexByID($list, $id);
			
			if (index != -1)
			{//found
				$list.splice(index, 1);
			}//found
			
			Log.log("Participant Remove: " + $list.length, "@hm");
			
		}//removeParticipant
		
		private function addParticipantIfNotDup($list:Vector.<Participant>, $participant:Participant):void
		{//addParticipantIfNotDup
			var found:Boolean = false;
			
			var index:int = getParticipantIndexByID($list, $participant.id);
			
			if (index == -1)
			{//add
				$list.push($participant);
			}//add
		}//addParticipantIfNotDup
		
		private function getParticipantByID($list:Vector.<Participant>, $id:String):Participant
		{//getParticipantByID
			var part:Participant = null;
			
			for (var i:int = 0; i < $list.length; i++) 
			{//find
				if ($list[i].id == $id)
				{//found
					part = $list[i];
					break;
				}//found
			}//find
			
			return part;
		}//getParticipantByID
		
		private function getParticipantIndexByID($list:Vector.<Participant>, $id:String):int
		{//getParticipantIndexByID
			var index:int = -1;
			
			for (var i:int = 0; i < $list.length; i++) 
			{//find
				if ($list[i].id == $id)
				{//found
					index = i;
					break;
				}//found
			}//find
			
			return index;
		}//getParticipantIndexByID
		
		private function handleBridgeReady(e:HangoutBridgeEvent=null):void 
		{//handleBridgeReady
			init();
			dispatchEvent(new HangoutManagerEvent(HangoutManagerEvent.READY));
		}//handleBridgeReady
		
		public function enableLogging($isEnabled:Boolean):Object
		{//enableLogging
			if (_hb && _hb.isReady)
			{//
				return _hb.enableLogging($isEnabled);
			}//
			return null;
		}//enableLogging
		
		public function get enabledParticipants():Vector.<Participant> 
		{
			return _enabledParticipants;
		}
		
		public function get participants():Vector.<Participant> 
		{
			return _participants;
		}
		
		public function get isReady():Boolean 
		{
			return _isReady;
		}
		
		public function get myParticipantID():String 
		{
			return _myParticipantID;
		}
		
		public function get isOnAir():Boolean
		{//get isOnAir
			return callOnHangoutOnAir("isOnAirHangout");
		}//get isOnAir
		
		public function get isBroadcasting():Boolean
		{//get isBroadcasting
			return callOnHangoutOnAir("isBroadcasting");
		}//get isBroadcasting
		
		public function get isPublic():Boolean
		{//get isPublic
			return callOnHangout("isPublic");
		}//get isPublic
		
		public function get isAppVisible():Boolean
		{//get isAppVisible
			return callOnHangout("isAppVisible");
		}//get isAppVisible
		
		public function get hasCamera():Boolean
		{//hasCamera
			return callOnHangoutAV("hasCamera");
		}//hasCamera
		
		public function get hasMic():Boolean
		{//hasMic
			return callOnHangoutAV("hasMicrophone");
		}//hasMic
		
		public function get hasSpeakers():Boolean
		{//hasSpeakers
			return callOnHangoutAV("hasSpeakers");
		}//hasSpeakers
		
		public function get isLoggingEnabled():Boolean
		{//isLoggingEnabled
			return _hb.isLoggingEnabled;
		}//isLoggingEnabled
		
		public function get isApiReady():Boolean
		{//isApiReady
			return _hb.callOnBridge("getIsApiReady");
		}//isApiReady
		
		public function get hb():HangoutBridge 
		{
			return _hb;
		}
		
	}//HangoutManager Class

}
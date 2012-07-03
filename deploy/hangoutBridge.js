/**
 * ...
 * @author Jake Callery
 */

 
function HangoutBridge($jsBridge)
{//HangoutBridge
	
	var isDebugging = true;
	var jsBridge = $jsBridge;
	var resources = {};
	var sounds = {};
	var overlays = {};
	var eventMap = {};
	var trackingOverlays = {};
	var isApiReady = false;
	var soundID = 0;
	
	debugLog = function(message)
	{
		if(typeof(console) != 'undefined' && isDebugging == true)
		{//log
			console.log(message);
		}//log
	};
	
	handleAPIReady = function(eventObj)
	{//handleAPIReady
		if (eventObj.isApiReady) 
		{//api ready
			debugLog("[@JS]Hangout API is ready");
		}//api ready
		
		isApiReady = eventObj.isApiReady;
		
		gapi.hangout.onApiReady.remove(handleAPIReady);
		
	};//handleAPIReady
	
	init = function()
	{//init
		gapi.hangout.onApiReady.add(handleAPIReady);
	};//init
	
	gadgets.util.registerOnLoadHandler(init);
	
	
	////PUBLIC METHODS////
	this.getIsApiReady = function()
	{//getIsApiReady
		return isApiReady;
	}//getIsApiReady
	
	this.enableLogging = function($isEnabled)
	{//enableLogging
		isDebugging = $isEnabled;
	}//enableLogging
	
	this.isLoggingEnabled = function()
	{//isLoggingEnabled
		return isDebugging;
	}//isLoggingEnabled
	
	//SOUND FUNCTIONALITY
	this.createAudioResource = function($url)
	{//createAudioResource
		debugLog("[@JS]Creating audio resource: " + $url);
		var r = gapi.hangout.av.effects.createAudioResource($url);
		debugLog("[@JS]After create audio resource: " + r);
		resources[$url] = r;
		return r;
	}//createAudioResource
	
	this.createSound = function($soundResourceID, $settingsObj)
	{//createSound
		debugLog("[@JS]Creating sound: " + $soundResourceID);
		
		if(typeof(resources[$soundResourceID]))
		{//good resource
			soundID++;
			if(typeof($settingsObj) != 'undefined')
			{//create with options
				debugLog("[@JS]Making sound with options: " + soundID + " / " + $settingsObj.loop + " / " + $settingsObj.volume);
				sounds[soundID] = resources[$soundResourceID].createSound($settingsObj)
			}//create with options
			else
			{//no options
				debugLog("[@JS]Making sound with no options: " + soundID);
				sounds[soundID] = resources[$soundResourceID].createSound();
			}//no options
			
			return soundID;
		}//good resource
		else
		{//bad resource
			debugLog("[@JS]Bad Sound Resource: " + $soundResourceID);
		}//bad resource
		
	}//createSound
	
	this.playSound = function($soundID)
	{//playSound
		if(typeof(sounds[$soundID]))
		{//good sound instance
			debugLog("[@JS]Playing Sound Instance: " + $soundID);
			sounds[$soundID].play();
		}//good sound instance
		else
		{//bad resource
			debugLog("[@JS]BAD SOUND INSTANCE: " + $soundID);
		}//bad resource
	}//playSound
	
	this.stopSound = function($soundID)
	{//playSound
		if(typeof(sounds[$soundID]))
		{//good sound instance
			debugLog("[@JS]Stopping Sound Instance: " + $soundID);
			sounds[$soundID].stop();
		}//good sound instance
		else
		{//bad resource
			debugLog("[@JS]BAD SOUND INSTANCE: " + $soundID);
		}//bad resource
	}//playSound
	
	this.getSoundVolume = function($soundID)
	{//getSoundVolume
		if(typeof(sounds[$soundID]))
		{//good sound instance
			debugLog("[@JS]Getting Sound Volume: " + $soundID);
			return sounds[$soundID].getVolume();
		}//good sound instance
		else
		{//bad resource
			debugLog("[@JS]BAD SOUND INSTANCE: " + $soundID);
		}//bad resource
		
		return null;
	}//getSoundVolume
	
	this.setSoundVolume = function($soundID, $volume)
	{//setSoundVolume
		if(typeof(sounds[$soundID]))
		{//good sound instance
			debugLog("[@JS]Setting Sound Volume: " + $soundID + " / " + $volume);
			sounds[$soundID].setVolume($volume);
		}//good sound instance
		else
		{//bad resource
			debugLog("[@JS]BAD SOUND INSTANCE: " + $soundID);
		}//bad resource
	}//setSoundVolume
	
	this.getIsLooped = function($soundID)
	{//getIsLooped
		if(typeof(sounds[$soundID]))
		{//good sound instance
			debugLog("[@JS]Getting Is Looped: " + $soundID);
			return sounds[$soundID].isLooped();
		}//good sound instance
		else
		{//bad resource
			debugLog("[@JS]BAD SOUND INSTANCE: " + $soundID);
		}//bad resource
	}//getIsLooped
	
	this.setSoundLoop = function($soundID, $isLooped)
	{//setSoundLoop
		if(typeof(sounds[$soundID]))
		{//good sound instance
			debugLog("[@JS]Setting Is Looped: " + $soundID + " / " + $isLooped);
			sounds[$soundID].setLoop($isLooped);
		}//good sound instance
		else
		{//bad resource
			debugLog("[@JS]BAD SOUND INSTANCE: " + $soundID);
		}//bad resource
	}//setSoundLoop
	
	//OVERLAY FUNCTIONALITY
	this.createImageResource = function($url)
	{//createImageResource
		debugLog("[@JS]before create image resource: " + $url);
		var r = gapi.hangout.av.effects.createImageResource($url.toString());
		debugLog("[@JS]after create image resource: " + r);
		resources[$url] = r;
		return r;
	}//createImageResource
	
	this.createOverlay = function($imageResourceID, $settingsObj)
	{//createOverlay
		debugLog("[@JS]Creating Overlay: " + $imageResourceID);
		if(typeof(resources[$imageResourceID]))
		{//good resource
			
			$settingsObj = typeof($settingsObj)!='undefined' ? $settingsObj:{};
			
			if(typeof($settingsObj.scale) != 'undefined' && typeof($settingsObj.scale.reference) != 'undefined')
			{//eval
				debugLog("[@JS]Show Scale Reference: " + $settingsObj.scale.reference);
				$settingsObj.scale.reference = eval($settingsObj.scale.reference);
				debugLog("[@JS]Show scale Reference After: " + $settingsObj.scale.reference);
			}//eval
			
			var imgRes = resources[$imageResourceID];
			overlays[$imageResourceID] = imgRes.createOverlay($settingsObj);
			
			debugLog("[@JS]Overlay in list: " + overlays[$imageResourceID]);
		}//good resource
		else
		{//bad resource
			debugLog("[@JS]BAD RESOURCE: " + $imageResourceID);
		}//bad resource
		
		return overlays[$imageResourceID];
	}//createOverlay
	
	this.showOverlay = function($imageResourceID)
	{//showOverlay
		debugLog("[@JS]Overlay: " + overlays[$imageResourceID]);
		
		if(typeof(overlays[$imageResourceID]) != 'undefined')
		{//show
			debugLog("[@JS]Showing Old Overlay: " + $imageResourceID);
			overlays[$imageResourceID].setVisible(true);
		}//show
		else
		{//not found
			debugLog("[@JS] Overlay not found, not showing");
		}//not found
		
		debugLog("[@JS]After ShowFaceTrackingOverlay Call");
		
		return overlays[$imageResourceID];
	}//showOverlay
	
	this.hideOverlay = function($imageResourceID, $settingsObj)
	{//hideOverlay
		if(typeof(overlays[$imageResourceID]))
		{//good overlay
			debugLog("[@JS]Hiding Overlay: " + $imageResourceID + " / " + $settingsObj);
			overlays[$imageResourceID].setVisible(false);
		}//good overlay
		
		return overlays[$imageResourceID];
	}//hideOverlay
	
	this.setOverlayPosition = function($imageResourceID, $x, $y)
	{//setOverlayPosition
		if(typeof(overlays[$imageResourceID]))
		{//good overlay
			debugLog("[@JS]Setting overlay position: " + $imageResourceID + " / " + $x + "," + $y);
			overlays[$imageResourceID].setPosition($x, $y);
		}//good overlay
	}//setOverlayPosition
	
	this.setOverlayRotation = function($imageResourceID, $rads)
	{//setOverlayRotation
		if(typeof(overlays[$imageResourceID]))
		{//good overlay
			debugLog("[@JS]Setting overlay rotation: " + $imageResourceID + " / " + $rads);
			overlays[$imageResourceID].setRotation($rads);
		}//good overlay
	}//setOverlayRotation
	
	this.setOverlayScale = function($imageResourceID, $numberOrScaleObj)
	{//setOverlayScale
		if(typeof(overlays[$imageResourceID]))
		{//good overlay
			debugLog("[@JS]Setting Scale: " + $imageResourceID + " / " + $numberOrScaleObj);
			if(isNaN(Number($numberOrScaleObj)))
			{//obj
				debugLog("[@JS]Using Mag/Ref");
				$numberOrScaleObj.reference = eval($numberOrScaleObj.reference);
				overlays[$imageResourceID].setScale($numberOrScaleObj);
			}//obj
			else
			{//number
				debugLog("[@JS]Using Number: " + Number($numberOrScaleObj));
				overlays[$imageResourceID].setScale(Number($numberOrScaleObj));
			}//number
		}//good overlay
	}//setOverlayScale
	
	this.getOverlayPosition = function($imageResourceID)
	{//getOverlayPosition
		if(typeof(overlays[$imageResourceID]))
		{//good overlay
			debugLog("[@JS]Getting Overlay Position: " + $imageResourceID + " / " + overlays[$imageResourceID]);
			return overlays[$imageResourceID].getPosition();
		}//good overlay
		
		return "NaN";
	}//getOverlayPosition
	
	this.getOverlayRotation = function($imageResourceID)
	{//getOverlayRotation
		if(typeof(overlays[$imageResourceID]))
		{//good overlay
			debugLog("[@JS]Getting overlay rotation: " + $imageResourceID);
			return overlays[$imageResourceID].getRotation();
		}//good overlay
		
		return "NaN";
	}//getOverlayRotation
	
	this.getOverlayScale = function($imageResourceID)
	{//getOverlayScale
		if(typeof(overlays[$imageResourceID]))
		{//good overlay
			debugLog("[@JS]Getting overlay scale: " + $imageResourceID);
			return overlays[$imageResourceID].getScale();
		}//good overlay
		
		return null;
	}//getOverlayScale
	
	this.getOverlayIsVisible = function($imageResourceID)
	{//getOverlayIsVisible
		if(typeof(overlays[$imageResourceID]))
		{//good overlay
			debugLog("[@JS]Getting overlay isVisible: " + $imageResourceID);
			return overlays[$imageResourceID].isVisible();
		}//good overlay
		
		return null;
	}//getOverlayIsVisible
	
	this.createFaceTrackingOverlay = function($imageResourceID, $settingsObj)
	{//createFaceTrackingOverlay
		if(typeof(resources[$imageResourceID]))
		{//good resource
			debugLog("[@JS]Creating FaceTracking Overlay");
			
			$settingsObj = typeof($settingsObj)!='undefined' ? $settingsObj:{};
			
			if(typeof($settingsObj.trackingFeature) != 'undefined')
			{//eval
				debugLog("[@JS]Create Feature: " + $settingsObj.trackingFeature);
				$settingsObj.trackingFeature = eval($settingsObj.trackingFeature);
				debugLog("[@JS]Create Feature After: " + $settingsObj.trackingFeature);
			}//eval
			
			var imgRes = resources[$imageResourceID];
			trackingOverlays[$imageResourceID] = imgRes.createFaceTrackingOverlay($settingsObj);
		}//good resource
		
		return trackingOverlays[$imageResourceID];
	}//createFaceTrackingOverlay
	
	this.showFaceTrackingOverlay = function($imageResourceID)
	{//showFaceTrackingOverlay
		debugLog("[@JS]Overlay: " + trackingOverlays[$imageResourceID]);
		
		if(typeof(trackingOverlays[$imageResourceID]) != 'undefined')
		{//show
			debugLog("[@JS]Showing Tracking Overlay: " + $imageResourceID);
			trackingOverlays[$imageResourceID].setVisible(true);
		}//show
		else
		{//bad overlay
			debugLog("[@JS]Face Tracked Overlay Not Found, not showing");
		}//bad overlay
		
		return trackingOverlays[$imageResourceID];
	}//showFaceTrackingOverlay
	
	this.hideFaceTrackingOverlay = function($imageResourceID, $settingsObj)
	{//hideFaceTrackingOverlay
		if(typeof(trackingOverlays[$imageResourceID]))
		{//good overlay
			debugLog("[@JS]Hiding Tracking Overlay: " + $imageResourceID);
			trackingOverlays[$imageResourceID].setVisible(false);
		}//good overlay
		
		return trackingOverlays[$imageResourceID];
	}//hideFaceTrackingOverlay
	
	this.getFaceTrackingOverlayOffset = function($imageResourceID)
	{//getFaceTrackingOverlayOffset
		if(typeof(trackingOverlays[$imageResourceID]))
		{//good overlay
			debugLog("[@JS]Getting Tracking Overlay: " + $imageResourceID);
			return trackingOverlays[$imageResourceID].getOffset();
		}//good overlay
		
		return null;
	}//getFaceTrackingOverlayOffset
	
	this.getFaceTrackingOverlayRotateWithFace = function($imageResourceID)
	{//getFaceTrackingOverlayRotateWithFace
		if(typeof(trackingOverlays[$imageResourceID]))
		{//good overlay
			debugLog("[@JS]Getting Tracking Overlay rotateWithFace: " + $imageResourceID);
			return trackingOverlays[$imageResourceID].getRotateWithFace();
		}//good overlay
		
		return null;
	}//getFaceTrackingOverlayRotateWithFace
	
	this.getFaceTrackingOverlayRotation = function($imageResourceID)
	{//getFaceTrackingOverlayRotation
		if(typeof(trackingOverlays[$imageResourceID]))
		{//good overlay
			debugLog("[@JS]Getting Tracking Overlay Rotation: " + $imageResourceID);
			return trackingOverlays[$imageResourceID].getRotation();
		}//good overlay
		
		return NaN;
	}//getFaceTrackingOverlayRotation
	
	this.getFaceTrackingOverlayScale = function($imageResourceID)
	{//getFaceTrackingOverlayScale
		if(typeof(trackingOverlays[$imageResourceID]))
		{//good overlay
			debugLog("[@JS]Getting Tracking Overlay Scale: " + $imageResourceID);
			return trackingOverlays[$imageResourceID].getScale();
		}//good overlay
		
		return NaN;
	}//getFaceTrackingOverlayScale
	
	this.getFaceTrackingOverlayScaleWithFace = function($imageResourceID)
	{//getFaceTrackingOverlayScaleWithFace
		if(typeof(trackingOverlays[$imageResourceID]))
		{//good overlay
			debugLog("[@JS]Getting Tracking Overlay scaleWithFace: " + $imageResourceID);
			return trackingOverlays[$imageResourceID].getScaleWithFace();
		}//good overlay
		
		return null;
	}//getFaceTrackingOverlayScaleWithFace
	
	this.getFaceTrackingOverlayTrackingFeature = function($imageResourceID)
	{//getFaceTrackingOverlayTrackingFeature
		if(typeof(trackingOverlays[$imageResourceID]))
		{//good overlay
			debugLog("[@JS]Getting Tracking Overlay trackingFeature: " + $imageResourceID);
			return trackingOverlays[$imageResourceID].getTrackingFeature();
		}//good overlay
		
		return null;
	}//getFaceTrackingOverlayTrackingFeature
	
	this.getFaceTrackingOverlayIsVisible = function($imageResourceID)
	{//getFaceTrackingOverlayIsVisible
		if(typeof(trackingOverlays[$imageResourceID]))
		{//good overlay
			debugLog("[@JS]Getting Tracking Overlay isVisible: " + $imageResourceID);
			return trackingOverlays[$imageResourceID].isVisible();
		}//good overlay
		
		return null;
	}//getFaceTrackingOverlayIsVisible
	
	this.setFaceTrackingOverlayOffset = function($imageResourceID, $x, $y)
	{//setFaceTrackingOverlayOffset
		if(typeof(trackingOverlays[$imageResourceID]))
		{//good overlay
			debugLog("[@JS]Getting Tracking Overlay Offset: " + $imageResourceID + " / " + $x + "," + $y);
			trackingOverlays[$imageResourceID].setOffset($x,$y);
		}//good overlay
	}//setFaceTrackingOverlayOffset
	
	this.setFaceTrackingOverlayRotateWithFace = function($imageResourceID, $shouldRotate)
	{//setFaceTrackingOverlayRotateWithFace
		if(typeof(trackingOverlays[$imageResourceID]))
		{//good overlay
			debugLog("[@JS]Getting Tracking Overlay rotateWithFace: " + $imageResourceID + " / " + $shouldRotate);
			trackingOverlays[$imageResourceID].setRotateWithFace($shouldRotate);
		}//good overlay
	}//setFaceTrackingOverlayRotateWithFace
	
	this.setFaceTrackingOverlayRotation = function($imageResourceID, $rads)
	{//setFaceTrackingOverlayRotation
		if(typeof(trackingOverlays[$imageResourceID]))
		{//good overlay
			debugLog("[@JS]Setting Tracking Overlay Rotation: " + $imageResourceID + " / " + $rads);
			trackingOverlays[$imageResourceID].setRotation($rads);
		}//good overlay
	}//setFaceTrackingOverlayRotation
	
	this.setFaceTrackingOverlayScale = function($imageResourceID, $scale)
	{//setFaceTrackingOverlayScale
		if(typeof(trackingOverlays[$imageResourceID]))
		{//good overlay
			debugLog("[@JS]Setting Tracking Overlay Scale: " + $imageResourceID + " / " + $scale);
			trackingOverlays[$imageResourceID].setScale($scale);
		}//good overlay
	}//setFaceTrackingOverlayScale
	
	this.setFaceTrackingOverlayScaleWithFace = function($imageResourceID, $shouldScale)
	{//setFaceTrackingOverlayScaleWithFace
		if(typeof(trackingOverlays[$imageResourceID]))
		{//good overlay
			debugLog("[@JS]Setting Tracking Overlay scaleWithFace: " + $imageResourceID + " / " + $shouldScale);
			trackingOverlays[$imageResourceID].setScaleWithFace($shouldScale);
		}//good overlay
	}//setFaceTrackingOverlayScaleWithFace
	
	this.setFaceTrackingOverlaySetFeature = function($imageResourceID, $trackingFeature)
	{//setFaceTrackingOverlaySetFeature
		if(typeof(trackingOverlays[$imageResourceID]))
		{//good overlay
			debugLog("[@JS]Setting Tracking Overlay trackingFeature: " + $imageResourceID + " / " + $trackingFeature);
			trackingOverlays[$imageResourceID].setTrackingFeature(eval($trackingFeature));
		}//good overlay
	}//setFaceTrackingOverlaySetFeature
	
	this.setFaceTrackingOverlayVisible = function($imageResourceID, $isVisible)
	{//setFaceTrackingOverlayVisible
		if(typeof(trackingOverlays[$imageResourceID]))
		{//good overlay
			debugLog("[@JS]Setting Tracking Overlay Visible: " + $imageResourceID + " / " + $isVisible);
			trackingOverlays[$imageResourceID].setVisible($isVisible);
		}//good overlay
	}//setFaceTrackingOverlayVisible
	
	////// DIRECT CALLS /////
	this.callOnHangout = function($package, $params)
	{//callOnHangout
		debugLog("[@JS] Call on Hangout: " + $package + " / " + $params);
		
		$params = typeof($params)!='undefined' ? $params:[];
		
		var $method;
		
		if(Object.prototype.toString.call($params) === '[object Array]' && $params.length > 0)
		{//we have params
			debugLog("[@JS]Multiple Params");
			$method = $params.shift();
		}//we have params
		else
		{
			debugLog("[@JS]1 param, string only");
			$method = $params;
		}
		
		var r;
		var p = eval($package);
		if(typeof(p) != 'undefined')
		{//
			if(Object.prototype.toString.call($params) === '[object Array]'&& $params.length > 1)
			{//apply
				debugLog("[@JS]Calling with Apply");
				r = p[$method].apply(this, $params);
			}//apply
			else if (Object.prototype.toString.call($params) === '[object Array]' && $params.length == 1)
			{//call
				debugLog("[@JS]Calling With Call");
				r = p[$method].call(this, $params[0]);
			}//call
			else if(typeof($method) != 'undefined')
			{//no params, but valid method
				debugLog("[@JS]Invoking with no params");
				r = p[$method]();
			}//no params, but valid method
			else
			{//bad method
				debugLog("[@JS]No valid method passed to callOnHangout");
			}//bad method
		}//
		else
		{//bad package
			debugLog("[@JS] Not a valid package passed to callOnHangout");
		}//bad package
		
		debugLog("[@JS]After call: " + r);
		
		return r;
		
	}//callOnHangout
	
	//// Event Management ////
	this.addHangoutListener = function($package, $evtName, $callbackName, $passBackProperty)
	{//addHangoutListener
		$passBackProperty = typeof($passBackProperty)!='undefined' ? $passBackProperty:"";
		
		var p = eval($package);
		
		if(typeof(p) != 'undefined')
		{//
			var eventID = ($package.toString() + $evtName.toString() + $callbackName.toString() + $passBackProperty.toString());
			
			if(typeof(eventMap["eventID"]) == 'undefined')
			{//add new callback
				var f = function(evtObj)
				{//function def
					if(typeof(jsBridge.swf[$callbackName] != 'undefined'))
					{//call it
						if($passBackProperty != "")
						{//only send back a part of the event object
							jsBridge.swf[$callbackName](evtObj[$passBackProperty]);
						}//only send back a part of the event object
						else
						{//send back the whole event object
							jsBridge.swf[$callbackName](evtObj);
						}//send back the whole event object
					}//call it
					else
					{//notify bad
						debugLog("[@JS]Bad Callback for " + $evtName + " event on hangoutBridge");
					}//notify bad
				}//function def
				
				eventMap[eventID] = f;
				
				debugLog("[@JS]Adding Event Listener: " + eventID);
				
				p[$evtName].add(f);
			}//add new callback
			else
			{//duplicate event
				debugLog("[@JS]Duplicate Event Callback, not adding a new one: " + eventID);
			}//duplicate event
		}//
		else
		{//bad package
			debugLog("[@JS]Bad package passed to addHangoutListener");
		}//bad package
		
	}//addHangoutListener
	
	this.removeHangoutListener = function($package, $evtName, $callbackName, $passBackProperty)
	{//removeHangoutListener
		
		$passBackProperty = typeof($passBackProperty)!='undefined' ? $passBackProperty:"";
		
		var p = eval($package);
		if(typeof(p) != 'undefined')
		{//good package
			var eventID = ($package.toString() + $evtName.toString() + $callbackName.toString() + $passBackProperty.toString());
			
			if(typeof(eventMap[eventID]) != 'undefined')
			{//remove
				debugLog("[@JS]Removing Event: " + eventID + " / " + eventMap[eventID]);
				p[$evtName].remove(eventMap[eventID]);
				eventMap[eventID] = null;
			}//remove
			else
			{//bad event id
				debugLog("[@JS]Bad eventID/signature passed to removeHangoutListener, not removing: " + eventID);
			}//bad event id
			
		}//good package
		else
		{//bad package
			debugLog("[@JS]Bad package passed to removeHangoutListener");
		}//bad package
		
	}//removeHangoutListener
}//HangoutBridge








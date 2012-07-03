package app.ui 
{
	import app.data.DataHolder;
	import app.data.EventCenter;
	import app.data.TrackingOverlayData;
	import app.events.AppEvent;
	import app.faceTracker.FaceTracker;
	import com.adobe.serialization.json.JSON;
	import com.jac.google.hangout.data.TrackingFeature;
	import com.jac.google.hangout.events.HangoutManagerEvent;
	import com.jac.google.hangout.HangoutManager;
	import com.jac.log.Log;
	import com.jac.utils.DataProviderUtils;
	import com.jac.utils.MathUtils;
	import com.jac.utils.ObjUtils;
	import com.jac.utils.ObjUtils;
	import fl.controls.CheckBox;
	import fl.data.DataProvider;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.system.System;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Jake Callery
	 */
	public class Page1UI extends EventDispatcher implements IPage
	{//Page1UI Class
		
		private var _view:Page1View;
		private var _dh:DataHolder = DataHolder.getInstance();
		private var _hm:HangoutManager;
		
		private var _trackingOverlays:Vector.<TrackingOverlayData>;
		private var _goldStarPath:String;
		private var _faceTracker:FaceTracker;
		private var _pingGridDP:DataProvider;
		private var _pingTimer:Timer;
		private var _numPings:int;
		private var _pingCount:int;
		private var _pongs:Array;
		
		public function Page1UI($view:Page1View) 
		{//Page1UI
			_view = $view;
			
			_pingCount = 0;
			_pingTimer = new Timer(100);
			_pingTimer.addEventListener(TimerEvent.TIMER, handlePingTimer);
			_pingGridDP = new DataProvider();
			_view.pingResponseGrid.dataProvider = _pingGridDP;
			_view.pingResponseGrid.columns = ["AvgTime", "NumPings", "ClientID"];
			
			//set up overlay urls
			_trackingOverlays = Vector.<TrackingOverlayData>
			([
				new TrackingOverlayData(_dh.baseProto + _dh.baseDomain +_dh.basePath + _dh.baseAvatarsPath + "/avatar0.png", TrackingFeature.LEFT_EYE),
				new TrackingOverlayData(_dh.baseProto + _dh.baseDomain +_dh.basePath + _dh.baseAvatarsPath + "/avatar1.png", TrackingFeature.RIGHT_EYE),
				new TrackingOverlayData(_dh.baseProto + _dh.baseDomain +_dh.basePath + _dh.baseAvatarsPath + "/avatar2.png", TrackingFeature.NOSE_TIP),
				new TrackingOverlayData(_dh.baseProto + _dh.baseDomain +_dh.basePath + _dh.baseAvatarsPath + "/avatar3.png", TrackingFeature.MOUTH_CENTER)
			]);
			
			_view.getStateButton.addEventListener(MouseEvent.CLICK, handleGetStateClick);
			_view.submitDeltaButton.addEventListener(MouseEvent.CLICK, handleSubmitDeltaClick);
			_view.copyURLButton.addEventListener(MouseEvent.CLICK, handleCopyURLClick);
			_view.clearLogButton.addEventListener(MouseEvent.CLICK, handleClearLogClick);
			
			_view.leftEyeTrackCheckBox.addEventListener(Event.CHANGE, handleTrackOverlayChange);
			_view.rightEyeTrackCheckBox.addEventListener(Event.CHANGE, handleTrackOverlayChange);
			_view.noseTrackCheckBox.addEventListener(Event.CHANGE, handleTrackOverlayChange);
			_view.mouthTrackCheckBox.addEventListener(Event.CHANGE, handleTrackOverlayChange);
			
			_view.goldStarCheckBox.addEventListener(Event.CHANGE, handleGoldStarClick);
			_view.xPosStepper.addEventListener(Event.CHANGE, handlePosChange);
			_view.yPosStepper.addEventListener(Event.CHANGE, handlePosChange);
			_view.scaleSlider.addEventListener(Event.CHANGE, handleScaleChange);
			_view.rotateSlider.addEventListener(Event.CHANGE, handleRotateChange);
			
			_view.getOverlayPositionButton.addEventListener(MouseEvent.CLICK, handleGetPositionClick);
			_view.getOverlayScaleButton.addEventListener(MouseEvent.CLICK, handleGetOverlayScaleClick);
			_view.getOverlayRotationButton.addEventListener(MouseEvent.CLICK, handleGetOverlayRotationClick);
			_view.getOverlayIsVisibleButton.addEventListener(MouseEvent.CLICK, handleGetOverlayIsVisibleClick);
			_view.getTrackingOverlayOffsetButton.addEventListener(MouseEvent.CLICK, handleTrackingOffsetClick);
			_view.getTrackingOverlayRotateWithFaceButton.addEventListener(MouseEvent.CLICK, handleTrackingGetRotateWithFace);
			_view.getTrackingOverlayRotationButton.addEventListener(MouseEvent.CLICK, handleGetTrackingOverlayRotation);
			_view.getTrackingOverlayScaleButton.addEventListener(MouseEvent.CLICK, handleGetTrackingScale);
			_view.getTrackingOverlayScaleWithFaceButton.addEventListener(MouseEvent.CLICK, handleGetTrackingScaleWithFace);
			_view.getTrackingOverlayTrackingFeatureButton.addEventListener(MouseEvent.CLICK, handleGetTrackingFeature);
			_view.getTrackingOverlayIsVisibleButton.addEventListener(MouseEvent.CLICK, handleGetTrackingIsVisible);
			_view.xOffsetStepper.addEventListener(Event.CHANGE, handleOffsetChange);
			_view.yOffsetStepper.addEventListener(Event.CHANGE, handleOffsetChange);
			_view.rotateWithFaceTrackCheckBox.addEventListener(Event.CHANGE, handleRotateWithFaceChange);
			_view.scaleWithFaceTrackCheckBox.addEventListener(Event.CHANGE, handleScaleWithFaceChange);
			_view.trackingFeatureCombo.addEventListener(Event.CHANGE, handleTrackFeatureChange);
			_view.trackingRotationSlider.addEventListener(Event.CHANGE, handleTrackingRotationSliderChange);
			_view.trackedScaleSlider.addEventListener(Event.CHANGE, handleTrackingScaleSliderChange);
			
			_view.sendMessageButton.addEventListener(MouseEvent.CLICK, handleSendMessageClick);
			_view.sendPingsButton.addEventListener(MouseEvent.CLICK, handleSendPingsClick);
			
			_view.toggleLoggingButton.addEventListener(MouseEvent.CLICK, handleToggleLogging);
			
			_view.page2Button.addEventListener(MouseEvent.CLICK, handleNextPageClick);
			
			if (_dh.hangoutManager.isReady)
			{//ready
				handleHMReady(null);
			}//ready
			else
			{//wait
				_dh.hangoutManager.addEventListener(HangoutManagerEvent.READY, handleHMReady);
			}//wait
			
		}//Page1UI
		
		private function handleNextPageClick(e:MouseEvent):void 
		{//handleNextPageClick
			dispatchEvent(new AppEvent(AppEvent.NEXT_PAGE));
		}//handleNextPageClick
		
		private function handleToggleLogging(e:MouseEvent):void 
		{//handleToggleLogging
			if (Log.isLoggingEnabled())
			{
				Log.enable(false);
				_dh.hangoutManager.enableLogging(false);
				_view.toggleLoggingButton.label = "Enable Logging";
			}
			else
			{
				Log.enable(true);
				_dh.hangoutManager.enableLogging(true);
				_view.toggleLoggingButton.label = "Disable Logging";
			}
		}//handleToggleLogging
		
		private function handleSendPingsClick(e:MouseEvent):void 
		{//handleSendPingsClick
			//START TEST
			_pingTimer.reset();
			_pingTimer.stop();
			_numPings = 0;
			_pongs = [];
			_pingGridDP.removeAll();
			_pingTimer.delay = _view.pingDelayStepper.value;
			_pingTimer.start();
		}//handleSendPingsClick
		
		private function handlePingTimer(e:TimerEvent):void
		{//handlePingTimer
			if (_numPings >= _view.numPingsToSendStepper.value)
			{//done
				_pingTimer.stop();
			}//done
			else
			{//send ping
				_pingCount++;
				
				var obj:Object = {
									origSender:_dh.hangoutManager.myParticipantID,
									origTime:getTimer(),
									pingID:_pingCount
								 };
				var msg:String = "<" + JSON.encode(obj);
				
				_dh.hangoutManager.sendMessage(msg);
			
			}//send ping
			
			_numPings++;
		}//handlePingTimer
		
		private function handleSendMessageClick(e:MouseEvent):void 
		{//handleSendMessageClick
			_dh.hangoutManager.sendMessage(_view.messageDataText.text);
		}//handleSendMessageClick
		
		private function handleTrackingScaleSliderChange(e:Event):void 
		{//handleTrackingScaleSliderChange
			_dh.hangoutManager.setFaceTrackingOverlayScale(_trackingOverlays[3].url, _view.trackedScaleSlider.value);
		}//handleTrackingScaleSliderChange
		
		private function handleTrackingRotationSliderChange(e:Event):void 
		{//handleTrackingRotationSliderChange
			_dh.hangoutManager.setFaceTrackingOverlayRotation(_trackingOverlays[3].url, MathUtils.degToRad(_view.trackingRotationSlider.value));
		}//handleTrackingRotationSliderChange
		
		private function handleTrackFeatureChange(e:Event):void 
		{//handleTrackFeatureChange
			_dh.hangoutManager.setFaceTrackingOverlayFeature(_trackingOverlays[3].url, TrackingFeature.getFullString(_view.trackingFeatureCombo.selectedLabel));
		}//handleTrackFeatureChange
		
		private function handleScaleWithFaceChange(e:Event):void 
		{//handleScaleWithFaceChange
			_dh.hangoutManager.setFaceTrackingOverlayScaleWithFace(_trackingOverlays[3].url, _view.scaleWithFaceTrackCheckBox.selected);
		}//handleScaleWithFaceChange
		
		private function handleRotateWithFaceChange(e:Event):void 
		{//handleRotateWithFaceChange
			_dh.hangoutManager.setFaceTrackingOverlayRotateWithFace(_trackingOverlays[3].url, _view.rotateWithFaceTrackCheckBox.selected);
		}//handleRotateWithFaceChange
		
		private function handleOffsetChange(e:Event):void 
		{//handleOffsetChange
			_dh.hangoutManager.setFaceTrackingOverlayOffset(_trackingOverlays[3].url, _view.xOffsetStepper.value, _view.yOffsetStepper.value);
		}//handleOffsetChange
		
		private function handleGetTrackingIsVisible(e:MouseEvent):void 
		{//handleGetTrackingIsVisible
			Log.log("Mouth Is Visible: " + _dh.hangoutManager.getFaceTrackingOverlayIsVisible(_trackingOverlays[3].url), "@ui");
		}//handleGetTrackingIsVisible
		
		private function handleGetTrackingFeature(e:MouseEvent):void 
		{//handleGetTrackingFeature
			Log.log("Mouth Tracking Feature: " + ObjUtils.getDynamicProps(_dh.hangoutManager.getFaceTrackingOverlayTrackingFeature(_trackingOverlays[3].url)), "@ui");
		}//handleGetTrackingFeature
		
		private function handleGetTrackingScaleWithFace(e:MouseEvent):void 
		{
			Log.log("Mouth Scale With Face: " + _dh.hangoutManager.getFaceTrackingOverlayScaleWithFace(_trackingOverlays[3].url), "@ui");
		}
		
		private function handleGetTrackingScale(e:MouseEvent):void 
		{//handleGetTrackingScale
			Log.log("Mouth Scale: " + _dh.hangoutManager.getFaceTrackingOverlayScale(_trackingOverlays[3].url), "@ui");
		}//handleGetTrackingScale
		
		private function handleGetTrackingOverlayRotation(e:MouseEvent):void 
		{//handleGetTrackingOverlayRotation
			Log.log("Mouth Rotation: " + _dh.hangoutManager.getFaceTrackingOverlayRotation(_trackingOverlays[3].url), "@ui");
		}//handleGetTrackingOverlayRotation
		
		private function handleTrackingGetRotateWithFace(e:MouseEvent):void 
		{//handleTrackingGetRotateWithFace
			Log.log("Mouth Rotate With Face: " + _dh.hangoutManager.getFaceTrackingOverlayRotateWithFace(_trackingOverlays[3].url), "@ui");
		}//handleTrackingGetRotateWithFace
		
		private function handleTrackingOffsetClick(e:MouseEvent):void 
		{//handleTrackOverlayOffsetClick
			Log.log("Mouth Overlay Offset: " + ObjUtils.getDynamicProps(_dh.hangoutManager.getFaceTrackingOverlayOffset(_trackingOverlays[3].url)), "@ui");
		}//handleTrackOverlayOffsetClick
		
		private function handleGetOverlayIsVisibleClick(e:MouseEvent):void 
		{//handleGetOverlayIsVisibleClick
			Log.log("Overlay IsVisible: " + _dh.hangoutManager.getOverlayIsVisible(_goldStarPath), "@ui");
		}//handleGetOverlayIsVisibleClick
		
		private function handleGetOverlayRotationClick(e:MouseEvent):void 
		{//handleGetOverlayRotationClick
			Log.log("Overlay Rotation: " + MathUtils.radToDeg(_dh.hangoutManager.getOverlayRotation(_goldStarPath)), "@ui");
		}//handleGetOverlayRotationClick
		
		private function handleGetPositionClick(e:MouseEvent):void 
		{//handleGetPositionClick
			Log.log("Overlay Position: " + ObjUtils.getDynamicProps(_dh.hangoutManager.getOverlayPosition(_goldStarPath)), "@ui");
		}//handleGetPositionClick
		
		private function handleGetOverlayScaleClick(e:MouseEvent):void 
		{//getOverlayScaleClick
			Log.log("Overlay Scale: " + ObjUtils.getDynamicProps(_dh.hangoutManager.getOverlayScale(_goldStarPath)), "@ui");
		}//getOverlayScaleClick
		
		private function handleRotateChange(e:Event):void 
		{//handleRotateChange
			_dh.hangoutManager.setOverlayRotation(_goldStarPath, MathUtils.degToRad(_view.rotateSlider.value));
		}//handleRotateChange
		
		private function handleScaleChange(e:Event):void 
		{//handleScaleChange
			//_dh.hangoutManager.setOverlayScale(_goldStarPath, _view.scaleSlider.value);
			_dh.hangoutManager.setOverlayScale(_goldStarPath, {magnitude:_view.scaleSlider.value, reference:"gapi.hangout.av.effects.ScaleReference.WIDTH"});
			
		}//handleScaleChange
		
		private function handlePosChange(e:Event):void 
		{//handlePosChange
			_dh.hangoutManager.setOverlayPosition(_goldStarPath, _view.xPosStepper.value, _view.yPosStepper.value);
		}//handlePosChange
		
		private function handleGoldStarClick(e:Event):void 
		{//handleGoldStarClick
			if (CheckBox(e.target).selected)
			{//
				_dh.hangoutManager.showOverlay(_goldStarPath);
			}//
			else
			{
				_dh.hangoutManager.hideOverlay(_goldStarPath);
			}
		}//handleGoldStartClick
		
		private function handleTrackOverlayChange(e:Event):void 
		{//handleTrackOverlayChange
			if (e.target == _view.leftEyeTrackCheckBox)
			{//
				if (CheckBox(e.target).selected)
				{
					_dh.hangoutManager.showFaceTrackingOverlay(_trackingOverlays[0].url, {trackingFeature:_trackingOverlays[0].trackingFeature, scaleWithFace:true, rotateWithFace:true, scale:2, offset:{x:0,y:0} } );
				}
				else
				{
					_dh.hangoutManager.hideFaceTrackingOverlay(_trackingOverlays[0].url);
				}
			}//
			else if (e.target == _view.rightEyeTrackCheckBox)
			{
				if (CheckBox(e.target).selected)
				{
					_dh.hangoutManager.showFaceTrackingOverlay(_trackingOverlays[1].url, {trackingFeature:_trackingOverlays[1].trackingFeature, scaleWithFace:true, rotateWithFace:true, scale:2, offset:{x:0,y:0} } );
				}
				else
				{
					_dh.hangoutManager.hideFaceTrackingOverlay(_trackingOverlays[1].url);
				}
			}
			else if (e.target == _view.noseTrackCheckBox)
			{
				if (CheckBox(e.target).selected)
				{
					_dh.hangoutManager.showFaceTrackingOverlay(_trackingOverlays[2].url, {trackingFeature:_trackingOverlays[2].trackingFeature, scaleWithFace:true, rotateWithFace:true, scale:2, offset:{x:0,y:0} } );
				}
				else
				{
					_dh.hangoutManager.hideFaceTrackingOverlay(_trackingOverlays[2].url);
				}
			}
			else if (e.target == _view.mouthTrackCheckBox)
			{
				if (CheckBox(e.target).selected)
				{
					_dh.hangoutManager.showFaceTrackingOverlay(_trackingOverlays[3].url, {trackingFeature:_trackingOverlays[3].trackingFeature, scaleWithFace:true, rotateWithFace:true, scale:2, offset:{x:0,y:0} } );
				}
				else
				{
					_dh.hangoutManager.hideFaceTrackingOverlay(_trackingOverlays[3].url);
				}
			}
		}//handleTrackOverlayChange
		
		private function handleHMReady(e:HangoutManagerEvent):void 
		{//handleHMReady
			
			_faceTracker = new FaceTracker(_view.faceTrackerView);
			
			_goldStarPath = _dh.baseProto + _dh.baseDomain +_dh.basePath + _dh.baseOverlaysPath + "/goldstar.png";
			
			for (var i:int = 0; i < _trackingOverlays.length; i++) 
			{//set up avatars
				_dh.hangoutManager.createImageResource(_trackingOverlays[i].url);
			}//set up avatars
			
			//Set up overlays
			_dh.hangoutManager.createImageResource(_goldStarPath);
			_dh.hangoutManager.createOverlay(_goldStarPath, {position:{x:-0.37,y:-0.3}, rotation:0, scale:{magnitude:0.2, reference: "gapi.hangout.av.effects.ScaleReference.WIDTH"}});
			
			_dh.hangoutManager.createImageResource(_trackingOverlays[0].url);
			_dh.hangoutManager.createImageResource(_trackingOverlays[1].url);
			_dh.hangoutManager.createImageResource(_trackingOverlays[2].url);
			_dh.hangoutManager.createImageResource(_trackingOverlays[3].url);
			
			_dh.hangoutManager.createFaceTrackingOverlay(_trackingOverlays[0].url, { trackingFeature:_trackingOverlays[0].trackingFeature, scaleWithFace:true, rotateWithFace:true, scale:2, offset: { x:0, y:0 } } );
			_dh.hangoutManager.createFaceTrackingOverlay(_trackingOverlays[1].url, { trackingFeature:_trackingOverlays[1].trackingFeature, scaleWithFace:true, rotateWithFace:true, scale:2, offset: { x:0, y:0 } } );
			_dh.hangoutManager.createFaceTrackingOverlay(_trackingOverlays[2].url, { trackingFeature:_trackingOverlays[2].trackingFeature, scaleWithFace:true, rotateWithFace:true, scale:2, offset: { x:0, y:0 } } );
			_dh.hangoutManager.createFaceTrackingOverlay(_trackingOverlays[3].url, { trackingFeature:_trackingOverlays[3].trackingFeature, scaleWithFace:true, rotateWithFace:true, scale:2, offset: { x:0, y:0 } } );
			
			//
			_view.isOnAirText.text = _dh.hangoutManager.isOnAir.toString();
			_view.isBroadcastingText.text = _dh.hangoutManager.isBroadcasting.toString();
			_view.participantIDText.text = _dh.hangoutManager.myParticipantID;
			_view.isPublicText.text = _dh.hangoutManager.isPublic.toString();
			
			_dh.hangoutManager.addEventListener(HangoutManagerEvent.PUBLIC_CHANGED, handlePublicChanged);
			_dh.hangoutManager.addEventListener(HangoutManagerEvent.BROADCASTING_CHANGED, handleBroadcastingChanged);
			_dh.hangoutManager.addEventListener(HangoutManagerEvent.MESSAGE_RECEIVED, handleMessage);
			_dh.hangoutManager.addEventListener(HangoutManagerEvent.APP_VISIBLE_CHANGED, handleAppVisibleChanged);
			_dh.hangoutManager.addEventListener(HangoutManagerEvent.CAMERA_MUTE_CHANGED, handleCameraMuteChanged);
			_dh.hangoutManager.addEventListener(HangoutManagerEvent.HAS_CAMERA_CHANGED, handleHasCameraChanged);
			_dh.hangoutManager.addEventListener(HangoutManagerEvent.HAS_MIC_CHANGED, handleHasMicChanged);
			_dh.hangoutManager.addEventListener(HangoutManagerEvent.HAS_SPEAKERS_CHANGED, handleHasSpeakersChanged);
			_dh.hangoutManager.addEventListener(HangoutManagerEvent.MIC_MUTE_CHANGED, handleMicMuteChanged);
			_dh.hangoutManager.addEventListener(HangoutManagerEvent.VOLUMES_CHANGED, handleVolumesChanged);
			
			if (_dh.hangoutManager.isLoggingEnabled == true)
			{//enabled
				_view.toggleLoggingButton.label = "Disable Logging";
			}//enabled
			else
			{//disabled
				_view.toggleLoggingButton.label = "Enable Logging";
			}//disabled
			
		}//handleHMReady
		
		private function handleVolumesChanged(e:HangoutManagerEvent):void 
		{
			//Log.log("Caught Volumes Changed: " + ObjUtils.getDynamicProps(e.data), "@ui");
		}
		
		private function handleMicMuteChanged(e:HangoutManagerEvent):void 
		{
			Log.log("Caught Mic Mute Changed To: " + e.data.isMicrophoneMute.toString(), "@ui");
		}
		
		private function handleHasSpeakersChanged(e:HangoutManagerEvent):void 
		{
			Log.log("Caught Has Speakers Changed To: " + e.data.hasSpeakers.toString(), "@ui");
		}
		
		private function handleHasMicChanged(e:HangoutManagerEvent):void 
		{
			Log.log("Caught Has Mic Changed To: " + e.data.hasMicrophone.toString(), "@ui");
		}
		
		private function handleHasCameraChanged(e:HangoutManagerEvent):void 
		{
			Log.log("Caught Has Camera Changed to: " + e.data.hasCamera.toString(), "@ui");
		}
		
		private function handleCameraMuteChanged(e:HangoutManagerEvent):void 
		{//handleCameraMuteChanged
			Log.log("Caught Camera Mute Changed to: " + e.data.isCameraMute.toString(), "@ui");
		}//handleCameraMuteChanged
		
		private function handleAppVisibleChanged(e:HangoutManagerEvent):void 
		{//handleAppVisibleChanged
			Log.log("Caught App Visible Changed to: " + e.data.isAppVisible.toString(), "@ui");
		}//handleAppVisibleChanged
		
		private function handlePublicChanged(e:HangoutManagerEvent):void 
		{//handlePublicChanged
			Log.log("Caught Public Changed to: " + e.data.isPublic.toString(), "@ui");
			_view.isPublicText.text = e.data.toString();
		}//handlePublicChanged
		
		private function handleMessage(e:HangoutManagerEvent):void 
		{//handleMessage
			var msg:String = e.data.message.toString();
			var senderID:String = e.data.senderId;
			
			if (msg.charAt(0) == "<")
			{//ping
				msg = msg.substr(1);
				
				var pingObj:Object;
				try
				{
					pingObj = JSON.decode(msg);
				}
				catch (err:Error)
				{
					Log.logWarning("Bad Ping JSON");
				}
				
				if (pingObj != null && pingObj.hasOwnProperty("pingID"))
				{//
					//Send PONG (start with ">")
					msg = ">" + msg;
					_dh.hangoutManager.sendMessage(msg);
				}//
			}//ping
			else if (msg.charAt(0) == ">")
			{//pong
				msg = msg.substr(1);
				
				var pongObj:Object;
				try
				{
					pongObj = JSON.decode(msg);
				}
				catch (err1:Error)
				{
					Log.logWarning("Bad Pong JSON");
				}
				
				if (pongObj != null && pongObj.hasOwnProperty("pingID") && pongObj.origSender == _dh.hangoutManager.myParticipantID)
				{//record pong
					var lapsedTime:Number = getTimer() - Number(pongObj.origTime);
					if (_pongs[senderID] == null) { _pongs[senderID] = { };}
					_pongs[senderID].totalTime = (isNaN(_pongs[senderID].totalTime))?lapsedTime:(_pongs[senderID].totalTime + lapsedTime);
					_pongs[senderID].numPongs = (isNaN(_pongs[senderID].numPongs))?1:(_pongs[senderID].numPongs + 1);
					
					//update datagrid
					var item:Object = DataProviderUtils.findItem(_pingGridDP, "ClientID", senderID);
					
					if (item != null)
					{//update
						item.AvgTime = _pongs[senderID].totalTime / _pongs[senderID].numPongs;
						item.NumPings = _pongs[senderID].numPongs;
						_pingGridDP.invalidateItem(item);
					}//update
					else
					{//add new
						_pingGridDP.addItem( { AvgTime:_pongs[senderID].totalTime / _pongs[senderID].numPongs, NumPings:_pongs[senderID].numPongs, ClientID:senderID } );
					}//add new
					
				}//record pong
				
			}//pong
		}//handleMessage
		
		private function handleBroadcastingChanged(e:HangoutManagerEvent):void 
		{//handleBroadcastingChanged
			_view.isBroadcastingText.text = e.data.isBroadcasting;
		}//handleBroadcastingChanged
		
		private function handleClearLogClick(e:MouseEvent):void 
		{//handleClearLogClick
			dispatchEvent(new AppEvent(AppEvent.CLEAR_LOG));
		}//handleClearLogClick
		
		private function handleCopyURLClick(e:MouseEvent):void 
		{//handleCopyURLClick
			var link:String = String(_dh.hangoutManager.callOnHangout("getHangoutUrl")) + "?gid=" + _dh.appID;
			Log.log(link, "@ui");
			System.setClipboard(link);
		}//handleCopyURLClick
		
		private function handleSubmitDeltaClick(e:MouseEvent):void 
		{//handleSubmitDeltaClick
			Log.log("Caught Submit Delta Click: " + _view.keyText.text + " / " + _view.valueText.text, "@ui");
			
			if (_dh.hangoutManager != null)
			{//submit
				Log.log("Submitting Delta", "@ui");
				var updates:Object = { };
				updates[_view.keyText.text] = _view.valueText.text;
				_dh.hangoutManager.submitDelta(updates);
			}//submit
			
		}//handleSubmitDeltaClick
		
		private function handleGetStateClick(e:MouseEvent):void 
		{//handleGetStateClick
			Log.log("Caught Get State Click", "@ui");
			if (_dh.hangoutManager != null)
			{//get state
				Log.log("Getting State Meta Data", "@ui");
				var stateMeta:Object = _dh.hangoutManager.getStateMetadata();
				Log.log("State MetaData: \n" + ObjUtils.getDynamicProps(stateMeta), "@ui");
			}//get state
		}//handleGetStateClick
		
		public function get view():MovieClip 
		{
			return _view;
		}
		
	}//Page1UI Class

}
package app.ui 
{
	import app.data.DataHolder;
	import app.events.AppEvent;
	import com.jac.google.hangout.events.HangoutManagerEvent;
	import com.jac.google.hangout.HangoutManager;
	import com.jac.log.Log;
	import com.jac.utils.ObjUtils;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Jake Callery
	 */
	public class Page2UI extends EventDispatcher implements IPage
	{//Page2UI Class
		
		private const NO_PARTS:String = "[none]";
		
		private var _view:Page2View;
		private var _dh:DataHolder = DataHolder.getInstance();
		private var _hm:HangoutManager;
		private var _soundPath:String;
		private var _soundID:Number;
		
		public function Page2UI($view:Page2View) 
		{//Page2UI
			_view = $view;
			
			_soundPath = _dh.baseProto + _dh.baseDomain +_dh.basePath + _dh.baseSoundsPath + "/testsound.wav";
			
			_view.page1Button.addEventListener(MouseEvent.CLICK, handlePage1Click);
			_hm = _dh.hangoutManager;
			
			if (_hm.isReady)
			{//ready
				handleHMReady(null);
			}//ready
			else
			{//wait
				_hm.addEventListener(HangoutManagerEvent.READY, handleHMReady);
			}//wait
			
		}//Page2UI
		
		private function showResult($obj:Object):void
		{//showResult
			_view.resultText.text = ObjUtils.getDynamicProps($obj);
			_view.vertUIScrollBar.invalidate();
			_view.horizUIScrollBar.invalidate();
		}//showResult
		
		private function handlePage1Click(e:MouseEvent):void 
		{//handlePage1Click
			dispatchEvent(new AppEvent(AppEvent.NEXT_PAGE));
		}//handlePage1Click
		
		private function handleHMReady(e:HangoutManagerEvent):void 
		{//handleHMReady
			_view.apiReadyText.text = _hm.isApiReady.toString();
			_view.bridgeReadyText.text = _hm.isReady.toString();
			
			_hm.createAudioResource(_soundPath);
			
			//_soundID = _hm.createSound(_soundPath);
			_soundID = _hm.createSound(_soundPath, {loop:true, volume:1} );
			
			Log.log("--- SOUND ID: " + _soundID, "@ui");
			
			handlePartsChanged();
			
			//Add listeners
			_hm.addEventListener(HangoutManagerEvent.PARTICIPANTS_CHANGED, handlePartsChanged);
			
			//ui listeners
			_view.vertUIScrollBar.scrollTarget = _view.resultText;
			_view.horizUIScrollBar.scrollTarget = _view.resultText;
			_view.resultText.addEventListener(Event.CHANGE, handleTextChange);
			
			//Info
			_view.getParticipantsButton.addEventListener(MouseEvent.CLICK, handleGetPartsClick);
			_view.getEnabledPartsButton.addEventListener(MouseEvent.CLICK, handleGetEnabledPartsClick);
			_view.getHangoutURLButton.addEventListener(MouseEvent.CLICK, handleGetHangoutUrlClick);
			_view.getHangoutIDButton.addEventListener(MouseEvent.CLICK, handleGetHangoutIdClick);
			_view.getLocaleButton.addEventListener(MouseEvent.CLICK, handleGetLocaleClick);
			_view.getStartDataButton.addEventListener(MouseEvent.CLICK, handleGetStartDataClick);
			_view.getPage2StateButton.addEventListener(MouseEvent.CLICK, handleGetStateClick);
			_view.getPage2StateMetaButton.addEventListener(MouseEvent.CLICK, handeGetStateMetaClick);
			_view.hideAppButton.addEventListener(MouseEvent.CLICK, handleHideAppClick);
			_view.getIsAppVisibleButton.addEventListener(MouseEvent.CLICK, handleGetIsAppVisible);
			
			//AV
			_view.setAvatarButton.addEventListener(MouseEvent.CLICK, handleSetAvatarClick);
			_view.clearAvatarButton.addEventListener(MouseEvent.CLICK, handleClearAvatarClick);
			_view.getAvatarButton.addEventListener(MouseEvent.CLICK, handleGetAvatarClick);
			_view.setCameraMuteButton.addEventListener(MouseEvent.CLICK, handleSetCamearMuteClick);
			_view.getCameraMuteButton.addEventListener(MouseEvent.CLICK, handleGetCameraMuteClick);
			_view.setMicMuteButton.addEventListener(MouseEvent.CLICK, handleSetMicMuteClick)
			_view.getMicMuteButton.addEventListener(MouseEvent.CLICK, handleGetMicMuteClick)
			_view.getHasSpeakersButton.addEventListener(MouseEvent.CLICK, handleHasSpeakersClick);
			_view.getHasMicButton.addEventListener(MouseEvent.CLICK, handleGetHasMicClick)
			_view.getHasCameraButton.addEventListener(MouseEvent.CLICK, handleGetHasCameraClick);
			_view.clearMicMuteButton.addEventListener(MouseEvent.CLICK, handleClearMicClick);
			_view.getPartAudioLevelButton.addEventListener(MouseEvent.CLICK, handleGetPartAudioLevelClick);
			_view.getPartVolumeButton.addEventListener(MouseEvent.CLICK, handleGetPartVolumeClick);
			_view.getIsPartAudibleButton.addEventListener(MouseEvent.CLICK, handleGetIsPartAudibleClick);
			_view.getIsPartVisibleButton.addEventListener(MouseEvent.CLICK, handleGetIsPartVisibleClick);
			_view.requestParticipantMicMuteButton.addEventListener(MouseEvent.CLICK, handleReqPartMuteClick);
			_view.setParticipantAudioLevel.addEventListener(MouseEvent.CLICK, handleSetPartAudioLevelClick);
			_view.setParticipantAudibleButton.addEventListener(MouseEvent.CLICK, handleSetPartAudibleClick);
			_view.setParticipantVisibleButton.addEventListener(MouseEvent.CLICK, handleSetPartVisibleClick);
			_view.getVolumesButton.addEventListener(MouseEvent.CLICK, handleGetVolumesClick);
			
			//Layout
			_view.displayNoticeButton.addEventListener(MouseEvent.CLICK, handleDisplayNoticeClick);
			_view.dismissNoticeButton.addEventListener(MouseEvent.CLICK, handleDismissNoticeClick);
			_view.hasNoticeButton.addEventListener(MouseEvent.CLICK, handleHasNoticeClick);
			_view.toggleChatPaneButton.addEventListener(MouseEvent.CLICK, handleToggleChatPane);
			_view.isChatPaneVisibleButton.addEventListener(MouseEvent.CLICK, handleIsChatPaneVisibleClick);
			
			//Sound
			_view.playSoundButton.addEventListener(MouseEvent.CLICK, handlePlaySound);
			_view.stopSoundButton.addEventListener(MouseEvent.CLICK, handleStopSound);
			_view.toggleLoopButton.addEventListener(MouseEvent.CLICK, handleToggleLoop);
			_view.toggleVolumeButton.addEventListener(MouseEvent.CLICK, handleToggleVolume);
			_view.getIsLoopedButton.addEventListener(MouseEvent.CLICK, handleIsLoopedClick);
			_view.getSoundVolumeButton.addEventListener(MouseEvent.CLICK, handleGetSoundVolumeClick);
		}//handleHMReady
		
		private function handleGetSoundVolumeClick(e:MouseEvent):void 
		{//handleGetSoundVolumeClick
			showResult(_hm.getSoundVolume(_soundID));
		}//handleGetSoundVolumeClick
		
		private function handleIsLoopedClick(e:MouseEvent):void 
		{//handleIsLoopedClick
			showResult(_hm.getIsLooped(_soundID));
		}//handleIsLoopedCLicked
		
		private function handleToggleVolume(e:MouseEvent):void 
		{//handleToggleVolume
			if (_hm.getSoundVolume(_soundID) == 1)
			{//
				_hm.setSoundVolume(_soundID, 0.2)
			}
			else
			{
				_hm.setSoundVolume(_soundID, 1);
			}
		}//handleToggleVolume
		
		private function handleToggleLoop(e:MouseEvent):void 
		{//handleToggleLoop
			_hm.setSoundLoop(_soundID, !_hm.getIsLooped(_soundID));
		}//handleToggleLoop
		
		private function handlePlaySound(e:MouseEvent):void 
		{//handlePlaySound
			_hm.playSound(_soundID);
		}//handlePlaySound
		
		private function handleStopSound(e:MouseEvent):void 
		{//handleStopSound
			_hm.stopSound(_soundID);
		}//handleStopSound
		
		private function handleGetVolumesClick(e:MouseEvent):void 
		{
			showResult(_hm.callOnHangoutAV("getVolumes"));
		}
		
		private function handleSetPartVisibleClick(e:MouseEvent):void 
		{
			if (_view.remotePartIDText.text != NO_PARTS)
			{//
				_hm.callOnHangoutAV("setParticipantVisible", _view.remotePartIDText.text, !(_hm.callOnHangoutAV("isParticipantVisible", _view.remotePartIDText.text)));
			}//
			else
			{
				_hm.callOnHangoutLayout("displayNotice", "This feature requres more than 1 participant to be running the app.");
			}
		}
		
		private function handleSetPartAudioLevelClick(e:MouseEvent):void 
		{
			if (_view.remotePartIDText.text != NO_PARTS)
			{//
				var vol:Number;
				
				var level:Object = _hm.callOnHangoutAV("getParticipantAudioLevel", _view.remotePartIDText.text);
				
				if (level[0] != 1)
				{//
					vol = 1;
				}
				else
				{//
					vol = 10;
				}//
				
				_hm.callOnHangoutAV("setParticipantAudioLevel", _view.remotePartIDText.text, vol);
			}//
		}
		
		private function handleSetPartAudibleClick(e:MouseEvent):void 
		{
			if (_view.remotePartIDText.text != NO_PARTS)
			{//
				_hm.callOnHangoutAV("setParticipantAudible", _view.remotePartIDText.text, !(_hm.callOnHangoutAV("isParticipantAudible", _view.remotePartIDText.text)));
			}//
			else
			{
				_hm.callOnHangoutLayout("displayNotice", "This feature requres more than 1 participant to be running the app.");
			}
		}
		
		private function handleReqPartMuteClick(e:MouseEvent):void 
		{
			if (_view.remotePartIDText.text != NO_PARTS)
			{//
				_hm.callOnHangoutAV("requestParticipantMicrophoneMute", _view.remotePartIDText.text);
			}//
			else
			{
				_hm.callOnHangoutLayout("displayNotice", "This feature requres more than 1 participant to be running the app.");
			}
		}
		
		private function handleGetIsPartVisibleClick(e:MouseEvent):void 
		{
			if (_view.remotePartIDText.text != NO_PARTS)
			{//
				showResult(_hm.callOnHangoutAV("isParticipantVisible", _view.remotePartIDText.text));
			}//
			else
			{
				_hm.callOnHangoutLayout("displayNotice", "This feature requres more than 1 participant to be running the app.");
			}
		}
		
		private function handleGetIsPartAudibleClick(e:MouseEvent):void 
		{
			if (_view.remotePartIDText.text != NO_PARTS)
			{//
				showResult(_hm.callOnHangoutAV("isParticipantAudible", _view.remotePartIDText.text));
			}//
			else
			{
				_hm.callOnHangoutLayout("displayNotice", "This feature requres more than 1 participant to be running the app.");
			}
		}
		
		private function handleGetPartVolumeClick(e:MouseEvent):void 
		{
			if (_view.remotePartIDText.text != NO_PARTS)
			{//
				showResult(_hm.callOnHangoutAV("getParticipantVolume", _view.remotePartIDText.text));
			}//
			else
			{
				_hm.callOnHangoutLayout("displayNotice", "This feature requres more than 1 participant to be running the app.");
			}
		}
		
		private function handleGetPartAudioLevelClick(e:MouseEvent):void 
		{
			if (_view.remotePartIDText.text != NO_PARTS)
			{//
				showResult(_hm.callOnHangoutAV("getParticipantAudioLevel", _view.remotePartIDText.text));
			}//
			else
			{
				_hm.callOnHangoutLayout("displayNotice", "This feature requres more than 1 participant to be running the app.");
			}
		}
		
		private function handleClearMicClick(e:MouseEvent):void 
		{
			_hm.clearMicMute();
		}
		
		private function handleGetHasCameraClick(e:MouseEvent):void 
		{
			showResult(_hm.hasCamera);
		}
		
		private function handleGetHasMicClick(e:MouseEvent):void 
		{
			showResult(_hm.hasMic);
		}
		
		private function handleHasSpeakersClick(e:MouseEvent):void 
		{
			showResult(_hm.hasSpeakers);
		}
		
		private function handleGetMicMuteClick(e:MouseEvent):void 
		{
			showResult(_hm.getMicMute());
		}
		
		private function handleSetMicMuteClick(e:MouseEvent):void 
		{
			_hm.setMicMute(!(_hm.getMicMute()));
		}
		
		private function handleGetCameraMuteClick(e:MouseEvent):void 
		{
				showResult(_hm.getCameraMute());
		}
		
		private function handleSetCamearMuteClick(e:MouseEvent):void 
		{
			_hm.setCameraMute(!(_hm.getCameraMute()));
		}
		
		private function handleGetAvatarClick(e:MouseEvent):void 
		{
			if (_view.remotePartIDText.text != NO_PARTS)
			{
				showResult(_hm.getAvatar(_view.remotePartIDText.text));
			}
			else
			{
				showResult(_hm.getAvatar(_hm.myParticipantID));
			}
		}
		
		private function handleClearAvatarClick(e:MouseEvent):void 
		{
			if (_view.remotePartIDText.text != NO_PARTS)
			{
				_hm.clearAvatar(_view.remotePartIDText.text);
			}
			else
			{
				_hm.clearAvatar(_hm.myParticipantID);
			}
		}
		
		private function handleSetAvatarClick(e:MouseEvent):void 
		{//handleSetAvatarClick
			if (_view.remotePartIDText.text != NO_PARTS)
			{//
				_hm.setAvatar(_view.remotePartIDText.text, (_dh.baseProto + _dh.baseDomain +_dh.basePath + _dh.baseAvatarsPath + "/localAvatar.png"));
			}//
			else
			{//self
				_hm.setAvatar(_hm.myParticipantID, (_dh.baseProto + _dh.baseDomain +_dh.basePath + _dh.baseAvatarsPath + "/localAvatar.png"));
			}//self
		}//handleSetAvatarClick
		
		private function handleIsChatPaneVisibleClick(e:MouseEvent):void 
		{
			showResult(_hm.callOnHangoutLayout("isChatPaneVisible"));
		}
		
		private function handleToggleChatPane(e:MouseEvent):void 
		{//handleToggleChatPane
			Log.log("Chat Pane Visible: " + _hm.callOnHangoutLayout("isChatPaneVisible"), "@ui");
			if (_hm.callOnHangoutLayout("isChatPaneVisible"))
			{//hide
				_hm.callOnHangoutLayout("setChatPaneVisible", false);
			}//hide
			else
			{//show
				_hm.callOnHangoutLayout("setChatPaneVisible", true);
			}//show
		}//handleToggleChatPane
		
		private function handleHasNoticeClick(e:MouseEvent):void 
		{
			var result:Object = _hm.callOnHangoutLayout("hasNotice");
			showResult(result);
		}
		
		private function handleDismissNoticeClick(e:MouseEvent):void 
		{
			_hm.callOnHangoutLayout("dismissNotice");
		}
		
		private function handleDisplayNoticeClick(e:MouseEvent):void 
		{
			_hm.callOnHangoutLayout("displayNotice", "Custom Sticky Notice Message!", true);
			//_hm.callOnHangoutLayout("displayNotice", "Custom Sticky Notice Message!");
		}
		
		private function handleGetIsAppVisible(e:MouseEvent):void 
		{
			showResult(_hm.callOnHangout("isAppVisible"));
		}
		
		private function handleHideAppClick(e:MouseEvent):void 
		{
			_hm.callOnHangout("hideApp");
		}
		
		private function handeGetStateMetaClick(e:MouseEvent):void 
		{
			showResult(_hm.callOnHangoutData("getStateMetadata"));
		}
		
		private function handleGetStateClick(e:MouseEvent):void 
		{
			showResult(_hm.callOnHangoutData("getState"));
		}
		
		private function handleGetStartDataClick(e:MouseEvent):void 
		{
			showResult(_hm.callOnHangout("getStartData"));
		}
		
		private function handleGetLocaleClick(e:MouseEvent):void 
		{
			showResult(_hm.callOnHangout("getLocale"));
		}
		
		private function handleGetHangoutIdClick(e:MouseEvent):void 
		{
			showResult(_hm.callOnHangout("getHangoutId"));
		}
		
		private function handleGetHangoutUrlClick(e:MouseEvent):void 
		{
			showResult(_hm.callOnHangout("getHangoutUrl"));
		}
		
		private function handleTextChange(e:Event):void 
		{//handleTextChange
			_view.vertUIScrollBar.invalidate();
			_view.horizUIScrollBar.invalidate();
		}//handleTextChange
		
		private function handleGetEnabledPartsClick(e:MouseEvent):void 
		{//
			showResult(_hm.callOnHangout("getEnabledParticipants"));
		}//
		
		private function handleGetPartsClick(e:MouseEvent):void 
		{//handleGetPartsClick
			showResult(_hm.callOnHangout("getParticipants"));
		}//handleGetPartsClick
		
		private function handlePartsChanged(e:HangoutManagerEvent=null):void 
		{//handlePartsChanged
			var found:Boolean = false;
			for (var i:int = 0; i < _hm.participants.length; i++) 
			{
				if (_hm.participants[i].id != _hm.myParticipantID)
				{//set
					_view.remotePartIDText.text = _hm.participants[i].id;
					found = true;
					break;
				}//set
			}
			if (!found)
			{//
				_view.remotePartIDText.text = NO_PARTS;
			}//
		}//handlePartsChanged
		
		public function get view():MovieClip 
		{
			return _view;
		}
		
	}//Page2UI Class

}
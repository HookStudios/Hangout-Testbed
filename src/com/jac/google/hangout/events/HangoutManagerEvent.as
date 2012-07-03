package com.jac.google.hangout.events 
{//Packge
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Jake Callery
	 */
	public class HangoutManagerEvent extends Event 
	{//HangoutManagerEvent Class
		
		static public const READY:String = "hangoutManagerReadyEvent";
		static public const PARTICIPANTS_ADDED:String = "hangoutManagerParticipantsAddedEvent";
		static public const PARTICIPANTS_REMOVED:String = "hangoutManagerParticipantsRemovedEvent";
		static public const PARTICIPANTS_CHANGED:String = "hangoutManagerParticipantsChangedEvent";
		static public const PARTICIPANTS_ENABLED:String = "hangoutManagerParticipantsEnabledEvent";
		static public const PARTICIPANTS_DISABLED:String = "hangoutManagerParticipantsDisabledEvent";
		static public const ENABLED_PARTICIPANTS_CHANGED:String = "hangoutManagerEnabledParticipantsChangedEvent";
		static public const VOLUMES_CHANGED:String = "hangoutManagerVolumesChangedEvent";
		static public const STATE_CHANGED:String = "hangoutManagerStateChangedEvent";
		static public const MESSAGE_RECEIVED:String = "hangoutManagerMessageReceivedEvent";
		static public const BROADCASTING_CHANGED:String = "hangoutManagerBroadcastingChangedEvent";
		static public const FACE_TRACKING_DATA_CHANGED:String = "hangoutFaceTrackingDataChangedEvent";
		static public const APP_VISIBLE_CHANGED:String = "hangoutAppVisibleChangedEvent";
		static public const PUBLIC_CHANGED:String = "hangoutPublicChangedEvent";
		static public const CAMERA_MUTE_CHANGED:String = "hangoutCameraMuteChangedEvent";
		static public const HAS_CAMERA_CHANGED:String = "hangoutHasCameraChangedEvent";
		static public const HAS_MIC_CHANGED:String = "hangoutHasMicChangedEvent";
		static public const HAS_SPEAKERS_CHANGED:String = "hangoutHasSpeakersChangedEvent";
		static public const MIC_MUTE_CHANGED:String = "hangoutMicMuteChangedEvent";
		static public const HAS_NOTICE:String = "hangoutHasNoticeEvent";
		static public const CHAT_PANE_VISIBLE:String = "hangoutChatPaneVisibleEvent";
		
		private var _data:Object;
		
		public function HangoutManagerEvent(type:String, $data:Object=null, bubbles:Boolean=false, cancelable:Boolean=false) 
		{//HangoutManagerEvent 
			super(type, bubbles, cancelable);
			_data = $data;
			
		}//HangoutManagerEvent
		
		public override function clone():Event 
		{ 
			return new HangoutManagerEvent(type, data, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("HangoutManagerEvent", "type", "data", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get data():Object {return _data;}
	}//HangoutManagerEvent Class
	
}//Packge
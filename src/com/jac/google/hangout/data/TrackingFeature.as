package com.jac.google.hangout.data 
{
	/**
	 * ...
	 * @author Jake Callery
	 */
	public class TrackingFeature 
	{//TrackingFeature Class
		static public const LEFT_EYE:String = "gapi.hangout.av.effects.FaceTrackingFeature.LEFT_EYE";
		static public const LEFT_EYEBROW_LEFT:String = "gapi.hangout.av.effects.FaceTrackingFeature.LEFT_EYEBROW_LEFT";
		static public const LEFT_EYEBROW_RIGHT:String = "gapi.hangout.av.effects.FaceTrackingFeature.LEFT_EYEBROW_RIGHT";
		static public const LOWER_LIP:String = "gapi.hangout.av.effects.FaceTrackingFeature.LOWER_LIP";
		static public const MOUTH_CENTER:String = "gapi.hangout.av.effects.FaceTrackingFeature.MOUTH_CENTER";
		static public const MOUTH_LEFT:String = "gapi.hangout.av.effects.FaceTrackingFeature.MOUTH_LEFT";
		static public const MOUTH_RIGHT:String = "gapi.hangout.av.effects.FaceTrackingFeature.MOUTH_RIGHT";
		static public const NOSE_ROOT:String = "gapi.hangout.av.effects.FaceTrackingFeature.NOSE_ROOT";
		static public const NOSE_TIP:String = "gapi.hangout.av.effects.FaceTrackingFeature.NOSE_TIP";
		static public const RIGHT_EYE:String = "gapi.hangout.av.effects.FaceTrackingFeature.RIGHT_EYE";
		static public const RIGHT_EYEBROW_LEFT:String = "gapi.hangout.av.effects.FaceTrackingFeature.RIGHT_EYEBROW_LEFT";
		static public const RIGHT_EYEBROW_RIGHT:String = "gapi.hangout.av.effects.FaceTrackingFeature.RIGHT_EYEBROW_RIGHT";
		static public const UPPER_LIP:String = "gapi.hangout.av.effects.FaceTrackingFeature.UPPER_LIP";
		
		static public function getFullString($feature:String):String
		{//getFullString
			return TrackingFeature[$feature];
		}//getFullString
	}//TrackingFeature Class

}
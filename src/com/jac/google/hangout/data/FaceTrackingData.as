package com.jac.google.hangout.data 
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author Jake Callery
	 */
	public class FaceTrackingData 
	{//FaceTrackingData Class
		
		public var hasFace:Boolean;
		
		public var pan:Number;
		public var roll:Number;
		public var tilt:Number;
		
		public var leftEye:Point;
		public var leftEyebrowLeft:Point;
		public var leftEyebrowRight:Point;
		public var lowerLip:Point;
		public var mouthCenter:Point;
		public var mouthLeft:Point;
		public var mouthRight:Point;
		public var noseRoot:Point;
		public var noseTip:Point;
		public var rightEye:Point;
		public var rightEyebrowLeft:Point;
		public var rightEyebrowRight:Point;
		public var upperLip:Point;
		
		public var rawObj:Object;
		
		public function FaceTrackingData($rawObj:Object) 
		{//FaceTrackingData
			rawObj = $rawObj;
			
			hasFace = rawObj.hasFace;
			pan = rawObj.pan;
			roll = rawObj.roll;
			tilt = rawObj.tilt;
			
			leftEye = new Point(rawObj.leftEye.x, rawObj.leftEye.y);
			leftEyebrowLeft = new Point(rawObj.leftEyebrowLeft.x, rawObj.leftEyebrowLeft.y);
			leftEyebrowRight = new Point(rawObj.leftEyebrowRight.x, rawObj.leftEyebrowRight.y);
			lowerLip = new Point(rawObj.lowerLip.x, rawObj.lowerLip.y);
			mouthCenter = new Point(rawObj.mouthCenter.x, rawObj.mouthCenter.y);
			mouthLeft = new Point(rawObj.mouthLeft.x, rawObj.mouthLeft.y);
			mouthRight = new Point(rawObj.mouthRight.x, rawObj.mouthRight.y);
			noseRoot = new Point(rawObj.noseRoot.x, rawObj.noseRoot.y);
			noseTip = new Point(rawObj.noseTip.x, rawObj.noseTip.y);
			rightEye = new Point(rawObj.rightEye.x, rawObj.rightEye.y);
			rightEyebrowLeft = new Point(rawObj.rightEyebrowLeft.x, rawObj.rightEyebrowLeft.y);
			rightEyebrowRight = new Point(rawObj.rightEyebrowRight.x, rawObj.rightEyebrowRight.y);
			upperLip = new Point(rawObj.upperLip.x, rawObj.upperLip.y);
			
		}//FaceTrackingData
		
	}//FaceTrackingData Class

}
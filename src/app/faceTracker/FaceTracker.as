package app.faceTracker 
{
	import app.data.DataHolder;
	import com.jac.google.hangout.events.HangoutManagerEvent;
	import com.jac.log.Log;
	import com.jac.utils.ObjUtils;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author Jake Callery
	 */
	public class FaceTracker extends EventDispatcher 
	{//FaceTracker Class
		
		private const GLOBAL_X_OFFSET:Number = 107;
		private const GLOBAL_Y_OFFSET:Number = 204;
		private const GLOBAL_X_SCALE:Number = 300;
		private const GLOBAL_Y_SCALE:Number = 300;
		
		private var _dh:DataHolder = DataHolder.getInstance();
		private var _view:FaceTrackerView;
		
		private var _leftEyeDot:Sprite;
		private var _leftEyebrowLeftDot:Sprite;
		private var _leftEyebrowRightDot:Sprite;
		private var _lowerLipDot:Sprite;
		private var _mouthCenterDot:Sprite;
		private var _mouthLeftDot:Sprite;
		private var _mouthRightDot:Sprite;
		private var _noseRootDot:Sprite;
		private var _noseTipDot:Sprite;
		private var _rightEyeDot:Sprite;
		private var _rightEyebrowLeftDot:Sprite;
		private var _rightEyebrowRightDot:Sprite;
		private var _upperLipDot:Sprite;
		
		public function FaceTracker($view:FaceTrackerView=null) 
		{//FaceTracker
			
			_view = (($view!=null)?$view : new FaceTrackerView());
			
			_leftEyeDot = new Sprite();
			_leftEyebrowLeftDot = new Sprite();
			_leftEyebrowRightDot = new Sprite();
			_lowerLipDot = new Sprite();
			_mouthCenterDot = new Sprite();
			_mouthLeftDot = new Sprite();
			_mouthRightDot = new Sprite();
			_noseRootDot = new Sprite();
			_noseTipDot = new Sprite();
			_rightEyeDot = new Sprite();
			_rightEyebrowLeftDot = new Sprite();
			_rightEyebrowRightDot = new Sprite();
			_upperLipDot = new Sprite();
			
			_view.addChild(_leftEyeDot);
			_view.addChild(_leftEyebrowLeftDot);
			_view.addChild(_leftEyebrowRightDot);
			_view.addChild(_lowerLipDot);
			_view.addChild(_mouthCenterDot);
			_view.addChild(_mouthLeftDot);
			_view.addChild(_mouthRightDot);
			_view.addChild(_noseRootDot);
			_view.addChild(_noseTipDot);
			_view.addChild(_rightEyeDot);
			_view.addChild(_rightEyebrowLeftDot);
			_view.addChild(_rightEyebrowRightDot);
			_view.addChild(_upperLipDot);
			
			
			_leftEyeDot.graphics.beginFill(0x009900, 1);
			_leftEyeDot.graphics.drawCircle(3, 3, 3);
			_leftEyeDot.graphics.endFill();
			
			_leftEyebrowLeftDot.graphics.beginFill(0x009900, 1);
			_leftEyebrowLeftDot.graphics.drawCircle(3, 3, 3);
			_leftEyebrowLeftDot.graphics.endFill();
			
			_leftEyebrowRightDot.graphics.beginFill(0x009900, 1);
			_leftEyebrowRightDot.graphics.drawCircle(3, 3, 3);
			_leftEyebrowRightDot.graphics.endFill();
			
			_lowerLipDot.graphics.beginFill(0x009900, 1);
			_lowerLipDot.graphics.drawCircle(3, 3, 3);
			_lowerLipDot.graphics.endFill();
			
			_mouthCenterDot.graphics.beginFill(0x009900, 1);
			_mouthCenterDot.graphics.drawCircle(3, 3, 3);
			_mouthCenterDot.graphics.endFill();
			
			_mouthLeftDot.graphics.beginFill(0x009900, 1);
			_mouthLeftDot.graphics.drawCircle(3, 3, 3);
			_mouthLeftDot.graphics.endFill();
			
			_mouthRightDot.graphics.beginFill(0x009900, 1);
			_mouthRightDot.graphics.drawCircle(3, 3, 3);
			_mouthRightDot.graphics.endFill();
			
			_noseRootDot.graphics.beginFill(0x009900, 1);
			_noseRootDot.graphics.drawCircle(3, 3, 3);
			_noseRootDot.graphics.endFill();
			
			_noseTipDot.graphics.beginFill(0x009900, 1);
			_noseTipDot.graphics.drawCircle(3, 3, 3);
			_noseTipDot.graphics.endFill();
			
			_rightEyeDot.graphics.beginFill(0x009900, 1);
			_rightEyeDot.graphics.drawCircle(3, 3, 3);
			_rightEyeDot.graphics.endFill();
			
			_rightEyebrowLeftDot.graphics.beginFill(0x009900, 1);
			_rightEyebrowLeftDot.graphics.drawCircle(3, 3, 3);
			_rightEyebrowLeftDot.graphics.endFill();
			
			_rightEyebrowRightDot.graphics.beginFill(0x009900, 1);
			_rightEyebrowRightDot.graphics.drawCircle(3, 3, 3);
			_rightEyebrowRightDot.graphics.endFill();
			
			_upperLipDot.graphics.beginFill(0x009900, 1);
			_upperLipDot.graphics.drawCircle(3, 3, 3);
			_upperLipDot.graphics.endFill();
			
			_view.addChild(_leftEyeDot);
			
			_view.volText.autoSize = TextFieldAutoSize.LEFT;
			
			if (_dh.hangoutManager.isReady)
			{//ready
				handleHMReady(null);
			}//ready
			else
			{//wait
				_dh.hangoutManager.addEventListener(HangoutManagerEvent.READY, handleHMReady);
			}//wait
			
		}//FaceTracker
		
		private function handleHMReady(e:HangoutManagerEvent):void 
		{//handleHMReady
			_dh.hangoutManager.addEventListener(HangoutManagerEvent.FACE_TRACKING_DATA_CHANGED, handleTrackingData);
			_dh.hangoutManager.addEventListener(HangoutManagerEvent.VOLUMES_CHANGED, handleVolumesChanged);
		}//handleHMReady
		
		private function handleVolumesChanged(e:HangoutManagerEvent):void 
		{//handleVolumesChanged
			var vols:String = "";
			
			//Log.log("Volumes: " + ObjUtils.getDynamicProps(e.data.volumes), "@ui");
			
			for (var id:String in e.data.volumes)
			{//vols
				vols += (e.data.volumes[id].toString() + ",");
			}//vols
			
			vols = vols.substring(0, vols.length - 1);
			
			_view.volText.text = vols;
		}//handleVolumesChanged
		
		private function handleTrackingData(e:HangoutManagerEvent):void 
		{//handleTrackingData
			_view.hasFaceText.text = e.data.hasFace.toString();
			
			if (e.data.hasFace == true)
			{//
				_view.panText.text = e.data.pan.toString();
				_view.tiltText.text = e.data.tilt.toString();
				_view.rollText.text = e.data.roll.toString();
				
				_leftEyeDot.x = (e.data.leftEye.x * GLOBAL_X_SCALE) + GLOBAL_X_OFFSET;
				_leftEyeDot.y = (e.data.leftEye.y * GLOBAL_Y_SCALE) + GLOBAL_Y_OFFSET;
				
				_leftEyebrowLeftDot.x = (e.data.leftEyebrowLeft.x * GLOBAL_X_SCALE) + GLOBAL_X_OFFSET;
				_leftEyebrowLeftDot.y = (e.data.leftEyebrowLeft.y * GLOBAL_Y_SCALE) + GLOBAL_Y_OFFSET;
				
				_leftEyebrowRightDot.x = (e.data.leftEyebrowRight.x * GLOBAL_X_SCALE) + GLOBAL_X_OFFSET;
				_leftEyebrowRightDot.y = (e.data.leftEyebrowRight.y * GLOBAL_Y_SCALE) + GLOBAL_Y_OFFSET;
				
				_lowerLipDot.x = (e.data.lowerLip.x * GLOBAL_X_SCALE) + GLOBAL_X_OFFSET;
				_lowerLipDot.y = (e.data.lowerLip.y * GLOBAL_Y_SCALE) + GLOBAL_Y_OFFSET;
				
				_mouthCenterDot.x = (e.data.mouthCenter.x * GLOBAL_X_SCALE) + GLOBAL_X_OFFSET;
				_mouthCenterDot.y = (e.data.mouthCenter.y * GLOBAL_Y_SCALE) + GLOBAL_Y_OFFSET;
				
				_mouthLeftDot.x = (e.data.mouthLeft.x * GLOBAL_X_SCALE) + GLOBAL_X_OFFSET;
				_mouthLeftDot.y = (e.data.mouthLeft.y * GLOBAL_Y_SCALE) + GLOBAL_Y_OFFSET;
				
				_mouthRightDot.x = (e.data.mouthRight.x * GLOBAL_X_SCALE) + GLOBAL_X_OFFSET;
				_mouthRightDot.y = (e.data.mouthRight.y * GLOBAL_Y_SCALE) + GLOBAL_Y_OFFSET;
				
				_noseRootDot.x = (e.data.noseRoot.x * GLOBAL_X_SCALE) + GLOBAL_X_OFFSET;
				_noseRootDot.y =(e.data.noseRoot.y * GLOBAL_Y_SCALE) + GLOBAL_Y_OFFSET;
				
				_noseTipDot.x = (e.data.noseTip.x * GLOBAL_X_SCALE) + GLOBAL_X_OFFSET;
				_noseTipDot.y = (e.data.noseTip.y * GLOBAL_Y_SCALE) + GLOBAL_Y_OFFSET;
				
				_rightEyeDot.x = (e.data.rightEye.x * GLOBAL_X_SCALE) + GLOBAL_X_OFFSET;
				_rightEyeDot.y = (e.data.rightEye.y * GLOBAL_Y_SCALE) + GLOBAL_Y_OFFSET;
				
				_rightEyebrowLeftDot.x = (e.data.rightEyebrowLeft.x * GLOBAL_X_SCALE) + GLOBAL_X_OFFSET;
				_rightEyebrowLeftDot.y = (e.data.rightEyebrowLeft.y * GLOBAL_Y_SCALE) + GLOBAL_Y_OFFSET;
				
				_rightEyebrowRightDot.x = (e.data.rightEyebrowRight.x * GLOBAL_X_SCALE) + GLOBAL_X_OFFSET;
				_rightEyebrowRightDot.y = (e.data.rightEyebrowRight.y * GLOBAL_Y_SCALE) + GLOBAL_Y_OFFSET;
				
				_upperLipDot.x = (e.data.upperLip.x * GLOBAL_X_SCALE) + GLOBAL_X_OFFSET;
				_upperLipDot.y = (e.data.upperLip.y * GLOBAL_Y_SCALE) + GLOBAL_Y_OFFSET;
				
			}//
		}//handleTrackingData
		
		public function get view():FaceTrackerView 
		{
			return _view;
		}
		
	}//FaceTracker Class

}
package 
{
	import app.data.DataHolder;
	import app.data.EventCenter;
	import app.events.AppEvent;
	import app.ui.MainUI;
	import com.jac.google.hangout.events.HangoutManagerEvent;
	import com.jac.google.hangout.HangoutBridge;
	import com.jac.google.hangout.HangoutManager;
	import com.jac.jsBridge.events.JSBridgeEvent;
	import com.jac.jsBridge.JSBridge;
	import com.jac.log.DebugLevel;
	import com.jac.log.Log;
	import com.jac.log.targets.BrowserConsoleTarget;
	import com.jac.log.targets.ScrollableTextFieldTarget;
	import com.jac.log.targets.TraceTarget;
	import com.jac.log.VerboseLevel;
	import com.jac.utils.ObjUtils;
	import com.jac.utils.WebUtils;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.Security;
	
	/**
	 * ...
	 * @author Jake Callery
	 */
	public class Main extends Sprite 
	{//Main Class
		
		private var _mainUI:MainUI;
		private var _dh:DataHolder = DataHolder.getInstance();
		private var _ec:EventCenter = EventCenter.getInstance();
		
		public function Main():void 
		{//Main
			
			//Allow access
			Security.allowInsecureDomain("*");
			Security.allowDomain('*');
			
			Log.addLogTarget(new TraceTarget());
			Log.addLogTarget(new BrowserConsoleTarget());
			Log.setVerboseFilter(VerboseLevel.LEVEL | VerboseLevel.CLASS | VerboseLevel.FUNCTION | VerboseLevel.TIME | VerboseLevel.LINE | VerboseLevel.NORMAL);
			Log.setLevelFilter(DebugLevel.ALL);
			Log.enable(true);
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}//Main
		
		private function init(e:Event = null):void 
		{//init
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			// entry point
			var defaultObj:Object = new Object();
			defaultObj.baseProto = "https://";
			defaultObj.baseDomain = "hangouts.byhook.com";
			defaultObj.basePath = "/hangouttestbed";
			defaultObj.baseAvatarsPath = "/avatars";
			defaultObj.baseOverlaysPath = "/overlays";
			defaultObj.baseSoundsPath = "/sounds";
			defaultObj.appID = "16018758775";
			
			//Grab params
			var params:Object = WebUtils.getVars(stage.loaderInfo, "baseDomain", defaultObj);
			_dh.baseProto = params.baseProto;
			_dh.baseDomain = params.baseDomain;
			_dh.basePath = params.basePath;
			_dh.appID = params.appID;
			_dh.baseAvatarsPath = params.baseAvatarsPath;
			_dh.baseOverlaysPath = params.baseOverlaysPath;
			_dh.baseSoundsPath = params.baseSoundsPath;
			
			//Set up bridge
			_dh.jsBridge = new JSBridge();
			_dh.jsBridge.addEventListener(JSBridgeEvent.BRIDGE_READY, handleJSBridgeReady);
			_dh.jsBridge.initJS(false, false);
			
		}//init
		
		private function handleJSBridgeReady(e:JSBridgeEvent):void 
		{//handleBridgeReady
			Log.log("Caught JS Bridge Ready", "@main");
			_dh.hangoutBridge = new HangoutBridge();
			
			Log.log("Init Hangout Bridge", "@main");
			_dh.hangoutBridge.init(_dh.jsBridge);
			
			Log.log("Make new Hangout Manager", "@main");
			_dh.hangoutManager = new HangoutManager(_dh.hangoutBridge);
			_dh.hangoutManager.addEventListener(HangoutManagerEvent.STATE_CHANGED, handleStateChanged);
			
			//Set up UI
			_mainUI = new MainUI();
			addChild(_mainUI.view);
			Log.addLogTarget(new ScrollableTextFieldTarget(_mainUI.view.debugText, _mainUI.view.debugTextUIScrollBar));
			
			//Wait for hangout ready
			if (!_dh.hangoutManager.isReady)
			{//wait
				Log.log("HM Not yet ready in Main", "@main");
				_dh.hangoutManager.addEventListener(HangoutManagerEvent.READY, handleHangoutManagerReady);
			}//wait
			else
			{//start up
				Log.log("HM already ready, start", "@main");
				handleHangoutManagerReady();
			}//start up
			
		}//handleBridgeReady
		
		private function handleStateChanged(e:HangoutManagerEvent):void 
		{//handleStateChanged
			//Log.log("Caught State Changed", "@main");
			//Log.log("State Meta Data:", "@main");
			var state:Object = _dh.hangoutManager.getStateMetadata();
			//Log.log(ObjUtils.getDynamicProps(state), "@main");
		}//handleStateChanged
		
		private function handleHangoutManagerReady(e:HangoutManagerEvent=null):void 
		{//handleHangoutManagerReady
			Log.log("Caught Hangout Manager Ready", "@main");
			_dh.hangoutManager.removeEventListener(HangoutManagerEvent.READY, handleHangoutManagerReady);
			_ec.dispatchEvent(new AppEvent(AppEvent.APP_READY));
		}//handleHangoutManagerReady
		
	}//Main Class
	
}
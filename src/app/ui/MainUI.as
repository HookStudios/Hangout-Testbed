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
	import com.jac.log.Log;
	import com.jac.utils.DataProviderUtils;
	import com.jac.utils.MathUtils;
	import com.jac.utils.ObjUtils;
	import fl.controls.CheckBox;
	import fl.data.DataProvider;
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
	public class MainUI extends EventDispatcher 
	{//MainUI Class
		
		private var _view:MainUIView;
		private var _page2:Page2UI;
		private var _page1:Page1UI;
		
		private var _ec:EventCenter = EventCenter.getInstance();
		private var _dh:DataHolder = DataHolder.getInstance();
		
		private var _pages:Array;
		private var _pageIndex:int;
		
		public function MainUI() 
		{//MainUI
			_view = new MainUIView();
			_pages = [];
			
			_pageIndex = 0;
			
			_page1 = new Page1UI(_view.page1View);
			_view.page1View.visible = true;
			_pages.push(_page1);
			_page1.addEventListener(AppEvent.NEXT_PAGE, handleNextPage);
			_page1.addEventListener(AppEvent.CLEAR_LOG, handleClearLog);
			
			_page2 = new Page2UI(_view.page2View);
			_view.page2View.visible = false;
			_pages.push(_page2);
			_page2.addEventListener(AppEvent.NEXT_PAGE, handleNextPage);
			
			if (_dh.hangoutManager.isReady)
			{//ready
				handleHMReady(null);
			}//ready
			else
			{//wait
				_dh.hangoutManager.addEventListener(HangoutManagerEvent.READY, handleHMReady);
			}//wait
			
			if (_view.stage)
			{//
				handleAddedToStage(null);
			}//
			else
			{//
				_view.addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
			}//
			
		}//MainUI
		
		private function handleClearLog(e:AppEvent):void 
		{//handleClearLog
			_view.debugText.text = "";
		}//handleClearLog
		
		private function handleAddedToStage(e:Event):void 
		{//handleAddedToStage
			removeEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
		}//handleAddedToStage
		
		private function handleHMReady(e:HangoutManagerEvent):void 
		{//handleHMReady
			Log.enable(_dh.hangoutManager.isLoggingEnabled);
		}//handleHMReady
		
		private function handleNextPage(e:AppEvent):void 
		{//handleNextPage
			IPage(_pages[_pageIndex]).view.visible = false;
			
			_pageIndex++;
			if (_pageIndex >= _pages.length)
			{//loop
				_pageIndex = 0;
			}//loop
			
			IPage(_pages[_pageIndex]).view.visible = true;
		}//handleNextPage
		
		private function handlePage2Click(e:MouseEvent):void 
		{//handlePage2Click
			_view.page2View.visible = true;
		}//handlePage2Click
		
		
		
		public function get view():MainUIView 
		{
			return _view;
		}
		
	}//MainUI Class

}
package com.jac.log.targets 
{
	import fl.controls.UIScrollBar;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Jake Callery
	 */
	public class ScrollableTextFieldTarget extends TextFieldTarget 
	{//ScrollableTextFieldTarget Class
	
		private var _scrollBar:UIScrollBar;
	
		public function ScrollableTextFieldTarget(textField:TextField, scrollBar:UIScrollBar) 
		{//ScrollableTextFieldTarget
			super(textField);
			
			_scrollBar = scrollBar;
			_scrollBar.scrollTarget = _field;
			
		}//ScrollableTextFieldTarget
		
		override public function output(...args):void 
		{//output
			var autoScroll:Boolean = (_scrollBar.scrollPosition == _field.maxScrollV);
			super.output(args);
			
			if (autoScroll)
			{//
				_scrollBar.scrollPosition = _field.maxScrollV;
				_scrollBar.invalidate();
			}//
			
		}//output
		
	}//ScrollableTextFieldTarget Class

}
package com.jac.log.targets 
{//Package
	import com.jac.log.ILogTarget;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	/**
	 * ...
	 * @author Jake Callery
	 */
	public class FileTarget extends EventDispatcher implements ILogTarget
	{//FileTarget Class
	
		private var _enabled:Boolean;
		private var _file:File;
		private var _fStream:FileStream;
		private var _doClearFile:Boolean;
		
		public function FileTarget(file:File, clearFile:Boolean) 
		{//FileTarget
			_doClearFile = clearFile;
			_file = file;
			_fStream = new FileStream();
			
			_enabled = true;
		}//FileTarget
		
		/* INTERFACE com.jac.log.ILogTarget */
		public function get enabled():Boolean
		{//get enabled
			return _enabled;
		}//get enabled
		
		public function set enabled(value:Boolean):void
		{//set enabled
			_enabled = value;
		}//set enabled
		
		public function output(...args):void
		{//output
			if (_doClearFile)
			{//clear
				_fStream.open(_file, FileMode.WRITE);
				_doClearFile = false;
			}//clear
			else
			{//append
				_fStream.open(_file, FileMode.APPEND);
			}//append
			
			for each(var arg:String in args)
			{//out
				_fStream.writeUTFBytes(arg);
			}//out
			
			_fStream.writeUTFBytes("\n");
			_fStream.close();
		}//output
		
		
	}//FileTarget Class

}//Package
package com.jac.google.hangout.data 
{
	/**
	 * ...
	 * @author Jake Callery
	 */
	public class Participant 
	{//Particpant Class
		
		public var raw:Object;
		public var id:String;
		public var displayIndex:int;
		public var hasMicrophone:Boolean;
		public var hasCamera:Boolean;
		public var hasAppEnabled:Boolean
		public var person:Person;
		
		public function Participant($raw:Object) 
		{//Participant
			raw = $raw;
			id = String($raw.id);
			displayIndex = parseInt($raw.displayIndex);
			hasMicrophone = $raw.hasMicrophone;
			hasCamera = $raw.hasCamera;
			hasAppEnabled = $raw.hasAppEnabled;
			person = new Person($raw.person);
		}//Participant
		
	}//Particpant Class

}
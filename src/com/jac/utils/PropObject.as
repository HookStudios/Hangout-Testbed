package com.jac.utils 
{
	public class PropObject
	{//PropObject Class
	
		private var _name:String;
		private var _value:Object;
		private var _access:String;
		private var _type:String;
		private var _declaredBy:String;
		
		public function PropObject(name:String, access:String, type:String, declaredBy:String, value:Object) 
		{//PropObject
			_name = name;
			_access = access;
			_type = type;
			_declaredBy = declaredBy;
			_value = value;
		}//PropObject
		
		public function toString():String 
		{//toString
			
			var result:String = "";
			result += ("Name: " + _name + "\n");
			result += ("Value: " + _value + "\n");
			result += ("Access: " + _access + "\n");
			result += ("Type: " + _type + "\n");
			result += ("DeclaredBy: " + _declaredBy + "\n");
			
			return result;
		}//toString
		
		public function get name():String { return _name; }
		public function get value():Object { return _value; }
		public function get access():String { return _access; }
		public function get type():String { return _type; }
		public function get declaredBy():String { return _declaredBy; }
		
	}//PropObject Class

}
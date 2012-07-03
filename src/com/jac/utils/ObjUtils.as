package com.jac.utils 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.utils.ByteArray;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	import flash.xml.XMLNode;
	/**
	 * A utility class that contains methods to make objects more convenient to use.
	 * <br/>Please be aware that these are under constant development and may not be fully tested.
	 */
	public class ObjUtils
	{//ObjUtils Class
		
		/*
		public static function deepCopy($objToClone:*):Object
        {//deepCopy
            var clone:ByteArray = new ByteArray();
            clone.writeObject( reference );
            clone.position = 0;
            return clone.readObject();
        }//deepCopy
		*/
		
		/**
		 * This will list out each dynamic property of the generic object along with its value.
		 * @param	obj	the object to trace the dynamic properties of.
		 */
		static public function traceObj(obj:Object):String
		{//traceObj
			trace("Object: " + obj);
			
			var finalString:String = ("Object: " + obj);
			
			for (var prop:String in obj)
			{//trace each prop
				trace("- " + prop + ": " + obj[prop]);
				finalString += ("\n" + "- " + prop + ": " + obj[prop]);
			}//trace each prop
			
			return finalString;
		}//traceObj
		
		/**
		 * Utility function to describe the dynamic properties of an object.  Results are returned as a formatted string.  This is
		 * meant to be used simply as a visual aid.  It supports indexed arrays, associative arrays and dictionaries, but not vectors (FP9 compatibility)
		 * 
		 * @param	$obj the object you would like describe the dynamic props of
		 * @param	$tabString (optional) probably just want to leave this blank.  This is here to simply support formatting during recursion
		 * @return	a formatted string to help visualize the structure of the dynamic properties of an object
		 */
		static public function getDynamicProps($obj:Object, $tabString:String="", $propLabel:String=""):String
		{//getDynamicProps
			
			if ($obj == null)
			{//done
				return "NULL";
			}//done
			
			var propLabel:String = $propLabel;
			if (propLabel != "")
			{//
				propLabel = "(" + $propLabel + ")";
			}//
			
			var finalString:String = ("\n" + $tabString + "- Object" + propLabel + ": " + $obj);
			
			if ($obj.hasOwnProperty("name"))
			{//show name
				finalString += (" - " + $obj["name"]);
			}//show name
			
			var newTabs:String = "\t";
			
			for (var prop:String in $obj)
			{//each prop
				newTabs = "\t";
				if ($obj[prop] != null)
				{//good result
					if ($obj[prop] is Array)
					{//list
						finalString += ("\n" + ($tabString + newTabs) + "- " + prop + ": Array");
						newTabs += "\t";
						for (var i:int = 0; i < int($obj[prop]["length"]); i++)
						{//try each
							try
							{//try
								if ($obj[prop][i])
								{//if object, recurse
									if (String($obj[prop][i].toString()).charAt(0) == "[")
									{//
										//finalString += ObjUtils.getDynamicProps($obj[prop][i], (($tabString + newTabs) + "\t"));
										finalString += ObjUtils.getDynamicProps($obj[prop][i], (($tabString + newTabs)));
									}//
									else
									{//display
										finalString += ("\n" + ($tabString + newTabs) + "- " + getQualifiedClassName($obj[prop][i]) + ": " + $obj[prop][i]);
									}//display
								}//if object, recures
							}//try
							catch (err:Error)
							{//Skip
							}//Skip
						}//try each
					}//list
					else if (!(String($obj[prop].toString()).charAt(0) == "["))
					{//string
						finalString += ("\n" + ($tabString + newTabs) + "- " + prop + ": " + $obj[prop]);
					}//string
					//else if ($obj[prop].valueOf() is Object)
					else
					{//recurse
						finalString += ObjUtils.getDynamicProps($obj[prop], (($tabString + newTabs)), prop);
					}//recurse
				}//good result
				else
				{//null prop
					finalString += ("\n" + ($tabString + newTabs) + "- " + prop + ": " + "NULL");
				}//null prop
			}//each prop
			
			
			return finalString;
		}//getDynamicProps
		
		static public function traceDirectProps(obj:Object, includeBaseClass:Boolean = true, includeDirectClass:Boolean = true, listOfFullyQualifiedClassNames:Array = null):String
		{//traceDirectProps
			var props:Array = getDirectProps(obj, includeBaseClass, includeDirectClass, listOfFullyQualifiedClassNames);
			var finalString:String = "";
			
			for (var i:int = 0; i < props.length; i++)
			{//each propObj
				finalString += (props[i].toString() + "\n");
			}//each propObj
			
			trace(finalString);
			return finalString;
		}//traceDirectProps
		
		static public function getDirectProps(obj:Object, includeBaseClass:Boolean = true, includeDirectClass:Boolean = true, listOfFullyQualifiedClassNames:Array=null, includeDynamicProps:Boolean=true):Array
		{//getDirectProps
			var classList:Array = new Array();
			var fullClassName:String = getQualifiedClassName(obj);
			var fullTypeXML:XML = describeType(obj);
			var typeXMLList:XMLList;
			var tmpXML:XML;
			
			if (includeDirectClass)
			{//add direct class to class list
				classList.push(fullTypeXML.@name);
			}//add direct class to class list
			
			if (includeBaseClass)
			{//add base class to class list
				classList.push(fullTypeXML.@base)
			}//add base class to class list
			
			if (listOfFullyQualifiedClassNames)
			{//tack on extras
				classList = classList.concat(listOfFullyQualifiedClassNames);
			}//tack on extras
			
			var propList:Array = new Array();
			
			if (includeDynamicProps)
			{//loop over dynamic props
				for (var dProp:String in obj)
				{//each prop
					var dPropObj:PropObject = new PropObject(dProp, "readwrite", "dynamic", "dynamic", obj[dProp]);
					propList[dProp] = dPropObj;
				}//each prop
			}//loop over dynamic props
			
			for each(var variableXML:XML in fullTypeXML.variable)
			{
				var propObject:PropObject = new PropObject(variableXML.@name, variableXML.@access, variableXML.@type, variableXML.@declaredBy, obj[variableXML.@name]);
				propList[propObject.name] = propObject;
			}
			
			for (var i:int = 0; i < classList.length; i++)
			{//grab props for each declared by class
				typeXMLList = fullTypeXML.accessor.(@declaredBy == classList[i]);
				
				for each (var prop:XML in typeXMLList)
				{//walk props
					var newProp:PropObject = new PropObject(prop.@name, prop.@access, prop.@type, prop.@declaredBy, obj[prop.@name]);
					//trace("New Prop: " + newProp);
					propList.push(newProp);
				}//walk props
				
			}//grab props for each declared by class
			
			return propList;
		}//getDirectProps
		
		static public function getDirectPropsDictionary(obj:Object, includeBaseClass:Boolean = true, includeDirectClass:Boolean = true, listOfFullyQualifiedClassNames:Array=null):Array
		{//getDirectProps
			var classList:Array = new Array();
			var fullClassName:String = getQualifiedClassName(obj);
			var fullTypeXML:XML = describeType(obj);
			var typeXMLList:XMLList;
			var tmpXML:XML;
			
			if (includeDirectClass)
			{//add direct class to class list
				classList.push(fullTypeXML.@name);
			}//add direct class to class list
			
			if (includeBaseClass)
			{//add base class to class list
				classList.push(fullTypeXML.@base)
			}//add base class to class list
			
			if (listOfFullyQualifiedClassNames)
			{//tack on extras
				classList = classList.concat(listOfFullyQualifiedClassNames);
			}//tack on extras
			
			var propList:Array = new Array();
			
			for each(var variableXML:XML in fullTypeXML.variable)
			{
				var propObject:PropObject = new PropObject(variableXML.@name, variableXML.@access, variableXML.@type, variableXML.@declaredBy, obj[variableXML.@name]);
				propList[propObject.name] = propObject;
			}
			
			for (var i:int = 0; i < classList.length; i++)
			{//grab props for each declared by class
				typeXMLList = fullTypeXML.accessor.(@declaredBy == classList[i]);
				
				for each (var prop:XML in typeXMLList)
				{//walk props
					var newProp:PropObject = new PropObject(prop.@name, prop.@access, prop.@type, prop.@declaredBy, obj[prop.@name]);
					//trace("New Prop: " + newProp);
					propList[newProp.name] = newProp;
				}//walk props
				
			}//grab props for each declared by class
			
			return propList;
		}//getDirectProps
		
		/**
         *  Generates a UID (unique identifier) based on ActionScript's
         *  pseudo-random number generator and the current time.
         *
         *  <p>The UID has the form
         *  <code>"XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"</code>
         *  where X is a hexadecimal digit (0-9, A-F).</p>
         *
         *  <p>This UID will not be truly globally unique; but it is the best
         *  we can do without player support for UID generation.</p>
         *
         *  @return The newly-generated UID.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public static function createUID():String
        {//createUID
			
			//Char codes for 0123456789ABCDEF
			const ALPHA_CHAR_CODES:Array = [48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 65, 66, 67, 68, 69, 70];
			
            var uid:Array = new Array(36);
            var index:int = 0;
           
            var i:int;
            var j:int;
           
            for (i = 0; i < 8; i++)
            {
                uid[index++] = ALPHA_CHAR_CODES[Math.floor(Math.random() *  16)];
            }
   
            for (i = 0; i < 3; i++)
            {
                uid[index++] = 45; // charCode for "-"
               
                for (j = 0; j < 4; j++)
                {
                    uid[index++] = ALPHA_CHAR_CODES[Math.floor(Math.random() *  16)];
                }
            }
           
            uid[index++] = 45; // charCode for "-"
   
            var time:Number = new Date().getTime();
            // Note: time is the number of milliseconds since 1970,
            // which is currently more than one trillion.
            // We use the low 8 hex digits of this number in the UID.
            // Just in case the system clock has been reset to
            // Jan 1-4, 1970 (in which case this number could have only
            // 1-7 hex digits), we pad on the left with 7 zeros
            // before taking the low digits.
            var timeString:String = ("0000000" + time.toString(16).toUpperCase()).substr(-8);
           
            for (i = 0; i < 8; i++)
            {
                uid[index++] = timeString.charCodeAt(i);
            }
           
            for (i = 0; i < 4; i++)
            {
                uid[index++] = ALPHA_CHAR_CODES[Math.floor(Math.random() *  16)];
            }
           
            return String.fromCharCode.apply(null, uid);
        }//createUID
		
		/**
		 * Returns and XML tree of all decendants of the root object currently on the root object's display list
		 * The returned format could look like this:
		 * <root>
		 *	  <object>
		 *		<class>TestObject</class>
		 *		<name>instance1</name>
		 *		<props>
		 *		  <x>0</x>
		 *		  <y>0</y>
		 *		</props>
		 *	  </object>
		 *    <object>
		 *		<class>OtherObject</class>
		 *		<name>neatoName</name>
		 *		<props>
		 *		  <x>0</x>
		 *		  <y>0</y>
		 *		</props>
		 *	  </object>
		 *	</root>
		 * @param	$rootObject the object to start with and search through
		 * @param	$xml the xml node you want to add this tree to..  pass in new XML("<root></root>") if its a standalone xml tree
		 * @param	$propNames and array of strings that are the names of the properties you want to retrieve the values of
		 * @return  the found display list in xml format
		 */
		static public function listDisplayObjects($rootObject:DisplayObjectContainer, $xml:XML=null, $propNames:Array=null):XML
		{//listDisplayObjects
			
			var objXML:XML = new XML("<object><class>" + getQualifiedClassName($rootObject) + "</class><name>" + $rootObject.name + "</name><props></props></object>");
			
			var p:int;
			var propName:String;
			var val:String;
			
			if ($propNames)
			{//get props
				for (p = 0; p < $propNames.length; p++)
				{//props
					propName = $propNames[p];
					val = "undefined";
					if ($rootObject[propName] != undefined)
					{//good prop
						val = $rootObject[propName];
					}//good 
					objXML.props.appendChild(new XML("<" + propName + ">" + val + "</" + propName + ">"));
				}//props
			}//get props
			
			for (var i:int = 0; i < $rootObject.numChildren; i++)
			{//check each child
				var child:Object = $rootObject.getChildAt(i);
			
				if (child is DisplayObjectContainer && child.numChildren > 0)
				{//check
					listDisplayObjects(DisplayObjectContainer(child), objXML, $propNames);
				}//check
				else
				{//just add child
					var childXML:XML = new XML("<object><class>" + getQualifiedClassName(child) + "</class><name>" + child.name + "</name><props></props></object>")
					
					if ($propNames)
					{//get child props
						for (p = 0; p < $propNames.length; p++)
						{//props
							propName = $propNames[p];
							val = "undefined";
							if (child[propName] != undefined)
							{//good prop
								val = child[propName];
							}//good 
							childXML.props.appendChild(new XML("<" + propName + ">" + val + "</" + propName + ">"));
						}//props
					}//get child props
					
					objXML.appendChild(childXML);
				}//just add child
			}//check each child
			
			$xml.appendChild(objXML);
			
			return $xml;
		}//listDisplayObjects
		
	}//ObjUtils Class

}
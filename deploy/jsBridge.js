/**
 * ...
 * @author Jake Callery
 */

var myBridge = {};
myBridge.thisMovie = function(movieName) 
{
	 if (navigator.appName.indexOf("Microsoft") != -1) 
	 {
		 return window[movieName];
	 } 
	 else 
	 {
		 return document[movieName];
	 }
};

initFromSwf = function()
{
	myBridge.swf = myBridge.thisMovie("altContent");
	myBridge.swf.notifyJSReady({bridgeName:"myBridge", swfProp:"swf"});
};
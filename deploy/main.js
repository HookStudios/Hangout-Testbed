logFromSwf = function(message)
{
	if(typeof(console) != 'undefined')
	{//log
		console.log(message);
	}//log
};

var flashvars = 
{
	baseProto:appSettings.baseProto,
	baseDomain:appSettings.baseDomain,
	basePath:appSettings.basePath,
	baseAvatarsPath:appSettings.baseAvatarsPath,
	baseOverlaysPath:appSettings.baseOverlaysPath,
	baseSoundsPath:appSettings.baseSoundsPath,
	appID:appSettings.appID
	
};
var params = {
	menu: "false",
	scale: "noScale",
	allowFullscreen: "true",
	allowScriptAccess: "always",
	allowNetworking: "all",
	bgcolor: "",
	wmode: "window"
};

var attributes = 
{
	
};

var hangoutBridge = new HangoutBridge(myBridge);
myBridge.hangoutBridge = hangoutBridge;

swfobject.embedSWF(appSettings.baseProto + appSettings.baseDomain + appSettings.basePath + "/HangoutTestBed.swf", "altContent", "1024px", "600px", "10.0.0", appSettings.baseProto + appSettings.baseDomain + appSettings.basePath + "/expressInstall.swf", flashvars, params, attributes);



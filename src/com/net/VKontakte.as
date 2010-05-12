package com.net
{
	import com.facecontrol.util.Util;
	import com.gsolo.encryption.MD5;
	import com.serialization.json.JSON;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.utils.Timer;
	
	public class VKontakte extends EventDispatcher
	{
		private static const FC_API_SERVER:String = 'http://api.vkontakte.ru/api.php';
		private static const APP_KEY:String = 'EqKl8Wg2be';
		
		private const loader:URLLoader = new URLLoader();
		private var requestQueue: Array;
		private var timer: Timer;
		private var currentMethod: String;
		
		public function VKontakte()
		{
			currentMethod = null;
			requestQueue = new Array();
			timer = new Timer(500, 0);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.start();
			loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			loader.addEventListener(Event.COMPLETE, completeHandler);
		}
		
		private function onTimer(event: TimerEvent): void {
			if (requestQueue.length > 0 && !currentMethod) {
				var r: Object = requestQueue.pop();
				request(r['method'], r['vars']);
			}
		}

		private function request(method: String, vars:URLVariables):void
		{
			if (!currentMethod) {
				currentMethod = method;
				var request: URLRequest = new URLRequest();
				request.url = FC_API_SERVER;
				request.data = vars;
				loader.load(request);
			}
			else {
				var r: Object = {'method': method, 'vars': vars};
				requestQueue.push(r);	
			}
		}
		
		private function errorHandler(e:IOErrorEvent):void {
			dispatchEvent(new VKontakteEvent(VKontakteEvent.ERROR, null, 255));
			currentMethod = null;
		}
		
		private function completeHandler(event:Event):void
		{
			trace("VKontakte:completeHandler: " + loader.data);
			try {
				var response:Object = JSON.deserialize(loader.data);
				
				if (response.hasOwnProperty('error')) {
					response = response.error;
					var errorCode:int = response.error_code;
					dispatchEvent(new VKontakteEvent(VKontakteEvent.ERROR, currentMethod, null, errorCode, response.error_msg));
				}
				else if (response.hasOwnProperty('response')) {
					response = response.response;
					dispatchEvent(new VKontakteEvent(VKontakteEvent.COMPLETED, currentMethod, response));
				}
			}
			catch (e:Error) {
				dispatchEvent(new VKontakteEvent(VKontakteEvent.ERROR, currentMethod, null, 254, e.message));
			}
			currentMethod = null;
		}
		
		public function getProfiles(uids:Array):void {
				var idsString:String = '';
				for each (var uid:String in uids) {
					idsString += uid + ',';
				}
				
				var vars: URLVariables = new URLVariables();
				var fields:String = 'uid,first_name,last_name,nickname,sex,bdate,city,photo_big,country';
				var sig:String = Util.viewer_id+'api_id='+Util.apiId+
					'fields='+fields+
					'format=json'+
					'method=getProfiles'+'test_mode=1'+'uids='+idsString+'v=2.0'+APP_KEY;
					
				vars['api_id'] = Util.apiId;
				vars['v'] = '2.0';
				vars['method'] = 'getProfiles';
				vars['uids'] = idsString;
				vars['fields'] = fields;
				vars['format'] = 'json';
				vars['test_mode'] = 1;
				vars['sig'] = MD5.encrypt(sig);
				
				request('getProfiles', vars);
		}
		
		public function isAppUser():void {
			var vars: URLVariables = new URLVariables();
			var sig:String = Util.viewer_id+'api_id='+Util.apiId+'format=json'+'method=isAppUser'+'test_mode=1'+'v=2.0'+APP_KEY;
			vars['api_id'] = Util.apiId;
			vars['v'] = '2.0';
			vars['method'] = 'isAppUser';
			vars['format'] = 'json';
			vars['test_mode'] = '1';
			vars['sig'] = MD5.encrypt(sig);
			
			request('isAppUser', vars);
		}
		
		public function getUserSettings():void {
			var vars: URLVariables = new URLVariables();
			var sig:String = Util.viewer_id+'api_id='+Util.apiId+'format=json'+'method=getUserSettings'+'test_mode=1'+'v=2.0'+APP_KEY;
			vars['api_id'] = Util.apiId;
			vars['v'] = '2.0';
			vars['method'] = 'getUserSettings';
			vars['format'] = 'json';
			vars['test_mode'] = '1';
			vars['sig'] = MD5.encrypt(sig);
			
			request('getUserSettings', vars);
		}
		
		public function getFriends():void {
			var vars: URLVariables = new URLVariables();
			var sig:String = Util.viewer_id+'api_id='+Util.apiId+'format=json'+'method=getFriends'+'test_mode=1'+'v=2.0'+APP_KEY;
			vars['api_id'] = Util.apiId;
			vars['v'] = '2.0';
			vars['method'] = 'getFriends';
			vars['format'] = 'json';
			vars['test_mode'] = '1';
			vars['sig'] = MD5.encrypt(sig);
			
			request('getFriends', vars);
		}
		
		public function getAppFriends():void {
			var vars: URLVariables = new URLVariables();
			var sig:String = Util.viewer_id+'api_id=1827403'+'format=json'+'method=getAppFriends'+'test_mode=1'+'v=2.0'+APP_KEY;
			vars['api_id'] = '1827403';
			vars['v'] = '2.0';
			vars['method'] = 'getAppFriends';
			vars['format'] = 'json';
			vars['test_mode'] = '1';
			vars['sig'] = MD5.encrypt(sig);
			
			request('getAppFriends', vars);
		}
		
		//77625236
		public function getAlbums():void {
			var vars: URLVariables = new URLVariables();
			var sig:String = Util.viewer_id+'api_id=1827403'+'format=json'+'method=photos.getAlbums'+'test_mode=1'+'uid='+Util.viewer_id+'v=2.0'+'EqKl8Wg2be';
			vars['api_id'] = '1827403';
			vars['v'] = '2.0';
			vars['uid'] = Util.viewer_id;//'77625236';
			vars['method'] = 'photos.getAlbums';
			vars['format'] = 'json';
			vars['test_mode'] = '1';
			vars['sig'] = MD5.encrypt(sig);
			
			request('photos.getAlbums', vars);
		}
		
		public function getPhotos(aid: String):void {
			var vars: URLVariables = new URLVariables();
			var sig:String = Util.viewer_id+'aid='+aid+'api_id=1827403'+'format=json'+'method=photos.get'+'test_mode=1'+'uid=77625236'+'v=2.0'+APP_KEY;
			vars['api_id'] = '1827403';
			vars['v'] = '2.0';
			vars['aid'] = aid;
			vars['uid'] = '77625236';
			vars['method'] = 'photos.get';
			vars['format'] = 'json';
			vars['test_mode'] = '1';
			vars['sig'] = MD5.encrypt(sig);
			
			request('photos.get', vars);
		}
		
		public function getAds():void {
			var vars: URLVariables = new URLVariables();
			var sig:String = Util.viewer_id+'api_id=1827403'+'format=json'+'method=getAds'+'test_mode=1'+'v=2.0'+APP_KEY;
			vars['api_id'] = '1827403';
			vars['method'] = 'getAds';
			vars['v'] = '2.0';
			vars['format'] = 'json';
			vars['test_mode'] = '1';
			vars['sig'] = MD5.encrypt(sig);
			
			request('getAds', vars);
		}
	}
}
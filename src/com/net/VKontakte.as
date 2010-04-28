package com.net
{
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
//		public static const STATE_NONE:uint = 0;
//		public static const STATE_GET_PROFILES:uint = 1;
//		public static const STATE_GET_APP_FRIENDS:uint = 2;
//		public static const STATE_GET_FRIENDS:uint = 3;
//		public static const STATE_GET_ALBUMS:uint = 4;
//		public static const STATE_GET_PHOTOS:uint = 5;
		
		private static const FC_API_SERVER:String = 'http://api.vkontakte.ru/api.php';
		private const loader:URLLoader = new URLLoader();
		private var requestQueue: Array;
		private var timer: Timer;
		private var currentMethod: String;
		
//		public var state:uint = STATE_NONE;
		
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
//			trace(loader.data);
			try {
				var response:Object = JSON.deserialize(loader.data);
				
				if (response.hasOwnProperty('error')) {
					response = response.error;
					var errorCode:int = response.error_code;
					dispatchEvent(new VKontakteEvent(VKontakteEvent.ERROR, currentMethod, null, errorCode, response.error_msg));
				}
				else if (response.hasOwnProperty('response')) {
//					var method:String;
//					switch (state) {
//						case STATE_GET_PROFILES:
//							method = 'getProfiles';
//						break;
//						case STATE_GET_APP_FRIENDS:
//							method = 'getAppFriends';
//						break;
//						case STATE_GET_FRIENDS:
//							method = 'getFriends';
//						break;
//						case STATE_GET_ALBUMS:
//							method = 'photos.getAlbums';
//						break;
//						case STATE_GET_PHOTOS:
//							method = 'photos.getPhotos';
//						break;
//					}
					response = response.response;
					dispatchEvent(new VKontakteEvent(VKontakteEvent.COMPLETED, currentMethod, response));
				}
			}
			catch (e:Error) {
				dispatchEvent(new VKontakteEvent(VKontakteEvent.ERROR, currentMethod, null, 254, e.message));
			}
			currentMethod = null;
		}
		
		public function getProfiles(uid:int):void {
//			if (state == STATE_NONE) {
//				state = STATE_GET_PROFILES;
				
				var vars: URLVariables = new URLVariables();
				var sig:String = '57856825'+'api_id=1827403'+
					'fields=uid,first_name,last_name,nickname,sex,bdate,city,photo,photo_medium,photo_big'+
					'format=json'+
					'method=getProfiles'+'test_mode=1'+'uids='+uid+'v=2.0'+'EqKl8Wg2be';
					
				vars['api_id'] = '1827403';
				vars['v'] = '2.0';
				vars['method'] = 'getProfiles';
				vars['uids'] = uid;
				vars['fields'] = 'uid,first_name,last_name,nickname,sex,bdate,city,photo,photo_medium,photo_big';
				vars['format'] = 'json';
				vars['test_mode'] = '1';
				vars['sig'] = MD5.encrypt(sig);
				
				request('getProfiles', vars);
//			}
		}
		
		public function isAppUser():void {
//			if (state == STATE_NONE) {
//				state = STATE_GET_PROFILES;
				
				var vars: URLVariables = new URLVariables();
				var sig:String = '57856825'+'api_id=1827403'+'format=json'+'method=isAppUser'+'test_mode=1'+'v=2.0'+'EqKl8Wg2be';
				vars['api_id'] = '1827403';
				vars['v'] = '2.0';
				vars['method'] = 'isAppUser';
				vars['format'] = 'json';
				vars['test_mode'] = '1';
				vars['sig'] = MD5.encrypt(sig);
				
				request('isAppUser', vars);
//			}
		}
		
		public function getFriends():void {
//			if (state == STATE_NONE) {
//				state = STATE_GET_FRIENDS;
				
				var vars: URLVariables = new URLVariables();
				var sig:String = '57856825'+'api_id=1827403'+'format=json'+'method=getFriends'+'test_mode=1'+'v=2.0'+'EqKl8Wg2be';
				vars['api_id'] = '1827403';
				vars['v'] = '2.0';
				vars['method'] = 'getFriends';
				vars['format'] = 'json';
				vars['test_mode'] = '1';
				vars['sig'] = MD5.encrypt(sig);
				
				request('getFriends', vars);
//			}
		}
		
		public function getAppFriends():void {
//			if (state == STATE_NONE) {
//				state = STATE_GET_APP_FRIENDS;
				
				var vars: URLVariables = new URLVariables();
				var sig:String = '57856825'+'api_id=1827403'+'format=json'+'method=getAppFriends'+'test_mode=1'+'v=2.0'+'EqKl8Wg2be';
				vars['api_id'] = '1827403';
				vars['v'] = '2.0';
				vars['method'] = 'getAppFriends';
				vars['format'] = 'json';
				vars['test_mode'] = '1';
				vars['sig'] = MD5.encrypt(sig);
				
				request('getAppFriends', vars);
//			}
		}
		//77625236
		public function getAlbums():void {
			var vars: URLVariables = new URLVariables();
			var sig:String = '57856825'+'api_id=1827403'+'format=json'+'method=photos.getAlbums'+'test_mode=1'+'uid=77625236'+'v=2.0'+'EqKl8Wg2be';
			vars['api_id'] = '1827403';
			vars['v'] = '2.0';
			vars['uid'] = '77625236';
			vars['method'] = 'photos.getAlbums';
			vars['format'] = 'json';
			vars['test_mode'] = '1';
			vars['sig'] = MD5.encrypt(sig);
			
			request('photos.getAlbums', vars);
		}
		
		public function getPhotos(aid: String):void {
			var vars: URLVariables = new URLVariables();
			var sig:String = '57856825'+'aid='+aid+'api_id=1827403'+'format=json'+'method=photos.get'+'test_mode=1'+'uid=77625236'+'v=2.0'+'EqKl8Wg2be';
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
			var sig:String = '57856825'+'api_id=1827403'+'format=json'+'method=getAds'+'test_mode=1'+'v=2.0'+'EqKl8Wg2be';
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
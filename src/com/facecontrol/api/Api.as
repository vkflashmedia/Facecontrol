package com.facecontrol.api
{
	import com.serialization.json.JSON;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	
	public class Api extends EventDispatcher
	{
		private static const FC_API_SERVER:String = 'http://facecontrol/';
		private const loader:URLLoader = new URLLoader();
		
		public function Api()
		{
			loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			loader.addEventListener(Event.COMPLETE, completeHandler);
		}
		
		private function request(vars:URLVariables):void
		{
			var request: URLRequest = new URLRequest();
			request.url = FC_API_SERVER;
			request.data = vars;
			loader.load(request);
		}
		
		private function errorHandler(e:IOErrorEvent):void {
			dispatchEvent(new ApiEvent(ApiEvent.ERROR, e.text, 255));
		}
		
		private function completeHandler(event:Event):void
		{
			trace("completeHandler: "+loader.data);
			try {
				var json:Object = JSON.deserialize(loader.data);
				
				if (json.hasOwnProperty('error')) {
					var errorCode:int = json.err_code;
					var errorMessage:String = null;
					
					if (json.hasOwnProperty('err_msg')) {
						errorMessage = json.err_msg;
					}
					dispatchEvent(new ApiEvent(ApiEvent.ERROR, errorMessage, errorCode));
				}
				else if (json.hasOwnProperty('response')) {
					dispatchEvent(new ApiEvent(ApiEvent.COMPLETED, json.response));
				}
			}
			catch (e:Error) {
				dispatchEvent(new ApiEvent(ApiEvent.ERROR, null, 254, e.message));
			}
		}
		
		public function registerUser(uid:int, fname:String, lname:String, nickname:String, sex:int, bdate:String, city:int, country:int):void
		{
			var vars: URLVariables = new URLVariables();
			vars['method'] = 'reg_user';
			vars['uid'] = uid;
			vars['fname'] = fname;
			vars['lname'] = lname;
			
			if (nickname != null) vars['nickname'] = nickname;
			vars['sex'] = sex;
			
			if (bdate != null) vars['bdate'] = bdate;
			vars['city'] = city;
			vars['country'] = country;
			
			request(vars);
		}
		
		public function saveSettings(uid:int, sex:int=0, minAge:int=8, maxAge:int=99, city:String=null):void
		{
			var vars: URLVariables = new URLVariables();
			vars['method'] = 'save_settings';
			vars['uid'] = uid;
			vars['sex'] = sex;
			vars['age_min'] = minAge;
			vars['max_age'] = maxAge;
			
			if (city != null) vars['city'] = city;
			
			request(vars);
		}
		
		public function loadSettings(uid:int):void
		{
			var vars: URLVariables = new URLVariables();
			vars['method'] = 'load_settings';
			vars['uid'] = uid;
			
			request(vars);
		}
		
		public function addPhoto(uid:int, src:String, src_small:String, src_big:String, comment:String=null):void
		{
			var vars: URLVariables = new URLVariables();
			vars['method'] = 'add_photo';
			vars['uid'] = uid;
			vars['src'] = src;
			vars['src_small'] = src_small;
			vars['src_big'] = src_big;
			if (comment != null) vars['comment'] = comment;
			
			request(vars);
		}
		
		public function getPhotos(uid:int):void
		{
			var vars: URLVariables = new URLVariables();
			vars['method'] = 'get_photos';
			vars['uid'] = uid;
			
			request(vars);
		}
		
		public function deletePhoto(pid:int):void
		{
			var vars: URLVariables = new URLVariables();
			vars['method'] = 'del_photo';
			vars['pid'] = pid;
			
			request(vars);
		}
		
		public function setComment(pid:int, comment:String):void
		{
			var vars: URLVariables = new URLVariables();
			vars['method'] = 'set_comment';
			vars['pid'] = pid;
			vars['comment'] = comment;
			
			request(vars);
		}
		
		public function vote(uid:int, pid:String, rating:int=1):void
		{
			var vars: URLVariables = new URLVariables();
			vars['method'] = 'vote';
			vars['uid'] = uid;
			vars['pid'] = pid;
			vars['rating'] = rating;
			
			request(vars);
		}
		
		public function setMain(pid:String):void
		{
			var vars: URLVariables = new URLVariables();
			vars['method'] = 'set_main';
			vars['pid'] = pid;
			
			request(vars);
		}
		
		public function nextPhoto(uid:int):void
		{
			var vars: URLVariables = new URLVariables();
			vars['method'] = 'next_photo';
			vars['uid'] = uid;
			
			request(vars);
		}
		
		public function friends(uids:Array):void {
			var vars: URLVariables = new URLVariables();
			vars['method'] = 'friends';
			var uidsString:String = '';
			var uid:String;
			for each (uid in uids) {
				uidsString += uid + ',';
			}
			vars['uids'] = uidsString;
			
			request(vars);
		}
		
		public function top100():void
		{
			var vars: URLVariables = new URLVariables();
			vars['method'] = 'top100';
			
			request(vars);
		}
		
		public function bottom100():void
		{
			var vars: URLVariables = new URLVariables();
			vars['method'] = 'top100';
			
			request(vars);
		}
	}
}
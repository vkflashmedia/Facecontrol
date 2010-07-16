package com.facecontrol.api
{
	import com.facecontrol.util.Util;
	import com.serialization.json.JSON;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.utils.Timer;
	
	public class Api extends EventDispatcher
	{
		private static const FC_API_SERVER:String = 'http://www.fcapi.ru/';
		
		private const loader:URLLoader = new URLLoader();
		private var requestQueue: Array;
		private var timer: Timer;
		private var currentMethod: String;
		
		public function Api()
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
				requestQueue.push({'method': method, 'vars': vars});	
			}
		}

		private function errorHandler(e:IOErrorEvent):void {
			if (Util.DEBUG) trace('errorHandler: ' + e.text);
			dispatchEvent(new ApiEvent(ApiEvent.ERROR, e.text, 255));
			currentMethod = null;
		}
		
		private function completeHandler(event:Event):void
		{
			if (Util.DEBUG) trace('Api: '+currentMethod+': '+loader.data);
			try {
				var json:Object = JSON.deserialize(loader.data);
				
				if (json.hasOwnProperty('error')) {
					json = json.error;
					var errorCode:int = json.err_code;
					var errorMessage:String = null;
					
					if (json.hasOwnProperty('err_msg')) {
						errorMessage = json.err_msg;
					}
					dispatchEvent(new ApiEvent(ApiEvent.ERROR, null, errorCode, errorMessage));
				}
				else if (json.hasOwnProperty('response')) {
					dispatchEvent(new ApiEvent(ApiEvent.COMPLETED, json.response));
				}
			}
			catch (e:Error) {
				dispatchEvent(new ApiEvent(ApiEvent.ERROR, null, 254, e.message));
			}
			currentMethod = null;
		}
		
		public function login(user:Object):void
		{
			var vars: URLVariables = new URLVariables();
			vars['method'] = 'login';
			vars['viewer_id'] = Util.viewer_id;
			vars['user_id'] = Util.user_id;
			vars['fname'] = user.first_name;
			vars['lname'] = user.last_name;
			if (user.nickname) vars['nickname'] = user.nickname;
			vars['sex'] = user.sex;
			if (user.bdate) vars['bdate'] = user.bdate;
			vars['city'] = user.city;
			vars['country'] = user.country;
			
			request(vars['method'], vars);
		}
		
		public function saveSettings(uid:int, sex:int=0, minAge:int=8, maxAge:int=99, city:String=null, country:String=null):void
		{
			var vars: URLVariables = new URLVariables();
			vars['method'] = 'save_settings';
			vars['uid'] = uid;
			vars['sex'] = sex;
			vars['age_min'] = minAge;
			vars['age_max'] = maxAge;
			if (city) vars['city'] = city;
			if (country) vars['country'] = country;
			
			request(vars['method'], vars);
		}
		
		public function loadSettings(uid:int):void
		{
			var vars: URLVariables = new URLVariables();
			vars['method'] = 'load_settings';
			vars['uid'] = uid;
			
			request(vars['method'], vars);
		}
		
		public function addPhoto(uid:int, src:String, src_small:String, src_big:String, comment:String=null, vkPid:String=null):void
		{
			var vars: URLVariables = new URLVariables();
			vars['method'] = 'add_photo';
			vars['uid'] = uid;
			if (src) vars['src'] = src;
			if (src_small) vars['src_small'] = src_small;
			if (src_big) vars['src_big'] = src_big;
			if (comment) vars['comment'] = comment;
			if (vkPid) vars['vk_pid'] = vkPid;
			
			request(vars['method'], vars);
		}
		
		public function getPhotos(uid:int, add_compensation:Boolean=false):void
		{
			var vars: URLVariables = new URLVariables();
			vars['method'] = 'get_photos';
			vars['uid'] = uid;
			if (add_compensation) vars['add_compensation'] = add_compensation;
			
			request(vars['method'], vars);
		}
		
		public function deletePhoto(pid:int):void
		{
			var vars: URLVariables = new URLVariables();
			vars['method'] = 'del_photo';
			vars['pid'] = pid;
			
			request(vars['method'], vars);
		}
		
		public function setComment(pid:int, comment:String):void {
			var vars: URLVariables = new URLVariables();
			vars['method'] = 'set_comment';
			vars['pid'] = pid;
			vars['comment'] = comment;
			
			request(vars['method'], vars);
		}
		
		public function vote(pid:String, rating:int=1):void
		{
			var vars: URLVariables = new URLVariables();
			vars['method'] = 'vote';
			vars['viewer_id'] = Util.viewer_id;
			vars['pid'] = pid;
			vars['rating'] = rating;
			
			request(vars['method'], vars);
		}
		
		public function setMain(pid:String):void
		{
			var vars: URLVariables = new URLVariables();
			vars['method'] = 'set_main';
			vars['pid'] = pid;
			
			request(vars['method'], vars);
		}
		
		public function nextPhoto(uid:int):void
		{
			var vars: URLVariables = new URLVariables();
			vars['method'] = 'next_photo';
			vars['uid'] = uid;
			
			request(vars['method'], vars);
		}
		
		public function friends(uids:Array):void {
			var vars: URLVariables = new URLVariables();
			vars['method'] = 'friends';
			var uidsString:String = '';
			var uid:String;
			for each (uid in uids) {
				uidsString += uid + ',';
			}
			vars['viewer_id'] = Util.viewer_id;
			vars['uids'] = uidsString;
			
			request(vars['method'], vars);
		}
		
		public function favorites(uid:int):void {
			var vars: URLVariables = new URLVariables();
			vars['method'] = 'favorites';
			vars['uid'] = uid;
			
			request(vars['method'], vars);
		}
		
		public function addFavorite(uid:int, favoriteUid:int):void {
			var vars: URLVariables = new URLVariables();
			vars['method'] = 'add_favorite';
			vars['uid'] = uid;
			vars['favorite_uid'] = favoriteUid;
			
			request(vars['method'], vars);
		}
		
		public function deleteFavorite(uid:int, favoriteUid:int):void {
			var vars: URLVariables = new URLVariables();
			vars['method'] = 'del_favorite';
			vars['uid'] = uid;
			vars['favorite_uid'] = favoriteUid;
			
			request(vars['method'], vars);
		}
		
		public function getTop(uid:uint):void {
			var vars: URLVariables = new URLVariables();
			vars['method'] = 'top100';
			vars['uid'] = uid;
			request(vars['method'], vars);
		}
		
		public function mainPhoto(uid:uint):void {
			var vars: URLVariables = new URLVariables();
			vars['method'] = 'main_photo';
			vars['viewer_id'] = Util.viewer_id;
			vars['uid'] = uid;
			request(vars['method'], vars);
		}
		
//		public function invite():void {
//			var vars: URLVariables = new URLVariables();
//			vars['method'] = 'invite';
//			vars['viewer_id'] = Util.viewer_id;
//			vars['user_id'] = Util.user_id;
//			request(vars['method'], vars);
//		}
		
//		public function writeIn(debt:int):void {
//			var vars: URLVariables = new URLVariables();
//			vars['method'] = 'write_in';
//			vars['viewer_id'] = Util.viewer_id;
//			vars['debt'] = debt;
//			request(vars['method'], vars);
//		}
		
		public function writeOff(debt:int):void {
			var vars: URLVariables = new URLVariables();
			vars['method'] = 'write_off';
			vars['viewer_id'] = Util.viewer_id;
			vars['debt'] = debt;
			request(vars['method'], vars);
		}
		
		public function withdrawVotes(votes:int):void {
			var vars: URLVariables = new URLVariables();
			vars['method'] = 'withdraw_votes';
			vars['viewer_id'] = Util.viewer_id;
			vars['auth_key'] = Util.auth_key;
			vars['votes'] = votes;
			request(vars['method'], vars);
		}
		
		public function setFrame(frame:int):void {
			var vars: URLVariables = new URLVariables();
			vars['method'] = 'set_frame';
			vars['viewer_id'] = Util.viewer_id;
			vars['frame'] = frame;
			request(vars['method'], vars);
		}
		
		public function wallPost():void {
			var vars: URLVariables = new URLVariables();
			vars['method'] = 'wall_post';
			vars['viewer_id'] = Util.viewer_id;
			vars['wall_id'] = Util.wall_id;
			request(vars['method'], vars);
		}
	}
}
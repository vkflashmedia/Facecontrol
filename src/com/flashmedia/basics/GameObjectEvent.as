package com.flashmedia.basics
{
	import flash.events.Event;

	public class GameObjectEvent extends Event
	{
		public static const TYPE_KEY_DOWN: String = 'type_key_down';
		public static const TYPE_KEY_UP: String = 'type_key_up';
		public static const TYPE_MOUSE_HOVER: String = 'type_mouse_hover';
		public static const TYPE_MOUSE_CLICK: String = 'type_mouse_click';
		public static const TYPE_MOUSE_MOVE: String = 'type_mouse_move';
		public static const TYPE_ANIMATION_COMPLETED: String = 'type_animation_completed';
		
		public var gameObject: GameObject;
		public var keyCode: uint;
		
		public function GameObjectEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
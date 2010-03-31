package com.facecontrol.gui
{
	import flash.events.Event;

	public class MainMenuEvent extends Event
	{
		public static const FIRST_BUTTON_CLICK:String = 'first_button_click';
		public static const SECOND_BUTTON_CLICK:String = 'second_button_click';
		public static const THIRD_BUTTON_CLICK:String = 'third_button_click';
		public static const FOURTH_BUTTON_CLICK:String = 'fourth_button_click';
		public static const FIFTH_BUTTON_CLICK:String = 'fifth_button_click';
		
		public function MainMenuEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}
package com.facecontrol.dialog
{
	import flash.events.Event;

	public class MessageDialogEvent extends Event
	{
		public static const CANCEL_BUTTON_CLICKED:String = 'CANCEL_BUTTON_CLICKED';
		public static const SECOND_BUTTON_CLICKED:String = 'SECOND_BUTTON_CLICKED';
		
		public function MessageDialogEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}
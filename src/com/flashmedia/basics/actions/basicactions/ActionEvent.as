package com.flashmedia.basics.actions.basicactions
{
	import flash.events.Event;

	public class ActionEvent extends Event
	{
		public function ActionEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}
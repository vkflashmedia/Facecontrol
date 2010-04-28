package com.facecontrol.gui
{
	import com.flashmedia.basics.GameObjectEvent;

	public class VKPhotoAlbumEvent extends GameObjectEvent
	{
		public static const LOADED:String = 'album_loaded';
		
		public function VKPhotoAlbumEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}
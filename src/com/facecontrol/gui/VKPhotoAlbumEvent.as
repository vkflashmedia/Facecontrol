package com.facecontrol.gui
{
	import com.flashmedia.basics.GameObjectEvent;

	public class VKPhotoAlbumEvent extends GameObjectEvent
	{
		public static const ALBUMS_LOADED:String = 'albums_loaded';
		public static const PHOTOS_LOADED:String = 'photos_loaded';
		
		public function VKPhotoAlbumEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}
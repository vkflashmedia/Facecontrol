package com.flashmedia.util
{
	import flash.display.Bitmap;
	
	public class BitmapUtil
	{
		public static const ZOOM_PERMIT: String = 'scale_policy_no_stretch';
		public static const ZOON_DENY: String = 'scale_policy_stretch';
		public static const PROPORTION_SAVE: String = 'scale_policy_no_stretch';
		public static const PROPORTION_DONT_SAVE: String = 'scale_policy_no_stretch';
		
		
		public function BitmapUtil()
		{
		}

		public static function scaleImage(bitmap: Bitmap, width: uint, height: uint, ... attrs): void {
			var result: Bitmap = new Bitmap();
			bitmap.
		}
	}
}
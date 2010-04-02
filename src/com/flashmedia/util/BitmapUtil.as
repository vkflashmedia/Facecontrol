package com.flashmedia.util
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
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
//			bitmap.
		}
		
		public static function createImage(top:Bitmap, mid:Bitmap, bottom:Bitmap, height:uint):Bitmap {
			var data:BitmapData = new BitmapData(top.width, height);
			var rect:Rectangle = new Rectangle(0, 0, top.width, top.height);
			var point:Point = new Point(0, 0);
			data.copyPixels(top.bitmapData, rect, point);
			
			rect = new Rectangle(0, 0, mid.width, mid.height);
			var i:int;
			var count:int = height - bottom.height;
			for (i = top.height; i < count; ++i) {
				point = new Point(0, i);
				data.copyPixels(mid.bitmapData, rect, point);
			}
			
			rect = new Rectangle(0, 0, bottom.width, bottom.height);
			point = new Point(0, height - bottom.height);
			data.copyPixels(bottom.bitmapData, rect, point);
			
			var result:Bitmap = new Bitmap(data);
			return result;
		}
	}
}
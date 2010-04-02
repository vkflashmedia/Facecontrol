package com.facecontrol.util
{
	import flash.display.Bitmap;
	
	public class Images
	{
		public static const HEAD_BUTTON1:String = 'headButton1';
		public static const HEAD_BUTTON2:String = 'headButton2';
		public static const HEAD_BUTTON3:String = 'headButton3';
		public static const HEAD_BUTTON4:String = 'headButton4';
		public static const HEAD_BUTTON5:String = 'headButton5';
		public static const BACKGROUND:String = 'background';
		public static const SUPER_ICON:String = 'superIcon';
		public static const JUNK_ICON:String = 'junkIcon';
		public static const BIG_MASK:String = 'bigMask';
		public static const SMALL_MASK:String = 'smallMask';
		public static const BIG_STAR:String = 'bigStar';
		public static const LINE:String = 'line';
		public static const FILTER_BACKGROUND:String = 'filterBackground';
		
		public static const IM:String = 'im';
		
		public static const HEAD_BUTTON1_PATH:String = 'images\\head\\01.png';
		public static const HEAD_BUTTON2_PATH:String = 'images\\head\\02.png';
		public static const HEAD_BUTTON3_PATH:String = 'images\\head\\03.png';
		public static const HEAD_BUTTON4_PATH:String = 'images\\head\\04.png';
		public static const HEAD_BUTTON5_PATH:String = 'images\\head\\05.png';
		public static const BACKGROUND_PATH:String = 'images\\bgr.jpg';
		public static const SUPER_ICON_PATH:String = 'images\\super.png';
		public static const JUNK_ICON_PATH:String = 'images\\otstoj.png';
		public static const BIG_MASK_PATH:String = 'images\\big_photo.png';
		public static const SMALL_MASK_PATH:String = 'images\\small_photo.png';
		public static const BIG_STAR_PATH:String = 'images\\big_star.png';
		public static const LINE_PATH:String = 'images\\line.png';
		public static const FILTER_BACKGROUND_PATH:String = 'images\\form02.png';
		
		public static const IM_PATH:String = 'images\\1.jpg';
		
		public var headButton1:Bitmap;
		public var headButton2:Bitmap;
		public var headButton3:Bitmap;
		public var headButton4:Bitmap;
		public var headButton5:Bitmap;
		public var background:Bitmap;
		public var superIcon:Bitmap;
		public var junkIcon:Bitmap;
		public var bigMask:Bitmap;
		public var smallMask:Bitmap;
		public var bigStar:Bitmap;
		public var line:Bitmap;
		public var filterBackground:Bitmap;
		
		public var im:Bitmap;
		
		public var names:Array;
		
		public function Images()
		{
			names = new Array(
				HEAD_BUTTON1,
				HEAD_BUTTON2,
				HEAD_BUTTON3,
				HEAD_BUTTON4,
				HEAD_BUTTON5,
				BACKGROUND,
				SUPER_ICON,
				JUNK_ICON,
				BIG_MASK,
				SMALL_MASK,
				BIG_STAR,
				LINE,
				FILTER_BACKGROUND,
				IM
			);
		}

	}
}
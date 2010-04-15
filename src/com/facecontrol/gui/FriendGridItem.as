package com.facecontrol.gui
{
	import com.facecontrol.util.Util;
	import com.flashmedia.basics.GameObject;
	import com.flashmedia.basics.GameScene;
	
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class FriendGridItem extends GameObject
	{
		public function FriendGridItem(value:GameScene, userRaw:Object, drawLine:Boolean)
		{
			super(value);
			
			this.width = 329;
			this.height = 99;
			
			var label:TextField = new TextField();
			label.x = 73;
			label.y = 40;
			label.width = 45;
			label.height = 30;
			label.text = userRaw.fname;
			label.setTextFormat(new TextFormat(Util.tahoma.fontName, 10, 0x9a9a9a));
			label.embedFonts = true;
			label.antiAliasType = AntiAliasType.ADVANCED;
			addChild(label);
		}
	}
}
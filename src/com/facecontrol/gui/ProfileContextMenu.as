package com.facecontrol.gui
{
	import com.facecontrol.forms.FavoritesForm;
	import com.facecontrol.forms.FriendsForm;
	import com.facecontrol.forms.PreloaderSplash;
	import com.facecontrol.util.Constants;
	import com.facecontrol.util.Util;
	import com.flashmedia.basics.GameLayer;
	import com.flashmedia.basics.GameObjectEvent;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.gui.Button;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.text.AntiAliasType;
	import flash.text.TextFormat;

	public class ProfileContextMenu extends GameLayer
	{
		public function ProfileContextMenu(value:GameScene)
		{
			super(value);
			
			graphics.beginFill(0xffffff, 0);
			graphics.drawRect(0, 50, Constants.APP_WIDTH, Constants.APP_HEIGHT - 50);
			graphics.endFill();
			
			var back:Sprite = new Sprite();
			back.graphics.beginFill(0xfaf8f9);
			back.graphics.drawRoundRect(148, 45, 122, 108, 10, 10);
			back.graphics.endFill();
			addChild(back);
			
			var sprite:Sprite = new Sprite();
			sprite.graphics.beginFill(0xfaf8f9);
			sprite.graphics.drawRoundRect(0, 0, 120, 29, 10, 10);
			sprite.graphics.endFill();
			var bitmapData:BitmapData = new BitmapData(120, 29, true, 0xffffff);
			bitmapData.draw(sprite);
			
			var highlightedSprite:Sprite = new Sprite();
			highlightedSprite.graphics.beginFill(0x666666);
			highlightedSprite.graphics.drawRoundRect(0, 0, 120, 29, 10, 10);
			highlightedSprite.graphics.endFill();
			var highlightedBitmapData:BitmapData = new BitmapData(120, 29, true, 0xffffff);
			highlightedBitmapData.draw(highlightedSprite);
			
			var profileButton:Button = new Button(_scene, 149, 65);
			profileButton.setBackgroundImageForState(new Bitmap(bitmapData), CONTROL_STATE_NORMAL);
			profileButton.setBackgroundImageForState(new Bitmap(highlightedBitmapData), CONTROL_STATE_HIGHLIGHTED);
			profileButton.setTitleForState('мои фото', CONTROL_STATE_NORMAL);
			profileButton.setTextFormatForState(new TextFormat(Util.university.fontName, 21), CONTROL_STATE_NORMAL);
			profileButton.setTextFormatForState(new TextFormat(Util.university.fontName, 21, 0xfaf8f9), CONTROL_STATE_HIGHLIGHTED);
			profileButton.textField.embedFonts = true;
			profileButton.textField.antiAliasType = AntiAliasType.ADVANCED;
			profileButton.setTextPosition(23, 1);
			profileButton.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, onProfileButtonClicked);
			addChild(profileButton);
			
			var friendsButton:Button = new Button(_scene, profileButton.x, profileButton.y + profileButton.height);
			friendsButton.setBackgroundImageForState(new Bitmap(bitmapData), CONTROL_STATE_NORMAL);
			friendsButton.setBackgroundImageForState(new Bitmap(highlightedBitmapData), CONTROL_STATE_HIGHLIGHTED);
			friendsButton.setTitleForState('друзья', CONTROL_STATE_NORMAL);
			friendsButton.setTextFormatForState(new TextFormat(Util.university.fontName, 21), CONTROL_STATE_NORMAL);
			friendsButton.setTextFormatForState(new TextFormat(Util.university.fontName, 21, 0xfaf8f9), CONTROL_STATE_HIGHLIGHTED);
			friendsButton.textField.embedFonts = true;
			friendsButton.textField.antiAliasType = AntiAliasType.ADVANCED;
			friendsButton.setTextPosition(23, 1);
			friendsButton.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, onFriendsButtonClicked);
			addChild(friendsButton);
			
			var favoritesButton:Button = new Button(_scene, profileButton.x, friendsButton.y + friendsButton.height);
			favoritesButton.setBackgroundImageForState(new Bitmap(bitmapData), CONTROL_STATE_NORMAL);
			favoritesButton.setBackgroundImageForState(new Bitmap(highlightedBitmapData), CONTROL_STATE_HIGHLIGHTED);
			favoritesButton.setTitleForState('избранные', CONTROL_STATE_NORMAL);
			favoritesButton.setTextFormatForState(new TextFormat(Util.university.fontName, 21), CONTROL_STATE_NORMAL);
			favoritesButton.setTextFormatForState(new TextFormat(Util.university.fontName, 21, 0xfaf8f9), CONTROL_STATE_HIGHLIGHTED);
			favoritesButton.textField.embedFonts = true;
			favoritesButton.textField.antiAliasType = AntiAliasType.ADVANCED;
			favoritesButton.setTextPosition(23, 1);
			favoritesButton.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, onFavoritesButtonClicked);
			addChild(favoritesButton);
		}
		
		public function onProfileButtonClicked(event:GameObjectEvent):void {
			PreloaderSplash.instance.showModal();
			Util.api.getPhotos(Util.viewer_id);
			visible = false;
		}
		
		public function onFriendsButtonClicked(event:GameObjectEvent):void {
			PreloaderSplash.instance.showModal();
			FriendsForm.instance.requestFriends();
			visible = false;
		}
		
		public function onFavoritesButtonClicked(event:GameObjectEvent):void {
			PreloaderSplash.instance.showModal();
			Util.api.favorites(Util.viewer_id);
			visible = false;
		}
		
	}
}
package com.facecontrol.forms
{
	import com.facecontrol.gui.VKPhotoAlbum;
	import com.facecontrol.gui.VKPhotoAlbumEvent;
	import com.flashmedia.basics.GameLayer;
	import com.flashmedia.basics.GameObjectEvent;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.gui.Label;
	
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	public class PhotoAlbumForm extends GameLayer
	{
		private var waitText: TextField;
		private var _vkPhotoAlbum: VKPhotoAlbum;
		private var _currentAlbumPage: int = 0;
		private var _currentPhotoPage: int = 0;
		
		public function PhotoAlbumForm(value:GameScene)
		{
			super(value);
			var backBtn: Label = new Label(scene, 'Назад');
			backBtn.setSelect(true);
			backBtn.fillBackground(0x0a0aff, 1.0);
			backBtn.x = 50,
			backBtn.y = 5,
			backBtn.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, function (event: GameObjectEvent): void {
				if (_vkPhotoAlbum.state == VKPhotoAlbum.STATE_IN_ALBUMS) {
					
				}
				else if (_vkPhotoAlbum.state == VKPhotoAlbum.STATE_IN_PHOTOS) {
					_currentPhotoPage = 0;
					_vkPhotoAlbum.showAlbums(_currentAlbumPage);
				}
			});
			addChild(backBtn);
			
			var chooseBtn: Label = new Label(scene, 'Выбрать');
			chooseBtn.setSelect(true);
			chooseBtn.fillBackground(0x0a0aff, 1.0);
			chooseBtn.x = 100,
			chooseBtn.y = 5,
			chooseBtn.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, function (event: GameObjectEvent): void {
				if (_vkPhotoAlbum.state == VKPhotoAlbum.STATE_IN_ALBUMS) {
					_currentPhotoPage = 0;
					_vkPhotoAlbum.showPhotos(_vkPhotoAlbum.selectedAlbumId);
				}
				else if (_vkPhotoAlbum.state == VKPhotoAlbum.STATE_IN_PHOTOS) {
					//todo полноразмерный предпросмотр
				}
			});
			addChild(chooseBtn);
			
			var prevBtn: Label = new Label(scene, '<');
			prevBtn.setSelect(true);
			prevBtn.fillBackground(0x0a0aff, 1.0);
			prevBtn.x = 400,
			prevBtn.y = 5,
			prevBtn.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, function (event: GameObjectEvent): void {
				if (_vkPhotoAlbum.state == VKPhotoAlbum.STATE_IN_ALBUMS) {
					if (_currentAlbumPage > 0) {
						_currentAlbumPage--;
						_vkPhotoAlbum.showAlbums(_currentAlbumPage);
					}
				}
				else if (_vkPhotoAlbum.state == VKPhotoAlbum.STATE_IN_PHOTOS) {
					if (_currentPhotoPage > 0) {
						_currentPhotoPage--;
						_vkPhotoAlbum.showPhotos(_vkPhotoAlbum.selectedAlbumId, _currentPhotoPage);
					}
				}
			});
			addChild(prevBtn);
			
			var nextBtn: Label = new Label(scene, '>');
			nextBtn.setSelect(true);
			nextBtn.fillBackground(0x0a0aff, 1.0);
			nextBtn.x = 420,
			nextBtn.y = 5,
			nextBtn.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, function (event: GameObjectEvent): void {
				if (_vkPhotoAlbum.state == VKPhotoAlbum.STATE_IN_ALBUMS) {
					if (_currentAlbumPage < (_vkPhotoAlbum.albumsPages - 1)) {
						_currentAlbumPage++;
						_vkPhotoAlbum.showAlbums(_currentAlbumPage);
					}
				}
				else if (_vkPhotoAlbum.state == VKPhotoAlbum.STATE_IN_PHOTOS) {
					if (_currentPhotoPage < (_vkPhotoAlbum.selectedAlbumPhotosPages - 1)) {
						_currentPhotoPage++;
						_vkPhotoAlbum.showPhotos(_vkPhotoAlbum.selectedAlbumId, _currentPhotoPage);
					}
				}
			});
			addChild(nextBtn);
			
			waitText = new TextField(); 
			waitText.autoSize = TextFieldAutoSize.LEFT;
			waitText.text = 'Идет загрузка фотографий...';
			waitText.x = 200;
			waitText.y = 200;
			addChild(waitText);
			
			_vkPhotoAlbum = new VKPhotoAlbum(scene, 4, 3);
			_vkPhotoAlbum.debug = true;
			_vkPhotoAlbum.x = 50;
			_vkPhotoAlbum.y = 50;
			_vkPhotoAlbum.addEventListener(VKPhotoAlbumEvent.LOADED, function onAlbumLoad(event: VKPhotoAlbumEvent): void {
				removeChild(waitText);
			});
			addChild(_vkPhotoAlbum);
		}
		
	}
}
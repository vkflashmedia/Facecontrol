package {
	import com.efnx.events.MultiLoaderEvent;
	import com.efnx.net.MultiLoader;
	import com.facecontrol.forms.MainForm;
	import com.facecontrol.util.Images;
	import com.facecontrol.util.Util;
	import com.flashmedia.basics.GameScene;
	
	import flash.system.System;
	import flash.text.Font;
	
	public class Facecontrol extends GameScene {
		private static var _images:Images;
		public function Facecontrol() {
			_images = new Images();
			
//			MultiLoader.testing = true;
			Util.multiLoader = new MultiLoader();
			Util.multiLoader.addEventListener(MultiLoaderEvent.PROGRESS, multiLoaderProgressListener);
			Util.multiLoader.addEventListener(MultiLoaderEvent.COMPLETE, multiLoaderCompleteListener);
			
			load();
//			testComponents();
		}
		
		private function load():void {
			Util.multiLoader.load(Images.HEAD_BUTTON1_PATH, Images.HEAD_BUTTON1, 'Bitmap');
			Util.multiLoader.load(Images.HEAD_BUTTON2_PATH, Images.HEAD_BUTTON2, 'Bitmap');
			Util.multiLoader.load(Images.HEAD_BUTTON3_PATH, Images.HEAD_BUTTON3, 'Bitmap');
			Util.multiLoader.load(Images.HEAD_BUTTON4_PATH, Images.HEAD_BUTTON4, 'Bitmap');
			Util.multiLoader.load(Images.HEAD_BUTTON5_PATH, Images.HEAD_BUTTON5, 'Bitmap');
			
			Util.multiLoader.load(Images.BACKGROUND_PATH, Images.BACKGROUND, 'Bitmap');
			
			Util.multiLoader.load(Images.SUPER_ICON_PATH, Images.SUPER_ICON, 'Bitmap');
			Util.multiLoader.load(Images.JUNK_ICON_PATH, Images.JUNK_ICON, 'Bitmap');

			Util.multiLoader.load(Images.BIG_MASK_PATH, Images.BIG_MASK, 'Bitmap');
			Util.multiLoader.load(Images.SMALL_MASK_PATH, Images.SMALL_MASK, 'Bitmap');
			Util.multiLoader.load(Images.BIG_STAR_PATH, Images.BIG_STAR, 'Bitmap');
			Util.multiLoader.load(Images.LINE_PATH, Images.LINE, 'Bitmap');
			Util.multiLoader.load(Images.FILTER_BACKGROUND_PATH, Images.FILTER_BACKGROUND, 'Bitmap');
					
			Util.multiLoader.load(Images.IM_PATH, Images.IM, 'Bitmap');
		}
		
		private function multiLoaderProgressListener(event:MultiLoaderEvent):void {
			
		}
		
		private function multiLoaderCompleteListener(event:MultiLoaderEvent):void {
			if (event.entry != "") {
				_images[event.entry] = Util.multiLoader.get(event.entry);
			}
			
			if (isLoadCompleted()) {
				var main:MainForm = new MainForm(this);
				addChild(main);
			}
		}
		
		private function isLoadCompleted():Boolean {
			var result:Boolean = true;
			var count:int = _images.names.length;
			
			for (var i:uint = 0; i < count; ++i) {
				if (!Util.multiLoader.hasLoaded(_images.names[i])) {
					result = false;
					break;
				}
			}
			
			return result;
		}
		
		/*
		private function onLoad(event: MultiLoaderEvent): void {
			switch (event.entry) {
				case 'Button1':
					menu.buttonAtIndex(0).setBackgroundImageForState(_multiLoader.get("Button1"), Button.STATE_NORMAL);
				break;
				case 'Button2':
					menu.buttonAtIndex(1).setBackgroundImageForState(_multiLoader.get("Button2"), Button.STATE_NORMAL);
				break;
				case 'Button3':
					menu.buttonAtIndex(2).setBackgroundImageForState(_multiLoader.get("Button3"), Button.STATE_NORMAL);
				break;
				case 'Button4':
					menu.buttonAtIndex(3).setBackgroundImageForState(_multiLoader.get("Button4"), Button.STATE_NORMAL);
				break;
				case 'Button5':
					menu.buttonAtIndex(4).setBackgroundImageForState(_multiLoader.get("Button5"), Button.STATE_NORMAL);
				break;
				case 'scroll_up':
				case 'scroll_body':
				case 'scroll_down':
					if (_multiLoader.hasLoaded('scroll_up') &&
						_multiLoader.hasLoaded('scroll_body') &&
						_multiLoader.hasLoaded('scroll_down')) {
						var image:Bitmap = BitmapUtil.createImage(
							_multiLoader.get('scroll_up'),
							_multiLoader.get('scroll_body'),
							_multiLoader.get('scroll_down'),
							100);
						addChild(image);
					}
				break;
			}
		}
		
		private function aliFunction():void {
			_multiLoader.addEventListener(MultiLoaderEvent.COMPLETE, onLoad);
			/*
			var format:TextFormat = new TextFormat();
			format.font = MenuFont.fontName;
			format.size = 18;
			
//			b = new Button(this, 0, 50);
//			b.setTitleForState("Main меню", Button.STATE_NORMAL);
//			b.setTextFormatForState(format, Button.STATE_NORMAL);
//			b.textField.embedFonts = true;
//			b.setTextPosition(100, 50);
//			b.setBackgroundImageForState(_multiLoader.get("Button"), Button.STATE_NORMAL);
//			addChild(b);
//			b.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, onButtonClicked);

			var b1:Button = new Button(this, 0, 0);
			b1.setTitleForState("main", Button.STATE_NORMAL);
			b1.setTextFormatForState(format, Button.STATE_NORMAL);
			b1.textField.embedFonts = true;
			b1.setTextPosition(50, 10);
			
			var b2:Button = new Button(this, 149, 0);
			b2.setTitleForState("my photos", Button.STATE_NORMAL);
			b2.setTextFormatForState(format, Button.STATE_NORMAL);
			b2.textField.embedFonts = true;
			b2.setTextPosition(35, 10);
			
			var b3:Button = new Button(this, 257, 0);
			b3.setTitleForState("top100", Button.STATE_NORMAL);
			b3.setTextFormatForState(format, Button.STATE_NORMAL);
			b3.textField.embedFonts = true;
			b3.setTextPosition(30, 10);
			
			var b4:Button = new Button(this, 364, 0);
			b4.setTitleForState("bottom100", Button.STATE_NORMAL);
			b4.setTextFormatForState(format, Button.STATE_NORMAL);
			b4.textField.embedFonts = true;
			b4.setTextPosition(30, 10);
			
			var b5:Button = new Button(this, 483, 0);
			b5.setTitleForState("friends", Button.STATE_NORMAL);
			b5.setTextFormatForState(format, Button.STATE_NORMAL);
			b5.textField.embedFonts = true;
			b5.setTextPosition(30, 10);
			
			var buttons:Array = new Array(b1, b2, b3, b4, b5);
			menu = new MainMenu(this);
			menu.buttons = buttons;
			addChild(menu);
			
			_multiLoader.load("images\\head\\01.png", "Button1", "Bitmap");
			_multiLoader.load("images\\head\\02.png", "Button2", "Bitmap");
			_multiLoader.load("images\\head\\03.png", "Button3", "Bitmap");
			_multiLoader.load("images\\head\\04.png", "Button4", "Bitmap");
			_multiLoader.load("images\\head\\05.png", "Button5", "Bitmap");
			
			_multiLoader.load("images\\scroll_up.png", "scroll_up", "Bitmap");
			_multiLoader.load("images\\scroll_body.png", "scroll_body", "Bitmap");
			_multiLoader.load("images\\scroll_down.png", "scroll_down", "Bitmap");
		}
		
		private function testComponents(): void {
			//multiLoader.load("http://cs1256.vkontakte.ru/u7776141/17008570/x_b07e69c3.jpg", "Photo1", "Bitmap");
			_multiLoader.load("c:\\choose_button.png", "dropIcon", "Bitmap");
			_multiLoader.addEventListener(MultiLoaderEvent.PROGRESS, function (event: MultiLoaderEvent): void {
			
			});
			_multiLoader.addEventListener(MultiLoaderEvent.COMPLETE, function (event: MultiLoaderEvent): void {
				cb.dropIcon = _multiLoader.get("dropIcon");
			});
			
			cb = new ComboBox(this);
			cb.x = 400;
			cb.y = 400;
			cb.height = 15;
			cb.addItem('Item1');
			cb.addItem('Item2');
			cb.addItem('Item3');
			cb.addItem('Item4');
			cb.addItem('Item5');
			addChild(cb);
			
			var label: Label = new Label(this, 'TestLabel');
			label.x = 300;
			label.y = 200;
			//label.debug = true;
			label.fillBackground(0xffffff, 1.0);
			label.selectable = true;
			label.canHover = true;
			label.canFocus = true;
			addChild(label);
			
			var gb: GridBox = new GridBox(this, 4);
			gb.addEventListener(GridBoxEvent.TYPE_ITEM_SELECTED, function (event: GridBoxEvent) : void {
				trace((event.item as String) + ' ' + event.columnIndex + ' ' + event.rowIndex);
			});
			gb.x = 50;
			gb.y = 10;
			gb.width = 400;
			gb.height = 300;
			gb.widthPolicy = GridBox.WIDTH_POLICY_STRETCH_BY_WIDTH;
			gb.heightPolicy = GridBox.HEIGHT_POLICY_STRETCH_BY_HEIGHT;
//			gb.columnWidthPolicy = GridBox.COLUMN_WIDTH_POLICY_ALL_SAME;
//			gb.rowHeightPolicy = GridBox.ROW_HEIGHT_POLICY_ALL_SAME;
			gb.horizontalItemsAlign = GameObject.HORIZONTAL_ALIGN_LEFT;
			gb.verticalItemsAlign = GameObject.VERTICAL_ALIGN_CENTER;
			gb.fillBackground(0xffffff, 1.0);
			gb.indentBetweenItems = 0;
			gb.padding = 0;
			gb.addItem('VeryVeryVeryLongItem\nNew line text');
			for (var i: uint = 0; i < 20; i++) {
				var str: String = 'Item' + i.toString();
				if (i == 2) {
					str = 'Long long Item 10';
				}
				if (i == 7) {
					str = 'Line1\nLine2\nLine3';
				}
				gb.addItem(str);
			}
			addChild(gb);
		}
		
		private function onButtonClicked(e: GameObjectEvent): void {
			var cancelButton:Button = new Button(this);
			cancelButton.x = 40;
			cancelButton.y = 50;
			cancelButton.width = 50;
			cancelButton.setTitleForState("Ok", Button.STATE_NORMAL);
			
			var otherButton:Button = new Button(this);
			otherButton.x = 110;
			otherButton.y = 50;
			otherButton.width = 50;
			otherButton.setTitleForState("Other", Button.STATE_NORMAL);
			var msg: MessageBox = new MessageBox(this, "Message", cancelButton, otherButton);
			msg.show();
		}
		
		private function changeListener(e:Event):void {
			p.clear();
			p.update();
		}
		/*
		private function request():void {
			this.addChild(textField);
			var api:Api = new Api(textField);
			api.addEventListener(ApiEvent.ERROR, onError);
			api.addEventListener(ApiEvent.COMPLETED, onCompleted);
			
			api.registerUser(1, "test1", "test3", null, 0, null, 1);
		}
		
		public function onError(e:ApiEvent):void {
			textField.text = "error";
		}
		
		public function onCompleted(e:ApiEvent):void {
			var response:Object = e.response;
			try {
				textField.text = response["method"];
			}
			catch (e:Error) {
				textField.text = e.message;
			}
		}
		*/
	}
}

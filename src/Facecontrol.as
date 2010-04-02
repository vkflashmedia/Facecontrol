package {
	import com.efnx.events.MultiLoaderEvent;
	import com.efnx.net.MultiLoader;
	import com.flashmedia.basics.GameObject;
	import com.flashmedia.basics.GameObjectEvent;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.gui.Button;
	import com.flashmedia.gui.ComboBox;
	import com.flashmedia.gui.GridBox;
	import com.flashmedia.gui.GridBoxEvent;
	import com.flashmedia.gui.Label;
	import com.flashmedia.gui.LinkButton;
	import com.flashmedia.gui.MessageBox;
	import com.flashmedia.gui.RatingBar;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.text.TextField;

	public class Facecontrol extends GameScene {
		private var textField: TextField = new TextField();
//		private var p:Pagination;
		private var linkButton:LinkButton;
		private var gb: GridBox;
		private var cb: ComboBox;
		private var rateBar: RatingBar;
		private static var _multiLoader: MultiLoader;
		
		public function Facecontrol() {
			_multiLoader = new MultiLoader();
			testComponents();
			/*
			linkButton = new LinkButton(this, "My link button", 0, 0, 50);
			addChild(linkButton);
			linkButton.wordWrap = true;
			linkButton.label = "This is my first label";
//			p = new Pagination(this, 100, 0, 10, 1);
//			addChild(p);
//			p.addEventListener(Event.CHANGE, changeListener);
			
			var myBitmapDataObject:BitmapData = new BitmapData(50, 20, false, 0x80FF3300); 
			var bitmap:Bitmap = new Bitmap(myBitmapDataObject); 
			
			var b:Button = new Button(this, 50, 20);
			b.setTitleForState("Button", Button.STATE_NORMAL);
			addChild(b);
			b.setBackgroundImageForState(bitmap, Button.STATE_NORMAL);
			b.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, onButtonClicked);
			*/
		}
		
		private function testComponents(): void {
			//multiLoader.load("http://cs1256.vkontakte.ru/u7776141/17008570/x_b07e69c3.jpg", "Photo1", "Bitmap");
			_multiLoader.load("c:\\img\\choose_button.png", "dropIcon", "Bitmap");
			_multiLoader.load("c:\\img\\rating_bgr.png", "ratingBack", "Bitmap");
			_multiLoader.load("c:\\img\\rating_star_active.png", "ratingIconOn", "Bitmap");
			_multiLoader.load("c:\\img\\rating_star_off.png", "ratingIconOff", "Bitmap");
			_multiLoader.addEventListener(MultiLoaderEvent.PROGRESS, function (event: MultiLoaderEvent): void {
			
			});
			_multiLoader.addEventListener(MultiLoaderEvent.COMPLETE, function (event: MultiLoaderEvent): void {
				switch (event.entry) {
					case 'dropIcon':
						cb.dropIcon = _multiLoader.get("dropIcon");
						gb.addItem(_multiLoader.get("dropIcon"));
						gb.addItem(cb);
					break;
					case 'ratingBack':
						rateBar.bitmap = _multiLoader.get("ratingBack");
						gb.addItem(rateBar);
					break;
					case 'ratingIconOff':
						rateBar.rateIconOff = _multiLoader.get("ratingIconOff");
						gb.addItem(_multiLoader.get("ratingIconOff"));
					break;
					case 'ratingIconOn':
						rateBar.rateIconOn = _multiLoader.get("ratingIconOn");
					break;
				}
			});
			
			rateBar = new RatingBar(this, 10);
			rateBar.x = 550;
			rateBar.y = 300;
			rateBar.setLayout(5, 13, 26, 21);
			addChild(rateBar);

			var spr: Sprite = new Sprite();
			spr.graphics.beginFill(0xffffff);
			spr.graphics.drawRoundRect(0, 0, 100, 15, 12);
			spr.graphics.endFill();
			var bd: BitmapData = new BitmapData(100, 15, true, undefined);
			bd.draw(spr);
			var cbBack: Bitmap = new Bitmap(bd);
			cb = new ComboBox(this);
			cb.bitmap = cbBack;
			cb.x = 400;
			cb.y = 400;
			cb.height = 15;
			cb.addItem('Item1');
			cb.addItem('Item2');
			cb.addItem('Item3');
			cb.addItem('Item4');
			cb.addItem('Item5');
			cb.selectedItem = 'Item1';
			addChild(cb);
			
			var label: Label = new Label(this, 'TestLabel');
			label.x = 300;
			label.y = 250;
			//label.debug = true;
			label.fillBackground(0xffffff, 1.0);
			label.selectable = true;
			label.canHover = true;
			label.canFocus = true;
			addChild(label);
			
			gb = new GridBox(this, 4);
			gb.addEventListener(GridBoxEvent.TYPE_ITEM_SELECTED, function (event: GridBoxEvent) : void {
				trace((event.item as String) + ' ' + event.columnIndex + ' ' + event.rowIndex);
			});
			gb.x = 50;
			gb.y = 3;
			gb.width = 500;
			gb.height = 300;
			gb.widthPolicy = GridBox.WIDTH_POLICY_AUTO_SIZE;
			gb.heightPolicy = GridBox.HEIGHT_POLICY_AUTO_SIZE;
//			gb.columnWidthPolicy = GridBox.COLUMN_WIDTH_POLICY_ALL_SAME;
//			gb.rowHeightPolicy = GridBox.ROW_HEIGHT_POLICY_ALL_SAME;
			gb.horizontalItemsAlign = GameObject.HORIZONTAL_ALIGN_LEFT;
			gb.verticalItemsAlign = GameObject.VERTICAL_ALIGN_TOP;
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
		/*
		private function changeListener(e:Event):void {
			p.clear();
			p.update();
		}
		
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

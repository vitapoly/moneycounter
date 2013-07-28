package
{	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import flash.text.TextField;
		
	public class Game extends Sprite
	{
		private var titleSprite:Sprite;
		private var textOutputGUI:Sprite;
		private var outputTxt:TextField;
		private var nameList:Array = new Array("Jun", "Mark", "Micheal", "Larry", "Amado", "Byron", "Caleb", "Kial", "Robert", "Steve", "Tipatat", "Taige", "Amir ", "James", "Jimmy","Saravjeet","Monty","Rebecca","Vanessa","Kefan","Oliver","Putri","Matthew","Kia","James", "Keith","Cheryl","Christopher","Carolyn","LaTorri","Chris","Elissa","KewPee","Charles","Nicu","Beverly","Greg","Kurt","Hao","Noreen","Regina","Phil","Angelo","Hari","Dominique","Isa","Lily","Celeste","Trisha","Yosun" );
		
		
		public function Game()
		{
			super();
			
			titleSprite = new Sprite();
			textOutputGUI = new Sprite();
			/*
			var BGloader:Loader = new Loader();
			BGloader.contentLoaderInfo.addEventListener(Event.COMPLETE, BGloaderComplete);
			BGloader.load(new URLRequest("images/background.jpg"));
			
			var titleImageLoader:Loader = new Loader();
			titleImageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, titleImageLoaderComplete);
			titleImageLoader.load(new URLRequest("images/title.png"));
			
			var textOutputGUILoader:Loader = new Loader();
			textOutputGUILoader.contentLoaderInfo.addEventListener(Event.COMPLETE, textOutputGUILoaderComplete);
			textOutputGUILoader.load(new URLRequest("images/textBG.png"));
			*/
			//2 modes: identify money and game mode
			//identify money simply detects money and says it back to the user
			//game mode will test and grade user based on the least amount of bills used to complete a purchase
			
			
			MoneyCounter.instance.readyToRecord  = true;
			
		}
		/*
		public function BGloaderComplete (event:Event):void
		{
	//		addChild(new Bitmap(Bitmap(LoaderInfo(event.target).content).bitmapData));
			say(("Welcome to the shopping game. You can select a game mode by saying money, or shopping.  You can tap anywhere on the screen to start talking.  When you are finished talking, tap the screen again.");
			MoneyCounter.instance.readyToRecord  = true;
		}
		
		public function titleImageLoaderComplete(event:Event):void
		{
			titleSprite.addChild(new Bitmap(Bitmap(LoaderInfo(event.target).content).bitmapData));
			addChild(titleSprite);
		}
		
		
		public function textOutputGUILoaderComplete(event:Event):void
		{
			MoneyCounter.instance.readyToRecord  = true;
			textOutputGUI.addChild(new Bitmap(Bitmap(LoaderInfo(event.target).content).bitmapData));
			addChild(textOutputGUI);
			textOutputGUI.x = 34;
			textOutputGUI.y = 1024 - textOutputGUI.height;
		}*/
		
		public function startMoneyMode():void
		{
			MoneyCounter.instance.say("Please hold up one bill at a time for the camera.");
			
		}
		
		public function startShoppingMode():void
		{
			MoneyCounter.instance.say("");
		
		}
			
		public function randRange(min:Number, max:Number):Number{
			var randomNum:Number = Math.floor(Math.random() * (max - min + 1)) + min
			return randomNum
		}
	}
	
	
}





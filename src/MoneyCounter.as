package
{
	
	import com.vitapoly.speech.AirSpeech;
	import com.vitapoly.speech.AirSpeechRecognitionEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import cmodule.aircall.CLibInit;
	import flash.display.Bitmap;
	

	[SWF(backgroundColor="#ffffff", frameRate="60", width = "768", height = "1024" )]
	public class MoneyCounter extends Sprite
	{
		public static var instance:MoneyCounter;
		private var disableSpeechDebug:Boolean = true;  //set to false if want speech
		
		private var camera:Camera;
		private var video:Video;
		private var isRecording:Boolean = false;

		private var game:Game;
		
		
		public var readyToRecord:Boolean;
		public var airSpeech:AirSpeech;
		
		
		private var debugTxt:TextField;
		
		public function MoneyCounter()
		{
			super();
			instance = this;
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
						
			//  init camera
			setupCamera();
			var textFormat:TextFormat = new TextFormat;
			textFormat.size = 20;
			
			debugTxt = new TextField();
			debugTxt.width = 500;
			debugTxt.height = 500;
			debugTxt.alpha = 70;
			debugTxt.x = video.width;
			debugTxt.defaultTextFormat = textFormat;
			debugTxt.text = "Debug Text Area";
			addChild(debugTxt);
			
		}
		
		public function log(str):void
		{
			trace(str);
			debugTxt.text += str + "\n";
			debugTxt.scrollV = debugTxt.numLines - 4;
		}

		
		private function setupCamera():void
		{
			video = new Video(640, 480);
			camera = Camera.getCamera();
			camera.setMode(640, 480, 30);
			video.attachCamera(camera);
			addChild(video);
			
			var btn:Sprite = new Sprite();
			btn.addChild(new Bitmap(new BitmapData(300,300,false, 0xFF0000)));
			btn.y = video.height;
			addChild(btn);
			
			
			
			btn.addEventListener(MouseEvent.CLICK, function(e:Event):void
			{
				
				log("starting process");
				
				//  save jpg
				var jpgData:ByteArray = saveJPG();
				
				uploadJPG(jpgData, function()
				{
					log("uploaded");
				});
			});
			
			airSpeech = new AirSpeech();
			
			airSpeech.addEventListener(AirSpeech.SPEECH_RECOGNIZED_EVENT, function(e:AirSpeechRecognitionEvent):void {
				trace(JSON.stringify(e.response));
				
				if ((e.response.status == 0) && (e.response.hypotheses.length)) {
					var phrase:String = e.response.hypotheses[0].utterance; // recognized phrase
					
					say("I've heard you say, " + phrase);
					
					switch(phrase)
					{
						case "money":
							game.startMoneyMode();
							break;
						case "shopping":
							game.startShoppingMode();
							break;
						
					}					
					
				} else {
					say("I am sorry, I didn't catch that.");
				}
			});
			
			// tap stage once to start recording, tap again to stop
			stage.addEventListener(MouseEvent.CLICK, function(e:Event):void
			{
				if(readyToRecord)
					toggleRecordOnOff();
				
				
			});
			
			
			game = new Game();
			addChild(game);
			
		}

		
		public function toggleRecordOnOff():void
		{
			if (isRecording) {
				if(!disableSpeechDebug)	
					airSpeech.stopRecording();
			isRecording = false;
			} else {
				if(!disableSpeechDebug)	
					airSpeech.startRecording();
			isRecording = true;
			}
		}
		
		public function saveJPG():ByteArray
		{
			var bitmapData:BitmapData = new BitmapData(640, 480);
			bitmapData.draw(video);
			
			return this.bitmapDataToJpeg(bitmapData); 
		}
		
		public function uploadJPG(jpgData:ByteArray, callback:Function):void
		{
			log("Main.uploadJPG");
			
			try{
				
				var urlRequest:URLRequest=new URLRequest("http://apps.vitapoly.com/apps/opencv/findMoneyFromImage.php");
				urlRequest.method = URLRequestMethod.POST;
				urlRequest.data = jpgData;
				
				var urlLoader:URLLoader=new URLLoader();
				urlLoader.dataFormat=URLLoaderDataFormat.TEXT;
				
				
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, function(e:flash.events.ErrorEvent):void{
					log("error: " + e.errorID);
				});
				urlLoader.addEventListener(flash.events.Event.COMPLETE, function(e:flash.events.Event):void
				{
					callback(e.target.data);
					log("done: \n"+ e.target.data);
				});				
				
				urlLoader.load(urlRequest);
				
				
			} catch(error:Error)
				
			{
				log(error.getStackTrace());
			}
		}		
		
		public function say(str:String):void
		{
			if(!disableSpeechDebug)
				airSpeech.speak(str);
			
			log(str);
		}

		public function bitmapDataToJpeg(bitmapData:BitmapData):ByteArray
		{
			log("Main.bitmapDataToJpeg");
			
			/// init alchemy object
			var jpeginit:CLibInit = new CLibInit(); // get library
			var jpeglib:Object = jpeginit.init(); // initialize library exported class to an object
			var byteArray:ByteArray = new ByteArray();
			var byteArrayOut:ByteArray = new ByteArray();
			byteArray = bitmapData.getPixels(bitmapData.rect);
			byteArray.position = 0;
			jpeglib.encode(byteArray, byteArrayOut, bitmapData.width, bitmapData.height, 80);
			return byteArrayOut;
			
		}
		

	}
}
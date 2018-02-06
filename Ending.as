package{
	import org.flixel.*;
	import flash.ui.Keyboard;
	import flash.events.Event;
	import Playtomic.*;
	import flash.events.KeyboardEvent;
	import flash.external.ExternalInterface;	 

 
	public class Ending extends FlxState{
		
		[Embed(source="Visual/Title.png")] 				protected var ImgTitle:Class;
		[Embed(source="Visual/Red_Grid_BG.png")] 		protected var ImgRedBG:Class;
		private var BackgroundGroup:FlxGroup;
		private var TitleGroup:FlxGroup;
		private var Page:uint = 0;
	
		//this handles initializing everything
		override public function create():void{	
			//fuk da world
			initGame();
		}

		private function ClearData():void{
			var cutie:QTPi = new QTPi();
			cutie.OHGODNOPLEASEDONT();
		}
		
		private function Continue():void{
			Page++;
			switch(Page){
				default:
					FlxG.switchState(new GameState());
					break;
			}
		}
		
		
		//this is the update() function
		override public function update():void{		
			if(FlxG.keys.justPressed("X")){
				Continue();
			}
			if(FlxG.keys.justPressed("R")){
				ClearData();
			}
			super.update();
		}
		
		protected function initGame():void{
		
			//Group Initialization
			BackgroundGroup	= new FlxGroup();
			TitleGroup		= new FlxGroup();
			//create background
			for(var i:uint = 0; i < (320/16); i++){
				for (var j:uint = 0; j < (240/16); j++){
					var ax:uint	= i*16;
					var ay:uint	= j*16;
					var a:FlxSprite = new FlxSprite(ax, ay);
					a.loadGraphic(ImgRedBG, true, true, 16, 16);
					a.addAnimation("Loopme", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15], 10, true);
					a.play("Loopme");
					a.blend	= "screen";
					BackgroundGroup.add(a);
				}
			}
			for(i = 0; i < (320/16); i++){
				for (j = 0; j < (240/16); j++){
					var bx:uint	= i*16;
					var by:uint	= j*16;
					var b:FlxSprite = new FlxSprite(bx, by);
					b.loadGraphic(ImgRedBG, true, true, 16, 16);
					b.addAnimation("Loopme2", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15], 5, true);
					b.play("Loopme2");
					b.blend	= "screen";
					b.angle = 90+180;
					BackgroundGroup.add(b);
				}
			}			
			var EndingText:FlxText = new FlxText(10, 50, 300, "Congratulations!");
			EndingText.size = 24;
			EndingText.alignment = "center";
			TitleGroup.add(EndingText);
			EndingText = new FlxText(10, 100, 300, "You've collected the 4 Orb of Goals, and reminded QT-Pi that she enjoys things in life other than Wario Land! There would be pictures and shit here but I've only got a few hours left- and there are more important things. It was great to join in on Ludum dare this time, I had a blast, missed some social events, and I'm sure I'll be back for more next time.");
			EndingText.alignment = "center";
			TitleGroup.add(EndingText);
			EndingText = new FlxText(10, FlxG.height-50, 300, "Press X to continue back to the title screen, or R to clear your saved data.");
			EndingText.alignment = "center";
			TitleGroup.add(EndingText);
			
			var asdf:FlxText = new FlxText(0, FlxG.height - 30, 320, "A game by Joseph Stevens for Ludum Dare 21");
			asdf.alignment = "center";
			TitleGroup.add(asdf);
			asdf = new FlxText(0, FlxG.height - 20, 320, "http://www.splixel.com");
			asdf.alignment = "center";
			TitleGroup.add(asdf);
			
			add(BackgroundGroup);
			add(TitleGroup);
		}		
	}
}

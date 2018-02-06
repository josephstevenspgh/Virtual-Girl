package{
	import org.flixel.*;
	import flash.ui.Keyboard;
	
	import flash.events.Event;
	import Playtomic.*;
	import flash.events.KeyboardEvent;
	import flash.external.ExternalInterface;	 

 
	public class GameState extends FlxState{
		
		[Embed(source="Visual/Title.png")] 				protected var ImgTitle:Class;
		[Embed(source="Visual/Red_Grid_BG.png")] 		protected var ImgRedBG:Class;
		private var BackgroundGroup:FlxGroup;
		private var TitleGroup:FlxGroup;
		private var Page:uint = 0;
	
		//this handles initializing everything
		override public function create():void{	
			//fuk da world
			if(ExternalInterface.available && ExternalInterface.objectID != null){
				Log.View(4010, "2e2246c47d3b445d", ExternalInterface.call('window.location.href.toString'));
			}
			
			//this is now a title screen
			initGame();
		}
		
		private function Continue():void{
			Page++;
			switch(Page){
				case 1:
					//hide prev group
					TitleGroup.members[0].alpha = 0;
					TitleGroup.members[1].alpha = 0;
					TitleGroup.members[2].alpha = 0;
					var a:FlxText =new FlxText(10, FlxG.height - 20, 300, "Press X to continue."); 
					a.alignment = "center";
					TitleGroup.add(a);
					BackgroundGroup.add(new FlxText(10, 20, 300, "This is the story of the girl who loved her Virtual Boy so much that became hopelessly addicted. The only thing that mattered to her was playing Wario Land, because all the other games sucked. But boy, did she love that Wario Land."));
					BackgroundGroup.add(new FlxText(10, 70, 300, "I don't know why, but she played the shit out of that game. Didn't matter what was going on, even took it with her when she had a tattoo of 3D glasses put on her lower back. She beat the game three times during that episode."));
					BackgroundGroup.add(new FlxText(10, 120, 300, "Eventually, all of her friends got sick of trying to talk to her and she grew very lonely. Not that she cared or anything, at least she still had good ol' Wario there for her. But damnit YOU care. Help her escape this awful Virtual Reality addiction by forcing her to collect 4 objects that reminded her of how great her previous life was. Cmon, you know you want to."));
					break;
				default:
					FlxG.switchState(new HubMap());
					//FlxG.switchState(new Ending());
					break;
			}
		}
		
		
		//this is the update() function
		override public function update():void{		
			if(FlxG.keys.justPressed("X")){
				Continue();
			}
			super.update();
		}
		
		protected function initGame():void{
		
			//Group Initialization
			BackgroundGroup	= new FlxGroup();
			//create background
			for(var i:uint = 0; i < (FlxG.width/16); i++){
				for (var j:uint = 0; j < (FlxG.height/16); j++){
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
			for(i = 0; i < (FlxG.width/16); i++){
				for (j = 0; j < (FlxG.height/16); j++){
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
			
			TitleGroup = new FlxGroup();
			TitleGroup.add(new FlxSprite(0, 0, ImgTitle));
			var asdf:FlxText = new FlxText(0, FlxG.height - 30, FlxG.width, "A game by Joseph Stevens for Ludum Dare 21");
			asdf.alignment = "center";
			TitleGroup.add(asdf);
			asdf = new FlxText(0, FlxG.height - 20, FlxG.width, "http://www.splixel.com");
			asdf.alignment = "center";
			TitleGroup.add(asdf);
			
			add(BackgroundGroup);
			add(TitleGroup);
		}		
	}
}

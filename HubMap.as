package{
	import flash.display.Stage;
	import flash.events.FullScreenEvent;
	import org.flixel.*;
	import flash.ui.Keyboard;
	import flash.events.Event;
	import flash.events.KeyboardEvent;

 
	public class HubMap extends FlxState{
		//Variables and Etc
		private var Player:QTPi;
		
		//Graphics
		[Embed(source="Data/HubWorldtiles.png")] 		protected var RedMap_Tiles:Class;
		[Embed(source="Visual/Red_Grid_BG.png")] 		protected var ImgRedBG:Class;
		[Embed(source="Visual/Doors.png")] 				protected var ImgDoors:Class;
		[Embed(source="Visual/OrbOfGoal_MapIcons.png")] protected var ImgOrbs:Class;
		[Embed(source="Visual/BoostRefuge.png")] 			protected var ImgPat:Class;
		
		[Embed(source="Visual/BoostPack.png")] protected var ImgBoost:Class;
		//Music
		[Embed(source="Audio/Stage1.wav.mp3")]	protected var IntroMusic:Class;
		
		//Maps
		[Embed(source="Data/HubWorldmap001.txm",		mimeType="application/octet-stream")] protected var RedMap_Data:Class;
		private var RedTileMap:FlxTilemap;
		
		//Groups
		private var BackgroundGroup:FlxGroup;
		private var TileGroup:FlxGroup;
		private var PlayerGroup:FlxGroup;
		private var ItemGroup:FlxGroup;
		private var ObjectGroup:FlxGroup;
		
		//temp bs
		private var emitter:FlxEmitter;
		private var FullScreen:Boolean	= false;
		
		//this handles initializing everything
		override public function create():void{			
			//Initialize THINGS

			initGame();
			
			super.update();
		}
		
		protected function initGame():void{
			//Musics
			FlxG.playMusic(IntroMusic);
		
			//Group Initialization
			BackgroundGroup	= new FlxGroup();
			TileGroup 		= new FlxGroup();
			PlayerGroup 	= new FlxGroup();
			ItemGroup		= new FlxGroup();
			ObjectGroup		= new FlxGroup();
			
			//Load Map
			RedTileMap	= new FlxTilemap();
			RedTileMap.loadMap(new RedMap_Data, RedMap_Tiles, 16, 16);
			
			FlxG.worldBounds = RedTileMap.getBounds();
			
			//Create Player
			Player = new QTPi(128, 24);
			Player.Unlock();
			
			
			//Add Groups
			TileGroup.add(RedTileMap);
			PlayerGroup.add(Player);
			PlayerGroup.add(Player.GroupSprites());
			//doors
			ItemGroup.add(new FlxSprite(152, 64));
			ItemGroup.add(new FlxSprite(72, 112));
			ItemGroup.add(new FlxSprite(232, 112));
			ItemGroup.add(new FlxSprite(152, 160));
			//orb notifiers
			ItemGroup.add(new FlxSprite(136, 144));
			ItemGroup.add(new FlxSprite(152, 144));
			ItemGroup.add(new FlxSprite(168, 144));
			
			//load graphics for items
			ItemGroup.members[0].loadGraphic(ImgDoors, true, true, 16, 16);
			ItemGroup.members[1].loadGraphic(ImgDoors, true, true, 16, 16);
			ItemGroup.members[2].loadGraphic(ImgDoors, true, true, 16, 16);
			ItemGroup.members[3].loadGraphic(ImgDoors, true, true, 16, 16);
			ItemGroup.members[4].loadGraphic(ImgOrbs, true, true, 16, 16);
			ItemGroup.members[5].loadGraphic(ImgOrbs, true, true, 16, 16);
			ItemGroup.members[6].loadGraphic(ImgOrbs, true, true, 16, 16);
			ItemGroup.members[1].frame = 1;
			ItemGroup.members[2].frame = 2;
			ItemGroup.members[3].addAnimation("RGBDoor", [0, 1, 2], 30, true);
			ItemGroup.members[3].play("RGBDoor");
			
			//orbs
			if(Player.Orb1Got){
				ItemGroup.members[4].frame = 1;
			}
			if(Player.Orb2Got){
				ItemGroup.members[5].frame = 2;
			}
			if(Player.Orb3Got){
				ItemGroup.members[6].frame = 3;
			}
			
			//Object Group - all objects need to be on this
			ObjectGroup.add(PlayerGroup);
			
			add(BackgroundGroup);
			add(TileGroup);
			add(ItemGroup);
			add(PlayerGroup);
			
			//Camera
//			FlxG.camera = new FlxCamera(0, 0, 640, 480);
			FlxG.camera.follow(Player, FlxCamera.STYLE_PLATFORMER);
			FlxG.camera.bounds = RedTileMap.getBounds();
		}
		
		private function toggleFullScreen():void {
			try {
				switch (systemManager.stage.displayState) {                         
					case StageDisplayState.FULL_SCREEN:                             
						systemManager.stage.displayState = StageDisplayState.NORMAL;
						break;                         
					default:
						systemManager.stage.fullScreenSourceRect = new Rectangle (0,20,640,480);
						systemManager.stage.displayState = StageDisplayState.FULL_SCREEN;
						break;                     
				}                 
			} catch (err:SecurityError) {}
		}
		
		//this is the update() function
		override public function update():void{			
			//Entering Doors
			if(FlxG.keys.DOWN || FlxG.keys.S){
				if(FlxG.overlap(PlayerGroup, ItemGroup.members[0])){
					FlxG.switchState(new RedMap());
				}else if(FlxG.overlap(PlayerGroup, ItemGroup.members[1])){
					FlxG.switchState(new SlopeTest());
				}else if(FlxG.overlap(PlayerGroup, ItemGroup.members[2])){
//					FlxG.switchState(new BlueMap());
				}else if(FlxG.overlap(PlayerGroup, ItemGroup.members[3])){
					if(Player.Orb1Got && Player.Orb2Got && Player.Orb3Got){
//						FlxG.switchState(new RGBMap());
					}
				}
			}
			if(FlxG.keys.justPressed("F")){
				toggleFullScreen();
			}
			
			//Blink Ability
			if(Player.CanBlink){
				if(FlxG.mouse.justPressed()){
					var BTileID:uint = RedTileMap.getTile(uint(FlxG.mouse.x/16), uint(FlxG.mouse.y/16));
					if(BTileID < 5){
						Player.x	= FlxG.mouse.x;
						Player.y	= FlxG.mouse.y;
					}
				}
			}
			
			super.update();			
			
			//collision
			FlxG.collide(ObjectGroup, TileGroup);
		}
	}
}

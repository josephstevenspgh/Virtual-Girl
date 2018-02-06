package{
	import org.flixel.*;
	import flash.ui.Keyboard;
	import flash.events.Event;
	import flash.events.KeyboardEvent;

 
	public class TreasureRoom extends VGMap{
		
		//Maps
		[Embed(source="Data/TreasureRoommap001.txm",				mimeType="application/octet-stream")] protected var TreasureRoomMap_Data:Class;
		
		//Graphics
		[Embed(source="Data/TreasureRoomtiles.png")] 				protected var TTiles:Class;
		[Embed(source="Visual/TreasureChest.png")] 					protected var ImgChest:Class;
		[Embed(source="Visual/GlowingOrb.png")] 					protected var ImgGlowOrb:Class;
		
		//Treasure Room Variables
		private var TreasureID:uint;
		private var PreviousState:VGMap;
		private var PreviousX:Number;
		private var PreviousY:Number;
		
		//MOTHER FUCKING TREASURE, YEE BOY
		private var TreasureChest:FlxSprite;
		private var GlowOrb:FlxSprite;
		private var TreasureText:FlxSprite;
		private var TreasureChestOpened:Boolean = false;
		private var GlowOrbDir:Boolean = true;
		private var GlowOrbStable:Boolean = false;
		
		//Text for different treasures.
		private var HC_TEXT:String 		= "You've found a life-up! Collect 3 of these to increase your health by one!";
		private var BOOST_TEXT:String	= "You've found the Boost Pack! Press X while airborne to get a nice little jet boost.";
		private var KEY_TEXT:String		= "You got a key! You can use this to enter the next level.";
		private var CAT_TEXT:String		= "You've found... a cat? Well, might as well bring him with you.";
		
		private var NOTHERE_TEXT:String	= "Sorry, it seems you've already gotten this treasure.";
		
		/* 
		 * Notes about TreasureID
		 * 1   - 99	 - Heart Containers
		 * 101 - 199 - Abilities
		 * 201 - 299 - CATS YO
		 * 301 - 399 - End of Level Goals
		 */
		
		public function TreasureRoom(TID:uint, PState:VGMap):void{
			//Stuff you need to know :)
			TreasureID 		= TID;
			PreviousState 	= PState;
		}
		
		override protected function initGame():void{
			//Musics
			FlxG.playMusic(IntroMusic);
			
			//mother fuckin treasure chest aw ye man
			TreasureChest = new FlxSprite();
			TreasureChest.loadGraphic(ImgChest, true, true, 32, 32);
			TreasureChest.x = (FlxG.width/2) - (TreasureChest.width/2);
			TreasureChest.y = 128;
			GlowOrb = new FlxSprite();
			GlowOrb.loadGraphic(ImgGlowOrb, true, true, 32, 32);
			GlowOrb.addAnimation("Glow", [0, 1, 2, 3, 2, 1], 15, true);
			GlowOrb.play("Glow");
			GlowOrb.y = 128
			GlowOrb.x = -144;
		PreviousState
			//Group Initialization
			BackgroundGroup	= new FlxGroup();
			TileGroup 		= new FlxGroup();
			PlayerGroup 	= new FlxGroup();
			EnemyGroup		= new FlxGroup();
			LifeGroup		= new FlxGroup();
			ItemGroup		= new FlxGroup();
			ObjectGroup		= new FlxGroup();
			
			//Load Map
			LevelTileMap	= new FlxTilemap();
			LevelTileMap.loadMap(new TreasureRoomMap_Data, TTiles, 16, 16, 0, 0, 1, 30);
			
			FlxG.worldBounds = LevelTileMap.getBounds();
			
			//Create Player
			Player = new QTPi(24, FlxG.height-64);
			Player.Unlock();
			PlayerMaxLife = Player.getMaxLife();
			
			//Life Display
			for(var asdf:uint = 0; asdf < PlayerMaxLife; asdf++){
				var LifeSprite:FlxSprite = new FlxSprite();
				LifeSprite.loadGraphic(ImgLife, true, true, 8, 8);
				LifeSprite.x	= 9 * (asdf+1);
				LifeSprite.y	= 8;
				LifeSprite.scrollFactor = new FlxPoint(0, 0);
				LifeGroup.add(LifeSprite);
			}
			
			//Add Groups
			TileGroup.add(LevelTileMap);
			PlayerGroup.add(Player);
			PlayerGroup.add(Player.GroupSprites());
			PlayerGroup.add(Player.GroupBullets());
			ItemGroup.add(new OrbOfGoal(-1088, 80));
			ItemGroup.add(new DoubleJump(-80, 176));
			ItemGroup.add(new DoubleJump(-64, 64));
			
			//Object Group - all objects need to be on this
			ObjectGroup.add(EnemyGroup);
			ObjectGroup.add(PlayerGroup);
			
			
			add(BackgroundGroup);
			add(TileGroup);
			add(ItemGroup);
			add(EnemyGroup);
			add(GlowOrb);
			add(TreasureChest);
			add(PlayerGroup);
			add(LifeGroup);
			
			//Camera
			FlxG.camera.follow(Player, FlxCamera.SHAKE_HORIZONTAL_ONLY);
			FlxG.camera.bounds = LevelTileMap.getBounds();
			ShowIcons();
		}
		
		private function TreasureCheck():void{
			if(TreasureChestOpened){
				//OH MY GOD YOU OPENED IT. YOU ASS
				if(GlowOrbStable){
					//MAKE IT FLOAT
					if(GlowOrbDir){
						GlowOrb.y += .25;
					}else{
						GlowOrb.y -= .25;
					}
					if(GlowOrb.y <= TreasureChest.y - 32){
						GlowOrbDir = !GlowOrbDir;
					}else if(GlowOrb.y >= TreasureChest.y - 32 + 8){
						GlowOrbDir = !GlowOrbDir;
					}
				}else{
					//RAISE THAT BITCH
					GlowOrb.y -= .5;
					if(GlowOrb.y <= TreasureChest.y - 32){
						GlowOrbStable = true;
					}
				}
			}
		
		}		
		
		private function GiveItem():void{
			if(TreasureID < 100){
				PlayerGroup.members[0].GiveItem(TreasureID);
			}else if(TreasureID == 101){
			
			}
		}
		
		override protected function WarpDoor():void{
			FlxG.switchState(PreviousState);
		}
		
		private function TextboxCheck():void{
			if(TreasureText != null){
				if(TreasureText.scale.x < 1){
					TreasureText.scale = new FlxPoint(TreasureText.scale.x+.05, TreasureText.scale.x+.05);
				}
			}
		}
		
		override protected function SpecialRoom():void{
			TreasureCheck();	
			TextboxCheck();
			if(GlowOrbStable){		
				if(FlxG.overlap(PlayerGroup, GlowOrb)){
					GlowOrb.x = -50;
					TreasureText = VGLib.DrawTextBox("You got the thingy!<br>I'll put nicer text here later.<br><br>ps hi guise sup lols.<br>Press C to return kthxbai", 24, 24, true);
					TreasureText.scale = new FlxPoint(0, 0);
					add(TreasureText);
					PauseGame = true;
					PlayerGroup.members[0].PauseGame = true;
					GiveItem();
				}
			}
			if(TreasureChest.frame > 0){
				if(FlxG.keys.justPressed("C")){
					//leave this place at once!
					if(PauseGame){
						PauseGame = false;
						TreasureText.x = FlxG.width+1;
						TreasureText = VGLib.DrawTextBox("OK. Now press C to exit.", 24, 32, true);
					TreasureText.scale = new FlxPoint(0, 0);
						add(TreasureText);
						PlayerGroup.members[0].PauseGame = false;
					}else{
						SetupDoorFadeout();
					}
				}
			}
		}
		
		override protected function CheckDoors():void{
			//Use this function for treasure chests
			if((PlayerGroup.members[0].x > 144) && (PlayerGroup.members[0].x < 160)){
				TreasureChestOpened = true;
				TreasureChest.frame += 1;
				GlowOrb.x = TreasureChest.x;
			}
		}
	}
}

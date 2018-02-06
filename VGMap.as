package{
	import org.flixel.*;
	import flash.ui.Keyboard;
	import flash.events.Event;
	import flash.events.KeyboardEvent;

 
	public class VGMap extends FlxState{
		//Variables and Etc
		protected var Player:QTPi;
		private var PlayerDead:Boolean	= false;
		private var BlinkTimer:Number	= 0;
				
		//Graphics
		[Embed(source="Visual/Red_Backdrop.png")] 		protected var ImgRedBG:Class;
		[Embed(source="Visual/TempHP.png")] 			protected var ImgLife:Class;
		[Embed(source="Visual/WeaponIcons.png")] 		protected var ImgWeapon:Class;
		[Embed(source="Visual/ItemIcons.png")] 			protected var ImgItems:Class;
		
		//Music
		[Embed(source="Audio/Stage1.wav.mp3")]			protected var IntroMusic:Class;
		[Embed(source="Audio/Splash.wav.mp3")]			protected var SfxSplash:Class;
		[Embed(source="Audio/Powerup.wav.mp3")]			protected var SfxPowerup:Class;
		[Embed(source="Audio/DAI.wav.mp3")]				protected var SfxDie:Class;
		
		//Maps
		protected var LevelTileMap:FlxTilemap;
		
		//Screen Transitions
		protected var Entering:uint = 0;
		protected var EnteringDoor:Boolean = false;
		protected var BlackScreen:FlxSprite;
		
		//Groups
		protected var BackgroundGroup:FlxGroup;
		protected var TileGroup:FlxGroup;
		protected var LevelObjects:FlxGroup;
		protected var PlayerGroup:FlxGroup;
		protected var EnemyGroup:FlxGroup;
		protected var ItemGroup:FlxGroup;
		protected var ObjectGroup:FlxGroup;
		protected var BlinkGroup:FlxGroup;
		protected var LifeGroup:FlxGroup;
		
		//Player HUD.. kinda
		protected var PlayerMaxLife:uint;
		protected var PlayerLife:uint;
		protected var InitX:Number			= -1;
		protected var InitY:Number			= -1;
		
		//what map?
		protected var CURRENT_MAP:uint		= 0;
		static protected var HUBMAP:uint 	= 0;
		static protected var REDMAP:uint 	= 1;
		static protected var GREENMAP:uint 	= 2;
		static protected var BLUEMAP:uint 	= 3;
		static protected var RGBMAP:uint 	= 4;
		
		//Tranisitions and shit
		protected var PauseGame:Boolean = false;
		
		//groups suck use this
		protected var TutText:FlxText;
		
		protected var Stage:uint = 0;
		
		//public function VGMap(IX:Number, IY:Number):void{
		//	InitX = IX;
		//	InitY = IY;
		//}
		
		//this handles initializing everything
		override public function create():void{			
			//make mouse visible
			
			//Initialize THINGS
			initGame();
			LifeSetup();
			
			FlxG.flash(0xFF000000);
					
			super.update();
		}
		
		private function LifeSetup():void{
			var LifeSprite:FlxSprite = new FlxSprite();
			LifeSprite.loadGraphic(ImgLife, true, true, 32, 16);
			LifeSprite.x = 8;
			LifeSprite.y = 8;
			LifeSprite.scrollFactor = new FlxPoint(0, 0);
			LifeGroup.add(LifeSprite);
			//Weapon Icon
			var WeaponIcon:FlxSprite = new FlxSprite();
			WeaponIcon.loadGraphic(ImgWeapon, true, true, 16, 16);
			WeaponIcon.x = 8+31;
			WeaponIcon.y = 8;
			WeaponIcon.scrollFactor = new FlxPoint(0, 0);
			LifeGroup.add(WeaponIcon);
			//Item Icons
			var ItemIcon:FlxSprite = new FlxSprite();
			ItemIcon.loadGraphic(ImgItems, true, true, 16, 16);
			ItemIcon.x = 8+31+15;
			ItemIcon.y = 8;
			ItemIcon.frame = 1;
			ItemIcon.scrollFactor = new FlxPoint(0, 0);
			LifeGroup.add(ItemIcon);
			ItemIcon = new FlxSprite();
			ItemIcon.loadGraphic(ImgItems, true, true, 16, 16);
			ItemIcon.x = 8+31+15+15;
			ItemIcon.y = 8;
			ItemIcon.frame = 2;
			ItemIcon.scrollFactor = new FlxPoint(0, 0);
			LifeGroup.add(ItemIcon);
			ItemIcon = new FlxSprite();
			ItemIcon.loadGraphic(ImgItems, true, true, 16, 16);
			ItemIcon.x = 8+31+15+15+15;
			ItemIcon.y = 8;
			ItemIcon.frame = 3;
			ItemIcon.scrollFactor = new FlxPoint(0, 0);
			LifeGroup.add(ItemIcon);
								
		}
		
		protected function ShowLife():void{
			//I'm redesigning how life works.
			//This is temporary.
			
		}
		
		protected function ShowIcons():void{
			var OverlayGroup:FlxGroup = new FlxGroup;
			if(Player.CanDoubleJump){
				//show double jump icon
				var a:DoubleJump = new DoubleJump(132, FlxG.height-20);
				a.scrollFactor = new FlxPoint(0, 0);
				OverlayGroup.add(a);
			}
			if(Player.LiquidProof){
				var b:LiquidProof = new LiquidProof(152, FlxG.height-20);			
				b.scrollFactor = new FlxPoint(0, 0);
				OverlayGroup.add(b);
			}
			if(Player.CanBlink){
				FlxG.mouse.show();
				var c:Blink = new Blink(172, FlxG.height-20);				
				c.scrollFactor = new FlxPoint(0, 0);
				OverlayGroup.add(c);
			}
			add(OverlayGroup);
			
			//set up blink bar
			BlinkGroup = new FlxGroup();
			BlinkGroup.add(new FlxSprite(FlxG.width/2 - 30, FlxG.height-30));
			//makeGraphic(Width:uint, Height:uint, Color:uint = 0xffffffff, Unique:Boolean = false, Key:String = null):FlxSprite			
			BlinkGroup.members[0].makeGraphic(1, 8, 0xFFFFFFFF);
			BlinkGroup.members[0].scrollFactor = new FlxPoint(0, 0);
			BlinkGroup.members[0].alpha			= 0;
			add(BlinkGroup);
		}
		
		protected function initGame():void{}
		
		private function CheckDeath():void{
			if((!Player.Unlocked || Player.y > LevelTileMap.height) && !PlayerDead){
				var a:FlxText = new FlxText(0, 75, FlxG.width, "You died and that totally sucks.");
				a.alignment = "center";
				a.size		= 16;
				a.scrollFactor = new FlxPoint(0, 0);
				a.shadow	= 0xFF000000;
				add(a);
				a = new FlxText(0, 110, FlxG.width, "Press R to restart.");
				a.alignment = "center";
				a.size		= 8;
				a.scrollFactor = new FlxPoint(0, 0);
				a.shadow	= 0xFF000000;
				add(a);
				PlayerDead = true;
				Player.Lock();
				super.update();
			}
		}
		
		private function ShowText(WhatText:uint):void{
			switch(WhatText){
				case 1:
					//double jump
					TutText = new FlxText(0, 73, FlxG.width, "You've unlocked Double Jump! Take a guess as to how this works.");
					TutText.alignment = "center";
					TutText.scrollFactor = new FlxPoint(0, 0);
					break;
				case 2:
					//blink
					TutText = new FlxText(0, 73, FlxG.width, "You've unlocked Blink! Click anywhere within QT-Pi's vision to instantly teleport. However, you can only do this once every 30 seconds.");
					TutText.alignment = "center";
					TutText.scrollFactor = new FlxPoint(0, 0);
					break;
				case 3:
					//liquid proof
					TutText = new FlxText(0, 73, FlxG.width, "You've unlocked LiquidProof! You can now enter wet places.");
					TutText.alignment = "center";
					TutText.scrollFactor = new FlxPoint(0, 0);
					break;
				}
				TutText.alpha = 1;
				add(TutText);
		}
		
		protected function CheckDoors():void{}
		
		protected function DoorAt(DX:Number, DY:Number):Boolean{
			//See if the player overlaps with the door - be a little generous
			var PX:Number = PlayerGroup.members[0].x;
			var PY:Number = PlayerGroup.members[0].y;
			
			if((PX + 4) > DX){
				if((PX - 12) < (DX)){
					//X fits - now check Y
					//I'm too tired and lazy to do this all together or easier
					if((PY + 4) > DY){
						if((PY - 12) < (DY)){
							return true;
						}
					}
				}
			}
			
			return false;
		}
				
		protected function SetupDoorFadeout():void{
				PauseGame = true;
				EnteringDoor = true;
				BlackScreen = new FlxSprite();
				BlackScreen.scrollFactor = new FlxPoint(0, 0);
				BlackScreen.makeGraphic(FlxG.width, 1000, 0xFF000000);
				BlackScreen.x = 0;
				BlackScreen.y = -1000;
				PlayerGroup.members[0].PauseGame = true;
				add(BlackScreen);		
		}
		
		protected function SpecialRoom():void{}
		protected function WarpDoor():void{}
		
		//this is the update() function
		override public function update():void{
			if(PauseGame){
				//skip this shit
				SpecialRoom();
				
				if(EnteringDoor){
					//Enter that door :)
					BlackScreen.acceleration.y += 45;
					if(BlackScreen.y > -760){
						//WARP
						WarpDoor();
					}
				}
				
				super.update();
				PlayerGroup.members[0].AlignBoost();
				return;
			}
			SpecialRoom();
			//Check for doors
			if(FlxG.keys.justPressed("DOWN")){
				CheckDoors();
			}
			
			//Lifebar
			ShowLife();
		
			//fade out tutorial text
			if(TutText != null){
				TutText.alpha -= FlxG.elapsed/5;
			}
			
			CheckDeath();
			
			//restart button
			if(FlxG.keys.R){
				FlxG.switchState(new HubMap());
			}
		
		
			for(var i:uint = 0; i < EnemyGroup.members.length; i ++){
				if(EnemyGroup.members[i] != null){
					var TileID:uint = LevelTileMap.getTile(uint(EnemyGroup.members[i].x/16), uint(EnemyGroup.members[i].y/16));
					if(TileID == 1 || TileID == 2){
						FlxG.play(SfxSplash);
						EnemyGroup.members[i].KillMe();
					}
				}
			}
			
			//kill player in lava
			var PTileID:uint = LevelTileMap.getTile(uint((Player.x+8)/16), uint((Player.y+8)/16));
			
			switch(CURRENT_MAP){
				case REDMAP:
					if(PTileID == 20 || PTileID == 21){
						if(!Player.LiquidProof){
							if(Player.Unlocked){
								FlxG.play(SfxSplash);
								Player.KillMe();
							}
						}
					}
					break;
			}
			
			//Let player know if shes on a ladder
			switch(CURRENT_MAP){
				case REDMAP:
					if(PTileID == 28){
						Player.isOverLadder = true;
					}else{
						Player.isOverLadder = false;
					}
					break;
			}
			

			if(FlxG.overlap(PlayerGroup, EnemyGroup)){
				if(Player.Unlocked){
					FlxG.play(SfxDie);
					Player.KnockBack(1);
				}
			}
			
			//this is the wingame one
			if(FlxG.overlap(PlayerGroup, ItemGroup.members[0])){
				FlxG.play(SfxPowerup);
				Player.UnlockOrb(Stage);
				if(Stage != 4){
					FlxG.switchState(new HubMap());
				}else{
					FlxG.switchState(new Ending());
				}
			}
			
			//ability
			if(FlxG.overlap(PlayerGroup, ItemGroup.members[1])){
				FlxG.play(SfxPowerup);
				ShowText(Stage);
				switch(Stage){
					case 1:						
						Player.UnlockDoubleJump();
						break;
					case 2:
						Player.UnlockBlink();
						break;
					case 3:
						Player.UnlockLiquidProofing();
						break;
				}
				ItemGroup.members[1].x = -50;
//				ShowIcons();
			}
			
			
			//Blink Ability
			if(Player.CanBlink && Player.Unlocked){
				if(BlinkTimer <= 0){
					if(FlxG.mouse.justPressed() && Player.onGround()){
						var BTileID:uint = LevelTileMap.getTile(uint(FlxG.mouse.x/16), uint(FlxG.mouse.y/16));
						var SolidIndex:uint = 0;
						switch(CURRENT_MAP){
							default:
								SolidIndex = 5;
								break;
							case REDMAP:
								SolidIndex = 24;
								break;
						}
						if(BTileID < SolidIndex){
							//check if player can see the tile
							if(LevelTileMap.ray(new FlxPoint(FlxG.mouse.x, FlxG.mouse.y), new FlxPoint(Player.x, Player.y))){
								Player.x	= uint(FlxG.mouse.x/16) * 16;
								Player.y	= uint(FlxG.mouse.y/16) * 16;
								BlinkTimer	= 30;
								BlinkGroup.members[0].alpha = 1;
							}
						}
					}
				}else{
					BlinkTimer -= FlxG.elapsed;
					//update blink bar
					if(BlinkTimer > 1){
						BlinkGroup.members[0].makeGraphic(BlinkTimer*2, 8, 0xFFFFFFFF);
					}else{
						BlinkGroup.members[0].alpha = 0;
					}
				}
			}
			
			
			super.update();			
			FlxG.collide(ObjectGroup, TileGroup);
			PlayerGroup.members[0].AlignBoost();
		}
	}
}

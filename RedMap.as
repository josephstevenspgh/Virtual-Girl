package{
	import org.flixel.*;
	import flash.ui.Keyboard;
	import flash.events.Event;
	import flash.events.KeyboardEvent;

 
	public class RedMap extends VGMap{
		
		//Maps
		[Embed(source="Data/RedMapmap001.txm",					mimeType="application/octet-stream")] protected var RedMap_Data:Class;
		[Embed(source="Data/RedMap_Backgroundmap001.txm",		mimeType="application/octet-stream")] protected var RedMap_Background_Data:Class;
		
		[Embed(source="Data/RedMaptiles.png")] 					protected var RTiles:Class;
		[Embed(source="Data/RedMap_Backgroundtiles.png")] 		protected var RTiles_Background:Class;
		
		public function RedMap(NX:Number = -1, NY:Number = -1){
			InitX = NX;
			InitY = NY;
		}
		
		override protected function initGame():void{
			Stage = 1;
			//Musics
			FlxG.playMusic(IntroMusic);
		
			CURRENT_MAP	= 1;
		
			//Group Initialization
			BackgroundGroup	= new FlxGroup();
			TileGroup 		= new FlxGroup();
			PlayerGroup 	= new FlxGroup();
			EnemyGroup		= new FlxGroup();
			LifeGroup		= new FlxGroup();
			ItemGroup		= new FlxGroup();
			ObjectGroup		= new FlxGroup();
			LevelObjects	= new FlxGroup();
			
			//Load Map
			LevelTileMap	= new FlxTilemap();
			LevelTileMap.loadMap(new RedMap_Data, RTiles, 16, 16, 0, 0, 1, 30);
			
			
			//Fancy schmancy background :)
			var BackgroundTM:FlxTilemap;
			BackgroundTM = new FlxTilemap();
			BackgroundTM.loadMap(new RedMap_Background_Data, RTiles_Background, 16, 16, 0, 0, 1, 100);
			BackgroundTM.scrollFactor = new FlxPoint(0.5, 0.25);
			
			FlxG.worldBounds = LevelTileMap.getBounds();
			
			//Create Player
			if(InitX < 0){
				InitX = 784;
			}
			if(InitY < 0){
				InitY = 352;
			}
			Player = new QTPi(InitX, InitY);
			Player.Unlock();
			PlayerMaxLife = Player.getMaxLife();
			
			//create background
			var bd:FlxSprite = new FlxSprite();
			bd.loadGraphic(ImgRedBG, true, true, 400, 300);
			bd.scrollFactor = new FlxPoint(0.05, 0.05);
			BackgroundGroup.add(bd);
			
			var i:uint = 0;
			var j:uint = 0;
			
			//Level Objects
			//LevelObjects.add(new WaveBridge(704, 368, 8, Player));
			LevelObjects.add(new WaveBridge(576, 80, 18, Player));
			
			//Add Groups
			TileGroup.add(BackgroundTM);
			TileGroup.add(LevelTileMap);
			PlayerGroup.add(Player);
			PlayerGroup.add(Player.GroupSprites());
			PlayerGroup.add(Player.GroupBullets());
			ItemGroup.add(new OrbOfGoal(-1088, 80));
			ItemGroup.add(new DoubleJump(-80, 176));
			ItemGroup.add(new DoubleJump(-64, 64));
			
			//Heart Containers
			/*
			ItemGroup.add(new HeartContainer(736, 48));
			ItemGroup.add(new HeartContainer(32, 640));
			ItemGroup.add(new HeartContainer(256, 512));
			ItemGroup.add(new HeartContainer(1456, 528));
			*/
			
			//736 400
			
			//MOTHER FUCKIN LAVA
			
			//Go through, find all the lava tiles, make them pretty
			for(i = 0; i < LevelTileMap.widthInTiles; i++){
				for(j = 0; j < LevelTileMap.heightInTiles; j++){
					if(LevelTileMap.getTile(i, j) == 20){
						ItemGroup.add(new LavaTile(i*16, j*16));
					}
				}
			}
			
			/*
			EnemyGroup.add(new RedRobot(56, 328));
			EnemyGroup.add(new RedRobot(96, 552));
			EnemyGroup.add(new RedRobot(528, 728));
			EnemyGroup.add(new RedRobot(560, 536));
			EnemyGroup.add(new RedRobot(352, 312));
			EnemyGroup.add(new RedRobot(600, 120));
			EnemyGroup.add(new RedRobot(736, 344));
			EnemyGroup.add(new RedRobot(256, 504));*/
			
			//Object Group - all objects need to be on this
			ObjectGroup.add(EnemyGroup);
			ObjectGroup.add(PlayerGroup);
			TileGroup.add(LevelObjects);
			
			
			add(BackgroundGroup);
			add(TileGroup);
			add(LevelObjects);
			add(ItemGroup);
			add(EnemyGroup);
			add(PlayerGroup);
			add(LifeGroup);
			
			//Camera
//			FlxG.camera = new FlxCamera(0, 0, 640, 480);
			FlxG.camera.follow(Player, FlxCamera.STYLE_PLATFORMER);
			FlxG.camera.bounds = LevelTileMap.getBounds();
//			ShowIcons();
		}
		
		override protected function WarpDoor():void{
			switch(Entering){
				case 1:
					FlxG.switchState(new HubMap());
					break;
				case 2:
					FlxG.switchState(new TreasureRoom(1, new RedMap(PlayerGroup.members[0].x, PlayerGroup.members[0].y)));
					break;
				case 3:
					FlxG.switchState(new TreasureRoom(2, new RedMap(PlayerGroup.members[0].x, PlayerGroup.members[0].y)));
					break;
				case 4:
					FlxG.switchState(new TreasureRoom(3, new RedMap(PlayerGroup.members[0].x, PlayerGroup.members[0].y)));
					break;
				case 5:
					FlxG.switchState(new TreasureRoom(4, new RedMap(PlayerGroup.members[0].x, PlayerGroup.members[0].y)));
					break;
				case 6:
					FlxG.switchState(new TreasureRoom(101, new RedMap(PlayerGroup.members[0].x, PlayerGroup.members[0].y)));
					break;
				case 7:
					FlxG.switchState(new TreasureRoom(201, new RedMap(PlayerGroup.members[0].x, PlayerGroup.members[0].y)));
					break;
				case 8:
					FlxG.switchState(new TreasureRoom(301, new RedMap(PlayerGroup.members[0].x, PlayerGroup.members[0].y)));
					break;
			}
		}
		
		override protected function CheckDoors():void{
			//Exit Door	- 784  352
			//HC 1		- 736  64
			//HC 2		- 32   656
			//HC 3		- 240  528
			//HC 4		- 1088 288
			//Ability	- 80   192
			//CATS		- 1408 576
			//GOAL		- 1088 96
			if(DoorAt(784, 352)){
				//Exit the stage
				SetupDoorFadeout();
				Entering = 1;
			}else if(DoorAt(736, 64)){
				SetupDoorFadeout();
				Entering = 2;
			}else if(DoorAt(32, 656)){
				SetupDoorFadeout();
				Entering = 3;
			}else if(DoorAt(240, 528)){
				SetupDoorFadeout();
				Entering = 4;
			}else if(DoorAt(1088, 288)){
				SetupDoorFadeout();
				Entering = 5;
			}else if(DoorAt(80, 192)){
				SetupDoorFadeout();
				Entering = 6;
			}else if(DoorAt(1408, 576)){
				SetupDoorFadeout();
				Entering = 7;
			}else if(DoorAt(1088, 96)){
				SetupDoorFadeout();
				Entering = 8;
			}
		}
	}
}

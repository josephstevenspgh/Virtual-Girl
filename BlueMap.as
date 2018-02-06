package{
	import org.flixel.*;
	import flash.ui.Keyboard;
	import flash.events.Event;
	import flash.events.KeyboardEvent;

 
	public class BlueMap extends VGMap{
		//Variables and Etc
		[Embed(source="Data/BlueMapmap001.txm",		mimeType="application/octet-stream")] protected var RedMap_Data:Class;
		
		override protected function initGame():void{
			Stage = 3;
			//Musics
			FlxG.playMusic(IntroMusic);
		
			//Group Initialization
			BackgroundGroup	= new FlxGroup();
			TileGroup 		= new FlxGroup();
			PlayerGroup 	= new FlxGroup();
			EnemyGroup		= new FlxGroup();
			ItemGroup		= new FlxGroup();
			ObjectGroup		= new FlxGroup();
			
			//Load Map
			LevelTileMap	= new FlxTilemap();
			LevelTileMap.loadMap(new RedMap_Data, RedMap_Tiles, 16, 16, 0, 0, 1, 5);
			
			FlxG.worldBounds = LevelTileMap.getBounds();
			
			//Create Player
			Player = new QTPi(24, 24);
			Player.Unlock();
			
			//create background
			for(var i:uint = 0; i < (320/16); i++){
				for (var j:uint = 0; j < (240/16); j++){
					var ax:uint	= i*16;
					var ay:uint	= j*16;
					var a:FlxSprite = new FlxSprite(ax, ay);
					a.loadGraphic(ImgRedBG, true, true, 16, 16);
					a.addAnimation("Loopme", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15], 10, true);
					a.play("Loopme");
					a.angle = 90;
					a.scrollFactor = new FlxPoint(0, 0);
					BackgroundGroup.add(a);
				}
			}
			
			//Add Groups
			TileGroup.add(LevelTileMap);
			PlayerGroup.add(Player);
			ItemGroup.add(new OrbOfGoal(544, 480));
			ItemGroup.members[0].frame = 2;
			ItemGroup.add(new LiquidProof(448, 224));
			
			//Enemies
			EnemyGroup.add(new Bluebut(336, 64));
			EnemyGroup.add(new Bluebut(416, 96));
			EnemyGroup.add(new Bluebut(496, 64));
			EnemyGroup.add(new Bluebut(688, 80));
			EnemyGroup.add(new Bluebut(656, 272));
			EnemyGroup.add(new Bluebut(480, 240));
			EnemyGroup.add(new Bluebut(288, 288));
			EnemyGroup.add(new Bluebut(240, 304));
			EnemyGroup.add(new Bluebut(32, 246));
			EnemyGroup.add(new Bluebut(128, 400));
			EnemyGroup.add(new Bluebut(112, 576));
			EnemyGroup.add(new Bluebut(576, 576));
			EnemyGroup.add(new Bluebut(704, 512));
			EnemyGroup.add(new Bluebut(416, 400));
			
			//Object Group - all objects need to be on this
			ObjectGroup.add(EnemyGroup);
			ObjectGroup.add(PlayerGroup);
			
			add(BackgroundGroup);
			add(TileGroup);
			add(ItemGroup);
			add(EnemyGroup);
			add(PlayerGroup);
			
			//Camera
//			FlxG.camera = new FlxCamera(0, 0, 640, 480);
			FlxG.camera.follow(Player, FlxCamera.STYLE_PLATFORMER);
			FlxG.camera.bounds = LevelTileMap.getBounds();
			ShowIcons();
		}
	}
}

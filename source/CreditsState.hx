package;

import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class CreditsState extends MusicBeatState
{
  var curSelected:Int = 0;
  private var grpMembers:FlxTypedGroup<Alphabet>;

  var purpleTeam:Array<CreditsMetadata> = [];

	override function create()
	{
    var creditsTeam = CoolUtil.coolTextFile(Paths.txt('creditsChristrashings'));

    for (i in 0...creditsTeam.length)
    {
  	  var data:Array<String> = creditsTeam[i].split(':');
      purpleTeam.push(new CreditsMetadata(data[0], data[1], data[2]));
    }
		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Credits Silly!", null);
		#end

		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		var bg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('stageback'));
		bg.setGraphicSize(Std.int(bg.width * 1.05));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

    grpMembers = new FlxTypedGroup<Alphabet>();
		add(grpMembers);

    for (i in 0...purpleTeam.length)
		{
			var teamText:Alphabet = new Alphabet(0, (70 * i) + 30, purpleTeam[i].nameDev, true, false, true);
			teamText.isMenuItem = true;
			teamText.targetY = i;
			grpMembers.add(teamText);
    }

    var scoreText = new FlxText(FlxG.width * 0.7, 5, 0, purpleTeam[i].bioDev, 32);
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);

		var scoreBG:FlxSprite = new FlxSprite(scoreText.x - 6, 0).makeGraphic(Std.int(FlxG.width * 0.35), 66, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);
    
    add(scoreText);

    changeSelection();

    #if mobile addVPad(UP_DOWN, A_B); #end

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
    
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}
    
    if (controls.UP_P)
    {
      FlxG.sound.play(Paths.sound('scrollMenu'));
      changeSelection(-1);
    }

    if (controls.DOWN_P)
    {
      FlxG.sound.play(Paths.sound('scrollMenu'));
      changeSelection(1);
    }

    if (controls.BACK)
    {
      FlxG.switchState(new MainMenuState());
    }
    
    if (controls.ACCEPT)
    {
      fancyOpenURL("https://" + purpleTeam[i].youtubeLinks);
    }
	}

  function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = purpleTeam.length - 1;
		if (curSelected >= purpleTeam.length)
			curSelected = 0;
		
		var bullShit:Int = 0;

		for (item in grpMembers.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			if (item.targetY == 0)
			{
				item.alpha = 1;
			}
		}
	}
}

class CreditsMetadata
{
	public var nameDev:String = "";
	public var youtubeLinks:String = "";
	public var bioDev:String = "";

	public function new(name:String, youtube:String, bio:String)
	{
		this.nameDev = name;
		this.youtubeLinks = youtube;
		this.bioDev = bio;
  }
}
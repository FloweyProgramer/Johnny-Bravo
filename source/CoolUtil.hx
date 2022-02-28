package;

import lime.utils.Assets;
import sys.io.Process;

using StringTools;

class CoolUtil
{
	public static var difficultyArray:Array<String> = ['Easy', "Normal", "Hard"];

	public static var programList:Array<String> = [ //ddlc this was clever code
		'obs32',
		'obs64',
		'streamlabs obs', // shitter program
		'bdcam',
		'fraps',
		'xsplit', // TIL c# program
		'hycam2', // hueh
		'twitchstudio' // why
	];

	public static function difficultyFromInt(difficulty:Int):String
	{
		return difficultyArray[difficulty];
	}

	public static function isRecording():Bool
		{
			#if FEATURE_OBS
			var taskList:Process = new Process('tasklist', []);
			var readableList:String = taskList.stdout.readAll().toString().toLowerCase();
			var isOBS:Bool = false;
	
			for (i in 0...programList.length)
			{
				if (readableList.contains(programList[i]))
					isOBS = true;
			}
	
			taskList.close();
			readableList = '';
	
			return isOBS;
			#else
			return false;
			#end
		}

	public static function coolTextFile(path:String):Array<String>
	{
		var daList:Array<String> = Assets.getText(path).trim().split('\n');

		for (i in 0...daList.length)
		{
			daList[i] = daList[i].trim();
		}

		return daList;
	}
	
	public static function coolStringFile(path:String):Array<String>
		{
			var daList:Array<String> = path.trim().split('\n');
	
			for (i in 0...daList.length)
			{
				daList[i] = daList[i].trim();
			}
	
			return daList;
		}

	public static function numberArray(max:Int, ?min = 0):Array<Int>
	{
		var dumbArray:Array<Int> = [];
		for (i in min...max)
		{
			dumbArray.push(i);
		}
		return dumbArray;
	}
}

How Do I Use VScript?
	1) Watch this tutorial by TopHattWaffle on How to Use VScript:
		https://www.youtube.com/watch?v=p05bQ8ds8-w
	2) Come over to the TF2Maps Discord to ask questions, too! Beginners welcome.

How to Use This Script in Your Maps
	1) Make sure to place the folder give_tf_weapon and all containing files in directory `/tf/scripts/vscripts/`
	   It should look like `/tf/scripts/vscripts/give_tf_weapon/` with all the files in that directory.
	2) Then to execute this script in a map, make an entity with "vscripts" keyvalue, and place `give_tf_weapon/_master` as the parameter.
	3) Run the map, then it should automatically execute.

	x) Alternatively, you can test it in any map through console by typing `script_execute give_tf_weapon/_master`

How to Give Yourself a Weapon (in console)
	1) After executing the script, you should be able to send out a console command to communicate with the script.
	2) Send this through the console:

		script GetListenServerHost().GiveWeapon("My Weapon Here")

	3) It accepts any weapon names. Caps sensitive. Don't include "The" in the name--It won't accept that.
	4) It accepts item IDs, too.
	5) You can also give yourself the example custom weapons:

		script GetListenServerHost().GiveWeapon("Medieval Crossbow")
		script GetListenServerHost().GiveWeapon("Horsemann's Hex")
		script GetListenServerHost().GiveWeapon("Hottest Hand")

	Notes:
	 - GetListenServerHost() is the person hosting the server.
	 - If you wanted to give another player a weapon, it must be a handle you make through the script.
	 - Use the `zz_examples.nut` in the /give_tf_weapon/ folder for more examples on how to do this.


Have fun, modders!
Signed:
 - Yaki
 - 10 Dec 22
		
depth = -1;

hsp = 0;
vsp = 0;

temphsp = 0;
tempvsp = 0;

templimit = 25;

bigbounce = 25;
smallbounce = 15;

flyspd = 10;
movespd = 13;

updown = 0;
leftright = 0;

//Right = 1, Left = -1
direct = 1;

shooting = false;
windMax = 300;
windPower = windMax;
recharge = false;
refillWind = false;

player_health = 3;
dead = false;
immune = false;
death_timer = 0;

//Gamepad Variables
usingGamepad = false;
connectedSlot = 0;
gp_num = gamepad_get_device_count();

if(instance_exists(obj_checkpoint_control))
{
	if(obj_checkpoint_control.checked)
	{
		x = obj_checkpoint_control.xvalue;
		y = obj_checkpoint_control.yvalue;
	}
}
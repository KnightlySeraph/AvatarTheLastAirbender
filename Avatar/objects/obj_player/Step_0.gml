//Controller Check
if (keyboard_check_pressed(ord("C"))){
		for (var i = 0; i < gp_num; i++){
			if (gamepad_is_connected(i)) {
				show_message("Gamepad Connect to slot " + string(i));
				usingGamepad = true;
				connectedSlot = i;
				gamepad_set_axis_deadzone(i, 0.05);
				break;
			}
		}
}
if (usingGamepad){
	haxis = gamepad_axis_value(connectedSlot, gp_axislh);
	vaxis = gamepad_axis_value(connectedSlot, gp_axislv);
	if (gamepad_button_check_pressed(connectedSlot, gp_face4)){
		show_debug_message("vaxis is: " + string(vaxis) + "   haxis is: " + string(haxis));	
	}
}
//End Controller Check -- Justin

updown = 0;
leftright = 0;

if(player_health <= 0 && !dead)
{
	shooting = false;
	dead = true;
	obj_camera.follow = noone;
}
else
{
	//Controller Inputs
	if (usingGamepad){
		if(vaxis < -0.05) {
			//Move Up
			updown -= 1;
			if(tempvsp > -templimit) tempvsp -= 1;
		}
		if(haxis < -0.05) {
			//Move Left
			leftright -= 1; 
			if(temphsp > -templimit) temphsp -= 1;
		}
		if(vaxis > 0.05){
			//Move Down
			updown += 1; 
			if(tempvsp < templimit) tempvsp += 2;
		}
		if(haxis > 0.05) {
			//Move Right
			leftright += 1; 
			if(temphsp < templimit) temphsp += 1;
		}
		if(gamepad_button_check(connectedSlot, gp_face3) && !recharge && windPower > 0){
			show_debug_message("Sqaure Pressed");
			shooting = true;
		}
		else {
			shooting = false;
		}
	}
	//End --Justin
	else { //Not Using Gamepad -- Justin
		if(keyboard_check(ord("W"))) 
		{
			//Move Up
			updown -= 1;
			if(tempvsp > -templimit) tempvsp -= 1;
		}
		if(keyboard_check(ord("A"))) 
		{
			//Move Left
			leftright -= 1; 
			if(temphsp > -templimit) temphsp -= 1;
		}
		if(keyboard_check(ord("S")))
		{
			//Move Down
			updown += 1; 
			if(tempvsp < templimit) tempvsp += 2;
		}
		if(keyboard_check(ord("D"))) 
		{
			//Move Right
			leftright += 1; 
			if(temphsp < templimit) temphsp += 1;
		}

		if(keyboard_check(vk_enter) && !recharge && windPower > 0) shooting = true;
		else shooting = false;	
	}
}


//HSP is equal to the speed plus the temp hsp
hsp = ((leftright * movespd) + temphsp);
//If hsp is more than 15, make it 15 and decrease temp hsp
if(abs(hsp) > templimit) 
{
	hsp = sign(hsp) * templimit;
	temphsp -= 0.5 * sign(temphsp);
	
}
//VSP is equal to the speed plus the temp vsp
vsp = ((updown * flyspd) + tempvsp);
//If vsp is more than 15, make it 15 and decrease temp vsp
if(abs(vsp) > templimit) 
{
	vsp = sign(vsp) * templimit;
	tempvsp -= 0.5 * sign(tempvsp);
}

//Decrease temp vsp and hsp if not 0
if(tempvsp != 0)
{
	tempvsp -= 0.5 * sign(tempvsp);	
}
if(temphsp != 0)
{
	temphsp -= 0.5 * sign(temphsp);	
}

//Check if colliding with walls on left or right
if(!dead)
{
	if(place_meeting(x+hsp, y, obj_wall))
	{
		while(!place_meeting(x+sign(hsp), y, obj_wall))
		{
			x += sign(hsp);	
		}
		//If moving left or right, big bounce
		if(leftright != 0) temphsp = bigbounce * -sign(hsp);
		//Else, small bounce
		else temphsp = smallbounce * -sign(hsp);

		hsp = 0;
	}
	//Check if colliding with walls up or down
	if(place_meeting(x, y + vsp, obj_wall))
	{
		while(!place_meeting(x, y+sign(vsp), obj_wall))
		{
			y += sign(vsp);	
		}
		//IF moving up or down, big bounce
		if(updown != 0) tempvsp = bigbounce * -sign(vsp);
		//Else, small bounce
		else tempvsp = smallbounce * -sign(vsp);

		vsp = 0;
	}
}

//SHOOTING
if(shooting)
{
	if(!instance_exists(obj_wind))
	{
		if(direct > 0)
		{
			instance_create_depth(x+80,y-30,depth,obj_wind);
		}
		else
		{
			with(instance_create_depth(x-80,y-30,depth,obj_wind))
			{
				image_xscale = -1;	
			}
		}
	}
	temphsp += -direct * 1;
	windPower -= 2;
	if(windPower <= 0)
	{
		recharge = true;	
	}
	alarm[0] = 30;
	refillWind = false;
}
else
{
	if(instance_exists(obj_wind))
	{
		instance_destroy(obj_wind);	
	}
	if(refillWind)
	{
		if(windPower < windMax)
		{
			windPower += 2;
			if(windPower >= windMax / 2)
			{
				recharge = false;	
			}
		}
		else
		{
			recharge = false;	
			refillWind = false;
		}
	}
}



//Move player
x += hsp;
y += vsp;

//Sprite Machine
if(leftright > 0)
{
	image_xscale = 1;	
	direct = 1;
}
else if(leftright < 0)
{
	image_xscale = -1;
	direct = -1;
}

if(place_meeting(x,y,obj_projectile) && !immune)
{
	immune = true;
	player_health -= 1;
	alarm[1] = 30;
}
if(place_meeting(x,y,obj_frog_big_damage) && !immune)
{
	immune = true;
	player_health -= 1;
	alarm[1] = 30;
}


if(dead)
{
	sprite_index = spr_player_dead;	
	tempvsp += tempvsp + 1;
	temphsp -= direct * 1;
	death_timer += 1;
	if(death_timer > 38)
	{
		instance_activate_object(obj_menu_deathscreen);
	}
}
else if(shooting)
{
	if(!audio_is_playing(snd_wind))
	{
		audio_play_sound(snd_wind,0,true);	
	}
	if(leftright != 0)
	{
		sprite_index = spr_player_shoot_move;
	}
	else if(updown < 0)
	{
		sprite_index = spr_player_shoot_up;	
	}
	else if(updown > 0)
	{
		sprite_index = spr_player_shoot_down;	
	}
	else
	{
		sprite_index = spr_player_shoot;	
	}
}
else
{
	audio_stop_sound(snd_wind);
	if(leftright != 0)
	{
		sprite_index = spr_player_move;
	}
	else if(updown < 0)
	{
		sprite_index = spr_player_move_up;	
	}
	else if(updown > 0)
	{
		sprite_index = spr_player_move_down;	
	}
	else
	{
		sprite_index = spr_player_idle;	
	}
}

if(dead)
{
	audio_stop_sound(snd_wind);
	if(!audio_is_playing(snd_whoosh))
	{
		audio_play_sound(snd_whoosh, 0, false);	
	}
}
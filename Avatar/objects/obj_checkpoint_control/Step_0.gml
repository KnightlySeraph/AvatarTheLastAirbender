if(room == rm_menu_main)
{
	checked = false;
	roomvalue = Level1;
	
}
else if(room == Level1 || room == Level2 || room == TheFrogFather)
{
	roomvalue = room;	
}

if(!checked)
{
	xvalue = 0;
	yvalue = 0;
}


integer Loaded;
integer BackingUp;
integer SwimDamp = TRUE;
integer BackTog = TRUE;
integer LagComp = TRUE;
integer CurNoteLine;
integer heldany;
integer warned;
//integer ALLCONTROL; is 831
integer rundir;
integer heldlevel;
integer heldedge;
integer sequentialstands;
integer LastAgentInfo;
string MenuContext;
integer ListenID;//swimming and egging//what was egging
integer ListenIDSub;//recycling response
//integer ListenIDSub2;//sitrespons
integer Wet;
integer lastwaterindex;
integer pageindex;
integer AOEcho = -983127;
integer magicnum = -19;
integer hottimer;
integer stunlock;//prejump jank
integer cooldown;
float ControlType;//standing is the only animation that needs to cycle
integer laststandindex;
integer totalanims;

float internaltimer = 0.5;
float hottimerduration = 0.1;
float standduration;
string currentnotecard;
string waterexitsound = "33a8d7dd-84d9-1fa9-8ee7-55d6780027ab";
string buttonsound = "b87173a6-cb8c-5c4f-9155-e5c6b9451e18";
string splashheavy = "4b624f8a-1ab7-118d-cd6f-b7150b7905e6";
string splashlight = "33a8d7dd-84d9-1fa9-8ee7-55d6780027ab";
key Owner;
key NotecardRequestID;

vector PersSwimTPos;
//current anims in memory
string FlyLeft;
string FlyRight;
string RunLeft;
string RunRight;

string AwayAnim;
string BusyAnim;
string TypingAnim;
string BackupAnim;
string DeformerAnim;

string SwimUp;      
string SwimForward;
string SwimIdle;
string SwimFast;
string SwimDown;
string SwimSurf;
string SeaWalk;
string SeaRun;

string manualground;
string manualsit;
string manualwalk;
string manualstand;

string realdirtydecrypter(string in)
{//special crypter
    in = llDeleteSubString(in, 0, llStringLength("nemomalusfelix")-1);
    string magic = llStringToBase64( llGetDate()+"♥diguioeh@mafij./cdwf♥"+in);

    return llBase64ToString(llXorBase64(in,magic));
}//used for water
float min(float in,float in2)
{
    if(in < in2) return in;
    else return in2;
}
RandomUpdateOverrideAll()
{
    string deformer = "tpose bonetrans";
    
    if(DeformerAnim) deformer = DeformerAnim;
    
    llStopAnimation(deformer);
    llStartAnimation(deformer);
    
    if(!Loaded) return;
    
    cooldown = 10;
    //cyclestand();
    {
        list Data = parselinksetdata("Standing");
        //llOwnerSay((string)Data);
        //if(llGetListLength(Data) > 1)
        //    Data = llDeleteSubList(Data, 0,0);
        
        integer standcount = llGetListLength(Data);
        string pendingstand = manualstand;
        integer pendingstandindex;
        //llOwnerSay((string)standcount);
        
        if(pendingstand == "")
        {
            if(!sequentialstands && standcount > 1)
            {//get a random index number
                pendingstandindex = llRound(llFrand(standcount-1));
                
                if(laststandindex == pendingstandindex)
                {
                    if(pendingstandindex==0) pendingstandindex++;
                    else pendingstandindex--;
                }
            }
            else if(standcount > 1)
            {
                pendingstandindex = laststandindex+1;
                if(pendingstandindex >= standcount)
                    pendingstandindex = 0;
            }
            //llOwnerSay(llList2String(Data,pendingstandindex) + "idneinx");
            list StandData = llParseString2List(llList2String(Data,pendingstandindex),["-"],[]);
            pendingstand = llStringTrim(llList2String(StandData,0),STRING_TRIM);
            //llOwnerSay((string)pendingstandindex);
            
            if(ControlType != 0)
            {//sets cycle stand times
                float bufferduration = llList2Float(StandData,1);//manual duration takes priority
                
                if(bufferduration) standduration = bufferduration;
                else standduration = ControlType;//use default cycle timer otherwise
            }
            
            laststandindex = pendingstandindex;
        }
    
        handleanim("Standing", [], pendingstand);
    }
    
    list allkeys = llLinksetDataListKeys( 0, 0 );
    integer i = llGetListLength(allkeys);
    
    while(i--)
    {
        
        string Current = llList2String(allkeys,i);//llStringTrim(llList2String(Data,0),STRING_TRIM); //type of override
        list Data = parselinksetdata(Current);

        if(Data != [] && Current != "Standing")
        {
            Data = llListRandomize(Data, 1);//random order
            
            if(Current != "")
                llLinksetDataWrite( Current , llDumpList2String(Data,"|"));//makes order memorized
            
            
            string Anim = llStringTrim(llList2String(Data,0),STRING_TRIM);
            
            if(llGetInventoryType(Anim) == INVENTORY_ANIMATION)
            {
                if(Current == "Away") AwayAnim = Anim;
                else if(Current == "Busy") BusyAnim = Anim;
                else if(Current == "Typing") TypingAnim = Anim;
                else if(Current == "Walking Backward") BackupAnim = Anim;

                else if(Current == "Flying Left") FlyLeft = Anim;
                else if(Current == "Flying Right") FlyRight = Anim;

                else if(Current == "Running Left") RunLeft = Anim;
                else if(Current == "Running Right") RunRight = Anim;
                
                else if(Current == "Swimming Up") ;//SwimUp = Anim;//just here to skip it
                else if(Current == "Swimming Surface") ;//SwimSurf = Anim;
                else if(Current == "Swimming Idle") ;//SwimIdle = Anim;
                else if(Current == "Swimming Forward") ;//SwimFor = Anim;
                else if(Current == "Swimming Down") ;//BackupAnim = Anim;
                else if(Current == "Swimming Fast") ;//BackupAnim = Anim;
                
                else if(Current == "Sea Walk") ;//BackupAnim = Anim;
                else if(Current == "Sea Run") ;//BackupAnim = Anim;
                
                else if(Current == "Deformer") DeformerAnim = Anim;//BackupAnim = Anim;
                
                else
                {
                    if(Current == "Sitting on Ground" && manualground != "") Anim = manualground;
                    else if(Current == "Sitting" && manualsit != "") Anim = manualsit;
                    else if(Current == "Walking" && manualwalk != "") Anim = manualwalk;//idles handled elsewher
                    
                    handleanim(Current, [], Anim);
                }
            }
            else if(Anim != "" && !warned)
            {
                llOwnerSay("Missing animation : "+Current+"|"+Anim);
            }
        }
    }
    
    
    llRegionSayTo(Owner,AOEcho,"AO|replayanims");
    echoqueue = "";
    echoanim();
}
/*
cyclestand()
{
    list Data = parselinksetdata("Standing");
    //llOwnerSay((string)Data);
    if(llGetListLength(Data) > 1)
        Data = llDeleteSubList(Data, 0,0);
    
    integer standcount = llGetListLength(Data);
    string pendingstand = manualstand;
    integer pendingstandindex;
    
    if(pendingstand == "")
    {
        if(!sequentialstands && standcount > 1)
        {//get a random index number
            pendingstandindex = llRound(llFrand(standcount-1));
            
            if(laststandindex == pendingstandindex)
            {
                if(pendingstandindex==0) pendingstandindex++;
                else pendingstandindex--;
            }
        }
        else if(standcount > 1)
        {
            pendingstandindex = laststandindex+1;
            if(pendingstandindex >= standcount)
                pendingstandindex = 0;
        }
        //llOwnerSay(llList2String(Data,pendingstandindex) + "idneinx");
        list StandData = llParseString2List(llList2String(Data,pendingstandindex),["-"],[]);
        pendingstand = llStringTrim(llList2String(StandData,0),STRING_TRIM);
        //llOwnerSay((string)pendingstandindex);
        
        if(ControlType != 0)
        {//sets cycle stand times
            float bufferduration = llList2Float(StandData,1);//manual duration takes priority
            
            if(bufferduration) standduration = bufferduration;
            else standduration = ControlType;//use default cycle timer otherwise
        }
        
        laststandindex = pendingstandindex;
    }

    handleanim("Standing", [], pendingstand);
}
*/
string lastanimecho;
string echoqueue;
handleanim(string anim, list tostop,string type)
{//can aalso override
    if(llGetOwner() != Owner) llResetScript();
//    if(!(llGetPermissions() & PERMISSION_TRIGGER_ANIMATION)) 
//        return;
        
    if(type != "")
    {
//        llOwnerSay(anim);
        llSetAnimationOverride(anim,type);//reversed, anim is actually type
        return;//doesn't stop anims if using override, also saves an else indent
    }
    else if(anim != "") 
    {
        if(anim != lastanimecho) echoqueue = anim;

        llStartAnimation(anim);
        
        llSetTimerEvent(0.01);//immediately queue change
    }
 
    integer count = llGetListLength(tostop);
    while(count--)
    {
        string stopping = llList2String(tostop,count);
        if(stopping != "") llStopAnimation(stopping);
        if(stopping == echoqueue) echoqueue = "";
        //llOwnerSay(stopping);
    }
    echoanim();
}
/*//somehow takes 1000 memory
string indexfromlist(list input,integer index)
{
    if(index == -1)
        index = llRound(llFrand(llGetListLength(input)-1));
    
    return llList2String(input,index);
}
*/
exitwater(string reason)
{
    llStopMoveToTarget();
    llSetBuoyancy(0);

    if(reason == "resetonly")
    {//hard vars
        knownWater = [];
    }
    else if(Wet)
    {//was in water
        llPlaySound(waterexitsound,0.5);
        Wet = 0;
        heldany = 0;
        PersSwimTPos = ZERO_VECTOR;
        
        //handleanim("Walking",[],SeaWalk);
        //handleanim("Running",[],SeaRun);
        //string SeaWalk = llList2String(parselinksetdata("Sea Walk"),0);//only called now
        //string SeaRun = llList2String(parselinksetdata("Sea Run"),0);
        
        handleanim("Falling Down",[],llList2String(parselinksetdata("Falling Down"),0));
        handleanim("Flying",[],llList2String(parselinksetdata("Flying"),0));
        handleanim("FlyingSlow",[],llList2String(parselinksetdata("FlyingSlow"),0));
        handleanim("Hovering",[],llList2String(parselinksetdata("Hovering"),0));
        handleanim("Hovering Down",[],llList2String(parselinksetdata("Hovering Down"),0));
        handleanim("Hovering Up",[], llList2String(parselinksetdata("Hovering Up"),0) );
        handleanim("Jumping",[],llList2String(parselinksetdata("Jumping"),0));
        handleanim("Running",[],llList2String(parselinksetdata("Running"),0));
        handleanim("Walking",[],llList2String(parselinksetdata("Walking"),0));//could maybe make this random? but will involve getting 

        
        handleanim("",[SwimForward,SwimSurf,SwimUp,SwimDown,SwimFast,SeaRun,SeaWalk], "");
        
        
        //check if we dove back in
        llSetTimerEvent(hottimerduration);
        hottimer = 55;
        if(rundir == 2) rundir = 0;
    }
    RandomUpdateOverrideAll();
    //InitOverride(1); 
}
init() 
{
    Loaded = 0;
    //SuperList = [];
    CurNoteLine = 0;
    
    if(currentnotecard == "") currentnotecard = llGetInventoryName(INVENTORY_NOTECARD,0);
    
    totalanims = llGetInventoryNumber(INVENTORY_ANIMATION);//checks if anims were updated or not
    /*
    ALLCONTROL = CONTROL_FWD | CONTROL_BACK
                            | CONTROL_LEFT | CONTROL_RIGHT | CONTROL_UP | CONTROL_DOWN | CONTROL_ROT_LEFT | CONTROL_ROT_RIGHT;
                            */
    //its just 831
    
    Owner = llGetOwner();

    ListenID = llListen(magicnum, "", NULL_KEY, ""); //swimming and egging//what was egging
    ListenIDSub = llListen(magicnum+1, "", Owner, "");     
//    ListenIDSub2 = llListen(magicnum+2, "", Owner, "");   
    
    
    llListenControl(ListenIDSub,FALSE);    
//    llListenControl(ListenIDSub2,FALSE);    
 
    
    llRequestPermissions(Owner, PERMISSION_TRIGGER_ANIMATION | PERMISSION_OVERRIDE_ANIMATIONS | PERMISSION_TAKE_CONTROLS);
    llSetTimerEvent(internaltimer);
    llResetTime();
    
    string deformer = "tpose bonetrans";
    list anims = llGetAnimationList(Owner);
    
    if(DeformerAnim) deformer = DeformerAnim;
    
    llStopAnimation(deformer);
    handleanim(deformer, anims, "");
    
    LastAgentInfo = LastAgentInfo|AGENT_TYPING|AGENT_AWAY|AGENT_FLYING|AGENT_BUSY;//force updates
}
deinit()
{
    lastanimecho = "";
    Wet = 0;
    llReleaseControls();
    llSetTimerEvent(0);

    if(llGetOwner() != Owner) 
        llResetScript();
//    if(llGetPermissions() & PERMISSION_OVERRIDE_ANIMATIONS)
    {//double check incase the owner or something messes up
        llResetAnimationOverride("ALL");
        list anims = llGetAnimationList(Owner);
        llOwnerSay("Stopping "+(string)llGetListLength(anims)+" animations.");
        handleanim("bone surgery", anims, "");//bone surgery
    }


    exitwater("resetonly");
    //handleanim("",[TypingAnim,AwayAnim,BusyAnim],"");
}
InitOverride(integer keep)
{
    totalanims = llGetInventoryNumber(INVENTORY_ANIMATION);
    CurNoteLine = 0;
    Loaded = 0;
    warned = 0;
    //SuperList = [];
    
    if(!keep)
    {//resets and cleans anims
        
        llOwnerSay("Loading animations...");
        llLinksetDataReset();
        llResetAnimationOverride("ALL");
        list anims = llGetAnimationList(Owner);
        
        string deformer = "tpose bonetrans";
        
        if(DeformerAnim) deformer = DeformerAnim;
        
        llStopAnimation(deformer);
        llStartAnimation(deformer);
        //handleanim("tpose bonetrans",[],"");
        AwayAnim = "";
        BusyAnim = "";
        TypingAnim = "";
        BackupAnim = "";
        FlyLeft = "";
        FlyRight = "";
    
        RunLeft = "";
        RunRight = "";
                    
        DeformerAnim = "";
    }
    
    //RandomUpdateOverrideAll();


    NotecardRequestID = llGetNotecardLine(currentnotecard,0);
    //garbage collection is not run during this
    //string input = llGetNotecardLineSync(currentnotecard,0);
    //key cachingevent = llGetNumberOfNotecardLines(currentnotecard);
    integer attempts;

}

list parselinksetdata(string item)
{//returns a list with checking and parsing
    string data = llLinksetDataRead(item);
    list output = llParseString2List(data,["|"],[]);
    
    if(llList2String(output,0) == " ") output = [""];//prevents a element 1 returning elemnt 0
    return output;
}

handletouchstart(integer link, integer face)
{
    if(link == 1)
    {//handle hiding
        vector RootScale = llGetScale();
        float ScaleMult = RootScale.y/0.07381;

        llPlaySound(buttonsound,1);
        list LinkInfo = llGetLinkPrimitiveParams(3,[PRIM_SIZE,PRIM_POS_LOCAL]);
                
        float Pos = -0.15594;
        float Scale = 0.34660;
                
        vector CurScale = llList2Vector(LinkInfo,0);    
        vector CurPos = llList2Vector(LinkInfo,1); 
        list params;
        integer link3alpha;
                
        if(CurScale.y <= 0.01)
        {//unhide
            CurPos = CurPos-<0,-Pos*ScaleMult*0.8,0>;
            CurScale = <CurScale.x,Scale*ScaleMult,CurScale.z>;
            link3alpha = 1;
                
            params = [PRIM_POS_LOCAL,<0.00000, -0.349981, -0.00124>*ScaleMult,
                            PRIM_LINK_TARGET,3,PRIM_ROTATION,<-1,1,1,1>,PRIM_POS_LOCAL,CurPos,PRIM_SIZE,CurScale];
        }
        else
        {//hide
            CurPos = CurPos-<0,Pos*ScaleMult*0.8,0>;
            CurScale = <CurScale.x,0,CurScale.z>;
            link3alpha = 0;
            
            params = [PRIM_POS_LOCAL,<0.00000, -0.032788, 0.31339>*ScaleMult,
                            PRIM_LINK_TARGET,3,PRIM_ROTATION,<-1,-1,1,1>,PRIM_POS_LOCAL,CurPos,PRIM_SIZE,CurScale];
        }
                
        llSetLinkAlpha(3,link3alpha,ALL_SIDES);
        llSetAlpha(!link3alpha,1);
        llSetLinkPrimitiveParamsFast(2,params);
    }
    else
        colorbutton(link,face);//handle actions
}
colorbutton(integer link,integer face)
{
    llPlaySound(buttonsound,1);
    list LinkInfo = llGetLinkPrimitiveParams(link,[PRIM_COLOR, face]);
    vector color = llList2Vector(LinkInfo,0);
    
    
    if(link == 3)//a double check
    {//all the buttons here
        string reply;
        vector applycolor;
        float condition;
        list dialogbuttons;
        string dialog;
    
        if(color == <0.25,0.25,0.25>)
        {
            if(face == 3) {applycolor = <1,1,0>; condition = 0.5;}
            else {applycolor = <1,1,1>;condition = 1;}
        }
        else if(color == <1,1,0>) {applycolor = <1,1,1>;condition = 1;}
        else {applycolor = <0.25,0.25,0.25>;condition = 0;}
        
        if(face == 0)
        {//power
            if(condition) {init();RandomUpdateOverrideAll();}
            else deinit();
        }
        else if(face == 1)
            return;//the background
        else if(face == 2)
        {//cycle
            applycolor = <1,1,1>;
            dialog = "'Update' updates your current animation set. 'Cycling' sets how the animations are cycled (default 0)";
            dialogbuttons = ["Update","Cycling"];
            
        }        
        else if(face == 3)
        {//reverse
            BackTog = llCeil(condition);
            LagComp = llFloor(condition);
            
            if(LagComp) reply = "Lag compensation is on.";
            else reply = "Toggling reverse animations";
        }
        else if(face == 4)
        {//swim
            SwimDamp = llCeil(condition);
            if(!SwimDamp) exitwater("resetonly");
        }
        else if(face == 5)//menu gear
        {//gear
            applycolor = <1,1,1>;
            dialog = "Control which animation is played when you sit down, or your idle time cycling.";
            dialogbuttons = ["Ground Sits","Sit On Object","Idles","Sequence Stands","Cycling","Internal Timer","Load Notecard"];       
        }
        
        llSetLinkColor(link, applycolor, face);
                    
        if(reply) llOwnerSay(reply);
        
        if(dialog) 
        {
            MenuContext = "Main";
            integer buttonamount = llGetListLength(dialogbuttons);
            if(buttonamount >= 10) dialogbuttons = llList2List(dialogbuttons,0,10);
            
            llListenControl(ListenIDSub,TRUE);
            llDialog(Owner,dialog,dialogbuttons,magicnum+1);
        }
    }
}
sendpage(integer start)
{
    llListenControl(ListenIDSub,TRUE); // to make it more responsive
    
    list output;
    integer index;
    start = start*6;
    list filtereditems;
    
    integer totalitems = llGetInventoryNumber(INVENTORY_NOTECARD);
    list items;
            
    while(totalitems--)
    {
        items += [llGetInventoryName(INVENTORY_NOTECARD,totalitems)];
    }
    totalitems = llGetListLength(items);
    
    while(totalitems--)
    {
        string name = llList2String(items,totalitems);
        
        if(~llSubStringIndex(name,"Animation Config:"))
            name = llStringTrim(llGetSubString(name,17,-1),STRING_TRIM);
        else if(llStringLength(name) > 24)
            llOwnerSay("Warning, " + name + " may be too long to fit into the dialog box.");
            
        filtereditems += name;
    }
    
    while(index<6)
    {
        string pendingname = llList2String(filtereditems,start+index);//llGetInventoryName(INVENTORY_ANIMATION,start+index);
        pendingname = llGetSubString(pendingname,0,20);//trims the name to fit, max is 24
        
        if(pendingname == "")// no entry but still fill the button
            pendingname = " ";
        output += pendingname;
        index++;
    }    
    
    llDialog(Owner, "Select a Notecard. Page "+(string)pageindex, output+["🡸","CLOSE","🡺"], magicnum+1);
}
/*
processlisten(integer Chan, string Mess)
{
    integer forcelisten;
    list dialogbuttons;
    string dialog;
    string textbox;
    string feedback;
    
    Mess = llStringTrim(Mess,STRING_TRIM);

    if(Chan == magicnum+1)
    {
        integer preservecontext;
        
        if(Mess == "Cycling")
        {
            textbox = "\nEnter how often you want to randomize the animation set. \n\nSet to 0 to do it when you stop moving.";
        }
        else if(Mess == "Update")
            InitOverride(0);
        else if(Mess == "🡸")
        {
            integer pagecount = llFloor(llGetInventoryNumber(INVENTORY_NOTECARD)/6);
                    
            pageindex--;
            if(pageindex<0) pageindex = pagecount;
                    
            sendpage(pageindex);
            forcelisten = 1;
            preservecontext = 1;
        }
        else if(Mess == "🡺")
        {
            integer pagecount = llFloor(llGetInventoryNumber(INVENTORY_NOTECARD)/6);
                    
            pageindex++;
            if(pageindex>pagecount) pageindex = 0;
                    
            sendpage(pageindex);
            forcelisten = 1;
            preservecontext = 1;
        }
        else if(Mess == "CLOSE")
        {
            preservecontext = 1;
        }
        else if(Mess == "Sit On Object")
        {
            list SitList = parselinksetdata("Sitting");
            
            dialog = "Control which animation is played when you sit down.";
            dialogbuttons = ["Random Sit obj"]+SitList;
        }
        else if(Mess == "Load Notecard")
        {
            sendpage(pageindex);
            forcelisten = 1;
        }
        else if(Mess == "Ground Sits")
        {
            list GroundSitList = parselinksetdata("Sitting on Ground");

            dialog = "Control which animation is played when you sit down on the ground.";
            dialogbuttons = ["Random Sit grd"]+GroundSitList;
        }
        else if(Mess == "Idles")
        {
            list StandList = parselinksetdata("Standing");

            dialog = "Control which animation is played when you stand around.";
            dialogbuttons = ["Random Idle"]+StandList;
        }
        else if(Mess == "Walks")
        {
            list WalkList = parselinksetdata("Walking");

            dialog = "Control which animation is played when you walk around.";
            dialogbuttons = ["Random Walk"]+WalkList;
        }//button selects end--------------------------
        else if(Mess == "Random Sit grd")
        {
            manualground = "";
            feedback = "Ground sits are now randomized";
        }
        else if(Mess == "Random Sit obj")
        {
            manualsit = "";
            feedback = "Object sits are now randomized";
        }
        else if(Mess == "Random Idle")
        {
            manualstand = "";
            feedback = "Idles are now randomized";
        }
        else if(Mess == "Random Walk")
        {
            manualwalk = "";
            feedback = "Walks are now randomized";
        }
        else if(Mess == "Internal Timer")
        {
            textbox = "\nEnter the approximate time inbetween timer events.";
        }
        else if(Mess == "Sequence Stands")
        {
            sequentialstands = !sequentialstands;
            
            if(sequentialstands) feedback = "Stands are now sequential, going through the order in the notecard.";
            else feedback = "Stands are now randomized.";
            
            RandomUpdateOverrideAll();
        }
        else
        {//selected a thing//TEST THIS FINISH THIS
            if(MenuContext == "Load Notecard")
            {
                if(llGetInventoryType(Mess) != INVENTORY_NOTECARD) Mess = "Animation Config: "+Mess;
                if(llGetInventoryType(Mess) != INVENTORY_NOTECARD) Mess = "Animation Config:"+Mess; // incase it has no spaces
                feedback = "Loading Notecard - "+Mess+"...";
                currentnotecard = Mess;

                manualground = "";
                manualsit = "";
                manualwalk = "";
                manualstand = "";
                                
                InitOverride(1);
            }
            else if(MenuContext == "Sit On Object")
            {
                feedback = "Object sit is now: "+Mess;
                handleanim("Sitting",[],Mess);
                manualsit = Mess;
            }
            else if(MenuContext == "Ground Sits")
            {
                feedback = "Ground sit is now: "+Mess;
                handleanim("Sitting on Ground",[],Mess);
                manualground = Mess;
            }
            else if(MenuContext == "Walks")
            {
                feedback = "Walk is now: "+Mess;
                handleanim("Walking",[],Mess);
                manualwalk = Mess;
            }
            else if(MenuContext == "Idles")
            {
                feedback = "Idle is now: "+Mess;
                handleanim("Standing",[],Mess);
                manualstand = Mess;
            }
            else if(MenuContext == "Cycling")
            {
                feedback = "Cycle timer is now: "+Mess;
                float messnum = (float)Mess;
                ControlType = messnum;
                standduration = messnum;
            }

            MenuContext = "";
        }
        
        if(!preservecontext) MenuContext = Mess;
    }

    if(dialog != "") 
    {
        llListenControl(ListenIDSub,TRUE);  
        llDialog(Owner,dialog,dialogbuttons,magicnum+1);
    }
    else if(textbox != "") llTextBox(Owner,textbox,magicnum+1);
    else if (!forcelisten) llListenControl(ListenIDSub,FALSE);//MISSING TIMEOUT
    
    if(feedback) llOwnerSay(feedback);
}
*/
echoanim()
{
    string animtype = llGetAnimation(Owner);
    string currentanim = llList2String(parselinksetdata(animtype),0);
    if(echoqueue) currentanim = echoqueue;
    
    if(lastanimecho != currentanim)
    {//echos animation, needs to account if its already called by an special
        llRegionSayTo(Owner,AOEcho,"AO|syncplay|"+animtype+"|"+currentanim);
        lastanimecho = currentanim;
    }    
}
/*
processtimer(integer AgentInfo)
{
    //float timerupdate;
    if(cooldown>0) cooldown--;//helps with spam
    
    if((standduration!=0) && (llGetTime()>standduration) && !(AgentInfo&AGENT_SITTING) && !Wet )
    {//trigger stand cycle
        RandomUpdateOverrideAll();
        llResetTime();
    }
    
    
    if(AgentInfo&AGENT_FLYING)
    {//just fly trigger incase the control doesn't get it
        hottimer = 10;
    }   
    else if(LastAgentInfo & AGENT_FLYING && !Wet)
    {//landing from flight
        rundir = 0;
        
        handleanim("",[FlyLeft,FlyRight],"");
    }
    
    if(AgentInfo & AGENT_TYPING) handleanim(TypingAnim,[],"");
    else if(LastAgentInfo & AGENT_TYPING) handleanim("",[TypingAnim],"");
    
    if(AgentInfo & AGENT_AWAY) handleanim(AwayAnim,[],"");
    else if(LastAgentInfo & AGENT_AWAY) handleanim("",[AwayAnim],"");
    
    if(AgentInfo & AGENT_BUSY) handleanim(BusyAnim,[],"");
    else if(LastAgentInfo & AGENT_BUSY) handleanim("",[BusyAnim],"");
    
    
    
    echoanim();
}
*/
processwater(integer AgentInfo)
{//WAS HERE LAST NEEDS MORE TESTING
    integer level = heldlevel;
    integer edge = heldedge;
    vector Pos = llGetPos();
    float water = llWater(<0,0,0>); 
    
    integer inwater = Pos.z<water;
    integer inprimwater = FALSE;
    float currentsurface = water - 0.20;
    integer x;
    //llOwnerSay((string)knownWater);
    for(x=0;x<llGetListLength(knownWater);++x)
    {//slightly more cpu time needed than old method, 
        key waterkey = llList2Key(knownWater,x);
        list waterdetails = llGetObjectDetails(waterkey,[OBJECT_POS,OBJECT_SCALE,OBJECT_ROT]);
        //list bbox = llGetBoundingBox(waterkey);//may get funny if linked
        vector waterpos = llList2Vector(waterdetails,0);
        vector waterscale = llList2Vector(waterdetails,1);
        rotation waterrot = llList2Rot(waterdetails,2);

        vector min = waterscale*-0.5;
        vector max = waterscale*0.5;
        vector inputvec = (Pos-waterpos)*waterrot;

        //if(vecwithin((Pos-waterpos)*waterrot,min,max))//saves memory if not a function
        if(
            ((inputvec.x >= min.x) && (inputvec.x <= max.x)) &&
            ((inputvec.y >= min.y) && (inputvec.y <= max.y)) &&
            ((inputvec.z >= min.z) && (inputvec.z <= max.z))
        )
        {
            float pendingsurface = waterpos.z + max.z - 0.20;
            if(pendingsurface > currentsurface) currentsurface = pendingsurface;
            //incase some weirdo puts a bounding box underwater/touching water/going up water
            inprimwater = TRUE;
        }
    }
    
    
       
    integer agentair = (AgentInfo & AGENT_IN_AIR);
    integer agentflying = (AgentInfo & AGENT_FLYING);

    if(agentair && !agentflying && !Wet)
    {//not in water but maybe diving aka triggers when falling
        hottimer = 60;
        if(hottimer<15) llSetTimerEvent(hottimerduration);//faster response
    }


    if(!inwater && !inprimwater && Wet) exitwater("timer exit");//is wet adn exiting
    else if(inwater || inprimwater)
    {//in the water
        vector movepos;
        vector curvel = llGetVel();
        float movepostau = 0.5;
        
        if(!Wet)//Gets the old AO and applies new one
        {
            //enterwater("process entry");//saves memory outside of funciton
            {
            //if(Wet) return;
            
            string splash;
            Wet = 1;
            
            if(llVecMag(llGetVel())>5) splash = splashheavy;
            else splash = splashlight;
            
            llPlaySound(splash,0.5);
            llSetBuoyancy(1);
            llMoveToTarget(llGetPos()+(llGetVel()*0.22),1);//draggyness
            heldany = 0;
            
            SwimUp = llList2String(parselinksetdata("Swimming Up"),0);//far more resources saved not repeating lllist2string
            SwimForward = llList2String(parselinksetdata("Swimming Forward"),0);
            SwimFast = llList2String(parselinksetdata("Swimming Fast"),0);
            SwimIdle = llList2String(parselinksetdata("Swimming Idle"),0);
            SwimDown = llList2String(parselinksetdata("Swimming Down"),0);
            SwimSurf = llList2String(parselinksetdata("Swimming Surface"),0);
            SeaWalk = llList2String(parselinksetdata("Sea Walk"),0);//only called now
            SeaRun = llList2String(parselinksetdata("Sea Run"),0);
            
            handleanim("Hovering",[],SwimIdle);
            handleanim("Falling Down",[],SwimIdle);
            handleanim("Jumping",[],SwimIdle);
            
            
            handleanim("Hovering Up",[],SwimUp);
            handleanim("Hovering Down",[],SwimDown);
            
            if(SwimFast == "") SwimFast = SwimForward;
            if(SeaRun == "") SeaRun = SeaWalk;
            
            handleanim("Flying",[FlyLeft,FlyRight],SwimFast);   
            
            
            if(SeaWalk) handleanim("Walking",[],SeaWalk);
            if(SeaRun) handleanim("Running",[],SeaRun);


            
            handleanim(SeaRun,["falldown",RunLeft,RunRight,FlyLeft,FlyRight//,"walk","run"
            /*
            ,"fly","flyslow","hover","hover_down","hover_up"
            ,"land","run","soft_land","walk","run"*/
            ],"");
            }
        }
        else if((AgentInfo&AGENT_IN_AIR) && rundir == 2)
        {//recover from sea walk
            llSetBuoyancy(1);
            movepos = Pos+(curvel*0.5);
            movepostau = 1;
            
            rundir = 0;
            hottimer = 0;
        }
        
        
        if(Wet)
        {//actively swwimming
            rotation currot = llGetRot();
            vector TPos;
            float mult = 3.2;

            integer onsurface = (Pos.z > (currentsurface - 0.20));//surface2 || surface1 || surfacewat;
            

            if(AgentInfo&AGENT_IN_AIR)//swimming
            {
                handleanim("",[SeaWalk,SeaRun],"");
                if(AgentInfo&AGENT_ALWAYS_RUN) mult = 5.2;    
                
                if(level & CONTROL_UP)     
                {  
                    if(heldany<40 && (onsurface)) heldany += 5;   
                    else if(heldany >= 40)
                    {//exit water boost jumping out, works special
                        if(heldany == 40)
                        {//trigger the jump
                            exitwater("Jump Exit"); 
    
                            TPos = ZERO_VECTOR;
                            float shove;
    
                            while(shove<1)
                            {
                                vector impulse;
                                float sleep;
                                        
                                if(llGetEnergy()<0.9)
                                {
                                    impulse = ZERO_VECTOR;
                                    sleep = 0.04;
                                }
                                else
                                {
                                    shove += 0.1; 
                                    impulse = <0,0,0.8*llSin(shove*PI)>;
                                    sleep = 0.01;
                                }
                                        
                                llSleep(sleep);
                                llApplyImpulse(<0,0,0.8*llSin(shove*PI)>,FALSE);
                            }
                            return;
                        }
                    }//end of held
                    //control up still going
                    
                    if(!(onsurface))//also not on surface
                        handleanim(SwimUp,[SwimDown],"");
                        
                    TPos += <0, 0, 0.5>;
                }//end of controlup
                else if(level & CONTROL_DOWN)
                {
                    if(heldany<40 && (onsurface)) heldany+=5;
                    else if(!onsurface) handleanim(SwimDown,[SwimUp],"");
                        
                    //SWIM BUG UNSURE IF NECCESSARY NEED TEST
                    //playstopanims("",[SwimUp]);
                    
                    TPos -= <0, 0, 0.5>;
                }
                else
                {//not up or down
                    handleanim("",[SwimDown,SwimUp],"");
                    heldany = 0;
                }
                //still floating 
                if(level & CONTROL_FWD) TPos += <1, 0, 0.0>;
                else if(level & CONTROL_BACK) TPos -= <1, 0, 0.0>;
                
                if(level & CONTROL_LEFT) TPos += <0, 1, 0.0>;
                else if(level & CONTROL_RIGHT) TPos -= <0, 1, 0.0>;
    
    
                //if(!level) NEEDS TESTING handleanim(SwimIdle,[],"");
                ///animhjadnling----
                if((TPos.x+TPos.y != 0) && rundir != -2)//holding a direction and not on seafloor
                {
                    if(onsurface) handleanim(SwimSurf,[SwimForward],"");
                    else handleanim(SwimForward,[SwimSurf],"");
                }
                else if(TPos == ZERO_VECTOR && rundir != -2)
                {//not moving anywhere
                    
                    handleanim(SwimIdle,[SwimSurf,SwimForward],"");
                }   
                
                //drift handling--------

                if(TPos) TPos *= 0.05;//accum multiplier
                
                if(llFabs(PersSwimTPos.x) >= 1) TPos.x = 0;//accumlator stops when perspos is max
                else TPos.x = min(TPos.x,1-TPos.x);
                            
                if(llFabs(PersSwimTPos.y) >= 1) TPos.y = 0;
                else TPos.y = min(TPos.y,1-TPos.y);
                                
                if(llFabs(PersSwimTPos.z) >= 1) TPos.z = 0;
                else TPos.z = min(TPos.z,1-TPos.z);
                
                //makes sure unheld buttons decay drag
                if(TPos.x) PersSwimTPos.x += TPos.x;
                else PersSwimTPos.x *= 0.9;
                if(TPos.y) PersSwimTPos.y += TPos.y;
                else PersSwimTPos.y *= 0.9;                                
                if(TPos.z) PersSwimTPos.z += TPos.z;
                else PersSwimTPos.z *= 0.9;
                
                //PersSwimTPos *= 0.99;//hacky way to make sure fabs doesn't cap direciton incase timer does'nt run

                vector MoveTPos = ((PersSwimTPos*currot)*0.5*mult);//local to global,mult for running 
                //llOwnerSay((string)PersSwimTPos);
                if(PersSwimTPos == ZERO_VECTOR 
                    && !((level & CONTROL_ROT_LEFT)//vel brings down if rotating
                    || (level & CONTROL_ROT_RIGHT)) )//prevent stopping instantly, 
                {
                    MoveTPos += <curvel.x,curvel.y,curvel.z>*0.5;
                }
                vector gotopos = Pos+MoveTPos;
                //llOwnerSay((string)PersSwimTPos);
                if(heldany < 40)//cap height at surface
                {//making sure not held or something
                    float max = gotopos.z;
                    if(onsurface)
                    {
                        handleanim("",[SwimUp,SwimDown],"");
                        
                        max = currentsurface+0.10;
                        /*
                        if(surface2) max = watermax2.z-0.1;
                        else if(surface1) max = watermax.z-0.1;
                        else if(surfacewat) max = water-0.1;
                        */
                    }
                    gotopos = <gotopos.x,gotopos.y,max>;
                }
                
                if(movepos == ZERO_VECTOR) movepos = gotopos;
                
                //llOwnerSay((string)movepos);
                llMoveToTarget(movepos,movepostau);//finally move
            }//end of in air
            else
            {//hitting sea floor
                if(rundir != 2)
                {
                    rundir = 2;
                    PersSwimTPos = ZERO_VECTOR;
                    handleanim("",[SwimForward,SwimSurf,SwimUp,SwimDown,SwimFast],"");
                    llSetBuoyancy(0.8);
                    llStopMoveToTarget();
                }
                
                llApplyImpulse(curvel*-0.3,FALSE);

                hottimer = 30;
            }
        }  
    }
}
/*
enterwater(string reason)
{
    if(Wet) return;
    
    string splash;
    Wet = 1;
    
    if(llVecMag(llGetVel())>5) splash = splashheavy;
    else splash = splashlight;
    
    llPlaySound(splash,0.5);
    llSetBuoyancy(1);
    llMoveToTarget(llGetPos()+(llGetVel()*0.22),1);//draggyness
    heldany = 0;
    
    SwimUp = llList2String(parselinksetdata("Swimming Up"),0);//far more resources saved not repeating lllist2string
    SwimForward = llList2String(parselinksetdata("Swimming Forward"),0);
    SwimFast = llList2String(parselinksetdata("Swimming Fast"),0);
    SwimIdle = llList2String(parselinksetdata("Swimming Idle"),0);
    SwimDown = llList2String(parselinksetdata("Swimming Down"),0);
    SwimSurf = llList2String(parselinksetdata("Swimming Surface"),0);
    string SeaWalk = llList2String(parselinksetdata("Sea Walk"),0);//only called now
    string SeaRun = llList2String(parselinksetdata("Sea Run"),0);
    
    handleanim("Hovering",[],SwimIdle);
    handleanim("Falling Down",[],SwimIdle);
    handleanim("Jumping",[],SwimIdle);
    
    
    handleanim("Hovering Up",[],SwimUp);
    handleanim("Hovering Down",[],SwimDown);
    
    if(SwimFast == "") SwimFast = SwimForward;
    if(SeaRun == "") SeaRun = SeaWalk;
    
    handleanim("Flying",[FlyLeft,FlyRight],SwimFast);   
    
    
    if(SeaWalk) handleanim("Walking",[],SeaWalk);
    if(SeaRun) handleanim("Running",[],SeaRun);
    
    handleanim(SeaRun,["falldown",RunLeft,RunRight],"");
}
*/
/*
processcontrol(integer level, integer edge, integer AgentInfo)
{
    integer agentair = AgentInfo & AGENT_IN_AIR;
    
    if(BackTog)
    {
        if(!(AgentInfo & AGENT_SITTING))
        {
            if(!Wet && !agentair && !(AgentInfo&AGENT_ALWAYS_RUN) && 
                (level & CONTROL_BACK) && !(level & (CONTROL_RIGHT|CONTROL_LEFT|CONTROL_UP|CONTROL_DOWN))
                )
            {
                float mult = 1.2;
                
                if(AgentInfo & AGENT_CROUCHING) mult = -0.15;
    
                rotation currot = llGetRot();
                llMoveToTarget(llGetPos()+(<mult,0,0>*currot),1);
                
                
                if(!BackingUp)
                { 
                    BackingUp = TRUE;
    
                    handleanim(BackupAnim,[],"");
                }
                
            }
            else if(BackingUp)
            {
                llStopMoveToTarget();
    
                handleanim("",[BackupAnim],"");
                
                if(LagComp) llApplyImpulse(<-1.5,0,0>,TRUE);
                BackingUp = FALSE;
            }
        }
    }
    //prejump jank
    /*
    if(level & CONTROL_UP)
    {
        string ownerplayanim = llGetAnimation(Owner);
        
        if((ownerplayanim == "PreJumping" || ownerplayanim == "Standing Up"))
        {
            if(!hottimer) hottimer = 20;
            if(!stunlock) stunlock = 10;
        }
        else if(stunlock>8)
        {//prejump jankery
            handleanim("Standing Up",[],llList2String(parselinksetdata("Standing Up"),0));
            handleanim("Soft Landing",[],llList2String(parselinksetdata("Soft Landing"),0));
            
            string Prejump = llList2String(parselinksetdata("PreJumping"),0);
            
            if(Prejump)
            {
                llResetAnimationOverride("PreJumping");
                handleanim("",["prejump"],"");
                llSleep(0.1);
                handleanim("PreJumping",[],Prejump);
            }
        }
            
    }
    */
    /*
    //lean turn run control
    if(!Wet)
    {
        integer resetrun;
        integer agentflying = AgentInfo & AGENT_FLYING;
        integer forward = level & CONTROL_FWD;
        
        if(forward)//reset when let go of forward and no longer needing to lean
        {//must forward to lean
            vector omega = llGetOmega();
            integer left = level & 33554432 && omega.z > 0.6;
            integer right = level & 67108864 && omega.z < -0.6;
            integer running = AgentInfo&AGENT_ALWAYS_RUN;
            

            //run left
            if(left)
            {
                if(agentflying) {handleanim(FlyLeft,[RunLeft,RunRight,FlyRight],"");rundir = -1;}
                else if(running) {handleanim(RunLeft,[FlyLeft,RunRight,FlyRight],"");rundir = -1;}
            }
            else if(right)
            {
                if(agentflying) {handleanim(FlyRight,[RunLeft,RunRight,FlyLeft],"");rundir = 1;}
                else if(running) {handleanim(RunRight,[FlyLeft,RunLeft,FlyRight],"");rundir = 1;}
            }
            else if(rundir != 0) resetrun = 1;//needs to trigger inside and outside of forward
        }
        else if(rundir != 0) resetrun = 1;
        //else resetrun;
        if(resetrun)
        {
            handleanim("",[FlyLeft,FlyRight,RunRight,RunLeft],"");
            rundir = 0;
        }
    }
    
    
    if(((ControlType==0) && !level && !cooldown && !agentair && !Wet && !(AgentInfo&AGENT_SITTING)))
    {//changing idles on move
        RandomUpdateOverrideAll();
    }
    
    if(edge)
    {//hot updates on key c hange
        llSetTimerEvent(0.01);
        if(Wet && hottimer<15) hottimer = 15;
        else if(hottimer<10) hottimer = 10;
        
        echoanim();
    }
}
*/
list knownWater;
/*
processwaterbounds(string sender, string Mess)
{
    list messlist = llParseString2List(Mess,["|"],[]);
    string avatar = realdirtydecrypter(llList2String(messlist,1));
                
    if(avatar != Owner) return;
    
    if(!~llListFindList(knownWater,[sender]))
        knownWater += sender;
    while( llGetListLength(knownWater) > 2)
        knownWater = llDeleteSubList(knownWater,0,0);
}*/
/*
integer vecwithin(vector in, vector min, vector max)
{
    return 
    (
        ((in.x >= min.x) && (in.x <= max.x)) &&
        ((in.y >= min.y) && (in.y <= max.y)) &&
        ((in.z >= min.z) && (in.z <= max.z))
    );
}*/

/*
processwaterbounds(string Mess)
{
    list messlist = llParseString2List(Mess,["|"],[]);
    string avatar = realdirtydecrypter(llList2String(messlist,1));
                
    if(avatar != Owner) return;
            
    vector watbuffer = (vector)llList2String(messlist,2); 
    
    if(watermin == <0,0,0> || (lastwaterindex != 1 && watbuffer != watermin2))
    {
        watermin = watbuffer;
        watermax = (vector)llList2String(messlist,3);
        lastwaterindex = 1;        
    }
    else if(lastwaterindex != 2 && watermin != watermin2 && watbuffer != watermin)
    {
        watermin = watbuffer;
        watermax = (vector)llList2String(messlist,3);
        lastwaterindex = 2;        
    }
}
*/
default
{
    state_entry()
    {
        init();
    }
    changed(integer change)
    {
        if(change & CHANGED_TELEPORT) exitwater("resetonly");
        if(change & CHANGED_INVENTORY && llGetInventoryNumber(INVENTORY_ANIMATION) == totalanims)
            InitOverride(1); 
            
    }
    attach(key id)
    {
        if(id == NULL_KEY) deinit();
        else 
        {
            vector size = llGetAgentSize(Owner);

            if(size.z == 1.9)//wait until avatar is loaded
                llSleep(5);

            init();    
            //InitOverride(0);
        }
    }
    control( key id, integer level, integer edge )
    {
        if(!Loaded) return;
        
        heldedge = edge;
        heldlevel = level;
        
        integer AgentInfo = llGetAgentInfo(Owner);
        
        //processcontrol(level,edge,AgentInfo);//saves memory outside of funciton
            integer agentair = AgentInfo & AGENT_IN_AIR;
    
            if(BackTog)
            {
                if(!(AgentInfo & AGENT_SITTING))
                {
                    if(!Wet && !agentair && !(AgentInfo&AGENT_ALWAYS_RUN) && 
                        (level & CONTROL_BACK) && !(level & (CONTROL_RIGHT|CONTROL_LEFT|CONTROL_UP|CONTROL_DOWN))
                        )
                    {
                        float mult = 1.2;
                        
                        if(AgentInfo & AGENT_CROUCHING) mult = -0.15;
            
                        rotation currot = llGetRot();
                        llMoveToTarget(llGetPos()+(<mult,0,0>*currot),1);
                        
                        
                        if(!BackingUp)
                        { 
                            BackingUp = TRUE;
            
                            handleanim(BackupAnim,[],"");
                        }
                        
                    }
                    else if(BackingUp)
                    {
                        llStopMoveToTarget();
            
                        handleanim("",[BackupAnim],"");
                        
                        if(LagComp) llApplyImpulse(<-1.5,0,0>,TRUE);
                        BackingUp = FALSE;
                    }
                }
            }
            //prejump jank
            /*
            if(level & CONTROL_UP)
            {
                string ownerplayanim = llGetAnimation(Owner);
                
                if((ownerplayanim == "PreJumping" || ownerplayanim == "Standing Up"))
                {
                    if(!hottimer) hottimer = 20;
                    if(!stunlock) stunlock = 10;
                }
                else if(stunlock>8)
                {//prejump jankery
                    handleanim("Standing Up",[],llList2String(parselinksetdata("Standing Up"),0));
                    handleanim("Soft Landing",[],llList2String(parselinksetdata("Soft Landing"),0));
                    
                    string Prejump = llList2String(parselinksetdata("PreJumping"),0);
                    
                    if(Prejump)
                    {
                        llResetAnimationOverride("PreJumping");
                        handleanim("",["prejump"],"");
                        llSleep(0.1);
                        handleanim("PreJumping",[],Prejump);
                    }
                }
                    
            }
            */
            //lean turn run control
            if(!Wet)
            {
                integer resetrun;
                integer agentflying = AgentInfo & AGENT_FLYING;
                integer forward = level & CONTROL_FWD;
                
                if(forward)//reset when let go of forward and no longer needing to lean
                {//must forward to lean
                    vector omega = llGetOmega();
                    integer left = level & 33554432 && omega.z > 0.6;
                    integer right = level & 67108864 && omega.z < -0.6;
                    integer running = AgentInfo&AGENT_ALWAYS_RUN;
                    
        
                    //run left
                    if(left)
                    {
                        if(agentflying) {handleanim(FlyLeft,[RunLeft,RunRight,FlyRight],"");rundir = -1;}
                        else if(running) {handleanim(RunLeft,[FlyLeft,RunRight,FlyRight],"");rundir = -1;}
                    }
                    else if(right)
                    {
                        if(agentflying) {handleanim(FlyRight,[RunLeft,RunRight,FlyLeft],"");rundir = 1;}
                        else if(running) {handleanim(RunRight,[FlyLeft,RunLeft,FlyRight],"");rundir = 1;}
                    }
                    else if(rundir != 0) resetrun = 1;//needs to trigger inside and outside of forward
                }
                else if(rundir != 0) resetrun = 1;
                //else resetrun;
                if(resetrun)
                {
                    handleanim("",[FlyLeft,FlyRight,RunRight,RunLeft],"");
                    rundir = 0;
                }
            }
            
            
            if(((ControlType==0) && !level && !cooldown && !agentair && !Wet && !(AgentInfo&AGENT_SITTING)))
            {//changing idles on move
                RandomUpdateOverrideAll();
            }
            
            if(edge)
            {//hot updates on key c hange
                llSetTimerEvent(0.01);
                if(Wet && hottimer<15) hottimer = 15;
                else if(hottimer<10) hottimer = 10;
                
                echoanim();
            }
        
        if(SwimDamp) processwater(AgentInfo);
    }
    timer()
    {
        integer AgentInfo = llGetAgentInfo(Owner);
        
        //processtimer(AgentInfo);
        {
            //float timerupdate;
            if(cooldown>0) cooldown--;//helps with spam
            
            if((standduration!=0) && (llGetTime()>standduration) && !(AgentInfo&AGENT_SITTING) && !Wet )
            {//trigger stand cycle
                RandomUpdateOverrideAll();
                llResetTime();
            }
            
            
            if(AgentInfo&AGENT_FLYING)
            {//just fly trigger incase the control doesn't get it
                hottimer = 10;
            }   
            else if(LastAgentInfo & AGENT_FLYING && !Wet)
            {//landing from flight
                rundir = 0;
                
                handleanim("",[FlyLeft,FlyRight],"");
            }
            
            if(AgentInfo & AGENT_TYPING) handleanim(TypingAnim,[],"");
            else if(LastAgentInfo & AGENT_TYPING) handleanim("",[TypingAnim],"");
            
            if(AgentInfo & AGENT_AWAY) handleanim(AwayAnim,[],"");
            else if(LastAgentInfo & AGENT_AWAY) handleanim("",[AwayAnim],"");
            
            if(AgentInfo & AGENT_BUSY) handleanim(BusyAnim,[],"");
            else if(LastAgentInfo & AGENT_BUSY) handleanim("",[BusyAnim],"");
            
            
            
            echoanim();
        }
        if(SwimDamp) processwater(AgentInfo);
        
        if(hottimer) {hottimer--;llSetTimerEvent(hottimerduration);}
        else llSetTimerEvent(internaltimer);
        
        LastAgentInfo = AgentInfo;
    }
    touch_start(integer dect)
    {
        if(llDetectedKey(0) != Owner) return;
        integer link = llDetectedLinkNumber(0);
        integer face = llDetectedTouchFace(0);
        
        handletouchstart(link,face);
    }
    listen( integer channel, string name, key id, string message )
    {
//        llOwnerSay((string)channel);
        if(id == Owner) 
        {
            //processlisten(channel, message);
            {
                integer forcelisten;
                list dialogbuttons;
                string dialog;
                string textbox;
                string feedback;
                
                message = llStringTrim(message,STRING_TRIM);
            
                if(channel == magicnum+1)
                {
                    integer preservecontext;
                    
                    if(message == "Cycling")
                    {
                        textbox = "\nEnter how often you want to randomize the animation set. \n\nSet to 0 to do it when you stop moving.";
                    }
                    else if(message == "Update")
                        InitOverride(0);
                    else if(message == "🡸")
                    {
                        integer pagecount = llFloor(llGetInventoryNumber(INVENTORY_NOTECARD)/6);
                                
                        pageindex--;
                        if(pageindex<0) pageindex = pagecount;
                                
                        sendpage(pageindex);
                        forcelisten = 1;
                        preservecontext = 1;
                    }
                    else if(message == "🡺")
                    {
                        integer pagecount = llFloor(llGetInventoryNumber(INVENTORY_NOTECARD)/6);
                                
                        pageindex++;
                        if(pageindex>pagecount) pageindex = 0;
                                
                        sendpage(pageindex);
                        forcelisten = 1;
                        preservecontext = 1;
                    }
                    else if(message == "CLOSE")
                    {
                        preservecontext = 1;
                    }
                    else if(message == "Sit On Object")
                    {
                        list SitList = parselinksetdata("Sitting");
                        
                        dialog = "Control which animation is played when you sit down.";
                        dialogbuttons = ["Random Sit obj"]+SitList;
                    }
                    else if(message == "Load Notecard")
                    {
                        sendpage(pageindex);
                        forcelisten = 1;
                    }
                    else if(message == "Ground Sits")
                    {
                        list GroundSitList = parselinksetdata("Sitting on Ground");
            
                        dialog = "Control which animation is played when you sit down on the ground.";
                        dialogbuttons = ["Random Sit grd"]+GroundSitList;
                    }
                    else if(message == "Idles")
                    {
                        list StandList = parselinksetdata("Standing");
            
                        dialog = "Control which animation is played when you stand around.";
                        dialogbuttons = ["Random Idle"]+StandList;
                    }
                    else if(message == "Walks")
                    {
                        list WalkList = parselinksetdata("Walking");
            
                        dialog = "Control which animation is played when you walk around.";
                        dialogbuttons = ["Random Walk"]+WalkList;
                    }//button selects end--------------------------
                    else if(message == "Random Sit grd")
                    {
                        manualground = "";
                        feedback = "Ground sits are now randomized";
                    }
                    else if(message == "Random Sit obj")
                    {
                        manualsit = "";
                        feedback = "Object sits are now randomized";
                    }
                    else if(message == "Random Idle")
                    {
                        manualstand = "";
                        feedback = "Idles are now randomized";
                    }
                    else if(message == "Random Walk")
                    {
                        manualwalk = "";
                        feedback = "Walks are now randomized";
                    }
                    else if(message == "Internal Timer")
                    {
                        textbox = "\nEnter the approximate time inbetween timer events.";
                    }
                    else if(message == "Sequence Stands")
                    {
                        sequentialstands = !sequentialstands;
                        
                        if(sequentialstands) feedback = "Stands are now sequential, going through the order in the notecard.";
                        else feedback = "Stands are now randomized.";
                        
                        RandomUpdateOverrideAll();
                    }
                    else
                    {//selected a thing//TEST THIS FINISH THIS
                        if(MenuContext == "Load Notecard")
                        {
                            if(llGetInventoryType(message) != INVENTORY_NOTECARD) message = "Animation Config: "+message;
                            if(llGetInventoryType(message) != INVENTORY_NOTECARD) message = "Animation Config:"+message; // incase it has no spaces
                            feedback = "Loading Notecard - "+message+"...";
                            currentnotecard = message;
            
                            manualground = "";
                            manualsit = "";
                            manualwalk = "";
                            manualstand = "";
                                            
                            InitOverride(1);
                        }
                        else if(MenuContext == "Sit On Object")
                        {
                            feedback = "Object sit is now: "+message;
                            handleanim("Sitting",[],message);
                            manualsit = message;
                        }
                        else if(MenuContext == "Ground Sits")
                        {
                            feedback = "Ground sit is now: "+message;
                            handleanim("Sitting on Ground",[],message);
                            manualground = message;
                        }
                        else if(MenuContext == "Walks")
                        {
                            feedback = "Walk is now: "+message;
                            handleanim("Walking",[],message);
                            manualwalk = message;
                        }
                        else if(MenuContext == "Idles")
                        {
                            feedback = "Idle is now: "+message;
                            handleanim("Standing",[],message);
                            manualstand = message;
                        }
                        else if(MenuContext == "Cycling")
                        {
                            feedback = "Cycle timer is now: "+message;
                            float messnum = (float)message;
                            ControlType = messnum;
                            standduration = messnum;
                        }
            
                        MenuContext = "";
                    }
                    
                    if(!preservecontext) MenuContext = message;
                }
            
                if(dialog != "") 
                {
                    llListenControl(ListenIDSub,TRUE);  
                    llDialog(Owner,dialog,dialogbuttons,magicnum+1);
                }
                else if(textbox != "") llTextBox(Owner,textbox,magicnum+1);
                else if (!forcelisten) llListenControl(ListenIDSub,FALSE);//MISSING TIMEOUT
                
                if(feedback) llOwnerSay(feedback);
            }
        }     
        else if(llGetOwnerKey(id) == Owner)
        {
            list data = llParseString2List(message, ["|"],[]);
            string command = llList2String(data,0);
            string input = llList2String(data,1);
            if(message == "findAO")
                llRegionSayTo(id,AOEcho,"AO|sync");
            else if(command == "remoteload")
            {
                message = input;
                if(llGetInventoryType(input) != INVENTORY_NOTECARD) input = "Animation Config: "+input;
                if(llGetInventoryType(input) != INVENTORY_NOTECARD) input = "Animation Config:"+input; // incase it has no spaces
                llOwnerSay("Loading Notecard - "+input+"...");
                currentnotecard = input;
            
                manualground = "";
                manualsit = "";
                manualwalk = "";
                manualstand = "";
                                            
                InitOverride(1);
            }
        }
        
        if(channel == magicnum && SwimDamp)
        {//waterbounds?
            if(llList2String(llParseString2List(message,["|"],[]),0) == "water")
            {
                list messlist = llParseString2List(message,["|"],[]);
                string avatar = realdirtydecrypter(llList2String(messlist,1));
                            
                if(avatar != Owner) return;
                
                if(!~llListFindList(knownWater,[id]))
                    knownWater += id;
                while( llGetListLength(knownWater) > 2)
                    knownWater = llDeleteSubList(knownWater,0,0);
                //processwaterbounds(id,message);//no longer needs group //saves memory outside of funciton
            }
        }   
    }
    run_time_permissions(integer PermReturn) 
    {
        if (PermReturn & (PERMISSION_TRIGGER_ANIMATION | PERMISSION_OVERRIDE_ANIMATIONS)) 
            InitOverride(Loaded);
            
        if (PermReturn & (PERMISSION_TAKE_CONTROLS)) 
            llTakeControls(100664127, TRUE, TRUE);
    }
    link_message( integer sender_num, integer num, string str, key id )
    {
        if(id == "getinv")
        {
            integer count = llGetInventoryNumber(INVENTORY_ALL);
            integer length;
            list inventory;

            while(count--)
            {
                string name = llGetInventoryName(INVENTORY_ALL,count);
                inventory += name;
                length++;
                
                if(length > 30)
                {
                    llMessageLinked(LINK_SET, 0, llDumpList2String(inventory,"↕↕"), "rootinv");
                    length = 0;
                    inventory = [];
                    //llOwnerSay("splitting");
                }
            }

            llMessageLinked(LINK_SET, 0, llDumpList2String(inventory,"↕↕"), "endrootinv");
        }
        else if(id == "prepmove")
        {
            list removal = llParseString2List(str,["↕↕"],[]);
            integer count = llGetListLength(removal);
            //llOwnerSay((string)count);
            while(count--)
                llRemoveInventory(llList2String(removal,count));
            //removal = [];//attempt to save memory right away
            llMessageLinked(LINK_SET, 0, "", "readyforin");
        }
    }

    dataserver(key Request, string Data)
    {//notecard reader
        if(Request != NotecardRequestID) return;
        
        llSleep(0.1);
        //garbage collection is not run during this so problems MIGHt happen
        while(Data != EOF) 
        {
            //llOwnerSay((string)CurNoteLine);
            list Datalist = llParseString2List(Data,["|",",","[","]"],[]);
            integer length = llGetListLength(Datalist);

            while(length--)//reconstruct but trim
            {
                string Trimmed = llStringTrim(llList2String(Datalist,length),STRING_TRIM);
                if(Trimmed == "") Trimmed = " ";
                
                Datalist = llListReplaceList(Datalist,[Trimmed],length,length);
            }

            string typeofentry = llList2String(Datalist,0);
            list datainlist = llList2List(Datalist,1,-1);
            
            integer result;
            if(typeofentry != "")
                result = llLinksetDataWrite( typeofentry , llDumpList2String(datainlist,"|"));
            
            if(result != LINKSETDATA_OK && result != LINKSETDATA_NOUPDATE)
                llOwnerSay("Error: "+(string)result+" - "+typeofentry);

            CurNoteLine++;
            
            Data = llGetNotecardLineSync(currentnotecard,CurNoteLine);
            
            if(Data == NAK)
                NotecardRequestID = llGetNotecardLine(currentnotecard,CurNoteLine);
        }
        if(Data != NAK)
        {
            CurNoteLine = 0;
            Loaded = 1;
            RandomUpdateOverrideAll();
            integer lowestmemory = 65536 - llGetUsedMemory();
            llSleep(0.1);
            llOwnerSay("Loading finished! Memory remaining:"+(string)(65536 - llGetUsedMemory()) + " | "+(string)lowestmemory + " while loading.");
            warned = 1;
        }
    }
}

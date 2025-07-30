integer ListenID;
integer queued;
integer openkey;
integer sneezable = FALSE;
//float sizemult = 1;
float curtimer;
string timerreason;
key Owner;
list animqueue;
list stopqueue;

integer detox(string input,integer count)
{
    list DateData = llParseString2List(llGetDate(), ["-"], []);
    
    integer month = (integer)llList2String(DateData, 1);
    integer day = (integer)llList2String(DateData, 2); 

    input = llXorBase64(input,llStringToBase64("§https://youtu.be/Jh7XsGeWxCE♠"));
    
    integer pin = llBase64ToInteger(input);
    //llOwnerSay("butcher -- "+ (string)pin);
    
    //pin = pin/(count);//
    pin = (pin-(day+month)) - (
         ( (integer)("0x"+(string)llGetKey()) )
         + (count*day));

    timerreason = "update timeout";
    llSetTimerEvent(120);

    return pin;
}
startreaction(key source,string triggerdata)
{//trigger-anims,anims-sounds,sounds-range-delay-random-directional-echo-exception
//anims in inventory named with _direction at end, anims in notecard do not have this
    
    list parsed = llParseString2List(triggerdata,["|"],[]);
    string trigger = llList2String(parsed,0);
    string exceptions = llList2String(parsed,8);
//    llOwnerSay(llDumpList2String(parsed,"|")+"===trigger");
    
    if(exceptions)
    {
        list attached = llGetAttachedList(Owner);
        integer length = llGetListLength(attached);

        while(length--)
        {
            string name = llToLower( llKey2Name((llList2String(attached,length))) );
                
            if(~llSubStringIndex( name , exceptions ))
                return;
        }
    }
    
    
    list details = llGetObjectDetails(source,[OBJECT_POS,OBJECT_ROT]);
    float sizemult = (float)llLinksetDataRead("rangemult");
    vector centerpos = llGetPos()+(<0.27*sizemult,0,0>*llGetRot());//fucking took me a couple of hours to realize pony center WAS teh butt
    vector sourcepos = llList2Vector(details,0);
    float range = llList2Float(parsed,3);
    
    float distance = llVecDist(centerpos,sourcepos);

    if(distance > range) return;//range check
    
    float delay = llList2Float(parsed,4);
    float random = llList2Float(parsed,5);
    //llOwnerSay("next===="+(string)(llList2Float(animqueue,0)-llGetTime()));
    if(delay + random > 0)
    {//play it later
        //llOwnerSay(llDumpList2String(animqueue,"|"));
        if(timerreason != "" && timerreason != "delayanim") return;//probaly updating
        if(~llListFindList(animqueue,[trigger])) return;
        
//        integer queuelength = llGetListLength(animqueue);
//        if(queuelength == 0) llResetTime();
        
        float curtime = llGetTime();
        float finaldelay = delay+llFrand(random)*llGetRegionTimeDilation();
        
        animqueue += [curtime+finaldelay,trigger,source];
        animqueue = llListSort(animqueue,3,TRUE);
        /*
        float nexttime = llList2Float(animqueue,0)-curtime;
        
        //llOwnerSay("initnext==="+(string)nexttime);
        
        if(nexttime > 0)
        {
            //llSetTimerEvent(nexttime);
            timerreason = "delayanim";
            //llOwnerSay("timerupdate==="+(string)nexttime);
        }
        else
        {
            //llSetTimerEvent(0.05);
            timerreason = "delayanim";
            //llOwnerSay("we are late");
        }
        */
    }
    else
        processtrigger(trigger,source);
    
    requeuetimer();
//    llOwnerSay("quieue==++="+llDumpList2String(animqueue,"|"));
}
cleanupstops()
{//cleanup old stops and retimers
//trigger timer is handled seperately
    float stoptime = llList2Float(stopqueue,0);
    //llOwnerSay("stoptime===="+(string)stoptime);
    if(stoptime)
    {
        if(stoptime-llGetTime() < 0.07)
        {
            llStopAnimation(llList2String(stopqueue,1));
            stopqueue = llDeleteSubList(stopqueue,0,2);
        }
    }
    
//    list commandqueue = animqueue+stopqueue;
//    commandqueue = llListSort(commandqueue,3,TRUE);
        

    //llOwnerSay("qudieue==="+llDumpList2String(animqueue,"|"));
}
requeuetimer()
{
    list commandqueue = animqueue+stopqueue;//remake list incase of changes
    commandqueue = llListSort(commandqueue,3,TRUE);
    
    if(llGetListLength(commandqueue) == 0 && timerreason == "delayanim")
        {
            llSetTimerEvent(0);//queue is done
            timerreason = "";
            llResetTime();
            //llOwnerSay("lastanim===");
        }
    else// if(timerreason != "update timeout")
        {//next command time
            float nexttime = llList2Float(commandqueue,0)-llGetTime();//fresh time cause list updated
            if(nexttime < 0) nexttime = 0.05;
            llSetTimerEvent(nexttime);
            timerreason = "delayanim";
            //llOwnerSay("newdelay==="+(string)nexttime);
            //llOwnerSay("reason==="+llList2String(animqueue,1));
        }        
    //llOwnerSay("comm====="+llDumpList2String(commandqueue,"|"));
}
processtrigger(string trigger,string source)
{
    if(timerreason == "update timeout") return;
    //string trigger = llList2String(parsed,0);
    string triggerdata = llLinksetDataRead(trigger);
    if(triggerdata == "") return;
            
    triggerdata = trigger+"|"+triggerdata;

    list parsed = llParseString2List(triggerdata,["|"],[]);
//    float applytimer;
//    list commandqueue = animqueue+stopqueue;
    
    if(trigger == llList2String(animqueue,1))
    {//trigger exists in queue already, clean and prepare next
        float nexttime = llList2Float(animqueue,0)-llGetTime();
        
        //llOwnerSay("nexttime==="+(string)nexttime);
        if(nexttime < 0.07)
        {//clean from queue
            animqueue = llDeleteSubList(animqueue,0,2);
            //llOwnerSay("Trimming===="+llDumpList2String(animqueue,"|"));
        }
        else //some reason it got triggered early
            return;
    }
    //stop queued anims

//    requeuetimer();

//    if(trigger == "") return;//incase of just stopanim
    //actually playing anim
    list details = llGetObjectDetails(source,[OBJECT_POS,OBJECT_ROT]);//check the most recent direction
    float sizemult = (float)llLinksetDataRead("rangemult");
    if(sizemult==0) sizemult = 1;
    vector centerpos = llGetPos()+(<0.27*sizemult,0,0>*llGetRot());//recalc fresh centerpos
    vector sourcepos = llList2Vector(details,0);
    
    string direction = llList2String(parsed,6);
    float echorange = llList2Float(parsed,7);
//    llOwnerSay("direciton1 =---==="+(string)parsed);
    if(direction != "any")
    {
        //direction stands for required direction sender needs to face target
        //F means sender is facing target, R means target is right of sender
        //all,F,FL,FR ,L,R, BL,BR,B
        //defaults if combined dir not found, back down to base dir, F,L,R,B
        rotation sourcerot = llList2Rot(details,1);//checks rotation at time of trigger
        
        string sourcedir = finddir(sourcerot,sourcepos-centerpos,1);
        
        //less math so probably faster vs parsing every 
        if(llSubStringIndex(direction,sourcedir) == -1) return;
        //make sure sender direction matches
    }
    //llOwnerSay("direciton ===="+direction);
    list anims = llParseString2List(llList2String(parsed,1),[","],[]);
    integer animtotal = llGetListLength(anims);
    //string anim = llList2String(anims,(integer)llFrand(animtotal));
    
    string rootdir = finddir(llGetRot(),sourcepos-centerpos,1);
    //anim picking
    integer count = animtotal;
    list candidates;
    //llOwnerSay((string)count);
    
    while(count--)
    {//for each list option
        string anim = llList2String(anims,count-1);
        anim += "_"+rootdir;
        //string animdir = llList2String(llParseString2List(anim,["_"],[]),-1);
        //llOwnerSay("root==="+anim);
        
        if(llGetInventoryType(anim) == INVENTORY_ANIMATION) candidates += anim;
    }
    
    integer candidatetotal = llGetListLength(candidates);
    string playanim = llList2String(candidates,(integer)llFrand(candidatetotal));
    
    //llOwnerSay("attempt pre===="+playanim);
    //llOwnerSay("candidates====="+(string)candidatetotal);
    
    if(candidatetotal == 0) playanim = llList2String(anims,(integer)llFrand(animtotal));//no directional candidates
    //llOwnerSay("attempt ===="+playanim);
    
    if(llGetInventoryType(playanim) == INVENTORY_ANIMATION) 
    {
        llStopAnimation(playanim);
        llSleep(0.06);
        llStartAnimation(playanim);
        
        list parsed = llParseString2List(playanim,["_"],[]);
        float duration = (float)llList2String(parsed,1);//anim_time_direction
        
        if(duration)
        {
            integer findindex = llListFindList(stopqueue,[playanim]);
            float stoppingtime = llGetTime()+(duration);
            if(~findindex)
            {
                stopqueue = llListReplaceList(stopqueue,[stoppingtime],findindex-1,findindex-1);
            }
            else
            {
                stopqueue += [stoppingtime,playanim,"s"];//s is placeholder for sorting
            }
            
            stopqueue = llListSort(stopqueue,3,TRUE);
        }
    }
    
    //sound picking

    /*
    count = soundtotal-1;
    candidates = [];
    while(count--)
    {
        //llOwnerSay((string)count);
        //string anim = llList2String(anims,count);
        //string animdir = llList2String(llParseString2List(anim,["_"],[]),-1);
         
        //candidates += ;
        //if(animdir == rootdir) candidates += anim;
    }    
    
    
    soundtotal = llGetListLength(sounds);
    */
    
    
    //llOwnerSay("attempt ===="+playanim);

    
    list sounds = llParseString2List(llList2String(parsed,2),[","],[]); 
    integer soundtotal = llGetListLength(sounds);
        
    string sound = llList2String(sounds,(integer)llFrand(soundtotal));
    list parsedsound = llParseString2List(sound,["*"],[]);
    float sounddelay = llList2Float(parsedsound,2);
    float volume = llList2Float(parsedsound,1);
    sound = llList2String(parsedsound,0);
    //llOwnerSay(llDumpList2String(parsedsound,"-"));
        
    if(llGetInventoryType(sound) == INVENTORY_SOUND)
    {//sneezing*volume*delay
        if(sounddelay > 1) 
        {//attempt to sneak in a preload for long sounds
            llPreloadSound(sound);
            llSleep(sounddelay-1);
        }
        else if(sounddelay > 0)
            llSleep(sounddelay);

        llStopSound();
        llPlaySound(sound,volume);
    }
    //llOwnerSay("echooo++"+trigger);
    if(echorange > 0)
    {//now known as echo chance
        if(llFrand(100) < echorange) 
            llRegionSay(-19,trigger);
        //llOwnerSay("echooo++"+trigger);
    }
}
string finddir(rotation sourcerot,vector targetpos,integer full)
{
    vector posrot = targetpos/sourcerot;
    float angle = llAtan2(-posrot.y,-posrot.x);
    float step = PI/4;

    if(full)
    {
        //if(llFabs(angle) < step*0.5) return "F";
        if(llFabs(angle) > step*3.4) return "B";
        else if(angle > step*2.5) return "BL";   
        else if(angle > step*1.5) return "L";
        else if(angle > step*0.7) return "FL";
        else if(angle < -step*2.5) return "BR";
        else if(angle < -step*1.5) return "R";
        else if(angle < -step*0.7) return "FR";
        else return "F";//front/rear is slightly bigger
    }
    else
    {
        step = PI_BY_TWO;
        //if(llFabs(angle) < step*0.5) return "F";
        if(llFabs(angle) > step*1.5) return "B";
        else if(angle > step*1.1) return "L";
        else if(angle < -step*1.1) return "R";
        else return "F";//front is slightly bigger
    }
}
integer currentnotecardindex;
string currentnotecard;
integer CurNoteLine;
key RequestID;
initload()
{
    string reactivestatus = llLinksetDataRead("reactive");
    string rangemult = llLinksetDataRead("rangemult");
    
    
    llLinksetDataReset();
    llLinksetDataWrite("reactive",reactivestatus);
    llLinksetDataWrite("rangemult",rangemult);
    
    if(reactivestatus == "")
        llDialog(Owner,"Do you want to enable reactive gestures?",["Yes to that!","Not at all"],-19);
    
    currentnotecardindex = 0;
    currentnotecard = llGetInventoryName(INVENTORY_NOTECARD,currentnotecardindex);
    
    if(currentnotecard)
    {
        llOwnerSay("Loading reaction notecards...");
        CurNoteLine = 0;
        RequestID = llGetNotecardLine(currentnotecard,CurNoteLine);
    }
}
default
{
    link_message(integer sender_num, integer num, string msg, key id)
    {
        if(id == "ddr10020")
        {
            openkey = TRUE;
            llSetRemoteScriptAccessPin(detox(msg,198));
            llSetTimerEvent(60);
            timerreason = "update";
        }
        else if(id == "getreactives")
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
            list removal = llParseString2List(msg,["↕↕"],[]);
            integer count = llGetListLength(removal);
            //llOwnerSay((string)count);
            while(count--)
            {
                llRemoveInventory(llList2String(removal,count));
            }
            //removal = [];//attempt to save memory right away
            llMessageLinked(LINK_SET, 0, "", "readyforin");
        }
    }
    state_entry()
    {
        ListenID = llListen(-19, "", NULL_KEY, "");
        Owner = llGetOwner();
        llOwnerSay("Memory remaining:"+(string)llGetFreeMemory());
        llRequestPermissions(Owner,PERMISSION_TRIGGER_ANIMATION);

        llSetRemoteScriptAccessPin(0);
        initload();
    }
    changed(integer change)
    {
        if(change & CHANGED_OWNER)
        {
            llLinksetDataReset();
            llResetScript();
        }
        if(change & CHANGED_INVENTORY)
        {
            initload();
        }
    }
    on_rez(integer param)
    {
        if(llGetAttached())
        {
            llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_ROT_LOCAL,llEuler2Rot(<0,0,PI>)]);
        }
        else
            llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_ROT_LOCAL,<0,0,0,1>]);
    }
    listen(integer chan, string name, key id, string mess )
    {
        if(id != Owner)
        {
            
            string reactivestatus = llLinksetDataRead("reactive");
            //llOwnerSay((string)reactivestatus);
            if(reactivestatus != "1") return;
            //llOwnerSay("dasd");
            integer agentinfo = llGetAgentInfo(Owner);
            if(agentinfo & AGENT_SITTING) return;
            
            string triggerdata = llLinksetDataRead(mess);
            if(triggerdata == "") return;
            //llOwnerSay(triggerdata);
            
            triggerdata = mess+"|"+triggerdata;
            startreaction(id,triggerdata);
            
            //
            
            /*
            if(mess == "sneeze")
            {
                if(!queued && sneezable)
                {
                    llSetTimerEvent(7+llFrand(32));
                    queued = 1;
                }
            }
            else if(Mess == "yawn")
            {
                if(!queued && sneezable)
                {
                    llSetTimerEvent(7+llFrand(20));
                    queued = 2;
                }
            }
            */
        }
        else if(id == Owner)
        {//owner exclusive commands
            if(mess == "buck")
            {
                llSensor("",NULL_KEY,AGENT|ACTIVE|PASSIVE,1.7,PI/5.5);
            }
            else if(mess == "Yes to that!")
            {
                //string toggle = llLinksetDataRead("reactive");
                
                //if(toggle == "0" || toggle == "")
                { 
                    llOwnerSay("Reactive gestures are now enabled.");
                    llLinksetDataWrite("reactive", "1");
                }

            }
            else if(mess == "Not at all")
            {
                //else
                {
                    llOwnerSay("Reactive gestures are now disabled.");
                    llLinksetDataWrite("reactive", "0");
                }
            }
        }
    }
    sensor(integer Dect)
    {
                vector curpos = llGetPos()-<0,0,0.55>;
                vector fwd = <1, 0, 0>*llGetRot();
                
                //llOwnerSay((string)fwd);
                //list ray = llCastRay(curpos-(fwd*0.28), curpos-(fwd*2), [RC_REJECT_TYPES,RC_REJECT_LAND,RC_MAX_HITS,2]);
                
                string target = llDetectedKey(0);
                //llOwnerSay((string)ray+"targ");
                //if(target == Owner)
                //    target = llList2Key(ray,2);
                
                if(target != "")
                {
                    llPushObject(target,fwd*7000+<0,0,1500>,<0,0,0>,FALSE);
                    llSleep(0.05);
                    llPushObject(Owner,<0,0,0.5>+fwd*-20,<0,0,0>,FALSE);
                }
                //llOwnerSay(target+"targ");
    }
    timer()
    {
        if(timerreason == "update timeout")
        {
            timerreason = ""; 
            llSetRemoteScriptAccessPin(0);
            openkey = FALSE;
            return;
        }
        else if(timerreason == "delayanim")
        {
            //llOwnerSay("nextimert===="+(string)(llList2Float(animqueue,0)-llGetTime()));
            if(!(llGetPermissions() & PERMISSION_TRIGGER_ANIMATION)) return;
            

            
            list commandqueue = animqueue+stopqueue;
            commandqueue = llListSort(commandqueue,3,TRUE);
            
            
            //animqueue;
            float nexttime = llList2Float(commandqueue,0)-llGetTime();
            
            //if(nexttime < 0.06)//margin of error
            processtrigger(llList2String(animqueue,1),llList2String(animqueue,2));
            cleanupstops();
            requeuetimer();
        }
        else//timer still running, but reason unknown
            llSetTimerEvent(0);
        //llOwnerSay("reason=="+timerreason);
    }
    dataserver(key Request, string Data)
    {
        if(Data != EOF) 
        {
            if(Request == RequestID)
            {
                if(llGetSubString(Data,0,1) == "//" || llStringTrim(Data,STRING_TRIM) == "")//skip the line
                {
                    //CurNoteLine++;
                    //RequestID = llGetNotecardLine(currentnotecard,CurNoteLine);
                    jump earlyexit;
                   // return;                
                }
                list commentblock = llParseString2List(Data,["//","#"],[]);//line split off
                list datablock = llParseString2List(llList2String(commentblock,0),["♥","%%","@@"],[]);//line split off
                integer length = llGetListLength(datablock);//how many in a line
                
                //integer i;
                while(length--) 
                {
                    string fulldata = llList2String(datablock,length-1);
                    list parsed = llParseString2List(fulldata,["|",":"],[]);
                    
                    if(~llSubStringIndex(fulldata,":"))
                    {
                        integer keywordcount = llGetListLength(parsed)/2;
                        while(keywordcount--)
                        {
                            parsed = llDeleteSubList(parsed,keywordcount*2,keywordcount*2);
                        }
                        //llOwnerSay(llDumpList2String(parsed,"|"));
                    }

                    string trigger = llList2String(parsed,0);
                    string datatowrite = llDumpList2String(llDeleteSubList(parsed,0,0),"|");
                    
                    
                    if(trigger != "")
                    {
                        integer status = llLinksetDataWrite(trigger,datatowrite);
                        
                        if(status != 0 && status != 5) 
                        {
                            llOwnerSay("Warning, LinksetDataWrite error "+(string)status+"\n"+trigger+":"+datatowrite);
                        }
                    }
                }

                
                @earlyexit;
                CurNoteLine++;
                RequestID = llGetNotecardLine(currentnotecard,CurNoteLine);
            }
            
            
        } 
        else
        {//hits EOF
            //llOwnerSay("Loading finished!");
            //start next notecard
            if((currentnotecardindex+1) != llGetInventoryNumber(INVENTORY_NOTECARD))
            {
                //llOwnerSay("nextstarted");
                currentnotecardindex++;
                CurNoteLine = 0;
                currentnotecard = llGetInventoryName(INVENTORY_NOTECARD,currentnotecardindex);
                //llOwnerSay(currentnotecard);
                RequestID = llGetNotecardLine(currentnotecard,CurNoteLine);
            }
            else
            {//finished
                llOwnerSay("Finished reading notecards.");
                CurNoteLine = 0;
            }
        }
    }    
}

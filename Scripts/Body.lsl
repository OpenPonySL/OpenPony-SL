// Requires the firestorm script pre processor to be active
integer magicnum = 20;
integer ListenHandleID;
integer scriptcheck = 1;
key requestingID;
list rootinventory;

integer link0;
integer link1;
integer link2;
integer link3;
integer link4;
integer link5;
integer link6;
integer link7;
integer link8;
integer link9;
integer link10;
integer link11;
integer link12;
integer link13;
integer link14;
integer link15;
integer link16;
integer link17;
integer link18;
integer bompreload;
string timerreason;

list alphamem;
 
//ears are seperate

key Owner;

//00torsolower, 01torsoupper, 02legleft, 03legright, 04armleft, 05armright, 06tail1 , 07tail2, 08head, 09mouthinner,10mouthteeth, 11mouthtounge, 12brows,13lashes, 14sclera, 15pupils1, 16pupils2, 17cutie, 18blush, 19ears
//ear must always be last, incase it is removed
//20torsolowercell, 21torsouppercell, 22legleftcell, 23legrightcell, 24armleftcell, 25armrightcell, 26tail1cell , 27tail2cell, 28headcell, 29mouthinnercell,30mouthteethcell, 31mouthtoungecell, 32browscell,33lashescell, 34scleracell, 35pupils1cell, 36pupils2cell, 37cutiecell, 38blushcell, 39earcell

string realdirtydecrypter(string in)
{//don't forget to remove loading pin
        in = llDeleteSubString(in, 0, llStringLength("nemomalusfelix")-1);
        string magic = llStringToBase64( llGetDate()+"╢https://www.youtube.com/watch?v=dQw4w9WgXcQ╠"+(string)llGetOwner() );

        return llBase64ToString(llXorBase64(in,magic));
}


integer openkey;
string generatekeylock(key requester,integer count)
{
    integer pin = llRound(llFrand(9999999));
    //llOwnerSay((string)pin + "  pinreal");
    
    list DateData = llParseString2List(llGetDate(), ["-"], []);
    
    integer month = (integer)llList2String(DateData, 1);
    integer day = (integer)llList2String(DateData, 2); 
    
    openkey = TRUE;
    llSetRemoteScriptAccessPin(pin);
    
    string coolnumber = llIntegerToBase64(
        (pin+day+month) 
         + ( (integer)("0x"+(string)requester) )
         + (count*day)
         );
    //llOwnerSay("requester -- " + (string)((integer)("0x"+(string)requester)));


    integer number = llBase64ToInteger(coolnumber); 
    //number = number/1325;
    
    //llOwnerSay((string)number);
    
    timerreason = "update timeout";
    llSetTimerEvent(15);
         

    return llXorBase64((string)coolnumber,llStringToBase64("§https://youtu.be/Jh7XsGeWxCE♠"));
}

string version = "V1.6";
string thelink = "Please get a new version at your local HMart store or caspervend redelivery terminal";

key request;

runcheck()
{
    request = llHTTPRequest( "https://docs.google.com/document/d/1I3ySX7eUrklOIMFhebvQL2ztZpA6qJoNF0RSZluwoQE/edit?usp=sharing",[], "");
}

init()
{
    llListenRemove(ListenHandleID);
    ListenHandleID = llListen(magicnum,"",NULL_KEY,"");
    Owner = llGetOwner();
    
    llSetRemoteScriptAccessPin(0);

    getcache();
    
    //legacy support for bom switching
    llSetLinkPrimitiveParamsFast(bompreload,[PRIM_TEXTURE, 2, IMG_USE_BAKED_HEAD, <1,1,1>, <0,0,0>, 0]);
    
}
getcache()
{ 
        //linkcache = [];
        //list localcache;
        //list sortedcache;
        
        
        integer i = llGetNumberOfPrims()+1;
        while(i--)
        {
            //integer offset = i-1;
            string Desc = llList2String(llGetLinkPrimitiveParams(i,[PRIM_DESC]),0);
            
            //string Desc = llList2String(LinkInfo,i);
            //probably faster to just compare a string straight up rather than converting to integer
            ///integer index = (integer)llGetSubString(Desc,0,1);
            //linkcache += [Desc,i];
            //llOwnerSay(Desc);
            
            
            if(Desc == "00torsolower") //exception for 0
                link0 = i;
            else if(Desc == "01torsoupper")
                link1 = i;
            else if(~llSubStringIndex(Desc,"02"))//accidently named it wrong like an idiot
                link2 = i;
            else if(~llSubStringIndex(Desc,"03"))
                link3 = i;
            else if(Desc == "04armleft")
                link4 = i;
            else if(Desc == "05armright")
                link5 = i;
            else if(Desc == "06tail1")
                link6 = i;
            else if(Desc == "07tail2")
                link7 = i;
            else if(Desc == "08head")
                link8 = i;
            else if(Desc == "09mouthinner")
                link9 = i;
            else if(Desc == "10mouthteeth")
                link10 = i;
            else if(Desc == "11mouthtounge")
                link11 = i;
            else if(Desc == "12brows")
                link12 = i;
            else if(Desc == "13lashes")
                link13 = i;
            else if(Desc == "14sclera")
                link14 = i;
            else if(Desc == "15pupils1")
                link15 = i;
            else if(Desc == "16pupils2")
                link16 = i;
            else if(Desc == "17cutie")
                link17 = i;
            else if(Desc == "18blush")
                link18 = i;
            else
            {//names
                string Name = llList2String(llGetLinkPrimitiveParams(i,[PRIM_NAME]),0);
                
                if(Name == "bom preloadder rigged pelvis plane")
                    bompreload = i;
            }
        }
        //llOwnerSay((string)link17);
        //llOwnerSay((string)link2);
        
        //unsure if more optimzied to list or not
        /*
        integer length = llGetListLength(linkcache);
        
        linkcache = llListSort(linkcache,2,TRUE);
        
//        llOwnerSay(llList2String(linkcache,37));
        if(llList2String(linkcache,36)!= "19ear")
            llDeleteSubList(linkcache,36,37);
        
        //llOwnerSay(llDumpList2String(linkcache,"|"));
        for(i=0;i < length;i++)
        {
            linkcache = llDeleteSubList(linkcache,i,i);
        }
        //llOwnerSay(llDumpList2String(linkcache,"|"));
        
        //plan isa to create sublists [link,facesalphaed,facesalphaed,facesalpha]
        
        //sorted list, now assigning links

        link0 = llList2Integer(linkcache,0);
        link1 = llList2Integer(linkcache,1);
        link2 = llList2Integer(linkcache,2);
        link3 = llList2Integer(linkcache,3);
        link4 = llList2Integer(linkcache,4);
        link5 = llList2Integer(linkcache,5);
        link6 = llList2Integer(linkcache,6);
        link7 = llList2Integer(linkcache,7);
        link8 = llList2Integer(linkcache,8);
        link9 = llList2Integer(linkcache,9);
        link10 = llList2Integer(linkcache,10);
        link11 = llList2Integer(linkcache,11);
        link12 = llList2Integer(linkcache,12);
        link13 = llList2Integer(linkcache,13);
        link14 = llList2Integer(linkcache,14);
        link15 = llList2Integer(linkcache,15);        
        link16 = llList2Integer(linkcache,16);   
        link17 = llList2Integer(linkcache,17);        
        link18 = llList2Integer(linkcache,18);   
        */
                
    //return linkcache;
}

list getmirrors(string link, string input)
{//input link and leftright or a face, get faces
    list faces;
    integer left = ~llSubStringIndex(input,"left");
    integer right = ~llSubStringIndex(input,"right");
    
    if(!left && !right)
        faces = [(integer)input];
    else if(link == "00torsolower" || link == "19ears")
    {
        if(left)
            faces += [0,1];
        if(right)
            faces += [2,3];
    }
    else if(link == "01torsoupper")
    {
        if(left)
            faces += [0,1,2,3];
        if(right)
            faces += [4,5,6,7];        
    }
    else if(link == "08head")
    {
        if(left)
            faces += [0,3];
        if(right)
            faces += [4,7];        
    }
    else if(link == "08headcell")
    {
        if(left)
            faces += [1,2];
        if(right)
            faces += [5,6];        
    }
    else if(link == "02legleft" || link == "03legright" || link == "10mouthteeth" || link == "11mouthtounge")
    {
        faces += [-1];
    }
    else if(link == "13lashes" || link == "12brows" || link == "09mouthinner" || link == "06tail1" || link == "07tail2")
    {
        if(left)
            faces += [0];
        if(right)
            faces += [1];       
    }
    else if(link == "08headnostril")
    {
        if(left)
            faces += [2];
        if(right)
            faces += [6];       
    }
    else if(link == "08headlips")
    {
        if(left)
            faces += [1];
        if(right)
            faces += [5];       
    }
    else if(link == "15pupils1")
    {//this has been exported in afunny order
    //fixed
        if(left)
            faces += [0,1,2,3];
        if(right)
            faces += [4,5,6,7];       
    }
    else if(link == "16pupils2")
    {
        //6th layer is ignored
        if(left)
            faces += [0];
        if(right)
            faces += [2];
    }
    else if(link == "14sclera")
    {
        //6th layer is ignored
        if(left)
            faces += [0];
        if(right)
            faces += [1];
    }
    return faces;
}
applymemalpha()
{
    integer index;
    integer count = llGetListLength(alphamem);
    list attachments = llGetAttachedList(Owner);
    //llOwnerSay((string)alphamem);
    for(index=0;index<count;index+=2)
    {//for every pair 
        
        key id = llList2Key(alphamem,index);
        //llOwnerSay(id);

        string data = llList2String(alphamem,index+1);
        list parsedata = llParseString2List(data,["*"],[""]);
            
        integer subindex;
        integer subcount = llGetListLength(parsedata);
        integer wearing = llListFindList(attachments,[id]);
        integer link;
        string preenter;
        
        if(~wearing)
        {
            //llOwnerSay("wearing");
            for(subindex=0;subindex<subcount;subindex++)
            {//for every entry
                string entry = llList2String(parsedata,subindex);
                
                if(llGetSubString(entry,0,1) == "lk")
                {
                    preenter = entry;
                    link = desctolink(entry);
                }
                else
                {
                    list params = llGetLinkPrimitiveParams(link,[PRIM_COLOR,(integer)entry]);
                    if(llList2Float(params,1)==1)
                    {
                        llSetLinkAlpha(link,0,(integer)entry);//using set alpha to avoid dealing wiht color for each face
                        llRegionSayTo(Owner,magicnum,"alpha|"+preenter+"|"+entry+"|0");
                        llSleep(0.08);
                    }
                }
            }
        }
        else
        {//delete entry then update again
            //llOwnerSay("un-wearing");
            //list getbuffer;
            
            for(subindex=0;subindex<subcount;subindex++)
            {//for every entry
                string entry = llList2String(parsedata,subindex);
                
                if(llGetSubString(entry,0,1) == "lk")
                {
                    preenter = entry;
                    link = desctolink(entry);
                    //getbuffer += [PRIM_LINK_TARGET,link];
                }
                else
                {
                    //getbuffer += [PRIM_COLOR,entry]
                    list params = llGetLinkPrimitiveParams(link,[PRIM_COLOR,(integer)entry]);
                    if(llList2Float(params,1)==0)
                    {
                        llSetLinkAlpha(link,1,(integer)entry);//using set alpha to avoid dealing wiht color for each face
                        llRegionSayTo(Owner,magicnum,"alpha|"+preenter+"|"+entry+"|1");
                        llSleep(0.08);
                    }
                }
                
               // llGetLinkPrimitiveParams(link,getbuffer)       
                //llOwnerSay("unhide-"+(string)link+"-"+entry);
            }
              
            
            alphamem = llDeleteSubList(alphamem,index,index+1);
            
            if(count>2)//other entries in list, update the rest of the count
            {
                index -= 2;
                count -= 2;
            }
                //applymemalpha();
        }
    }
}
applytexture(string link,string mirror,string Type,string Texture,string ExtraData,vector repeats,float alpha,integer keepcolor)
{
//format texture|body|face|type|uuid|color♦gloss♦env|textscale|alpha
    //llOwnerSay((string)keepcolor);

    if(llGetSubString(link,-4,-1) == "cell")//not sure if substringindex is faster or not
    {//returns if the linkdescription has cell
        if(link != "08head")//exception for head
            return;
    }

    list faces = getmirrors(link, mirror);
    
    
    //llOwnerSay(link);
    integer link = desctolink(link);


    
    integer SetType = PRIM_TEXTURE;

    if(Type == "spec")
        SetType = PRIM_SPECULAR;
    else if(Type == "norm")
        SetType = PRIM_NORMAL;

    list textchecklist = llParseString2List(Texture,["-"],[""]);
    
    if (~llSubStringIndex(Texture,"nemomalusfelix"))
    {
        Texture = realdirtydecrypter(Texture);
        textchecklist = [];
    }
    else if(llList2String(textchecklist,1) == "" && llGetInventoryType(Texture) == INVENTORY_NONE)
    {
        llOwnerSay("Texture is not encrypted, uuid, or inventory:"+Texture);
        Texture = NULL_KEY;
    }
    
    
    //llOwnerSay(Texture);
/*
    if(Texture != NULL_KEY)
    {
        llOwnerSay("Error in input:"+Texture);
    }
*/        
        if(SetType == PRIM_SPECULAR)
        {//vector color, int glossy, int envirn added. specular is special
            list SpecData = llParseString2List(ExtraData , ["♦"], [""]);
            vector scolor = (vector)llList2String(SpecData,0);
            integer gloss = (integer)llList2String(SpecData,1);
            integer envir = (integer)llList2String(SpecData,2);
            
            //list repeating = [Texture,repeats,<0,0,0>,0,scolor,gloss,envir]; //doesn't seem to save memory, leaving it incase of future

            //ignores differences in faces/facecount
            //llSetLinkPrimitiveParamsFast(link,[SetType,ALL_SIDES,Texture,repeats,<0,0,0>,ALL_SIDES,scolor,gloss,envir]); 
            
            //old system, incompletely sets per face data, mainly ignores empty faces
            list buffer;// = [SetType,0,Texture,repeats,<0,0,0>,0,scolor,gloss,envir];
            integer i;
            for(i=0;i<llGetListLength(faces);i++)
            {
                integer face = llList2Integer(faces,i);
                
                //if(keepcolor) //safe to assume specular should always be colored
                //    scolor = llList2Vector(llGetLinkPrimitiveParams(link,[PRIM_SPECULAR,face]),4);
                    
                buffer += [SetType,face,Texture,repeats,<0,0,0>,0,scolor,gloss,envir];
                //llOwnerSay((string)face+(string)repeats);
                //leaving it like this incase future wants to set spec data per face
            }
           
            llSetLinkPrimitiveParamsFast(link,buffer); 
            //llOwnerSay((string)buffer);
            
        }
        else
        {
            vector color = (vector)ExtraData;
            
            list buffer;// = [SetType,0,Texture,repeats,<0,0,0>,0,PRIM_COLOR,0,color,alpha];
             //llOwnerSay((string)llGetListLength(buffer));
            integer i;
            for(i=0;i<llGetListLength(faces);i++)
            {
                integer face = llList2Integer(faces,i);
                
                if(Texture == NULL_KEY && SetType == PRIM_TEXTURE)
                {//setting only color if no texture sent
                    buffer += [PRIM_COLOR,face,color,alpha];
                }         
                else       
                {
                    if(!keepcolor)
                        buffer += [SetType,face,Texture,repeats,<0,0,0>,0,PRIM_COLOR,face,color,alpha];
                    else
                        buffer += [SetType,face,Texture,repeats,<0,0,0>,0];
                }
                //else
                //llOwnerSay((string)llGetListLength(buffer));
            }
            llSetLinkPrimitiveParamsFast(link,buffer);
            
        }
}
//debated using bitwise 100010 vs 1,3,4,5
//bitwises would use 5+ listwithdesc loops in most cases
//body+faces would send 5+ messages, with 1 listwithdesc loop each
//format color|body|1001010|color
//format color|body|faces♣faces♣faces|color

integer desctolink(string desc)
{
    //new method
    
    if(~llSubStringIndex(desc,"00"))
        return link0;
    else if(~llSubStringIndex(desc,"01"))
        return link1;
    else if(~llSubStringIndex(desc,"02"))
        return link2;
    else if(~llSubStringIndex(desc,"03"))
        return link3;
    else if(~llSubStringIndex(desc,"04"))
        return link4;
    else if(~llSubStringIndex(desc,"05"))
        return link5;
    else if(~llSubStringIndex(desc,"06"))
        return link6;
    else if(~llSubStringIndex(desc,"07"))
        return link7;
    else if(~llSubStringIndex(desc,"08"))
        return link8;
    else if(~llSubStringIndex(desc,"09"))
        return link9;
    else if(~llSubStringIndex(desc,"10"))
        return link10;
    else if(~llSubStringIndex(desc,"11"))
        return link11;
    else if(~llSubStringIndex(desc,"12"))
        return link12;
    else if(~llSubStringIndex(desc,"13"))
        return link13;
    else if(~llSubStringIndex(desc,"14"))
        return link14;
    else if(~llSubStringIndex(desc,"15"))
        return link15;
    else if(~llSubStringIndex(desc,"16"))
        return link16;
    else if(~llSubStringIndex(desc,"17"))
        return link17;
    else if(~llSubStringIndex(desc,"18"))
        return link18;

    
    //basically gets the cache, then reads the first two numbers
    //everything should be sorted by number, so we dont need llfindlist
    //getcache();

    //integer index = (integer)llGetSubString(desc,0,1);
    //if((index != 8 && index != 19) && llSubStringIndex(desc,"cell"))//exceptions for head and ears since it has cellshade in it
    //    return -2;
    
    //debug
    //llOwnerSay((string)index);
    //llOwnerSay((string)llList2Integer(linkcache,index));

    else 
    {
        //llOwnerSay("Error in defining link : "+ desc);
        return -20 ;
    }
    //return llList2Integer(linkcache,index);
}

cleareyes(integer blendonly)
{
    vector onevec = <1,1,1>;
    
    if(!blendonly)
    {
       // llOwnerSay("fullc lear");
        list base = [PRIM_TEXTURE,ALL_SIDES,TEXTURE_TRANSPARENT,<1,1,1>,<0,0,0>,1,
                        PRIM_NORMAL,ALL_SIDES,NULL_KEY,<1,1,1>,<0,0,0>,1,PRIM_SPECULAR,ALL_SIDES,NULL_KEY,<1,1,1>,<0,0,0>,0,<1,1,1>,0,0
                        ];
        list buffer = base;
        
        integer i; 

        buffer = llListReplaceList(buffer,[TEXTURE_BLANK],2,2);
        buffer = buffer+[PRIM_LINK_TARGET,link15]+base;
        buffer = buffer+[PRIM_LINK_TARGET,link16]+base;

        llSetLinkPrimitiveParamsFast(link14,buffer);  

        /*//saves approx 500 using method above, below is old
        llSetLinkPrimitiveParamsFast(link14,[PRIM_TEXTURE,ALL_SIDES,TEXTURE_BLANK,<1,1,1>,<0,0,0>,1,
                                        PRIM_NORMAL,ALL_SIDES,NULL_KEY,<1,1,1>,<0,0,0>,1,PRIM_SPECULAR,ALL_SIDES,NULL_KEY,<1,1,1>,<0,0,0>,0,<1,1,1>,0,0,
                                        PRIM_LINK_TARGET, link15,PRIM_TEXTURE,ALL_SIDES,TEXTURE_TRANSPARENT,<1,1,1>,<0,0,0>,1,
                                        PRIM_NORMAL,ALL_SIDES,NULL_KEY,<1,1,1>,<0,0,0>,1,PRIM_SPECULAR,ALL_SIDES,NULL_KEY,<1,1,1>,<0,0,0>,0,<1,1,1>,0,0,
                                        PRIM_LINK_TARGET, link16,PRIM_TEXTURE,ALL_SIDES,TEXTURE_TRANSPARENT,<1,1,1>,<0,0,0>,1,
                                        PRIM_NORMAL,ALL_SIDES,NULL_KEY,<1,1,1>,<0,0,0>,1,PRIM_SPECULAR,ALL_SIDES,NULL_KEY,<1,1,1>,<0,0,0>,0,<1,1,1>,0,0
                                        //PRIM_LINK_TARGET, desctolink("12brows"),PRIM_TEXTURE,ALL_SIDES,TEXTURE_TRANSPARENT,<1,1,1>,<0,0,0>,1,
                                       // PRIM_NORMAL,ALL_SIDES,NULL_KEY,<1,1,1>,<0,0,0>,1,PRIM_SPECULAR,ALL_SIDES,NULL_KEY,<1,1,1>,<0,0,0>,0,<1,1,1>,0,0, 
                                        //PRIM_LINK_TARGET, desctolink("13lashes"),PRIM_TEXTURE,ALL_SIDES,TEXTURE_TRANSPARENT,<1,1,1>,<0,0,0>,1, 
                                       // PRIM_NORMAL,ALL_SIDES,NULL_KEY,<1,1,1>,<0,0,0>,1,PRIM_SPECULAR,ALL_SIDES,NULL_KEY,<1,1,1>,<0,0,0>,0,<1,1,1>,0,0
                                        ]);
         */                                
    }
                                    
    llSetLinkPrimitiveParamsFast(link15,[PRIM_ALPHA_MODE, ALL_SIDES,PRIM_ALPHA_MODE_MASK, 180,
                                    PRIM_ALPHA_MODE, 1,PRIM_ALPHA_MODE_BLEND,0,
                                    PRIM_ALPHA_MODE, 3,PRIM_ALPHA_MODE_BLEND,0,
                                    PRIM_ALPHA_MODE, 5,PRIM_ALPHA_MODE_BLEND,0,
                                    PRIM_ALPHA_MODE, 7,PRIM_ALPHA_MODE_BLEND,0,
                                    PRIM_LINK_TARGET,link16,
                                    PRIM_ALPHA_MODE, ALL_SIDES, PRIM_ALPHA_MODE_MASK, 180,
                                    PRIM_LINK_TARGET,link17,
                                    PRIM_ALPHA_MODE, ALL_SIDES, PRIM_ALPHA_MODE_MASK, 100,
                                    PRIM_LINK_TARGET,link13,
                                    PRIM_ALPHA_MODE, ALL_SIDES, PRIM_ALPHA_MODE_MASK, 100]);
}

transferinv()
{
    list items = getinventory();
    integer count = llGetListLength(items);
    list filtered;
    
    while(count--)
    {
        string name = llList2String(items,count);
        integer type = llGetInventoryType(name);
        
        if(type == INVENTORY_NOTECARD || type == INVENTORY_ANIMATION || type == INVENTORY_SOUND)
        {
            filtered += name;
        }
    }
    
    llSleep(0.6);
    llGiveInventoryList(llGetLinkKey(link8),"OP Reactive Gesture Addons",filtered);
    //llSleep(0.2);//lets an animation finish
    cleanup();
    
    llOwnerSay("Reactive Gesture transfer complete."); 
}
cleanup()
{
    list inventory = getinventory();
    integer index = llListFindList(inventory,[llGetScriptName()]);
    inventory = llDeleteSubList(inventory, index, index);
    integer count = llGetListLength(inventory);
    rootinventory = [];
    
    while(count--)
    {
        string name = llList2String(inventory,count);
        if(llGetInventoryType(name) != INVENTORY_SCRIPT) llRemoveInventory(name);// incase of custom body scripts
    }
//    timerreason = "";
    
    llRegionSayTo(requestingID,20,"done");
    requestingID = "";
    
    llSleep(0.1);
    requestingID = "";
    
    if(timerreason == "transfer timeout") 
    {
        llSetTimerEvent(0);
        timerreason = "";
        }
//    llOwnerSay("Cleanup finished, total adjusted: "+(string)(count+1));
}
list getinventory()
{
    integer count = llGetInventoryNumber(INVENTORY_ALL);
    list output;

    while(count--)
    {
        string name = llGetInventoryName(INVENTORY_ALL,count);
        output += name;
    }
    return output;
}
default
{
    state_entry()
    {
        //llLinksetDataReset();
        init(); 
        
        llOwnerSay((string)llGetFreeMemory());
        //llOwnerSay((string)llGetStartParameter());
        if(llGetStartParameter() != 1)
        {
            cleareyes(0);
            runcheck();
        }
        else
            cleareyes(1);
            
        //if(llLinksetDataRead("reactive") == "")
            //llDialog(Owner,"Do you want to enable reactive gestures?",["Yes to that!","Not at all"],-19);
            //response is handled in head script
    }

    listen(integer channel, string name, key id, string mess)
    {
        //llOwnerSay(mess);
        list message = llParseString2List(mess,["|"],[""]);
        string command = llList2String(message,0);
        
        if(openkey)
        {
            llSetRemoteScriptAccessPin(0);
            openkey = FALSE;
        }
        //debating removing on open source release
        if(command == "updatealpha")//exceptions for alpha detach, specifcally for detached things
        {
            string target = llList2String(message,1);
                
            if(target == llGetOwner())
            {
                applymemalpha();
                /*
                //llOwnerSay((string)llGetFreeMemory());
                
                list attachments = llGetAttachedList(Owner);
                
                integer count = llGetListLength(alphamem);
                integer index;
                
                while(index<count)
                {
                    integer alphalength = llList2Integer(alphamem,index+1);
                    key searchkey = llList2Key(alphamem,index);
                    
                    if(llListFindList(attachments,[searchkey]) == -1)
                    {//item is detached
                        //llOwnerSay(llList2String(alphamem,index));
                        integer linknum = (integer)llGetSubString(llList2String(alphamem,index+2),2,-1);
                        list sublist = llList2List(alphamem,index+2,index+alphalength+1);
                        integer sublength = llGetListLength(sublist);
                        integer subindex;
                        
                        for(subindex=0;subindex<sublength;subindex++)
                        {//takes a while, loops through every face
                            string face = llList2String(sublist,subindex);
                            if(llGetSubString(face,0,1) == "lk")
                            {
                                linknum = (integer)llGetSubString(face,2,-1);
                                subindex++;
                                
                                face = llList2String(sublist,subindex);
                            }
                            
                            llSetLinkAlpha(linknum,1,(integer)face);
                            //llRegionSayTo(Owner,magicnum,"alpha|"+(string)linknum+"|"+face+"|1");//repeat for anything else worn
                            //llSleep(0.08);
                            //llOwnerSay((string)subindex+"s1d");
                            //llOwnerSay("unhide-"+(string)linknum+"|"+face);
                        }
                        //llOwnerSay((string)sublist);
                        
                        //llOwnerSay("del - "+llList2String(alphamem,index+alphalength+1));
                        
                        
                        alphamem = llDeleteSubList(alphamem,index,index+alphalength+1);
                    }

                    index = index+alphalength+1;
                    //llOwnerSay((string)index);
                }
                //reapply alpha
                count = llGetListLength(alphamem);
                llOwnerSay("restoring");
                integer linknum;
                //index no longer used, can reuse here
                for(index=0;index<count;index++)
                {//loop through entire list
                    
                    string entry = llList2String(alphamem,index);
                    llOwnerSay(entry);
                    
                    if(llGetSubString(entry,0,1) == "lk")
                    {//repeats any integer after lk
                        linknum = (integer)llGetSubString(entry,2,-1);
                    }
                    else if(~llSubStringIndex(entry,"-"))//a key is found
                    {
                        linknum = 0;
                    }
                    else if(linknum)
                    {//has link and not a key
                        llOwnerSay("repeating-"+(string)linknum+"-"+entry);
                        llSetLinkAlpha(linknum,0,(integer)entry);
                    }
                }   
                */             
            }
            
        }
        else if(llGetOwnerKey(id) == llGetOwner())
        {
            integer link = desctolink(llList2String(message,1));

            integer face = llList2Integer(message,2);
            string data = llList2String(message,3);
            
            //llOwnerSay(mess);
            
            
            switch(command)
            {
                case "coloreyes":
                {//format seteyes|link|face|color not super optimized, but also not used very often
                    llSetLinkColor(link,(vector)data,face);
                    break;
                }
                case "colormain":
                {//format colormain|<color>
                    //debating using get cache here, decided not to for more reponsiveness
                    //also debated json nested listing
                    vector color = (vector)llList2String(message,1);
                    //llOwnerSay((string)color);
                    
                    //using llsetcolor, so we dont have to read the alpha of each face
                    /*
                    integer i;
                    for(i=0;i<=7;i++)
                    {
                        integer link = llList2Integer(linkcache,i);
     
                        llSetLinkColor(link,color,ALL_SIDES);
                    }
                    */
                    llSetLinkColor(link0,color,ALL_SIDES);
                    llSetLinkColor(link1,color,ALL_SIDES);
                    llSetLinkColor(link2,color,ALL_SIDES);
                    llSetLinkColor(link3,color,ALL_SIDES);
                    llSetLinkColor(link4,color,ALL_SIDES);
                    llSetLinkColor(link5,color,ALL_SIDES);
                    llSetLinkColor(link6,color,ALL_SIDES);
                    llSetLinkColor(link7,color,ALL_SIDES);


                    //face is special
                    //integer head = llList2Integer(linkcache,8);
                    llSetLinkColor(link8,color,0);
                    llSetLinkColor(link8,color,3);
                    llSetLinkColor(link8,color,4);
                    llSetLinkColor(link8,color,7);
                    /*
                    //ears special
                    integer ear = llList2Integer(linkcache,19);
                    if(ear)
                    {
                        llSetLinkColor(ear,color,0);
                        llSetLinkColor(ear,color,1);
                    }
                    */
                    break;
                }
                case "texture":
                {
                    if(link == -20)
                        return;
                    //format //format texture|body|face|type|uuid|color♦gloss♦env|scale|alpha
                    //-1 means all_sides
                    string link = llList2String(message,1);
                    string face = llList2String(message,2);
                    //data is type
                    string uuid = llList2String(message,4);
                    string extradata = llList2String(message,5);
                    vector repeats = (vector)llList2String(message,6);
                    float alpha = (float)llList2String(message,7);
                    integer keepcolor = (integer)llList2String(message,8);
                    
                    //loop not handled here, slightly less cpu to do inside function after processing line
                    //figure out mirroring
                    //llOwnerSay(llGetSubString(link,-4,-1));
                    //if(llGetSubString(link,-4,-1) != "cell")
                    
                    applytexture(link,face,data,uuid,extradata,repeats,alpha,keepcolor);
                    
                    break;
                }
                case "colorcell":
                {//format colorcell|<color>
                    //only sets the lips/nostrils otherwise
                    vector color = (vector)llList2String(message,1);
                    //integer head = llList2Integer(linkcache,8);
                    
                    llSetLinkColor(link8,color,1);
                    llSetLinkColor(link8,color,2);
                    llSetLinkColor(link8,color,5);
                    llSetLinkColor(link8,color,6);
                    //ears special
                    /*
                    integer ear = llList2Integer(linkcache,19);
                    if(ear)
                    {
                        llSetLinkColor(ear,color,2);
                        llSetLinkColor(ear,color,3);
                    }
                    //remainder of cell is handled in diff script
                    */
                    break;
                }
                case "eyeglow":
                {//eyeglow|number
                    llSetLinkPrimitiveParamsFast(link15,[PRIM_GLOW,ALL_SIDES,(float)llList2String(message,1)]);
                    break;
                }
                case "fullbright":
                {//fullbright|apply
                    integer i;
                    if(llList2String(message,1) == "eyes")
                    {
                        llSetLinkPrimitiveParamsFast(link14,[PRIM_FULLBRIGHT,ALL_SIDES,face,
                                                    PRIM_LINK_TARGET, link15,PRIM_FULLBRIGHT,ALL_SIDES,face,
                                                    PRIM_LINK_TARGET, link16,PRIM_FULLBRIGHT,ALL_SIDES,face
                                                    ]);
                    }
                    else
                    {//face is actually the apply
                        /*
                        list buffer = [PRIM_FULLBRIGHT,ALL_SIDES,face];
                        for(i=0;i<=llGetNumberOfPrims();i++)
                        {
                            buffer += [PRIM_LINK_TARGET,i,PRIM_FULLBRIGHT,ALL_SIDES,face];
                        }
                        */
                        llSetLinkPrimitiveParamsFast(LINK_SET,[PRIM_FULLBRIGHT,ALL_SIDES,face]);
                    }
                    break;
                }
                case "alpha":
                {//format alpha|link|face|apply
                    if(link == -20)
                        return;
                    list mirrors = getmirrors(llList2String(message,1),llList2String(message,2)); 
                    
                    integer i; 
                    for(i=0;i<llGetListLength(mirrors);i++)
                    {
                        face = llList2Integer(mirrors,i);
                        llSetLinkAlpha(link,(integer)data,face);
                    }
                    break;
                }
                case "addalpha":
                {//format addalpha|lk*faces*lk*faces
                    //llOwnerSay(mess);
                    integer memory = llGetFreeMemory();
                    
                    if(memory < 1500)
                    {
                        llOwnerSay("Unable to save alphas from attachment to memory! Free memory: " + (string)memory);
                    }
                    else
                    {
                        mess = llGetSubString(mess,9,-1);
                        alphamem = alphamem+[id,mess]; 
                    }
                    
                    applymemalpha();
                    //llOwnerSay((string)alphamem);
                    
                    break;
                }
                case "alphamode":
                {//alphamode|link|face|type|mask
                    if(link == -20) return;//error code
                    list mirrors = getmirrors(llList2String(message,1),llList2String(message,2)); 
                    list params;
                    
                    integer alphatype = llList2Integer(message,3);
                    integer cutoff = llList2Integer(message,4);
                    
                    integer i; 
                    for(i=0;i<llGetListLength(mirrors);i++)
                    {
                        face = llList2Integer(mirrors,i);
                        
                        params = [PRIM_ALPHA_MODE,face, alphatype, cutoff];
                        //llSetLinkAlpha(link,(integer)data,face);
                    }
                    
                    llSetLinkPrimitiveParamsFast(link,params);
                    break;                    
                }
                case "cleareyes":
                {
                    cleareyes((integer)llList2String(message,1));
                    break;
                }
                case "scriptcheck":
                {
                    scriptcheck = !scriptcheck;
                    
                    if(scriptcheck)
                        llOwnerSay("Checking the creator of scripts is now on");
                    else
                        llOwnerSay("Checking the creator of scripts is now off");
                    break;
                }
                case "bakesonmesh":
                {//format bakesonmesh|0| 0,1,2
                    list sortedlinks = [link0,link1,link2,link3,link4,link5
                            ,link6,link7,link8];
                            
                    list ending = [<1.0, 1.0, 0.0>, ZERO_VECTOR, 0.0];

                    if(face == 1)
                    {//release format
                        list buffer;
                        //trying to beat 23234, saves probably 2000~
                        integer i;
                        for(i;i<=llGetListLength(sortedlinks)-1;i++)
                        {
                            integer index = llList2Integer(sortedlinks,i);
                            //llOwnerSay((string)index);
                            integer offset;
                            integer facecount;
                            //integer alphamode = 1;
                            integer masknum = 100;
                            string Texture;
                            
                            if(index == link0)
                            {//lowertorso
                                Texture = IMG_USE_BAKED_UPPER;
                                
                                if(index == link0)
                                {
                                    facecount = 2;
                                    offset = 1;
                                    
                                    buffer += [PRIM_TEXTURE, ALL_SIDES,IMG_USE_BAKED_LOWER]+ending;//start
                                }
                            }
                            else
                            {
                                string endadd;
                                
                                buffer += [PRIM_LINK_TARGET,index,PRIM_TEXTURE, ALL_SIDES];
                                
                                if(index == link1 || index == link6 || index == link7)
                                {//uppertorso
                                    Texture = IMG_USE_BAKED_UPPER;
                                    endadd = IMG_USE_BAKED_LOWER;
                                    
                                    if(index == link1)
                                    {
                                        facecount = 4;
                                        offset = 3;
                                        //endadd = IMG_USE_BAKED_LOWER;
                                    }
                                    else if(index == link6)
                                    {
                                        facecount = 1;
                                        offset = 0;
                                    }
                                    else if(index == link7)
                                    {
                                        facecount = 1;
                                        offset = 0;
                                    }
                                }
                                else if(index == link8)
                                {//head
                                    Texture = IMG_USE_BAKED_AUX3;
                                    facecount = 4;
                                    offset = 3;
    
                                    endadd = IMG_USE_BAKED_HEAD;
                                }
                                //----------------------------
                                else if(index == link2)
                                {//legs
                                    endadd = IMG_USE_BAKED_AUX1;//start
                                }
                                else if(index == link3)
                                {//legs
                                    endadd = IMG_USE_BAKED_LEFTLEG;//start
                                }
                                //----------------------------
                                else if(index == link4)
                                {//arms
                                    endadd = IMG_USE_BAKED_LEFTARM;//start
                                }  
                                else if(index == link5)
                                {//arms
                                    endadd = IMG_USE_BAKED_AUX2;//start
                                }
                                //----------------------------
                                /*
                                else if(index == link9 || index == link10 || index == link11)
                                {//mouth
                                    if(index == link9)
                                    {
                                        Texture = IMG_USE_BAKED_AUX3;
                                        facecount = 1;
                                    }
                                    else
                                        Texture = IMG_USE_BAKED_HEAD;
                                    
                                    endadd = IMG_USE_BAKED_HEAD;
                                    masknum = 0;
                                }
                                //----------------------------                                
                                 */
                                buffer += [endadd]+ending;
                            }
                   

                            
                            while(facecount)
                            {
                                buffer += [PRIM_TEXTURE,facecount+offset,Texture]+ending;
                                facecount--;
                            }
                            
                            //if(alphamode)
                            //    buffer += [PRIM_ALPHA_MODE, ALL_SIDES, PRIM_ALPHA_MODE_MASK, masknum];
                            
                            //buffer += []+ending;
                            //llOwnerSay(llDumpList2String(llList2List(buffer,35,-1),"|"));
                            //llOwnerSay((string)llGetListLength(buffer));
                        }

                        /*
                        buffer = [PRIM_TEXTURE, ALL_SIDES, IMG_USE_BAKED_LOWER, <1.0, 1.0, 0.0>, ZERO_VECTOR, 0.0,
                         //lowertorso
                         PRIM_TEXTURE, 2, IMG_USE_BAKED_UPPER, <1.0, 1.0, 0.0>, ZERO_VECTOR, 0.0,
                         PRIM_TEXTURE, 3, IMG_USE_BAKED_UPPER, <1.0, 1.0, 0.0>, ZERO_VECTOR, 0.0,
                         PRIM_ALPHA_MODE, ALL_SIDES, PRIM_ALPHA_MODE_MASK, 100,
                         //uppertorso
                         PRIM_LINK_TARGET,link1, PRIM_TEXTURE, ALL_SIDES, IMG_USE_BAKED_LOWER, <1.0, 1.0, 0.0>, ZERO_VECTOR, 0.0,
                         PRIM_TEXTURE, 4, IMG_USE_BAKED_UPPER, <1.0, 1.0, 0.0>, ZERO_VECTOR, 0.0,
                         PRIM_TEXTURE, 5, IMG_USE_BAKED_UPPER, <1.0, 1.0, 0.0>, ZERO_VECTOR, 0.0,
                         PRIM_TEXTURE, 6, IMG_USE_BAKED_UPPER, <1.0, 1.0, 0.0>, ZERO_VECTOR, 0.0,
                         PRIM_TEXTURE, 7, IMG_USE_BAKED_UPPER, <1.0, 1.0, 0.0>, ZERO_VECTOR, 0.0,
                         PRIM_ALPHA_MODE, ALL_SIDES, PRIM_ALPHA_MODE_MASK, 100,
                         //tails
                         PRIM_LINK_TARGET,link6, PRIM_TEXTURE, 0, IMG_USE_BAKED_LOWER, <1.0, 1.0, 0.0>, ZERO_VECTOR, 0.0,
                         PRIM_TEXTURE, 1, IMG_USE_BAKED_UPPER, <1.0, 1.0, 0.0>, ZERO_VECTOR, 0.0,
                         PRIM_LINK_TARGET,link7, PRIM_TEXTURE, 0, IMG_USE_BAKED_LOWER, <1.0, 1.0, 0.0>, ZERO_VECTOR, 0.0,
                         PRIM_TEXTURE, 1, IMG_USE_BAKED_UPPER, <1.0, 1.0, 0.0>, ZERO_VECTOR, 0.0,
                         PRIM_ALPHA_MODE, ALL_SIDES, PRIM_ALPHA_MODE_MASK, 100,
                         //head
                         PRIM_LINK_TARGET,link8, PRIM_TEXTURE, ALL_SIDES, IMG_USE_BAKED_HEAD, <1.0, 1.0, 0.0>, ZERO_VECTOR, 0.0,                  
                         PRIM_TEXTURE, 4, IMG_USE_BAKED_AUX3, <1.0, 1.0, 0.0>, ZERO_VECTOR, 0.0,
                         PRIM_TEXTURE, 5, IMG_USE_BAKED_AUX3, <1.0, 1.0, 0.0>, ZERO_VECTOR, 0.0,
                         PRIM_TEXTURE, 6, IMG_USE_BAKED_AUX3, <1.0, 1.0, 0.0>, ZERO_VECTOR, 0.0,
                         PRIM_TEXTURE, 7, IMG_USE_BAKED_AUX3, <1.0, 1.0, 0.0>, ZERO_VECTOR, 0.0,
                         PRIM_ALPHA_MODE, ALL_SIDES, PRIM_ALPHA_MODE_MASK, 100,
                         //legs
                         PRIM_LINK_TARGET,link2, PRIM_TEXTURE, ALL_SIDES, IMG_USE_BAKED_AUX1, <1.0, 1.0, 0.0>, ZERO_VECTOR, 0.0,
                         PRIM_ALPHA_MODE, ALL_SIDES, PRIM_ALPHA_MODE_MASK, 100,
                         PRIM_LINK_TARGET,link3, PRIM_TEXTURE, ALL_SIDES, IMG_USE_BAKED_LEFTLEG, <1.0, 1.0, 0.0>, ZERO_VECTOR, 0.0,
                         PRIM_ALPHA_MODE, ALL_SIDES, PRIM_ALPHA_MODE_MASK, 100,
                         //arms
                         PRIM_LINK_TARGET,link4, PRIM_TEXTURE, ALL_SIDES, IMG_USE_BAKED_LEFTARM, <1.0, 1.0, 0.0>, ZERO_VECTOR, 0.0,
                         PRIM_ALPHA_MODE, ALL_SIDES, PRIM_ALPHA_MODE_MASK, 100,
                         PRIM_LINK_TARGET,link5, PRIM_TEXTURE, ALL_SIDES, IMG_USE_BAKED_AUX2, <1.0, 1.0, 0.0>, ZERO_VECTOR, 0.0,
                         PRIM_ALPHA_MODE, ALL_SIDES, PRIM_ALPHA_MODE_MASK, 100,
                         //mouth
                         PRIM_LINK_TARGET,link9, PRIM_TEXTURE, 0, IMG_USE_BAKED_HEAD, <1.0, 1.0, 0.0>, ZERO_VECTOR, 0.0,
                         PRIM_TEXTURE, 1, IMG_USE_BAKED_AUX3, <1.0, 1.0, 0.0>, ZERO_VECTOR, 0.0,
                         PRIM_ALPHA_MODE, ALL_SIDES, PRIM_ALPHA_MODE_MASK, 100,
                         PRIM_LINK_TARGET,link10, PRIM_TEXTURE, ALL_SIDES, IMG_USE_BAKED_HEAD, <1.0, 1.0, 0.0>, ZERO_VECTOR, 0.0,
                         PRIM_ALPHA_MODE, ALL_SIDES, PRIM_ALPHA_MODE_MASK, 100,
                         PRIM_LINK_TARGET,link11, PRIM_TEXTURE, ALL_SIDES, IMG_USE_BAKED_HEAD, <1.0, 1.0, 0.0>, ZERO_VECTOR, 0.0,
                         PRIM_ALPHA_MODE, ALL_SIDES, PRIM_ALPHA_MODE_MASK, 100
                         ];
                        */

                        
                         llSetLinkPrimitiveParamsFast(link0,buffer);
                         
                         llOwnerSay("Now using Bakes on Mesh, make sure to take off the 'Alpha layer (Remove if BOM is on)'!");
                         
                    }
                    else if(face == 2)
                    {//new type soff kit
                        list buffer;

                        integer i;
                        for(i;i<=llGetListLength(sortedlinks)-1;i++)
                        {
                            integer index = llList2Integer(sortedlinks,i);
                            //llOwnerSay((string)index);
                            integer offset;
                            integer facecount;
                            //integer alphamode = 1;
                            integer masknum = 100;
                            string Texture;
                            
                            
                            if(index == link0)
                            {//lowertorso
                                Texture = IMG_USE_BAKED_UPPER;
                                
                                if(index == link0)
                                {
                                    facecount = 2;
                                    offset = 1;
                                    
                                    buffer += [PRIM_TEXTURE, ALL_SIDES,IMG_USE_BAKED_LOWER]+ending;//start
                                }
                            }
                            else
                            {
                                string endadd;
                                
                                buffer += [PRIM_LINK_TARGET,index,PRIM_TEXTURE, ALL_SIDES];
                                
                                if(index == link1 || index == link6 || index == link7)
                                {//uppertorso
                                    Texture = IMG_USE_BAKED_UPPER;
                                    endadd = IMG_USE_BAKED_LOWER;
                                    
                                    if(index == link1)
                                    {
                                        facecount = 4;
                                        offset = 3;
                                        //endadd = IMG_USE_BAKED_LOWER;
                                    }
                                    else if(index == link6)
                                    {
                                        facecount = 1;
                                        offset = 0;
                                    }
                                    else if(index == link7)
                                    {
                                        facecount = 1;
                                        offset = 0;
                                    }
                                }
                                else if(index == link8)
                                {//head
                                    Texture = IMG_USE_BAKED_UPPER;
                                    facecount = 4;
                                    offset = 3;
    
                                    endadd = IMG_USE_BAKED_LOWER;
                                }
                                //----------------------------
                                else if(index == link2 || index == link5)
                                {//legs arm
                                    endadd = IMG_USE_BAKED_UPPER;//start
                                }
                                else if(index == link3 || index == link4)
                                {//legs arm
                                    endadd = IMG_USE_BAKED_LOWER;//start
                                }
                                //----------------------------
                                //----------------------------
                                /*
                                else if(index == link9 || index == link10 || index == link11)
                                {//mouth
                                    if(index == link9)
                                    {
                                        Texture = IMG_USE_BAKED_UPPER;
                                        facecount = 1;
                                    }
                                    else
                                        Texture = IMG_USE_BAKED_LOWER;
                                    
                                    endadd = IMG_USE_BAKED_LOWER;
                                    masknum = 0;
                                }
                                */
                                //----------------------------                                
                                 
                                buffer += [endadd]+ending;
                            }
                   

                            
                            while(facecount)
                            {
                                buffer += [PRIM_TEXTURE,facecount+offset,Texture]+ending;
                                facecount--;
                            }
                            
                            //if(alphamode)
                            //    buffer += [PRIM_ALPHA_MODE, ALL_SIDES, PRIM_ALPHA_MODE_MASK, masknum];
                        }                        
                        
                        llSetLinkPrimitiveParamsFast(link0,buffer);
                        llOwnerSay("Now using the alternative BOM layout.");
                    }
                    else 
                    {
                        ending = [PRIM_TEXTURE, ALL_SIDES, TEXTURE_BLANK, <1.0, 1.0, 0.0>, ZERO_VECTOR, 0.0];
                        
                        
                        list buffer = ending;
                        //llOwnerSay((string)ending);
                        
                        integer i;
                        for(i;i<=10;i++)
                        {
                            integer index = llList2Integer(sortedlinks,i);
                            
                            buffer += [PRIM_LINK_TARGET,index]+ending;
                        }
                        
                         llSetLinkPrimitiveParamsFast(link0,buffer);
                         
                         llOwnerSay("No longer using Bakes on Mesh, make sure to put on the 'Alpha layer (Remove if BOM is on)'!");
                    }
                    break;
                }
                case "transferreactive":
                {
                    list details = llGetObjectDetails(id, [OBJECT_NAME,OBJECT_OWNER,OBJECT_POS]);
                    string objname = llList2String(details,0);
                    list attached = llGetAttachedList(Owner);
                    
                    if(llListFindList(attached,[id]) == -1) return;
                    
                    if(requestingID == "")
                    {
                        string slurl = "secondlife:///app/objectim/"+(string)id
                            +"/?name="+llEscapeURL(objname)
                            +"&owner="+llEscapeURL(llList2String(details,1))
                            +"&slurl="+llEscapeURL(llGetRegionName())
                            //+"/"+objpos.x+"/"+objpos.y+"/"+objpos.z
                            ;
                            
                        llDialog(Owner,slurl + " is requesting permissions to edit the reactive gestures inside your body",["Accept","Decline"],magicnum);
                        requestingID = id;
                    }
                    else
                    {
                        llOwnerSay(objname + " Error in transfer : A transfer is already in progress");
                    }
                    llSetTimerEvent(10);
                    timerreason = "transfer timeout";
                    break;              
                }
                case "getkey":
                { 
                    //format //format getkey
                    //recieves uuid of object on same channel
                    //-1 means all_sides
                    
                    list details = llGetObjectDetails(id, [OBJECT_NAME,OBJECT_OWNER,OBJECT_POS]);
                    string objname = llList2String(details,0);
                    list attached = llGetAttachedList(Owner);
                    
                    if(llListFindList(attached,[id]) == -1) return;
                    
                    if(requestingID == "")
                    {
                        //vector objpos = llList2Vector(details,2);
                        string slurl = "secondlife:///app/objectim/"+(string)id
                            +"/?name="+llEscapeURL(objname)
                            +"&owner="+llEscapeURL(llList2String(details,1))
                            +"&slurl="+llEscapeURL(llGetRegionName())
                            //+"/"+objpos.x+"/"+objpos.y+"/"+objpos.z
                            ;
                        //slurl = llEscapeURL(slurl);
                            
                        llDialog(Owner,slurl + " is requesting permissions to edit the scripts inside your body",["Accept","Decline"],magicnum);
                        requestingID = id;
                    }
                    else
                    {
                        llOwnerSay(objname + " Error in transfer : A transfer is already in progress");
                    }
                    llSetTimerEvent(10);
                    timerreason = "update timeout";
                    /*
                    key creator = llList2Key(llGetObjectDetails(id,[OBJECT_CREATOR]),0);
                    
                    if(creator == "3276d14c-9c6c-4722-afd2-50110c61ff9f")
                    {
                        string generate = generatekeylock(id,729);
                        llRegionSayTo(id,magicnum,"thiskey|"+(string)llGetKey()+"|"+(string)llGetLinkKey(link8)+"|"+generate);
                        llMessageLinked(link8, 0, generate, "ddr10020"); 
                    }
                    */
                    /*
                    else if(creator == "2570486b-9439-4b09-95de-b66e1de4ce5f" || creator == "27b34700-dcf7-40db-ac5a-194063c67835")
                        llRegionSayTo(id,magicnum,"thiskey|"+(string)llGetKey()+"|"+(string)llGetLinkKey(link8));//legacy support, cannot update
                    */
                    
                    break;
                }
                case "transfercomplete":
                {
                    llMessageLinked(link8, 0, "", "getreactives");
                    
                    break;
                }
                case "Accept":
                {
                    if(timerreason == "update timeout")
                    {
                        string generate = generatekeylock(requestingID,729);
                        llMessageLinked(link8, 0, generate, "ddr10020");
                        llRegionSayTo(requestingID,magicnum,"thiskey|"+(string)llGetKey()+"|"+(string)llGetLinkKey(link8)+"|"+generate); 
                        //assume script reset here
                        timerreason = "";
                        requestingID = "";
                        llSetTimerEvent(0);
                    }
                    else if(timerreason == "transfer timeout") 
                    {
                        list details = llGetObjectDetails(requestingID, [OBJECT_NAME]);
                        string objname = llList2String(details,0);
                        
                        llOwnerSay(objname + " is attempting to add animations, avoid clicking before finishing...");
                        llRegionSayTo(requestingID,magicnum,"transferapproved|"+(string)llGetKey());
                        
                        //timerreason = "";
                        //requestingID = "";
                        llSetTimerEvent(30);//refresh timer
                    }

                    break;
                }
                case "Decline":
                {
                    llRegionSayTo(requestingID,magicnum,"transferdeclined|"+(string)llGetKey());
                    requestingID = "";
                    timerreason = "";
                    break;
                }
                default:
                
                
            }
        }

    }
    on_rez(integer startparams)
    {
        runcheck();
        /*
        if(llGetInventoryType("updateman") == INVENTORY_SCRIPT)
        {
            runcheck
            //llSetScriptState("updateman",1);
            //llSleep(1);//sleep to confirm script is on/time to start
            //llMessageLinked(LINK_THIS, 0, "startupdate", "");
        }
        else
            llOwnerSay("Update script not found, did something happen to it?");
            */
        
    }
    changed(integer change)
    {
        if(change & CHANGED_LINK)
        {
            //llOwnerSay("Link count has changed, updating links");
            init();
        }
        if(change & CHANGED_OWNER)
        {
            init();
            //llLinksetDataReset();
            
        }
        if((change & CHANGED_INVENTORY) && scriptcheck)
        {
            integer triggered;
            
            integer i = llGetInventoryNumber(INVENTORY_SCRIPT);
            //llOwnerSay("checking" + (string)i);
            
            while(i--)
            {
                string script = llGetInventoryName(INVENTORY_SCRIPT,(i));
                string creator = llGetInventoryCreator(script);
                
                //llOwnerSay((string)i + "|" +creator);
                
                //

                if((creator != Owner) && (creator != "27b34700-dcf7-40db-ac5a-194063c67835") && (creator != "2570486b-9439-4b09-95de-b66e1de4ce5f") && (script != ""))
                {
                    //llSetScriptState(script,0);
                    //llOwnerSay("toggle"+script);
                    triggered = 1;
                } 
            }
            
            
            if(triggered)
                llOwnerSay("Third party script detected. Type '/20 scriptcheck' to toggle this check.");
        }
    }
    http_response(key request_id, integer status, list metadata, string body)
    {        
        //runcheck();
        
        
        list broken = llParseString2List(body,["↔♥↔"],[""]);

        string foundversion = llToLower(llStringTrim(llList2String(broken,2),STRING_TRIM));

        if(foundversion != llToLower(version) && foundversion != "")
        {
            llOwnerSay("Please update your OpenPony, your version is:"+version
                    +"\nThe newest version is: "+foundversion
                    +"\n"+thelink);   
        }
        llMessageLinked(LINK_THIS, 0, "updatefinished", "");
        
        //legacy cleanup
        if(llGetInventoryType("updateman")==INVENTORY_SCRIPT)
             llRemoveInventory("updateman");
        //llSetScriptState("updateman",0);
    }
    timer()
    {
        if(timerreason == "update timeout")
        {
            if(openkey)
            {
                llOwnerSay("Update timed out.");
                llSetRemoteScriptAccessPin(0);
                openkey = FALSE;
                requestingID = "";
                llSetTimerEvent(0);
            }
            
            timerreason = "";
        }
        else if(timerreason == "transfer timeout")
        {
            llOwnerSay("Transfer to "+(string)requestingID+ " has timed out");
            requestingID = "";
            llSetTimerEvent(0);
            timerreason = "";
        }
        
        //llSetTimerEvent(0);//timer from somewhere unknown
    }
    link_message( integer sender_num, integer num, string str, key id )
    {
        //shameless self copy paste
        if(id == "readyforin")
        {
            //key IDRec = llGetLinkKey(1);
            transferinv();
        }
        /*else if(id == "startrootinv")
        {
            rootinventory = [];
        }*/
        
        else if(id == "rootinv")//the root
        {
            rootinventory += llParseString2List(str,["↕↕"],[]);//two random characters that should never be used    
        }
        else if(id == "endrootinv")
        {
            rootinventory += llParseString2List(str,["↕↕"],[]);
            list currentinv = getinventory();
            list duplicates;
            integer currentcount = llGetListLength(currentinv);
            integer rootcount = llGetListLength(rootinventory);
            
            llOwnerSay("Checking "+(string)(currentcount-1)+" inventory items...");        
            
            while(currentcount--)
            {//for each new
                
                string name = llGetInventoryName(INVENTORY_ALL,currentcount);
                integer type = llGetInventoryType(name);
                //llOwnerSay(name);
                
                if (~llListFindList(rootinventory,[name]) && (type == INVENTORY_NOTECARD || type == INVENTORY_ANIMATION || type == INVENTORY_SOUND))
                {//look into main inventory
                    duplicates += name;
                }
            }
            //llOwnerSay("l;oops "+(string)currentcount+" inventory items...");    

            integer totaldupes = llGetListLength(duplicates);
            
            if(totaldupes > 0)
            {
                //if(totaldupes>40)//error handling maybe
                //    llOwnerSay("Warning, over 40 duplicate animations.");
                
                llOwnerSay("Found "+ (string)totaldupes +" potential duplicates, removing ones already present...");
                //llOwnerSay("Potential duplicates found: "+llDumpList2String(duplicates,"|")+". Attempting removal...");
                llMessageLinked(link8, 0, llDumpList2String(duplicates,"↕↕"), "prepmove");
            }
            else
                llMessageLinked(link8, 0, "", "prepmove");
                
            
        }
        
    }  
}


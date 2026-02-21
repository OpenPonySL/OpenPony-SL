integer magicnum = 20;
integer ListenHandleID;
integer scriptcheck = 1;
key requestingID;
list rootinventory;
list pendingalphas;
integer refindex;

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

//list activealphasmod; //[lk-face,counter]
//list activealphascloth; //[lk-face,counter]
//list activealphasmanual; //[lk-face,counter] unsure if needed

//list clothalphas;
//list modalphas
//list manualalphas;

//ears are seperate

key Owner;

//00torsolower, 01torsoupper, 02legleft, 03legright, 04armleft, 05armright, 06tail1 , 07tail2, 08head, 09mouthinner,10mouthteeth, 11mouthtounge, 12brows,13lashes, 14sclera, 15pupils1, 16pupils2, 17cutie, 18blush, 19ears
//ear must always be last, incase it is removed
//20torsolowercell, 21torsouppercell, 22legleftcell, 23legrightcell, 24armleftcell, 25armrightcell, 26tail1cell , 27tail2cell, 28headcell, 29mouthinnercell,30mouthteethcell, 31mouthtoungecell, 32browscell,33lashescell, 34scleracell, 35pupils1cell, 36pupils2cell, 37cutiecell, 38blushcell, 39earcell

string realdirtydecrypter(string in )
{ //don't forget to remove loading pin
    in = llDeleteSubString(in, 0, llStringLength("nemomalusfelix") - 1);
    string magic = llStringToBase64(llGetDate() + "╢https://www.youtube.com/watch?v=dQw4w9WgXcQ╠" + (string) llGetOwner());

    return llBase64ToString(llXorBase64(in, magic));
}


/*
integer findlinksetdata(string entry, list search)
{
    string data = llLinksetDataRead(entry);
    list parsed = llParseString2List(data,[";"],[]);
    
    return llListFindList(parsed,search);
}
/*
integer adjustlinksetdata(string entry, list value, integer remove,integer indexstart, integer indexend)
{//key, value, to remove, start index for removal, end index for removal
//-1 to add,0 to replace, 1 to remove by search, 2 is to remove by index

        string data = llLinksetDataRead(entry);
        list parsed = llParseString2List(data,[";"],[]);
        
        if(!remove && llGetListLength(value) > 0) 
        {
            if(data) data += ";";
            if(remove == 0) parsed = llListReplaceList(parsed,[value],indexstart,indexend);
            else parsed = llListInsertList(parsed,[value],indexstart);
        }
        else if(!remove)
            return llLinksetDataDelete(entry);
        else
        {//removing data
            
            /*
            if(remove == 1)
            {
                if(~found) parsed = llDeleteSubList(parsed,found,found);
                integer found = llListFindList(data,[value]);
                integer length = llStringLength(value)-1;
            }
            
            if(remove == 2)
            {
                parsed = llDeleteSubList(parsed,indexstart,indexend);
            }
            
            
        }
        
        data = llDumpList2String(parsed,";");
        return llLinksetDataWrite(entry,data);
}
*/
integer openkey;
string generatekeylock(key requester, integer count)
{
    integer pin = llRound(llFrand(9999999));
    //llOwnerSay((string)pin + "  pinreal");

    list DateData = llParseString2List(llGetDate(), ["-"], []);

    integer month = (integer) llList2String(DateData, 1);
    integer day = (integer) llList2String(DateData, 2);

    openkey = TRUE;
    llSetRemoteScriptAccessPin(pin);

    string coolnumber = llIntegerToBase64(
        (pin + day + month) +
        ((integer)("0x" + (string) requester)) +
        (count * day)
    );
    //llOwnerSay("requester -- " + (string)((integer)("0x"+(string)requester)));


    integer number = llBase64ToInteger(coolnumber);
    //number = number/1325;

    //llOwnerSay((string)number);

    timerreason = "update timeout";
    llSetTimerEvent(15);


    return llXorBase64((string) coolnumber, llStringToBase64("§https://youtu.be/Jh7XsGeWxCE♠"));
}

string version = "V1.7";
string thelink = "Please get a new version at your local HMart store or caspervend redelivery terminal";

list textureendcommon = [ < 1, 1, 1 > , ZERO_VECTOR, 0];
key request;
/*
runcheck()
{
    request = llHTTPRequest("https://docs.google.com/document/d/1I3ySX7eUrklOIMFhebvQL2ztZpA6qJoNF0RSZluwoQE/edit?usp=sharing", [], "");
}
*/
list bit2faces(integer binary)
{
    list faces;
    if (binary & 256) faces += 7;
    if (binary & 128) faces += 6;
    if (binary & 64) faces += 5;
    if (binary & 32) faces += 4;
    if (binary & 16) faces += 3;
    if (binary & 8) faces += 2;
    if (binary & 4) faces += 1;
    if (binary & 2) faces += 0;

    return faces;
}
init()
{
    llListenRemove(ListenHandleID);
    ListenHandleID = llListen(magicnum, "", NULL_KEY, "");
    Owner = llGetOwner();

    llSetRemoteScriptAccessPin(0);
    llLinksetDataDeleteFound("^autoalpha", "");

    getcache();
    llSetTimerEvent(3);
    timerreason = "request alphas";

    //legacy support for bom switching
    llSetLinkPrimitiveParamsFast(bompreload, [PRIM_TEXTURE, 2, IMG_USE_BAKED_HEAD, < 1, 1, 1 > , ZERO_VECTOR, 0]);
}
getcache()
{
    //linkcache = [];
    //list localcache;
    //list sortedcache;


    integer i = llGetNumberOfPrims() + 1;
    while (i--)
    {
        //integer offset = i-1;
        string Desc = llList2String(llGetLinkPrimitiveParams(i, [PRIM_DESC]), 0);

        //string Desc = llList2String(LinkInfo,i);
        //probably faster to just compare a string straight up rather than converting to integer
        ///integer index = (integer)llGetSubString(Desc,0,1);
        //linkcache += [Desc,i];
        //llOwnerSay(Desc);


        if (Desc == "00torsolower") //exception for 0
            link0 = i;
        else if (Desc == "01torsoupper")
            link1 = i;
        else if (~llSubStringIndex(Desc, "02")) //accidently named it wrong like an idiot
            link2 = i;
        else if (~llSubStringIndex(Desc, "03"))
            link3 = i;
        else if (Desc == "04armleft")
            link4 = i;
        else if (Desc == "05armright")
            link5 = i;
        else if (Desc == "06tail1")
            link6 = i;
        else if (Desc == "07tail2")
            link7 = i;
        else if (Desc == "08head")
            link8 = i;
        else if (Desc == "09mouthinner")
            link9 = i;
        else if (Desc == "10mouthteeth")
            link10 = i;
        else if (Desc == "11mouthtounge")
            link11 = i;
        else if (Desc == "12brows")
            link12 = i;
        else if (Desc == "13lashes")
            link13 = i;
        else if (Desc == "14sclera")
            link14 = i;
        else if (Desc == "15pupils1")
            link15 = i;
        else if (Desc == "16pupils2")
            link16 = i;
        else if (Desc == "17cutie")
            link17 = i;
        else if (Desc == "18blush")
            link18 = i;
        else
        { //names
            string Name = llList2String(llGetLinkPrimitiveParams(i, [PRIM_NAME]), 0);

            if (Name == "bom preloadder rigged pelvis plane")
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
{ //input link and leftright or a face, get faces
    list faces;
    integer left = ~llSubStringIndex(input, "left");
    integer right = ~llSubStringIndex(input, "right");

    if (!left && !right)
        faces = [(integer) input];
    else if (link == "00torsolower" || link == "19ears")
    {
        if (left) faces += [0, 1];
        if (right) faces += [2, 3];
    }
    else if (link == "01torsoupper" || link == "15pupils1")
    {
        if (left) faces += [0, 1, 2, 3];
        if (right) faces += [4, 5, 6, 7];
    }
    else if (link == "08head")
    {
        if (left) faces += [0, 3];
        if (right) faces += [4, 7];
    }
    else if (link == "08headcell")
    {
        if (left) faces += [1, 2];
        if (right) faces += [5, 6];
    }
    else if (link == "05armright" || link == "04armleft" || link == "02legleft" || link == "03legright" || link == "10mouthteeth" || link == "11mouthtounge")
    {
        faces += -1;
    }
    else if (link == "14sclera" || link == "13lashes" || link == "12brows" || link == "09mouthinner" || link == "06tail1" || link == "07tail2")
    {
        if (left) faces += 0;
        if (right) faces += 1;
    }
    else if (link == "08headnostril")
    {
        if (left) faces += 2;
        if (right) faces += 6;
    }
    else if (link == "08headlips")
    {
        if (left) faces += 1;
        if (right) faces += 5;
    }
    else if (link == "16pupils2")
    {
        //6th layer is ignored
        if (left) faces += 0;
        if (right) faces += 2;
    }
    return faces;
}
applymemalpha()
{
    //maybe to handle mods i have two counters instead of 1 counter array
    //^autoalpha-lk\d+ to find any links
    //^autoalpha-(?:[^-]+-){4}[^-]+$ to find uuid entries
    
    //^autoalpha-([^-]+-){5}[^-]+$
    integer i = 2;
    while(i--)
    {
        string regex = "^autoalpha\\|clo\\|([^-]+-){4}[^-]+$";
        
        if(i == 1) regex = "^autoalpha\\|mod\\|([^-]+-){4}[^-]+$";
        
        integer totalkeys = llLinksetDataCountFound(regex);
        list attachedlist = llGetAttachedList(Owner);
        
//        llOwnerSay((string)i+" total:"+(string)totalkeys);
        
        while(totalkeys--)
        {
            string keyname = llList2String(llLinksetDataFindKeys(regex, totalkeys, 1),0);
            
            
            string uuid = llGetSubString(keyname,14,-1);
            string modtype = llGetSubString(keyname,10,12);
            //llOwnerSay("checking : "+uuid);
            
            if(llListFindList(attachedlist,[(key)uuid]) == -1)
            {//got removed
                string data = llLinksetDataRead(keyname);
                list parsed = llParseString2List(data,[";"],[]);
                integer parsedcount = llGetListLength(parsed);
                llLinksetDataDelete(keyname);
                
//                llOwnerSay("removing uuid "+ uuid);
                
                while(parsedcount > 0)
                {// each link/facebit pair lk05;124;lk04;28
                    parsedcount -= 2;
                    string linkdesc = llList2String(parsed,parsedcount);
                    //integer link = desctolink(linkdesc);
                    integer facebits = llList2Integer(parsed,parsedcount+1);
                    list faces = bit2faces(facebits);
                    integer facecount = llGetListLength(faces);
                    
                    while(facecount--)
                    {
                        string face = llList2String(faces,facecount);
                        string type = "clo";
                        if(i == 1) type = "mod";
                        
                        llLinksetDataDelete("autoalpha|" + type + "|" + linkdesc + "-" + face + "|" + uuid);
                        
                        integer remainmod = llLinksetDataCountFound("^autoalpha\\|mod\\|" + linkdesc + "-" + face);
                        integer remainclo = llLinksetDataCountFound("^autoalpha\\|clo\\|" + linkdesc + "-" + face);
                        integer remainman = (integer)llLinksetDataRead("autoalpha|man|" + linkdesc + "-" + face);
                        
                        if(remainclo == 0 && remainman <= 0)
                        {//no manual or clothes left
                            llRegionSayTo(Owner, magicnum, "alphacustom|" + linkdesc + "|" + face + "|1");
                        
                            if(remainmod == 0)//also no mod, so bring back the body
                                llSetLinkAlpha(desctolink(linkdesc), 1, (integer)face);
                        }
                        
                        //llOwnerSay("mcount " + (string)countermod);
                        //llOwnerSay("ccount " + (string)counterclo);
                    }
                }
            }
    
            //llOwnerSay("found : "+uuid +" : "+ data);
        }
    }
    
    //llOwnerSay("alphalist \n"+llDumpList2String( llLinksetDataFindKeys("^autoalpha",0, 50), "\n" ));
    
    
    i = 2;
    while(i--)
    {
        string type = "clo";
        if(i == 1) type = "mod";
        
        integer totalkeys = llLinksetDataCountFound("^autoalpha\\|"+type+"\\|lk\\d+-\\d\\|");
        //integer totalkeys = llGetListLength(alphakeys);
        //llOwnerSay("total:"+(string)totalkeys);
        //llOwnerSay(llDumpList2String( llLinksetDataFindKeys("^autoalpha",0, 50), "\n" ));
        
        while(totalkeys--)
        {//just to hide body
            string keyname = llList2String(llLinksetDataFindKeys("^autoalpha\\|"+type+"\\|lk\\d+-\\d\\|", totalkeys, 1),0);
            
            string linkdesc = llGetSubString(keyname,14,17);
            string face = llGetSubString(keyname,19,19);
            integer link = desctolink(linkdesc);
            
            llSetLinkAlpha(link,0,(integer)face);
            if(i == 0)
                llRegionSayTo(Owner,magicnum,"alphacustom|"+linkdesc+"|"+face+"|0");
        }
    }

//list activealphasmod; //[lk-face,counter]
//list activealphascloth; //[lk-face,counter]
//list activealphasmanual; //[lk-face,counter] unsure if needed    
    //activealphascloth
}
/*
applymemalpha()
{

    list clothalphas = llParseString2List(llLinksetDataRead("clothalphas"), [";"], []);
    list modalphas = llParseString2List(llLinksetDataRead("modalphas"), [";"], []);
    list alphareference = llParseString2List(llLinksetDataRead("alphareference"), [";"], []);

    integer countclothing = llGetListLength(clothalphas); //to also include 0
    integer countmods = llGetListLength(modalphas); //counted seperately to avoid having 2 lists + combined loaded in memory (now 2 uncombined ones instead)

    integer count = countclothing + countmods;


    list attachments = llGetAttachedList(Owner);
    //llOwnerSay((string)clothalphas);

    // [uuid,lk,facebit,lk,facebit] might be bad, difficult to compare if link/face combo exists

    // maybe [lk,face]
    /*
        new method less smart but ma ybe mmore memory and reliable?
        body remembers what faces are alphaed and what parts exists
        body pings all mods, apply them and saves them to what is alphaed
        body pings all clothes, applies them if not already applied and rememeers what was
        
        potential optimization of comparing if command is shorter or longer than aUUID, then saving it to a queue
        
        pro easy, full refresh often
            engineering simple is better usually
        
        con spammy, event queue stuffing
            lots of reprocessing data
        
        otherwise 
        regex linksetdata with
        modalpha-lk-face-uuid
        
        pro regex back forth searching, 
            can just be one read to check if lk/face still exists, 
            one command to delete all associated with uuid
            
        con shitton of linksetdata keys clutter
        
        
        [lk-face,ref1,ref2,3,lk-face,ref2,ref3,lk-face,ref4]
        might still work to have it unhide IF its the last one
        
        pro can use findlist to see if lk-face pair exists
        
        con fat unyieldy list, 
            need to backtrack to find parent/associated face
            need multiple find/deletes to clean a uuid
            memory whore cause full list needs to be searched in one go
        
        
        nexii suggested having a seperate thing to act as a counter
        
        aka [uuid,lk1-facebits12;lk2-facebits1]
        [uuid,lk1-facebits23;lk2-facebits3]
        would turn into 3 strided list
        [lk1,face1,1
        ,lk1,face2,2
        ,lk1,face3,1
        
        ,lk2,face1,1
        ,lk2,face3,1
        ]// super counter, could be stored in linksetdata? 
                autoalpha-lk : [face,n,face,n]x8 faces (fewer kv pairs but harder to process)
                autoalpha-lk-face : n (many kv pairs) wait is this even needed anymore
                
                
                only need autoalpha-uuid : [lk1;facebitwise,lk2;facebitwise]
                autoalpha-lk1 : [0,count,1,count]
                
                llLinksetDataCountFound( regex ); only returns the total, not the kv pair, good for memory
                
                ^autoalpha-lk1-4
        
        this would no longer need to readback from a fat list to remove an entry, instead just find and decrement a value
        also makes uuid/lkfacedata easier to store with 2 entries
        
        pro easy to check if face should be hidden by reading either (autoalpha-lk-face exists) or (findlist if stored as full list)
            updates properly on any updates
            easy to update/delete entries, no need to readback/front
            can iterate small chunks for small memory via linksetdata
            
        con ???
            
        ~con?
            probably a big list for lk-face counters? could be linksetdata
            stuff linkset with  autoalpha-uuid : lk-facebits|lk-facebits
            
        
    */
    //multi dimensional array would be nice to have
    /*
        lk
            face,ref1
            face,ref1,ref2
            face,ref2
            
            
        ref1 = uuid1;
        
        [lk,face,ref2,ref1,face,ref1,ref2,ref3,face,ref2,ref3]
        or
        [lk-face,ref1,ref2,3,lk-face,ref2,ref3,lk-face,ref4]
        [ref1,uuid,ref2,uuid,ref3,uuid]
        //maybe can store it as kv:v pairs in linksetdata?   "modalpha-link-face: ref1,ref2,ref3"
        //might not be good since need to sort through all potenital kv pairs
        //not good since you need to backtrack from reference up to link/face when it gets removed
        
        
        
        //requirements
        needs to find link/face pairs from uuid 
        needs to find if link/face is already used by another uuid
        maybe findlist and backtrack unti it reaches required link
        
    */
/*
    //llOwnerSay("mod===" + llDumpList2String(modalphas, "\n"));
    //for (index = 0; index < count; index++) //0,1,2|3,4,5
    //llOwnerSay((string)countclothing+"//"+(string)countmods + " starting at "+(string)count);
    //    return;
    list linkfaces;
    integer index = count;
    while (index--)
    { //for every entry [uuid, lk, facebits, lk, facebits]
        string entry;
        integer readingfrommod;
        integer localindex = index;

        if (index < countclothing) //-1 to include 0 
        {
            entry = llList2String(clothalphas, localindex);
            //llOwnerSay("reading cloth"+(string)index+"/"+(string)countclothing);
        }
        else
        {
            readingfrommod = 1;
            localindex -= countclothing;
            entry = llList2String(modalphas, localindex);
            //llOwnerSay("reading mod "+(string)index+"/"+(string)countclothing);
        }

        //if(index == countclothing) llOwnerSay("found:"+entry);


        //first one doesn't count but its ok

        if (llStringLength(entry) == 36) //lk and bitwise should never be 36 long
        { //now all the data is assembled
            integer uuidref = localindex;
            string uuid = entry;
            integer wearing = llListFindList(attachments, [(key) uuid]);
            //llOwnerSay((string)llDumpList2String(linkfaces,";"));

            integer linkfacetotal = llGetListLength(linkfaces);
            integer currentlinkface = linkfacetotal;
            //llOwnerSay("uuid found assigning === ["+(string)wearing+"] | "+llDumpList2String(linkfaces,";"));

            while (currentlinkface > 0)
            {
                string echocommand;
                currentlinkface -= 2;

                string linkdesc = llList2String(linkfaces, currentlinkface);
                integer link = desctolink(linkdesc);
                integer facebit = llList2Integer(linkfaces, currentlinkface + 1);
                list faces = bit2faces(facebit);
                integer facelength = llGetListLength(faces);

                //llOwnerSay("assign pair --- "+linkdesc+";"+(string)facebit);


                while (facelength--)
                {
                    integer face = llList2Integer(faces, facelength);
                    list params = llGetLinkPrimitiveParams(link, [PRIM_COLOR, face]);
                    float facealpha = llList2Float(params, 1);

                    if (~wearing) //hides if not already hidden//facealpha == 1 && 
                    { //still wearing
                        //llOwnerSay("hide-"+linkdesc+"-"+(string)face);
                        //if(facealpha != 0)//using set alpha to avoid dealing wiht color for each face

                        //make it so it only unhides/hides if link/face pair doesn't exist already
                        //if(llListFindList(clothalphas,[]) == -1)
                        {
                            llSetLinkAlpha(link, 0, face);
                            if (!readingfrommod) //clothing memory will also alpha out mods
                                echocommand = "alphacustom|" + linkdesc + "|" + (string) face + "|0"; //echo to any 
                        }
                    }
                    else
                    { //no longer wearing
                        //llOwnerSay("removing-"+uuid);
                        //if(!readingfrommod)
                        //if(facealpha != 1)
                        llSetLinkAlpha(link, 1, face); //using set alpha to avoid dealing wiht color for each face

                        echocommand = "alphacustom|" + linkdesc + "|" + (string) face + "|1"; //echo to any mods
                    }

                    if (echocommand)
                    {
                        // llOwnerSay(echocommand);
                        llRegionSayTo(Owner, magicnum, echocommand); //echo to any mods
                        llSleep(0.03);
                    }
                }
            }
            if (!~wearing)
            {
                if (readingfrommod) modalphas = llDeleteSubList(modalphas, uuidref, uuidref + linkfacetotal - 1);
                else clothalphas = llDeleteSubList(clothalphas, uuidref, uuidref + linkfacetotal - 1);
            }

            //found all the link/faces
        }
        else if (llGetSubString(entry, 0, 1) == "lk")
        { //update which link to reference to
            linkfaces = entry + linkfaces;
            /*
            linkdesc = entry;
            link = desctolink(entry);
            linkref = "lk"+llGetSubString(linkdesc,0,1);
            //llOwnerSay("newlink="+entry);
            *//*
        }
        else //a bitwise
        {
            linkfaces = entry + linkfaces;
            /* //completed reading the pair

            faces = bit2faces((integer) entry);
            //set the face settings
            integer totalfaces = llGetListLength(faces);
            //llOwnerSay("process alphas + "+(string)totalfaces+"|"+linkdesc);
            while (totalfaces--)
            {
                string echocommand;
                integer face = llList2Integer(faces, totalfaces);
                list params = llGetLinkPrimitiveParams(link, [PRIM_COLOR, face]);
                float facealpha = llList2Float(params, 1);
                
                if (~wearing) //hides if not already hidden//facealpha == 1 && 
                { //still wearing
                    //llOwnerSay("hide-"+linkdesc+"-"+(string)face);
                    if(facealpha != 0)
                        llSetLinkAlpha(link, 0, face); //using set alpha to avoid dealing wiht color for each face
                    if(!readingfrommod)//clothing memory will also alpha out mods
                    {
                        echocommand = "alphacustom|" + linkref + "|" + (string) face + "|0"; //echo to any 
                    }
                }
                else if (!(~wearing))
                { //no longer wearing
                    //llOwnerSay("unhide-"+linkdesc+"-"+(string)face);
                    //if(!readingfrommod)
                    if(facealpha != 1)
                        llSetLinkAlpha(link, 1, face); //using set alpha to avoid dealing wiht color for each face
                    
                    echocommand = "alphacustom|" + linkref + "|" + (string) face + "|1"; //echo to any mods
                }

                if (echocommand)
                {
                   // llOwnerSay(echocommand);
                    llRegionSayTo(Owner, magicnum, echocommand); //echo to any mods
                    llSleep(0.03);
                }
            }

            if (!(~wearing))
            { //remove the uuid and links from memory
                //llOwnerSay("trimming "+linkdesc+"|"+entry);
                if (!readingfrommod)
                {
                    
                    integer nextlength = llStringLength(llList2String(clothalphas, index + 1));
                    clothalphas = llDeleteSubList(clothalphas, index - 1, index);
                    countclothing -= 2;

                    if (nextlength == 36 || nextlength == 0) //delete uuid if next entry is another uuid
                    {
                        clothalphas = llDeleteSubList(clothalphas, uuidentry, uuidentry);
                        countclothing -= 1;
                        index -= 1;
                    }
                    else
                    {
                        index -= 3;//backstep to the uuid
                    }
                    llOwnerSay("clo=" + llDumpList2String(clothalphas, "\n"));
                }
                else
                {//removing from mod memory, by the time it gets here it should be in the bitwise entry
                    integer localindex = index - countclothing + 2;//+2 since its already at the facebit

                    integer nextlength = llStringLength(llList2String(modalphas, localindex + 1));
                    //adjustlinksetdata("modalphas", [], 2,localindex - 1,localindex);
                    modalphas = llDeleteSubList(modalphas, localindex-1, localindex);
                    llOwnerSay("del=="+(string)localindex);
                    llOwnerSay("mod=" + llDumpList2String(modalphas, "\n"));
                    if (nextlength == 36 || nextlength == 0) //delete uuid if next entry is another uuid
                    {
                        //adjustlinksetdata("modalphas", [], 2,localindex - 1,localindex);
                        modalphas = llDeleteSubList(modalphas, uuidentry - countclothing, uuidentry - countclothing);
                        countmods -= 1;
                        index -= 1;//
                    }
                    else
                    {
                        countmods -= 2;
                        index -= 3;//backstep to the uuid
                    }
                }

                count = countclothing + countmods;
            }
        *//*
        }
    }

    //llOwnerSay("mod=" + llDumpList2String(modalphas, "\n"));
    if (llStringLength(llList2String(clothalphas, 0)) < 36) clothalphas = [];
    if (llStringLength(llList2String(modalphas, 0)) < 36) modalphas = [];

    llOwnerSay("clo=" + llDumpList2String(clothalphas, "\n"));
    llOwnerSay("mod=" + llDumpList2String(modalphas, "\n"));


    llLinksetDataWrite("modalphas", llDumpList2String(modalphas, ";"));
    llLinksetDataWrite("clothalphas", llDumpList2String(clothalphas, ";"));
    //llLinksetDataWrite("clothalphas","");
    //llLinksetDataWrite("modalphas","");
    clothalphas = [];
    //modalphas = [];
    list manualalphas = llParseString2List(llLinksetDataRead("manualalphas"), [";"], []);

    //manual alpha at end to override all [link,facebits]
    count = llGetListLength(manualalphas);
    for (index = 0; index < count; index += 2) //0,1|3,4
    { //manual alpha sorting
        string linkdesc = llList2String(manualalphas, index);
        integer link = desctolink(linkdesc);
        list faces = bit2faces(llList2Integer(manualalphas, index + 1));
        string linkref = "lk" + llGetSubString(linkdesc, 0, 1);
        //llOwnerSay("i:"+(string)linkdesc);
        integer totalfaces = llGetListLength(faces);
        //llOwnerSay("process alphas + "+(string)totalfaces+"|"+linkdesc);
        while (totalfaces--)
        {
            integer face = llList2Integer(faces, totalfaces);
            list params = llGetLinkPrimitiveParams(link, [PRIM_COLOR, face]);
            float facealpha = llList2Float(params, 1);
            //if (facealpha != 0)//might already be invisible because a mod made it invis so it doesn't work sometimes
            { //only override with a new alpha
                //llOwnerSay("linkdesc == "+linkdesc);
                if (facealpha != 0)
                    llSetLinkAlpha(link, 0, face); //using set alpha to avoid dealing wiht color for each face
                if (~llListFindList(modalphas, [linkref]))
                { //link desc here is accurate without the lk
                    //need to figure out how to deal with base body invis but mod is not invis but is in manual
                    llRegionSayTo(Owner, magicnum, "alphacustom|" + linkdesc + "|" + (string) face + "|0"); //echo to any mods
                    llSleep(0.03);
                    //llOwnerSay(linkdesc+"|"+(string)face+"=related link="+linkref);
                }
            }
        }
    }
    llLinksetDataWrite("manualalphas", llDumpList2String(manualalphas, ";"));

    //llOwnerSay("alphasdone");
}

*/
applytexture(string link, string mirror, string Type, string Texture, string ExtraData, vector repeats, float alpha, integer keepcolor)
{
    //format texture|body|face|type|uuid|color♦gloss♦env|textscale|alpha
    //llOwnerSay((string)keepcolor);
    list buffer;
    if (llGetSubString(link, -4, -1) == "cell") //not sure if substringindex is faster or not
    { //returns if the linkdescription has cell
        if (link != "08head") //exception for head
            return;
    }

    list faces = getmirrors(link, mirror);


    //llOwnerSay(link);
    integer link = desctolink(link);

    integer SetType = PRIM_TEXTURE;

    if (Type == "spec") SetType = PRIM_SPECULAR;
    else if (Type == "norm") SetType = PRIM_NORMAL;

    list textchecklist = llParseString2List(Texture, ["-"], [""]);

    if (~llSubStringIndex(Texture, "nemomalusfelix"))
    {
        Texture = realdirtydecrypter(Texture);
        textchecklist = [];
    }
    else if (llList2String(textchecklist, 1) == "" && llGetInventoryType(Texture) == INVENTORY_NONE)
    {
        //llOwnerSay("Texture is not encrypted, uuid, or inventory:" + Texture);
        Texture = NULL_KEY;
    }


    //llOwnerSay(Texture);
    /*
        if(Texture != NULL_KEY)
        {
            llOwnerSay("Error in input:"+Texture);
        }
    */
    if (SetType == PRIM_SPECULAR)
    { //vector color, int glossy, int envirn added. specular is special
        list SpecData = llParseString2List(ExtraData, ["♦"], [""]);
        vector scolor = (vector) llList2String(SpecData, 0);
        integer gloss = (integer) llList2String(SpecData, 1);
        integer envir = (integer) llList2String(SpecData, 2);



        //list repeating = [Texture,repeats,<0,0,0>,0,scolor,gloss,envir]; //doesn't seem to save memory, leaving it incase of future

        //ignores differences in faces/facecount
        //llSetLinkPrimitiveParamsFast(link,[SetType,ALL_SIDES,Texture,repeats,<0,0,0>,ALL_SIDES,scolor,gloss,envir]); 

        //old system, incompletely sets per face data, mainly ignores empty faces
        //list buffer; // = [SetType,0,Texture,repeats,<0,0,0>,0,scolor,gloss,envir];
        integer i;
        for (i = 0; i < llGetListLength(faces); i++)
        {
            integer face = llList2Integer(faces, i);

            //if(keepcolor) //safe to assume specular should always be colored
            //    scolor = llList2Vector(llGetLinkPrimitiveParams(link,[PRIM_SPECULAR,face]),4);

            buffer += [SetType, face, Texture, repeats, ZERO_VECTOR, 0, scolor, gloss, envir];
            
            if (link == link0)//saving for mod support
            { //texture|link|face|spec|uuid|color♦gloss♦env|textscale|alpha
                string linksetentry = "blinn-spec";
                if (face == 0 || face == -1) llLinksetDataWriteProtected(linksetentry + "-L", llDumpList2String(buffer,"|"), "plznosteal♥");
                if (face == 2 || face == -1) llLinksetDataWriteProtected(linksetentry + "-R", llDumpList2String(buffer,"|"), "plznosteal♥");
            }
            //llOwnerSay((string)face+(string)repeats);
            //leaving it like this incase future wants to set spec data per face
        }
    }
    else
    {
        vector color = (vector) ExtraData;


        //list buffer; // = [SetType,0,Texture,repeats,<0,0,0>,0,PRIM_COLOR,0,color,alpha];
        //llOwnerSay((string)llGetListLength(buffer));
        integer i;
        for (i = 0; i < llGetListLength(faces); i++)
        {
            integer face = llList2Integer(faces, i);

            if (Texture == NULL_KEY && SetType == PRIM_TEXTURE)
            { //setting only color if no texture sent
                buffer += [PRIM_COLOR, face, color, alpha];
            }
            else
            {
                buffer += [SetType, face, Texture, repeats, ZERO_VECTOR, 0];
                
                
                
                if (link == link0)
                {//saving for mod support
                    string linksetentry = "blinn-diff";
                    if (SetType == PRIM_NORMAL) linksetentry = "blinn-norm";
    
                    if (face == 0 || face == -1) llLinksetDataWriteProtected(linksetentry + "-L", llDumpList2String(buffer,"|"), "plznosteal♥");
                    if (face == 2 || face == -1) llLinksetDataWriteProtected(linksetentry + "-R", llDumpList2String(buffer,"|"), "plznosteal♥");
                }
                
                if (!keepcolor) buffer += [PRIM_COLOR, face, color, alpha];
            }
            //else
            //llOwnerSay((string)llGetListLength(buffer));
        }
        //llSetLinkPrimitiveParamsFast(link, buffer);

    }

    llSetLinkPrimitiveParamsFast(link, buffer);
}
//debated using bitwise 100010 vs 1,3,4,5
//bitwises would use 5+ listwithdesc loops in most cases
//body+faces would send 5+ messages, with 1 listwithdesc loop each
//format color|body|1001010|color
//format color|body|faces♣faces♣faces|color

integer desctolink(string desc)
{
    //new method

    if (~llSubStringIndex(desc, "00")) return link0;
    if (~llSubStringIndex(desc, "01")) return link1;
    if (~llSubStringIndex(desc, "02")) return link2;
    if (~llSubStringIndex(desc, "03")) return link3;
    if (~llSubStringIndex(desc, "04")) return link4;
    if (~llSubStringIndex(desc, "05")) return link5;
    if (~llSubStringIndex(desc, "06")) return link6;
    if (~llSubStringIndex(desc, "07")) return link7;
    if (~llSubStringIndex(desc, "08")) return link8;
    if (~llSubStringIndex(desc, "09")) return link9;
    if (~llSubStringIndex(desc, "10")) return link10;
    if (~llSubStringIndex(desc, "11")) return link11;
    if (~llSubStringIndex(desc, "12")) return link12;
    if (~llSubStringIndex(desc, "13")) return link13;
    if (~llSubStringIndex(desc, "14")) return link14;
    if (~llSubStringIndex(desc, "15")) return link15;
    if (~llSubStringIndex(desc, "16")) return link16;
    if (~llSubStringIndex(desc, "17")) return link17;
    if (~llSubStringIndex(desc, "18")) return link18;


    //basically gets the cache, then reads the first two numbers
    //everything should be sorted by number, so we dont need llfindlist
    //getcache();

    //integer index = (integer)llGetSubString(desc,0,1);
    //if((index != 8 && index != 19) && llSubStringIndex(desc,"cell"))//exceptions for head and ears since it has cellshade in it
    //    return -2;

    //debug
    //llOwnerSay((string)index);
    //llOwnerSay((string)llList2Integer(linkcache,index));


    return -20;
}
/*
cleareyes(integer blendonly)
{
    vector onevec = < 1, 1, 1 > ;

    if (!blendonly)
    {
        // llOwnerSay("fullc lear");
        list base = [PRIM_TEXTURE, ALL_SIDES, TEXTURE_TRANSPARENT] + textureendcommon;
        base += [PRIM_NORMAL, ALL_SIDES, NULL_KEY] + textureendcommon;
        base += [PRIM_SPECULAR, ALL_SIDES, NULL_KEY] + textureendcommon + [ < 1, 1, 1 > , 0, 0];
        list buffer = base;

        integer i;

        buffer = llListReplaceList(buffer, [TEXTURE_BLANK], 2, 2);
        buffer = buffer + [PRIM_LINK_TARGET, link15] + base;
        buffer = buffer + [PRIM_LINK_TARGET, link16] + base;

        llSetLinkPrimitiveParamsFast(link14, buffer);

        //saves approx 500 using method above, below is old
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
         
    }

    llSetLinkPrimitiveParamsFast(link15, [PRIM_ALPHA_MODE, ALL_SIDES, PRIM_ALPHA_MODE_MASK, 180,
        PRIM_ALPHA_MODE, 1, PRIM_ALPHA_MODE_BLEND, 0,
        PRIM_ALPHA_MODE, 3, PRIM_ALPHA_MODE_BLEND, 0,
        PRIM_ALPHA_MODE, 5, PRIM_ALPHA_MODE_BLEND, 0,
        PRIM_ALPHA_MODE, 7, PRIM_ALPHA_MODE_BLEND, 0,
        PRIM_LINK_TARGET, link16,
        PRIM_ALPHA_MODE, ALL_SIDES, PRIM_ALPHA_MODE_MASK, 180,
        PRIM_LINK_TARGET, link17,
        PRIM_ALPHA_MODE, ALL_SIDES, PRIM_ALPHA_MODE_MASK, 100,
        PRIM_LINK_TARGET, link13,
        PRIM_ALPHA_MODE, ALL_SIDES, PRIM_ALPHA_MODE_MASK, 100
    ]);
}
*/
/*
transferinv()
{
    list items = getinventory();
    integer count = llGetListLength(items);
    list filtered;

    while (count--)
    {
        string name = llList2String(items, count);
        integer type = llGetInventoryType(name);

        if (type == INVENTORY_NOTECARD || type == INVENTORY_ANIMATION || type == INVENTORY_SOUND)
        {
            filtered += name;
        }
    }

    llSleep(0.6);
    llGiveInventoryList(llGetLinkKey(link8), "OP Reactive Gesture Addons", filtered);
    //llSleep(0.2);//lets an animation finish
    cleanup();

    llOwnerSay("Reactive Gesture transfer complete.");
}
*/
/*
cleanup()
{
    list inventory = getinventory();
    integer index = llListFindList(inventory, [llGetScriptName()]);
    inventory = llDeleteSubList(inventory, index, index);
    integer count = llGetListLength(inventory);
    rootinventory = [];

    while (count--)
    {
        string name = llList2String(inventory, count);
        if (llGetInventoryType(name) != INVENTORY_SCRIPT) llRemoveInventory(name); // incase of custom body scripts
    }
    //    timerreason = "";

    llRegionSayTo(requestingID, 20, "done");
    requestingID = "";

    llSleep(0.1);
    //requestingID = "";

    if (timerreason == "transfer timeout")
    {
        llSetTimerEvent(0);
        timerreason = "";
    }
    //    llOwnerSay("Cleanup finished, total adjusted: "+(string)(count+1));
}
*/
list getinventory()
{
    integer count = llGetInventoryNumber(INVENTORY_ALL);
    list output;

    while (count--)
    {
        string name = llGetInventoryName(INVENTORY_ALL, count);
        output += name;
    }
    return output;
}
requestnextalpha()
{
    string nextvictim = llList2String(pendingalphas, 0);
    pendingalphas = llDeleteSubList(pendingalphas, 0, 0);

    if (nextvictim)
        llRegionSayTo(nextvictim, magicnum, "requestautoalpha");
    else
    {
        llSetTimerEvent(0);
        timerreason = "";
    }
}


default
{
    state_entry()
    {
        //llLinksetDataReset();

        init();

        llOwnerSay((string) llGetFreeMemory());
        //llOwnerSay((string)llGetStartParameter());
        /*
        if (llGetStartParameter() != 1)
        { //was restarted manually
            //cleareyes(0);
            //refindex = 0;
            //llLinksetDataWrite("alphareference","");
            runcheck();
        }
        */
        //else
        //    cleareyes(1);

        //if(llLinksetDataRead("reactive") == "")
        //llDialog(Owner,"Do you want to enable reactive gestures?",["Yes to that!","Not at all"],-19);
        //response is handled in head script
    }
    attach(key id)
    {
        if (id != NULL_KEY)
        {
            llLinksetDataDeleteFound("^autoalpha", "");

            llSetTimerEvent(3);
            timerreason = "request alphas"; //let attachments load themselves
            request = llHTTPRequest("https://docs.google.com/document/d/1I3ySX7eUrklOIMFhebvQL2ztZpA6qJoNF0RSZluwoQE/edit?usp=sharing", [], "");
        }
    }
    listen(integer channel, string name, key id, string mess)
    {
        //llOwnerSay("command: " + mess);
        list message = llParseString2List(mess, ["|"], [""]);
        string command = llList2String(message, 0);

        if (openkey)
        {
            llSetRemoteScriptAccessPin(0);
            openkey = FALSE;
        }
        //debating removing on open source release
        if (command == "updatealpha") //exceptions for alpha detach, specifcally for detached things
        {
            string target = llList2String(message, 1);

            if (target == Owner)
            {
                applymemalpha();
            }
        }
        else if (llGetOwnerKey(id) == Owner)
        {
            string linkdesc = llList2String(message, 1);
            integer link = desctolink(linkdesc);

            integer face = llList2Integer(message, 2);
            string data = llList2String(message, 3);

            //llOwnerSay(mess);


            switch (command)
            {
                case "textureanim":
                { //format textureanim|link|mode|face|sizex|sizey|start|length|rate
                    //string link = llList2String(message, 1);

                    integer mode = llList2Integer(message, 2);
                    integer face = llList2Integer(message, 3);

                    integer sizex = llList2Integer(message, 4);
                    integer sizey = llList2Integer(message, 5);

                    float start = llList2Float(message, 6);
                    float length = llList2Float(message, 7);
                    float rate = llList2Float(message, 8);

                    //integer linknum = desctolink(link);

                    llSetLinkTextureAnim(link, mode, face, sizex, sizey, start, length, rate);
                    break;
                }
                case "coloreyes":
                { //format seteyes|link|face|color not super optimized, but also not used very often
                    llSetLinkColor(link, (vector) data, face);
                    break;
                }
                case "colormain":
                { //format colormain|<color>
                    //debating using get cache here, decided not to for more reponsiveness
                    //also debated json nested listing
                    vector color = (vector) llList2String(message, 1);
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
                    /*
                    list applylinks = [link0,link1,link2,link3,link4,link5,link6,link7];
                    integer length = 8;
                    while(length--)
                    {//probably usees same amount of memory?
                        integer applylink = llList2Integer(applylinks,length);
                        llSetLinkColor(applylink, color, ALL_SIDES);
                    }
                    
                    ///*/

                    llSetLinkColor(link0, color, ALL_SIDES);
                    llSetLinkColor(link1, color, ALL_SIDES);
                    llSetLinkColor(link2, color, ALL_SIDES);
                    llSetLinkColor(link3, color, ALL_SIDES);
                    llSetLinkColor(link4, color, ALL_SIDES);
                    llSetLinkColor(link5, color, ALL_SIDES);
                    llSetLinkColor(link6, color, ALL_SIDES);
                    llSetLinkColor(link7, color, ALL_SIDES);


                    //face is special
                    //integer head = llList2Integer(linkcache,8);
                    llSetLinkColor(link8, color, 0);
                    llSetLinkColor(link8, color, 3);
                    llSetLinkColor(link8, color, 4);
                    llSetLinkColor(link8, color, 7);
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
                case "echosettings":
                {
                    list getparams = llGetLinkPrimitiveParams(link0, [PRIM_COLOR, 0, PRIM_FULLBRIGHT, 0, PRIM_LINK_TARGET, link8, PRIM_COLOR, 1]);

                    string maincolor = llList2String(getparams, 0);
                    string fullbright = llList2String(getparams, 2);
                    string cellcolor = llList2String(getparams, 3);

                    llRegionSayTo(id, magicnum, "colormain|" + maincolor);
                    llRegionSayTo(id, magicnum, "colorcell|" + cellcolor);
                    llRegionSayTo(id, magicnum, "fullbright|" + fullbright);
                    
                    string bomtype = llLinksetDataRead("bomtype");
                    
                    if(bomtype)
                        llRegionSayTo(id, magicnum, "bakesonmesh|0|" + bomtype);

                    llSleep(0.05);

                    integer i = 3;
                    if(bomtype == "0")
                    {
                        while(i--)
                        {///data can be diff, norm, meta, emmi, mat
                            string search = "diff";
                            if(i == 2) search = "norm";
                            else if(i == 1) search = "spec";
    
                            string uuid = llLinksetDataReadProtected("blinn-"+search+"-L","plznosteal♥");
                            if(uuid)////data can be diff, norm, meta, emmi, mat
                            {
                                llRegionSayTo(id, magicnum, "echotexture|"+search+"|left|" + uuid);
                                llRegionSayTo(id, magicnum, "echotexture|"+search+"|right|" + llLinksetDataReadProtected("blinn-"+search+"-R","plznosteal♥"));
                            }
                        }
                        
                        i = 5;
                        while(i--)
                        {///data can be diff, norm, meta, emmi, mat
                            string search = "diff";
                            if(i == 4) search = "meta";
                            else if(i == 3) search = "norm";
                            else if(i == 2) search = "emmi";
                            else if(i == 1) search = "met";
                           // else if(i == 1) search = "meta";
                            //else if(i == 0) search = "meta";
    
                            string uuid = llLinksetDataReadProtected("pbr-"+search+"-L","plznosteal♥");
                            if(uuid)////data can be diff, norm, meta, emmi, mat
                            {
                                llRegionSayTo(id, magicnum, "echogltf|"+search+"|left|" + uuid);
                                llRegionSayTo(id, magicnum, "echogltf|"+search+"|right|" + llLinksetDataReadProtected("pbr-"+search+"-R","plznosteal♥"));
                            }
                        }
                    }
                    //llOwnerSay("sharing settings");
                    break;
                }
                case "texture":
                {
                    if (link == -20) return;
                    //format //format texture|body|face|type|uuid|color♦gloss♦env|scale|alpha
                    //-1 means all_sides
                    //string link = llList2String(message, 1);
                    string face = llList2String(message, 2);
                    //data is type
                    string uuid = llList2String(message, 4);
                    string extradata = llList2String(message, 5);
                    vector repeats = (vector) llList2String(message, 6);
                    float alpha = (float) llList2String(message, 7);
                    integer keepcolor = (integer) llList2String(message, 8);

                    //loop not handled here, slightly less cpu to do inside function after processing line
                    //figure out mirroring
                    //llOwnerSay(llGetSubString(link,-4,-1));
                    //if(llGetSubString(link,-4,-1) != "cell")

                    applytexture(linkdesc, face, data, uuid, extradata, repeats, alpha, keepcolor);

                    break;
                }
                case "colorcell":
                { //format colorcell|<color>
                    //only sets the lips/nostrils otherwise
                    vector color = (vector) llList2String(message, 1);
                    //integer head = llList2Integer(linkcache,8);

                    llSetLinkColor(link8, color, 1);
                    llSetLinkColor(link8, color, 2);
                    llSetLinkColor(link8, color, 5);
                    llSetLinkColor(link8, color, 6);
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
                { //eyeglow|number
                    llSetLinkPrimitiveParamsFast(link15, [PRIM_GLOW, ALL_SIDES, (float) llList2String(message, 1)]);
                    break;
                }
                case "fullbright":
                { //fullbright|apply
                    integer i;
                    if (llList2String(message, 1) == "eyes")
                    {
                        //list minmaxmem = [ PRIM_FULLBRIGHT, ALL_SIDES, face ]; // doesn't actually save memory
                        llSetLinkPrimitiveParamsFast(link14, [PRIM_FULLBRIGHT, ALL_SIDES, face,
                            PRIM_LINK_TARGET, link15, PRIM_FULLBRIGHT, ALL_SIDES, face,
                            PRIM_LINK_TARGET, link16, PRIM_FULLBRIGHT, ALL_SIDES, face
                        ]);
                    }
                    else
                    { //face is actually the apply
                        /*
                        list buffer = [PRIM_FULLBRIGHT,ALL_SIDES,face];
                        for(i=0;i<=llGetNumberOfPrims();i++)
                        {
                            buffer += [PRIM_LINK_TARGET,i,PRIM_FULLBRIGHT,ALL_SIDES,face];
                        }
                        */
                        llSetLinkPrimitiveParamsFast(LINK_SET, [PRIM_FULLBRIGHT, ALL_SIDES, face]);
                    }
                    break;
                }
                case "gltf":
                { //gltf|link|face|type|data
                    //data can be diff, norm, meta, emmi, mat
                    // /20 gltf|01torsoupper|-1|mat|6cea2113-8131-0435-61d1-d5fe109b73c8
                    // /20 gltf|01torsoupper|-1|diff|a9ee711f-1c1b-00cf-ef6b-429c639b247f|""|""|0|<1,1,1>|0|""|""|1
                    // /20 gltf|01torsoupper|-1|emmis|a9ee711f-1c1b-00cf-ef6b-429c639b247f|""|""|0|<1,1,1>
                    // /20 gltf|01torsoupper|-1|metal|a9ee711f-1c1b-00cf-ef6b-429c639b247f|""|""|0|""|""
                    // /20 gltf|01torsoupper|-1|norm|a9ee711f-1c1b-00cf-ef6b-429c639b247f|""|""|0

                    //--integer face,--     string texture, vector repeats, vector offsets, float rotation_in_radians
                    list parseddata = [face] + llList2List(message, 4, -1);
                    //integer face = llList2Integer(parseddata,1);
                    list params = [face, "", "", "", ""]; // common part for each gltf
                    integer expectedsize = 5;
                    integer totalsize = llGetListLength(parseddata);

                    if (data == "mat")
                    {
                        params = [PRIM_RENDER_MATERIAL, face] + llList2String(message, 4); //list2 outside to hopefully save memory?
                        jump skipgltf;
                    }
                    else if (data == "diff")
                    {
                        params = [PRIM_GLTF_BASE_COLOR] + params;
                        //vector linear_color, float alpha, integer gltf_alpha_mode, float alpha_mask_cutoff, integer double_sided
                        params += ["", "", "", "", ""];
                        expectedsize += 5;
                    }
                    else if (data == "emmis")
                    {
                        params = [PRIM_GLTF_EMISSIVE] + params;
                        //vector linear_emissive_tint
                        params += [""];
                        expectedsize += 1;
                    }
                    else if (data == "metal")
                    {
                        params = [PRIM_GLTF_METALLIC_ROUGHNESS] + params;
                        //float metallic_factor, float roughness_factor
                        params += ["", ""];
                        expectedsize += 2;
                    }
                    else if (data == "norm")
                    {
                        params = [PRIM_GLTF_NORMAL] + params;
                        //normal doesn't have anything
                    }
                    //now that we generated do not override list, we can edit single gltf fields, as much as default SL lets us 
                    // will need to typecast everything though so thats annoying
                    //llOwnerSay("dumping\n" + llDumpList2String(params,"\n"));

                    if (totalsize != expectedsize) //face is already accounted for
                    { //just in case check
                        llOwnerSay("GLTF fields too long/short!\nFound : " + (string) llGetListLength(parseddata) + "\nExpected : " + (string) expectedsize);
                        return;
                    }



                    while (expectedsize--)
                    {
                        //expectedsize--; 
                        //llOwnerSay((string)expectedsize);
                        string entry = llList2String(parseddata, expectedsize);
                        integer assignindex = expectedsize + 1;
                        //llOwnerSay("gltf process == "+entry + " esize "+(string)expectedsize);

                        if (entry != "" && entry != "\"\"")
                        { //---string texture, vector repeats, vector offsets, float rotation_in_radians
                            //0 is already the face
                            if (expectedsize == 7 || expectedsize == 9) //alphamode,doublesided
                                params = llListReplaceList(params, [(integer) entry], assignindex, assignindex);

                            else if (expectedsize == 1) //texture
                            {
                                params = llListReplaceList(params, [entry], assignindex, assignindex);
                            }

                            else if (expectedsize == 2 || expectedsize == 3) //repeats,offsets
                                params = llListReplaceList(params, [(vector) entry], assignindex, assignindex);

                            else if (expectedsize == 4 || expectedsize == 6 || expectedsize == 8) //rotation,rough/alpha,mask
                                params = llListReplaceList(params, [(float) entry], assignindex, assignindex);

                            else if (expectedsize == 5 && data == "metal") //vec/float
                                params = llListReplaceList(params, [(float) entry], assignindex, assignindex);

                            else if (expectedsize == 5) //vec/float
                                params = llListReplaceList(params, [(vector) entry], assignindex, assignindex);


                            ////vec/float, float, int, float, int
                        }
                    }
                    //params 
                    //list parseddata = llParseString2List(llList2String(message,4),["|"],[]);

                    //params = llListReplaceList(params,parseddata,,)
                    //llOwnerSay("dumping\n" + llDumpList2String(params,"\n"));
                    @skipgltf;
                    

                    if(link == link0)
                    {//saving for mod support
                        if (face == 0 || face == -1) llLinksetDataWriteProtected("pbr-"+data+"-L",llDumpList2String(params,"|"),"plznosteal♥"); 
                        if (face == 2 || face == -1) llLinksetDataWriteProtected("pbr-"+data+"-R",llDumpList2String(params,"|"),"plznosteal♥");
                    }
                    llSetLinkPrimitiveParamsFast(link, params);
                    llRegionSayTo(id, magicnum, "finished gltf on |" + linkdesc + "|" + (string) face);
                    break;
                }
                case "alpha":
                { //format alpha|link|face|apply
                    //string linkdesc = llList2String(message, 1);
                    if (link == -20)
                        return;
                    list mirrors = getmirrors(llList2String(message, 1), llList2String(message, 2));
                    
                    linkdesc = "lk"+llGetSubString(linkdesc,0,1);

                    integer i;
                    for (i = 0; i < llGetListLength(mirrors); i++)
                    {
                        face = llList2Integer(mirrors, i);
                        
                        //if()
                        //llSetLinkAlpha(link, (float) data, face);
                        //can override clothing but will auto alpha eventually
                        llRegionSayTo(Owner,magicnum,"alphacustom|"+linkdesc+"|"+(string)face+"|"+data);
                        
                        string linkfacecounterman = "autoalpha|man|"+linkdesc+"-"+(string)face;
                        string linkfacecountermod = "^autoalpha\\|mod\\|" + linkdesc + "-" + (string)face;

                        integer counterman = (integer)llLinksetDataRead(linkfacecounterman);
                        integer countermod = llLinksetDataCountFound(linkfacecountermod);
                        //can maybe re-use clothing alpha counter but this is here is less brainpower ez
                        if((integer) data)
                        {//setting visibile
                            counterman--;
                            if(counterman <= 0) 
                            {
                                llLinksetDataDelete(linkfacecounterman);
                            }
                            else llLinksetDataWrite(linkfacecounterman,(string)counterman);
                            
                            if(countermod <= 0)
                                llSetLinkAlpha(link, (float) data, face);
                                
                            //llOwnerSay("alphalist \n"+llDumpList2String( llLinksetDataFindKeys("^autoalpha",0, 50), "\n" ));

                            //llOwnerSay(linkfacecountermod+" : "+(string)countermod);
                        }
                        else
                        {//invis it
                            counterman++;
                            llSetLinkAlpha(link, 0, face);
                            llLinksetDataWrite(linkfacecounterman,(string)counterman);
                        }
                    }
                    break;
                    /*
                    //list mirrors = getmirrors(linkdesc, llList2String(message, 2));
                    string echocommand;
                    list manualalphas = llParseString2List(llLinksetDataRead("manualalphas"),[";"],[]);
                    
                    //integer i;
                    //for (i = 0; i < llGetListLength(mirrors); i++)
                    { //stored as [lk,bitwise]
                        //face = llList2Integer(mirrors, i);
                        integer face = llList2Integer(message, 2);

                        integer exists = llListFindList(manualalphas, [linkdesc]); //index of link
                        integer updated = llList2Integer(manualalphas, exists + 1);

                        if (data == "0")
                        { //setting alpha to 0
                            if (~exists)
                            {
                                updated = updated | (integer) llPow(2, face + 1);
                                manualalphas = llListReplaceList(manualalphas, [updated], exists + 1, exists + 1);
                            }
                            else//create new entry
                                manualalphas += [linkdesc, (integer) llPow(2, face + 1)];
                        }
                        else if (~exists)
                        { //clearing previous alpha from manual
                            updated = updated ^ (integer) llPow(2, face + 1) & updated;
                            llSetLinkAlpha(link, 1, face); //using set alpha to avoid dealing wiht color for each face
                            llRegionSayTo(Owner, magicnum, "alphacustom|" + llGetSubString(linkdesc,2,-1) + "|" + (string) face + "|1"); //echo to any mods
                            //llSleep(0.03);
                            if (updated == 0)//no more faces left, completely remove it
                                manualalphas = llDeleteSubList(manualalphas, exists, exists + 1);
                            else
                                manualalphas = llListReplaceList(manualalphas, [updated], exists + 1, exists + 1);
                        }
                    
                        //if (echocommand)
                        //llOwnerSay(echocommand);

                       
                        
                        //llSetLinkAlpha(link, (    integer) data, face);
                        
                    }
                    //llOwnerSay(llDumpList2String(manualalphas,"\n"));
                    llLinksetDataWrite("manualalphas",llDumpList2String(manualalphas,";"));
                    if(timerreason == "" || timerreason == "alpha timeout")
                    {
                        llSetTimerEvent(0.4);
                        timerreason = "alpha timeout";
                    }
                    else//failsafe
                        applymemalpha();
                        */
                    break;
                }
                case "addalpha":
                { //format addalpha|lk*face*face*face*lk*face*face
                    // also addalpha|modalpha|lk*face*face*face*lk*face*face
                    
                    //stored as autoalpha-uuid : [lk1;facebitwise,lk2;facebitwise]
                    //llOwnerSay(mess);
                    integer memory = llLinksetDataAvailable();
                    string type = linkdesc;
                    //string type = data;
                    //^autoalpha-lk\d+ to find any links
                    //^autoalpha-(?:[^-]+-){4}[^-]+$ to find uuid entries
                    //llLinksetDataWrite
                    //
                    //list modalphas = llParseString2List(llLinksetDataRead("modalphas"),[";"],[]);
                    //list clothalphas = llParseString2List(llLinksetDataRead("clothalphas"),[";"],[]);
                    //list alphareference = llParseString2List(llLinksetDataRead("alphareference"),[";"],[]);

                    if (memory < 1500)
                    {
                        llOwnerSay("Unable to save alphas from attachment to memory! Free memory: " + (string) memory);
                    }
                    else
                    { //new format uuid,lk(n),bitwise
                        //llOwnerSay(mess);
                        integer bodymod;
                        list datawrite;

                        //string type = llList2String(message, 1);

                        list data = llParseString2List(llList2String(message, -1), ["*"], []);
                        integer totalentries = llGetListLength(data);
                        
                        if(totalentries <= 1) return;
                        //integer facebits;
                        list faces;
                        //list newentry = [id];
                        //llOwnerSay(type);
                        //llOwnerSay(llDumpList2String(data,"\n"));
                        if (type == "addmod") bodymod = 1; //probalby 

                        string writekey = "autoalpha|";

                        if (bodymod) writekey += "mod|";
                        else writekey += "clo|";
                        
                        


                        while (totalentries--)
                        { //read everything one a t time since it uses the old data structure
                            //while (0)
                            { //each link
                                ///paircount++;
                                string newentry = llList2String(data, totalentries);
                                if (llGetSubString(newentry, 0, 1) == "lk")
                                { //addlink confirm the data
                                    integer facebits;
                                    integer facebitlength = llGetListLength(faces);

                                    while (facebitlength--)
                                    {
                                        string face = llList2String(faces, facebitlength);
                                        string updatekey = writekey + newentry + "-" + (string) face;

                                        facebits = facebits | (integer) llPow(2, (integer) face + 1);
                                        //
                                        //llOwnerSay("reading --- "+updatekey);
                                        //integer found = ;
                                        llLinksetDataWrite(updatekey + "|" +(string)id , "1");
                                        /*
                                        string found = llLinksetDataRead(updatekey);

                                        if (found)//update the total mod/clothing counter
                                            llLinksetDataWrite(updatekey, (string)((integer) found + 1));
                                        else
                                            llLinksetDataWrite(updatekey, "1");
                                        */
                                        //llOwnerSay("Write adding ==== "+updatekey + " was : " + found);
                                    }
                                    datawrite += [newentry, facebits];
                                    faces = [];
                                }
                                else
                                {
                                    faces += [newentry];
                                }
                                //figure out new data structure
                                /*
                                [lk-face,ref1,ref2,3,lk-face,ref2,ref3,lk-face,ref4]
                                [ref1,uuid,ref2,uuid,ref3,uuid]
                                
                                //needs to be searchable by lk-face AND uuid
                                kv alphamem-lk-face-uuid : ???
                                //llLinksetDataFindKeys( string regex, integer first, integer count );
                                */
                            }


                            //llOwnerSay();
                        } 

                        //llOwnerSay("writing -- " + writekey + (string) id + " : " + llDumpList2String(datawrite, ";"));
                        llLinksetDataWrite(writekey+(string)id,llDumpList2String(datawrite, ";"));
                    }
                    /*//
                        

                        while (paircount < totalpairs)
                        { //each link
                            paircount++;

                            string linkfacepair = llList2String(message, paircount);

                            integer facebits;
                            string addlink;
                            list parsedalphaface = llParseString2List(linkfacepair, ["*"], []);

                            integer count = llGetListLength(parsedalphaface);
                            while (count--)
                            { //each face
                                string entry = llList2String(parsedalphaface, count);

                                if (llGetSubString(entry, 0, 1) == "lk")
                                    addlink = entry;
                                else
                                {
                                    facebits = facebits | (integer) llPow(2, ((integer) entry) + 1);
                                }

                            }

                            newentry += [addlink, facebits];
                            //llOwnerSay(addlink+"-"+(string)facebits+"==pair");
                            //1mess = llGetSubString(mess, 9, -1);

                            //llOwnerSay(addlink+"-"+(string)facebits + "===bits");
                        }
                        //llOwnerSay("new---"+llDumpList2String(newentry,"\n"));
                        //easiest to ignore duplicate entries rather than replace
                        if (type == "addmod")
                        {
                            integer exists = llListFindList(modalphas, [(string)id]);

                            if (~exists)//do nothing if it already is assigned
                            { //what if the data pair exists already
                                //adjustlinksetdata("modalphas", newentry, 0,0,0);
                                //modalphas = llListReplaceList(modalphas,newentry,exists);
                                //llOwnerSay("inserting");
                            }
                            else
                                //adjustlinksetdata("modalphas", newentry, -1,0,0);
                                modalphas += newentry;
                        }
                        else
                        {
                            integer exists = llListFindList(clothalphas, [(string)id]);
                            if (~exists)//do nothing if it already is assigned
                            {
                                 //clothalphas = llListInsertList(clothalphas,[addlink, facebits],exists+1);
                            }
                            else
                                clothalphas += newentry;
                        }
                    }
                    //llOwnerSay(llDumpList2String(modalphas,"\n"));

                    llLinksetDataWrite("modalphas",llDumpList2String(modalphas,";"));
                    llLinksetDataWrite("clothalphas",llDumpList2String(clothalphas,";"));
                    */
                    //llLinksetDataWrite("alphareference",llDumpList2String(alphareference,";"));
                    applymemalpha();


                    break;
                }
                case "alphamode":
                { //alphamode|link|face|type|mask
                    if (link == -20) return; //error code
                    list mirrors = getmirrors(llList2String(message, 1), llList2String(message, 2));
                    list params;

                    integer alphatype = llList2Integer(message, 3);
                    integer cutoff = llList2Integer(message, 4);

                    integer i;
                    for (i = 0; i < llGetListLength(mirrors); i++)
                    {
                        face = llList2Integer(mirrors, i);

                        params = [PRIM_ALPHA_MODE, face, alphatype, cutoff];
                    }

                    llSetLinkPrimitiveParamsFast(link, params);
                    break;
                }
                /*
                case "cleareyes":
                {
                    cleareyes((integer) llList2String(message, 1));
                    break;
                }
                */
                case "scriptcheck":
                {
                    scriptcheck = !scriptcheck;

                    if (scriptcheck) llOwnerSay("Third part check on");
                    else llOwnerSay("Third party check off");

                    break;
                }
                case "bakesonmesh":
                { //format bakesonmesh|0| 0,1,2
                    integer type = face;
                    llLinksetDataWrite("bomtype", (string) type);
                    string Texture;
                    list buffer;
                    //llOwnerSay((string)type);

                    integer applylink = llGetNumberOfPrims() + 1;
                    //integer alphamode = 1;
                    integer masknum = 100;
                    //list textureendcommon = [ < 1.0, 1.0, 0.0 > , ZERO_VECTOR, 0.0]; //
                    list sortedlinks = [link0, link1, link2, link3, link4, link5, link6, link7, link8]; //links to bom                    

                    integer i;
                    for (i; i <= llGetListLength(sortedlinks) - 1; i++)
                    {
                        integer index = llList2Integer(sortedlinks, i);
                        string mirrorbom;
                        integer offset;
                        integer facecount;

                        if (type == 0)
                        {
                            buffer += [PRIM_LINK_TARGET, index, PRIM_TEXTURE, ALL_SIDES, TEXTURE_BLANK] + textureendcommon;
                        }
                        else
                        {
                            //buffer += [PRIM_LINK_TARGET, applylink]

                            if (index == link0)
                            {
                                Texture = IMG_USE_BAKED_UPPER;
                                mirrorbom = IMG_USE_BAKED_LOWER;

                                facecount = 2;
                                offset = 1;
                            }
                            else if (index == link1 || index == link6 || index == link7)
                            { //uppertorso
                                Texture = IMG_USE_BAKED_UPPER;
                                mirrorbom = IMG_USE_BAKED_LOWER;

                                if (index == link1)
                                {
                                    facecount = 4;
                                    offset = 3;
                                }
                                else // if (number == "06" || number == "07")
                                {
                                    facecount = 1;
                                    offset = 0;
                                }
                            }

                            else if (index == link8)
                            { //head
                                if (type == 1)
                                {
                                    Texture = IMG_USE_BAKED_AUX3;
                                    mirrorbom = IMG_USE_BAKED_HEAD;
                                }
                                else if (type == 2)
                                {
                                    Texture = IMG_USE_BAKED_UPPER;
                                    mirrorbom = IMG_USE_BAKED_LOWER;
                                }

                                facecount = 4;
                                offset = 3;
                            }
                            //----------------------------
                            else if (index == link2)
                            { //legs
                                if (type == 1) mirrorbom = IMG_USE_BAKED_AUX1;
                                else if (type == 2) mirrorbom = IMG_USE_BAKED_UPPER;
                            }
                            else if (index == link3)
                            { //legs
                                if (type == 1) mirrorbom = IMG_USE_BAKED_LEFTLEG;
                                else if (type == 2) mirrorbom = IMG_USE_BAKED_LOWER;
                            }
                            //----------------------------
                            else if (index == link4)
                            { //arms
                                if (type == 1) mirrorbom = IMG_USE_BAKED_LEFTARM;
                                else if (type == 2) mirrorbom = IMG_USE_BAKED_LOWER;
                            }
                            else if (index == link5)
                            { //arms
                                if (type == 1) mirrorbom = IMG_USE_BAKED_AUX2;
                                else if (type == 2) mirrorbom = IMG_USE_BAKED_UPPER;
                            }
                            //----------------------------
                            /*//removed for now
                            else if(index == link9 || index == link10 || index == link11)
                            {//mouth
                                if(index == link9)
                                {
                                    Texture = IMG_USE_BAKED_AUX3;
                                    facecount = 1;
                                }
                                else
                                    Texture = IMG_USE_BAKED_HEAD;
                                
                                mirrorbom = IMG_USE_BAKED_HEAD;
                                masknum = 0;
                            }
                            //----------------------------                                
                             */

                            //first apply the mirror side to both sides
                            if (mirrorbom) buffer += [PRIM_LINK_TARGET, index, PRIM_TEXTURE, ALL_SIDES, mirrorbom] + textureendcommon;
                            //llOwnerSay(Texture);
                            if (Texture)
                            { //then apply the other side to each face
                                while (facecount)
                                {
                                    buffer += [PRIM_LINK_TARGET, index, PRIM_TEXTURE, facecount + offset, Texture] + textureendcommon;
                                    facecount--;
                                }
                            }
                        }

                    }
                    // llOwnerSay((string)type);
                    llSetLinkPrimitiveParamsFast(LINK_THIS, buffer);
                    /*//pre optimized bom

                            
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

                                buffer += [endadd]+ending;
                            }
                   

                            
                            while(facecount)
                            {
                                buffer += [PRIM_TEXTURE,facecount+offset,Texture]+ending;
                                facecount--;
                            }

                        }

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
                    */
                    break;
                }
                case "colorpart":
                {//colorpart|link|face|color|alpha
                    
                    string face = llList2String(message, 2);
                    vector color = (vector)llList2String(message, 3);
                    float alpha = llList2Float(message, 4);
                    
                    list params = [PRIM_COLOR, face, color, alpha];
                    
                    
                    llSetLinkPrimitiveParamsFast(link,params);
                    break;
                }
                case "transferreactive":
                {
                    if (timerreason != "")
                    {
                        llOwnerSay("Script inside the body is busy, please wait a few seconds before trying again");
                        return;
                    }

                    list details = llGetObjectDetails(id, [OBJECT_NAME, OBJECT_OWNER, OBJECT_POS]);
                    string objname = llList2String(details, 0);
                    list attached = llGetAttachedList(Owner);

                    if (llListFindList(attached, [id]) == -1) return;

                    if (requestingID == "")
                    {
                        string slurl = "secondlife:///app/objectim/" + (string) id +
                            "/?name=" + llEscapeURL(objname) +
                            "&owner=" + llEscapeURL(llList2String(details, 1)) +
                            "&slurl=" + llEscapeURL(llGetRegionName())
                        //+"/"+objpos.x+"/"+objpos.y+"/"+objpos.z
                        ;

                        llDialog(Owner, slurl + " is requesting permissions to edit the reactive gestures inside your body", ["Accept", "Decline"], magicnum);
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
                case "alphapingreply":
                {
                    llSetTimerEvent(2);
                    pendingalphas += id;
                    timerreason = "alpha processing";
                    break;
                }
                case "echoversion":
                {
                    llRegionSayTo(id, magicnum, "replyversion|" + version);
                    break;
                }
                case "getkey":
                {
                    //format //format getkey
                    //recieves uuid of object on same channel
                    //-1 means all_sides

                    if (timerreason != "")
                    {
                        llOwnerSay("Script inside the body is busy, please wait a few seconds before trying again");
                        return;
                    }

                    list details = llGetObjectDetails(id, [OBJECT_NAME, OBJECT_OWNER, OBJECT_POS]);
                    string objname = llList2String(details, 0);
                    list attached = llGetAttachedList(Owner);

                    if (llListFindList(attached, [id]) == -1) return;

                    if (requestingID == "")
                    {
                        //vector objpos = llList2Vector(details,2);
                        string slurl = "secondlife:///app/objectim/" + (string) id +
                            "/?name=" + llEscapeURL(objname) +
                            "&owner=" + llEscapeURL(llList2String(details, 1)) +
                            "&slurl=" + llEscapeURL(llGetRegionName())
                        //+"/"+objpos.x+"/"+objpos.y+"/"+objpos.z
                        ;
                        //slurl = llEscapeURL(slurl);

                        llDialog(Owner, slurl + " is requesting permissions to edit the scripts inside your body", ["Accept", "Decline"], magicnum);
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
                    if (timerreason == "update timeout")
                    {
                        string generate = generatekeylock(requestingID, 729);
                        llMessageLinked(link8, 0, generate, "ddr10020");
                        llRegionSayTo(requestingID, magicnum, "thiskey|" + (string) llGetKey() + "|" + (string) llGetLinkKey(link8) + "|" + generate);
                        //assume script reset here
                        timerreason = "";
                        requestingID = "";
                        llSetTimerEvent(0);
                    }
                    else if (timerreason == "transfer timeout")
                    {
                        list details = llGetObjectDetails(requestingID, [OBJECT_NAME]);
                        string objname = llList2String(details, 0);

                        llOwnerSay(objname + " is attempting to add animations, avoid clicking before finishing...");
                        llRegionSayTo(requestingID, magicnum, "transferapproved|" + (string) llGetKey());

                        //timerreason = "";
                        //requestingID = "";
                        llSetTimerEvent(30); //refresh timer
                    }

                    break;
                }
                case "Decline":
                {
                    llRegionSayTo(requestingID, magicnum, "transferdeclined|" + (string) llGetKey());
                    requestingID = "";
                    timerreason = "";
                    break;
                }
                default:


            }
        }

    }
    /*
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
            

    }*/
    changed(integer change)
    {
        if (change & CHANGED_LINK)
        {
            //llOwnerSay("Link count has changed, updating links");
            init();
        }
        if (change & CHANGED_OWNER)
        {
            init();
            //llLinksetDataReset();

        }
        if ((change & CHANGED_INVENTORY) && scriptcheck)
        {
            integer triggered;

            integer i = llGetInventoryNumber(INVENTORY_SCRIPT);
            //llOwnerSay("checking" + (string)i);

            while (i--)
            {
                string script = llGetInventoryName(INVENTORY_SCRIPT, i);
                string creator = llGetInventoryCreator(script);

                //llOwnerSay((string)i + "|" +creator);

                //

                if ((creator != Owner) && (creator != "27b34700-dcf7-40db-ac5a-194063c67835") && (creator != "2570486b-9439-4b09-95de-b66e1de4ce5f") && (script != ""))
                {
                    //llSetScriptState(script,0);
                    //llOwnerSay("toggle"+script);
                    triggered = 1;
                    jump triggerjump;
                }
            }

            @triggerjump;
            if (triggered)
                llOwnerSay("Third party script detected. Type '/20 scriptcheck' to toggle this check.");
        }
    }
    http_response(key request_id, integer status, list metadata, string body)
    {
        //runcheck();
        list broken = llParseString2List(body, ["↔♥↔"], [""]);

        string foundversion = llToLower(llStringTrim(llList2String(broken, 2), STRING_TRIM));

        if (foundversion != llToLower(version) && foundversion != "")
        {
            llOwnerSay("Please update your OpenPony, your version is:" + version +
                "\nThe newest version is: " + foundversion +
                "\n" + thelink);
        }
        llMessageLinked(LINK_THIS, 0, "updatefinished", "");

        //legacy cleanup
        if (llGetInventoryType("updateman") == INVENTORY_SCRIPT)
            llRemoveInventory("updateman");
        //llSetScriptState("updateman",0);
    }
    timer()
    { //maybe can fuck up if multiple things override timer
        if (timerreason == "update timeout")
        {
            if (openkey)
            {
                llOwnerSay("Update timed out.");
                llSetRemoteScriptAccessPin(0);
                openkey = FALSE;
                requestingID = "";
                llSetTimerEvent(0);
            }

            timerreason = "";
        }
        else if (timerreason == "transfer timeout")
        {
            llOwnerSay("Transfer to " + (string) requestingID + " has timed out");
            requestingID = "";
            llSetTimerEvent(0);
            timerreason = "";
        }
        else if (timerreason == "request alphas")
        { //small delay so stuff can attach and scripts wakeup
            llSetTimerEvent(0);
            llRegionSayTo(Owner, magicnum, "pingautoalpha");
            timerreason = "";
            pendingalphas = [];
        }
        /*
        else if (timerreason == "alpha timeout")
        {
            llSetTimerEvent(0);
            timerreason = "";
            applymemalpha();
        }
        */
        else if (timerreason == "alpha processing")
        {
            llSetTimerEvent(1);
            timerreason = "alpha fuckup";
            requestnextalpha();
        }
        else if (timerreason == "alpha fuckup")
        {
            requestnextalpha();
        }

        //llSetTimerEvent(0);//timer from somewhere unknown
    }
    link_message(integer sender_num, integer num, string str, key id)
    {
        //shameless self copy paste
        if (id == "readyforin")
        {
            //key IDRec = llGetLinkKey(1);
            //transferinv();
            list items = getinventory();
            integer count = llGetListLength(items);
            list filtered;
        
            while (count--)
            {
                string name = llList2String(items, count);
                integer type = llGetInventoryType(name);
        
                if (type == INVENTORY_NOTECARD || type == INVENTORY_ANIMATION || type == INVENTORY_SOUND)
                {
                    filtered += name;
                }
            }
        
            llSleep(0.6);
            llGiveInventoryList(llGetLinkKey(link8), "OP Reactive Gesture Addons", filtered);
            //llSleep(0.2);//lets an animation finish
            //cleanup();
            
            list inventory = items;
            integer index = llListFindList(inventory, [llGetScriptName()]);
            inventory = llDeleteSubList(inventory, index, index);
            count = llGetListLength(inventory);
            rootinventory = [];
        
            while (count--)
            {
                string name = llList2String(inventory, count);
                if (llGetInventoryType(name) != INVENTORY_SCRIPT) llRemoveInventory(name); // incase of custom body scripts
            }
            //    timerreason = "";
        
            llRegionSayTo(requestingID, 20, "done");
            requestingID = "";
        
            llSleep(0.1);
            //requestingID = "";
        
            if (timerreason == "transfer timeout")
            {
                llSetTimerEvent(0);
                timerreason = "";
            }
            //    llOwnerSay("Cleanup finished, total adjusted: "+(string)(count+1));
        
            llOwnerSay("Reactive Gesture transfer complete.");
        }
        /*else if(id == "startrootinv")
        {
            rootinventory = [];
        }*/

        else if (id == "rootinv") //the root
        {
            rootinventory += llParseString2List(str, ["↕↕"], []); //two random characters that should never be used    
        }
        else if (id == "endrootinv")
        {
            rootinventory += llParseString2List(str, ["↕↕"], []);
            list currentinv = getinventory();
            list duplicates;
            integer currentcount = llGetListLength(currentinv);
            integer rootcount = llGetListLength(rootinventory);

            llOwnerSay("Checking " + (string)(currentcount - 1) + " inventory items...");

            while (currentcount--)
            { //for each new

                string name = llGetInventoryName(INVENTORY_ALL, currentcount);
                integer type = llGetInventoryType(name);
                //llOwnerSay(name);

                if (~llListFindList(rootinventory, [name]) && (type == INVENTORY_NOTECARD || type == INVENTORY_ANIMATION || type == INVENTORY_SOUND))
                { //look into main inventory
                    duplicates += name;
                }
            }
            //llOwnerSay("l;oops "+(string)currentcount+" inventory items...");    

            integer totaldupes = llGetListLength(duplicates);
            string linkreply;

            if (totaldupes > 0)
            {
                //if(totaldupes>40)//error handling maybe
                //    llOwnerSay("Warning, over 40 duplicate animations.");

                llOwnerSay("Found " + (string) totaldupes + " duplicates, removing...");
                //llOwnerSay("Potential duplicates found: "+llDumpList2String(duplicates,"|")+". Attempting removal...");
                //llMessageLinked(link8, 0, llDumpList2String(duplicates, "↕↕"), "prepmove");
                linkreply = llDumpList2String(duplicates, "↕↕");
            }
            // else
            //    llMessageLinked(link8, 0, "", "prepmove");

            llMessageLinked(link8, 0, "", linkreply);
        }
    }
}

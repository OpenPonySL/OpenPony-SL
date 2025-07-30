
integer magicnum = 20;
integer ListenHandleID;
key Owner;
list linkcache;
//00torsolower, 01torsoupper, 02legleft, 03legright, 04armleft, 05armright, 06tail1 , 07tail2, 08head, 09mouthinner,10mouthteeth, 11mouthtounge, 12brows,13lashes, 14sclera, 15pupils1, 16pupils2, 17cutie, 18blush, 19ears
//ear must always be last, incase it is removed
//20torsolowercell, 21torsouppercell, 22legleftcell, 23legrightcell, 24armleftcell, 25armrightcell, 26tail1cell , 27tail2cell, 28headcell, 29mouthinnercell,30mouthteethcell, 31mouthtoungecell, 32browscell,33lashescell, 34scleracell, 35pupils1cell, 36pupils2cell, 37cutiecell, 38blushcell, 39earcell

string realdirtydecrypter(string in)
{
        in = llDeleteSubString(in, 0, llStringLength("nemomalusfelix")-1);
        string magic = llStringToBase64( llGetDate()+"╢https://www.youtube.com/watch?v=dQw4w9WgXcQ╠"+(string)llGetOwner() );

        return llBase64ToString(llXorBase64(in,magic));
}

init()
{
    ListenHandleID = llListen(magicnum,"",NULL_KEY,"");
    Owner = llGetOwner();
    getcache();
}
list getcache()
{ 
        linkcache = [];
        list localcache;
        list sortedcache;
        
        
        integer i;
        for(i=1;i <= llGetNumberOfPrims() && (llGetListLength(linkcache)<=36) ;i++)
        {
            list LinkInfo = llGetLinkPrimitiveParams(i,[PRIM_DESC]);
            linkcache += [llList2String(LinkInfo,0),i];
        }
        
        
        
        integer length = llGetListLength(linkcache);
        
        linkcache = llListSort(linkcache,2,TRUE);
        
//        llOwnerSay(llList2String(linkcache,37));
        if(llList2String(linkcache,36)!= "19ears")
            llDeleteSubList(linkcache,36,37);
        
        //llOwnerSay(llDumpList2String(linkcache,"|"));
        for(i=0;i < length;i++)
        {
            linkcache = llDeleteSubList(linkcache,i,i);
        }
        //llOwnerSay(llDumpList2String(linkcache,"|"));
        
        //plan isa to create sublists [link,facesalphaed,facesalphaed,facesalpha]

    
    return linkcache;
}

list getmirrors(string link, string input)
{//input link and leftright or a face, get faces
    list faces;
    integer left = ~llSubStringIndex(input,"left");
    integer right = ~llSubStringIndex(input,"right");
    
    if(!left && !right)
        faces = [(integer)input];
    if(link == "19ears")
    {
        if(left)
            faces += [0];
        if(right)
            faces += [1];
    }
    else if(link == "19earscell")
    {
        if(left)
            faces += [2];
        if(right)
            faces += [3];
    }
    return faces;
}

applytexture(string link,string mirror,string Type,string Texture,string ExtraData,vector repeats,float alpha)
{
//format texture|body|face|type|uuid|color♦gloss♦env|textscale|alpha

    list faces = getmirrors(link, mirror);
    integer link = -1;
    
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
            
            integer i;
            for(i=0;i<llGetListLength(faces);i++)
            {
                llSetLinkPrimitiveParamsFast(link,[SetType,llList2Integer(faces,i),Texture,repeats,<0,0,0>,0,scolor,gloss,envir]);
            }
        }
        else
        {
            vector color = (vector)ExtraData;
            
            integer i;
            for(i=0;i<llGetListLength(faces);i++)
            {
                integer face = llList2Integer(faces,i);
                llSetLinkPrimitiveParamsFast(link,[SetType,face,Texture,repeats,<0,0,0>,0,
                                                    PRIM_COLOR,face,color,alpha]);
            }
        }
}
//debated using bitwise 100010 vs 1,3,4,5
//bitwises would use 5+ listwithdesc loops in most cases
//body+faces would send 5+ messages, with 1 listwithdesc loop each
//format color|body|1001010|color
//format color|body|faces♣faces♣faces|color


default
{
    state_entry()
    {
        init(); 
        llSetLinkPrimitiveParamsFast(llList2Integer(linkcache,15),[PRIM_ALPHA_MODE, ALL_SIDES,PRIM_ALPHA_MODE_MASK, 180,
                                        PRIM_ALPHA_MODE, 1,PRIM_ALPHA_MODE_BLEND,0,
                                        PRIM_ALPHA_MODE, 3,PRIM_ALPHA_MODE_BLEND,0,
                                        PRIM_ALPHA_MODE, 5,PRIM_ALPHA_MODE_BLEND,0,
                                        PRIM_ALPHA_MODE, 7,PRIM_ALPHA_MODE_BLEND,0
                                        ]);
                    
        llSetLinkPrimitiveParamsFast(llList2Integer(linkcache,16),[PRIM_ALPHA_MODE, ALL_SIDES,PRIM_ALPHA_MODE_MASK, 180,
                                        PRIM_ALPHA_MODE, 1,PRIM_ALPHA_MODE_BLEND,0,
                                        PRIM_ALPHA_MODE, 3,PRIM_ALPHA_MODE_BLEND,0]); 
    }
    changed(integer change)
    {
        if(change & CHANGED_LINK)
        {
            llOwnerSay("Link count has changed, updating links");
            init();
        }
    }

    listen(integer channel, string name, key id, string mess)
    {
        if(llGetOwnerKey(id) == llGetOwner())
        {
            list message = llParseString2List(mess,["|"],[""]);
            string command = llList2String(message,0);
            string link = llList2String(message,1);
            integer face = llList2Integer(message,2);
            string data = llList2String(message,3);
            

            if(command == "colormain")
            {//format colormain|<color>
                vector color = (vector)llList2String(message,1);
                //llOwnerSay((string)color);
                
                //using llsetcolor, so we dont have to read the alpha
                
                llSetColor(color,0);
                llSetColor(color,1);
            }
            else if(command == "colorcell")
            {//format colorcell|<color>
                //only sets the lips/nostrils otherwise
                vector color = (vector)llList2String(message,1);

                llSetColor(color,2);
                llSetColor(color,3);
                //remainder of cell is handled in diff script
            }
            else if(command == "fullbright")
            {//fullbright|apply
                llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_FULLBRIGHT,ALL_SIDES,face]);
            }
            else if(link == "19ears" || link == "19earscell")
            {
                if(command == "alpha")
                {//format alpha|link|face|apply
                list mirrors = getmirrors(llList2String(message,1),llList2String(message,2)); 
                
                integer i; 
                for(i=0;i<llGetListLength(mirrors);i++)
                {
                    face = llList2Integer(mirrors,i);
                    llSetLinkAlpha(LINK_THIS,(integer)data,face);
                }
                }
                else if(command == "texture")
                {
                    //format //format texture|body|face|type|uuid|color♦gloss♦env|scale|alpha
                    //-1 means all_sides
                    string link = llList2String(message,1);
                    string face = llList2String(message,2);
                    //data is type
                    string uuid = llList2String(message,4);
                    string extradata = llList2String(message,5);
                    vector repeats = (vector)llList2String(message,6);
                    float alpha = (float)llList2String(message,7);
                    
                    //loop not handled here, slightly less cpu to do inside function after processing line
                    //figure out mirroring
                    applytexture(link,face,data,uuid,extradata,repeats,alpha);
                }
            }
        }
    }
}

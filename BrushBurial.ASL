state("Brush Burial")
{
    
    short trigger : "UnityPlayer.dll", 0x0195AFD0, 0x38;
}  

startup{    
    refreshRate = 30;
    settings.Add("debug", false);
}

init
{    
    vars.logs = "bbasl_logs_v1.txt";
    vars.tempvar = false;

    vars.Setup = false;
    vars.Split = false;
    vars.Reset = false;
    vars.IsLoading = false;

    int[] splits = new int[]{ 
        //700  //PROLOGUE
        3000,  //ACT I
        5500,  //ACT II
        1500,  //BOSS FIGHT
        3000,  //ACT III
        0      //END SCREEN
    };

    vars.splits = splits;
    vars.splitx = 0;

}   

update
{
    //print(current.trigger.ToString()); //DEBUG PRINT
    if(old.trigger != current.trigger){
        if(settings["debug"]){
            File.AppendAllText(vars.logs, DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + ":trigger:" + current.trigger.ToString() + '\n');
        }
        if(current.trigger >= 700 && current.trigger < 800){
            vars.Setup = true;
            if(vars.IsLoading){
                vars.IsLoading = false;
                vars.Reset = true;
            }
            

        }
    }

    if (vars.Setup){
        if(old.trigger != current.trigger){
            if ((current.trigger >= vars.splits[vars.splitx]) && (current.trigger <= vars.splits[vars.splitx]+100)){
                vars.Split = true;
                vars.splitx++;
            }
            if(settings["debug"]){
                File.AppendAllText(vars.logs, DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + ":trigger:" + current.trigger.ToString() + '\n');
            }
        }





        if((current.trigger >= 300 && current.trigger < 400)){
            vars.Reset = true;
            vars.IsLoading = true;
            vars.tempvar = true;
            vars.Setup = false;
            vars.splitx = 0;
        }
    }
    
    else{
        if(vars.tempvar){
            vars.tempvar = false;
        }
        else{
            return false;
        }
    }
}

split{return vars.Split;}
onSplit{vars.Split = false;
    if(settings["debug"]){
        File.AppendAllText(vars.logs, DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")+":  :"+"SPLIT: split" + '\n');
    }
}

isLoading{return vars.IsLoading;}

reset{return vars.Reset;}
onReset{vars.Reset = false;
    if(settings["debug"]){
        File.AppendAllText(vars.logs, DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")+":  :"+"RESET: reset" + '\n');
    }
}

start{
    // print("yippee");
    return true;
    }

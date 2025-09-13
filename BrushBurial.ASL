state("Brush Burial")
{
    
    short trigger : "UnityPlayer.dll", 0x0195AFD0, 0x38;
}  

startup{    
    refreshRate = 30;
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
        3000,
        5500,
        1500,
        3000,
        0
    };

    vars.splits = splits;
    vars.splitx = 0;

}   

update
{
    //print(current.trigger.ToString());
    if(old.trigger != current.trigger){
        File.AppendAllText(vars.logs, DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + ":trigger:" + current.trigger.ToString() + '\n');
        if(current.trigger >= 720 && current.trigger < 730){
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
            
            File.AppendAllText(vars.logs, DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + ":trigger:" + current.trigger.ToString() + '\n');
        }





        if((current.trigger >= 300 && current.trigger < 400)){
            vars.Reset = true;
            vars.IsLoading = true;
            vars.tempvar = true;
            vars.Setup = false;
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
    File.AppendAllText(vars.logs, DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")+":  :"+"SPLIT: split" + '\n');
}

isLoading{return vars.IsLoading;}

reset{return vars.Reset;}
onReset{vars.Reset = false;
    File.AppendAllText(vars.logs, DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")+":  :"+"RESET: reset" + '\n');

}

start{
    // print("yippee");
    return true;
    }

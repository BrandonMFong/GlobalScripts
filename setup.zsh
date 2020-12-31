pushd "$(dirname "$0")"

    # copy profile 
    cp -f ./Profile.zsh ~/.zshrc;

    # Create Profile pointer 
    out=~/.profile.xml;
    if [ ! -f $out ] 
    then 
        touch $out;
    else 
        rm $out;
        touch $out;
    fi 
    GitRepoDir=$(pwd); # get the xPro directory 
    ConfigPath="${GitRepoDir}/Config/Users";

    # Configuration 
    # Asking if user wants to use or create
    # going to use Makito.xml as basis 
    
    # Have user choose if they want to create or use an existing config
    read -p "What do you want to do?\nCreate New Config[1]\nUse Existing Confg[2]\nSo" choice; # TODO read from app.json
    if [ $choice != "1" || $choice != "2" ] # if not 1 or 2 exit script
    then 
        exit 1; # return 1 
    else 
        # create new config 
        if [ $choice == "1" ]
        then 
            # create config file name
            read -p "Config File Name: " ConfigFile;
            ConfigFile="/${ConfigFile}.xml"; # config name 
            BaseConfig="/Makito.xml"; # TODO read from app.json 
            
            # Copy base config to new config 
            cp -f "${ConfigPath}${BaseConfig}" "${ConfigPath}${ConfigFile}";

        # Use existing config
        else 
            

        fi 

        # Keeping it in this if statement because I don't want to execute it if the user input something wrong 
        # Write to apppointer 
        # echo "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>" | tee -a $out;
        # echo "<Machine MachineName=\"KAMANTA\">" | tee -a $out;
        # echo "  <GitRepoDir>${GitRepoDir}</GitRepoDir>" | tee -a $out;
        # echo "  <ConfigFile>${ConfigFile}</ConfigFile>" | tee -a $out;
        # echo "</Machine>" | tee -a $out;
    fi

popd 
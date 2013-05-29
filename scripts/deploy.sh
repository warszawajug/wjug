#!/bin/bash
###############################################################
# procedures
###############################################################
startPrintingYellow() {
    echo -e "\e[01;33m"
    echo "================================================================================"
}

startPrintingRed() {
    echo -e "\e[00;31m"
    echo "================================================================================"
}

stopColloringEcho() {
    echo "================================================================================"
    echo -n -e '\e[00m'
}

verifyAnyChangesAreToBeCommitted() {
    gitCommitStatus=$(git status --porcelain)
    if [ "$gitCommitStatus" == "" ]; then
        startPrintingRed
            echo "Nothing new in here. Returning to master without a commit (including hard reset)."
        stopColloringEcho
        cleanAndReturnToMaster
        exit 1
    fi

    startPrintingYellow
        echo "Found changes to be committed."
    stopColloringEcho
    git status
}

cleanAndReturnToMaster() {
    git reset --hard
    git clean -f -x
    git checkout master
}

verifyEverythingIsCommited() {
    gitCommitStatus=$(git status --porcelain)
    if [ "$gitCommitStatus" != "" ]; then
        startPrintingRed
            echo "You have uncommited files."
            echo "Your git status:"
            echo $gitCommitStatus
            echo "Sorry. Rules are rules. Aborting!"
        stopColloringEcho
        exit 1
    fi
}

verifyEverythingIsPushedToOrigin() {
    gitPushStatus=$(git cherry -v)
    if [ "$gitPushStatus" != "" ]; then
        startPrintingRed
            echo "You have local commits that were NOT pushed."
            echo "Your 'git cherry -v' status:"
            echo $gitPushStatus
            echo "Sorry. Rules are rules. Aborting!"
        stopColloringEcho
        exit 1
    fi
}

printRules() {
    echo "-----------------------------------------------------------------------------------------------------------------"
    echo "RULES:"
    echo "1. You need to be in main git dir and on master."
    echo "2. You need to be up-to-date for master."
    echo "3. Commit, PULL and PUSH your changes before you deploy."
    echo "4. Enjoy. Or pray."
    echo "-----------------------------------------------------------------------------------------------------------------"
}

###############################################################
# work starts here
###############################################################

printRules

# sanity check
verifyEverythingIsCommited
verifyEverythingIsPushedToOrigin

# pull from master
git checkout master
git pull origin master
currentHashOnMaster=$(git rev-parse HEAD)

# fire up nodejs and generate _public
startPrintingYellow
    echo "> Firing up nodejs. Ctrl+c when generations is finished."
    echo "> (a pull request to automatize it would be welcome)"
stopColloringEcho

./scripts/server.sh

# checkout gh-pages
git checkout gh-pages
git pull origin gh-pages

# override content
cp -r -v ./_public/* ./

# if anything new
git add .
verifyAnyChangesAreToBeCommitted

# add & commit & push
echo "'autoupdate to $currentHashOnMaster '"
git commit -m "'autoupdate to $currentHashOnMaster '"
git push origin gh-pages

# checkout master
cleanAndReturnToMaster

startPrintingYellow
    echo "Update finished. Thank you for cooperation."
stopColloringEcho

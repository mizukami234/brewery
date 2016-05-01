ORDER=order.json

which jq
if [ $? -eq 1 ]; then
    echo "-- brewery requires jq --"
    brew install jq
fi

NORMAL_INSTALLS=`cat $ORDER | jq -r ".normal | .install[]"`
CASK_INSTALLS=`cat $ORDER | jq -r ".cask | .install[]"`

COL_SUCCESS="\033[32;1m"
COL_WARNING="\033[31;1m"
COL_END="\033[0;39m"

echo ""
echo "-- homebrew packages --"
for pkg in $NORMAL_INSTALLS
do
    brew ls -1 $pkg &> /dev/null
    if [ $? -eq 1 ]; then
        echo "${COL_WARNING}${pkg}${COL_END} is not installed."
        brew install $pkg
    else
        echo "${COL_SUCCESS}${pkg}${COL_END} has already been installed."
    fi
done

echo ""
echo "-- homebrew cask packages --"
for pkg in $CASK_INSTALLS
do
    brew cask ls -1 $pkg &> /dev/null
    if [ $? -eq 1 ]; then
        echo "${COL_WARNING}${pkg}${COL_END} is not installed."
        brew cask install $pkg
    else
        echo "${COL_SUCCESS}${pkg}${COL_END} has already been installed."
    fi
done

# put this script to /etc/profile.d/
# add "source /etc/profile" to users’.bash_profile file , for example:

##################################
# if [ -f ~/.bashrc ]; then      #
#         . ~/.bashrc            #
# fi                             #
# source /etc/profile            #
##################################

# mkdir /.trash
# chmod 1777 /.trash


alias rm=trash
alias lr='ls /.trash'
alias ur=undelfile

undelfile()
{
mv -i /.trash/$@ ./
}

trash()
{
mv $@ /.trash/
}

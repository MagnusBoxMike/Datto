# Datto RMM

These scripts have been created to work with Magnus Box and Datto RMM. We are posting the different scripts here to allow us to maintain version control and ease of accessibility.

Before implementing these scripts, please open a ticket by emailing support@magnusbox.com. You can put "Datto RMM" in the subject line. The reason for this is to allow us to setup the dedicated API user account on your Magnus Box server.

As always, never run a script without understanding how it works. You take full responsibility for running these scripts on your clients endpoints.
Interested in Magnus Box? Visit www.magnusbox.com for more information.

Looking for Syncro scripts? Check out our separate GitHub repository <a href="https://github.com/MagnusBoxMike/Syncro-Rmm">here</a>!

# Setting up in Datto RMM

These scripts require the use of variables setup in Datto RMM.

<strong>The required variables and are as follows</strong>

- mbapiuser - This variable will define the API Username that has been setup by support
- mbapipassword - This variable will define the API User Password that has been setup by support
- mbserver - This variable is the Magnus Box Server URL. Normally in the format of servername.ez-backup.net
- mbserverport - This variable is the Magnus Box Server Port used. This is default to 443 unless changed.
- mbappname - This variable is the name of the backup software as it appears on the machine. It will also reference the directory location on the machine.
- mbuser - This variable is used as the Magnus Box user setup on the server. 
- mbuserpassword - This variable is used as the Magnus Box user password setup on the server.
- mbuserdel - This variable is also used as the Magnus Box user setup on the server. However this variable is only used in the Delete User Script for Safety
- mbuserpassworddel - This variable is also used as the Magnus Box user setup on the server. However this variable is only used in the Delete User Script for Safety

For the best location on where to set these variables in Datto RMM please refer to each of the script, However this could be different in your environment. 

<br><br>










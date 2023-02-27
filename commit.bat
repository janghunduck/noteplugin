@echo off
set path=C:\Program Files\Git\bin


git add .

set /p str=Input description:
echo description: "%str%"
git commit -m "%str%"
git status

echo  ==================== git cconfig ==========================
git config --list


echo  ==================== git cconfig ==========================
git remote add origin https://github.com/janghunduck/noteplugin.git
echo master is this(³ë¿¹) so, change main.
git pull origin main
git push origin main

pause
…or create a new repository on the command line
echo "# mysqlER" >> README.md
git init
git add README.md
git commit -m "first commit"
git branch -M mysql
git remote add mysqlGit https://github.com/mikaody/mysqlER.git
git push -u mysqlGit mysql
…or push an existing repository from the command line
git remote add mysqlGit https://github.com/mikaody/mysqlER.git
git branch -M mysql
git push -u mysqlGit mysql

git add .
git commit -am "push"
git push -u mysqlGit mysql

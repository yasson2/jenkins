#install WGET
if ! [ -x "$(command -v wget)" ]; then
  sudo yum -y install wget
  exit 0
fi

#install GIT
if ! [ -x "$(command -v git)" ]; then
  sudo yum -y install git
  exit 0
fi

#install DOCKER
if ! [ -x "$(command -v docker)" ]; then
  sudo yum install -y docker
  sudo service docker start
  sudo docker run hello-world
  exit 0
fi


#install MySQL
if ! [ -x "$(command -v mysql)" ]; then
  sudo yum -y install mysql
  exit 0
fi
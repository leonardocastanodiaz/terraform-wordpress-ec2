env=`git branch | grep "*"|awk '{print $2}'`;
tf workspace new $env;
tf workspace select $env;
cd ../1-network;
tf workspace new $env;
tf workspace select $env;
cd ../2-ec2;
tf workspace new $env;
tf workspace select $env;
echo '### To create the new stack execute  tf apply --auto-approve && cd  ../1-network  && tf apply --auto-approve &&  cd ../2-ec2 && tf apply --auto-approve'
echo '### To delete the new stack execute  cd ../2-ec2 && tf destroy --auto-approve && cd  ../1-network  && tf destroy --auto-approve &&  cd ../0-elastic-ip  && tf destroy --auto-approve'



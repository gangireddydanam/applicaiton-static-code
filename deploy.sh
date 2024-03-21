echo "[>>>>>CI-Make a pkg]"
zip -r static-apache-$BUILD_NUMBER.zip *
aws s3 cp static-apache-$BUILD_NUMBER.zip s3://artifactory-files-devops/
sleep 3
rm -fr static-apache-$BUILD_NUMBER.zip
rm -fr *.html *.md
echo 
echo 
echo 
echo "[INFO] S3 files listed "
echo 
 aws s3 ls s3://artifactory-files-devops/
echo 

echo "[>>>>>CD-Deploy a pkg]"
aws s3 cp s3://artifactory-files-devops/static-apache-$BUILD_NUMBER.zip .
scp -i /tmp/eks-helm.pem static-apache-$BUILD_NUMBER.zip ec2-user@172.31.81.154:/tmp/
rm -fr *.zip
ssh -i /tmp/eks-helm.pem ec2-user@172.31.81.154 "ls -ltr /tmp"
ssh -i /tmp/eks-helm.pem ec2-user@172.31.81.154 "unzip /tmp/static-apache-*.zip -d /tmp/"
ssh -i /tmp/eks-helm.pem ec2-user@172.31.81.154 "ls -ltr /tmp"
ssh -i /tmp/eks-helm.pem ec2-user@172.31.81.154 "sudo rm -fr /var/www/html/*"
ssh -i /tmp/eks-helm.pem ec2-user@172.31.81.154 "sudo cp -r /tmp/*.html /var/www/html/"
ssh -i /tmp/eks-helm.pem ec2-user@172.31.81.154 "rm -fr /tmp/*.zip /tmp/*.html /tmp/*.md"
ssh -i /tmp/eks-helm.pem ec2-user@172.31.81.154 "ls -ltr /tmp"
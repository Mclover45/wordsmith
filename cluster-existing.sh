StateExisting=$(aws s3 ls s3://rbachkarou-kops | grep -o  wordsmith.rbachkarou.tl.scntl.com) 
    if [ $StateExisting == "wordsmith.rbachkarou.tl.scntl.com" ] 
    then 
        echo "yes" 
    else 
    kops validate cluster --wait 10m --state=s3://rbachkarou-kops
    fi


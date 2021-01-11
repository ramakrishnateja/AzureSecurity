# We have a new resource jon snow who is joining team to work as devops engineer
# and is primarily responsible for management of the kubernetes cluster

# Jon snow has requested access to the kubernetes cluster to perform his day to day operations

# As a first step lets create the user account. 
# We can run the below command to create Jon Snow in our active directory
$domainName = 'ramakrishnatejagmail.onmicrosoft.com'
$displayName = 'Jon Snow'
$userPrincipalName = 'jonsnow@'+$domainName
$subscriptionID = 'ab1a7875-684c-4793-a814-bbc20aa6a0e2'
# please change the password to a choice of yours before executing the script
$password = 'Iam@looser' #should have a special character and should be atleast 8 characters in length

az ad user create --display-name $displayName --password $password --user-principal-name $userPrincipalName

# Lets see how we can do the same through portal

# Lets try and login as Jon Snow and see what access he has to resources
# he logs in to portal and could not find the kubernetes cluster and pinged again to
# check with you if he was given permissions yet for the aks cluster named 'azsecurity'
# under subscription 'Pay-As-You-Go' and resource group 'udacity' which he has gathered from his colleagues or
# his onboarding document.

# we can now run the below command to provide Jon Snow access to the specified kubernetes resource
# follow this link for more options on how to assign the role and access

# Jon Snow has already specified the resource details which would become the scope for us 
# and we need to find the appropriate role that would give him just the accesss he would need and not more

# First add him as a reader to the current subscription
az role assignment create --assignee $userPrincipalName `
                --role 'Reader' `
                --subscription $subscriptionID

# lets check and see if he is able to get the necessary access to the resource

# lets assign him the needed role to give him proper access
az role assignment create --assignee $userPrincipalName `
                --role 'Azure Kubernetes Service Cluster Admin Role' `
                --scope "/subscriptions/$subscriptionId/resourcegroups/udacity/providers/Microsoft.ContainerService/managedClusters/azsecurity"

# why we need scoped access. Lets try and delete the cluster as Jon Snow
# lets try and delete the resource group as user Jon Snow.

@echo off
setlocal

set "REGION=us-east-1"
set "BUCKET=research-agent-tfstate-826149580160-mohdz-20261121"

echo Checking S3 bucket: %BUCKET% in %REGION%
aws s3api head-bucket --bucket "%BUCKET%" --region "%REGION%" 2>nul
if errorlevel 1 (
    aws s3api create-bucket --bucket "%BUCKET%" --region "%REGION%"
    if errorlevel 1 exit /b 1
)
aws s3api put-bucket-versioning --bucket "%BUCKET%" --region "%REGION%" --versioning-configuration Status=Enabled
if errorlevel 1 exit /b 1
aws s3api put-public-access-block --bucket "%BUCKET%" --region "%REGION%" --public-access-block-configuration BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true
if errorlevel 1 exit /b 1

echo Backend ready. Next: terraform -chdir=terraform init
endlocal & exit /b 0

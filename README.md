#Scripts for automating some techops tasks

##About this Mac
To get the same information shown in "About this Mac" on the command line:
```bash
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/pameck/mac-about-scripts/master/about_mac.rb)"
```

Export it to a file
```bash
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/pameck/mac-about-scripts/master/about_mac.rb)" > about_this_mac.txt
```

##Test this Mac
Runs connectivity, audio and other tests (just wifi atm!)
```bash
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/pameck/mac-about-scripts/master/test_mac.rb)"
```

Export it to a file
```bash
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/pameck/mac-about-scripts/master/test_mac.rb)" > test_this_mac.txt
```

##Upload information to an S3 bucktet
To upload the information shown in "About this Mac" to an S3 bucket:

1. Install the AWS SDK
`sudo gem install aws-sdk`

2. Copy this command to the computer's terminal, make sure you replace the s3_key and s3_secret values for the correct ones.
```bash
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/pameck/mac-about-scripts/master/to_garage_sale.rb)" -- --s3_key S3_USER_KEY --s3_secret S3_USER_SECRET
```
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
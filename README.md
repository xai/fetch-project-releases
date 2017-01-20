# fetch-project-releases
This is just to fetch java code samples from GitHub for research.  
We rely on tags because we consider the code to be more mature (read as: more likely to be syntactically correct).

## Note
This is an ugly proof of concept hack. See [TODO](#todo).

## Setup
You have to register an API token first!  
Please see [this](https://help.github.com/articles/creating-an-access-token-for-command-line-use/) on how to generate a token.

Also set CODE_BASE_DIR in the script to something meaningful.  
This is where the code is stored.

## Run
`$ TOKEN="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" ./get_java_projects.sh`

## Output
Releases are stored as tar.gz files in a file system hierarchy resembling githubs user/project structure.

Example output:
```
$ TOKEN=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ./get_java_projects.sh
Retrieving releases for: ReactiveX/RxJava (https://github.com/ReactiveX/RxJava)
storing release v2.0.4 as /tmp/src/ReactiveX/RxJava/v2.0.4.tar.gz
storing release v2.0.3 as /tmp/src/ReactiveX/RxJava/v2.0.3.tar.gz
storing release v2.0.2 as /tmp/src/ReactiveX/RxJava/v2.0.2.tar.gz
storing release v2.0.1 as /tmp/src/ReactiveX/RxJava/v2.0.1.tar.gz
storing release v2.0.0 as /tmp/src/ReactiveX/RxJava/v2.0.0.tar.gz
storing release v2.0.0-RC5 as /tmp/src/ReactiveX/RxJava/v2.0.0-RC5.tar.gz
storing release v2.0.0-RC4 as /tmp/src/ReactiveX/RxJava/v2.0.0-RC4.tar.gz
storing release v2.0.0-RC3 as /tmp/src/ReactiveX/RxJava/v2.0.0-RC3.tar.gz
storing release v2.0.0-RC1 as /tmp/src/ReactiveX/RxJava/v2.0.0-RC1.tar.gz
storing release v2.0.0-DP0 as /tmp/src/ReactiveX/RxJava/v2.0.0-DP0.tar.gz
storing release v1.2.5 as /tmp/src/ReactiveX/RxJava/v1.2.5.tar.gz
storing release v1.2.4 as /tmp/src/ReactiveX/RxJava/v1.2.4.tar.gz
storing release v1.2.3 as /tmp/src/ReactiveX/RxJava/v1.2.3.tar.gz
storing release v1.2.2 as /tmp/src/ReactiveX/RxJava/v1.2.2.tar.gz
storing release v1.2.1 as /tmp/src/ReactiveX/RxJava/v1.2.1.tar.gz
storing release v1.2.0 as /tmp/src/ReactiveX/RxJava/v1.2.0.tar.gz
storing release v1.1.10 as /tmp/src/ReactiveX/RxJava/v1.1.10.tar.gz
storing release v1.1.9 as /tmp/src/ReactiveX/RxJava/v1.1.9.tar.gz
storing release v1.1.8 as /tmp/src/ReactiveX/RxJava/v1.1.8.tar.gz
storing release v1.1.7 as /tmp/src/ReactiveX/RxJava/v1.1.7.tar.gz
storing release v1.1.6 as /tmp/src/ReactiveX/RxJava/v1.1.6.tar.gz
...
```

## TODO
- [ ] [reimplement this in python by using a proper json parser instead of banging the output with sed](/../../issues/4)
- [x] [use pagination to retrieve more than 30 projects](/../../issues/1)
- [x] [use arg parser to provide target directory via command line argument](/../../issues/2)
- [ ] [prune non-java files from repository](/../../issues/3)
- [ ] create a pull request that resolves all the todos (I'll happily pull) :)

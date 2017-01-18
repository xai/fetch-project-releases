# fetch-project-releases
This is just to fetch java code samples for research.
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

## TODO
- use pagination to retrieve more than 30 projects
- use opt arg parser to provide target directory via command line argument
- reimplement this in python by using a proper json parser
- create a pull request that resolves all the todos :)

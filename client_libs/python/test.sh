export PATH=../../bin/:$PATH
. virtualenv/bin/activate
python -m unittest discover -s test -p '*_test.py'

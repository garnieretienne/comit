== Testing

Clone the comit-test repository (in comit/tmp/) before : git clone git://github.com/garnieretienne/comit-test.git
Copy it : cp -r tmp/comit-test tmp/test
Copy it : cp -r tmp/comit-test tmp/erased
Clone this repository in project/repositories/test: cd comit/repositories/ && git clone ../tmp/test test
Clone this repository in project/repositories/erased: cd comit/repositories/ && git clone ../tmp/erased erased
Remove 'erased' git repo: rm -rf tmp/erased/